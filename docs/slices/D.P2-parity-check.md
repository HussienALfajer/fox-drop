# D.P2 The web and Flutter parity check in CI

Status: Planned · Tier: T0 (CI) · Branch: `test/component-parity`
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

## Stopped at

Not started.

## Evidence

- `node scripts/verify.mjs --changed`:
- A deliberate one-side change shown failing, then reverted.
- Review: `reviewer` at high, full list, and `security-reviewer` (CI change). The pull request has `## Checks changed`.

## Before deploying

Nothing.

## To check on staging

Nothing new.

## Notes for the next session

Needs D.P1. Each later slice adds its components to the registry's `metrics`; it adds no test file.
