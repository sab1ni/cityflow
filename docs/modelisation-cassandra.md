# CityFlow — Modélisation Cassandra
**Keyspace :** `cityflow` | **Cluster :** CityFlow v4.1.11 | **DC :** dc1

---

## 1. Keyspace

```cql
CREATE KEYSPACE IF NOT EXISTS cityflow
WITH replication = {
    'class': 'SimpleStrategy',
    'replication_factor': 1
};
```

`SimpleStrategy` avec `replication_factor: 1` pour l'environnement local mono-nœud.
En production : `NetworkTopologyStrategy` avec `replication_factor: 3` par datacenter.

---

## 2. Tables et justifications

### Table : `station_passages`
**Répond à :** US-C1, US-C2

```cql
CREATE TABLE IF NOT EXISTS cityflow.station_passages (
    station_id   text,
    day          date,
    passage_time timestamp,
    user_id      text,
    event_type   text,
    PRIMARY KEY ((station_id, day), passage_time)
) WITH CLUSTERING ORDER BY (passage_time DESC);
```

| Élément | Valeur | Justification |
|---|---|---|
| Partition key | `(station_id, day)` | Bucketing par jour — évite les partitions infinies |
| Clustering key | `passage_time DESC` | Passages récents en tête, LIMIT n ultra-rapide |
| Taille max partition | ~30 passages/jour/station | Très raisonnable, jamais > 1 MB |
| Requête servie | WHERE station_id = ? AND day = ? | US-C1 : historique station |

---

### Table : `user_passages`
**Répond à :** US-C2, US-C3

```cql
CREATE TABLE IF NOT EXISTS cityflow.user_passages (
    user_id      text,
    day          date,
    passage_time timestamp,
    station_id   text,
    event_type   text,
    PRIMARY KEY ((user_id), day, passage_time)
) WITH CLUSTERING ORDER BY (day DESC, passage_time DESC);
```

| Élément | Valeur | Justification |
|---|---|---|
| Partition key | `(user_id)` | 1 utilisateur = 1 partition, accès direct |
| Clustering key | `day DESC, passage_time DESC` | Historique chronologique inversé |
| Taille max partition | ~300 lignes/mois/utilisateur | Négligeable |
| Requête servie | WHERE user_id = ? AND day >= ? | US-C3 : audit RGPD |

**Duplication assumée :** chaque passage est écrit dans `station_passages` ET `user_passages`.
C'est volontaire — le stockage est bon marché, la performance de lecture est prioritaire.

---

### Table : `daily_station_stats`
**Répond à :** US-C4

```cql
CREATE TABLE IF NOT EXISTS cityflow.daily_station_stats (
    station_id     text,
    day            date,
    total_passages counter,
    PRIMARY KEY (station_id, day)
);
```

| Élément | Valeur | Justification |
|---|---|---|
| Partition key | `station_id` | Toutes les stats d'une station sur le même nœud |
| Clustering key | `day ASC` | Évolution chronologique en une seule requête |
| Type | counter | Incrément atomique, conçu pour les écritures massives |
| Requête servie | WHERE station_id = ? | US-C4 : évolution journalière |

---

### Table : `hourly_station_stats`
**Répond à :** US-C4 (granularité fine)

```cql
CREATE TABLE IF NOT EXISTS cityflow.hourly_station_stats (
    station_id     text,
    day            date,
    hour           int,
    total_passages counter,
    PRIMARY KEY ((station_id, day), hour)
);
```

| Élément | Valeur | Justification |
|---|---|---|
| Partition key | `(station_id, day)` | Bucketing par jour |
| Clustering key | `hour` | Détail par heure pour identifier les pics |
| Requête servie | WHERE station_id = ? AND day = ? | Pic d'affluence horaire |

---

## 3. Schéma complet des tables

```
station_passages        user_passages
──────────────────      ──────────────────
(station_id, day)  PK   (user_id)       PK
 passage_time      CK    day            CK
 user_id                 passage_time   CK
 event_type              station_id
                         event_type

daily_station_stats     hourly_station_stats
───────────────────     ────────────────────
 station_id        PK   (station_id, day)  PK
 day               CK    hour             CK
 total_passages ⊕       total_passages  ⊕

⊕ = type counter
```

---

## 4. Principe de synchronisation des tables

À chaque nouveau passage, l'application effectue **2 opérations** :

```cql
-- Op 1 : BATCH normal (inserts)
BEGIN BATCH
  INSERT INTO cityflow.station_passages (...) VALUES (...);
  INSERT INTO cityflow.user_passages (...) VALUES (...);
APPLY BATCH;

-- Op 2 : COUNTER BATCH (compteurs)
BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats
    SET total_passages = total_passages + 1
    WHERE station_id = ? AND day = ?;
APPLY BATCH;
```

**Note :** counter et non-counter ne peuvent pas coexister dans le même BATCH.
C'est une contrainte Cassandra qui impose deux appels séparés.

---

## 5. Jeu de données (seed)

| Dimension | Valeur |
|---|---|
| Stations | 15 (S001 Part-Dieu → S015 Gerland) |
| Utilisateurs | 30 (user_001 → user_030) |
| Passages | 200 répartis sur 7 jours |
| Période | 15/09/2025 → 21/09/2025 |
| Event types | rent / return |

**Stations lyonnaises :**
S001 Part-Dieu, S002 Bellecour, S003 Perrache, S004 Vieux-Lyon, S005 Confluence,
S006 Guillotière, S007 Saxe-Gambetta, S008 Charpennes, S009 Vaulx-en-Velin,
S010 Villeurbanne, S011 Vénissieux, S012 Bron, S013 Caluire, S014 Écully, S015 Gerland

---

## 6. Anti-patterns évités

| Anti-pattern | Ce qu'on a fait à la place |
|---|---|
| `PRIMARY KEY (station_id, timestamp)` sans bucketing | Ajout de `day` dans la partition key |
| `ALLOW FILTERING` pour filtrer par user | Table dédiée `user_passages` |
| Counter dans BEGIN BATCH normal | `BEGIN COUNTER BATCH` séparé |
| GROUP BY pour les stats | Tables de compteurs pré-agrégés |
