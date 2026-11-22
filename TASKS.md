# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs. At most 8 KB: the notes of earlier slices live in `docs/slice-notes.md`.

## Current task

D.1b Brand expression (architecture §9.12, `docs/roadmap.md` Phase D): each §9.12 item discussed with the owner in chat, one at a time, with options and a recommendation; `docs/brand/expression.md` is written only after the owner decides.

- **Branch:** `docs/brand-expression`.

### Plan

- [x] Principles and personality.
- [ ] Signature shape.
- [ ] Motion language.
- [ ] Map style.
- [ ] Illustration and photos.
- [ ] Full palette.
- [ ] Arabic typography.
- [ ] Voice and tone.
- [ ] Device budgets.
- [ ] First icon set.
- [ ] Write `docs/brand/expression.md` from the decisions; mark §9.12 decided; the owner approves the brief.
- [ ] Pull request; merge when its checks pass.

Decided so far (owner, 2026-11-22):

- Personality: «الجار الشاطر», the clever, quick, warm neighbour we know. The fox is wit and speed, the drop is delivery to your door; orange carries warmth and appetite, blue carries trust in numbers and states; friendly, never clowning. Rejected: loud and playful (hurts trust with cash and dense screens), calm premium (loses appetite, breaks the 30% orange).
- Principles, ordered; the higher one wins a conflict: (1) clear before beautiful: amount, time and state read at a glance; (2) honest numbers: every price, fee and time shown before the user commits, no surprise at the door; (3) light as a fox: fewest steps, felt speed, works on a low-end Android phone and a weak network; (4) each screen its moment: captain in the sun with one hand, kitchen alert seen from afar, dense panel with the keyboard; (5) local and warm: Arabic first, people's words, calm in errors, every error says what to do next.

## Waiting for the owner

- From `test/money-properties` (merged, PR 246): what an outcome posts when a restaurant-funded discount exceeds what the clearing account holds (`outcomeEntries` throws today; the property skips that case).

- D.1: the `FONTS_DEPLOY_KEY` secret (the private half of a read-only deploy key on `fox-drop-fonts`, no expiry; commands in the pull request thread) in the repository's Actions secrets; until then the CI fetch step skips. (The owner confirmed on 2026-11-21 that he holds the right to use every font in the pack, CoFo included, in the apps.) The meaning of the `broken-edges` icon SVGs and of the `variant-b/c` icons.
- Phase 3 of `docs/claude-code-workflow.md`: the phase 4 session started at 75.7K tokens with one MCP delta (goal: under 45K, none). Left: the `marketing` and `social-media-skills` plugins, off only in the app's settings.
- Phase 6 items 1 and 2 (owner decision 2026-11-21): `autoCompactWindow: 350000` and every slice in two sessions, planning then build (`build-slice`). L.1c was the first trial; record its measurement (`scripts/claude-audit.mjs`, against L.1a and L.1b) in `docs/claude-code-workflow.md`.
- L.1c's choices to confirm (`docs/slice-notes.md` «Left from L.1c»): the 1 km fit of a kept read, and the rest under «Decided by us».

## After that

D.2 (`feat/design-tokens`), then L.2 The permission matrix (branch `test/permission-matrix`; read first: architecture §18.1, AP §6 and §14 item 2, RA §22 item 2, the AP-2 and RA-2 rows of `docs/launch/dod-checklist.md`, `apps/server/CLAUDE.md` «Deny by default», the route table in `apps/server/src/modules/identity/admin-team.test.ts`), then the rest of launch readiness from L.3 (`docs/roadmap.md`).

Branches of Phase D: D.2 `feat/design-tokens`, D.3 `feat/design-directions`, D.4 `feat/design-system-project`, D.5 `feat/icon-set`, D.6 `feat/ui-web`, D.7 `feat/core-ui`. Branches of the later slices: L.3 `feat/captain-simulator`, L.4 `test/load-k6`, L.5 `chore/pgbackrest`, L.6 `feat/monitoring-alerts`, L.7 `chore/production-environment`, L.8 `test/patrol-e2e`, L.9 `docs/device-lab`, L.10 `docs/staging-rehearsal`, L.11 `chore/launch`.
