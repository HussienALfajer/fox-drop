# StatusChip

An order state, or another state, as an icon and a word on its tint.

## Behaviour

- `status` takes one of the nine order states of AP §8.1 and gives it its tone and icon: waiting amber, preparing blue, ready and delivered green, with the captain orange, refused and failed red, cancelled grey.
- `tone` with an optional `icon` draws any other state, such as a restaurant's «مشغول».
- `label` is the app's own wording: the panel says «مع الكابتن», the customer «في الطريق إليك».

## RTL and accessibility

Never colour alone: every chip has its word and an icon. Text on its tint passes 4.5:1, and 7:1 in the captain app, where the orange state reads in blue.
