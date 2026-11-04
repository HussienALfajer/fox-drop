# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs.

## Current task

Phase 0, slice 0.6: settings catalogue, server side (`docs/roadmap.md`).

- **Implements:** AP §4.4 (typed values with a default, a scope and edit roles; every change records the old and new value, editor, time and optional reason; immediate effect unless effective-dated; reset to default), AP Appendix A (every key), architecture §5.7 (settings cached in Valkey).
- **Branch:** `feat/settings-catalogue`
- **Done when:** every Appendix A key is in a typed catalogue with its default, scope (global or city) and edit roles; stored values override the default per scope; a change keeps its history and is audited through the `audit` module in the same transaction; reads are cached in Valkey and the cache is dropped on change; reset to default works; tests cover the types, scopes, history and cache.

## Plan

- [ ] Read Appendix A and list each key's type; ask the owner about any key whose type, default or scope is unclear, and about values marked "Before launch".
- [ ] The `settings` schema through the `db-migration` skill: stored values (key, city or global, value, effective date where needed) and the change history.
- [x] The catalogue in code: each key with its type (duration, percentage, money, count, enum, boolean, text, schedule), default, scope and edit roles, with a test that it lists every Appendix A key.
- [ ] The `settings` module's public service: read with the Valkey cache, change with history and an audit event in one transaction, reset to default, refusal for a role that may not edit.
- [ ] Valkey wiring in Nest (`VALKEY_URL`), closed on shutdown; a Testcontainers test for the cache.
- [ ] Folder `CLAUDE.md` for the module, and the pull request with `## Summary` and `## Test plan`, merged with a merge commit once CI passes.

## Notes from earlier slices

- Slice 0.3 added `GET /v1/<group>/status` in the four route groups, open without sign-in (owner decision 2026-11-04). Slice 0.8 brings deny-by-default guards: mark these four routes as public there, or they start answering `401`.
- `pnpm verify` regenerates the API contract first and needs Java 11 or later, and runs the database tests with Testcontainers, so Docker must be running (owner decision 2026-11-04).
- Slice 0.4 left out of `geo.cities` what needs other modules or open items: the base currency (`fx`, open item AP §13 item 4), accepted currencies, the business-day cutoff (a setting, slice 0.6), the office location and desk hours.
- MinIO no longer publishes images: the slice that first stores a file picks the local S3-compatible storage (T7).
- Slice 0.5 added the `audit` module (AP D27, D28). The settings changes of 0.6 are its first callers: import `AuditModule` where the change is made and call `recordWrite` inside the change's transaction (`apps/server/src/modules/audit/CLAUDE.md`). The `api` role does not import any database module yet; the first one makes `DATABASE_URL` required for the OpenAPI generation too (`apps/server/scripts/write-openapi.mjs` and `src/http/openapi.test.ts` build the API module), so solve that in the same step.
- Only the `worker` creates the monthly audit partitions (a daily timer until the worker gets pg-boss). A worker down for about a month would make every audited write fail: slice 0.13 (observability) should alert when next month's partition is missing.
- The audit log has no indexes beyond its key; the audit-log list (AP §9.16 filters: actor, action, target, date range) adds them.
- `pnpm` on this machine needs `fnm env` in the shell; the `checker` agent failed to start `pnpm verify` without it.

## Next

Slice 0.7, admin accounts and sign-in (`docs/roadmap.md`).
