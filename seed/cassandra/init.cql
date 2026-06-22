-- ============================================================
-- CityFlow — Cassandra seed script
-- Keyspaces : tp_cassandra (apprentissage) + cityflow (projet)
-- ============================================================

CREATE KEYSPACE IF NOT EXISTS tp_cassandra
WITH replication = {
    'class': 'SimpleStrategy',
    'replication_factor': 1
};

CREATE TABLE IF NOT EXISTS tp_cassandra.users (
    user_id    uuid PRIMARY KEY,
    email      text,
    first_name text,
    last_name  text,
    age        int,
    city       text,
    created_at timestamp,
    tags       set<text>
);

CREATE KEYSPACE IF NOT EXISTS cityflow
WITH replication = {
    'class': 'SimpleStrategy',
    'replication_factor': 1
};

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

CREATE TABLE IF NOT EXISTS cityflow.station_passages_by_event (
    station_id   text,
    day          date,
    event_type   text,
    passage_time timestamp,
    user_id      text,
    PRIMARY KEY ((station_id, day, event_type), passage_time)
) WITH CLUSTERING ORDER BY (passage_time DESC);
