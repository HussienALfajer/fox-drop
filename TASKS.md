# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs. At most 8 KB: the notes of earlier slices live in `docs/slice-notes.md`.

## Current task

D.7 `packages/core_ui` (`docs/roadmap.md` Phase D): the theme from the tokens, widgetbook, golden tests, Button and Icon. The owner sees them in widgetbook.

- **Branch:** `feat/core-ui`.
- **Cited:** architecture §9.5 (R1 to R9), §9.7, §9.9, §9.10; `apps/customer/CLAUDE.md` for the Flutter rules; `packages/core_tokens` (design-tokens 0.5.0); `docs/code/packages/design-tokens.md` «Icons (D.5)»; `docs/code/packages/ui-web.md` for the Button decisions to match; `docs/slice-notes.md` «Left from D.6» and «Left from D.5».
- **Approved already:** the Button set and states on the Component proposals sheet (D.6, 2026-11-23; R10 states 2026-11-24): four variants plus icon circles, no shadow, compact 40 for the panel only, loading = spinner with the width kept. The 44 icons (D.5).

### Design

**Owner decisions (2026-11-23, planning):** (1) the D.6 approval covers Flutter: hover with a mouse (merchant on Windows), pressed on touch; no new sheet. (2) Hybrid base, now §9.7 and §9.10: simple components on the widgets layer, complex ones may wrap `material_ui` inside `core_ui`; apps never import Material. (3) The R2 lint is built and tested now and runs on `core_ui`; each app turns it on in its own screen slice (the apps are plain Material today, by the design stop). (4) Goldens run on Linux in Docker and in a CI job, with CoFo, like the web `visual` job. (5) The owner sees widgetbook as a Windows app (`flutter run -d windows`).

**`packages/core_ui`** (Flutter, workspace member, depends on `core_tokens`, exact pins). Widgets are `Fox*`; inside `core_ui` import `core_tokens` with a prefix (`as t`) since it also has `FoxButton` and `FoxIcons`. Apps import `core_ui` only, never `core_tokens`.

- **Theme** `lib/src/theme/`: `FoxThemeData` (colours as `Color`, button tokens, `TypeScale` as `TextStyle` in `FoxFont.family`, tabular figures on `number`, `BoxShadow`s, durations, `FoxEasing.standard` as `Cubic`). Two constructors: `.phone()` (customer, merchant: `FoxColors.light`, `FoxType.phone`) and `.captain()` (`captainLight`, `FoxType.captain`). Light only (dark copies light, §9.2). `FoxTheme` InheritedWidget plus `FoxTheme.of(context)`. No Material `ThemeData`. Tests: each field equals its token.
- **`FoxIcon`** `lib/src/icon/`: `FoxIcon(FoxIconData icon, {size: FoxIconSize.sm|md|lg, label, color})` (no name enum exists; `core_ui` re-exports `FoxIcons`); a `CustomPainter` draws `FoxIcons.<name>.paths` scaled from 24, stroke 2/24 of the size, round caps and joins, colour from `DefaultTextStyle` or `color`. `path_data.dart` parses M L H V C S Q T A Z, absolute and relative, into a `Path` (`arcToPoint` for A; S and T reflect the last control point). `mirror` icons flip under `TextDirection.rtl`. No label → `ExcludeSemantics`; label → `Semantics(label, image: true)`. Tests: every icon in `FoxIcons.all` parses and its bounds lie in 2..22; one hand-checked path per command; only `back`, `car`, `motorcycle` flip in RTL.
- **`FoxButton`** `lib/src/button/`: as `docs/code/packages/ui-web.md` «Button» (variants primary, secondary, danger, ghost; `icon`, `iconEnd`; icon-only circle with a required `label`; `loading`, `disabled`; `onPressed`). Comfortable only (50 high, label = `subtitle`, icons md): compact 40 is the panel's, a web app. On `FocusableActionDetector` (Enter and Space, hover, focus) and a `GestureDetector`; colours fade over `duration.base`, nothing moves; focus ring 2 in `button.focus-ring`, gap 2 in `surface`, keyboard focus only. Loading: label at opacity 0 (width and name kept), a spinner painter on top (static under `disableAnimations`), presses ignored, still focusable. Disabled: not focusable. Semantics `button`, the label; min 48 × 48. `buttonStates`, `buttonVariants` for R3. Tests: semantics, keyboard, disabled and loading ignore taps, start icon right in RTL, no overflow at text scale 1.3 and 2.0, each state paints its token.
- **Goldens (R9, R10):** `test/golden/`, tagged `golden`; `dart_test.yaml` skips the tag in plain `flutter test`. `loadFoxFonts()` (`lib/testing.dart`) registers CoFo 400/500/700 from the repo's `.fonts/` with `FontLoader` and throws when missing (never skips). Every variant × state (rest, hover, focus, pressed, disabled, loading), with icon, icon-only, captain theme, 130% text; icons sheet at three sizes and mirrored. `scripts/golden-docker.mjs` runs them in a pinned Linux Flutter 3.47.9 image (`ghcr.io/cirruslabs/flutter:3.47.9` if it exists, else the `.fvmrc` Flutter on a pinned Ubuntu), passing `--update-goldens`. CI: a `golden` job in that image fetches fonts (`FONTS_DEPLOY_KEY`), runs the tag, uploads failures, required by `verify`, run on Dart changes.
- **widgetbook** `apps/widgetbook` (Windows, workspace member, exact pin that works on Flutter 3.47): a use case per state of every component, RTL Arabic, phone and captain theme addon, text-scale addon; `main` calls `loadFoxFonts()`. R3 test: every exported widget has a use case for each name in its `*States`.
- **R2/R5 lint** `packages/fox_lints`: an analyzer plugin (`analysis_server_plugin`, run by `dart analyze`; `custom_lint` only if the plugin API fails on this SDK, with the reason). Rules: `no_color_literal`, `no_literal_spacing` (numbers in `EdgeInsets*`, `SizedBox`, `TextStyle`), `no_material_import` (off in `core_ui`), `no_physical_direction` (`left`/`right` in insets, alignment, `Positioned`). Fixture tests. On in `core_ui`, except the theme mapping.
- **Docs:** `packages/core_ui/CLAUDE.md`, `docs/code/packages/core_ui.md`, the «Design stop» line in `apps/customer/CLAUDE.md`. Mark the Button and state sheets superseded (§9.9 step 4, design-tokens «Sync»).

**Left out:** wiring into the apps and bundling CoFo there (screen slices); Flutter compact density; dark mode; money and ₺ (D.8); a hosted widgetbook.

### Plan

- [x] Read the cited sections and write the design here
- [x] `core_ui` package and theme, with tests
- [x] `FoxIcon` and the path parser, with tests
- [x] `FoxButton`, with tests
- [ ] Goldens: font loader, Docker script, baselines, CI `golden` job
- [ ] `apps/widgetbook` and the R3 coverage test
- [ ] `fox_lints` (R2, R5) with tests, on in `core_ui`
- [ ] Docs, sheets superseded, review, hand over to D.8

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

D.8 onward (component batches, `docs/roadmap.md`). Then L.2 The permission matrix (`test/permission-matrix`; read first: architecture §18.1, AP §6 and §14 item 2, RA §22 item 2, the AP-2 and RA-2 rows of `docs/launch/dod-checklist.md`, `apps/server/CLAUDE.md` «Deny by default», the route table in `apps/server/src/modules/identity/admin-team.test.ts`), then L.3 to L.11 (`docs/roadmap.md`).
