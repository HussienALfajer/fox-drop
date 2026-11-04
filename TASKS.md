# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs.

## Current task

Phase 0, slice 0.9: settings edit API (`docs/roadmap.md`).

- **Implements:** AP §9.14 (grouped settings screens: each Appendix A setting with its default, current value, unit and description, and restore default; every change audited, money-impact settings ask for a reason), AP §9.15 last item (the compensation cap per role, editable), AP §14 item 28 (every Appendix A setting editable by the right roles and audited), Appendix A.
- **Branch:** `feat/settings-edit-api`
- **Done when:** an admin reads the settings grouped as in AP §9.14 with default, current value, unit and scope; edits a setting their role may edit, with a reason when it has money impact; resets it to its default; reads its change history; each change audited; a role that may not edit gets `403` and a wrong value `400` (`SettingRefusedError` mapped to HTTP errors); every new route is in the route-access matrix; tests cover each rule.

## Plan

- [ ] Read AP §9.14, §9.15, §14 item 28, Appendix A and `apps/server/src/modules/settings/CLAUDE.md`; ask the owner about anything unclear (such as which group each key belongs to, if Appendix A does not say).
- [ ] The permissions the routes need (`settings.read`, `settings.manage`, `dispatch.switch_mode` already exist) and how a setting's `editRoles` and a permission combine.
- [ ] Grouped read API with defaults, current values, units and scope.
- [ ] Edit and reset API with reasons for money-impact settings, mapping `SettingRefusedError` to HTTP errors.
- [ ] Change history API.
- [ ] The route-access matrix entries, `pnpm generate:api`, folder `CLAUDE.md` rules, and the pull request with `## Summary` and `## Test plan`, merged with a merge commit once CI passes.

## Notes from earlier slices

- Slice 0.3 added `GET /v1/<group>/status` in the four route groups, open without sign-in (owner decision 2026-11-04); slice 0.8 marks them `@Public()`.
- `pnpm verify` regenerates the API contract first and needs Java 11 or later, and runs the database tests with Testcontainers, so Docker must be running (owner decision 2026-11-04).
- Slice 0.4 left out of `geo.cities` what needs other modules or open items: the base currency (`fx`, open item AP §13 item 4), accepted currencies, the office location and desk hours. The business-day cutoff is now the setting `finance.business_day_cutoff`.
- MinIO no longer publishes images: the slice that first stores a file picks the local S3-compatible storage (T7).
- The `audit` module (slice 0.5): record writes with `recordWrite` inside their transaction (`apps/server/src/modules/audit/CLAUDE.md`). The `api` role does not import any database module yet; the first one makes `DATABASE_URL` (and `VALKEY_URL` with `SettingsModule`) required for the OpenAPI generation (`apps/server/scripts/write-openapi.mjs` and `src/http/openapi.test.ts` build the API module) and for the image smoke test, so solve that in the same step.
- Only the `worker` creates the monthly audit partitions (a daily timer until the worker gets pg-boss). A worker down for about a month would make every audited write fail: slice 0.13 (observability) should alert when next month's partition is missing.
- The audit log has no indexes beyond its key; the audit-log list (AP §9.16 filters: actor, action, target, date range) adds them.
- Slice 0.6 added the `settings` module (`apps/server/src/modules/settings/CLAUDE.md`): read `admin.*` with `SettingsService.get`. `AdminRole` in its catalogue must stay equal to `identity.admin_roles` (a test in `admin-team.test.ts`). Owner decision 2026-11-05: the settings with money impact require a reason. Slice 0.9 (settings edit API) maps `SettingRefusedError` to HTTP errors.
- The settings money values are not yet tied to the currency data: `captain.remit_tolerance` takes any currency code, and `currency.<code>.*` takes any three capital letters. The `fx` slice checks them against the city's currencies and base currency (AP §13 item 4).
- No settings change reaches the apps yet; AP §10 (force update, maintenance) needs an event through the outbox when `app.<app>.*` changes.
- `pnpm` on this machine needs `fnm env` in the shell (Git Bash: `eval "$(fnm env --shell bash)"; fnm use`). `pnpm add` and `pnpm install` also fail an engine check that reports Node 99999.0.0; `pnpm --config.engine-strict=false add ...` works around it.
- Slice 0.7 added admin sign-in in the `identity` module (`apps/server/src/modules/identity/CLAUDE.md`). A route that needs a session uses `AdminSessionGuard` and `@CurrentAdminSession()`. The API now needs `IDENTITY_ENCRYPTION_KEY` (32 bytes in base64) besides `DATABASE_URL` and `VALKEY_URL`; the OpenAPI generation uses placeholders (`setOpenApiPlaceholderEnvironment`).
- Slice 0.8 (owner decisions 2026-11-05): the audit actor role is every role held, sorted and joined (`actorRole`, such as `FIN,OPS`); a TOTP reset gives OWN a link where the user enrols again with their current password; no team action may leave the platform without an active OWN, and nobody disables themselves.
- Slice 0.8 made every route declare its access (`@Public()`, `@SignedIn()`, `@RequirePermission()`); `RouteAccessGuard` refuses the rest with `403`. Every new route also goes into the route table of `apps/server/src/modules/identity/admin-team.test.ts`. That test finds routes through the OpenAPI document, so a route hidden from it (`@ApiExcludeEndpoint`) would escape the matrix; read the routes from Fastify if one is ever hidden.
- Slice 0.8 read AP §6.2 in places the owner may want to confirm: OPS holds `restaurants.create`; FIN holds `restaurants.statements` and `captains.money` without the modules' `*.read`; DATA holds no `restaurants.read`. A new migration changes the grants.
- `admin_accounts.roles` is deprecated and empty since migration 0004; a later migration drops it (expand, then contract).
- The first OWN created by the server command has no name (`admin_accounts.name` is null); the command takes no `--name` yet.
- The compensation cap per role, editable on the role matrix screen (AP §9.15), is the settings `support.compensation_cap_pct.*`: slice 0.9 edits them.
- Owner decision 2026-11-05: a locked admin account answers `401` like every other sign-in refusal, never `423`.
- The API has no `trustProxy` yet, so behind Cloudflare and the proxy every session and audit event would record the proxy's IP. The deploy slice sets the trusted hops or reads `CF-Connecting-IP` from a trusted hop, never `trustProxy: true`.
- Sign-in and setup cost an Argon2 hash per request; nothing limits their rate yet. The deploy slice (Cloudflare rate limits, architecture §15.5) or a per-IP limit in Valkey must cover `/v1/admin/auth/*`.
- The session cookie is `__Host-` and `SameSite=Strict`, so the panel and the API must be served from the same site; the panel slice decides the origin (or adds CORS with credentials).

## Next

Slice 0.10, phone sign-in for the apps (`docs/roadmap.md`).
