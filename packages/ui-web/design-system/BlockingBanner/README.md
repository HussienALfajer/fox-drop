# BlockingBanner

The panel's blocking sound banner (AP §7.3): it covers the page after sign-in until alert sound is enabled.

## Behaviour

- Escape and outside presses cannot dismiss it; focus starts on its button.
- `onEnable` runs inside the press, so the browser lets audio start; the app closes it once sound plays.
