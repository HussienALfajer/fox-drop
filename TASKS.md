# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs.

## Current task

Phase 0, slice 0.8: roles, permissions and admin team API (`docs/roadmap.md`).

- **Implements:** AP §6.1 (five fixed roles OWN, OPS, SUP, FIN, DATA; permissions stored as data; a user holds one or more roles and gets their union), AP §6.2 and §6.3 (the module access matrix and the special permissions), AP §5.2 last item and §5.3 (OWN sees every open session and forces a user out of all of them; creates a user with a setup link, changes roles, disables a user, ending their sessions at once, resets a user's TOTP), AP §9.15 (the admin team screen's API), AP §14 items 1–2, architecture §15.2 (guards on every route, the UI hides and the server enforces; a test calls every forbidden route for every role).
- **Branch:** `feat/admin-roles`
- **Done when:** roles and permissions are rows, not code; every admin route is denied unless it names its permission, and a test matrix calls every admin route with every role; a user with two roles gets the union; OWN can list users and open sessions, create a user and get its setup link, change roles, disable a user (sessions end at once), reset TOTP (enrolment again at the next sign-in) and force a sign-out everywhere, each audited; tests cover each rule.

## Plan

- [ ] Read AP §6, §5.2–5.3, §9.15, §14 items 1–2 and architecture §15.2; ask the owner about anything unclear (how the audit records the role of a user with several roles; whether a locked account keeps answering `423`, see the notes).
- [ ] Roles and permissions as data through the `db-migration` skill: the five roles, the permissions of AP §6.2–6.3, and the account's roles as references; keep `AdminRole` in the settings catalogue in step with them.
- [ ] Deny-by-default guards for the admin group: a route names its permission or is marked public. Public: the four `GET /v1/<group>/status` routes and `POST /v1/admin/auth/sign-in`, `setup/totp` and `setup/complete`.
- [ ] The test matrix: every admin route with every role, and the union of two roles.
- [ ] The admin team API (AP §9.15): list users and their open sessions, create a user with a setup link, change roles, disable, reset TOTP, force sign-out everywhere, each audited, with tests.
- [ ] Folder `CLAUDE.md` rules, `pnpm generate:api`, and the pull request with `## Summary` and `## Test plan`, merged with a merge commit once CI passes.

## Notes from earlier slices

- Slice 0.3 added `GET /v1/<group>/status` in the four route groups, open without sign-in (owner decision 2026-11-04). Slice 0.8 brings deny-by-default guards: mark these four routes as public there, or they start answering `401`.
- `pnpm verify` regenerates the API contract first and needs Java 11 or later, and runs the database tests with Testcontainers, so Docker must be running (owner decision 2026-11-04).
- Slice 0.4 left out of `geo.cities` what needs other modules or open items: the base currency (`fx`, open item AP §13 item 4), accepted currencies, the office location and desk hours. The business-day cutoff is now the setting `finance.business_day_cutoff`.
- MinIO no longer publishes images: the slice that first stores a file picks the local S3-compatible storage (T7).
- The `audit` module (slice 0.5): record writes with `recordWrite` inside their transaction (`apps/server/src/modules/audit/CLAUDE.md`). The `api` role does not import any database module yet; the first one makes `DATABASE_URL` (and `VALKEY_URL` with `SettingsModule`) required for the OpenAPI generation (`apps/server/scripts/write-openapi.mjs` and `src/http/openapi.test.ts` build the API module) and for the image smoke test, so solve that in the same step.
- Only the `worker` creates the monthly audit partitions (a daily timer until the worker gets pg-boss). A worker down for about a month would make every audited write fail: slice 0.13 (observability) should alert when next month's partition is missing.
- The audit log has no indexes beyond its key; the audit-log list (AP §9.16 filters: actor, action, target, date range) adds them.
- Slice 0.6 added the `settings` module (`apps/server/src/modules/settings/CLAUDE.md`): read `admin.*` with `SettingsService.get`. `AdminRole` lives in its catalogue until slice 0.8 stores the roles as data. Owner decision 2026-11-05: the settings with money impact require a reason. Slice 0.9 (settings edit API) maps `SettingRefusedError` to HTTP errors.
- The settings money values are not yet tied to the currency data: `captain.remit_tolerance` takes any currency code, and `currency.<code>.*` takes any three capital letters. The `fx` slice checks them against the city's currencies and base currency (AP §13 item 4).
- No settings change reaches the apps yet; AP §10 (force update, maintenance) needs an event through the outbox when `app.<app>.*` changes.
- `pnpm` on this machine needs `fnm env` in the shell (Git Bash: `eval "$(fnm env --shell bash)"; fnm use`). `pnpm add` and `pnpm install` also fail an engine check that reports Node 99999.0.0; `pnpm --config.engine-strict=false add ...` works around it.
- Slice 0.7 added admin sign-in in the `identity` module (`apps/server/src/modules/identity/CLAUDE.md`). A route that needs a session uses `AdminSessionGuard` and `@CurrentAdminSession()`. The API now needs `IDENTITY_ENCRYPTION_KEY` (32 bytes in base64) besides `DATABASE_URL` and `VALKEY_URL`; the OpenAPI generation uses placeholders (`setOpenApiPlaceholderEnvironment`).
- The audit actor role of an admin is `roles.join(',')` (such as `OPS,FIN`) until slice 0.8 decides how a user with several roles is recorded.
- A locked account answers `423` and anything else `401`, so five wrong attempts show whether a sign-in name has an account. AP §5.1 does not require showing the lock: owner's decision pending (raised 2026-11-05).
- The API has no `trustProxy` yet, so behind Cloudflare and the proxy every session and audit event would record the proxy's IP. The deploy slice sets the trusted hops or reads `CF-Connecting-IP` from a trusted hop, never `trustProxy: true`.
- Sign-in and setup cost an Argon2 hash per request; nothing limits their rate yet. The deploy slice (Cloudflare rate limits, architecture §15.5) or a per-IP limit in Valkey must cover `/v1/admin/auth/*`.
- The session cookie is `__Host-` and `SameSite=Strict`, so the panel and the API must be served from the same site; the panel slice decides the origin (or adds CORS with credentials).

## Next

Slice 0.9, settings edit API (`docs/roadmap.md`).
