# D.P2 The web and Flutter parity check in CI

Status: Done · Tier: T0 (CI) · Branch: `test/component-parity`
Spec: architecture §9.5 R9, §9.8 (as rewritten by D.P1) · Definition of done: a pull request that makes a web or Flutter component differ from its component tokens fails, and every pull request touching a component carries a side-by-side image of both platforms.

## Goal

The two platforms are held to one measure. A pixel diff between Chromium and Flutter's rasteriser would be flaky (fonts and anti-aliasing differ), so the gate measures, and people look:

- **Gate (fails CI):** each side renders every component state listed in the registry and measures it (height, padding, gap, radius, border width, colours of fill, border and label, shadow) and compares with the component tokens. Both sides answer to the same tokens, so they match each other.
- **Report (for review):** for each changed component, one image with the web story's screenshot beside the Flutter golden of the same states, uploaded as a CI artifact and linked in the pull request.

## Plan

1. Registry: each entry gains `metrics`, the states and the token each measured value must equal.
2. Web: `packages/ui-web/e2e/parity.spec.ts` (functional project) walks the registry, opens each state's story and measures with `getComputedStyle` and the bounding box.
3. Flutter: `packages/core_ui/test/parity_test.dart` pumps each state and reads the render box and decoration against `core_tokens`.
4. Report: `scripts/parity-report.mjs` pairs the visual project's screenshots with the goldens into one PNG per component (an image library pinned once here if none is present).
5. CI: `ci.yml` and `scripts/verify.mjs` run both checks in their existing e2e and flutter jobs and upload the report; `scripts/classify-changes.mjs` runs them for a change under `ui-web`, `core_ui`, `design-tokens/tokens/component` or the registry.
6. First real use: Button and the form components, which already have `button.json` and `input.json`.

Files (hand-written count, 13): `packages/design-tokens/components.json`, `src/components.test.ts`, `packages/ui-web/e2e/parity.spec.ts`, `packages/ui-web/playwright.config.ts`, `packages/core_ui/test/parity_test.dart`, `packages/core_ui/test/parity_table.dart`, `scripts/parity-report.mjs`, `scripts/verify.mjs`, `scripts/classify-changes.mjs`, `scripts/classify-changes.test.mjs`, `.github/workflows/ci.yml`, `REVIEW.md`, `docs/code/packages/core_ui.md`.

Tests written first (locked in the red phase): `parity.spec.ts` and `parity_test.dart` over Button and the form components (each fails when a value is changed by hand on one side); `classify-changes.test.mjs` cases for the new paths.

## As built

- **Registry (`components.json`, `src/components.ts`):** each measured component has `metrics`: `web` (the CSS selector of the measured box), a shared `expect` and its `states` (`state`, `story`, optional `act` hover, press or focus, optional `only` web or flutter, and `expect`: each metric and its dotted token, or `none` for a colour). Metrics: height, width, paddingInline, radius, borderWidth, gap, background, border, foreground. First use: Button (the four variants at rest, hover, pressed and disabled, the web's compact, an icon's gap), TextField, TextArea, SearchField (rest, hover, focus, invalid, disabled; the web's compact), Checkbox and Switch (rest, hover, pressed, on, invalid, disabled): 49 states on the web, 44 in Flutter, each measured on the phone and the captain theme (the captain's block of `tokens.css` over `:root`): 98 web tests, 88 Flutter tests plus the table's own.
- **Expected values:** both sides read the light theme from `generated/tokens.css`, the resolved output both platforms are generated from, so neither keeps its own copy of the tokens. Corners are compared as drawn (no more than half the box: `radius.full` is 25 on a 50 button); an outline in the fill's own colour counts as none (Flutter's primary Button paints one).
- **Gate:** `e2e/parity.spec.ts` (functional project) and `test/parity_test.dart` with `test/parity_table.dart`; both run in their existing jobs (`e2e` for ui-web, `flutter`), so `verify.mjs` only adds the report's unit test to its script tests. `classify-changes.mjs` counts the registry and `tokens.css` as sources of `core_ui` (its Dart tests read them).
- **Report:** `scripts/parity-report.mjs` crops each measured story's committed phone screenshot to its content and lays it beside the Flutter design-system golden in Chromium (ui-web's Playwright, no new image library); CI's `parity-report` job (pull requests with `visual` or `golden`) uploads the PNGs and links them in the run's summary. It is not a gate and `verify` does not wait for it.
- **What the gate found on its first run, each fixed toward the approved sheet:** the disabled ghost FoxButton was filled (`button-sheet.ts:111` keeps it transparent); the web's disabled Switch kept its blue track and the disabled Checkbox its white box, because a lone `data-disabled:` lost to `data-unchecked:` (`forms-sheet.ts:212-233`). The images of those states changed with them.
- **Review (high, and the security review):** no blocking finding. Fixed: the captain theme is measured on both sides (the owner unlocked the tests for it, 2026-11-25); a metric must name a token of `tokens/component/` (the test compared a path with itself); Flutter reads the start-start corner as the web does; the web measures once the box's transitions have finished; the Switch's outline is measured (`none`); the report job's checkout keeps no token; `parity-report/` is ignored.
- **Left out (backlog):** RadioGroup, QuantityStepper, Select, CodeField, PhoneField and Field metrics; a shadow metric (no measured component has one yet); the Checkbox mark and the Switch thumb colours.

## Stopped at

Done: reviewed (two rounds, no blocking finding left), `--changed` green; the pull request is open with auto-merge.

## Evidence

- `node scripts/verify.mjs --changed`: «the checks of the change passed» (Turborepo lint, types, build and smoke tests; Dart analyze, fox_lints, format and Flutter tests of the 6 changed or dependent packages; server tests skipped, nothing they read changed).
- After the review fixes, `--changed` passed every step but one test outside the slice: `core_auth/test/session_test.dart` «retries a refresh that got no answer» failed twice under the run's parallel load and passed 3 of 3 alone (its real-time refresh waits, already in the backlog's «Real-time waits left in tests»). Web parity 98 passed, Flutter parity 89 passed on their own.
- Full `pnpm verify` (the slice changes `verify.mjs` and CI): every step passed but two that come from this machine's generator: the regenerated Dart client came out unformatted (long lines in `packages/core_api`), so «committed files current» and «Dart format» failed. The branch touches no route or schema; the regenerated files were restored and CI's `contract` job is the judge.
- `pnpm baselines`: 8 images changed (the two ghost Button goldens; the disabled Checkbox, disabled checked Checkbox and disabled Switch screenshots on phone and captain), looked at, committed on their own; both suites then compared clean.
- A deliberate one-side change shown failing, then reverted: Flutter padding set to `button.gap` → 17 states failed `paddingInline: 8.0 ≠ 16.0 (button.padding-inline)`; the web's primary fill set to danger → `background: #BF2929 ≠ #FF6E31 (button.primary.background)`. Both reverted; web 49 passed, Flutter 44 states passed.
- Red phase: `components.test.ts` failed «measures the Button and the form components», `parity_test.dart` failed «the table builds exactly the states the registry lists», `classify-changes.test.mjs` failed its D.P2 case.
- Review: `reviewer` at high, full list, and `security-reviewer` (CI change). The pull request has `## Checks changed`.

## Before deploying

Nothing.

## To check on staging

Nothing new.

## Notes for the next session

Needs D.P1. Each later slice adds its components to the registry's `metrics`; it adds no test file.
