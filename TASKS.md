# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs. At most 8 KB: the notes of earlier slices live in `docs/slice-notes.md`.

## Current task

D.7 `packages/core_ui` (`docs/roadmap.md` Phase D): the theme from the tokens, widgetbook, golden tests, Button and Icon. The owner sees them in widgetbook.

- **Branch:** `feat/core-ui`.
- **Cited:** architecture §9.5 (R1 to R9), §9.7, §9.9, §9.10; `apps/customer/CLAUDE.md` for the Flutter rules; `packages/core_tokens` (generated from design-tokens 0.4.0); `docs/code/packages/design-tokens.md` «Icons (D.5)» (stroke 2/24 of the size, `mirror` under RTL; the painter parses the path data, arcs and relative commands included); `docs/code/packages/ui-web.md` for the Button decisions to match; `docs/slice-notes.md` «Left from D.6» and «Left from D.5».
- **Approved already:** the Button set and states on the Component proposals sheet (D.6, 2026-11-23; R10 states 2026-11-24): four variants plus icon circles, no shadow, compact 40 for the panel only, loading = spinner with the width kept. The 44 icons (D.5).

### Design

**Owner decisions (2026-11-23, planning):** (1) the D.6 approval covers Flutter: hover where a mouse is (the merchant app on Windows), pressed carries the feedback on touch; no new sheet. (2) Hybrid base, now §9.7 and §9.10: simple components on the widgets layer, complex ones may wrap `material_ui` inside `core_ui`; apps never import Material. (3) The R2 lint is built and tested now and runs on `core_ui`; each app turns it on in its own screen slice (the apps are plain Material today, by the design stop). (4) Goldens run on Linux in Docker and in a CI job, with CoFo, like the web `visual` job. (5) The owner sees widgetbook as a Windows app (`flutter run -d windows`).

**`packages/core_ui`** (Flutter, workspace member, depends on `core_tokens`, exact pins). Widgets are `Fox*`; inside `core_ui` import `core_tokens` with a prefix (`as t`) since it also has `FoxButton` and `FoxIcons`. Apps import `core_ui` only, never `core_tokens`.

- **Theme** `lib/src/theme/`: `FoxThemeData` (colours as `Color`, `ButtonTokens` as `Color`/`double`, `TypeScale` as `TextStyle` with `FoxFont.family` and tabular figures (`FontFeature.tabularFigures()`) on the `number` role, shadows as `BoxShadow`, durations, `FoxEasing.standard` as `Cubic`). Two constructors: `.phone()` (customer, merchant: `FoxColors.light`, `FoxType.phone`) and `.captain()` (`captainLight`, `FoxType.captain`). Light only (dark copies light, §9.2). `FoxTheme` InheritedWidget plus `FoxTheme.of(context)`. No Material `ThemeData`. Tests: each field equals its token.
- **`FoxIcon`** `lib/src/icon/`: `FoxIcon(FoxIconName name, {size: sm|md|lg, label, color})`; a `CustomPainter` draws `FoxIcons.<name>.paths` scaled from 24, stroke 2/24 of the size, round caps and joins, colour from `DefaultTextStyle` or `color`. `path_data.dart` parses M L H V C S Q T A Z, absolute and relative, into a `Path` (`arcToPoint` for A; S and T reflect the last control point). `mirror` icons flip under `TextDirection.rtl`. No label → `ExcludeSemantics`; label → `Semantics(label, image: true)`. Tests: every icon in `FoxIcons.all` parses and its bounds lie in 2..22; one hand-checked path per command; only `back`, `car`, `motorcycle` flip in RTL.
- **`FoxButton`** `lib/src/button/`: as `docs/code/packages/ui-web.md` «Button» (variants primary, secondary, danger, ghost; `icon`, `iconEnd`; icon-only circle with a required `label`; `loading`, `disabled`; `onPressed`). Comfortable only (50 high, label = `subtitle`, icons md): compact 40 is the panel's, a web app. Built on `FocusableActionDetector` (Enter and Space through `ActivateIntent`, hover, focus highlight) and a `GestureDetector`; colours fade with `AnimatedContainer` over `duration.base`, nothing moves; focus ring 2 in `button.focus-ring` with a gap of 2 in `surface`, keyboard focus only (`FocusHighlightMode.traditional`). Loading: label kept at opacity 0 (width kept, name kept), a spinner arc painter on top, static under `MediaQuery.disableAnimations`, presses ignored, `Semantics(enabled: false)` but still focusable. Disabled: not focusable. Semantics: `button: true`, the label; min 48 × 48. `const buttonStates` and `buttonVariants` lists for R3. Tests: semantics, keyboard, disabled and loading ignore taps, start icon on the right in RTL, no overflow at `TextScaler.linear(1.3)` and 2.0, each state paints its token.
- **Goldens (R9, R10):** `test/golden/`, tagged `golden`; `dart_test.yaml` skips the tag in plain `flutter test`. `loadFoxFonts()` (`lib/testing.dart`) registers CoFo 400/500/700 from the repo's `.fonts/` with `FontLoader` and throws when missing (never skips). Every variant × state (rest, hover, focus, pressed, disabled, loading), with icon, icon-only, captain theme, 130% text; icons sheet at three sizes and mirrored. `scripts/golden-docker.mjs` runs them in a pinned Linux Flutter 3.47.9 image (the build checks `ghcr.io/cirruslabs/flutter:3.47.9` exists; else install the `.fvmrc` Flutter in a pinned Ubuntu image), `--update-goldens` passes through. CI: a `golden` job in the same image fetches fonts (`FONTS_DEPLOY_KEY`), runs the tag, uploads failures; `verify` requires it. `classify-changes.mjs` runs it on Dart changes.
- **widgetbook** `apps/widgetbook` (Windows only, workspace member, exact `widgetbook` pin compatible with Flutter 3.47; check it does not force Material on `core_ui`): one use case per state of every `core_ui` component, RTL Arabic, a theme addon for phone and captain, a text-scale addon. `main` calls `loadFoxFonts()`. R3 test in `core_ui` or widgetbook: every exported widget has a use case for each name in its `*States`.
- **R2/R5 lint** `packages/fox_lints`: an analyzer plugin (`analysis_server_plugin`, so `dart analyze` runs it; fall back to `custom_lint` only if the plugin API is not usable on this SDK, and write why). Rules: `no_color_literal` (`Color(…)`, `Color.fromARGB/RGBO` with literals), `no_literal_spacing` (number literals in `EdgeInsets*`, `SizedBox` width/height, `TextStyle`), `no_material_import` (`material.dart`, `cupertino.dart`, `material_ui`, `cupertino_ui`; off in `core_ui`), `no_physical_direction` (`EdgeInsets.only(left/right)`, `Alignment.*Left/Right`, `Positioned(left/right)`). Tests over fixture files. On in `core_ui`; `core_ui` may use literals only in the theme mapping, where it reads tokens.
- **Docs:** `packages/core_ui/CLAUDE.md`, `docs/code/packages/core_ui.md`, `apps/customer/CLAUDE.md` «Design stop» points at `core_ui` and the per-app R2 switch. Mark the Button and state sheets on Component proposals superseded (§9.9 step 4; `packages/design-tokens/CLAUDE.md` «Sync»).

**Left out:** wiring `core_ui` into the apps and bundling CoFo in them (screen slices); compact density in Flutter; dark mode; money and the ₺ fallback (D.8); a hosted widgetbook; the icon accent layer.

### Plan

- [x] Read the cited sections and write the design here
- [ ] `core_ui` package and theme, with tests
- [ ] `FoxIcon` and the path parser, with tests
- [ ] `FoxButton`, with tests
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

D.8 onward (component batches, `docs/roadmap.md`). Then L.2 The permission matrix (`test/permission-matrix`; read first: architecture §18.1, AP §6 and §14 item 2, RA §22 item 2, the AP-2 and RA-2 rows of `docs/launch/dod-checklist.md`, `apps/server/CLAUDE.md` «Deny by default», the route table in `apps/server/src/modules/identity/admin-team.test.ts`), then L.3 `feat/captain-simulator`, L.4 `test/load-k6`, L.5 `chore/pgbackrest`, L.6 `feat/monitoring-alerts`, L.7 `chore/production-environment`, L.8 `test/patrol-e2e`, L.9 `docs/device-lab`, L.10 `docs/staging-rehearsal`, L.11 `chore/launch`.
