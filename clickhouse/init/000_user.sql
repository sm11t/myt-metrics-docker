-- Create an app user with a password + basic rights
CREATE USER IF NOT EXISTS myt IDENTIFIED BY 'myt_pw';

GRANT SELECT, INSERT ON myt_metrics.* TO myt;
-- (optional) If you’ll run DDL via the app later:
-- GRANT CREATE, ALTER, DROP ON DATABASE myt_metrics TO myt;
