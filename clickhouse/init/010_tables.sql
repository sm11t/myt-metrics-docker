-- raw timeseries rows (one row per reading)
CREATE TABLE IF NOT EXISTS myt_metrics.myt_metrics_raw
(
  user_id String,
  metric LowCardinality(String),              -- e.g. 'heart_rate', 'spo2', 'hrv_rmssd'
  ts DateTime64(3, 'UTC'),                    -- UTC millisecond precision
  value Float64,
  unit LowCardinality(String),                -- 'bpm', '%', 'ms', etc.
  source LowCardinality(String),              -- 'apple_health', 'google_fit', 'demo'
  device_id String,
  day Date,                                   -- denormalized for fast partitions (UTC day)
  _ingested_at DateTime DEFAULT now(),
  _ver UInt64 DEFAULT 1                       -- for dedup via ReplacingMergeTree
)
ENGINE = ReplacingMergeTree(_ver)
PARTITION BY toYYYYMM(day)
ORDER BY (user_id, metric, ts, source, device_id)
SETTINGS index_granularity = 8192;

-- (Optional) compact rollup if you want minute-avg later; safe to keep commented for now
-- CREATE TABLE IF NOT EXISTS myt_metrics.myt_metrics_minute
-- (
--   user_id String,
--   metric LowCardinality(String),
--   minute DateTime('UTC'),     -- floored-to-minute
--   avg_value Float64,
--   unit LowCardinality(String),
--   source LowCardinality(String),
--   device_id String,
--   day Date
-- )
-- ENGINE = MergeTree
-- PARTITION BY toYYYYMM(day)
-- ORDER BY (user_id, metric, minute);
