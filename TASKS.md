# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs.

## Current task

Phase 0, slice 0.12: Flutter app shells, unstyled (`docs/roadmap.md`).

- **Implements:** architecture §11.1 (pub workspace and Melos, the three apps and their platforms: `apps/merchant` Android and Windows, `apps/captain` and `apps/customer` Android and iOS, one pinned Flutter), §11.2 (`core_l10n`: Arabic ARB files, Western digits), §11.3 (Riverpod, go_router), AP §4.7 and the Arabic right-to-left rule of `CLAUDE.md`.
- **Branch:** `feat/flutter-app-shells`
- **Done when:** the three apps build and run an unstyled Arabic RTL screen through go_router and Riverpod, call `GET /v1/<group>/status` through the generated `core_api` client, keep every user-facing string in `core_l10n` ARB files with Western digits, and pass analyze and widget tests inside `pnpm verify` and CI; no `core_ui`, theme or styling (the design stop); Flutter rules for Claude in the apps' `CLAUDE.md`.

## Plan

- [ ] Read architecture §11, §18.3, §19, `packages/core_api` and the root `CLAUDE.md`; ask the owner what the specs leave open (such as the app IDs and package names, the API address each app uses in development on an emulator and a device, and whether flavors start now or with the deploy slice).
- [ ] `packages/core_l10n`: Arabic ARB files, generated localizations, Western digits, with a test.
- [ ] `apps/customer`: Flutter app (Android, iOS), go_router, Riverpod, the `core_api` client calling `/v1/customer/status`, a widget test.
- [ ] `apps/captain` (Android, iOS) and `apps/merchant` (Android, Windows): the same shell on their route groups.
- [ ] Melos and `pnpm verify` wiring, CI, the Flutter rules in `CLAUDE.md`, the pull request with `## Summary` and `## Test plan`, merged with a merge commit once CI passes.

## Notes from earlier slices

- Slice 0.11 added the web app shells (`apps/admin/CLAUDE.md`): the panel on port 5173 and the portal on 5174 in development, the shared web lint rules in `eslint.web.mjs`, and a Playwright smoke test against `vite preview` with a fake API in `pnpm verify` and CI (owner decisions 2026-11-05).
- The deploy slice must serve each web app's `index.html` for every unknown path outside `/v1` (browser history routing), or a reload on a deep link answers 404.
- The panel's Arabic name «لوحة الإدارة» and the portal's «بوابة المطعم» are the spec terms (AP component table, RA §17); they are placeholders until the design.
- i18next formats interpolated numbers and dates with its `lng`, `ar`, which gives Arabic-Indic digits: the first translation that formats a value sets an `ar-u-nu-latn` formatter (AP §4.7).

- Slice 0.10 added app phone sign-in (`apps/server/src/modules/identity/CLAUDE.md`), customer routes only (owner decisions 2026-11-05: one engine over the app party, one account table per party, JWT keys in the database rotated every 30 days, a direct call to the development sender until the WhatsApp sender arrives). The restaurant and captain apps add a party, their account table and routes on the same engine. Outside `FOX_DROP_ENVIRONMENT=development` every code request answers `503` until the real sender exists.
- The app code request limits key on the request IP. Without `trustProxy` set for the real proxy hops, every user shares the proxy's IP and the platform gets `otp.ip_hourly_max` (30) code requests per hour: the deploy slice must set the trusted hop before anyone signs in on staging.
- A refresh may be retried with the same token for 10 seconds (owner decision 2026-11-05, architecture §15.1). The apps must still send one refresh at a time and keep the newest answer: a token replaced by a retry ends the session when presented.
- The code is sent before the transaction commits (a direct call). When the `otp-sender` queue arrives, the send request goes through the outbox in the same transaction (E3, E4).
- `identity.app_refresh_tokens` gains a row per refresh (about 96 a day per active device) and the application role cannot delete; plan partitions or a migrator-run purge of ended families before launch.

- Slice 0.3 added `GET /v1/<group>/status` in the four route groups, open without sign-in (owner decision 2026-11-04); slice 0.8 marks them `@Public()`.
- `pnpm verify` regenerates the API contract first and needs Java 11 or later, and runs the database tests with Testcontainers, so Docker must be running (owner decision 2026-11-04).
- Slice 0.4 left out of `geo.cities` what needs other modules or open items: the base currency (`fx`, open item AP §13 item 4), accepted currencies, the office location and desk hours. The business-day cutoff is now the setting `finance.business_day_cutoff`.
- MinIO no longer publishes images: the slice that first stores a file picks the local S3-compatible storage (T7).
- The `audit` module (slice 0.5): record writes with `recordWrite` inside their transaction (`apps/server/src/modules/audit/CLAUDE.md`). The `api` role does not import any database module yet; the first one makes `DATABASE_URL` (and `VALKEY_URL` with `SettingsModule`) required for the OpenAPI generation (`apps/server/scripts/write-openapi.mjs` and `src/http/openapi.test.ts` build the API module) and for the image smoke test, so solve that in the same step.
- Only the `worker` creates the monthly audit partitions (a daily timer until the worker gets pg-boss). A worker down for about a month would make every audited write fail: slice 0.13 (observability) should alert when next month's partition is missing.
- The audit log has no indexes beyond its key; the audit-log list (AP §9.16 filters: actor, action, target, date range) adds them.
- Slice 0.6 added the `settings` module (`apps/server/src/modules/settings/CLAUDE.md`): read `admin.*` with `SettingsService.get`. `AdminRole` in its catalogue must stay equal to `identity.admin_roles` (a test in `admin-team.test.ts`). Owner decision 2026-11-05: the settings with money impact require a reason.
- Slice 0.9 added the settings routes `/v1/admin/settings` (owner decisions 2026-11-05: groups by key prefix; the Appendix A edit roles decide who reads and edits each key, so OPS sees only `dispatch.mode` and FIN only `currency.<code>.*`; a currency key is also listed with no currency, the panel's «أضف عملة»). The compensation cap per role is `support.compensation_cap_pct.*` on these routes; the role matrix screen of AP §9.15 calls them.
- The settings accept any well-formed city UUID: `geo` has no public service yet. When it gets one, `SettingsService.resolve` and `list` check that the city exists.
- A settings change answers with the setting read after its transaction, so a concurrent edit could show the other editor's value; return the saved state from `update` and `reset` if it ever matters.
- The settings money values are not yet tied to the currency data: `captain.remit_tolerance` takes any currency code, and `currency.<code>.*` takes any three capital letters. The `fx` slice checks them against the city's currencies and base currency (AP §13 item 4).
- No settings change reaches the apps yet; AP §10 (force update, maintenance) needs an event through the outbox when `app.<app>.*` changes.
- `pnpm` on this machine needs `fnm env` in the shell (Git Bash: `eval "$(fnm env --shell bash)"; fnm use`). `pnpm add` and `pnpm install` also fail an engine check that reports Node 99999.0.0; `pnpm --config.engine-strict=false add ...` works around it.
- Slice 0.7 added admin sign-in in the `identity` module (`apps/server/src/modules/identity/CLAUDE.md`). The access decorators (`@Public()`, `@SignedIn()`, `@RequirePermission()`, `@CurrentAdminSession()`) and `requestContext` live in `apps/server/src/http/` since slice 0.9, so the settings module, which identity imports, can use them. The API now needs `IDENTITY_ENCRYPTION_KEY` (32 bytes in base64) besides `DATABASE_URL` and `VALKEY_URL`; the OpenAPI generation uses placeholders (`setOpenApiPlaceholderEnvironment`).
- Slice 0.8 (owner decisions 2026-11-05): the audit actor role is every role held, sorted and joined (`actorRole`, such as `FIN,OPS`); a TOTP reset gives OWN a link where the user enrols again with their current password; no team action may leave the platform without an active OWN, and nobody disables themselves.
- Slice 0.8 made every route declare its access (`@Public()`, `@SignedIn()`, `@RequirePermission()`); `RouteAccessGuard` refuses the rest with `403`. Every new route also goes into the route table of `apps/server/src/modules/identity/admin-team.test.ts`. That test finds routes through the OpenAPI document, so a route hidden from it (`@ApiExcludeEndpoint`) would escape the matrix; read the routes from Fastify if one is ever hidden.
- Slice 0.8 read AP §6.2 in places the owner may want to confirm: OPS holds `restaurants.create`; FIN holds `restaurants.statements` and `captains.money` without the modules' `*.read`; DATA holds no `restaurants.read`. A new migration changes the grants.
- `admin_accounts.roles` is deprecated and empty since migration 0004; a later migration drops it (expand, then contract).
- The first OWN created by the server command has no name (`admin_accounts.name` is null); the command takes no `--name` yet.
- Owner decision 2026-11-05: a locked admin account answers `401` like every other sign-in refusal, never `423`.
- The API has no `trustProxy` yet, so behind Cloudflare and the proxy every session and audit event would record the proxy's IP. The deploy slice sets the trusted hops or reads `CF-Connecting-IP` from a trusted hop, never `trustProxy: true`.
- Sign-in and setup cost an Argon2 hash per request; nothing limits their rate yet. The deploy slice (Cloudflare rate limits, architecture §15.5) or a per-IP limit in Valkey must cover `/v1/admin/auth/*`.
- The session cookie is `__Host-` and `SameSite=Strict`. Owner decision 2026-11-05: the panel and the portal call `/v1` on their own origin; Vite forwards it to the server in development, and the deploy slice routes `/v1` on each web app's host to the API. Development sign-in relies on the browser accepting a `Secure` cookie over `http://localhost` (Chrome, Edge and Firefox do).

## Next

Slice 0.13, the hosting decision (docs) (`docs/roadmap.md`).
