# Changelog

Every token change bumps `version` in `package.json` and gets an entry here (architecture §9.2). A token is marked `$deprecated` for one release before it is removed.

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
