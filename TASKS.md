# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs. At most 8 KB: the notes of earlier slices live in `docs/slice-notes.md`.

## Current task

D.5 Fox Drop icon set (`docs/roadmap.md` Phase D): the hand-drawn line icons in the Figma file's style (rounded line, a stroke of about 2 at 24) on one grid and stroke, as SVG sources with web and Flutter outputs and a test of the rules. The owner reviews the icon sheet.

- **Branch:** `feat/icon-set`.
- **Cited:** architecture §9.4, §9.5 R5 and R8, §9.8, §9.9; `docs/brand/expression.md` §2 (the drop only for places) and §10 (the first 44 icons); `docs/brand/directions.md` «Measurements» (icons row); `docs/code/packages/design-tokens.md` «The Design System and the Guide (D.4)» for how the icons reach the Design System (a new `Icons` asset group, `packages/design-tokens/CLAUDE.md` «Sync»).

### Design

(The planning session writes it here: where the SVG sources live, the grid and stroke rules and their test, the web and Flutter outputs, which icons mirror in RTL, the icon sheet for the owner on a design canvas, and the sync into the Design System.)

### Plan

- [ ] Read the cited sections and write the design here
- [ ] Review, hand over (roadmap, TASKS.md for D.6, slice notes), pull request

## Waiting for the owner

- From `test/money-properties` (merged, PR 246): what an outcome posts when a restaurant-funded discount exceeds what the clearing account holds (`outcomeEntries` throws today; the property skips that case).
- D.1: the `FONTS_DEPLOY_KEY` secret (the private half of a read-only deploy key on `fox-drop-fonts`, no expiry; commands in the pull request thread) in the repository's Actions secrets; until then the CI fetch step skips. The meaning of the `broken-edges` icon SVGs and of the `variant-b/c` icons.
- D.3: the choices under «Decided by us» in `docs/slice-notes.md` «Left from D.3».
- D.4: open both artifacts; the choices under «Decided by us» in «Left from D.4».
- Phase 3 of `docs/claude-code-workflow.md`: the `marketing` and `social-media-skills` plugins, off only in the app's settings (start goal under 45K tokens; was 75.7K).
- Phase 6 items 1 and 2: record L.1c's two-session measurement (`scripts/claude-audit.mjs`, against L.1a and L.1b) in `docs/claude-code-workflow.md`.
- L.1c's choices to confirm (`docs/slice-notes.md` «Left from L.1c»).

## After that

D.6 `feat/ui-web`, D.7 `feat/core-ui`. Then L.2 The permission matrix (`test/permission-matrix`; read first: architecture §18.1, AP §6 and §14 item 2, RA §22 item 2, the AP-2 and RA-2 rows of `docs/launch/dod-checklist.md`, `apps/server/CLAUDE.md` «Deny by default», the route table in `apps/server/src/modules/identity/admin-team.test.ts`), then L.3 `feat/captain-simulator`, L.4 `test/load-k6`, L.5 `chore/pgbackrest`, L.6 `feat/monitoring-alerts`, L.7 `chore/production-environment`, L.8 `test/patrol-e2e`, L.9 `docs/device-lab`, L.10 `docs/staging-rehearsal`, L.11 `chore/launch`.
