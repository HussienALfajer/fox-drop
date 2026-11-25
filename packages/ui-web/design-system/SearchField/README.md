# SearchField

A search pill with the brand-orange lens at its start and a clear button at its end while there is text.

## States

- `loading` swaps the clear button for the drop loader (`DropLoader`, size `sm`) and sets `aria-busy`; typing keeps working.
- Rest, hover, focus (a 2 brand-orange outline), filled and disabled; `density` `compact` is 40 high (panel and portal only).

## Props worth knowing

`label` is the accessible name (there is no visible label) and `clearLabel` names the clear button: both come from the app's translation files. `value` and `onValueChange` control it.

## RTL and accessibility

The lens sits at the start (right) and the clear button at the end (left); it is a text box with the search role and its own name.
