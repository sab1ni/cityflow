-- ============================================================
-- CityFlow Cassandra — Seed fil rouge Partie 10
-- 15 stations lyonnaises | 30 utilisateurs | 200 passages / 7 jours
-- ============================================================

CREATE KEYSPACE IF NOT EXISTS cityflow
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

CREATE TABLE IF NOT EXISTS cityflow.station_passages (
    station_id   text,
    day          date,
    passage_time timestamp,
    user_id      text,
    event_type   text,
    PRIMARY KEY ((station_id, day), passage_time)
) WITH CLUSTERING ORDER BY (passage_time DESC);

CREATE TABLE IF NOT EXISTS cityflow.user_passages (
    user_id      text,
    day          date,
    passage_time timestamp,
    station_id   text,
    event_type   text,
    PRIMARY KEY ((user_id), day, passage_time)
) WITH CLUSTERING ORDER BY (day DESC, passage_time DESC);

CREATE TABLE IF NOT EXISTS cityflow.daily_station_stats (
    station_id     text,
    day            date,
    total_passages counter,
    PRIMARY KEY (station_id, day)
);

CREATE TABLE IF NOT EXISTS cityflow.hourly_station_stats (
    station_id     text,
    day            date,
    hour           int,
    total_passages counter,
    PRIMARY KEY ((station_id, day), hour)
);

-- ── 200 passages ──
-- BATCH 1 : station_passages + user_passages

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S011', '2025-09-15', '2025-09-15 07:47:17', 'user_004', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_004', '2025-09-15', '2025-09-15 07:47:17', 'S011', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S004', '2025-09-15', '2025-09-15 18:06:43', 'user_005', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_005', '2025-09-15', '2025-09-15 18:06:43', 'S004', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S010', '2025-09-15', '2025-09-15 07:01:05', 'user_014', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_014', '2025-09-15', '2025-09-15 07:01:05', 'S010', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S004', '2025-09-15', '2025-09-15 16:01:35', 'user_017', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_017', '2025-09-15', '2025-09-15 16:01:35', 'S004', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S012', '2025-09-15', '2025-09-15 18:34:26', 'user_021', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_021', '2025-09-15', '2025-09-15 18:34:26', 'S012', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S008', '2025-09-15', '2025-09-15 11:51:55', 'user_019', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_019', '2025-09-15', '2025-09-15 11:51:55', 'S008', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S013', '2025-09-15', '2025-09-15 09:44:27', 'user_026', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_026', '2025-09-15', '2025-09-15 09:44:27', 'S013', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S005', '2025-09-15', '2025-09-15 10:48:21', 'user_005', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_005', '2025-09-15', '2025-09-15 10:48:21', 'S005', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S002', '2025-09-15', '2025-09-15 08:22:54', 'user_013', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_013', '2025-09-15', '2025-09-15 08:22:54', 'S002', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S010', '2025-09-15', '2025-09-15 19:02:46', 'user_009', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_009', '2025-09-15', '2025-09-15 19:02:46', 'S010', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S009', '2025-09-15', '2025-09-15 13:05:35', 'user_004', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_004', '2025-09-15', '2025-09-15 13:05:35', 'S009', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S014', '2025-09-15', '2025-09-15 16:56:55', 'user_021', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_021', '2025-09-15', '2025-09-15 16:56:55', 'S014', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S010', '2025-09-15', '2025-09-15 18:04:02', 'user_007', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_007', '2025-09-15', '2025-09-15 18:04:02', 'S010', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S013', '2025-09-15', '2025-09-15 08:54:14', 'user_010', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_010', '2025-09-15', '2025-09-15 08:54:14', 'S013', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S007', '2025-09-15', '2025-09-15 14:40:53', 'user_009', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_009', '2025-09-15', '2025-09-15 14:40:53', 'S007', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S003', '2025-09-15', '2025-09-15 12:13:42', 'user_012', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_012', '2025-09-15', '2025-09-15 12:13:42', 'S003', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S012', '2025-09-15', '2025-09-15 17:41:04', 'user_030', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_030', '2025-09-15', '2025-09-15 17:41:04', 'S012', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S009', '2025-09-15', '2025-09-15 10:10:29', 'user_024', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_024', '2025-09-15', '2025-09-15 10:10:29', 'S009', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S005', '2025-09-15', '2025-09-15 17:44:35', 'user_030', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_030', '2025-09-15', '2025-09-15 17:44:35', 'S005', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S011', '2025-09-15', '2025-09-15 20:49:49', 'user_011', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_011', '2025-09-15', '2025-09-15 20:49:49', 'S011', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S004', '2025-09-15', '2025-09-15 07:51:20', 'user_027', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_027', '2025-09-15', '2025-09-15 07:51:20', 'S004', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S005', '2025-09-15', '2025-09-15 10:58:36', 'user_003', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_003', '2025-09-15', '2025-09-15 10:58:36', 'S005', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S004', '2025-09-15', '2025-09-15 14:25:56', 'user_021', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_021', '2025-09-15', '2025-09-15 14:25:56', 'S004', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S003', '2025-09-15', '2025-09-15 09:15:47', 'user_009', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_009', '2025-09-15', '2025-09-15 09:15:47', 'S003', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S012', '2025-09-15', '2025-09-15 13:57:37', 'user_019', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_019', '2025-09-15', '2025-09-15 13:57:37', 'S012', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S006', '2025-09-15', '2025-09-15 09:32:31', 'user_008', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_008', '2025-09-15', '2025-09-15 09:32:31', 'S006', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S013', '2025-09-15', '2025-09-15 20:07:09', 'user_002', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_002', '2025-09-15', '2025-09-15 20:07:09', 'S013', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S013', '2025-09-15', '2025-09-15 13:38:04', 'user_022', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_022', '2025-09-15', '2025-09-15 13:38:04', 'S013', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S007', '2025-09-16', '2025-09-16 14:33:16', 'user_020', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_020', '2025-09-16', '2025-09-16 14:33:16', 'S007', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S011', '2025-09-16', '2025-09-16 08:43:56', 'user_024', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_024', '2025-09-16', '2025-09-16 08:43:56', 'S011', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S013', '2025-09-16', '2025-09-16 12:07:18', 'user_021', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_021', '2025-09-16', '2025-09-16 12:07:18', 'S013', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S003', '2025-09-16', '2025-09-16 07:46:56', 'user_015', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_015', '2025-09-16', '2025-09-16 07:46:56', 'S003', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S009', '2025-09-16', '2025-09-16 09:32:58', 'user_025', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_025', '2025-09-16', '2025-09-16 09:32:58', 'S009', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S014', '2025-09-16', '2025-09-16 11:53:40', 'user_021', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_021', '2025-09-16', '2025-09-16 11:53:40', 'S014', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S003', '2025-09-16', '2025-09-16 19:10:34', 'user_012', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_012', '2025-09-16', '2025-09-16 19:10:34', 'S003', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S010', '2025-09-16', '2025-09-16 14:01:07', 'user_011', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_011', '2025-09-16', '2025-09-16 14:01:07', 'S010', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S015', '2025-09-16', '2025-09-16 19:19:15', 'user_027', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_027', '2025-09-16', '2025-09-16 19:19:15', 'S015', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S004', '2025-09-16', '2025-09-16 16:05:05', 'user_029', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_029', '2025-09-16', '2025-09-16 16:05:05', 'S004', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S014', '2025-09-16', '2025-09-16 19:34:49', 'user_003', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_003', '2025-09-16', '2025-09-16 19:34:49', 'S014', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S003', '2025-09-16', '2025-09-16 14:35:10', 'user_022', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_022', '2025-09-16', '2025-09-16 14:35:10', 'S003', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S009', '2025-09-16', '2025-09-16 16:27:13', 'user_028', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_028', '2025-09-16', '2025-09-16 16:27:13', 'S009', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S012', '2025-09-16', '2025-09-16 13:42:41', 'user_010', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_010', '2025-09-16', '2025-09-16 13:42:41', 'S012', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S008', '2025-09-16', '2025-09-16 15:28:07', 'user_029', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_029', '2025-09-16', '2025-09-16 15:28:07', 'S008', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S004', '2025-09-16', '2025-09-16 12:01:37', 'user_003', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_003', '2025-09-16', '2025-09-16 12:01:37', 'S004', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S010', '2025-09-16', '2025-09-16 07:04:45', 'user_008', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_008', '2025-09-16', '2025-09-16 07:04:45', 'S010', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S004', '2025-09-16', '2025-09-16 07:55:21', 'user_003', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_003', '2025-09-16', '2025-09-16 07:55:21', 'S004', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S009', '2025-09-16', '2025-09-16 11:42:31', 'user_008', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_008', '2025-09-16', '2025-09-16 11:42:31', 'S009', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S009', '2025-09-16', '2025-09-16 18:59:56', 'user_005', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_005', '2025-09-16', '2025-09-16 18:59:56', 'S009', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S004', '2025-09-16', '2025-09-16 14:51:26', 'user_026', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_026', '2025-09-16', '2025-09-16 14:51:26', 'S004', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S002', '2025-09-16', '2025-09-16 17:27:22', 'user_004', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_004', '2025-09-16', '2025-09-16 17:27:22', 'S002', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S007', '2025-09-16', '2025-09-16 20:46:03', 'user_015', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_015', '2025-09-16', '2025-09-16 20:46:03', 'S007', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S001', '2025-09-16', '2025-09-16 18:21:51', 'user_013', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_013', '2025-09-16', '2025-09-16 18:21:51', 'S001', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S004', '2025-09-16', '2025-09-16 10:34:28', 'user_007', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_007', '2025-09-16', '2025-09-16 10:34:28', 'S004', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S007', '2025-09-16', '2025-09-16 11:29:15', 'user_006', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_006', '2025-09-16', '2025-09-16 11:29:15', 'S007', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S008', '2025-09-16', '2025-09-16 20:54:35', 'user_026', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_026', '2025-09-16', '2025-09-16 20:54:35', 'S008', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S001', '2025-09-16', '2025-09-16 15:53:00', 'user_021', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_021', '2025-09-16', '2025-09-16 15:53:00', 'S001', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S015', '2025-09-17', '2025-09-17 20:15:10', 'user_025', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_025', '2025-09-17', '2025-09-17 20:15:10', 'S015', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S008', '2025-09-17', '2025-09-17 10:55:25', 'user_016', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_016', '2025-09-17', '2025-09-17 10:55:25', 'S008', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S003', '2025-09-17', '2025-09-17 07:24:16', 'user_013', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_013', '2025-09-17', '2025-09-17 07:24:16', 'S003', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S005', '2025-09-17', '2025-09-17 18:46:50', 'user_014', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_014', '2025-09-17', '2025-09-17 18:46:50', 'S005', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S003', '2025-09-17', '2025-09-17 11:13:03', 'user_007', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_007', '2025-09-17', '2025-09-17 11:13:03', 'S003', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S012', '2025-09-17', '2025-09-17 07:03:37', 'user_011', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_011', '2025-09-17', '2025-09-17 07:03:37', 'S012', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S009', '2025-09-17', '2025-09-17 20:33:10', 'user_030', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_030', '2025-09-17', '2025-09-17 20:33:10', 'S009', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S009', '2025-09-17', '2025-09-17 20:11:04', 'user_003', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_003', '2025-09-17', '2025-09-17 20:11:04', 'S009', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S011', '2025-09-17', '2025-09-17 10:25:07', 'user_028', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_028', '2025-09-17', '2025-09-17 10:25:07', 'S011', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S010', '2025-09-17', '2025-09-17 07:39:05', 'user_020', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_020', '2025-09-17', '2025-09-17 07:39:05', 'S010', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S011', '2025-09-17', '2025-09-17 16:33:20', 'user_019', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_019', '2025-09-17', '2025-09-17 16:33:20', 'S011', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S004', '2025-09-17', '2025-09-17 18:20:15', 'user_022', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_022', '2025-09-17', '2025-09-17 18:20:15', 'S004', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S007', '2025-09-17', '2025-09-17 17:41:19', 'user_005', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_005', '2025-09-17', '2025-09-17 17:41:19', 'S007', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S006', '2025-09-17', '2025-09-17 19:59:04', 'user_030', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_030', '2025-09-17', '2025-09-17 19:59:04', 'S006', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S008', '2025-09-17', '2025-09-17 16:06:04', 'user_020', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_020', '2025-09-17', '2025-09-17 16:06:04', 'S008', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S009', '2025-09-17', '2025-09-17 09:59:22', 'user_009', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_009', '2025-09-17', '2025-09-17 09:59:22', 'S009', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S015', '2025-09-17', '2025-09-17 12:18:10', 'user_008', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_008', '2025-09-17', '2025-09-17 12:18:10', 'S015', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S014', '2025-09-17', '2025-09-17 18:19:39', 'user_018', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_018', '2025-09-17', '2025-09-17 18:19:39', 'S014', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S011', '2025-09-17', '2025-09-17 15:19:59', 'user_027', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_027', '2025-09-17', '2025-09-17 15:19:59', 'S011', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S015', '2025-09-17', '2025-09-17 11:07:56', 'user_005', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_005', '2025-09-17', '2025-09-17 11:07:56', 'S015', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S012', '2025-09-17', '2025-09-17 09:17:18', 'user_018', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_018', '2025-09-17', '2025-09-17 09:17:18', 'S012', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S012', '2025-09-17', '2025-09-17 10:43:40', 'user_011', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_011', '2025-09-17', '2025-09-17 10:43:40', 'S012', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S009', '2025-09-17', '2025-09-17 11:57:58', 'user_016', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_016', '2025-09-17', '2025-09-17 11:57:58', 'S009', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S002', '2025-09-17', '2025-09-17 13:53:17', 'user_021', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_021', '2025-09-17', '2025-09-17 13:53:17', 'S002', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S001', '2025-09-17', '2025-09-17 19:08:40', 'user_011', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_011', '2025-09-17', '2025-09-17 19:08:40', 'S001', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S003', '2025-09-17', '2025-09-17 14:35:45', 'user_024', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_024', '2025-09-17', '2025-09-17 14:35:45', 'S003', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S009', '2025-09-17', '2025-09-17 08:04:56', 'user_001', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_001', '2025-09-17', '2025-09-17 08:04:56', 'S009', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S009', '2025-09-17', '2025-09-17 20:23:37', 'user_002', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_002', '2025-09-17', '2025-09-17 20:23:37', 'S009', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S007', '2025-09-18', '2025-09-18 07:19:23', 'user_005', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_005', '2025-09-18', '2025-09-18 07:19:23', 'S007', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S015', '2025-09-18', '2025-09-18 10:43:15', 'user_012', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_012', '2025-09-18', '2025-09-18 10:43:15', 'S015', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S006', '2025-09-18', '2025-09-18 15:56:55', 'user_025', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_025', '2025-09-18', '2025-09-18 15:56:55', 'S006', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S010', '2025-09-18', '2025-09-18 09:59:59', 'user_024', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_024', '2025-09-18', '2025-09-18 09:59:59', 'S010', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S014', '2025-09-18', '2025-09-18 19:51:11', 'user_006', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_006', '2025-09-18', '2025-09-18 19:51:11', 'S014', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S001', '2025-09-18', '2025-09-18 18:59:21', 'user_006', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_006', '2025-09-18', '2025-09-18 18:59:21', 'S001', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S013', '2025-09-18', '2025-09-18 20:47:51', 'user_022', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_022', '2025-09-18', '2025-09-18 20:47:51', 'S013', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S005', '2025-09-18', '2025-09-18 19:44:06', 'user_006', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_006', '2025-09-18', '2025-09-18 19:44:06', 'S005', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S014', '2025-09-18', '2025-09-18 20:30:14', 'user_002', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_002', '2025-09-18', '2025-09-18 20:30:14', 'S014', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S014', '2025-09-18', '2025-09-18 14:22:19', 'user_030', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_030', '2025-09-18', '2025-09-18 14:22:19', 'S014', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S004', '2025-09-18', '2025-09-18 17:12:25', 'user_001', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_001', '2025-09-18', '2025-09-18 17:12:25', 'S004', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S005', '2025-09-18', '2025-09-18 08:49:17', 'user_028', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_028', '2025-09-18', '2025-09-18 08:49:17', 'S005', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S011', '2025-09-18', '2025-09-18 13:43:53', 'user_017', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_017', '2025-09-18', '2025-09-18 13:43:53', 'S011', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S001', '2025-09-18', '2025-09-18 11:11:37', 'user_004', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_004', '2025-09-18', '2025-09-18 11:11:37', 'S001', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S001', '2025-09-18', '2025-09-18 16:27:22', 'user_004', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_004', '2025-09-18', '2025-09-18 16:27:22', 'S001', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S007', '2025-09-18', '2025-09-18 15:07:24', 'user_020', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_020', '2025-09-18', '2025-09-18 15:07:24', 'S007', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S005', '2025-09-18', '2025-09-18 18:27:00', 'user_002', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_002', '2025-09-18', '2025-09-18 18:27:00', 'S005', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S006', '2025-09-18', '2025-09-18 08:42:58', 'user_014', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_014', '2025-09-18', '2025-09-18 08:42:58', 'S006', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S010', '2025-09-18', '2025-09-18 17:54:07', 'user_011', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_011', '2025-09-18', '2025-09-18 17:54:07', 'S010', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S009', '2025-09-18', '2025-09-18 17:26:20', 'user_010', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_010', '2025-09-18', '2025-09-18 17:26:20', 'S009', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S012', '2025-09-18', '2025-09-18 15:08:12', 'user_010', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_010', '2025-09-18', '2025-09-18 15:08:12', 'S012', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S011', '2025-09-18', '2025-09-18 17:47:57', 'user_013', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_013', '2025-09-18', '2025-09-18 17:47:57', 'S011', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S010', '2025-09-18', '2025-09-18 11:25:35', 'user_019', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_019', '2025-09-18', '2025-09-18 11:25:35', 'S010', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S005', '2025-09-18', '2025-09-18 10:27:50', 'user_010', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_010', '2025-09-18', '2025-09-18 10:27:50', 'S005', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S008', '2025-09-18', '2025-09-18 14:43:13', 'user_015', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_015', '2025-09-18', '2025-09-18 14:43:13', 'S008', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S013', '2025-09-18', '2025-09-18 19:47:10', 'user_029', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_029', '2025-09-18', '2025-09-18 19:47:10', 'S013', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S005', '2025-09-18', '2025-09-18 17:40:39', 'user_017', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_017', '2025-09-18', '2025-09-18 17:40:39', 'S005', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S002', '2025-09-18', '2025-09-18 19:15:43', 'user_027', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_027', '2025-09-18', '2025-09-18 19:15:43', 'S002', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S004', '2025-09-19', '2025-09-19 10:09:01', 'user_026', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_026', '2025-09-19', '2025-09-19 10:09:01', 'S004', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S004', '2025-09-19', '2025-09-19 16:54:49', 'user_016', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_016', '2025-09-19', '2025-09-19 16:54:49', 'S004', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S008', '2025-09-19', '2025-09-19 17:36:12', 'user_014', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_014', '2025-09-19', '2025-09-19 17:36:12', 'S008', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S008', '2025-09-19', '2025-09-19 10:09:41', 'user_013', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_013', '2025-09-19', '2025-09-19 10:09:41', 'S008', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S015', '2025-09-19', '2025-09-19 20:49:56', 'user_025', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_025', '2025-09-19', '2025-09-19 20:49:56', 'S015', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S013', '2025-09-19', '2025-09-19 10:11:51', 'user_014', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_014', '2025-09-19', '2025-09-19 10:11:51', 'S013', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S001', '2025-09-19', '2025-09-19 10:58:54', 'user_018', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_018', '2025-09-19', '2025-09-19 10:58:54', 'S001', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S008', '2025-09-19', '2025-09-19 19:29:42', 'user_005', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_005', '2025-09-19', '2025-09-19 19:29:42', 'S008', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S013', '2025-09-19', '2025-09-19 14:39:52', 'user_029', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_029', '2025-09-19', '2025-09-19 14:39:52', 'S013', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S014', '2025-09-19', '2025-09-19 15:28:57', 'user_030', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_030', '2025-09-19', '2025-09-19 15:28:57', 'S014', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S012', '2025-09-19', '2025-09-19 14:28:16', 'user_028', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_028', '2025-09-19', '2025-09-19 14:28:16', 'S012', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S014', '2025-09-19', '2025-09-19 11:49:49', 'user_021', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_021', '2025-09-19', '2025-09-19 11:49:49', 'S014', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S011', '2025-09-19', '2025-09-19 11:28:04', 'user_008', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_008', '2025-09-19', '2025-09-19 11:28:04', 'S011', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S004', '2025-09-19', '2025-09-19 12:20:57', 'user_009', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_009', '2025-09-19', '2025-09-19 12:20:57', 'S004', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S003', '2025-09-19', '2025-09-19 10:24:44', 'user_005', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_005', '2025-09-19', '2025-09-19 10:24:44', 'S003', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S012', '2025-09-19', '2025-09-19 08:26:26', 'user_007', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_007', '2025-09-19', '2025-09-19 08:26:26', 'S012', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S009', '2025-09-19', '2025-09-19 13:03:13', 'user_015', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_015', '2025-09-19', '2025-09-19 13:03:13', 'S009', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S007', '2025-09-19', '2025-09-19 19:37:44', 'user_029', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_029', '2025-09-19', '2025-09-19 19:37:44', 'S007', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S014', '2025-09-19', '2025-09-19 19:36:24', 'user_029', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_029', '2025-09-19', '2025-09-19 19:36:24', 'S014', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S001', '2025-09-19', '2025-09-19 11:48:24', 'user_012', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_012', '2025-09-19', '2025-09-19 11:48:24', 'S001', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S009', '2025-09-19', '2025-09-19 18:34:51', 'user_024', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_024', '2025-09-19', '2025-09-19 18:34:51', 'S009', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S008', '2025-09-19', '2025-09-19 11:27:31', 'user_008', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_008', '2025-09-19', '2025-09-19 11:27:31', 'S008', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S007', '2025-09-19', '2025-09-19 17:43:51', 'user_011', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_011', '2025-09-19', '2025-09-19 17:43:51', 'S007', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S012', '2025-09-19', '2025-09-19 20:29:58', 'user_006', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_006', '2025-09-19', '2025-09-19 20:29:58', 'S012', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S010', '2025-09-19', '2025-09-19 07:58:25', 'user_018', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_018', '2025-09-19', '2025-09-19 07:58:25', 'S010', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S002', '2025-09-19', '2025-09-19 13:08:55', 'user_021', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_021', '2025-09-19', '2025-09-19 13:08:55', 'S002', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S003', '2025-09-19', '2025-09-19 11:24:20', 'user_002', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_002', '2025-09-19', '2025-09-19 11:24:20', 'S003', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S008', '2025-09-19', '2025-09-19 12:48:56', 'user_011', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_011', '2025-09-19', '2025-09-19 12:48:56', 'S008', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S005', '2025-09-20', '2025-09-20 20:26:16', 'user_025', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_025', '2025-09-20', '2025-09-20 20:26:16', 'S005', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S008', '2025-09-20', '2025-09-20 18:34:03', 'user_001', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_001', '2025-09-20', '2025-09-20 18:34:03', 'S008', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S004', '2025-09-20', '2025-09-20 08:49:41', 'user_021', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_021', '2025-09-20', '2025-09-20 08:49:41', 'S004', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S013', '2025-09-20', '2025-09-20 10:12:53', 'user_001', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_001', '2025-09-20', '2025-09-20 10:12:53', 'S013', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S010', '2025-09-20', '2025-09-20 10:08:30', 'user_005', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_005', '2025-09-20', '2025-09-20 10:08:30', 'S010', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S010', '2025-09-20', '2025-09-20 14:44:16', 'user_007', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_007', '2025-09-20', '2025-09-20 14:44:16', 'S010', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S003', '2025-09-20', '2025-09-20 16:47:45', 'user_020', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_020', '2025-09-20', '2025-09-20 16:47:45', 'S003', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S013', '2025-09-20', '2025-09-20 09:19:06', 'user_027', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_027', '2025-09-20', '2025-09-20 09:19:06', 'S013', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S015', '2025-09-20', '2025-09-20 16:43:58', 'user_010', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_010', '2025-09-20', '2025-09-20 16:43:58', 'S015', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S007', '2025-09-20', '2025-09-20 10:04:37', 'user_023', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_023', '2025-09-20', '2025-09-20 10:04:37', 'S007', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S002', '2025-09-20', '2025-09-20 19:19:54', 'user_023', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_023', '2025-09-20', '2025-09-20 19:19:54', 'S002', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S013', '2025-09-20', '2025-09-20 19:02:22', 'user_019', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_019', '2025-09-20', '2025-09-20 19:02:22', 'S013', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S011', '2025-09-20', '2025-09-20 08:32:41', 'user_012', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_012', '2025-09-20', '2025-09-20 08:32:41', 'S011', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S001', '2025-09-20', '2025-09-20 13:52:31', 'user_028', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_028', '2025-09-20', '2025-09-20 13:52:31', 'S001', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S007', '2025-09-20', '2025-09-20 17:57:53', 'user_012', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_012', '2025-09-20', '2025-09-20 17:57:53', 'S007', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S012', '2025-09-20', '2025-09-20 13:11:46', 'user_005', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_005', '2025-09-20', '2025-09-20 13:11:46', 'S012', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S010', '2025-09-20', '2025-09-20 15:49:30', 'user_026', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_026', '2025-09-20', '2025-09-20 15:49:30', 'S010', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S007', '2025-09-20', '2025-09-20 18:37:17', 'user_027', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_027', '2025-09-20', '2025-09-20 18:37:17', 'S007', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S014', '2025-09-20', '2025-09-20 20:59:05', 'user_008', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_008', '2025-09-20', '2025-09-20 20:59:05', 'S014', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S015', '2025-09-20', '2025-09-20 10:48:29', 'user_015', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_015', '2025-09-20', '2025-09-20 10:48:29', 'S015', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S006', '2025-09-20', '2025-09-20 14:54:20', 'user_001', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_001', '2025-09-20', '2025-09-20 14:54:20', 'S006', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S008', '2025-09-20', '2025-09-20 12:51:16', 'user_007', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_007', '2025-09-20', '2025-09-20 12:51:16', 'S008', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S005', '2025-09-20', '2025-09-20 16:44:56', 'user_029', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_029', '2025-09-20', '2025-09-20 16:44:56', 'S005', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S009', '2025-09-20', '2025-09-20 15:12:05', 'user_001', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_001', '2025-09-20', '2025-09-20 15:12:05', 'S009', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S012', '2025-09-20', '2025-09-20 14:35:48', 'user_014', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_014', '2025-09-20', '2025-09-20 14:35:48', 'S012', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S012', '2025-09-20', '2025-09-20 17:45:31', 'user_016', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_016', '2025-09-20', '2025-09-20 17:45:31', 'S012', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S013', '2025-09-20', '2025-09-20 08:18:14', 'user_001', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_001', '2025-09-20', '2025-09-20 08:18:14', 'S013', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S012', '2025-09-20', '2025-09-20 11:42:37', 'user_008', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_008', '2025-09-20', '2025-09-20 11:42:37', 'S012', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S008', '2025-09-21', '2025-09-21 15:22:27', 'user_018', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_018', '2025-09-21', '2025-09-21 15:22:27', 'S008', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S006', '2025-09-21', '2025-09-21 14:17:19', 'user_023', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_023', '2025-09-21', '2025-09-21 14:17:19', 'S006', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S004', '2025-09-21', '2025-09-21 18:12:20', 'user_004', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_004', '2025-09-21', '2025-09-21 18:12:20', 'S004', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S012', '2025-09-21', '2025-09-21 19:44:11', 'user_018', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_018', '2025-09-21', '2025-09-21 19:44:11', 'S012', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S004', '2025-09-21', '2025-09-21 14:17:46', 'user_024', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_024', '2025-09-21', '2025-09-21 14:17:46', 'S004', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S002', '2025-09-21', '2025-09-21 10:18:14', 'user_027', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_027', '2025-09-21', '2025-09-21 10:18:14', 'S002', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S003', '2025-09-21', '2025-09-21 07:45:34', 'user_010', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_010', '2025-09-21', '2025-09-21 07:45:34', 'S003', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S005', '2025-09-21', '2025-09-21 07:35:18', 'user_002', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_002', '2025-09-21', '2025-09-21 07:35:18', 'S005', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S011', '2025-09-21', '2025-09-21 19:31:06', 'user_028', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_028', '2025-09-21', '2025-09-21 19:31:06', 'S011', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S010', '2025-09-21', '2025-09-21 14:30:28', 'user_010', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_010', '2025-09-21', '2025-09-21 14:30:28', 'S010', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S003', '2025-09-21', '2025-09-21 11:55:30', 'user_002', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_002', '2025-09-21', '2025-09-21 11:55:30', 'S003', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S014', '2025-09-21', '2025-09-21 13:31:04', 'user_003', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_003', '2025-09-21', '2025-09-21 13:31:04', 'S014', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S003', '2025-09-21', '2025-09-21 19:36:19', 'user_005', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_005', '2025-09-21', '2025-09-21 19:36:19', 'S003', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S004', '2025-09-21', '2025-09-21 15:48:26', 'user_004', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_004', '2025-09-21', '2025-09-21 15:48:26', 'S004', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S013', '2025-09-21', '2025-09-21 13:28:58', 'user_017', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_017', '2025-09-21', '2025-09-21 13:28:58', 'S013', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S005', '2025-09-21', '2025-09-21 16:27:19', 'user_028', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_028', '2025-09-21', '2025-09-21 16:27:19', 'S005', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S010', '2025-09-21', '2025-09-21 08:48:13', 'user_024', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_024', '2025-09-21', '2025-09-21 08:48:13', 'S010', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S005', '2025-09-21', '2025-09-21 08:10:15', 'user_022', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_022', '2025-09-21', '2025-09-21 08:10:15', 'S005', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S009', '2025-09-21', '2025-09-21 09:00:26', 'user_003', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_003', '2025-09-21', '2025-09-21 09:00:26', 'S009', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S012', '2025-09-21', '2025-09-21 14:18:02', 'user_020', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_020', '2025-09-21', '2025-09-21 14:18:02', 'S012', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S005', '2025-09-21', '2025-09-21 11:44:55', 'user_023', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_023', '2025-09-21', '2025-09-21 11:44:55', 'S005', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S002', '2025-09-21', '2025-09-21 10:59:16', 'user_022', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_022', '2025-09-21', '2025-09-21 10:59:16', 'S002', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S007', '2025-09-21', '2025-09-21 15:14:41', 'user_004', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_004', '2025-09-21', '2025-09-21 15:14:41', 'S007', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S015', '2025-09-21', '2025-09-21 20:09:04', 'user_009', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_009', '2025-09-21', '2025-09-21 20:09:04', 'S015', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S003', '2025-09-21', '2025-09-21 11:38:47', 'user_026', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_026', '2025-09-21', '2025-09-21 11:38:47', 'S003', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S008', '2025-09-21', '2025-09-21 14:44:19', 'user_004', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_004', '2025-09-21', '2025-09-21 14:44:19', 'S008', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S005', '2025-09-21', '2025-09-21 15:31:28', 'user_017', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_017', '2025-09-21', '2025-09-21 15:31:28', 'S005', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S010', '2025-09-21', '2025-09-21 13:47:20', 'user_002', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_002', '2025-09-21', '2025-09-21 13:47:20', 'S010', 'return');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S001', '2025-09-16', '2025-09-16 17:53:55', 'user_003', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_003', '2025-09-16', '2025-09-16 17:53:55', 'S001', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S013', '2025-09-21', '2025-09-21 11:36:02', 'user_022', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_022', '2025-09-21', '2025-09-21 11:36:02', 'S013', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S008', '2025-09-20', '2025-09-20 14:58:17', 'user_017', 'rent');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_017', '2025-09-20', '2025-09-20 14:58:17', 'S008', 'rent');
APPLY BATCH;

BEGIN BATCH
  INSERT INTO cityflow.station_passages (station_id, day, passage_time, user_id, event_type)
  VALUES ('S010', '2025-09-20', '2025-09-20 20:31:05', 'user_014', 'return');
  INSERT INTO cityflow.user_passages (user_id, day, passage_time, station_id, event_type)
  VALUES ('user_014', '2025-09-20', '2025-09-20 20:31:05', 'S010', 'return');
APPLY BATCH;

-- ── Compteurs daily_station_stats ──

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 3
  WHERE station_id = 'S001' AND day = '2025-09-16';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S001' AND day = '2025-09-17';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 3
  WHERE station_id = 'S001' AND day = '2025-09-18';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 2
  WHERE station_id = 'S001' AND day = '2025-09-19';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S001' AND day = '2025-09-20';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S002' AND day = '2025-09-15';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S002' AND day = '2025-09-16';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S002' AND day = '2025-09-17';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S002' AND day = '2025-09-18';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S002' AND day = '2025-09-19';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S002' AND day = '2025-09-20';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 2
  WHERE station_id = 'S002' AND day = '2025-09-21';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 2
  WHERE station_id = 'S003' AND day = '2025-09-15';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 3
  WHERE station_id = 'S003' AND day = '2025-09-16';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 3
  WHERE station_id = 'S003' AND day = '2025-09-17';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 2
  WHERE station_id = 'S003' AND day = '2025-09-19';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S003' AND day = '2025-09-20';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 4
  WHERE station_id = 'S003' AND day = '2025-09-21';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 4
  WHERE station_id = 'S004' AND day = '2025-09-15';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 5
  WHERE station_id = 'S004' AND day = '2025-09-16';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S004' AND day = '2025-09-17';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S004' AND day = '2025-09-18';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 3
  WHERE station_id = 'S004' AND day = '2025-09-19';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S004' AND day = '2025-09-20';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 3
  WHERE station_id = 'S004' AND day = '2025-09-21';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 3
  WHERE station_id = 'S005' AND day = '2025-09-15';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S005' AND day = '2025-09-17';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 5
  WHERE station_id = 'S005' AND day = '2025-09-18';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 2
  WHERE station_id = 'S005' AND day = '2025-09-20';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 5
  WHERE station_id = 'S005' AND day = '2025-09-21';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S006' AND day = '2025-09-15';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S006' AND day = '2025-09-17';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 2
  WHERE station_id = 'S006' AND day = '2025-09-18';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S006' AND day = '2025-09-20';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S006' AND day = '2025-09-21';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S007' AND day = '2025-09-15';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 3
  WHERE station_id = 'S007' AND day = '2025-09-16';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S007' AND day = '2025-09-17';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 2
  WHERE station_id = 'S007' AND day = '2025-09-18';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 2
  WHERE station_id = 'S007' AND day = '2025-09-19';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 3
  WHERE station_id = 'S007' AND day = '2025-09-20';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S007' AND day = '2025-09-21';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S008' AND day = '2025-09-15';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 2
  WHERE station_id = 'S008' AND day = '2025-09-16';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 2
  WHERE station_id = 'S008' AND day = '2025-09-17';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S008' AND day = '2025-09-18';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 5
  WHERE station_id = 'S008' AND day = '2025-09-19';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 3
  WHERE station_id = 'S008' AND day = '2025-09-20';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 2
  WHERE station_id = 'S008' AND day = '2025-09-21';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 2
  WHERE station_id = 'S009' AND day = '2025-09-15';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 4
  WHERE station_id = 'S009' AND day = '2025-09-16';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 6
  WHERE station_id = 'S009' AND day = '2025-09-17';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S009' AND day = '2025-09-18';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 2
  WHERE station_id = 'S009' AND day = '2025-09-19';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S009' AND day = '2025-09-20';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S009' AND day = '2025-09-21';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 3
  WHERE station_id = 'S010' AND day = '2025-09-15';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 2
  WHERE station_id = 'S010' AND day = '2025-09-16';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S010' AND day = '2025-09-17';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 3
  WHERE station_id = 'S010' AND day = '2025-09-18';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S010' AND day = '2025-09-19';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 4
  WHERE station_id = 'S010' AND day = '2025-09-20';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 3
  WHERE station_id = 'S010' AND day = '2025-09-21';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 2
  WHERE station_id = 'S011' AND day = '2025-09-15';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S011' AND day = '2025-09-16';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 3
  WHERE station_id = 'S011' AND day = '2025-09-17';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 2
  WHERE station_id = 'S011' AND day = '2025-09-18';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S011' AND day = '2025-09-19';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S011' AND day = '2025-09-20';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S011' AND day = '2025-09-21';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 3
  WHERE station_id = 'S012' AND day = '2025-09-15';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S012' AND day = '2025-09-16';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 3
  WHERE station_id = 'S012' AND day = '2025-09-17';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S012' AND day = '2025-09-18';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 3
  WHERE station_id = 'S012' AND day = '2025-09-19';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 4
  WHERE station_id = 'S012' AND day = '2025-09-20';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 2
  WHERE station_id = 'S012' AND day = '2025-09-21';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 4
  WHERE station_id = 'S013' AND day = '2025-09-15';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S013' AND day = '2025-09-16';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 2
  WHERE station_id = 'S013' AND day = '2025-09-18';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 2
  WHERE station_id = 'S013' AND day = '2025-09-19';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 4
  WHERE station_id = 'S013' AND day = '2025-09-20';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 2
  WHERE station_id = 'S013' AND day = '2025-09-21';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S014' AND day = '2025-09-15';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 2
  WHERE station_id = 'S014' AND day = '2025-09-16';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S014' AND day = '2025-09-17';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 3
  WHERE station_id = 'S014' AND day = '2025-09-18';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 3
  WHERE station_id = 'S014' AND day = '2025-09-19';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S014' AND day = '2025-09-20';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S014' AND day = '2025-09-21';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S015' AND day = '2025-09-16';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 3
  WHERE station_id = 'S015' AND day = '2025-09-17';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S015' AND day = '2025-09-18';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S015' AND day = '2025-09-19';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 2
  WHERE station_id = 'S015' AND day = '2025-09-20';
APPLY BATCH;

BEGIN COUNTER BATCH
  UPDATE cityflow.daily_station_stats SET total_passages = total_passages + 1
  WHERE station_id = 'S015' AND day = '2025-09-21';
APPLY BATCH;
