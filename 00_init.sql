-- Create replication user with proper permissions (using MD5)
CREATE USER replicator WITH REPLICATION PASSWORD 'replicator_password';

-- Create physical replication slot
SELECT pg_create_physical_replication_slot('replication_slot');

-- Grant necessary permissions
ALTER USER replicator WITH LOGIN;

-- Create gotech schema and grant permissions
CREATE SCHEMA IF NOT EXISTS gotech;
GRANT ALL ON SCHEMA gotech TO gotech;
GRANT ALL ON ALL TABLES IN SCHEMA gotech TO gotech;
ALTER DEFAULT PRIVILEGES IN SCHEMA gotech GRANT ALL ON TABLES TO gotech;

-- Grant schema permissions to replicator
GRANT USAGE ON SCHEMA gotech TO replicator;
GRANT SELECT ON ALL TABLES IN SCHEMA gotech TO replicator;
ALTER DEFAULT PRIVILEGES IN SCHEMA gotech GRANT SELECT ON TABLES TO replicator;

-- For debugging purposes, let's check the current authentication settings
\echo 'Current authentication settings:'
\du
\echo 'Replication slots:'
SELECT * FROM pg_replication_slots;