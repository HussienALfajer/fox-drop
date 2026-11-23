# Checkbox

A checkbox with its label: a soft square 24 in a 48 target; the whole row is the target.

## States

- Unchecked, hover and pressed (the box and its outline darken), focus (the keyboard ring), checked (brand orange with a check), mixed (`checked="indeterminate"`, a minus) for a parent whose children are partly checked, invalid (red outline) and disabled.
- A press on a mixed box checks it. `onCheckedChange` receives a boolean.

## RTL and accessibility

The box sits at the start (right) and the label follows it. It has a hidden input, so a form submits it; the label comes from the app's translation files.
