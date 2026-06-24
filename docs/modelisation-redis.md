# CityFlow — Modélisation Redis
**Instance :** Redis 7-alpine | **Port :** 6379 | **Persistance :** AOF activé

---

## 1. Schéma de clés complet

| Pattern de clé | Structure | TTL | User Story | Justification |
|---|---|---|---|---|
| `station:{id}:available_bikes` | String | 3600s | US-R1 | Cache disponibilité vélos, lecture O(1) |
| `station:{id}:available_scooters` | String | 3600s | US-R1 | Cache disponibilité scooters |
| `session:{userId}` | String (JSON) | 1800s | US-R2 | Session web, expire 30 min après dernière action |
| `leaderboard:monthly:{YYYY-MM}` | Sorted Set | permanent | US-R3 | Classement mensuel trié automatiquement |
| `ratelimit:{userId}:{minute}` | String | 120s | US-R4 | Compteur requêtes par fenêtre de 1 minute |
| `block:{userId}` | String | 3600s | US-R4 | Utilisateur banni pour dépassement |

---

## 2. Justifications des structures

### String — stations et sessions

String est le type le plus simple et le plus rapide de Redis.
Utilisé pour les disponibilités car :
- Valeur atomique (1 nombre entier)
- INCR/DECR atomiques → pas de race condition
- TTL natif → expiration automatique sans code supplémentaire

Utilisé pour les sessions car :
- Session = objet JSON sérialisé = 1 valeur texte
- Lecture/écriture complète en une commande (GET/SET)
- EXPIRE renouvelle le TTL à chaque action HTTP

### Sorted Set — leaderboard

Sorted Set est la structure idéale pour les classements :
- Éléments automatiquement triés par score
- ZINCRBY atomique → incrémentation sans race condition
- ZREVRANGE O(log n + k) → top 10 ultra-rapide
- ZREVRANK → rang d'un utilisateur en O(log n)
- Supporte des millions d'utilisateurs sans dégradation

### String — rate limiting

String avec INCR pour le compteur car :
- INCR est atomique → pas de race condition entre requêtes simultanées
- TTL 120s → nettoyage automatique, pas besoin de DEL manuel
- Pattern clé avec minute Unix → fenêtre glissante naturelle

---

## 3. Convention de nommage

```
entite:identifiant:attribut
```

Règles appliquées :
- `:` comme séparateur universel Redis
- Singulier : `station:` pas `stations:`
- Pas d'espaces ni d'accents
- Préfixe métier : `station:`, `session:`, `leaderboard:`, `ratelimit:`, `block:`
- Timestamp Unix pour les fenêtres de rate limiting

---

## 4. Politique de TTL

| Clé | TTL | Raison |
|---|---|---|
| `station:*:available_*` | 3600s (1h) | Données fraîches mais pas critiques. Cache miss → requête Cassandra |
| `session:*` | 1800s (30 min) | Renouvelé à chaque action HTTP via EXPIRE |
| `ratelimit:*` | 120s (2 min) | Fenêtre de 1 min + 60s de marge pour nettoyage |
| `block:*` | 3600s (1h) | Ban temporaire, durée configurable |
| `leaderboard:*` | aucun | Données permanentes, mise à jour par ZINCRBY |

---

## 5. Persistance

Configuration dans docker-compose.yml :
```
command: redis-server --requirepass cityflow2025 --appendonly yes
```

`--appendonly yes` active le mode AOF (Append-Only File).
Chaque commande d'écriture est loguée sur disque.
Les données survivent aux redémarrages du conteneur.

Pour la production, combiner RDB + AOF :
- RDB pour les snapshots rapides (restauration rapide)
- AOF pour la durabilité maximale (pas de perte de données)

---

## 6. Sécurité

- Authentification par mot de passe : `--requirepass cityflow2025`
- Volume Docker persistant : `redis_data:/data`
- En production : ACL Redis 6+ avec comptes par application,
  bind sur l'interface interne uniquement, TLS activé

---

## 7. Pourquoi Redis pour CityFlow

| Besoin | Alternative | Redis | Avantage |
|---|---|---|---|
| Cache disponibilités | Cassandra direct | Redis GET < 1ms | 1000× plus rapide |
| Sessions | Base SQL | Redis TTL natif | Expiration automatique |
| Leaderboard | SQL GROUP BY | Redis Sorted Set | Temps réel, O(log n) |
| Rate limiting | Compteur SQL | Redis INCR atomique | Pas de race condition |
