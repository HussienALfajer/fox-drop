# CountBadge

A count or a dot on the corner of an icon, or inline in a tab.

## Behaviour

- A count above `max` (99) shows «99+»; without `count` the badge is a dot; zero shows nothing.
- Red by default, `primary` orange for the cart, `accent` blue in a tab.

## RTL and accessibility

The digits run left to right so «99+» keeps its plus at the end. The visible count is hidden from screen readers; `label` gives the full count in words («3 إشعارات»).
