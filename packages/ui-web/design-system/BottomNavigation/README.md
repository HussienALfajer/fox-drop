# BottomNavigation

The floating bottom bar of the three apps, in the Figma shape: an accent outline that swells round each tab, ringed by a soft halo, an ivory circle per item and the current one a larger orange circle.

## Behaviour

- Icons only, every one Linear: the current item's larger circle alone marks it.
- `count` puts a count on an item's circle, `dot` a dot; `countLabel` says it in words.
- Each item is at least a 48 target.

## RTL and accessibility

A `nav` named by `label`; each item is a button named by its `label` with its badge («طلباتي، 1 جديد»), the current one `aria-current="page"`. Tab reaches every item; the arrows move along the bar by their side (left is the next item in RTL), Home and End go to the ends.
