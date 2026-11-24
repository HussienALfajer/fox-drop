# Icon

An icon of set v4 "Madar" on the 24 grid, drawn in the current text colour; use it beside a label or inside a Button.

## Use

- `name` picks the icon from the set (see `IconName`); a new icon goes into the design tokens first, never drawn in an app.
- `size`: `sm` for compact controls, `md` (default) beside text and in buttons, `lg` for empty states and headers. The stroke, 1.5 at 24, scales with the size.
- `variant`, one of the six styles drawn from each icon:
  - `linear`, the default;
  - `bold` for a selected item;
  - `brand-duo` (the meaning element in the brand orange) for empty states, promo cards and settings chips;
  - `bold-duo` for coloured cards and important notices;
  - `duotone` and `broken` for marketing.
- The colour is `currentColor`: set it on the parent with a semantic token.

## Accessibility

- Without `label` the icon is decorative and hidden from screen readers: right when a text label sits beside it.
- With `label` it is an image with that accessible name: needed when the icon stands alone (not inside a Button, which takes its own `label`).

## RTL

Only the icons that point somewhere flip under `dir="rtl"`: `back`, `motorcycle` and `car`. Every other icon keeps its drawing in both directions, so do not mirror them by hand.
