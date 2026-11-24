# Drawer

A full-height panel over the page: the quick view from a table at the end side, the sidebar on a phone at the start side.

## Behaviour

- `side: 'end'` (left in RTL) for a quick view, away from the sidebar; `'start'` for the sidebar's phone form.
- Escape, the × and the scrim close it; focus is trapped inside and returns to the trigger.

## Motion

Slides from its edge in `duration.slow`; only fades under reduced motion.
