# Button

The button of every FOX DROP screen: one action, in four looks, two densities and the states a press can be in.

## Variants

- `primary`: the one main action of a screen or a dialog (confirm the order). One per view.
- `secondary`: a lesser action beside it (add an address), outlined.
- `danger`: an action that destroys or cancels (cancel the order); always behind a clear label.
- `ghost`: a quiet action with no fill (skip, dismiss), for the third place in a row.

## Density

- `comfortable` (default) is 50 high, for the phone apps.
- `compact` is 40 high, for the admin panel and the restaurant portal only; never on a phone.

## Icons

- `icon` goes at the start of the label (right in RTL), `iconEnd` at its end (left in RTL). Icons come from `Icon` and follow the label's colour.
- An icon alone makes a circle and must have `label`: it is the accessible name, since nothing else tells a screen reader what the button does.

## States

- `disabled`: greyed out, not focusable, ignores presses; say why nearby.
- `loading`: a spinner over the hidden label; the width does not change, presses are ignored and the button stays focusable (`aria-busy`). Use it for a request in flight, not for navigation.
- Hover, focus (ring) and pressed are drawn for you.

## RTL and accessibility

Layout is logical (start and end), so the button mirrors by itself; an arrow icon that points somewhere (`back`) flips under `dir="rtl"`. The label is plain text from the app's translation files; the component has no text of its own. Contrast of every look and state is checked at design time; keep labels short enough to stay on one line at 130% text size.
