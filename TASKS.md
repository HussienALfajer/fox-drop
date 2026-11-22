# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs. At most 8 KB: the notes of earlier slices live in `docs/slice-notes.md`.

## Current task

Phase 7 item 2 of `docs/claude-code-workflow.md`: property tests with fast-check for money (every journal balances per currency, rounding round-trips, a repeated request or timer job posts once).

- **Branch:** `test/money-properties`.

### Plan

- [x] fast-check in the server; properties of rounding and conversion, of every pure journal rule, of the ledger's posting, and of concurrent pickup confirmations.
- [x] Fix the two journals with an entry of zero they found (`keptPaymentJournals`, `ticketMoneyEntries`).
- [x] Review: fix `frozenAtPickup`'s fee cuts after a free-delivery code, model it in the property, example tests for each fix, one answer per repeated key, timeouts.
- [ ] Pull request; merge when its checks pass.
- [ ] Owner: what an outcome posts when a restaurant-funded discount exceeds what the clearing account holds (`outcomeEntries` throws today; the property skips that case).

## Waiting for the owner

- D.1: the `FONTS_DEPLOY_KEY` secret (the private half of a read-only deploy key on `fox-drop-fonts`, no expiry; commands in the pull request thread) in the repository's Actions secrets; until then the CI fetch step skips. (The owner confirmed on 2026-11-21 that he holds the right to use every font in the pack, CoFo included, in the apps.) The meaning of the `broken-edges` icon SVGs and of the `variant-b/c` icons.
- Phase 3 of `docs/claude-code-workflow.md`: the phase 4 session started at 75.7K tokens with one MCP delta (goal: under 45K, none). Left: the `marketing` and `social-media-skills` plugins, off only in the app's settings.
- Phase 6 items 1 and 2 (owner decision 2026-11-21): `autoCompactWindow: 350000` and every slice in two sessions, planning then build (`build-slice`). L.1c was the first trial; record its measurement (`scripts/claude-audit.mjs`, against L.1a and L.1b) in `docs/claude-code-workflow.md`.
- L.1c's choices to confirm (`docs/slice-notes.md` «Left from L.1c»): the 1 km fit of a kept read, and the rest under «Decided by us».

## After that

Phase D from D.1b (`docs/brand-expression`: each §9.12 item discussed with the owner in chat, then `docs/brand/expression.md`), then D.2 (`feat/design-tokens`), then L.2 The permission matrix (branch `test/permission-matrix`; read first: architecture §18.1, AP §6 and §14 item 2, RA §22 item 2, the AP-2 and RA-2 rows of `docs/launch/dod-checklist.md`, `apps/server/CLAUDE.md` «Deny by default», the route table in `apps/server/src/modules/identity/admin-team.test.ts`), then the rest of launch readiness from L.3 (`docs/roadmap.md`).

Branches of Phase D: D.2 `feat/design-tokens`, D.3 `feat/design-directions`, D.4 `feat/design-system-project`, D.5 `feat/icon-set`, D.6 `feat/ui-web`, D.7 `feat/core-ui`. Branches of the later slices: L.3 `feat/captain-simulator`, L.4 `test/load-k6`, L.5 `chore/pgbackrest`, L.6 `feat/monitoring-alerts`, L.7 `chore/production-environment`, L.8 `test/patrol-e2e`, L.9 `docs/device-lab`, L.10 `docs/staging-rehearsal`, L.11 `chore/launch`.
