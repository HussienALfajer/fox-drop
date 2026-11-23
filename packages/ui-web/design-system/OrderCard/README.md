# OrderCard

The compact card of the restaurant's orders board (RA §8.2).

## Behaviour

- The order number and the time since it was placed, the item count and first items, the captain line, the column's Timer and any badges.
- One main button (`action`): «قبول», «الطلب جاهز» or «تأكيد الاستلام». The owner's portal is read-only and passes none.
- `late` turns the card red and adds `lateLabel` to its name.

## RTL and accessibility

The card is an article named by `label` («طلب #10423»), so a screen reader can jump between orders.
