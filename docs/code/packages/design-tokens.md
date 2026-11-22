# packages/design-tokens and packages/core_tokens

What the tokens pipeline does and why (slice D.2; architecture §9.2, §9.5 R1 and R4; brand expression §3, §6, §7). The rules for editing are in each package's `CLAUDE.md`.

## Pipeline

- Sources: W3C DTCG JSON (`$value`, `$type`). `tokens/primitive/color.json` and `foundation.json` (all under the `primitive` key), `tokens/semantic/base.json` (theme-free: space, radius, elevation, duration, easing, font, the type roles per surface, breakpoints, touch target), `semantic/light.json`, `dark.json` and `captain.json` (colours), `tokens/component/button.json`.
- `src/resolve.ts` runs Style Dictionary 5 once per theme: `light`, `dark`, `captainLight` (light plus the captain override) and `captainDark`. The override is a Style Dictionary `source` over an `include`, so it replaces keys without a collision warning. Style Dictionary only resolves references; `src/generate.ts` writes the formats itself, since none of its built-in formats gives the three outputs we need (variables per theme selector, a Tailwind v4 `@theme`, pure-Dart `const` classes).
- Outputs, committed: `generated/tokens.css` (`--fd-*` variables: `:root`, `[data-theme="dark"]`, `[data-surface="captain"]` and the dark captain), `generated/tailwind.css` (`@theme inline` that starts with `--*: initial` and maps semantic names to the variables), `generated/contrast-report.md`, and `packages/core_tokens/lib/src/tokens.g.dart`. The Dart file is written already in `dart format` style, so the generator needs no Dart SDK.
- Drift: `src/tokens.test.ts` renders every output and compares it with the committed file (as `infra/maps/style.json` does), so no step in `verify.mjs` is needed. `scripts/classify-changes.mjs` counts `packages/design-tokens/` as Dart too, so CI checks the Dart output.

## Decisions

- **Accessible orange `#C2410C`** (orange 600): 4.97:1 on ivory, 5.18:1 under white. Pressed is orange 700 `#9A3412`. `color.brand` keeps `#FF6E31` for decorative areas only.
- **Status colours** as the brand expression's candidates; all pass. The captain override darkens the muted text (neutral 700) and the success, warning and danger text (green 800, amber 800, red 800) to reach 7:1; info stays the brand blue.
- **Alert** (restaurant tablet and panel): red 800 `#8C1530`, 8.90:1 on ivory, white on it 9.27:1.
- **Chart colours:** the first candidates (olive `#6B7A1F`, pink `#DB2777`) failed: orange and olive were 0.9 apart (CIEDE2000) under protanopia. A darker olive `#4D5A12` and a deeper pink `#BE185D` give at least 12.0 under every simulation (Machado 2009, severity 1). The orange is orange 500 `#EA580C` (3.42:1), since the brand orange is below 3:1.
- **Borders:** `border` (neutral 200) is for decorative dividers and has no contrast pair (WCAG 1.4.11 covers component boundaries); `border-strong` (neutral 500, 3.91:1) is the control boundary.
- **Disabled** colours have no pair: WCAG exempts inactive controls.
- **Type roles** carry size, line height (text 1.6, headings 1.3, numbers 1.2) and weight: caption, secondary and body 400, subtitle 500, title, large title and number 700.
- **Tailwind breakpoints** carry literal values: a media query cannot read a CSS variable.
- **Tabular digits:** `scripts/font-metrics.mjs` measures CoFo 400/500/700 with fontkit and writes `docs/brand/font-metrics.json`: 650 units for every digit with `tnum` in all three weights, proportional widths of 514 to 703 without it. `scripts/font-metrics.test.mjs` checks the widths and the SHA-256s against the fonts manifest, and remeasures when `.fonts/` is present.

## Left out

Real dark values; wiring the theme into the web apps (D.6) and Flutter (D.7); the Design System sync (D.4); font subsetting and size budgets; map style tokens (D.3); icon tokens (D.5); densities (the panel scale covers the compact one for now).
