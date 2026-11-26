# DishCard

A dish in a restaurant's menu: the name, description and price at the start, a square photo, and «+» in the thumb's reach.

## Behaviour

- The whole card is one link to the dish's item sheet (`href`); «+» is its own button and calls `onAdd`. Once the dish is in the cart, «+» shows the count.
- Without a photo, or when it fails to load, the card is a text row with no image slot.
- `unavailableLabel` («يتوفر غداً») fades the card but the reason, and removes the link and «+».

## RTL and accessibility

The link is named by the dish; «+» by `addLabel`, with the count after it in Western digits («أضف وجبة كريسبي، 2»). An unavailable card is an article named by the dish and its reason.
