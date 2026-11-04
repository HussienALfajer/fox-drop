-- Run once per environment by a database administrator, connected to the
-- FOX DROP database, before the first migration, with psql 15 or later:
--   read -rs FOX_DROP_MIGRATOR_PASSWORD; read -rs FOX_DROP_APP_PASSWORD
--   export FOX_DROP_MIGRATOR_PASSWORD FOX_DROP_APP_PASSWORD
--   psql --file bootstrap.sql
-- The passwords come from the environment, so they stay out of the shell
-- history and the process list. Locally, init-development.sh runs it when the
-- container first starts.
--
-- fox_drop_migrator runs the migrations and owns every module schema.
-- fox_drop_app is the role the server connects with: it reads and writes the
-- rows the migrations grant it, and can never change the schema.
\set ON_ERROR_STOP on
\getenv migrator_password FOX_DROP_MIGRATOR_PASSWORD
\getenv app_password FOX_DROP_APP_PASSWORD
\if :{?migrator_password}
\else
  DO $$ BEGIN RAISE EXCEPTION 'FOX_DROP_MIGRATOR_PASSWORD is not set'; END $$;
\endif
\if :{?app_password}
\else
  DO $$ BEGIN RAISE EXCEPTION 'FOX_DROP_APP_PASSWORD is not set'; END $$;
\endif

CREATE ROLE fox_drop_migrator LOGIN PASSWORD :'migrator_password';
CREATE ROLE fox_drop_app LOGIN PASSWORD :'app_password';

SELECT current_database() AS database \gset
REVOKE ALL ON DATABASE :"database" FROM PUBLIC;
GRANT CONNECT, CREATE ON DATABASE :"database" TO fox_drop_migrator;
GRANT CONNECT ON DATABASE :"database" TO fox_drop_app;

-- PostGIS lives in public and needs a superuser to install. Nothing else
-- goes there: each module creates its own schema.
CREATE EXTENSION IF NOT EXISTS postgis;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT USAGE ON SCHEMA public TO fox_drop_migrator, fox_drop_app;
