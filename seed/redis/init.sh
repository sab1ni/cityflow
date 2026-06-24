#!/bin/bash
# ============================================================
# CityFlow — Redis seed script
# 15 stations | 5 sessions | 20 users leaderboard | rate limiting
# ============================================================

REDIS_CLI="redis-cli -a cityflow2025"

echo "=== Seed Redis CityFlow ==="

# ── Stations (vélos + scooters) TTL 3600s ──────────────────
echo "→ Stations..."
$REDIS_CLI SET station:S001:available_bikes 12 EX 3600
$REDIS_CLI SET station:S001:available_scooters 5 EX 3600
$REDIS_CLI SET station:S002:available_bikes 8 EX 3600
$REDIS_CLI SET station:S002:available_scooters 3 EX 3600
$REDIS_CLI SET station:S003:available_bikes 15 EX 3600
$REDIS_CLI SET station:S003:available_scooters 7 EX 3600
$REDIS_CLI SET station:S004:available_bikes 4 EX 3600
$REDIS_CLI SET station:S004:available_scooters 2 EX 3600
$REDIS_CLI SET station:S005:available_bikes 10 EX 3600
$REDIS_CLI SET station:S005:available_scooters 6 EX 3600
$REDIS_CLI SET station:S006:available_bikes 7 EX 3600
$REDIS_CLI SET station:S006:available_scooters 4 EX 3600
$REDIS_CLI SET station:S007:available_bikes 3 EX 3600
$REDIS_CLI SET station:S007:available_scooters 1 EX 3600
$REDIS_CLI SET station:S008:available_bikes 9 EX 3600
$REDIS_CLI SET station:S008:available_scooters 5 EX 3600
$REDIS_CLI SET station:S009:available_bikes 6 EX 3600
$REDIS_CLI SET station:S009:available_scooters 3 EX 3600
$REDIS_CLI SET station:S010:available_bikes 11 EX 3600
$REDIS_CLI SET station:S010:available_scooters 4 EX 3600
$REDIS_CLI SET station:S011:available_bikes 2 EX 3600
$REDIS_CLI SET station:S011:available_scooters 0 EX 3600
$REDIS_CLI SET station:S012:available_bikes 14 EX 3600
$REDIS_CLI SET station:S012:available_scooters 8 EX 3600
$REDIS_CLI SET station:S013:available_bikes 5 EX 3600
$REDIS_CLI SET station:S013:available_scooters 2 EX 3600
$REDIS_CLI SET station:S014:available_bikes 8 EX 3600
$REDIS_CLI SET station:S014:available_scooters 3 EX 3600
$REDIS_CLI SET station:S015:available_bikes 6 EX 3600
$REDIS_CLI SET station:S015:available_scooters 4 EX 3600

# ── Sessions actives TTL 1800s ──────────────────────────────
echo "→ Sessions..."
$REDIS_CLI SET session:user001 "{userId:user_001,name:Alice,lang:fr}" EX 1800
$REDIS_CLI SET session:user002 "{userId:user_002,name:Bob,lang:fr}" EX 1800
$REDIS_CLI SET session:user003 "{userId:user_003,name:Carol,lang:en}" EX 1800
$REDIS_CLI SET session:user004 "{userId:user_004,name:Dave,lang:fr}" EX 1800
$REDIS_CLI SET session:user005 "{userId:user_005,name:Eve,lang:fr}" EX 1800

# ── Leaderboard mensuel ─────────────────────────────────────
echo "→ Leaderboard..."
$REDIS_CLI ZADD leaderboard:monthly:2025-09 142 user_001
$REDIS_CLI ZADD leaderboard:monthly:2025-09 98 user_002
$REDIS_CLI ZADD leaderboard:monthly:2025-09 211 user_003
$REDIS_CLI ZADD leaderboard:monthly:2025-09 67 user_004
$REDIS_CLI ZADD leaderboard:monthly:2025-09 189 user_005
$REDIS_CLI ZADD leaderboard:monthly:2025-09 304 user_006
$REDIS_CLI ZADD leaderboard:monthly:2025-09 55 user_007
$REDIS_CLI ZADD leaderboard:monthly:2025-09 178 user_008
$REDIS_CLI ZADD leaderboard:monthly:2025-09 243 user_009
$REDIS_CLI ZADD leaderboard:monthly:2025-09 91 user_010
$REDIS_CLI ZADD leaderboard:monthly:2025-09 167 user_011
$REDIS_CLI ZADD leaderboard:monthly:2025-09 38 user_012
$REDIS_CLI ZADD leaderboard:monthly:2025-09 256 user_013
$REDIS_CLI ZADD leaderboard:monthly:2025-09 112 user_014
$REDIS_CLI ZADD leaderboard:monthly:2025-09 199 user_015
$REDIS_CLI ZADD leaderboard:monthly:2025-09 84 user_016
$REDIS_CLI ZADD leaderboard:monthly:2025-09 321 user_017
$REDIS_CLI ZADD leaderboard:monthly:2025-09 145 user_018
$REDIS_CLI ZADD leaderboard:monthly:2025-09 73 user_019
$REDIS_CLI ZADD leaderboard:monthly:2025-09 228 user_020

# ── Rate limiting (compteurs en cours) ─────────────────────
echo "→ Rate limiting..."
$REDIS_CLI SET ratelimit:user_001:1747123200 45 EX 120
$REDIS_CLI SET ratelimit:user_003:1747123200 87 EX 120
$REDIS_CLI SET ratelimit:user_006:1747123200 99 EX 120
$REDIS_CLI SET block:user_006 1 EX 3600

echo "=== Seed terminé ==="
$REDIS_CLI DBSIZE
