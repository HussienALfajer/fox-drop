# Banner

A full-width bar under the top bar: no connection, emergency stop, test mode, an update.

## Behaviour

- Five tones: red (solid, an alert), yellow `caution`, amber `warning`, blue `info`, grey `neutral` (tinted, a status).
- Every tone has an icon and words, never colour alone; an optional action sits at the end.
- `dismiss` adds a close control at the end, a 48 target with no fill, for a banner the user may put away for now (an update on offer, CU §4.2).
- `secondaryAction` adds a second way out (a call beside WhatsApp, CU §5.5); with two actions, both move to a line under the words, each with its icon.
