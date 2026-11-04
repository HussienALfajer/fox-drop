#!/bin/sh
# Runs inside the postgis container on the first start of an empty data
# directory (docker-entrypoint-initdb.d), for compose.yaml and the database tests.
# The entrypoint may source this file instead of running it, so it sets no
# shell options; bootstrap.sql stops on the first error and so does the entrypoint.
psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" \
  --set migrator_password="$FOX_DROP_MIGRATOR_PASSWORD" \
  --set app_password="$FOX_DROP_APP_PASSWORD" \
  --file /fox-drop/bootstrap.sql
