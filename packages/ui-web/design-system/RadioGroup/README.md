# RadioGroup

One choice from a short list: circles 24 in 48 targets, each row with its label is the target.

## Behaviour

- One tab stop for the group; the arrow keys move the choice (and skip a disabled option).
- `label` is the visible question and the group's name; `options` are `{ value, label, disabled? }`; `onValueChange` receives the value. An `error` turns the unselected outlines red and describes the group.

## States

Unselected, hover and pressed, focus (the keyboard ring), selected (a brand-orange ring and dot), invalid and disabled.

## RTL and accessibility

The circle sits at the start (right) of its label. All text comes from the app's translation files.
