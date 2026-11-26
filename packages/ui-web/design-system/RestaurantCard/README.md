# RestaurantCard

A restaurant in a customer list: the 16:9 cover with the heart and the state chip, the logo and name, the categories, the rating or «جديد», the estimate and the fee.

## Behaviour

- The whole card is one link to the restaurant (`href`); the heart is its own button above it and calls `onFavourite`. A favourite is a Bold red heart.
- No cover, or one that fails to load, shows the logo (or the name's first letter) on the brand tint.
- `closed` fades the card but its state chip and the heart, which keep their full contrast.

## RTL and accessibility

The link is named by the restaurant and its state («برجر كبصو، مغلق — يفتح السبت 10:00 ص»); the heart is a toggle button with `aria-pressed`, after the link in the keyboard order. The heart sits at the cover's start corner, the chip at its end.
