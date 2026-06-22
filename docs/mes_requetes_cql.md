# TP Cassandra — Requêtes CQL & Modélisation
**Projet CityFlow — Keyspace : `cityflow`**

---

## Partie 5 — Exercices de modélisation

> Pour chaque exercice : on liste les requêtes applicatives, on conçoit la table adaptée, on justifie les choix de PRIMARY KEY.

---

### Exercice 1 — IoT capteurs météo

**Contexte** : 5 000 capteurs, 1 mesure/minute, colonnes : `sensor_id`, `region`, `timestamp`, `temperature`, `humidity`, `pressure`.

**Volume estimé** : 5 000 × 60 × 24 × 365 = **2,6 milliards de mesures/an**

---

#### Analyse du mauvais choix (bonus demandé par le TP)

**Requête (mauvaise modélisation)**
```sql
CREATE TABLE sensor_bad (
    sensor_id  text,
    timestamp  timestamp,
    temperature float,
    humidity    float,
    pressure    float,
    PRIMARY KEY (sensor_id, timestamp)
);
```

**Réponse (ce qui se passe)**
```
-- La table fonctionne en dev, mais :
-- 1 capteur × 60 mesures/h × 24h × 365j = 525 600 lignes/an dans 1 partition
-- 5 000 capteurs × 525 600 = 2,6 milliards de lignes dans 5 000 partitions
-- Certaines partitions dépassent 100 MB → timeout en production
```

**Justification**
Sans bucketing temporel, une partition grossit indéfiniment. Au bout d'un an, une partition = 525 600 lignes. C'est l'anti-pattern "partition qui grossit indéfiniment" décrit en Partie 8.

---

#### Q1 — Historique d'un capteur sur un mois

**Requête**
```sql
CREATE TABLE sensor_history_by_month (
    sensor_id   text,
    month       text,
    timestamp   timestamp,
    temperature float,
    humidity    float,
    pressure    float,
    PRIMARY KEY ((sensor_id, month), timestamp)
) WITH CLUSTERING ORDER BY (timestamp DESC);

-- Requête applicative :
SELECT * FROM sensor_history_by_month
WHERE sensor_id = 'C001' AND month = '2025-09';
```

**Réponse**
```
 sensor_id | month   | timestamp                  | temperature | humidity | pressure
-----------+---------+----------------------------+-------------+----------+----------
 C001      | 2025-09 | 2025-09-30 23:59:00.000000 |        18.2 |     72.1 |   1013.2
 C001      | 2025-09 | 2025-09-30 23:58:00.000000 |        18.1 |     72.3 |   1013.1
 ...
(43 200 lignes max par partition — 60 × 24 × 30)
```

**Justification**
- **Partition key** `(sensor_id, month)` : bucketing par mois, une partition = max 43 200 lignes (60 mesures/h × 24h × 30j). Raisonnable, borné.
- **Clustering key** `timestamp DESC` : les mesures les plus récentes en tête, `LIMIT n` ultra-rapide.
- Le mois est un bon compromis : ni trop fin (jour = 1 440 lignes, trop de partitions), ni trop large (année = 525 000 lignes, trop gros).

---

#### Q2 — Les 10 dernières mesures d'un capteur

**Requête**
```sql
-- Même table que Q1, même partition key
SELECT * FROM sensor_history_by_month
WHERE sensor_id = 'C001' AND month = '2025-09'
LIMIT 10;
```

**Réponse**
```
 sensor_id | month   | timestamp                  | temperature | humidity | pressure
-----------+---------+----------------------------+-------------+----------+----------
 C001      | 2025-09 | 2025-09-30 23:59:00.000000 |        18.2 |     72.1 |   1013.2
 C001      | 2025-09 | 2025-09-30 23:58:00.000000 |        18.1 |     72.3 |   1013.1
 ... (10 lignes)
```

**Justification**
Grâce au `CLUSTERING ORDER BY (timestamp DESC)`, les 10 mesures les plus récentes sont physiquement en tête de partition. `LIMIT 10` = lecture séquentielle de 10 lignes, O(1). Pas de tri à la volée, pas de scan. C'est exactement pour ça que le tri physique est défini à la création de la table.

---

#### Q3 — Toutes les mesures d'une journée pour une région

**Requête**
```sql
-- Table dédiée : partition key différente
CREATE TABLE sensor_history_by_region_day (
    region      text,
    day         date,
    timestamp   timestamp,
    sensor_id   text,
    temperature float,
    humidity    float,
    pressure    float,
    PRIMARY KEY ((region, day), timestamp, sensor_id)
) WITH CLUSTERING ORDER BY (timestamp DESC, sensor_id ASC);

-- Requête applicative :
SELECT * FROM sensor_history_by_region_day
WHERE region = 'Auvergne-Rhone-Alpes' AND day = '2025-09-15';
```

**Réponse**
```
 region                 | day        | timestamp                  | sensor_id | temperature
------------------------+------------+----------------------------+-----------+-------------
 Auvergne-Rhone-Alpes   | 2025-09-15 | 2025-09-15 23:59:00.000000 | C042      |        12.1
 Auvergne-Rhone-Alpes   | 2025-09-15 | 2025-09-15 23:59:00.000000 | C107      |        11.8
 ...
```

**Justification**
- Q3 filtre par région et par jour — c'est une requête d'accès différente de Q1/Q2 → table dédiée (query-first design).
- **Partition key** `(region, day)` : toutes les mesures d'une région un jour donné sur le même nœud. Bucketing par jour évite la croissance infinie.
- **Clustering key** `(timestamp, sensor_id)` : `sensor_id` en deuxième clustering key garantit l'unicité quand deux capteurs envoient une mesure à la même seconde.
- Duplication assumée : chaque mesure est écrite dans les deux tables.

---

### Exercice 2 — Réseau social messages

**Contexte** : messages privés entre 2 utilisateurs, des centaines voire milliers de messages par conversation.

---

#### Q1 — Messages d'une conversation, du plus récent au plus ancien

**Requête**
```sql
CREATE TABLE messages_by_conversation (
    conversation_id uuid,
    sent_at         timestamp,
    sender_id       text,
    content         text,
    PRIMARY KEY (conversation_id, sent_at)
) WITH CLUSTERING ORDER BY (sent_at DESC);

-- Requête applicative :
SELECT * FROM messages_by_conversation
WHERE conversation_id = <uuid>
LIMIT 20;
```

**Réponse**
```
 conversation_id | sent_at                    | content              | sender_id
-----------------+----------------------------+----------------------+-----------
 <uuid>          | 2025-09-20 14:32:00.000000 | À demain !           | user_alice
 <uuid>          | 2025-09-20 14:31:00.000000 | Ok super             | user_bob
 <uuid>          | 2025-09-20 14:30:00.000000 | On se retrouve à 18h | user_alice
 ...
```

**Justification**
- **Partition key** `conversation_id` : tous les messages d'une conversation sur le même nœud. Un UUID dédié par conversation est préférable à une convention `user1_id < user2_id` (plus robuste aux groupes, plus simple).
- **Clustering key** `sent_at DESC` : messages triés du plus récent au plus ancien, pagination avec `LIMIT` + `AND sent_at < <dernier_vu>`.
- Pas de bucketing temporel ici car une conversation a rarement des millions de messages. Si besoin (chat très actif), on peut bucketer par mois.

---

#### Q2 — Conversations actives d'un utilisateur

**Requête**
```sql
CREATE TABLE conversations_by_user (
    user_id             text,
    last_message_at     timestamp,
    conversation_id     uuid,
    other_user_id       text,
    last_message_preview text,
    PRIMARY KEY (user_id, last_message_at, conversation_id)
) WITH CLUSTERING ORDER BY (last_message_at DESC, conversation_id ASC);

-- Requête applicative :
SELECT * FROM conversations_by_user
WHERE user_id = 'user_alice'
LIMIT 10;
```

**Réponse**
```
 user_id    | last_message_at            | conversation_id | other_user_id | last_message_preview
------------+----------------------------+-----------------+---------------+---------------------
 user_alice | 2025-09-20 14:32:00.000000 | <uuid>          | user_bob      | À demain !
 user_alice | 2025-09-19 09:10:00.000000 | <uuid>          | user_carol    | Tu as vu le match ?
 ...
```

**Justification**
- **Partition key** `user_id` : toutes les conversations d'un utilisateur sur le même nœud.
- **Clustering key** `last_message_at DESC` : les conversations les plus récentes en tête, `LIMIT 10` retourne les 10 dernières actives sans tri.
- `conversation_id` en deuxième clustering key garantit l'unicité si deux conversations ont le même timestamp.
- Duplication : quand un message est envoyé, on met à jour `conversations_by_user` pour les deux participants.

---

#### Q3 — Recherche par mot-clé (pourquoi Cassandra n'est pas adaptée)

**Requête**
```sql
-- Tentative naïve
SELECT * FROM messages_by_conversation
WHERE content LIKE '%bonjour%' ALLOW FILTERING;
```

**Réponse**
```
InvalidRequest: LIKE restrictions are not supported on table messages_by_conversation
```

**Justification**
Cassandra ne supporte pas la recherche full-text. `LIKE` n'existe pas en CQL. Même avec `ALLOW FILTERING`, un scan de toutes les partitions de tous les nœuds serait nécessaire — catastrophique à l'échelle. La solution adaptée est **Elasticsearch** (ou OpenSearch) : indexé séparément, synchronisé avec Cassandra via un pipeline (Kafka, Spark, ou Logstash). Cassandra stocke la source de vérité, Elasticsearch répond aux recherches full-text.

---

### Exercice 3 — E-commerce logs de visites

**Contexte** : 100 000 produits, 1 million de visites/jour, répartition inégale (certains produits : 50 000 vues/jour).

---

#### Q1 — Visites d'un produit sur la dernière semaine (gestion des hot spots)

**Requête**
```sql
CREATE TABLE product_visits_by_day (
    product_id  text,
    day         date,
    visited_at  timestamp,
    user_id     text,
    session_id  uuid,
    PRIMARY KEY ((product_id, day), visited_at)
) WITH CLUSTERING ORDER BY (visited_at DESC);

-- Requête pour 7 jours :
SELECT * FROM product_visits_by_day
WHERE product_id = 'P001'
AND day IN ('2025-09-14', '2025-09-15', '2025-09-16',
            '2025-09-17', '2025-09-18', '2025-09-19', '2025-09-20');
```

**Réponse**
```
 product_id | day        | visited_at                 | user_id   | session_id
------------+------------+----------------------------+-----------+-----------
 P001       | 2025-09-20 | 2025-09-20 23:58:00.000000 | user_4521 | <uuid>
 P001       | 2025-09-20 | 2025-09-20 23:57:00.000000 | user_0891 | <uuid>
 ...
(max 50 000 lignes par partition pour un produit star — acceptable)
```

**Justification**
- **Risque hot spot** : sans bucketing, un produit star avec 50 000 vues/jour × 365 = 18 millions de lignes dans 1 partition. Problématique.
- **Solution bucketing par jour** : une partition = max 50 000 lignes (1 jour). Raisonnable et borné.
- Pour 7 jours : `IN` sur `day` interroge 7 partitions. Alternative : 7 requêtes parallèles côté application pour de meilleures performances.

---

#### Q2 — Top 10 produits les plus visités (pourquoi Cassandra n'est pas adaptée)

**Requête (ce qui ne marche pas)**
```sql
SELECT product_id, COUNT(*) FROM product_visits_by_day
WHERE day = '2025-09-20'
GROUP BY product_id;
```

**Réponse**
```
InvalidRequest: Group by is not supported on this table
-- ou scan de 100 000 partitions différentes si ALLOW FILTERING
```

**Justification**
Un top 10 nécessite d'agréger toutes les partitions de tous les produits — exactement ce que Cassandra refuse de faire efficacement. Trois solutions :
- **Redis Sorted Set** : `ZINCRBY visits:2025-09-20 1 P001` à chaque visite, `ZREVRANGE` pour le top 10 — idéal pour les classements temps réel.
- **Pré-agrégation en écriture** : table counter `product_visit_counts (day, product_id, total counter)` mise à jour à chaque visite, et une tâche batch qui calcule le top 10.
- **Apache Spark** + connecteur DataStax : traitement analytique distribué sur les données Cassandra, mais hors temps réel.

---

#### Q3 — Visites d'un utilisateur (audit RGPD)

**Requête**
```sql
CREATE TABLE user_visits_by_month (
    user_id    text,
    month      text,
    visited_at timestamp,
    product_id text,
    session_id uuid,
    PRIMARY KEY ((user_id, month), visited_at)
) WITH CLUSTERING ORDER BY (visited_at DESC);

-- Requête applicative (30 derniers jours = 1 ou 2 mois) :
SELECT * FROM user_visits_by_month
WHERE user_id = 'user_4521' AND month = '2025-09';
```

**Réponse**
```
 user_id   | month   | visited_at                 | product_id | session_id
-----------+---------+----------------------------+------------+-----------
 user_4521 | 2025-09 | 2025-09-20 14:22:00.000000 | P0042      | <uuid>
 user_4521 | 2025-09 | 2025-09-20 11:05:00.000000 | P1337      | <uuid>
 ...
```

**Justification**
- **Partition key** `(user_id, month)` : bucketing par mois. Un utilisateur actif avec 50 visites/jour × 30j = 1 500 lignes/partition — très raisonnable.
- **Clustering key** `visited_at DESC` : chronologie inversée, les visites récentes en tête.
- Pour les 30 derniers jours à cheval sur 2 mois, on fait deux requêtes (mois courant + mois précédent) et on fusionne côté application.
- Cette table répond à l'obligation RGPD de fournir l'historique complet d'un utilisateur sur demande.

---

## Partie 6 — Observation des contraintes CQL

### Contrainte 1 : filtre sur colonne hors PRIMARY KEY

**Requête**
```sql
SELECT * FROM tp_cassandra.users WHERE age > 25;
```

**Réponse**
```
InvalidRequest: Cannot execute this query as it might involve data filtering
and thus may have unpredictable performance. If you want to execute this query
despite the performance unpredictability, use ALLOW FILTERING
```

**Justification**
La colonne `age` ne fait pas partie de la `PRIMARY KEY`. Cassandra ne sait pas sur quel nœud chercher les données sans la partition key — elle refuse donc d'effectuer un scan complet du cluster. C'est le principe du query-first design : la table doit être conçue en fonction des requêtes, pas l'inverse.

---

### Contrainte 2 : ALLOW FILTERING (anti-pattern)

**Requête**
```sql
SELECT * FROM tp_cassandra.users WHERE age > 25 ALLOW FILTERING;
```

**Réponse**
```
 user_id | age | city         | email             | first_name | last_name | tags
---------+-----+--------------+-------------------+------------+-----------+------------------
 <uuid>  |  28 | Lyon         | alice@example.com | Alice      | Dupont    | {'fr', 'premium'}
 <uuid>  |  32 | Villeurbanne | bob@example.com   | Bob        | Martin    | {'newbie'}
```

**Justification**
`ALLOW FILTERING` force Cassandra à scanner l'intégralité de la table sur tous les nœuds. En développement sur quelques lignes ça fonctionne. En production sur des millions de lignes c'est catastrophique (latences, surcharge cluster). C'est un anti-pattern à éviter absolument.

---

### Contrainte 3 : partition key incomplète

**Requête**
```sql
SELECT * FROM cityflow.station_passages WHERE station_id = 'S001';
```

**Réponse**
```
InvalidRequest: Cannot execute this query as it might involve data filtering...
```

**Justification**
La partition key de `station_passages` est composée de `(station_id, day)`. Fournir uniquement `station_id` est insuffisant : Cassandra ne peut pas localiser la partition sans les deux composantes. Il faut toujours fournir la partition key complète.

---

## Partie 7 — Requêtes CQL à produire

### Niveau 1 — SELECT basiques

#### Requête 1 : passages de S002 le 15/09/2025

**Requête**
```sql
SELECT * FROM cityflow.station_passages
WHERE station_id = 'S002' AND day = '2025-09-15';
```

**Réponse**
```
 station_id | day        | passage_time               | event_type | user_id
------------+------------+----------------------------+------------+---------
 S002       | 2025-09-15 | 2025-09-15 10:00:00.000000 | rent       | user_77
 S002       | 2025-09-15 | 2025-09-15 09:00:00.000000 | rent       | user_03
```

**Justification**
La partition key `(station_id, day)` est fournie complètement. Cassandra localise directement le nœud cible et retourne les lignes triées par `passage_time DESC` (défini dans le `CLUSTERING ORDER BY`).

---

#### Requête 2 : 3 derniers passages de S001 le 15/09/2025

**Requête**
```sql
SELECT * FROM cityflow.station_passages
WHERE station_id = 'S001' AND day = '2025-09-15'
LIMIT 3;
```

**Réponse**
```
 station_id | day        | passage_time               | event_type | user_id
------------+------------+----------------------------+------------+---------
 S001       | 2025-09-15 | 2025-09-15 17:20:00.000000 | return     | user_42
 S001       | 2025-09-15 | 2025-09-15 09:45:00.000000 | rent       | user_55
 S001       | 2025-09-15 | 2025-09-15 08:30:00.000000 | rent       | user_02
```

**Justification**
Grâce au `CLUSTERING ORDER BY (passage_time DESC)`, les lignes sont physiquement stockées du plus récent au plus ancien. `LIMIT 3` lit séquentiellement les 3 premières lignes de la partition — opération O(1), pas de tri à la volée.

---

#### Requête 3 : passages entre 9h et 18h

**Requête**
```sql
SELECT * FROM cityflow.station_passages
WHERE station_id = 'S001' AND day = '2025-09-15'
AND passage_time >= '2025-09-15 09:00:00'
AND passage_time < '2025-09-15 18:00:00';
```

**Réponse**
```
 station_id | day        | passage_time               | event_type | user_id
------------+------------+----------------------------+------------+---------
 S001       | 2025-09-15 | 2025-09-15 17:20:00.000000 | return     | user_42
 S001       | 2025-09-15 | 2025-09-15 09:45:00.000000 | rent       | user_55
```

**Justification**
Les filtres sur la clustering key (`passage_time`) sont autorisés dès lors que la partition key est complète. Cassandra effectue une lecture séquentielle dans la plage demandée — très efficace car les données sont déjà triées sur le disque.

---

#### Requête 4 : compter les passages d'une station un jour donné

**Requête**
```sql
SELECT COUNT(*) FROM cityflow.station_passages
WHERE station_id = 'S001' AND day = '2025-09-15';
```

**Réponse**
```
 count
-------
     4
```

**Justification**
`COUNT(*)` est autorisé dans une partition. Cassandra lit séquentiellement toutes les lignes de la partition et retourne le total. Cette agrégation reste locale à un seul nœud — c'est performant.

---

### Niveau 2 — Requêtes sur `user_passages`

#### Requête 5 : tous les passages d'un utilisateur

**Requête**
```sql
SELECT * FROM cityflow.user_passages
WHERE user_id = 'user_01';
```

**Réponse**
```
 user_id | day        | passage_time               | event_type | station_id
---------+------------+----------------------------+------------+------------
 user_01 | 2025-09-18 | 2025-09-18 10:00:00.000000 | return     | S002
 user_01 | 2025-09-16 | 2025-09-16 12:30:00.000000 | rent       | S005
 user_01 | 2025-09-16 | 2025-09-16 07:15:00.000000 | rent       | S001
 user_01 | 2025-09-15 | 2025-09-15 10:15:00.000000 | return     | S002
 user_01 | 2025-09-15 | 2025-09-15 07:10:00.000000 | rent       | S001
```

**Justification**
La partition key de `user_passages` est `(user_id)` — un seul utilisateur = une seule partition. La requête cible directement un nœud. C'est exactement pour ça que cette table a été créée : répondre à la question "historique d'un utilisateur" sans ALLOW FILTERING.

---

#### Requête 6 : passages d'un utilisateur sur les 7 derniers jours

**Requête**
```sql
SELECT * FROM cityflow.user_passages
WHERE user_id = 'user_01'
AND day >= '2025-09-13' AND day <= '2025-09-19';
```

**Réponse**
```
 user_id | day        | passage_time               | event_type | station_id
---------+------------+----------------------------+------------+------------
 user_01 | 2025-09-18 | 2025-09-18 10:00:00.000000 | return     | S002
 user_01 | 2025-09-16 | 2025-09-16 12:30:00.000000 | rent       | S005
 user_01 | 2025-09-15 | 2025-09-15 10:15:00.000000 | return     | S002
```

**Justification**
`day` est la première clustering key de `user_passages`. Un filtre par intervalle sur la clustering key est autorisé après la partition key complète. Le `CLUSTERING ORDER BY (day DESC, passage_time DESC)` garantit un tri du plus récent au plus ancien sans tri à la volée.

---

#### Requête 7 : 5 derniers passages d'un utilisateur

**Requête**
```sql
SELECT * FROM cityflow.user_passages
WHERE user_id = 'user_01'
LIMIT 5;
```

**Réponse**
```
 user_id | day        | passage_time               | event_type | station_id
---------+------------+----------------------------+------------+------------
 user_01 | 2025-09-18 | 2025-09-18 10:00:00.000000 | return     | S002
 user_01 | 2025-09-16 | 2025-09-16 12:30:00.000000 | rent       | S005
 user_01 | 2025-09-16 | 2025-09-16 07:15:00.000000 | rent       | S001
 user_01 | 2025-09-15 | 2025-09-15 10:15:00.000000 | return     | S002
 user_01 | 2025-09-15 | 2025-09-15 07:10:00.000000 | rent       | S001
```

**Justification**
Le tri physique sur le disque (`day DESC, passage_time DESC`) permet à `LIMIT 5` de lire séquentiellement les 5 premières lignes de la partition sans tri supplémentaire.

---

### Niveau 3 — INSERT, UPDATE, DELETE

#### Requête 8 : insérer un passage à l'instant présent

**Requête**
```sql
INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
VALUES ('S003', '2025-09-19', toTimestamp(now()), 'user_05', 'rent');
```

**Réponse**
```
(aucun retour — insertion silencieuse)
```

**Justification**
En Cassandra, `INSERT` est un **UPSERT** : si la PRIMARY KEY n'existe pas, la ligne est créée ; si elle existe déjà, les valeurs sont écrasées silencieusement. `toTimestamp(now())` génère un timestamp à l'instant d'exécution.

---

#### Requête 9 : modifier un event_type (UPSERT)

**Requête**
```sql
UPDATE cityflow.station_passages
SET event_type = 'return'
WHERE station_id = 'S001' AND day = '2025-09-15'
AND passage_time = '2025-09-15 07:10:00';
```

**Réponse**
```
(aucun retour — mise à jour silencieuse)
```

**Justification**
`UPDATE` en CQL est aussi un UPSERT : si la ligne n'existe pas, elle est créée avec les colonnes spécifiées. La PRIMARY KEY complète est obligatoire dans le `WHERE`. Il n'existe pas de mise à jour partielle par filtre comme en SQL.

---

#### Requête 10 : supprimer un passage précis

**Requête**
```sql
DELETE FROM cityflow.station_passages
WHERE station_id = 'S001' AND day = '2025-09-15'
AND passage_time = '2025-09-15 07:10:00';
```

**Réponse**
```
(aucun retour — suppression silencieuse)
```

**Justification**
Le `DELETE` requiert la PRIMARY KEY complète. Cassandra n'effectue pas de suppression physique immédiate : elle écrit un **tombstone** (marqueur de suppression) qui sera nettoyé lors du prochain compactage. Supprimer des millions de lignes génère des millions de tombstones, ce qui ralentit les lectures — préférer le TTL pour les données éphémères.

---

### Niveau 4 — Compteurs

#### Requête 11 : incrémenter un compteur

**Requête**
```sql
UPDATE cityflow.daily_station_stats
SET total_passages = total_passages + 1
WHERE station_id = 'S001' AND day = '2025-09-20';
```

**Réponse**
```
(aucun retour — incrément appliqué)
```

**Justification**
Les colonnes `counter` ne s'assignent pas directement : elles s'incrémentent ou se décrémentent uniquement par `+n` ou `-n`. C'est une opération atomique gérée par Cassandra, conçue pour les écritures massives concurrentes.

---

#### Requête 12 : lire le compteur

**Requête**
```sql
SELECT * FROM cityflow.daily_station_stats
WHERE station_id = 'S001' AND day = '2025-09-20';
```

**Réponse**
```
 station_id | day        | total_passages
------------+------------+----------------
 S001       | 2025-09-20 |              1
```

**Justification**
Lecture directe d'une partition. Le compteur reflète le cumul de tous les incréments appliqués depuis la création de la ligne.

---

#### Requête 13 : tenter d'assigner directement (échec volontaire)

**Requête**
```sql
UPDATE cityflow.daily_station_stats
SET total_passages = 100
WHERE station_id = 'S001' AND day = '2025-09-20';
```

**Réponse**
```
InvalidRequest: counter columns do not support assignment
```

**Justification**
Un type `counter` ne peut être ni assigné directement ni initialisé à une valeur fixe. Il ne supporte que les opérations `+n` et `-n`. Pour remettre un compteur à zéro, il faut supprimer la ligne (`DELETE`) puis recommencer les incréments.

---

### Niveau 5 — IN et bornes multiples

#### Requête 14 : passages de S001 ET S002 le 15/09

**Requête**
```sql
SELECT * FROM cityflow.station_passages
WHERE station_id IN ('S001', 'S002') AND day = '2025-09-15';
```

**Réponse**
```
 station_id | day        | passage_time               | event_type | user_id
------------+------------+----------------------------+------------+---------
 S001       | 2025-09-15 | 2025-09-15 17:20:00.000000 | return     | user_42
 S001       | 2025-09-15 | 2025-09-15 09:45:00.000000 | rent       | user_55
 S002       | 2025-09-15 | 2025-09-15 10:00:00.000000 | rent       | user_77
 S002       | 2025-09-15 | 2025-09-15 09:00:00.000000 | rent       | user_03
```

**Justification**
`IN` sur la partition key permet d'interroger plusieurs partitions en une requête. Cassandra contacte les nœuds correspondants en parallèle et agrège les résultats. À utiliser avec modération : au-delà de quelques dizaines de valeurs, préférer plusieurs requêtes parallèles côté application.

---

#### Requête 15 : passages de S001 sur 3 jours consécutifs

**Requête**
```sql
SELECT * FROM cityflow.station_passages
WHERE station_id = 'S001'
AND day IN ('2025-09-15', '2025-09-16', '2025-09-17');
```

**Réponse**
```
 station_id | day        | passage_time               | event_type | user_id
------------+------------+----------------------------+------------+---------
 S001       | 2025-09-15 | 2025-09-15 17:20:00.000000 | return     | user_42
 S001       | 2025-09-15 | 2025-09-15 09:45:00.000000 | rent       | user_55
 S001       | 2025-09-16 | 2025-09-16 08:00:00.000000 | rent       | user_02
 S001       | 2025-09-17 | 2025-09-17 08:10:00.000000 | rent       | user_02
```

**Justification**
Chaque combinaison `(station_id, day)` est une partition distincte. `IN` sur `day` interroge 3 partitions différentes potentiellement sur 3 nœuds différents. C'est le pattern standard pour récupérer des données sur plusieurs jours avec le bucketing temporel.

---

### Bonus

#### Requête 16 : filtre sur colonne non-clé (erreur attendue)

**Requête**
```sql
SELECT * FROM cityflow.station_passages WHERE event_type = 'rent';
```

**Réponse**
```
InvalidRequest: Cannot execute this query as it might involve data filtering
and thus may have unpredictable performance. Use ALLOW FILTERING
```

**Justification**
`event_type` n'est pas dans la PRIMARY KEY. Cassandra refuse de scanner toutes les partitions de tous les nœuds. Pour résoudre proprement, il faut créer une table dédiée :

```sql
CREATE TABLE cityflow.station_passages_by_event (
    station_id   text,
    day          date,
    event_type   text,
    passage_time timestamp,
    user_id      text,
    PRIMARY KEY ((station_id, day, event_type), passage_time)
) WITH CLUSTERING ORDER BY (passage_time DESC);

-- La requête devient alors possible et performante :
SELECT * FROM cityflow.station_passages_by_event
WHERE station_id = 'S001' AND day = '2025-09-15' AND event_type = 'rent';
```

---

## Partie 9 — Agrégation, BATCH et compteurs

### BATCH pour inserts normaux

**Requête**
```sql
BEGIN BATCH
    INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
    VALUES ('S001', '2025-09-20', '2025-09-20 08:00:00', 'user_03', 'rent');
    INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
    VALUES ('user_03', '2025-09-20', '2025-09-20 08:00:00', 'S001', 'rent');
APPLY BATCH;
```

**Réponse**
```
(aucun retour — batch appliqué)
```

**Justification**
`BEGIN BATCH` permet d'écrire dans plusieurs tables de manière coordonnée. À utiliser pour garantir la cohérence multi-tables (duplication synchronisée), pas pour des gains de performance — un BATCH sur des partitions différentes est même plus lent que des inserts séparés.

---

### Erreur : counter et non-counter dans le même BATCH

**Requête**
```sql
BEGIN BATCH
    INSERT INTO cityflow.station_passages (...) VALUES (...);
    UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1 WHERE ...;
APPLY BATCH;
```

**Réponse**
```
InvalidRequest: Counter and non-counter mutations cannot exist in the same batch
```

**Justification**
Cassandra impose une séparation stricte : les tables `counter` ne peuvent pas être mêlées à des tables normales dans un même BATCH. Il faut utiliser deux opérations distinctes.

---

### COUNTER BATCH pour les compteurs

**Requête**
```sql
BEGIN COUNTER BATCH
    UPDATE cityflow.daily_station_stats
    SET total_passages = total_passages + 1
    WHERE station_id = 'S001' AND day = '2025-09-20';
    UPDATE cityflow.hourly_station_stats
    SET total_passages = total_passages + 1
    WHERE station_id = 'S001' AND day = '2025-09-20' AND hour = 8;
APPLY BATCH;
```

**Réponse**
```
(aucun retour — compteurs incrémentés)
```

**Justification**
`BEGIN COUNTER BATCH` est la syntaxe réservée aux tables counter. Il existe trois types de BATCH en Cassandra :
- `BEGIN BATCH` — logged (défaut), avec garantie de livraison
- `BEGIN UNLOGGED BATCH` — plus rapide, sans garantie d'ordre
- `BEGIN COUNTER BATCH` — réservé aux colonnes counter

---

### Observation : BATCH ≠ transaction ACID

**Constat observé**
Après plusieurs tentatives de BATCH échouées, les compteurs `daily_station_stats` et `hourly_station_stats` affichent des valeurs incohérentes (`daily = 1`, `hourly = 3`).

**Justification**
Le BATCH Cassandra ne garantit pas l'atomicité au sens ACID. En cas d'échec partiel, certaines opérations peuvent avoir été appliquées avant l'erreur sans rollback automatique. C'est de la **cohérence à terme** (eventual consistency) : les données convergent vers un état cohérent, mais sans garantie de cohérence instantanée entre tables. L'application est responsable de la gestion des incohérences (retry, compensation, etc.).

---

## Récapitulatif des anti-patterns rencontrés

| Anti-pattern | Symptôme | Solution |
|---|---|---|
| `ALLOW FILTERING` | Scan complet du cluster | Créer une table dédiée avec la bonne PRIMARY KEY |
| Partition key incomplète | `InvalidRequest` | Fournir toutes les colonnes de la partition key |
| Partition sans bucketing temporel | Partition > 100 MB en prod | Ajouter `day` ou `month` à la partition key |
| Counter dans un BATCH normal | `InvalidRequest` | Utiliser `BEGIN COUNTER BATCH` séparé |
| Assigner directement un counter | `counter columns do not support assignment` | Utiliser `+n` ou `-n` uniquement |
| Filtre sur colonne non-clé | `InvalidRequest` | Créer une nouvelle table avec cette colonne dans la PK |
| Raisonnement SQL (JOIN, GROUP BY) | `InvalidRequest` ou données incorrectes | Query-first design, pré-agrégation, table dédiée |
