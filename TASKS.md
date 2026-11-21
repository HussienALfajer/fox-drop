# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs. At most 8 KB: the notes of earlier slices live in `docs/slice-notes.md`.

## Current task

Phase 6 item 5 of `docs/claude-code-workflow.md`: split the `deploy` skill into a short file and reference files (status under «Phase 6»).

- **Branch:** `chore/deploy-skill-split`.
- **Files:** `.claude/skills/deploy/SKILL.md`, `.claude/skills/deploy/references/*.md`, `docs/claude-code-workflow.md`.

### Plan

- [x] Move each long section into a reference file; leave a table in `SKILL.md`.
- [x] Status in the workflow doc.

## Waiting for the owner

- Phase 3 of `docs/claude-code-workflow.md`: the phase 4 session started at 75.7K tokens with one MCP delta (goal: under 45K, none). Left: the `marketing` and `social-media-skills` plugins, off only in the app's settings.

## After that

Launch readiness from L.2 (`docs/roadmap.md`); the gap slices L.1a `test/dod-test-gaps`, L.1b `feat/dod-calls-and-notices` and L.1c `feat/dod-offline-browsing` (owner approval 2026-11-21) come before L.10.

Branches of the later slices: L.2 `test/permission-matrix`, L.3 `feat/captain-simulator`, L.4 `test/load-k6`, L.5 `chore/pgbackrest`, L.6 `feat/monitoring-alerts`, L.7 `chore/production-environment`, L.8 `test/patrol-e2e`, L.9 `docs/device-lab`, L.10 `docs/staging-rehearsal`, L.11 `chore/launch`.
