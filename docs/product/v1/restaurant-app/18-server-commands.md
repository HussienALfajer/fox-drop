# 18. Server commands

> Part of the [restaurant app spec](README.md) (RA). A bare "§n" here means RA §n.

Every command:

- carries an idempotency key (§4.7)
- is checked on the server for the user's role, the restaurant's status and the order's state
- returns the new state
- records the user, the device and the time

| Command | Roles | Allowed when | Effect |
|---|---|---|---|
| Accept with prep time | MO, MC (app) | Order `placed` | `accepted`; customer notified; search start computed (§8.5) |
| Reject with reason | MO, MC (app) | Order `placed` | `rejected`; items unavailable or restaurant paused, per reason (§8.6) |
| Mark ready | MO, MC (app) | Order `accepted` | `ready` (§8.8) |
| Report item unavailable | MO, MC (app) | `accepted` or `ready`, before pickup, no open report, no open pickup request | Items unavailable; alert to operations; pickup blocked (§8.12) |
| Withdraw item-unavailable report | MO, MC (app) | Report open, operations have not acted | Report closed; items available again |
| Acknowledge edit | MO, MC (app) | An unacknowledged edit | Ring stops; acknowledgement recorded (§8.13) |
| Acknowledge cancellation | MO, MC (app) | An unacknowledged cancellation | Ring stops (§8.14) |
| Confirm pickup | MO, MC (app) | An open pickup request | Atomic pickup (§8.10, AP §8.1) |
| Dispute pickup | MO, MC (app) | An open pickup request, or within 10 min after any pickup confirmation | Rejects the request and alerts operations; or, after pickup, opens an urgent ticket (§8.10) |
| Reject pickup as incomplete | MO, MC (app) | An open pickup request | Rejects the request without amounts or an alert (§8.10) |
| Call captain | MO, MC (app) | From assignment until the order ends | Reveals the number; recorded (§8.9) |
| Pause / resume | MO, MC (app); MO (portal) | Pause: open or busy, and no operations or auto pause. Resume: paused by the restaurant. | State change (§7) |
| Busy mode on / off | MO, MC (app); MO (portal) | Restaurant open | Flag change (§7.3) |
| Holiday close / end | MO (app, portal) | Not suspended | State change (§10) |
| Set hours, default prep time, limit | MO (app, portal) | Any time | Applies immediately (§10) |
| Set pickup currencies | MO (app, portal) | Any time | Applies to new pickup requests (§12.7) |
| Set availability | MO, MC (app); MO (portal) | Any time | Immediate (§9.3) |
| Set price / bulk price change | MO (app, portal) | Any time | Immediate; logged; may alert operations (§9.4) |
| Hide, show, reorder, category window | MO (app, portal) | Any time | Immediate (§9.2) |
| Request a menu change / withdraw it | MO (app, portal) | Any time / while pending | Creates or withdraws a request (§9.5) |
| Add or remove a cashier | MO (app, portal) | Any time | Account change; removal signs out devices (§14.1) |
| Rename or sign out a device | MO (app, portal) | Any time | Device change (§14.2) |
| Set ringing on this device | MO (app) | Own device | Device setting (§4.4) |
| Create a ticket | MO, MC (app); MO (portal) | Any time | Ticket in the panel (§15) |
| Report the device check | MO, MC (app) | After a check | Stored on the device record (§4.5) |

**Real-time events the app subscribes to** (restaurant channel): order created, order updated (status, captain track, edits, timers), pickup request opened or closed, restaurant state changed, menu changed (including admin changes and review decisions), account entry posted, statement or receipt issued, and platform broadcasts (emergency stop, maintenance, version).
