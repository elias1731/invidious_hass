#!/usr/bin/env bash
echo "Starting Invidious Add-on..."

DB_USER=invidious
DB_PASS=invidious
DB_NAME=invidious

mkdir -p /data/db /data/invidious
chown -R postgres:postgres /data/db

if [ ! -f /data/db/PG_VERSION ]; then
  echo "Initializing PostgreSQL..."
  su-exec postgres initdb -D /data/db
  su-exec postgres pg_ctl -D /data/db -o "-c listen_addresses=''" -w start
  psql -U postgres -c "CREATE USER ${DB_USER} WITH PASSWORD '${DB_PASS}';"
  psql -U postgres -c "CREATE DATABASE ${DB_NAME} OWNER ${DB_USER};"
  su-exec postgres pg_ctl -D /data/db -m fast -w stop
fi

su-exec postgres pg_ctl -D /data/db -o "-c listen_addresses='*'" -w start
sleep 3

echo "Launching Invidious..."
docker run --rm \
  --network=host \
  -v /data/invidious:/config \
  -e INVIDIOUS_CONFIG_FILE=/config/config.yml \
  -e DB_USER=${DB_USER} \
  -e DB_PASS=${DB_PASS} \
  -e DB_NAME=${DB_NAME} \
  quay.io/invidious/invidious:latest