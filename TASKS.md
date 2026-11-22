# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs. At most 8 KB: the notes of earlier slices live in `docs/slice-notes.md`.

## Current task

D.5 Fox Drop icon set (`docs/roadmap.md` Phase D): the hand-drawn line icons in the Figma file's style (rounded line, a stroke of about 2 at 24) on one grid and stroke, as SVG sources with web and Flutter outputs and a test of the rules. The owner reviews the icon sheet.

- **Branch:** `feat/icon-set`.
- **Cited:** architecture §9.4, §9.5 R5 and R8, §9.8, §9.9; `docs/brand/expression.md` §2 (the drop only for places) and §10 (the first 44 icons); `docs/brand/directions.md` «Measurements» (icons row); `docs/code/packages/design-tokens.md` «The Design System and the Guide (D.4)» for how the icons reach the Design System (a new `Icons` asset group, `packages/design-tokens/CLAUDE.md` «Sync»).

### Design

Owner decisions (2026-11-23, planning session): the grid below; back, motorcycle and car mirror in RTL; Flutter gets path data painted as a stroke; the icon sheet is a page of a new «Component proposals» design canvas.

- **Sources** in `packages/design-tokens/icons/`: one `<name>.svg` per icon (kebab-case English names) and `icons/icons.json`, the manifest: `{name, group, mirror, description}` per icon, in the six groups and 44 icons of `docs/brand/expression.md` §10 (Navigation 10, Actions 9, States 7, Place and delivery 8, Money 5, Contact and rating 5). Drawn by hand in the Figma file's style (`docs/brand/directions.md` icons row): rounded lines, geometric and friendly, open shapes rather than filled. The logo's drop appears only in `drop-pin` and `map` (expression §2: the drop means a place). No icon is copied from another library (§10).
- **The drawing language (owner asked 2026-11-23 for a redraw led by the Figma file's own icons, measured from its vector geometry through the REST API):** Figma's icons are stroked lines outlined to fills, about 2.4 thick at 30 px (≈ 2 at 24), round caps and joins, plump soft shapes with generous radii, often one continuous line (the home's door is cut into its base). Kept from it: the basket for the cart, the scooter with a box and speed lines, the bell opening onto a notification dot, the heavy chevron for back, the handled bin with three slats, the plump heart, the flame with % for a discount. Our addition, one small "life" detail per icon where it reads (a glint, a shine, steam, sound waves, a wavy handwriting stroke). Figma's orange accents (the bell's dot, the stars) would need a second, accent layer, which the R8 grid forbids today: pending the owner.
- **The grid (R8, owner):** root `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">`, no width or height; children only `path`, `circle`, `ellipse`, `line`, `polyline`, `polygon`, `rect`, with geometry attributes only (no `fill`, `stroke*`, `style`, `transform`, `id`, `class`, `opacity`); every geometry point, curve and arc sample and circle extent inside the live area 2..22 (padding 2); numbers with at most 2 decimals. Sources drawn left-to-right (back points left); `mirror: true` flips them in RTL, exactly `back`, `motorcycle`, `car`.
- **The test** `src/icons.test.ts` checks all of the above over every file (a small parser in `src/icon-geometry.ts` for the path commands M L H V C S Q T A Z, absolute and relative, sampling curves and arcs), that the files and the manifest match one to one, the group counts, and the mirror set. A failing icon names the file and the rule.
- **Outputs**, written by `pnpm --filter @fox-drop/design-tokens generate` and added to `OUTPUTS` so the drift test covers them: every element is normalised to path data `d` by `src/icons.ts`, so both platforms read paths only. Web: `generated/icons.ts` (`export const icons = {...} as const`, `IconName`, each `{d: string[], mirror}`), exported as `@fox-drop/design-tokens/icons`. Flutter: `packages/core_tokens/lib/src/icons.g.dart` (pure Dart: `FoxIcons.<name>` as `FoxIconData(paths, mirror:)` and `FoxIcons.all` by source name, exported from `core_tokens.dart`, a `dart test` that every icon has paths), already in `dart format` style. Build note: named `Fox*`, not `Fd*`, to match `FoxColors`, `FoxSize` in `tokens.g.dart`. Path data is kept as authored (relative commands and arcs included); circles, ellipses and rects become arcs; D.7's painter parses it with an SVG path parser. The `Icon` components that render them are D.6 (`ui-web`, inline SVG) and D.7 (`core_ui`, a painter with stroke 2/24 of the size, round caps and joins, mirrored under RTL `Directionality`).
- **Icon size tokens:** `size.icon-sm` 16, `size.icon-md` 24, `size.icon-lg` 32 in `tokens/semantic/base.json` with descriptions; version 0.3.0 and a `CHANGELOG.md` entry.
- **The sheet** `src/icon-sheet.ts` (`pnpm … icon-sheet`) writes `.design-system/icons/` (ignored): one RTL page drawn from the resolved tokens: the 44 by group with English name and Arabic label in «guillemets» (sheet only, no app strings), each at 24 in `on-surface` blue on `surface`, active (ivory inside an orange circle of `size.control`), at 16, 24 and 32, and the three mirrored icons in LTR and RTL; plus a grid overlay of three icons showing the live area. Claude creates the «Component proposals» canvas (Design canvas type) and publishes the sheet as page «Icons — batch 1»; its link goes in Claude's memory (`fox-drop-design-artifacts.md`), never here.
- **Sync, after the owner approves the sheet (§9.9 step 4):** `src/design-system-build.ts` adds an `Icons` asset group (the 44 SVGs to `uploads/Icons/`, a README of the group with the grid rules and the mirror set), then the «Sync» steps of `packages/design-tokens/CLAUDE.md`; the sheet is marked superseded.
- **Docs in the slice:** `packages/design-tokens/CLAUDE.md` gets the icon rules (edit the SVG and manifest, regenerate, the R8 test); `docs/code/packages/design-tokens.md` an «Icons (D.5)» section; architecture §9.4 and §9.11 the settled grid and mirror set; `docs/brand/directions.md` icons row points to the tokens.
- **Left out:** the `Icon` components (D.6, D.7); the second batch (expression §10); filled or duotone variants; an icon font.

### Plan

- [x] Read the cited sections and write the design here
- [x] Grid test and geometry parser, manifest, first icons (Navigation), size tokens
- [x] The other 34 icons
- [x] Web and Dart outputs with the drift test and the Dart test
- [ ] Icon sheet; create «Component proposals», publish the page; owner reviews (stop until approved)
  - Stopped at (2026-11-23): sheet drawn (`src/icon-sheet.ts`) and published on «Component proposals» (link in Claude's memory); waiting for the owner's review. Changes the owner asks for: edit the SVGs, rerun `icon-sheet`, republish.
- [ ] Sync the `Icons` group into the Design System; docs (CLAUDE.md, docs/code, architecture §9.4 and §9.11)
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
