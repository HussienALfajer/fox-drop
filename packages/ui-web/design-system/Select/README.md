# Select

A single choice from a list: a pill trigger with a chevron that opens a listbox.

## Behaviour

- Arrow keys open the list and move through it, Enter picks, Escape closes; typing a letter on the trigger jumps to the matching option (type-ahead).
- Each option is 48 high; the chosen one is bold with a check. The list is as wide as the trigger.
- `items` are `{ value, label }` pairs; `placeholder` shows until something is chosen; `onValueChange` receives the value. `density` `compact` is 40 high (panel and portal only).

## RTL and accessibility

The trigger is a combobox named by the label and described by the hint or the error; the list is a listbox opening in the reading direction. Labels come from the app's translation files.
