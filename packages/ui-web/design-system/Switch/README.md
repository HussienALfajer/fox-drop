# Switch

A setting that takes effect at once: a classic 52 by 32 track with a round thumb.

## Behaviour

- Off rests at the start (right in RTL); on slides the thumb to the end (left in RTL) and the track turns brand orange. The label stays the same in both states and the whole row is the target.
- Space toggles it from the keyboard; `onCheckedChange` receives a boolean.

## States

Off, on, hover and pressed (the track darkens), focus (the keyboard ring) and disabled.

## RTL and accessibility

The thumb moves by logical layout, not by a physical offset, so it mirrors by itself. It has the switch role with a hidden input; the label comes from the app's translation files.
