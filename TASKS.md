# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs. At most 8 KB: the notes of earlier slices live in `docs/slice-notes.md`.

## Current task

L.1c Offline browsing (`docs/roadmap.md`, `docs/launch/dod-checklist.md` «Not built»): the customer app's cached browsing without a connection, and an `Idempotency-Key` on the address commands (CU §19 item 28). The owner browses a restaurant in airplane mode.

- **Branch:** `feat/dod-offline-browsing`.
- **Read first:** the CU-28 row and its note in `docs/launch/dod-checklist.md`; CU §19 item 28 and the browsing and addresses sections it rests on; `docs/code/apps/customer.md` (browsing, addresses); `apps/server/CLAUDE.md` (Idempotency) and the address routes in the `customers` module.

### Plan

- [ ] Read the cited sections and write the design here (what is cached, where, for how long, what a screen shows offline; which address commands take a key).
- [ ] Server: `Idempotency-Key` on the address commands (stored in the module's schema, in the command's transaction); tests (a replay answers the first result, another body is refused); `pnpm generate:api`.
- [ ] Customer app: the address commands send one key per body (resent on a lost answer); tests.
- [ ] Customer app: cached browsing offline (home, a restaurant and its menu from the last good read, marked as not live); tests.
- [ ] Review (`reviewer`), fixes.
- [ ] Mark CU-28 covered in `docs/launch/dod-checklist.md`; notes in `docs/slice-notes.md`; `docs/code/` notes; hand over.

## Waiting for the owner

- Phase 3 of `docs/claude-code-workflow.md`: the phase 4 session started at 75.7K tokens with one MCP delta (goal: under 45K, none). Left: the `marketing` and `social-media-skills` plugins, off only in the app's settings.
- Phase 6 item 1 (`autoCompactWindow: 200000`, kept by the owner 2026-11-21): watch L.1b and L.1c the same way (compactions, what was re-read or redone after each); any real loss moves it to 300K. Then the owner decides phase 6 item 2 (a large slice in three sessions): kept, or the compaction alone.

## After that

Launch readiness from L.2 (`docs/roadmap.md`); the gap slices come before L.10.

Branches of the later slices: L.2 `test/permission-matrix`, L.3 `feat/captain-simulator`, L.4 `test/load-k6`, L.5 `chore/pgbackrest`, L.6 `feat/monitoring-alerts`, L.7 `chore/production-environment`, L.8 `test/patrol-e2e`, L.9 `docs/device-lab`, L.10 `docs/staging-rehearsal`, L.11 `chore/launch`.
