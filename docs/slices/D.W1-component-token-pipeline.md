# D.W1 The component token pipeline and the raw-value check

Status: Planned · Tier: T2 · Branch: `feat/component-token-pipeline`
Spec: architecture §9.1, §9.2 (the component layer), §9.5 R1, R2, R9 · Definition of done: workflow §4 (UI items)

## The web-first plan (owner, 2026-11-26)

Every component is built on the web first (`ui-web`) and only web components show in the Fox Drop Design System; a Flutter twin (`core_ui`) is built when a screen needs it and is checked against the web one on a side-by-side parity sheet. The plan, in ten slices (owner, 2026-11-26: up to about 40 hand-written files for the migration and batch slices, D.W3 and D.W4, because their work repeats; D.W1, D.W2 and D.W5 keep the 25 of workflow §3.1):

| Slice | Delivers                                                                                                                  | Runs with                       |
| ----- | ------------------------------------------------------------------------------------------------------------------------- | ------------------------------- |
| D.W1  | The generic component-token pipeline (CSS and Dart from one source) and the checks on both sides                          | D.W2                            |
| D.W2  | The parity sheet: a web Storybook shot beside the Flutter render of the same state, same size                             | D.W1                            |
| D.W3a | Tokens and parity: forms and actions (twins)                                                                              | any other D.W3 or D.W4 slice    |
| D.W3b | Tokens and parity: data display (twins) and the data table                                                                | any other D.W3 or D.W4 slice    |
| D.W3c | Tokens and parity: overlays, tabs and the icon (twins), the web-only overlays                                             | any other D.W3 or D.W4 slice    |
| D.W4a | Web versions: date, time, country sheet, code preview (after D.W3a)                                                       | any other D.W3 or D.W4 slice    |
| D.W4b | Web versions: countdown ring, order row, logo, tracking steps; with the timer and order card twins                        | any other D.W3 or D.W4 slice    |
| D.W4c | Web versions: restaurant card, dish card, bottom sheet, pull to refresh                                                   | any other D.W3 or D.W4 slice    |
| D.W4d | Web versions: restaurant bar, bottom navigation, sign-in hero, blocking heads; with the top bar and navigation rail twins | any other D.W3 or D.W4 slice    |
| D.W5  | The Flutter cards leave the Design System; the approval rule is documented                                                | last, after every D.W3 and D.W4 |

Rules shared by every slice of the plan:

- **Tokens arrive with their component** (owner, 2026-11-26): a component's file in `tokens/component/` is written in the slice that moves both of its sides onto it, never before (no unread tokens).
- **One owner per file.** Each slice names the files it edits; no two slices in flight edit the same hand-written file (workflow §7 as amended on 2026-11-26). A Flutter file that holds a twin and a Flutter-only component (`fox_timer.dart`, `fox_order_card.dart`, `fox_top_bar.dart`, `fox_navigation.dart`) belongs to the D.W4 batch that builds the web version, so the twin moves with it.
- **Append-only shared files**, resolved when rebasing, one merge at a time: `packages/design-tokens/package.json` (version) and `CHANGELOG.md`, `packages/ui-web/src/index.ts`, `packages/ui-web/scripts/bundle.ts`, `bundle-entry.ts`, `docs.ts`, `packages/ui-web/test/stories.test.ts`, `docs/code/packages/ui-web.md`, `core_ui.md`, `design-tokens.md`, `docs/roadmap.md`. The slice that merges second rebases, runs `pnpm --filter @fox-drop/design-tokens generate`, takes the next minor version and runs `--changed` again. Generated outputs (`tokens.css`, `tailwind.css`, `tokens.g.dart`, `design-system.json`) are regenerated, never merged by hand.
- **A parity gap** (D.W3, D.W4): the owner decides on the sheet; the approved batch sheet (D.8, D.9, D.10, D.11b) wins where it shows the state, else the web wins. Every gap and its fix are listed in the slice file.
- **Not restored:** the D.P1 to D.P11 plan and its files (PR 302). No component registry and no pixel-diff gate: the parity sheet is reviewed once per twin; the existing screenshots and goldens guard later changes.

## Goal

Any file in `tokens/component/` becomes CSS variables and Dart constants for every theme without touching the generator, and declares the web and Flutter folders that read it; a test fails when a declared token is not read on one side, and both sides refuse raw values in component code.

## Plan

0. No design checkpoint: no look changes (the literals replaced keep their values; the screenshots and goldens must not move).
1. Tokens (`packages/design-tokens`):
   - `src/generate.ts`: the Dart output loops over every component file instead of the two hard-coded `component('button', …)` and `component('input', …)` calls, and adds one `ComponentTokens` class per theme holding every component (`FoxComponents.light.card…`), so a new component needs no hand change in `core_ui`. The CSS output already takes every token; checked by the test.
   - Each component file declares its folders in `$extensions["app.foxdrop"]`: `{ "web": ["button"], "flutter": ["button"] }` (folder names under `packages/ui-web/src/` and `packages/core_ui/lib/src/`). The generator ignores the extension. `button.json` declares its folders here; `input.json` waits for D.W3a, which moves the form family onto it.
   - `src/component-usage.test.ts` (new): for every component file with `$extensions`, each of its tokens is read in its web folders (`--fd-<path>`) and its Flutter folders (the Dart field), and a declared folder exists. Text scan of the source, no build.
2. Web: `eslint.web.mjs` extends the design rule inside `packages/ui-web/src` to the numeric classes it does not yet catch (`duration-*`, `delay-*`, `opacity-*`, `leading-*`, `tracking-*`, `text-<n>`, `rounded-<n>`, `stroke-<n>`, `border-<n>`); `test/lint.test.ts` proves each. The about 11 existing sites are replaced by tokens of the same value (a foundation token, or the component's own token when the component already has a file).
3. Flutter: `packages/fox_lints` adds `no_literal_dimension` over `core_ui`: a number literal other than 0 in `Radius.circular`, `BorderRadius.circular`, `BorderSide(width:)`, `SizedBox`/`Container`/`BoxConstraints` sizes, `TextStyle(fontSize:, height:, letterSpacing:)`, `FoxIcon(size:)`, `Offset`, `BoxShadow(blurRadius:, spreadRadius:)` and `Duration(milliseconds:)`. Matched on Flutter's own classes, as the other rules. The about 13 existing sites are fixed the same way; `mark_geometry.dart` is drawing geometry in the mark's own unit square, so painters (`CustomPainter` subclasses and their helpers) are out of the rule's scope, written in its doc and tested. `core_ui`'s theme exposes the generated bundle as `FoxThemeData.components`.
4. Docs: architecture §9.2 (the component layer declares its folders) and §9.5 R1, R2 «Enforced by»; `packages/design-tokens/CLAUDE.md` (adding a component file), `packages/fox_lints/CLAUDE.md` (the new rule); `docs/code/packages/design-tokens.md`.

Files (hand-written count, 24):

- Tokens (7): `packages/design-tokens/src/generate.ts`, `src/tokens.test.ts`, `src/component-usage.test.ts` (new), `tokens/component/button.json`, `CHANGELOG.md`, `package.json` (0.14.0), `CLAUDE.md`.
- Web (5): `eslint.web.mjs`, `packages/ui-web/test/lint.test.ts`, and the files holding the 11 sites (measured at the start: `rg -n "\b(duration|delay|opacity|leading|tracking|rounded|stroke|border|text)-[0-9]" packages/ui-web/src --glob '!*.stories.tsx'`), about 3.
- Flutter (9): `packages/fox_lints/lib/src/rules.dart`, `lib/main.dart`, `test/rules_test.dart`, `CLAUDE.md`, the root `analysis_options.yaml` (the rule's code), `packages/core_ui/lib/src/theme/fox_theme.dart`, `packages/core_ui/test/theme_test.dart`, and the files holding the 13 sites, about 2 (`empty_state/fox_empty_state.dart` and the ones the rule finds).
- Docs (3): `docs/architecture/09-design-system.md`, `docs/code/packages/design-tokens.md`, this file.

Not touched (D.W2 runs in parallel): `packages/ui-web/e2e/`, `playwright.config.ts`, `packages/ui-web/CLAUDE.md`, `packages/core_ui/test/parity/`, `packages/core_ui/dart_test.yaml`, `packages/core_ui/CLAUDE.md`, `docs/code/packages/ui-web.md`, `docs/code/packages/core_ui.md`, the root `package.json`, `.gitignore`, `scripts/`.

Tests written first (locked in the red phase):

- `src/tokens.test.ts`: a component file added to a temporary copy of `tokens/` comes out in `tokens.css` and in `tokens.g.dart`'s `ComponentTokens` for every theme; `$extensions` stays out of both outputs.
- `src/component-usage.test.ts`: `button.json` passes; a fixture with a token no web file reads, one no Flutter file reads, and one naming a missing folder each fail with the token's name.
- `packages/ui-web/test/lint.test.ts`: each new numeric class is reported in `packages/ui-web/src`, and the token form passes.
- `packages/fox_lints/test/rules_test.dart`: `no_literal_dimension` reports each listed constructor with a literal, passes 0, a token and a painter.
- `packages/core_ui/test/theme_test.dart`: `FoxTheme.of(context).components.button` equals `FoxComponents.<theme>.button` in the phone and captain themes.
- Proof of no look change: `pnpm baselines --check` finds no moved image.

## Decisions taken overnight (pending the owner)

The owner was asleep and delegated decisions to the supervising session (2026-11-26); each took the recommended option.

1. **0 is allowed on the web too.** The Flutter rule passes 0 (plan step 3); the web rule does the same (`opacity-0`, `border-b-0`), since 0 means "none", not a design value, and Tailwind builds it. So the about 11 `opacity-0` sites the plan counted stay; the web sites replaced are `border-t-2` (amounts summary, now `border-width.thick`) and `border-s-4` (sidebar, new `border-width.heavy`). The new class check is its own rule, `fd/component-design`, in ui-web only.
2. **A token can belong to one side.** `button.compact.height` is the panel's density; the Flutter button has none. Rather than a Flutter getter nobody reads, the token says `"$extensions": { "app.foxdrop": { "sides": ["web"] } }` and the usage check skips Flutter for it.
3. **The Flutter rule reads literals anywhere in the argument** (`touchTarget * 6`), as the plan's 13 sites imply, except a divisor of 2 (a half: a circle's radius, a centre) and inside painters. Painters are `CustomPainter` and `CustomClipper` subclasses; their helpers are functions and methods that take a `Canvas` or return a `Path`. It runs on `core_ui`'s `lib/` only: tests pin sizes and wait set times. A direct literal in `SizedBox` or `TextStyle` stays `no_literal_spacing`'s report, so nothing is reported twice. `Duration(milliseconds:)` matches `dart:core`'s class; `FoxIcon(size:)` matches `core_ui`'s.
4. **Nine Flutter sites, all value-for-value** (no golden moves): the menu's widths and the anchored list's height get `size.menu-min-width`, `menu-max-width`, `menu-max-height`; the separator `FoxBorderWidth.thin`; the bottom bar's pill `FoxSize.bar` (64 = 48 + 2 × 8); the blocking heads' bubble `FoxSize.tooltip` (240 = 48 × 5); the tabs' underline new `border-width.indicator` (3); the sheet's and toast's slides new `motion.enter.sheet` (1) and `motion.enter.toast` (0.15). The empty state's drop is a painter, out of scope. Three of these are parity gaps with the web (the menu's minimum width, the underline 3 against 4, the toast's rise) and are left to D.W3c, where the owner decides on the sheet.
5. **Two locked tests were corrected, not weakened:** the usage fixture's Flutter file had to read `gap` for the "unread on the web" case to fail on the web alone, and the lint test's stub `TextStyle` lacked `letterSpacing`.

## Stopped at

All layers built; `--changed`, baselines and review next.

## Evidence

- `node scripts/verify.mjs --changed`:
- Review:

## Before deploying

Nothing.

## To check on staging

Nothing new.

## Notes for the next session

The fox_lints rule recompiles the editor plugin (6 to 9 minutes, `packages/fox_lints/CLAUDE.md`); run the check through `tool/check.dart`.
