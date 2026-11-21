# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs. At most 8 KB: the notes of earlier slices live in `docs/slice-notes.md`.

## Current task

L.1b Calls and notices (`docs/roadmap.md`, `docs/launch/dod-checklist.md` «Not built»): «اتصال بالكابتن» in the restaurant app during an active order, recorded (RA §22 item 10, RA-10), and in the customer app from pickup to the end (CU §19 item 17, CU-17); the captain's call and WhatsApp taps recorded and allowed only during the order (CA §19 item 13, CA-13); the waiting-pay line «بدأ احتساب أجر الانتظار» (CA §19 item 10, CA-10); the late apology at 20 minutes past the promised time (CU §19 item 19, CU-19). The owner calls the captain from a test order on the restaurant and customer apps.

- **Branch:** `feat/dod-calls-and-notices`.
- **Read first:** the rows' notes in `docs/launch/dod-checklist.md`; `docs/code/apps/captain.md` and `docs/code/apps/customer.md` («Not yet»); the spec sections the rows cite. CU-17 also carries a test gap: the map leaves at the end.

### Plan

- [ ] Read the cited sections and write the plan here, one step per commit (server first: what records a call or WhatsApp tap, and who may read the captain's number when).
- [ ] Mark RA-10, CU-17, CA-13, CA-10 and CU-19 covered in `docs/launch/dod-checklist.md`; notes in `docs/slice-notes.md`.

## Waiting for the owner

- Phase 3 of `docs/claude-code-workflow.md`: the phase 4 session started at 75.7K tokens with one MCP delta (goal: under 45K, none). Left: the `marketing` and `social-media-skills` plugins, off only in the app's settings.
- Phase 6 item 1 (`autoCompactWindow: 200000`): the session that set the trial measures L.1a's transcript with `scripts/claude-audit.mjs` and decides whether the setting stays.

## After that

L.1c `feat/dod-offline-browsing` (CU-28), then launch readiness from L.2 (`docs/roadmap.md`); the gap slices come before L.10.

Branches of the later slices: L.2 `test/permission-matrix`, L.3 `feat/captain-simulator`, L.4 `test/load-k6`, L.5 `chore/pgbackrest`, L.6 `feat/monitoring-alerts`, L.7 `chore/production-environment`, L.8 `test/patrol-e2e`, L.9 `docs/device-lab`, L.10 `docs/staging-rehearsal`, L.11 `chore/launch`.
