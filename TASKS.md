# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs.

## Current task

Phase 0, slice 0.14: staging on Contabo (`docs/roadmap.md`).

- **Implements:** architecture §17.2 and §17.3 (hosting and deployment, T9), §15.4 and §15.5 (secrets and edge protection), §16 (error tracking through FOX DROP's domain), E8.
- **Branch:** `chore/staging-deploy`
- **Done when:** a merge to `main` builds the images, pushes them to the GitHub container registry and deploys the staging Compose project on the owner's Contabo server over SSH; staging runs as its own system user, Compose project, database and environment file, with every container on `127.0.0.1` or a Docker network only; nginx serves the panel and the portal with `index.html` for unknown paths outside `/v1`, routes `/v1` on each web app's host to the API, and limits the sign-in routes per IP; the API trusts exactly one proxy hop; migrations run before the new version starts; the database is backed up off the server; server errors reach Sentry; a `deploy` skill explains the deploy and the rollback; `pnpm verify` passes.

## Plan

Owner decisions 2026-11-05: staging on sslip.io names until the domain is bought; off-server backups to Backblaze B2; the owner creates the Sentry account and puts the DSN on the server; GitHub Actions deploys with a key whose `command=` allows only `infra/server/deploy-ssh.sh`.

- [x] Read `/root/SERVER.md` on the server (the `vertex-server` skill) and architecture §15, §16 and §17; ask the owner what is still open: the staging host names while the domain is not bought, the off-server backup destination, the Sentry account, and the deploy user's access.
- [x] Add the production images and the staging Compose file in `infra/`.
- [x] Add the nginx site, TLS and the per-IP limits, and set the API's trusted proxy hop.
- [x] Add the GitHub Actions deploy job, the migrations step and the server-side environment file.
- [x] Add the off-server database backup and the Sentry error tracking on the server.
- [ ] Provision staging on the server (`infra/server/provision.sh`).
- [ ] Add the `deploy` skill; pull request with `## Summary` and `## Test plan`, merged with a merge commit once CI passes.

## Notes from earlier slices

- Slice 0.13 recorded T9 (architecture §2; owner decisions 2026-11-05): staging and production both run on the owner's shared Contabo server (`vertex-server` skill) as Docker Compose projects behind its nginx, with no Cloudflare, no CDN, no Kamal, no Terraform and no Doppler; PostgreSQL, Valkey and an S3-compatible storage run as containers; secrets live in an environment file on the server; the apps reach Sentry and PostHog only through a relay on FOX DROP's domain. The domain is not bought yet.
- The server already runs other sites with their own PostgreSQL and Redis; FOX DROP never uses them. Docker bypasses `ufw`, so never publish a port on `0.0.0.0` (`/root/SERVER.md`).
- Architecture §22 item 9: the owner checks Firebase Cloud Messaging, App Check and the store installs on phones in Azaz before launch; item 10 records the shared-server risk.

- Slice 0.12 added the Flutter app shells (`apps/customer/CLAUDE.md`, `packages/core_l10n/CLAUDE.md`; owner decisions 2026-11-05): app IDs `com.foxdrop.customer`, `.captain` and `.merchant`; the launcher names «تطبيق الزبون», «تطبيق الكابتن» and «تطبيق المطعم», placeholders until the design; a debug build reaches the server at `10.0.2.2:3000` on the Android emulator and `localhost:3000` elsewhere, or at `--dart-define=API_BASE_URL`; a release build refuses to start without it.
- The deploy slice adds the flavors (development, staging, production; architecture §11.4) with their app ID suffix and API address, and the release slice the signing keys: every Android release build is still signed with the debug key (`android/app/build.gradle.kts`), so none may be distributed.
- iOS allows plain HTTP to the local network in every build (`NSAllowsLocalNetworking` in `Info.plist`); the flavors slice moves it into a debug-only configuration, as Android does with its debug manifest.
- CI analyzes and tests the apps but builds none of them; the three Android APKs and the Windows app were built by hand on 2026-11-05, and iOS was not built (no Mac). The release pipeline (architecture §11.4) adds the builds.
- The Flutter SDK pins `test_api` and `intl`, so `test` (1.31.1), `build_runner` (2.16.1) and `intl` (0.20.3) move with Flutter (`renovate.json`, `packages/core_api/CLAUDE.md`).
- In this sandbox the Dart analysis server crashes when its usage report to Google Analytics is blocked; `CI=true` turns the report off (`CI=true pnpm verify`).

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
- MinIO no longer publishes images: the slice that first stores a file picks the S3-compatible storage (T7), the same software on the server (T9, architecture §5.8).
- The `audit` module (slice 0.5): record writes with `recordWrite` inside their transaction (`apps/server/src/modules/audit/CLAUDE.md`). The `api` role does not import any database module yet; the first one makes `DATABASE_URL` (and `VALKEY_URL` with `SettingsModule`) required for the OpenAPI generation (`apps/server/scripts/write-openapi.mjs` and `src/http/openapi.test.ts` build the API module) and for the image smoke test, so solve that in the same step.
- Only the `worker` creates the monthly audit partitions (a daily timer until the worker gets pg-boss). A worker down for about a month would make every audited write fail: the observability slice should alert when next month's partition is missing.
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
- The API has no `trustProxy` yet, so behind nginx every session and audit event would record the proxy's IP. The deploy slice makes nginx replace `X-Forwarded-For` with the client address and the API trust exactly that one hop, never `trustProxy: true` (architecture §15.5).
- Sign-in and setup cost an Argon2 hash per request; nothing limits their rate yet. The deploy slice's per-IP limits in nginx (architecture §15.5), or a per-IP limit in Valkey, must cover `/v1/admin/auth/*`.
- The session cookie is `__Host-` and `SameSite=Strict`. Owner decision 2026-11-05: the panel and the portal call `/v1` on their own origin; Vite forwards it to the server in development, and the deploy slice routes `/v1` on each web app's host to the API. Development sign-in relies on the browser accepting a `Secure` cookie over `http://localhost` (Chrome, Edge and Firefox do).

## Next

Slice 0.15 is not on the roadmap yet: after 0.14, Phase 0 waits for the owner's answer on the design system and for the real WhatsApp sender (`docs/roadmap.md`).
