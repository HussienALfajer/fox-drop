# Dialog

A question that blocks the page until it is answered: a title, a description and two actions over the scrim.

## Behaviour

- An alert dialog: Escape, Android's back and the × close it; focus is trapped inside and returns to the trigger.
- Focus starts on the safe action (`cancelLabel`), never on the destructive one; `tone: 'danger'` draws the action in red.
- `onConfirm` runs before it closes; a Promise keeps it open, pending, until it settles.

## Motion

Fades and grows from 96% in `duration.base`; only fades under reduced motion.
