# D.W2 The parity sheet

Status: Planned · Tier: T2 · Branch: `feat/parity-sheet`
Spec: architecture §9.1 (Flutter drawings are a visual reference), §9.5 R9, §9.7 · Definition of done: workflow §4 (UI items)

Part of the web-first plan (its table and shared rules: `D.W1-component-token-pipeline.md`). Runs in parallel with D.W1: the two slices edit no file in common.

## Goal

`pnpm parity Button` writes one HTML page per component: each state of the web component (its Storybook story) beside the Flutter twin in the same state, at the same width and pixel ratio, on the app's ground, in CoFo, RTL. The owner reviews it once when a twin is built or moved; nothing in CI compares the two.

## Plan

0. No design checkpoint: a review tool, no component changes. The owner sees Button's sheet at the end.
1. The Flutter side (`packages/core_ui/test/parity/`):
   - `parity.dart`: `parityCase(storyId, builder, {surface})` pumps the widget in a frame 360 logical pixels wide (the phone width of the screen goldens, §9.9 step 8), height from its content, pixel ratio 2, RTL, the phone or captain theme on `surface`, animations off, the fonts the goldens load; writes `<repo>/.parity/flutter/<storyId>-<surface>.png`. The cases are tests tagged `parity`, skipped unless `--run-skipped` is passed (the `parity` tag in `dart_test.yaml`), so `flutter test` and CI never run them.
   - `button_parity_test.dart`: one case per Button story, keyed by the story's id (`button--primary` …), on the phone and captain surfaces.
2. The web side (`packages/ui-web/e2e/parity.spec.ts`): a Playwright project `parity`, run only when `FD_PARITY` names the stories (left out of the default projects in `playwright.config.ts`, so `pnpm verify` and CI never run it), opens each story with `openStory` at a 360 wide viewport, device scale 2, transitions off, CoFo checked as in `visual.spec.ts`, and shoots `#storybook-root > *` to `<repo>/.parity/web/<storyId>-<surface>.png`.
3. The sheet (`scripts/parity.mjs`, root `package.json` script `parity`): takes component names (`Button`, `--all`); finds the Flutter cases by their story ids (`rg "parityCase\('…"` over `packages/core_ui/test/parity/`), runs the Flutter cases, builds Storybook if `dist/storybook` is older than `packages/ui-web/src`, runs the web project for the same ids, then writes `.parity/<Component>.html`: one row per state and surface, web on the start side, Flutter on the end side, both at their natural size (same scale), the width and height of each in pixels, and a row marked «no Flutter case» or «no story» when a pair is missing. Images inlined, so the page stands alone. `.parity/` is git-ignored. On the host by default (the sheet is a human review, not a baseline); `--docker` runs both sides in the baseline images when the host's text rendering misleads.
4. Docs: `packages/ui-web/CLAUDE.md` and `packages/core_ui/CLAUDE.md` (one line each: how a twin gets its parity cases and its sheet), `docs/code/packages/ui-web.md`, `docs/code/packages/core_ui.md`.

Files (hand-written count, 13):

- Flutter (3): `packages/core_ui/test/parity/parity.dart` (new), `packages/core_ui/test/parity/button_parity_test.dart` (new), `packages/core_ui/dart_test.yaml`.
- Web (2): `packages/ui-web/e2e/parity.spec.ts` (new), `packages/ui-web/playwright.config.ts`.
- Script (4): `scripts/parity.mjs` (new), `scripts/parity.test.mjs` (new), the root `package.json`, `.gitignore`.
- Docs (4): `packages/ui-web/CLAUDE.md`, `packages/core_ui/CLAUDE.md`, `docs/code/packages/ui-web.md`, `docs/code/packages/core_ui.md`, plus this file.

Not touched (D.W1 runs in parallel): `packages/design-tokens/`, `eslint.web.mjs`, `packages/ui-web/test/`, `packages/ui-web/src/`, `packages/fox_lints/`, `packages/core_ui/lib/`, `packages/core_ui/test/theme_test.dart`, `analysis_options.yaml`, `docs/architecture/`.

Tests written first (locked in the red phase):

- `scripts/parity.test.mjs` (node:test, as the other `scripts/*.test.mjs`): the pairing of story ids with Flutter case ids (a missing case and a missing story each give their marked row); the page's rows in story order, phone then captain; an image's size printed under it; `.parity/` paths only.
- `classify-changes.test.mjs` is unchanged and must stay green: `scripts/parity.mjs` and the `parity` tag run in no CI job (checked by reading `scripts/classify-changes.mjs`; a change to it is out of scope).
- Evidence, not a locked test: `pnpm parity Button` on the host, the page opened in the browser pane and shown to the owner.

## Decisions taken overnight (pending the owner)

- **`--docker` left out.** The plan offered it for when the host's text rendering misleads. Running both sides in the baseline images means changing `scripts/golden-docker.mjs` (it hard-codes `--tags golden` and its output folders) and `packages/ui-web/scripts/visual-docker.mjs` (it hard-codes `--project=visual`), both outside this slice's files. The host render was faithful on Button's sheet (CoFo on both sides, same sizes). Backlog item added; build it the first time a sheet misleads.
- **`scripts/parity.test.mjs` joins verify's script tests** (`SCRIPT_TESTS` in `scripts/verify.mjs`, one name added). Without it the locked test would run nowhere; the step takes seconds and runs in every `format` job.
- **The frame has 16 pixels around the widget on both sides** (`FoxSpace.md`; on the web, `padding: 16px` on the story's root, whose Storybook body padding is removed). Flush against the frame, the focus ring was cut on both sides.
- **The web ground is `--fd-color-surface`**, set on the story's root by the spec: Storybook leaves it white while the Flutter frame paints the theme's surface, and the plan asks for "the app's ground".
- **Flutter ids built in a loop** (`'button--${variant.name}-$state'`) are read back from the shots the run wrote; the source scan still decides which components have cases and finds the literal ids. The plan's `rg` scan alone would have missed 24 of Button's 33 cases.
- **No Flutter case** for the densities (`*-comfortable`, `*-compact`, `compact-with-icon`, `icon-only-compact`) and the three press-counting stories: FoxButton has one density, and the counter is a keyboard test. The sheet marks the 13 rows.

## Stopped at

Built; checks and pull request next.

## Evidence

- `node scripts/verify.mjs --changed`:
- `pnpm parity Button`:
- Review:

## Before deploying

Nothing.

## To check on staging

Nothing new.

## Notes for the next session

The page is a local file; to show it on another device, publish it as a private artifact (the screenshots carry no font file, only rendered glyphs).
