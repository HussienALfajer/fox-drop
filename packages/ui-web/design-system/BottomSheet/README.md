# BottomSheet

A sheet from the bottom edge over the scrim: a handle, its title and its content, at most 90% of the screen.

## Behaviour

- Opens from its `trigger`, or controlled with `open` and `onOpenChange`. Escape and the scrim close it unless `dismissible` is false; the plain top has a ×.
- `sCurve` draws the brand's S-curve tab holding the title (the customer's item sheet), with no ×.
- It slides up over the slow duration; under reduced motion it only fades. On a wide page it is centred at the dialog width. `inline` keeps it in its frame, as on this card.

## RTL and accessibility

A dialog named by its title. Focus moves inside, stays there while it is open and returns to the trigger. The S-curve tab sits at the start side and mirrors with the direction.
