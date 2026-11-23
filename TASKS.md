# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs. At most 8 KB: the notes of earlier slices live in `docs/slice-notes.md`.

## Current task

D.7 `packages/core_ui` (`docs/roadmap.md` Phase D): the theme from the tokens, widgetbook, golden tests, Button and Icon. The owner sees them in widgetbook.

- **Branch:** `feat/core-ui`.
- **Cited:** architecture §9.5 (R1 to R9), §9.7, §9.9, §9.10; `apps/customer/CLAUDE.md` for the Flutter rules; `packages/core_tokens` (generated from design-tokens 0.4.0); `docs/code/packages/design-tokens.md` «Icons (D.5)» (stroke 2/24 of the size, `mirror` under RTL; the painter parses the path data, arcs and relative commands included); `docs/code/packages/ui-web.md` for the Button decisions to match; `docs/slice-notes.md` «Left from D.6» and «Left from D.5».
- **Approved already:** the Button set and states on the Component proposals sheet (D.6, 2026-11-23; hover 50% on 2026-11-24): four variants plus icon circles, no shadow, compact 40 for the panel only, danger pressed = `color.alert`, loading = spinner with the width kept. The 44 icons (D.5). Flutter has no hover on phones: confirm with the owner whether the sheet needs a Flutter page or the D.6 approval covers it.

### Design

(Written by the planning session.)

### Plan

- [ ] Read the cited sections and write the design here

## Waiting for the owner

- From `test/money-properties` (merged, PR 246): what an outcome posts when a restaurant-funded discount exceeds what the clearing account holds (`outcomeEntries` throws today; the property skips that case).
- D.1: the `FONTS_DEPLOY_KEY` secret (the private half of a read-only deploy key on `fox-drop-fonts`, no expiry; commands in the pull request thread) in the repository's Actions secrets; the `visual` CI job (D.6) fails without it. The meaning of the `broken-edges` icon SVGs and of the `variant-b/c` icons.
- D.3: the choices under «Decided by us» in `docs/slice-notes.md` «Left from D.3».
- D.4: open both artifacts; the choices under «Decided by us» in «Left from D.4».
- D.5: the orange accent layer for icons («Left from D.5»).
- D.6: the choices under «Decided by us» in «Left from D.6».
- Phase 3 of `docs/claude-code-workflow.md`: the `marketing` and `social-media-skills` plugins, off only in the app's settings (start goal under 45K tokens; was 75.7K).
- Phase 6 items 1 and 2: record L.1c's two-session measurement (`scripts/claude-audit.mjs`, against L.1a and L.1b) in `docs/claude-code-workflow.md`.
- L.1c's choices to confirm (`docs/slice-notes.md` «Left from L.1c»).

## After that

D.8 onward (component batches, `docs/roadmap.md`). Then L.2 The permission matrix (`test/permission-matrix`; read first: architecture §18.1, AP §6 and §14 item 2, RA §22 item 2, the AP-2 and RA-2 rows of `docs/launch/dod-checklist.md`, `apps/server/CLAUDE.md` «Deny by default», the route table in `apps/server/src/modules/identity/admin-team.test.ts`), then L.3 `feat/captain-simulator`, L.4 `test/load-k6`, L.5 `chore/pgbackrest`, L.6 `feat/monitoring-alerts`, L.7 `chore/production-environment`, L.8 `test/patrol-e2e`, L.9 `docs/device-lab`, L.10 `docs/staging-rehearsal`, L.11 `chore/launch`.
