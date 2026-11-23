# Timer

A running time: the auto-cancel and prep countdowns, a late order, a captain waiting.

## Behaviour

- «4:32» under ten minutes, «12 د» from ten on, with the app's `minuteUnit`. The app ticks `seconds`.
- Calm by default; `soon` (amber) in the last minute of a countdown; `late` (red) when the app says so, counting up. `tone` overrides it, and `prefix` adds words before the time («متأخر»).

## RTL and accessibility

Tabular digits keep the time from jittering. It has the `timer` role, which screen readers do not announce on every tick.
