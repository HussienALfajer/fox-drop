# QuantityStepper

The count of a cart line: two orange circles bridged by a concave strip holding the number.

## Behaviour

- «+» is at the start of the line (right in RTL), «−» at its end. `min` defaults to 1; `max` is optional and turns «+» off at the limit.
- At the minimum, with `onRemove` and `removeLabel`, «−» becomes the delete icon and removes the line; without them it is off.
- The number is announced when it changes; `label` names the group with the count («الكمية 2»), written and translated by the app.

## RTL and accessibility

Each circle is a 48 target. The two buttons have their own names (`increaseLabel`, `decreaseLabel`); an off button stays focusable so the keyboard does not lose its place.
