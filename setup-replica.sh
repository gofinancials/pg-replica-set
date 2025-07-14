#!/bin/bash

echo "Waiting for primary to be ready..."
sleep 10s

echo "Starting basebackup with debug info..."
PGPASSWORD=replicator_password psql -h postgres_primary -U replicator -d gotech -c "SELECT version()" || echo "Direct connection failed"

# Do the basebackup
until PGPASSWORD=replicator_password pg_basebackup -v -U replicator --pgdata=/var/lib/postgresql/data -R --slot=replication_slot --host=postgres_primary --port=5432; do
  echo "Waiting for primary to connect..."
  sleep 5s
done

echo "Backup done, starting PostgreSQL..."
chmod 0700 /var/lib/postgresql/data

# Start PostgreSQL
postgres 