# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs. At most 8 KB: the notes of earlier slices live in `docs/slice-notes.md`.

## Current task

L.1a The test gaps (`docs/roadmap.md`, `docs/launch/dod-checklist.md` «Built, test missing»): the 12 rows built without a test (AP-33b, RA-5, RA-9, RA-21, RA-23, RA-24, RA-26, RA-27, RA-29, CU-3, CU-5, CU-10), tests only; a test that finds a bug fixes it in the same slice. Then mark the rows covered in the checklist.

- **Branch:** `test/dod-test-gaps`.
- **Experiment riding on it:** phase 6 item 1 of `docs/claude-code-workflow.md`. `.claude/settings.json` sets `autoCompactWindow: 200000` (since `chore/auto-compact-window`), so this session compacts near 200K. Work as usual; keep `TASKS.md` current so a compaction loses nothing. After the merge, the session that set the experiment measures this one with `scripts/claude-audit.mjs` and decides whether the setting stays.

### Plan

- [ ] Plan the 12 tests (which file each goes in).
- [ ] Server tests (CU-3, CU-5, RA-21 and the rest that are server-side).
- [ ] Web tests (AP-33b, RA-24's portal, RA-29).
- [ ] Flutter tests (RA-5, RA-9, RA-23, RA-24's app, RA-26, RA-27, CU-10).
- [ ] Mark the rows covered in `docs/launch/dod-checklist.md`; notes in `docs/slice-notes.md`.

## Waiting for the owner

- Phase 3 of `docs/claude-code-workflow.md`: the phase 4 session started at 75.7K tokens with one MCP delta (goal: under 45K, none). Left: the `marketing` and `social-media-skills` plugins, off only in the app's settings.

## After that

Launch readiness from L.2 (`docs/roadmap.md`); the gap slices L.1a `test/dod-test-gaps`, L.1b `feat/dod-calls-and-notices` and L.1c `feat/dod-offline-browsing` (owner approval 2026-11-21) come before L.10.

Branches of the later slices: L.2 `test/permission-matrix`, L.3 `feat/captain-simulator`, L.4 `test/load-k6`, L.5 `chore/pgbackrest`, L.6 `feat/monitoring-alerts`, L.7 `chore/production-environment`, L.8 `test/patrol-e2e`, L.9 `docs/device-lab`, L.10 `docs/staging-rehearsal`, L.11 `chore/launch`.
