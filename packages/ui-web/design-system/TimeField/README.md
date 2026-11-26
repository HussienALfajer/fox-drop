# TimeField

A time of day: a pill with a clock icon and three boxes typed in place, the hour, the minute and «ص» or «م».

## Behaviour

- The value is 24-hour `HH:mm` (`15:05`), shown 12-hour with «ص» and «م» in Western digits (`03:05 م`). `onValueChange` receives `HH:mm`, or null while a box is empty.
- Digits fill a box and move on; the arrows step the box in focus; «ص» and «م» take a letter or the arrows.

## RTL and accessibility

The boxes form a group named by the label and described by the hint or the error; each box is named by its unit. The hour and minute read left to right as one run, and «ص»/«م» follows them, to their left. The Flutter twin (`FoxTimeField`) opens the same boxes in a dialog.
