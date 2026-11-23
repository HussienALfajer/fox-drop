# packages/core_ui

## Theme (D.7)

- `FoxThemeData` maps `core_tokens` to Flutter types: `FoxColorScheme` (every colour token as a `Color`), `FoxButtonTheme` (heights, inline padding, gap, radius, focus ring and every variant's colours), `FoxTextTheme` (each `TypeScale` role as a `TextStyle` in `FoxFont.family`, `leadingDistribution: even`, the weight from the token; `number` adds tabular figures), `FoxShadows` (`BoxShadow`s), the durations and `easing` (`FoxEasing.standard` as a `Cubic`).
- `.phone()` is `FoxColors.light` with `FoxType.phone` (customer and merchant); `.captain()` is `captainLight` with `FoxType.captain`. Light only: dark copies light until it is designed (§9.2).
- `FoxTheme` is an `InheritedWidget`; `FoxTheme.of` throws a `FlutterError` naming the fix when no theme is above. No Material `ThemeData`: the apps still use Material until their screen slices, and `core_ui` never reads it.
- Tests (`test/theme_test.dart`): every field equals its token, for both themes.

## Icon (D.7)

- `FoxIcon(FoxIconData icon, {size, label, color})`. The icon is the token value itself (`FoxIcons.back`), not a name enum: `core_tokens` already generates one constant per icon, and a second enum would have to be kept in step. `FoxIconSize` is `sm` 16, `md` 24, `lg` 32.
- A `CustomPainter` draws the icon's SVG paths scaled from the 24 grid, stroke 2 at 24, round caps and joins, in `color`, else the `DefaultTextStyle` colour, else `onSurface`. `lib/src/icon/path_data.dart` parses the path data (M L H V C S Q T A Z, absolute and relative; extra pairs after M are L; S and T reflect the last control point; A goes through `arcToPoint`, a zero radius is a line); parsed paths are cached.
- `mirror` icons (`back`, `car`, `motorcycle`) flip under RTL. Without a label the icon is excluded from semantics; with one it is an image with that label.
- Tests: every icon parses and its sampled outline (path metrics, not `getBounds`, which counts control points) lies inside 2..22; one hand-checked path per command; only the three mirror icons flip.

## Button (D.7)

- The same set as ui-web «Button» (`docs/code/packages/ui-web.md`): `FoxButtonVariant` primary, secondary, danger, ghost; `icon`, `iconEnd`; `FoxButton.icon` is the circle with a required `label`; `loading`; `onPressed: null` is disabled (the Flutter convention, no separate flag). Comfortable only, 50 high: compact 40 is the panel's, a web app.
- Built on `FocusableActionDetector` (Enter, numpad Enter and Space activate), its own `MouseRegion` for hover (the detector's hover highlight is off in touch mode, so a mouse on Windows never showed it) and a `GestureDetector` for pressed and taps. A state-owned `FocusNode` and explicit `Semantics` (`button`, `enabled`, `focusable`, `focused`, `onTap`, `onFocus`) give the focus semantics; the detector's own are off.
- Only the colours animate (`AnimatedContainer` over `FoxDuration.base` and the theme's easing): the fill and the secondary border (`foregroundDecoration`, so the size never moves). The layout (minimum 48, 50 for the circle, inline padding, centring) is outside the animation; animating it made the button grow during the fade.
- The focus ring is a foreground `CustomPaint` (`_RingPainter`): a 2 stroke in `surface` around the button, then 2 in `button.focus-ring`, following its corners, the inside unpainted. It was two `BoxShadow`s first, but Flutter paints a shadow under the whole shape, so a focused ghost filled with `surface` on any other background (the review of D.7). The 2 and 2 are constants in `fox_button.dart`, not tokens: the web takes them from Tailwind's `ring-2 ring-offset-2` defaults; a token pair would serve both if they ever change.
- Semantics: disabled is neither enabled nor focusable (a focus state, even false, would mark the node focusable, so both are null); loading is focusable but not enabled and has no tap action, as the web's `aria-disabled` while busy.
- Loading keeps the content at opacity 0 (width and name kept) under a 270° spinner arc that turns once a second and stands still under `disableAnimations`. A disabled or loading button paints neither hover nor pressed; ghost's rest is its hover colour at alpha 0, so the fade has no grey step.
- `buttonStates` and `buttonVariants` feed the widgetbook coverage test (R3).
- Tests: semantics and sizes, keyboard and taps, disabled not focusable, loading keeps width, name and focus and ignores presses, the start icon on the right in RTL, no overflow at text scale 1.3 and 2.0, and each variant's rest, hover, pressed and focus-ring tokens.

## Goldens (D.7, R9)

- `test/golden/` holds one image per theme and variant with every state at once (a mouse hovering, a held touch, keyboard focus), the icon-only circles, 130% text and the icon sheet at three sizes and mirrored; `sheet.dart` pumps them RTL at device pixel ratio 2 with animations off.
- They run on Linux only, since font rasterising differs by platform: `scripts/golden-docker.mjs` builds `fox-drop-golden:<.fvmrc version>` (a digest-pinned Ubuntu with Flutter cloned at the `.fvmrc` tag, because no ready image of Flutter 3.47 exists), copies the files the host's git lists (so a worktree works) and `.fonts/` into the container, runs `flutter test --tags golden --run-skipped` with any extra arguments, and copies the goldens (to a new folder, then swapped in) and `failures/` back, owned by the host user. The `golden` CI job runs it on Dart changes and on changes to the fonts manifest or the font-fetch scripts, after fetching the fonts (`FONTS_DEPLOY_KEY`), and uploads the failures; `verify` requires it.
- `loadFoxFonts` (`lib/testing.dart`) walks up to `.fonts/cofo-sans-pro-arabic` and loads 400, 500 and 700; it throws when they are missing instead of skipping, so a golden never passes on a fallback font.

## Lints (D.7, R2, R5)

`packages/fox_lints` (its own `CLAUDE.md`) is an analyzer plugin declared in the root `analysis_options.yaml`. It checks `core_ui` and `apps/widgetbook` only (`enforcedPackages`); `core_ui` may import Material (`materialPackages`). The theme mapping passes since it builds colours from token values, not literals.

## Left out

Wiring into the apps and bundling CoFo there (each app's screen slice, which also adds the app to `enforcedPackages`); compact density in Flutter; dark mode; money and the ₺ fallback (D.8); a hosted widgetbook.
