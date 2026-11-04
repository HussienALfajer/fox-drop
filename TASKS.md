# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs.

## Current task

Phase 0, slice 0.7: admin accounts and sign-in (`docs/roadmap.md`).

- **Implements:** AP §5.1 (email or phone and password of at least `admin.password_min_length`; mandatory TOTP per RFC 6238; one-time setup link valid 24 hours; TOTP enrolment by QR code; 10 single-use backup codes shown once; lockout for `admin.lockout_min` after `admin.login_max_attempts` failures), AP §5.2 (idle and maximum session lifetimes from `admin.session_idle_min` and `admin.session_max_hours`; each session records device, browser, IP, sign-in time and last activity), AP §5.3 (the first OWN account by a server command, never from the UI), architecture §10.3 (Argon2id, `otplib`, backup codes stored hashed, an HTTP-only, secure, same-site cookie with lifetimes enforced on the server).
- **Branch:** `feat/admin-sign-in`
- **Done when:** a server command creates the first OWN account and prints its setup link; the setup link sets the password and enrols TOTP once and expires after 24 hours; sign-in needs the password and a TOTP or backup code; failures lock the account; the session cookie expires on idle and at its maximum, read from the settings; sign-in, sign-out, setup and lockout are audited; no password, TOTP secret, setup token or backup code is logged, returned twice or stored in clear; tests cover each rule. Roles, guards and the admin team actions are slice 0.8.

## Plan

- [ ] Read AP §5.1–5.3, architecture §10.3 and §15; ask the owner whether the email or the phone is the sign-in name (§5.1 allows both) and anything else unclear.
- [ ] The `identity` schema through the `db-migration` skill: admin accounts (email or phone, password hash, TOTP secret, roles held as text until 0.8, status), setup links (hashed token, expiry, used), backup codes (hashed, used), sessions (hashed id, device, browser, IP, signed in, last activity, ended).
- [ ] The first-OWN server command, with a test.
- [ ] Setup: the link, the password rule, TOTP enrolment and the backup codes, with tests (failing first for the expiry and single use).
- [ ] Sign-in and lockout, with tests (failing first for the attempt count and lockout time from the settings).
- [ ] Sessions: the cookie, idle and maximum lifetimes, sign-out, with tests. The `api` role imports its first database module here: make `DATABASE_URL` and `VALKEY_URL` available to the OpenAPI generation and to `scripts/smoke-image.mjs`.
- [ ] Folder `CLAUDE.md` for the module, `pnpm generate:api`, and the pull request with `## Summary` and `## Test plan`, merged with a merge commit once CI passes.

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

## Next

Slice 0.8, roles, permissions and admin team API (`docs/roadmap.md`).
