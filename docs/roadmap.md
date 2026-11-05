# Roadmap

One line per item. Details belong in the specs and the architecture, not here.

## Versions

| Version | Scope                                                                                                                 | Status      |
| ------- | --------------------------------------------------------------------------------------------------------------------- | ----------- |
| V1      | Full order cycle for restaurants: cash on delivery, captain cash custody and earnings, launch promo codes. Azaz only. | Specified   |
| V2      | Quality and operations: printing, panel chat, penalties engine, English UI                                            | Not started |
| V3      | Stores and errands, central catalogue, order stacking                                                                 | Not started |
| V4      | Growth: loyalty, referral, campaigns                                                                                  | Not started |
| V5      | Electronic payments and wallet                                                                                        | Not started |
| V6      | Scale and intelligence: smart dispatch, forecasting                                                                   | Not started |

The technical growth path is [architecture §20](architecture/20-growth-path-v1-v6.md).

## V1 build phases

Markers: `[ ]` not started, `[~]` in progress, `[x]` done.

- `[x]` Specs: admin panel, restaurant app, captain app, customer app, technology stack.
- `[x]` Repository and documentation layout.
- `[~]` Phase 0, foundation: agent instructions and checks, workspace and CI, server skeleton with the module boundaries, database, identity and roles, settings. **The design system and any screen styling wait for the owner's answer on whether the UI/UX and design system are ready.** Slices, in order (owner approval 2026-11-04); each adds the folder `CLAUDE.md` and the rule or skill for the pattern it introduces:
  - `[x]` 0.1 Workspace, single check command and CI: pnpm and Turborepo, Dart pub workspace and Melos, pinned Node and Flutter (FVM), `pnpm verify` for TypeScript and Dart, format hooks, GitHub Actions, Renovate, `checker` agent, `build-slice` skill, branch protection on `main` (architecture §18.4, §19).
  - `[x]` 0.2 Server skeleton and module boundaries: NestJS on Fastify, `/v1` with the four route groups, `Server-Time`, Zod, redacted structured logs, one container image for the four roles, boundary lint rule that fails a forbidden import (architecture §4, §5.1, §5.3, §16).
  - `[x]` 0.3 OpenAPI contract and generated clients: `packages/api-schema`, TypeScript and Dart (`core_api`) clients generated in the check; a stale client fails it (architecture §5.3, E6).
  - `[x]` 0.4 Local environment and database: Docker Compose (PostGIS, Valkey, Centrifugo), Drizzle with SQL migrations, one schema per module, separate migration and application roles (proved by the database test; the server wires its connection in 0.5), UUIDv7, Testcontainers, cities with the Azaz seed, `.env.example`, `db-migration` skill. OSRM and the S3-compatible object storage come with their first use (T7; architecture §5.2, §5.4, §17.1; AP §1.3 item 6).
  - `[x]` 0.5 Audit log: append-only table enforced by database grants, actor, device and IP context, sensitive-view events (AP §4.6, §9.16; architecture §15.3).
  - `[x]` 0.6 Settings catalogue (server): every Appendix A key with type, default, scope and edit roles, stored values and change history, cached reads in Valkey, reset to default (AP §4.4, Appendix A).
  - `[x]` 0.7 Admin accounts and sign-in: setup link, Argon2id password, TOTP, backup codes, lockout, cookie session with idle and maximum lifetimes, first OWN by server command (AP §5.1–5.3; architecture §10.3).
  - `[x]` 0.8 Roles, permissions and admin team API: five roles as data, union of roles, deny-by-default guards, a test matrix calling every route with every role, admin team actions (AP §6, §9.15, §14 items 1–2).
  - `[x]` 0.9 Settings edit API: grouped reads, edits by allowed roles, reason for money-impact settings, reset, history, audit (AP §9.14, §14 item 28).
  - `[x]` 0.10 Phone sign-in for the apps (server): `CodeSender` port with a development-only sender, code rules, request limits in Valkey, 15-minute access tokens with rotating keys, rotated refresh tokens revoked on reuse, devices, sign out everywhere (architecture §8.3.1–8.3.2, §15.1).
  - `[x]` 0.11 Web app shells, unstyled: `apps/admin` and `apps/merchant-portal` with Vite, TanStack Router and Query, i18next in Arabic RTL, the generated client, a Playwright smoke test (architecture §10.1).
  - `[x]` 0.12 Flutter app shells, unstyled: the three apps and their platforms, `core_l10n` (Arabic ARB, Western digits), Riverpod, go_router, Flutter rules for Claude; analyze and widget tests in `pnpm verify` (architecture §11).
  - `[x]` 0.13 Hosting decision (docs): record T9, hosting on the owner's Contabo server without Cloudflare, and update every architecture section that depends on it (architecture §3, §5.8, §15, §16, §17, §22 item 9).
  - `[ ]` 0.14 Staging on Contabo: provisioning, deployment on every merge to `main`, server-side secrets, error tracking, `deploy` skill (architecture §17, E8). Waits for 0.13.
  - Waiting for the owner's answer on the UI/UX and design system: `packages/design-tokens`, `packages/ui-web` with Storybook, `packages/core_ui` with widgetbook, and the panel screens for sign-in, admin team and settings.
  - Later, before the staging trials of Phase 1: the real WhatsApp sender (`otp-sender`, sender pool, warm-up, App Check; architecture §8.3.3) and the emergency sign-in procedure (architecture §22 item 1).
- `[ ]` Phase 1, walking skeleton: one order goes through its whole cycle (customer orders, restaurant accepts, dispatch offers, captain picks up and delivers, ledger entries) with minimal screens.
- `[ ]` Phase 2 onwards, vertical slices: each feature of the specs built through every layer it touches, one slice per pull request. The slice list is planned before Phase 1 starts.
- `[ ]` Launch readiness: captain simulator load test, real-device lab, staging rehearsal (architecture §18).
