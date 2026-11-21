# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs. At most 8 KB: the notes of earlier slices live in `docs/slice-notes.md`.

## Current task

L.1b Calls and notices (`docs/roadmap.md`, `docs/launch/dod-checklist.md` «Not built»): «اتصال بالكابتن» in the restaurant app during an active order, recorded (RA §22 item 10, RA-10), and in the customer app from pickup to the end (CU §19 item 17, CU-17); the captain's call and WhatsApp taps recorded and allowed only during the order (CA §19 item 13, CA-13); the waiting-pay line «بدأ احتساب أجر الانتظار» (CA §19 item 10, CA-10); the late apology at 20 minutes past the promised time (CU §19 item 19, CU-19). The owner calls the captain from a test order on the restaurant and customer apps.

- **Branch:** `feat/dod-calls-and-notices`.
- **Read first:** the rows' notes in `docs/launch/dod-checklist.md`; `docs/code/apps/captain.md` and `docs/code/apps/customer.md` («Not yet»); the spec sections the rows cite. CU-17 also carries a test gap: the map leaves at the end.

### Plan

Design (decided in this session, from RA §8.9 / §18, CU §11.3 / §15, CA §9.5 / §15, which all say "the number revealed; the tap recorded"):

- Each tap is a reveal command that records the tap and answers `{ phone }`; the app dials (or opens WhatsApp) with the answer. The numbers leave the reads: the customer's `captain.phone` and the captain's `customer.phone`.
  `POST /v1/merchant/orders/{id}/captain-call` (MO, MC; from assignment until the order ends), `POST /v1/customer/orders/{id}/captain-call` (own order, `picked_up` or `arrived`), `POST /v1/captain/orders/{id}/customer-contact` with `channel` call or whatsapp (own active order). Outside the window: `409 order_state_changed`.
- The taps go in a new append-only `ordering.order_contacts` table, never in `order_events`: an event bumps the order version, which would refuse operations' preview-and-confirm dialogs (edit, outcome) after any call. The admin timeline merges them in by time (types `order.captain_called`, `order.customer_called`, `order.customer_whatsapp`).
- No `Idempotency-Key`: a tap dials at once or not at all (never queued and resent later), and each tap is its own record.
- CA-10: the captain's active order carries `waitingPayFrom` (the later of the arrival and the prep due time, plus the threshold kept at the arrival; null when the vehicle's rate pays no waiting), and the app shows «بدأ احتساب أجر الانتظار» from it on the server clock.
- CU-19: a `lateApology` timer sent beside the late code's, at the promised time + `order.delivery_late_alert_min`; it pushes `customer.late_apology` if the order is not delivered and the promised time unchanged. The customer's order carries `lateApologyAt` (null once ended) and the app shows the banner from it.

- [x] Read the cited sections and write the plan here.
- [x] Server: `order_contacts` migration, the three reveal routes, the numbers out of the reads, the admin timeline; tests (window, recorded, other party 404); `pnpm generate:api`.
- [x] Server: `waitingPayFrom` on the captain's active order; the late apology timer and `lateApologyAt`; tests. (Admin timeline labels and key done with it.)
- [ ] Customer app: «اتصال بالكابتن» on the order screen from pickup through the reveal (the door ring too), the late apology banner; tests (button and map leave at the end).
- [ ] Restaurant app: «اتصال بالكابتن» on the order detail from assignment to the end (dialer on Android, a dialog with the number on Windows); tests.
- [ ] Captain app: call and WhatsApp through the reveal, «بدأ احتساب أجر الانتظار»; tests. Admin: the three timeline labels.
- [ ] Review (`reviewer`), fixes.
- [ ] Mark RA-10, CU-17, CA-13, CA-10 and CU-19 covered in `docs/launch/dod-checklist.md`; notes in `docs/slice-notes.md`; `docs/code/` notes; hand over.

## Waiting for the owner

- Phase 3 of `docs/claude-code-workflow.md`: the phase 4 session started at 75.7K tokens with one MCP delta (goal: under 45K, none). Left: the `marketing` and `social-media-skills` plugins, off only in the app's settings.
- Phase 6 item 1 (`autoCompactWindow: 200000`, kept by the owner 2026-11-21): watch L.1b and L.1c the same way (compactions, what was re-read or redone after each); any real loss moves it to 300K. Then the owner decides phase 6 item 2 (a large slice in three sessions): kept, or the compaction alone.

## After that

L.1c `feat/dod-offline-browsing` (CU-28), then launch readiness from L.2 (`docs/roadmap.md`); the gap slices come before L.10.

Branches of the later slices: L.2 `test/permission-matrix`, L.3 `feat/captain-simulator`, L.4 `test/load-k6`, L.5 `chore/pgbackrest`, L.6 `feat/monitoring-alerts`, L.7 `chore/production-environment`, L.8 `test/patrol-e2e`, L.9 `docs/device-lab`, L.10 `docs/staging-rehearsal`, L.11 `chore/launch`.
