# Field

The wrapper of every form control: a label above, a hint or an error below, and the wiring that makes a screen reader read them with the control.

## Parts

- `label` (required) names the control. `optionalLabel` adds the optional mark beside it, «(اختياري)»; there is no required star.
- `hint` is help below the control. `error` replaces it, in red with the `error` icon, and becomes the control's description (`aria-describedby`, `aria-invalid`).
- `aside` is something at the end of the line below, like a character counter. `density` is `comfortable` (50) or `compact` (40, panel and portal only).

## Use

`TextField`, `TextArea`, `PhoneField`, `CodeField`, `Select` and `RadioGroup` already contain a Field; use it alone only around a control that has none.

## RTL and accessibility

The label and the message follow the reading direction; the component has no text of its own, so labels, hints and errors come from the app's translation files.
