# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs. At most 8 KB: the notes of earlier slices live in `docs/slice-notes.md`.

## Current task

D.8 Inputs and forms (`docs/roadmap.md` Phase D): text field and its wrapper (label, hint, error), long text, search, phone (+963), sign-in code, select, checkbox, radio, switch, quantity stepper, and the date and time pickers in Flutter; web (`ui-web`) and Flutter (`core_ui`) in one pull request (owner, 2026-11-23), from one sheet the owner approves.

- **Branch:** `feat/components-forms`.
- **Read first:** architecture §9.5 (R1 to R10), §9.6, §9.7, §9.9 (the component cycle), §9.10; `docs/brand/directions.md`; `docs/slice-notes.md` «Left from D.7» and «Left from D.6»; `packages/ui-web/CLAUDE.md` and `packages/core_ui/CLAUDE.md`; grep `docs/code/packages/ui-web.md` and `docs/code/packages/core_ui.md` for the Button and the patterns every component repeats (states exported for R3, R10 hover and pressed tokens, RTL and text-scale tests, goldens and the visual gate). The spec lines that use each control: sign-in (architecture §8.3.4), the customer's item options and cart (CU), the restaurant's open switch (RA), the panel's forms (AP).
- **Look at the Figma file first** (`build-slice` skill, «Look at the Figma file»): inspiration, not rules. The owner's analysis page of 2026-11-23 (link in Claude's memory, not here) lists what the file holds: the search pill, the focused and error inputs, the quantity stepper with its concave bridge, the circle and pill pairing.
- **Built so far:** tokens 0.5.0 (`packages/design-tokens`, `core_tokens`), the icon set, the Button and Icon on the web (`ui-web`, Storybook, synced into the Design System) and in Flutter (`core_ui`, widgetbook, goldens in Docker, `fox_lints`).

### Plan

- [x] Split «D.8 onward» into slices with the owner (`slice-plan`): D.8 forms, D.9 data display, D.10 overlays and navigation, one pull request each for both platforms (2026-11-23)
- [ ] Look at the Figma file, read the cited sections and write the design here, including its proposals sheet (§9.9 step 1) for the owner's approval
- [ ] The rest of the plan, written in the design step

## Waiting for the owner

- From `test/money-properties` (merged, PR 246): what an outcome posts when a restaurant-funded discount exceeds what the clearing account holds (`outcomeEntries` throws today; the property skips that case).
- D.1: the `FONTS_DEPLOY_KEY` secret (the private half of a read-only deploy key on `fox-drop-fonts`, no expiry; commands in the pull request thread) in the repository's Actions secrets; the `visual` (D.6) and `golden` (D.7) CI jobs fail without it. The meaning of the `broken-edges` icon SVGs and of the `variant-b/c` icons.
- D.3: the choices under «Decided by us» in `docs/slice-notes.md` «Left from D.3».
- D.4: open both artifacts; the choices under «Decided by us» in «Left from D.4».
- D.5: the orange accent layer for icons («Left from D.5»).
- D.6 and D.7: the choices under «Decided by us» in «Left from D.6» and «Left from D.7»; run widgetbook («Left from D.7»).
- Phase 3 of `docs/claude-code-workflow.md`: the `marketing` and `social-media-skills` plugins, off only in the app's settings (start goal under 45K tokens; was 75.7K).
- Phase 6 items 1 and 2: record L.1c's two-session measurement (`scripts/claude-audit.mjs`, against L.1a and L.1b) in `docs/claude-code-workflow.md`.
- L.1c's choices to confirm (`docs/slice-notes.md` «Left from L.1c»).

## After that

D.9 Data display, then D.10 Overlays and navigation, then the screens' slice plans (`docs/roadmap.md`). Then L.2 The permission matrix (`test/permission-matrix`; read first: architecture §18.1, AP §6 and §14 item 2, RA §22 item 2, the AP-2 and RA-2 rows of `docs/launch/dod-checklist.md`, `apps/server/CLAUDE.md` «Deny by default», the route table in `apps/server/src/modules/identity/admin-team.test.ts`), then L.3 to L.11.
