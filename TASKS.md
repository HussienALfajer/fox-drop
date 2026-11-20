# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs. At most 8 KB: the notes of earlier slices live in `docs/slice-notes.md`.

## Current task

Launch readiness (`docs/roadmap.md`), slice L.1: the definition-of-done audit. Split into L.1–L.11 with the owner's approval on 2026-11-21. Planned, not started.

- **Branch:** `docs/dod-checklist`.
- **Specs:** AP §14, RA §22, CA §19, CU §19 (the four definitions of done); architecture §17, §18.
- **Delivers:** `docs/launch/dod-checklist.md`, one row per item (AP 33, RA 30, CA 28, CU 28): the test that proves it (file and test name) or the staging demonstration that shows it (who, which device), and its state (covered, demo only, gap). Gaps larger than a fix become slices before L.10, with the owner's approval.
- **Owner decisions 2026-11-21:** the owner tests alone on their own phones (Android now, iPhone through TestFlight once the Apple Developer account exists); one full staging rehearsal before launch (L.10, the owner sets the date); production on the current Contabo server next to staging, with its own Firebase project and WhatsApp numbers.

### Plan

- [ ] Read each definition of done and grep `apps/` and `docs/code/` for the tests of each item (send the search to the `Explore` agent, one spec at a time).
- [ ] Write `docs/launch/dod-checklist.md` and link it from `docs/README.md`.
- [ ] Present the gaps to the owner; record approved fix slices in `docs/roadmap.md` before L.10.

### Branches of the later slices

L.2 `test/permission-matrix`, L.3 `feat/captain-simulator`, L.4 `test/load-k6`, L.5 `chore/pgbackrest`, L.6 `feat/monitoring-alerts`, L.7 `chore/production-environment`, L.8 `test/patrol-e2e`, L.9 `docs/device-lab`, L.10 `docs/staging-rehearsal`, L.11 `chore/launch`.

## Also open

Phase 2 of `docs/claude-code-workflow.md` (`chore/fewer-requests`, merged in pull request 218):

- [ ] After two sessions: `node scripts/claude-audit.mjs` shows the guard log; check it for false positives, then set `MODE = 'enforce'` in `.claude/hooks/bash.mjs`.
- [ ] Measure one slice session against the baseline (single-Bash requests under half of 67.7%). A planning session (2026-11-21, `5e6c2ce1`, 14 requests) measured 14.3% single-Bash requests; a slice session is still to measure.

## After that

In the order of `docs/claude-code-workflow.md`: phase 3 (the owner's MCP servers, plugins and skills, with the owner), phase 4 (fast checks, `chore/fast-verify`), phase 5 (CI filters). Then L.2 onwards.
