# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs. At most 8 KB: the notes of earlier slices live in `docs/slice-notes.md`.

## Current task

L.2 The permission matrix (`docs/roadmap.md`): one test calling every route with every admin role and every restaurant role, the forbidden calls refused (architecture §18.1, AP §14 item 2, RA §22 item 2).

- **Branch:** `test/permission-matrix`.
- **Read first:** architecture §18.1; AP §6 (roles and permissions) and §14 item 2; RA §22 item 2 and the restaurant roles it rests on; the AP-2 and RA-2 rows of `docs/launch/dod-checklist.md` (routes sampled, not every route); `apps/server/CLAUDE.md` «Deny by default» and the route table in `apps/server/src/modules/identity/admin-team.test.ts`.

### Design

(Written by the planning session.)

### Plan

- [ ] Read the cited sections and write the design here (which routes and roles, where the matrix comes from, how a test calls each route, what "refused" means per group).

## Waiting for the owner

- Phase 3 of `docs/claude-code-workflow.md`: the phase 4 session started at 75.7K tokens with one MCP delta (goal: under 45K, none). Left: the `marketing` and `social-media-skills` plugins, off only in the app's settings.
- Phase 6 items 1 and 2 (owner decision 2026-11-21): `autoCompactWindow: 350000` and every slice in two sessions, planning then build (`build-slice`). L.1c was the first trial; record its measurement (`scripts/claude-audit.mjs`, against L.1a and L.1b) in `docs/claude-code-workflow.md`.
- L.1c's choices to confirm (`docs/slice-notes.md` «Left from L.1c»): the 1 km fit of a kept read, and the rest under «Decided by us».

## After that

The rest of launch readiness from L.3 (`docs/roadmap.md`).

Branches of the later slices: L.3 `feat/captain-simulator`, L.4 `test/load-k6`, L.5 `chore/pgbackrest`, L.6 `feat/monitoring-alerts`, L.7 `chore/production-environment`, L.8 `test/patrol-e2e`, L.9 `docs/device-lab`, L.10 `docs/staging-rehearsal`, L.11 `chore/launch`.
