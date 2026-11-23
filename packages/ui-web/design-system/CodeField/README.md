# CodeField

The sign-in code: six 48 circles, always left to right, over one real input.

## Behaviour

- One input under the cells, so paste works (`482-913` becomes 482913), the phone offers the code from a message (`autocomplete="one-time-code"`) and the keyboard is numeric.
- The current cell has a 2 brand-orange outline and a blinking caret (it does not blink under reduced motion).
- `onComplete` runs once with the whole code. `done` fills the circles with the brand orange and fuses them over a moment, even under reduced motion; `error` turns every outline red.

## RTL and accessibility

The cells stay left to right (digits read left to right). Screen readers meet one input named by the label; the label, the hint and the error come from the app's translation files.
