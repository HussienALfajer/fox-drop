# Changelog

Every token change bumps `version` in `package.json` and gets an entry here (architecture §9.2). A token is marked `$deprecated` for one release before it is removed.

## 0.14.0 (2026-11-26, slice D.W1: the component token pipeline)

- Dart: every file of `tokens/component/` now comes out with no change to the generator, and a new `ComponentTokens` per theme (`FoxComponents.light.button`, …) bundles them; `core_ui` exposes it as `FoxThemeData.components`. `FoxButton` and `FoxInput` keep their names.
- A component file declares the ui-web and core_ui folders that read it in `$extensions["app.foxdrop"]` (`{ "web": [...], "flutter": [...] }`); `src/component-usage.test.ts` fails when a token is not read on a declared side. A token one side does not need says `"sides": ["web"]`. `button.json` declares `button` on both sides; `button.compact.height` is web only (the Flutter button has no compact density).
- New tokens, each with the value of the literal it replaces (no look change): `border-width.heavy` (4px, the current item's bar in the panel's sidebar, which wrote `border-s-4`), `border-width.indicator` (3px, the Flutter tabs' underline), `size.menu-min-width` (192px), `size.menu-max-width` (336px), `size.menu-max-height` (288px) for the Flutter menus, and `motion.enter.sheet` (1) and `motion.enter.toast` (0.15), the share of its height a Flutter sheet and toast slide in from. Dart gets the widths as `FoxBorderWidth` (`thin`, `thick`, `indicator`, `heavy`); the motion group's description now covers the entrances.

## 0.13.0 (2026-11-25, blue headings)

- `heading` moves from the brand orange `#FF6E31` to the brand blue `#03428E` (`primitive.color.blue.500`) in every theme, as the identity package V1.1 sets titles (owner, 2026-11-25). It leaves the orange exception (`ORANGE` in `src/contrast.ts`) and is checked as text: 4.5:1 on the phone and panel (8.72 on `surface`), 7:1 for the captain.

## 0.12.0 (2026-11-25, slice D.11b checkpoint C: sign-in and frame components)

- New contrast pairs, no token change: `primary-hover` and `primary-pressed` as text on `surface` and `surface-raised` under the orange exception (floor 3.6: the text link's hover and pressed ink, the tracking steps' current label), and `primary-pressed` on `info-subtle` at 4.5 on the phone and panel (the code preview's masked code, 4.68). The sign-in hero's orange badges and dish circles are decoration, read as words, so they have no pair.

## 0.11.0 (2026-11-25, slice D.11b: sign-in and frame components)

- New group `motion.*`: `motion.pulse.*` (the live dot's ring: scale 1 → 1.7, opacity 0.7 → 0 over `duration.moment`; still at 1.25 and 0.35 under reduced motion) and `motion.mark-fill.*` (the loader: the liquid rises over the first 0.7 of `duration.moment`, its surface sways every 700 ms, the full mark fades back over the last 0.18, the empty mark at 0.35; still half full under reduced motion), as `number` and `duration` tokens. CSS variables `--fd-motion-*` and Dart `FoxMotion`.

## 0.10.0 (2026-11-24, slice D.11: customer frame and sign-in)

- New semantic `nav-halo` (new primitive neutral 250, `#E3DFD8`): the soft halo round the floating bottom bar's outline, taken from the owner's Figma file (home) when the bar was redrawn in its shape (owner, 2026-11-24). Decoration only, so it has no contrast pair.

## 0.9.0 (2026-11-24, slice D.5b: icon set v4 Madar)

- The 47 icons redrawn as set v4 "Madar" (architecture §9.4, owner 2026-11-24): stroke 1.5, each element a `<path>` with its role as data attributes. The outputs carry six styles: the elements (Linear, Duotone, Brand Duo), `broken`, and `bold` and `boldDuo` fills baked with CanvasKit at 1.5 and 1.75 (`src/icon-bake.ts`). Dart `FoxIconData` gains `elements`, `broken`, `bold(weight)`, `boldDuo(weight)` and the enum `FoxIconWeight`; `paths` goes.
- New group `icon-stroke.*` (number): `phone` 1.5 and `captain` 1.75.
- New contrast pairs under the orange exception: `brand` on `surface`, `surface-raised` and `primary-subtle`, the Brand Duo accent.

## 0.8.0 (2026-11-24, slice D.10: overlays and navigation)

- From the approved sheet «Overlays and navigation — batch 4»: `caution` (yellow 800) and `caution-subtle` (yellow 50), the yellow banner tone RA §6.3 and CA §6.3 name beside amber, with their pair at 4.5:1 (7:1 for the captain); `scrim` (neutral 900 at 48%) behind dialogs, sheets and drawers. New primitives yellow 50 and 800 and `shadow.scrim`.
- New group `layer.*` (number): the stacking order sticky 10, banner 20, overlay 30, menu 40, toast 50, tooltip 60, blocking 70, as CSS variables for the web.
- New sizes for the overlays and bars: `size.dialog` 460, `size.drawer` 440, `size.toast` 360, `size.tooltip` 240, `size.sidebar` 248, `size.sidebar-collapsed` 72, `size.bar` 64.
- New icon `menu` (three lines), for the sidebar's phone form.

## 0.7.0 (2026-11-24, slice D.9: data display)

- From the approved sheet «Data display — batch 3»: the status tints `success-subtle`, `warning-subtle`, `danger-subtle`, `info-subtle`, `primary-subtle` and `neutral-subtle`, with `neutral` (inactive status text, neutral 700) and `on-primary-subtle` (orange 600; blue 500 in the captain app, which has no orange text). New primitives green, amber and red 50, orange 75 and neutral 150.
- New contrast pairs: each tone's text on its tint, and `on-surface` on the info and primary tints (a running timer, a selected table row); 4.5:1, 7:1 for the captain.
- `font.family.sans` gains the fallback «Fox Lira» after CoFo: the ₺ (U+20BA) cut from Noto Sans by `scripts/lira-font.py` into `ui-web/fonts/fox-lira` and `core_ui/assets/fonts/fox-lira`, under the SIL OFL (owner, 2026-11-24).

## 0.6.0 (2026-11-24, slice D.8: inputs and forms)

- New component tokens `input.*` (`tokens/component/input.json`): field height 50 (compact 40), padding, the pill radius and `area-radius` (long text), outline widths 1 and 2, every field colour per state, and the checkbox and radio, switch, quantity stepper and sign-in code tokens, from the approved forms sheet. Dart `FoxInput` beside `FoxButton`.
- New semantic tokens: `size.selection` 24, `size.step` 32, `size.switch-width` 52, `size.switch-height` 32, `border-width.thin` 1 and `border-width.thick` 2.
- The owner's orange exception now covers `primary` as a 3:1 control boundary (a focused outline, a checked box, the switch, the stepper) on `surface` and `surface-raised`, floor 2.5. New pair: `border-hover` at 3:1.
- New icons `chevron-down` and `calendar`.
- New semantic `border-pressed` (blue 700) and the triple `border-strong`/`border-hover`/`border-pressed` under the R10 ΔE test; `input.switch.color.track-pressed` and `input.stepper.color.background-hover`, so the off switch and the stepper have their own pressed and hover steps (review of D.8).

## 0.5.0 (2026-11-24, slice D.6: interaction states, R10)

- The owner picked «Brand tonal steps» on the Interaction states sheet: one state model for every interactive component, measured. The 0.4.0 hover (a 50% mix of fill and pressed) was ΔE2000 3.3 on primary and 1.3 on ghost, which the eye barely notices.
- New semantic colours: `primary-hover` (orange 550, new), `danger-hover` (red 700, new), `danger-pressed` (red 900, new), `surface-hover` (blue 50), `surface-raised-hover` (blue 100), `surface-raised-pressed` (blue 200), `border-hover` (blue 500). The captain overrides `danger-hover` (red 900), `danger-pressed` (red 950, new) and `surface-raised-pressed` (blue 100, for 7:1 text).
- Changed: `primary-pressed` orange 500 → 600; `surface-pressed` neutral 100 → blue 100, now a pressed state only (a selected item is designed with accent).
- Button: `background-hover` for every variant, `secondary.border-hover`; `secondary` presses to `surface-raised-*`; `danger.background-pressed` is `danger-pressed`, no longer `alert`.
- New test (R10): with a pointer (light, dark) hover is ΔE ≥ 8 from rest and pressed ≥ 5 beyond hover; on touch (captain) pressed is ≥ 8 from rest. Contrast: `on-surface` and the focus ring on every state ground, `on-danger` on its hover and pressed fills, `on-primary` on `primary-hover` under the orange exception.

## 0.4.0 (2026-11-23, slice D.6: the approved Button set)

- New: `size.control-compact` 40 px; Button tokens `button.compact.height`, `button.danger.{background,background-pressed,label}` (danger, alert, on-danger) and `button.ghost.{background-pressed,label}` (surface-pressed, on-surface). The ghost ground is transparent, so it has no token.
- New contrast pairs: `on-danger` on `alert` at 7:1 (every surface; `alert` is the 7:1 red) and, for the captain, whose danger is red 800, `on-danger` on `danger` at 7:1. In the captain theme danger and alert are the same red, so its pressed danger Button shows no darker step. The ghost label on its pressed ground is covered by `on-surface` on `surface-pressed`.

## 0.3.0 (2026-11-23, slice D.5: the icon set)

- New: `size.icon-sm` 16, `size.icon-md` 24 and `size.icon-lg` 32 px, the three icon sizes; icons are drawn on the 24 grid and their stroke scales to 2/24 of the size (architecture §9.4). Dart `FoxSize` now carries every `size.*` token.

## Unreleased (slice D.4: the Design System artifact)

- New output `generated/design-system.json`: the tokens in the Design System artifact's `tokens.json` shape (architecture §9.8). Every semantic colour, space step and elevation now carries a `$description`, its usage note there. No value changed, so no version bump.

## 0.2.0 (2026-11-23, slice D.3: the Figma file adopted)

- The owner adopted the Figma file "Fox Drop" as the design direction. Changed: `surface` is the Figma ground `#FBF2E7` (new neutral 75), `surface-raised` `#FEFEFE` (new neutral 25); `on-surface` is the brand blue and `on-surface-muted` the blue at 75% over the ground (`#416EA4`); `border` and `border-strong` are the blue at 16% and 60%; `primary` is the brand orange `#FF6E31`, `primary-pressed` orange 500, `on-primary` ivory; danger red 600 is the Figma error red `#BF2929`.
- New: `color.heading` (orange headings), `elevation.offset` (the flat 7 px shadow in orange 450 `#FD6425`), `radius.xl`, `size.control` (50 px). The radii are the Figma file's: sm 8, md 10, lg 15, xl 30, full. Button: height `size.control`, radius `radius.full`.
- Deprecated: `radius.xs` (use `radius.sm`); removed next release.
- The owner's contrast exception for the brand orange in every app: the contrast report lists its 30 pairs (orange headings, ivory labels on orange) as «owner exception»; each keeps a floor at today's ratio, and a test pins the orange values in every theme and keeps the exception to the orange tokens. Orange 600 `#C2410C` is no longer used by a semantic token.

## 0.1.0 (2026-11-22, slice D.2)

- First tokens: the orange, blue and warm-neutral scales, status, chart and shadow colours; the 4-point spacing grid, radii, three elevations, durations fast 100, base 200, slow 300 and moment 1200 ms with one calm easing; CoFo Sans Pro Arabic at 400, 500 and 700; the phone, panel and captain type scales; web breakpoints and the 48 touch target.
- Semantic colours with their dark slot (a copy of light) and the captain override; the Button component tokens.
- Settled by the contrast test and approved by the owner on 2026-11-22: the accessible orange `#C2410C` (orange 600) and the status colours danger `#B91C3C`, warning `#8A5A00`, success `#067647`, info `#03428E`; chart colours blue `#03428E`, orange `#EA580C`, teal `#0F766E`, violet `#7C3AED`, olive `#4D5A12`, pink `#BE185D`.
