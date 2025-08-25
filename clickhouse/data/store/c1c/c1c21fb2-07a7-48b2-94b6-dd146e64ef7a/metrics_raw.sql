ATTACH TABLE _ UUID '1e241e99-7f71-4280-be81-a0ad67f293f1'
(
    `user_id` String,
    `metric` LowCardinality(String),
    `ts` DateTime64(3, 'UTC'),
    `value` Float64,
    `unit` LowCardinality(String),
    `source` LowCardinality(String),
    `device_id` String,
    `day` Date,
    `ingested_at` DateTime64(3, 'UTC') DEFAULT now64(3),
    `ver` UInt64 DEFAULT toUnixTimestamp64Milli(now64(3))
)
ENGINE = ReplacingMergeTree(ver)
PARTITION BY toYYYYMM(day)
ORDER BY (user_id, metric, ts, source, device_id)
SETTINGS index_granularity = 8192
