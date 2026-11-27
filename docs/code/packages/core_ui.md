# packages/core_ui

## D.R1 (2026-11-27): every component deleted

The owner deleted every Flutter component: each `lib/src/<component>/` folder (`FoxIcon` and `FoxButton` included), `lib/src/internal/` (Material scope, field box, focus ring, menus), the forms, data, overlays, navigation and sign-in widgets, their tests, review tests, goldens and parity cases, and `FoxButtonTheme`, `FoxInputTheme` and `FoxThemeData.components`. Only `lib/src/theme/` and the test helpers (`lib/testing.dart`, `test/golden/sheet.dart`, `test/forms_harness.dart`, `test/overlays_harness.dart`, `test/parity/parity.dart`) remain. The phone rules moved to `packages/core_auth` (`docs/code/packages/core_auth.md`). Their sections here went too; their history is in git before the D.R1 merge (`docs/slices/D.R1-delete-components-screen-first.md`). Each component returns after its web twin, with the first approved customer screen that needs it.

## Theme (D.7)

- `FoxThemeData` maps `core_tokens` to Flutter types: `FoxColorScheme` (every colour token as a `Color`), `FoxTextTheme` (each `TypeScale` role as a `TextStyle` in `FoxFont.family`, `leadingDistribution: even`, the weight from the token; `number` adds tabular figures; every style falls back to «Fox Lira», the ₺ that CoFo lacks, declared in `pubspec.yaml` from `assets/fonts/fox-lira`, SIL OFL, and loaded by `loadFoxFonts` too), `FoxShadows` (`BoxShadow`s), `iconWeight` (`FoxIconWeight.phone` 1.5, `.captain` 1.75) and `easing` (`FoxEasing.standard` as a `Cubic`). A component's tokens come back as `components.<name>` with the first approved component.
- `.phone()` is `FoxColors.light` with `FoxType.phone` (customer and merchant); `.captain()` is `captainLight` with `FoxType.captain`. Light only: dark copies light until it is designed (§9.2).
- `FoxTheme` is an `InheritedWidget`; `FoxTheme.of` throws a `FlutterError` naming the fix when no theme is above. No Material `ThemeData`: the apps still use Material until their screen slices, and `core_ui` never reads it.
- Tests (`test/theme_test.dart`): every field equals its token, for both themes.

## Goldens (D.7, R9)

- `test/golden/` holds a component's golden sheets (none since D.R1); `sheet.dart` pumps a sheet RTL at device pixel ratio 2 with animations off. `scripts/golden-docker.mjs` skips when no golden test exists.
- They run on Linux only, since font rasterising differs by platform: `scripts/golden-docker.mjs` builds `fox-drop-golden:<.fvmrc version>` (a digest-pinned Ubuntu with Flutter cloned at the `.fvmrc` tag, because no ready image of Flutter 3.47 exists), copies the files the host's git lists (so a worktree works) and `.fonts/` into the container, runs `flutter test --tags golden --run-skipped` with any extra arguments, and copies the goldens (to a new folder, then swapped in) and `failures/` back, owned by the host user. The `golden` CI job runs it on Dart changes and on changes to the fonts manifest or the font-fetch scripts, after fetching the fonts (`FONTS_DEPLOY_KEY`), and uploads the failures; `verify` requires it.
- `loadFoxFonts` (`lib/testing.dart`) walks up to `.fonts/cofo-sans-pro-arabic` and loads 400, 500 and 700; it throws when they are missing instead of skipping, so a golden never passes on a fallback font.

## Lints (D.7, R2, R5)

`packages/fox_lints` (its own `CLAUDE.md`) runs its rules in the check through a standalone checker (`dart packages/fox_lints/tool/check.dart`, next to `dart analyze --fatal-infos --no-plugins`, since #291); the analyzer plugin declared in the root `analysis_options.yaml` stays for the editor only. It checks `core_ui` and `apps/widgetbook` only (`enforcedPackages`); `core_ui` may import Material (`materialPackages`). The theme mapping passes since it builds colours from token values, not literals.

## Parity cases (D.W2)

- `test/parity/parity.dart`: `parityCase(storyId, builder, {surfaces})` pumps the widget at the start of a 360 logical pixel frame (the phone width of the screen goldens), 16 pixels around it (`FoxSpace.md`, so a focus ring is not cut; the web side pads the story's root by the same), height from its content, pixel ratio 2, RTL, the phone or captain theme's surface, animations off, CoFo from `loadFoxFonts`. It writes `<repo>/.parity/flutter/<storyId>-<surface>.png`. An id ending in `-hover`, `-focus` or `-pressed` drives the frame's first `GestureDetector` with a mouse, keyboard focus or a held touch, as the web side drives the story's first control.
- CoFo is loaded inside the first case that runs (`tester.runAsync(loadFoxFonts)`), never in a `setUpAll`: a group's `setUpAll` runs even when the tag skips all its tests, and CI has no `.fonts/`, so 33 setUpAlls failed the `flutter` job on PR 305.
- The cases are tagged `parity`, skipped in `dart_test.yaml`; only `pnpm parity` (`scripts/parity.mjs`) passes `--tags parity --run-skipped`. The golden run passes `--tags golden`, so it never runs them.

## Web first: twins and their parity sheets (D.W5, T14)

- The Design System shows the web components only. Every `Fox*` widget is the twin of a web component, built only when a Flutter screen needs it, after its web component, on the same component tokens.
- A twin's drawing is its parity sheet: one `parityCase` per web story it can draw, compared side by side by `pnpm parity`. A token one side does not draw says `sides: ["web"]` (or `["flutter"]`) in its component file; an open overlay is shot alone, as `ui-web`'s `e2e/parity.spec.ts` frames it; a popup opened from a field lands outside the shot on both sides; Flutter keeps its 48 targets where the web's pointer targets are smaller (R13). The screen goldens (R9) stay the Flutter check.

## Left out

Wiring into the apps and bundling CoFo there (each app's screen slice, which also adds the app to `enforcedPackages`); compact density in Flutter; dark mode; Cupertino localizations for the iOS text toolbar (apps provide them); a hosted widgetbook.
