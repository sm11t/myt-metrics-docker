-- convenience view: quick counting by metric
CREATE OR REPLACE VIEW myt_metrics.v_metric_counts AS
SELECT metric, count() AS cnt
FROM myt_metrics.myt_metrics_raw
GROUP BY metric
ORDER BY metric;
