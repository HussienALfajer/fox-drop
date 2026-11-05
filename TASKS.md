# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs.

## Current task

Phase 0, slice 0.10: phone sign-in for the apps, server side (`docs/roadmap.md`).

- **Implements:** architecture §8.3.1 (the `CodeSender` port; V1's adapter runs in the `otp-sender` process; a development-only sender here), §8.3.2 (6-digit code, stored hashed with number, device and expiry, compared in constant time, one active code per number, `otp.validity_min`, `otp.max_attempts`, `otp.resend_after_sec`, the same answer whether the number has an account or not), §15.1 (15-minute JWT access tokens signed with a rotating key, refresh tokens stored hashed, rotated on every use and revoked on reuse; blocking, closing or forced sign-out revokes them all), the request limits of Appendix A (`otp.number_hourly_max`, `otp.number_daily_max`, `otp.device_daily_max`, `otp.ip_hourly_max`) in Valkey, devices, sign out everywhere.
- **Branch:** `feat/app-phone-sign-in`
- **Done when:** a phone requests a code and signs in with it, getting an access and a refresh token; every code rule and request limit is enforced and tested; a refresh token rotates and its reuse revokes the family; sign out everywhere revokes every refresh token; the development sender never runs outside development; every new route is in the route-access matrix; tests cover each rule.

## Plan

- [ ] Read architecture §8.3–8.3.4, §15.1, §4.4 (the `otp-sender` role), the sign-in sections of the three app specs (CU §5, RA §5.2, CA §4.9) and `apps/server/src/modules/identity/CLAUDE.md`; ask the owner what the specs leave open (such as which app routes this slice serves, the JWT key rotation period and where the keys live, and whether the customer, merchant and captain accounts are one table or three).
- [ ] The `CodeSender` port and the development-only sender, and the queue to the `otp-sender` role (or a direct call until pg-boss arrives, if the owner agrees).
- [ ] Codes: request and verify, with the code rules and the Valkey request limits (failing test first).
- [ ] Access and refresh tokens, rotation, reuse detection, devices and sign out everywhere (failing test first).
- [ ] The app route guard (`RouteAccessGuard` serves only the admin group so far), the route-access matrix entries, `pnpm generate:api`, folder `CLAUDE.md` rules, and the pull request with `## Summary` and `## Test plan`, merged with a merge commit once CI passes.

## Notes from earlier slices

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
- The session cookie is `__Host-` and `SameSite=Strict`, so the panel and the API must be served from the same site; the panel slice decides the origin (or adds CORS with credentials).

## Next

Slice 0.11, web app shells, unstyled (`docs/roadmap.md`).
