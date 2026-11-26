# OrderRow

One order in the customer's «طلباتي» (CU §12.3): the restaurant, the date, the status and the total.

## Behaviour

- The restaurant's Logo, its name and the date, the total at the end; the status chip below, with «اطلب مرة أخرى» (`trailing`) on a past order.
- On the customer's offset card. `onPress` opens the order: the whole card is its target, and the reorder action stays its own button.

## RTL and accessibility

The row is an article named by the restaurant and the date («برجر كبصو، اليوم · 9:45 م»); with `onPress` the restaurant's name is the button that opens it. At large text the total and the action wrap under the names.
