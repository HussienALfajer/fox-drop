# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs.

## Current task

Phase 0, slice 0.5: audit log (`docs/roadmap.md`).

- **Implements:** AP §4.6 (every write action and every sensitive view creates an audit event), AP §9.16 (the event's fields; immutable, enforced in the database), architecture §15.3 (append-only by database permissions), §5.4 (the audit log is partitioned by month), §4.2 (the `audit` module owns it).
- **Branch:** `feat/audit-log`
- **Done when:** the `audit` module records an event with time, actor (user and role), action, target type and id, the before and after values as a diff, reason, IP address and device; sensitive views are events too; the application role can `INSERT` and `SELECT` but never `UPDATE` or `DELETE` the table, proved by a Testcontainers test; other modules write events only through the `audit` module's public service.

## Plan

- [ ] The `audit` schema and table through the `db-migration` skill: UUIDv7 key, `city_id` (nullable for global actions; ask the owner), partitioned by month on the event time, `REVOKE UPDATE` from the application role.
- [ ] The `audit` module's public service: record an event (write action or sensitive view) with its actor, request context (IP address, device) and diff. Ask the owner how the actor is identified before slice 0.7 brings admin accounts.
- [ ] Wire the database into Nest: a provider built from `DATABASE_URL` for the roles that write events, closed on shutdown; the smoke-image job passes a `DATABASE_URL` or starts PostGIS.
- [ ] Testcontainers test: an event recorded and read back, `UPDATE` and `DELETE` refused for the application role, a month partition present for the current month.
- [ ] Folder `CLAUDE.md` for the module, and the pull request with `## Summary` and `## Test plan`, merged with a merge commit once CI passes.

## Notes from earlier slices

- Slice 0.3 added `GET /v1/<group>/status` in the four route groups, open without sign-in (owner decision 2026-11-04). Slice 0.8 brings deny-by-default guards: mark these four routes as public there, or they start answering `401`.
- `pnpm verify` regenerates the API contract first and needs Java 11 or later, and runs the database tests with Testcontainers, so Docker must be running (owner decision 2026-11-04).
- Slice 0.4 left out of `geo.cities` what needs other modules or open items: the base currency (`fx`, open item AP §13 item 4), accepted currencies, the business-day cutoff (a setting, slice 0.6), the office location and desk hours.
- MinIO no longer publishes images: the slice that first stores a file picks the local S3-compatible storage (T7).
- The server's `createDatabase` (`apps/server/src/database/database.ts`) is used only by the migration runner and the test so far; no process role connects at start yet.

## Next

Slice 0.6, settings catalogue (`docs/roadmap.md`).
