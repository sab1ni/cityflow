# CityFlow — Redis Queries
## Instance : Redis 7-alpine | Port : 6379 | Auth : cityflow2025

---

## Schéma de clés CityFlow

| Pattern | Structure | TTL | Description |
|---|---|---|---|
| `station:{id}:available_bikes` | String | 3600s | Vélos disponibles par station |
| `station:{id}:available_scooters` | String | 3600s | Scooters disponibles par station |
| `session:{userId}` | String (JSON) | 1800s | Session utilisateur active |
| `leaderboard:monthly:{YYYY-MM}` | Sorted Set | permanent | Classement mensuel par trajets |
| `ratelimit:{userId}:{minute}` | String | 120s | Compteur requêtes par minute |
| `block:{userId}` | String | 3600s | Utilisateur banni (rate limit dépassé) |

---

## US-R1 — Disponibilité temps réel d'une station

> En tant qu'utilisateur, je veux voir en temps réel combien de vélos sont disponibles à la station X.

### Requête — Lire la disponibilité

**Commande**
```redis
GET station:S001:available_bikes
GET station:S001:available_scooters

-- En une seule commande
MGET station:S001:available_bikes station:S001:available_scooters
```

**Réponse**
```
"12"
"5"
```

**Justification**
Structure String avec TTL 3600s (1h). Lecture en O(1) sub-milliseconde.
Si la clé a expiré (GET retourne nil = cache miss), l'application doit
aller chercher la donnée dans Cassandra et remettre en cache.

---

### Requête — Mettre à jour (quelqu'un loue/rend un vélo)

**Commande**
```redis
-- Quelqu'un loue un vélo à S001
DECR station:S001:available_bikes

-- Quelqu'un rend un vélo à S005
INCR station:S005:available_bikes
```

**Réponse**
```
(integer) 11
(integer) 11
```

**Justification**
INCR/DECR sont atomiques — pas de race condition même avec des milliers de
requêtes simultanées. Pas besoin de GET puis SET (qui créerait une race condition).

---

### Pattern Cache Aside (pseudo-code)

```python
def get_available_bikes(station_id):
    key = f"station:{station_id}:available_bikes"
    cached = redis.GET(key)
    if cached is not None:          # cache hit
        return int(cached)
    # cache miss → Cassandra
    bikes = cassandra.query(station_id)
    redis.SET(key, bikes, EX=3600)  # remettre en cache
    return bikes
```

---

## US-R2 — Session utilisateur 30 minutes

> En tant qu'utilisateur, je veux que ma session reste active pendant 30 minutes après ma dernière action.

### Requête — Vérifier et lire la session

**Commande**
```redis
EXISTS session:user001
GET session:user001
```

**Réponse**
```
(integer) 1
"{userId:user_001,name:Alice,lang:fr}"
```

**Justification**
EXISTS en O(1) avant GET évite de parser nil. La session est un JSON
sérialisé en String — lecture et écriture de l'objet complet en une commande.

---

### Requête — Renouveler le TTL à chaque action

**Commande**
```redis
EXPIRE session:user001 1800
TTL session:user001
```

**Réponse**
```
(integer) 1
(integer) 1796
```

**Justification**
À chaque requête HTTP, après lecture de la session, on appelle EXPIRE pour
remettre le compteur à 1800s. Sans cette commande, la session expire 30 min
après sa CRÉATION et non après la DERNIÈRE ACTION.

Séquence complète à chaque requête HTTP :
1. EXISTS session:{id} → si 0 : rediriger vers login
2. GET session:{id} → lire les données
3. EXPIRE session:{id} 1800 → renouveler

---

### Requête — Supprimer la session (déconnexion)

**Commande**
```redis
DEL session:user001
```

**Réponse**
```
(integer) 1
```

**Justification**
DEL supprime immédiatement la clé. La prochaine vérification EXISTS
retournera 0 → l'utilisateur sera redirigé vers la page de login.

---

## US-R3 — Top 10 utilisateurs les plus actifs

> En tant qu'utilisateur, je veux consulter le classement des 10 utilisateurs les plus actifs du mois.

### Requête — Top 10

**Commande**
```redis
ZREVRANGE leaderboard:monthly:2025-09 0 9 WITHSCORES
```

**Réponse**
```
1) "user_017"
2) "321"
3) "user_006"
4) "304"
5) "user_013"
6) "256"
7) "user_009"
8) "243"
9) "user_020"
10) "228"
11) "user_003"
12) "211"
13) "user_015"
14) "199"
15) "user_005"
16) "189"
17) "user_008"
18) "178"
19) "user_011"
20) "167"
```

**Justification**
ZREVRANGE retourne les éléments du Sorted Set du score le plus élevé au plus bas.
0 9 = indices 0 à 9 = les 10 premiers. WITHSCORES affiche les scores.
Complexité O(log n + k) où k = nombre d'éléments retournés.

---

### Requête — Rang et score d'un utilisateur

**Commande**
```redis
ZREVRANK leaderboard:monthly:2025-09 user_001
ZSCORE leaderboard:monthly:2025-09 user_001
```

**Réponse**
```
(integer) 12
"142"
```

**Justification**
ZREVRANK retourne la position (0-indexé) dans le classement décroissant.
user_001 avec 142 trajets est à la position 12 (13ème du classement).

---

### Requête — Incrémenter le score (trajet terminé)

**Commande**
```redis
ZINCRBY leaderboard:monthly:2025-09 1 user_001
```

**Réponse**
```
"143"
```

**Justification**
ZINCRBY est atomique. À chaque trajet terminé, on incrémente de 1.
Le Sorted Set se réorganise automatiquement — pas besoin de recalculer le classement.

---

## US-R4 — Rate limiting 100 requêtes/minute

> En tant que système, je veux limiter chaque utilisateur à 100 requêtes API par minute.

### Requête — Vérifier si bloqué

**Commande**
```redis
EXISTS block:user_006
```

**Réponse**
```
(integer) 1
```

**Justification**
Premier check avant tout traitement. Si EXISTS retourne 1 → rejeter
immédiatement avec HTTP 429. TTL 3600s = ban d'1 heure.

---

### Requête — Compteur de requêtes

**Commande**
```redis
GET ratelimit:user_006:1747123200
```

**Réponse**
```
"99"
```

**Justification**
La clé encode l'userId et la minute Unix (floor(timestamp/60)).
Chaque nouvelle minute = nouvelle clé = compteur repart à 0.
TTL 120s = nettoyage automatique 2 minutes après la fin de la fenêtre.

---

### Séquence complète rate limiting

**Commande**
```redis
-- 1. Vérifier si banni
EXISTS block:user_006

-- 2. Incrémenter le compteur
INCR ratelimit:user_006:1747123200

-- 3. Fixer le TTL si nouvelle clé (retour INCR == 1)
EXPIRE ratelimit:user_006:1747123200 120

-- 4. Si compteur > 100 : bloquer 1h
SET block:user_006 1 EX 3600
```

**Réponse**
```
(integer) 1  -- banni
(integer) 100
(integer) 1  -- TTL fixé
OK           -- banni
```

**Justification**
Algorithme fixed window counter :
- Clé = ratelimit:{userId}:{minute} → fenêtre d'1 minute exacte
- INCR atomique → pas de race condition
- TTL 120s → nettoyage automatique (pas besoin de DEL manuel)
- block:{userId} EX 3600 → ban d'1 heure si dépassement

Coût mémoire estimé pour 10 000 utilisateurs :
- Clé rate limit : ~50 bytes × 10 000 = 500 KB
- Clé block (si tous bannis) : ~30 bytes × 10 000 = 300 KB
- Total : < 1 MB → négligeable
