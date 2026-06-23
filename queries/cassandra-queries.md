# CityFlow — Cassandra Queries
## Keyspace : `cityflow` | Cluster : CityFlow v4.1.11

---

## US-C1 — Historique des passages d'une station sur une période

> En tant qu'analyste, je veux retrouver l'historique des passages d'une station spécifique sur une période donnée.

**Table utilisée :** `cityflow.station_passages`
**Partition key :** `(station_id, day)` — une partition = 1 station × 1 jour

Une partition couvre 1 jour. Pour une période de 7 jours, on utilise `IN` sur `day` :

```cql
-- Historique de la station Part-Dieu sur la semaine du 15/09
SELECT station_id, passage_time, user_id, event_type
FROM cityflow.station_passages
WHERE station_id = 'S001'
AND day IN ('2025-09-15','2025-09-16','2025-09-17',
            '2025-09-18','2025-09-19','2025-09-20','2025-09-21');
```

**Alternative pour de meilleures performances (requêtes parallèles) :**
```cql
-- Une requête par jour, exécutées en parallèle côté application
SELECT * FROM cityflow.station_passages WHERE station_id = 'S001' AND day = '2025-09-15';
SELECT * FROM cityflow.station_passages WHERE station_id = 'S001' AND day = '2025-09-16';
-- ... x7
```

**Justification :** `IN` interroge 7 partitions sur potentiellement 7 nœuds différents.
Pour 15 stations × 7 jours = 105 partitions max. Raisonnable.

---

## US-C2 — Encaisser plusieurs milliers d'écritures par minute

> En tant que système, je veux pouvoir enregistrer plusieurs milliers d'événements de passage par minute sans dégradation.

**Démonstration :** 100 insertions en boucle via cqlsh

```cql
-- Exécuter dans cqlsh — mesurer le temps total
-- Commande shell pour mesurer :
-- time cqlsh -f /chemin/vers/100_inserts.cql

-- Exemple de 5 insertions rapides (pattern à répéter x100) :
BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S001', '2025-09-21', '2025-09-21 10:00:01', 'user_001', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_001', '2025-09-21', '2025-09-21 10:00:01', 'S001', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S002', '2025-09-21', '2025-09-21 10:00:02', 'user_002', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_002', '2025-09-21', '2025-09-21 10:00:02', 'S002', 'rent');
APPLY BATCH;
```

**Résultat observé :** Cassandra encaisse sans dégradation — architecture optimisée pour les écritures massives (LSM-Tree, pas de verrou en écriture).

**Pourquoi Cassandra est adaptée à US-C2 :**
- Écriture = append dans une MemTable → flush en SSTable (séquentiel, ultra-rapide)
- Pas de master → pas de goulot d'étranglement
- Scalabilité horizontale linéaire : doubler le cluster = doubler le débit

---

## US-C3 — Audit utilisateur sur 30 jours (RGPD)

> En tant qu'utilisateur, je veux consulter mes propres connexions des 30 derniers jours.

**Table utilisée :** `cityflow.user_passages`
**Partition key :** `(user_id)` — 1 utilisateur = 1 partition

```cql
-- Tous les passages d'un utilisateur (toutes dates)
SELECT day, passage_time, station_id, event_type
FROM cityflow.user_passages
WHERE user_id = 'user_001'
ORDER BY day DESC;

-- Filtré sur les 30 derniers jours
SELECT day, passage_time, station_id, event_type
FROM cityflow.user_passages
WHERE user_id = 'user_001'
AND day >= '2025-08-22'
AND day <= '2025-09-21';

-- Limité aux 30 derniers passages
SELECT day, passage_time, station_id, event_type
FROM cityflow.user_passages
WHERE user_id = 'user_001'
LIMIT 30;
```

**Partitions touchées :** 1 seule partition par utilisateur.
La requête cible directement 1 nœud — O(1) en localisation, lecture séquentielle.

**Taille max de partition :**
- 1 utilisateur actif : ~10 passages/jour × 30j = 300 lignes/mois
- Très raisonnable, jamais de risque de partition trop grande

---

## US-C4 — Évolution journalière du nombre de passages

> En tant qu'analyste, je veux obtenir l'évolution journalière du nombre de passages pour identifier les pics d'affluence.

**Table utilisée :** `cityflow.daily_station_stats` (type counter)
**Partition key :** `station_id` | **Clustering key :** `day ASC`

```cql
-- Évolution sur 7 jours pour la station Part-Dieu
SELECT station_id, day, total_passages
FROM cityflow.daily_station_stats
WHERE station_id = 'S001';

-- Toutes les stations pour un jour donné (nécessite ALLOW FILTERING — usage limité)
SELECT station_id, day, total_passages
FROM cityflow.daily_station_stats
WHERE day = '2025-09-15'
ALLOW FILTERING;

-- Top stations par nombre de passages le 15/09 (requête sur plusieurs stations)
SELECT station_id, total_passages
FROM cityflow.daily_station_stats
WHERE station_id IN ('S001','S002','S003','S004','S005',
                     'S006','S007','S008','S009','S010',
                     'S011','S012','S013','S014','S015')
AND day = '2025-09-15';
```

**Une seule requête suffit** pour l'évolution d'une station :
- Clustering key `day ASC` → résultats triés chronologiquement
- Lecture séquentielle d'une partition = ultra-rapide

---

## Résumé des tables par US

| User Story | Table | Partition Key | Clustering Key |
|---|---|---|---|
| US-C1 | station_passages | (station_id, day) | passage_time DESC |
| US-C2 | station_passages + user_passages | (station_id, day) / (user_id) | passage_time DESC |
| US-C3 | user_passages | (user_id) | day DESC, passage_time DESC |
| US-C4 | daily_station_stats | station_id | day ASC |
