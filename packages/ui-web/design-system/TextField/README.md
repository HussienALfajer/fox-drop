# TextField

A single line of text: a pill with its label, hint and error.

## Density

- `comfortable` (default) is 50 high, for the phone apps.
- `compact` is 40 high, for the admin panel and the restaurant portal only.

## States

- Rest, hover (a darker outline), focus (a 2 brand-orange outline), filled, invalid (a 2 red outline and the error below, inset, so nothing moves) and disabled.
- `optionalLabel` marks an optional field with «(اختياري)»; there is no required star.

## Props worth knowing

`value` and `onValueChange` control it; `type` (text, email, url, password), `inputMode`, `autoComplete` and `maxLength` go to the input.

## RTL and accessibility

The text follows the reading direction; the error is the input's description. Labels and messages come from the app's translation files.
