ATTACH VIEW _ UUID 'be146f18-0dfd-4935-9e12-e92f0cf2318d'
(
    `user_id` String,
    `metric` LowCardinality(String),
    `ts` DateTime64(3, 'UTC'),
    `value` Float64,
    `unit` LowCardinality(String),
    `source` LowCardinality(String),
    `device_id` String,
    `day` Date,
    `ingested_at` DateTime64(3, 'UTC'),
    `ver` UInt64
)
AS SELECT *
FROM myt_metrics.metrics_raw
