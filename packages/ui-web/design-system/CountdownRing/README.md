# CountdownRing

The captain's offer countdown: a ring that empties over the offer's 45 seconds, the seconds left inside.

## Behaviour

- The app ticks `seconds`; the arc is the share of `total` left, from the top along the reading direction.
- Orange, then red in the last ten seconds (brand expression §3).

## RTL and accessibility

It has the `timer` role, named by the seconds and `label` («38 ثانية متبقية»), and is not announced on every tick. The digits are Western and tabular. Under reduced motion the arc jumps from tick to tick; the number carries the time.
