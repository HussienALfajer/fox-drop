# RestaurantBar

The restaurant app's bar on every screen: the restaurant's name, its status pill, the connection dot with its words, and the support button.

## Behaviour

- `status` is the pill the app gives (a StatusChip, or a button that opens the status sheet).
- `connected` turns the dot and its words green or red; `connectionLabel` («متصل», «غير متصل») is always shown beside the dot.

## RTL and accessibility

The name is the screen's heading. The connection is a live status, so a drop is announced, and never told by colour alone. The support button is a round icon button named by `supportLabel`.
