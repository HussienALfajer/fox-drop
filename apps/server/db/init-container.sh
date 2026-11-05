#!/bin/sh
# Runs inside the postgis container on the first start of an empty data
# directory (docker-entrypoint-initdb.d), for compose.yaml and the database tests.
# The entrypoint may source this file instead of running it, so it sets no
# shell options; each psql call stops on the first error and so does the entrypoint.
#
# The image's own 10_postgis.sh also installs topology and the tiger geocoder,
# which change the search path. Production has PostGIS only (bootstrap.sql),
# so remove them first: what passes here must pass there.
psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" --set ON_ERROR_STOP=on <<'EOSQL'
DROP EXTENSION IF EXISTS postgis_tiger_geocoder, postgis_topology, fuzzystrmatch CASCADE;
DROP SCHEMA IF EXISTS tiger, tiger_data, topology CASCADE;
SELECT current_database() AS database \gset
ALTER DATABASE :"database" RESET search_path;
EOSQL
# bootstrap.sql reads FOX_DROP_MIGRATOR_PASSWORD and FOX_DROP_APP_PASSWORD
# from the container environment.
psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" --file /fox-drop/bootstrap.sql
