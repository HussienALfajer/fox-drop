# packages/core_realtime

Real time in the three Flutter apps (architecture §6, §11.2; RA §4.3, CU §4.3). The server side is the notifications module (`apps/server/src/modules/notifications/CLAUDE.md`). A plain Dart package, tested with `dart test`.

## Layout

- `transport.dart`: `RealtimeTransport`, a stream of `RealtimeSignal`s per channel (`RealtimeUp` with `recovered`, `RealtimeDown`, `RealtimePublication`).
- `centrifuge_transport.dart`: `CentrifugeTransport`, one Centrifugo connection per app on `centrifuge` (Dart), opened with the first channel listened to and closed with the last.
- `live_feed.dart`: `LiveFeed`, a full state kept current over one channel.

## Rules

- **The state shown is always one the server answered.** A publication never patches the state: a newer one makes the feed fetch the app's read again (`GET /v1/merchant/orders`, `GET /v1/customer/orders/{orderId}`). The feed fetches at start, after every subscription that did not recover (`recovered: false`, the first one included), after each new publication, and every `pollEvery` while the channel is down or the latest fetch failed (30 s, CU §4.3). A command's answer makes the app call `refresh`.
- **Version ordering** (RA §4.3): publications carry `orderId` and `version`; the feed keeps the highest version seen per order, from fetches and events, and drops a publication not newer than it, even for an order that left the state. `events` gives the new publications (their `type` and `reason`) for the app's sounds and messages, never for the state.
- **Tokens:** the app passes its token route (`POST /v1/{party}/realtime/token`) as `token`; Centrifugo asks again when one expires. The session ending throws `RealtimeSignedOut`, which stops the reconnects. Channels need no token of their own: the API's subscription proxy checks each one.
- **The address** is the API's origin with `ws`/`wss` and `/connection/websocket` (nginx forwards it to Centrifugo on staging); a debug build on the default development address uses Centrifugo's local port 8000 (`compose.yaml`). Each app computes it in its `api.dart`.
- Tests use a fake `RealtimeTransport`; the Centrifugo side is proved by the server's `order-realtime.test.ts`.

## Not yet

- Presence and the restaurant devices' 20-second heartbeat (RA §4.3, §4.6), with the receiving-device rule.
- The Android foreground service that keeps the connection open in the background (`core_alerts`, architecture §12.2); today the connection lives while the app runs.
