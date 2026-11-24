# Card

The container of every card: raised white on the ground, radius 15.

## Behaviour

- `elevation="offset"` draws the Figma file's offset shadow, for the customer app; `outline` (the default) is a thin border for the restaurant, captain, panel and portal.
- `tone="danger"` tints a late order red with a red outline.
- With `onPress` the whole card is one button and takes the hover and pressed colours of the raised surface.

## RTL and accessibility

A pressable card needs `label`, its accessible name. Never put another button inside a pressable card.
