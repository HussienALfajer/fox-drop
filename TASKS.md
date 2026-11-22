# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs. At most 8 KB: the notes of earlier slices live in `docs/slice-notes.md`.

## Current task

D.3 Design directions (`docs/roadmap.md` Phase D): three or four directions on the same screens (customer home, captain active order, panel operations board), one of them the Figma direction, drawn in a Claude design canvas; the first icons drawn in each, and each scored against the D.1b principles. The owner picks one.

- **Branch:** `feat/design-directions`.
- **Read first:** architecture §9.1, §9.5 R7, §9.8, §9.9, §9.11, §9.12; `docs/brand/expression.md` (all of it: principles, signature shape, motion, map style, illustration, palette, typography, voice, budgets, first icon set); `docs/brand/README.md` and `docs/brand/guidelines/`; the D.2 tokens (`packages/design-tokens/CLAUDE.md`, `generated/contrast-report.md`); the specs of the three screens (CU home, CA active order, AP operations board).

### Design

Owner answers (2026-11-22): four directions; captain screen step 3; only the screens' icons; Figma read in the built-in browser; CoFo may be uploaded to the private canvas.

**Medium.** One private Artifact of the core "Design" type (quickstart intent `design`), titled «Fox Drop Directions», with no design system (none exists until D.4; §9.8 keeps exploration on a separate canvas). Its link stays out of the repo (§9.8).

**Inputs on the canvas.** Values from `packages/design-tokens/generated/tokens.css` by semantic name; nothing invented (§9.8). CoFo 400/500/700 from `.fonts/` (`pnpm fonts:fetch`) as private assets. Logo from `docs/brand/logo/`. Synthetic data only, Western tabular digits.

**The Figma file.** The owner sends its link in chat and signs in on the built-in browser pane; it is read as a mood board (no values, §9.8) and described in words, never the link or images, in `docs/brand/directions.md`.

**Four directions**, each a brief of palette use (60/30/10 kept), surfaces, shape and radii, density, imagery, type use and motion note:

| #   | Name           | Idea                                                                                           |
| --- | -------------- | ---------------------------------------------------------------------------------------------- |
| A   | «اتجاه Figma»  | The owner's Figma mood board turned into the tokens                                            |
| B   | «دافئ بالصور»  | Ivory, large food photos at fixed ratios, orange accents only (R7 appetite)                    |
| C   | «أزرق الثقة»   | Blue headers and numbers, calm structure, orange for the one main action                       |
| D   | «زاوية القطرة» | Bold orange blocks and the "drop corner" on cards (expression §2: tried in one direction only) |

**Artboards per direction** (Arabic RTL, default state only; the five R6 states belong to each screen's own cycle, §9.9):

1. Customer home, phone 390×844 (CU §8.1, §8.2): header with location and search, banners, categories, «الأقرب إليك», restaurant cards with cover, logo, rating or «جديد», delivery range, fee or «توصيل مجاني», one «مشغول» and one closed faded card, bottom navigation.
2. Captain step 3, phone 390×844 (CA §9.1, §9.5): the four-step progress bar, the sunlight map (expression §4: high contrast, route width 8, solid orange after pickup, drop pins), «تقبض من الزبون: …» with equivalents, address with building, floor, landmark, directions, note, «التسليم المتوقع قبل …», «ابدأ الملاحة», «اتصال بالزبون», «واتساب الزبون», main button «وصلت» in the thumb zone, «مشكلة» and «طوارئ». 7:1 text, no orange text (expression §6).
3. Panel operations board, 1440×900, compact (AP §9.2.1): five columns right to left with count and late count, cards with number, restaurant, neighbourhood, time in state with SLA colour plus icon (never colour alone, R4), captain or red «بلا كابتن», total, a few badges, the filter bar, one card's side panel open.
4. Icons sheet: the ~12 icons these screens use (home, search, cart, orders, account, heart, phone, route, cash, clock, warning, drop pin, chat), 24-point grid, one stroke, drawn in that direction's style (§9.4; D.5 draws the real set).

**Scoring.** A last artboard and `docs/brand/directions.md` hold one table: each direction scored 1 to 5 on the five principles of expression §1, in their order, plus R7 fit per surface, each score with a one-line reason. No weighted total: principle order breaks ties. The session recommends one; **the owner picks** (design stop, AskUserQuestion with the four plus "mix").

**Repo output** (docs only, no code): `docs/brand/directions.md` (Figma notes, the four briefs, the scores, the pick and what carries into D.4/D.5, e.g. whether the drop corner is kept); architecture §9.11 says the direction is chosen; `docs/brand/README.md` links the new file.

**Left out on purpose:** the R6 states, the restaurant app and portal screens, dark mode, motion prototypes, the full 44 icons (D.5), component sheets (D.6/D.7 cycles), any token change (a needed value goes to a later token PR, noted in directions.md).

**Checks:** a Markdown-only change, so the `checker` runs Prettier and the instruction size check.

### Plan

- [x] Read the cited sections and write the design here.
- [x] Read the Figma file in the built-in browser; write the Figma notes and the four briefs in `docs/brand/directions.md`.
- [x] Create the canvas with the token sheet, CoFo assets and direction A's four artboards. (Built as four templates on the canvas's «القوالب» page, `Home`, `Captain`, `Board`, `Icons`, each with a `look` prop A to D, plus a shared `Icon`; each direction's artboards are thin wrappers. The home artboard is 390×1400, the whole scroll, so the busy and closed cards show.)
- [ ] Draw directions B, C and D.
- [ ] Score the four on the canvas and in `directions.md`; the owner picks one.
- [ ] Record the pick (directions.md, architecture §9.11, brand README); review; hand over to D.4; pull request.

## Waiting for the owner

- From `test/money-properties` (merged, PR 246): what an outcome posts when a restaurant-funded discount exceeds what the clearing account holds (`outcomeEntries` throws today; the property skips that case).
- D.1: the `FONTS_DEPLOY_KEY` secret (the private half of a read-only deploy key on `fox-drop-fonts`, no expiry; commands in the pull request thread) in the repository's Actions secrets; until then the CI fetch step skips. (The owner confirmed on 2026-11-21 that he holds the right to use every font in the pack, CoFo included, in the apps.) The meaning of the `broken-edges` icon SVGs and of the `variant-b/c` icons.
- Phase 3 of `docs/claude-code-workflow.md`: the phase 4 session started at 75.7K tokens with one MCP delta (goal: under 45K, none). Left: the `marketing` and `social-media-skills` plugins, off only in the app's settings.
- Phase 6 items 1 and 2 (owner decision 2026-11-21): `autoCompactWindow: 350000` and every slice in two sessions, planning then build (`build-slice`). L.1c was the first trial; record its measurement (`scripts/claude-audit.mjs`, against L.1a and L.1b) in `docs/claude-code-workflow.md`.
- L.1c's choices to confirm (`docs/slice-notes.md` «Left from L.1c»): the 1 km fit of a kept read, and the rest under «Decided by us».

## After that

L.2 The permission matrix (branch `test/permission-matrix`; read first: architecture §18.1, AP §6 and §14 item 2, RA §22 item 2, the AP-2 and RA-2 rows of `docs/launch/dod-checklist.md`, `apps/server/CLAUDE.md` «Deny by default», the route table in `apps/server/src/modules/identity/admin-team.test.ts`), then the rest of launch readiness from L.3 (`docs/roadmap.md`).

Branches of Phase D: D.4 `feat/design-system-project`, D.5 `feat/icon-set`, D.6 `feat/ui-web`, D.7 `feat/core-ui`. Branches of the later slices: L.3 `feat/captain-simulator`, L.4 `test/load-k6`, L.5 `chore/pgbackrest`, L.6 `feat/monitoring-alerts`, L.7 `chore/production-environment`, L.8 `test/patrol-e2e`, L.9 `docs/device-lab`, L.10 `docs/staging-rehearsal`, L.11 `chore/launch`.
