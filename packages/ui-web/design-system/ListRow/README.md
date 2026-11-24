# ListRow

One row of a list: a lead icon, a title, a second line and an end slot.

## Behaviour

- `end` holds a value (Money), a chip or a switch.
- With `onPress` the row is one button with a chevron at the end; `tone="danger"` writes a destructive row in red without the chevron.
- 48 high on phones, 40 in `compact` density for the panel and portal.

## RTL and accessibility

The chevron points along the reading direction, to the left in Arabic. The title names the button and the second line describes it.
