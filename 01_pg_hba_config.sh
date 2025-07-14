#!/bin/bash
set -e

# This script will be executed as part of the PostgreSQL container initialization

# First, let's override the pg_hba.conf file in the PGDATA directory
cat > "$PGDATA/pg_hba.conf" << EOF
# TYPE  DATABASE        USER            ADDRESS                 METHOD

# Allow replication from any address with proper credentials
host    replication     replicator      0.0.0.0/0               md5

# "local" is for Unix domain socket connections only
local   all             all                                     md5
# IPv4 local connections:
host    all             all             127.0.0.1/32            md5
# IPv6 local connections:
host    all             all             ::1/128                 md5
# Allow replication connections from localhost
local   replication     all                                     md5
host    replication     all             127.0.0.1/32            md5
host    replication     all             ::1/128                 md5
# Allow all users from any host with proper credentials
host    all             all             0.0.0.0/0               md5
EOF

# Set proper permissions
chmod 600 "$PGDATA/pg_hba.conf"

# Also update postgresql.conf to ensure it loads our pg_hba.conf
echo "hba_file = '$PGDATA/pg_hba.conf'" >> "$PGDATA/postgresql.conf"
echo "password_encryption = 'md5'" >> "$PGDATA/postgresql.conf"

# Notify that the file has been updated
echo "pg_hba.conf has been updated to allow replication connections"
echo "postgresql.conf has been updated to point to our pg_hba.conf"