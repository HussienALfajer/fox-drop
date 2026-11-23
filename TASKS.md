# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs. At most 8 KB: the notes of earlier slices live in `docs/slice-notes.md`.

## Current task

D.9 Data display (`docs/roadmap.md` Phase D): money (Western digits, the ₺ fallback, bidi isolation), order status chip, count badge, card, list row, timer and countdown, order card, amounts summary, restaurant and dish cards, skeleton, empty and error states; the data table on the web. Web (`ui-web`) and Flutter (`core_ui`) in one pull request (owner, 2026-11-23), from one sheet the owner approves.

- **Branch:** `feat/components-data`.
- **Read first:** architecture §9.5 (R1 to R10), §9.7, §9.10; `packages/ui-web/CLAUDE.md`, `packages/core_ui/CLAUDE.md`; grep `docs/code/packages/ui-web.md` and `core_ui.md` for the patterns of D.6 to D.8 (exported states, R10 tokens, RTL and text-scale tests, goldens, the visual gate, the Design System cards). Specs: AP §4.7 (formats, digits, money), `docs/domain/` (money in minor units with a currency code), the order states the chip shows (grep `docs/domain/` and the parties' specs), CU and RA sections on the order card and the restaurant and dish cards.
- **Built so far:** tokens 0.6.0, icons, Button and Icon, and the inputs and forms set (D.8) on the web (`ui-web`) and in Flutter (`core_ui`, widgetbook, goldens).

### Design

Not written yet: the first plan step.

### Plan

- [ ] Look at the Figma file (`.claude/skills/build-slice/figma-look.mjs`), read the cited sections and write the design here, including its proposals sheet (§9.9 step 1) on the Component proposals canvas for the owner's approval
- [ ] Build steps, one commit each (written with the design)
- [ ] Docs (`docs/code/packages/*.md`, folder `CLAUDE.md` rules), mark the sheet superseded; review; hand over to D.10

## Waiting for the owner

- From `test/money-properties` (merged, PR 246): what an outcome posts when a restaurant-funded discount exceeds what the clearing account holds (`outcomeEntries` throws today; the property skips that case).
- D.1: the `FONTS_DEPLOY_KEY` secret (the private half of a read-only deploy key on `fox-drop-fonts`, no expiry; commands in the pull request thread) in the repository's Actions secrets; the `visual` (D.6) and `golden` (D.7) CI jobs fail without it. The meaning of the `broken-edges` icon SVGs and of the `variant-b/c` icons.
- D.3: the choices under «Decided by us» in `docs/slice-notes.md` «Left from D.3».
- D.4: open both artifacts; the choices under «Decided by us» in «Left from D.4».
- D.5: the orange accent layer for icons («Left from D.5»).
- D.6, D.7 and D.8: the choices under «Decided by us» in «Left from D.6», «D.7» and «D.8»; run widgetbook («Left from D.7»).
- Phase 3 of `docs/claude-code-workflow.md`: the `marketing` and `social-media-skills` plugins, off only in the app's settings (start goal under 45K tokens; was 75.7K).
- Phase 6 items 1 and 2: record L.1c's two-session measurement (`scripts/claude-audit.mjs`, against L.1a and L.1b) in `docs/claude-code-workflow.md`.
- L.1c's choices to confirm (`docs/slice-notes.md` «Left from L.1c»).

## After that

D.10 Overlays and navigation, then the screens' slice plans (`docs/roadmap.md`). Then L.2 The permission matrix (`test/permission-matrix`; read first: architecture §18.1, AP §6 and §14 item 2, RA §22 item 2, the AP-2 and RA-2 rows of `docs/launch/dod-checklist.md`, `apps/server/CLAUDE.md` «Deny by default», the route table in `apps/server/src/modules/identity/admin-team.test.ts`), then L.3 to L.11.
