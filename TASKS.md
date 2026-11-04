# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs.

## Current task

Phase 0, slice 0.4: local environment and database (`docs/roadmap.md`).

- **Implements:** architecture §5.2 (UUIDv7 keys, `city_id` on business records, `timestamptz` in UTC, money as `bigint` minor units with a currency code, E.164 phones, no deletes), §5.4 (PostgreSQL with PostGIS), §17.1 (`development` with Docker Compose: PostGIS, Valkey, Centrifugo, MinIO; OSRM waits for its first use in Phase 1), AP §1.3 item 6 (cities from day one, Azaz first), architecture §4.3 (each module owns its schema).
- **Branch:** `feat/local-database`
- **Done when:** `docker compose up` starts the local services; migrations run with a migration role and the server connects with an application role that cannot change the schema; the `cities` table holds the Azaz seed; a Testcontainers test runs the migrations on a fresh database inside `pnpm verify`; `.env.example` holds fake values only.

## Plan

- [ ] Docker Compose for development: PostGIS, Valkey, Centrifugo, MinIO, with pinned image versions and `.env.example`.
- [ ] Drizzle with SQL migration files, one PostgreSQL schema per module, separate migration and application roles with their grants.
- [ ] UUIDv7 primary keys and the first table: cities with the Azaz seed (AP §1.3 item 6). Ask the owner which module owns it if the specs do not say.
- [ ] Testcontainers test: migrations on a fresh PostGIS, the application role refused a schema change, the seed present. Decide with the owner whether CI runs it in `pnpm verify` (it needs Docker).
- [ ] `db-migration` skill and the folder `CLAUDE.md` for the database code.
- [ ] Pull request with `## Summary` and `## Test plan`, merged with a merge commit once CI passes.

## Notes from earlier slices

- Slice 0.3 added `GET /v1/<group>/status` in the four route groups, open without sign-in (owner decision 2026-11-04). Slice 0.8 brings deny-by-default guards: mark these four routes as public there, or they start answering `401`.
- `pnpm verify` regenerates the API contract first and needs Java 11 or later.

## Next

Slice 0.5, audit log (`docs/roadmap.md`).
