# notifications module

Real-time publishing through Centrifugo, push through FCM, the customer's stored notifications and the panel's alerts (architecture §4.2, §6.1–6.2, §8.1; RA §4.3, §16, §18; CU §13–14; AP §7.3, §9.1.3).

## Rules

- **Centrifugo holds the WebSockets; the API stays stateless.** Channels are `infra/centrifugo/config.yaml`. A new namespace goes into that file, `NAMESPACE_PARTY` in `realtime-access.ts` and `channels.ts`.
- **Real time is configured per process** (`realtime-config.ts`, read at each call). Without it the token routes answer `503 realtime_unavailable`, the proxy refuses and the worker leaves the outbox as it is; production refuses to start. No secret ships in an app (E7).
- **The subscription proxy:** every subscription is checked by a `@RealtimeProxy()` route (secret compared in constant time, `@ApiExcludeEndpoint()`, so no client is generated; `src/http/openapi.test.ts` fails on any other route left out of the OpenAPI document). A channel must be the session's own, checked through `AppSessionsService.openSession` or `AdminSessionsService.openSession`. `ordering` registers `order:` channels with `RealtimeAccess.allow`, since this module cannot read orders.
- **Ended sessions:** a module that ends sessions calls `notifyEnded` after its commit so their connections close; a role change calls `notifyAccessChanged`.
- **Publishing state changes goes through an outbox** written in the change's transaction (E4): `alert_outbox`, `platform_outbox`, the orders' outbox, `merchants.state_outbox`. The worker's relays publish with an idempotency key, `FOR UPDATE SKIP LOCKED`. The application role inserts and may change only `published_at`. A publication carries a type and ids; the client reads the full state again. Only positions (a captain's, the live map) skip the outbox.
- **Alerts:** add a rule to `alert-rules.ts` (code, severity, recipient roles, subject, whether it resolves itself). The module that owns a condition calls `AlertsService.sync(executor, subject, evaluated, open, now)` in its own transaction, never the pool. `AlertsSweep` reads only what no transaction of ours changes. One open alert per rule and subject (partial unique index).
- **Push:** queue with `PushQueue.enqueue(tx, pushes, now)` in the transaction of what it tells. `source` is unique, so queuing again adds nothing. A push expires (`PUSH_TTL_SECONDS` or its own end) and is never sent stale. Pushes go to a recipient's live tokens whose sessions are still open (`PushDevices.targets`). Tokens register with `PUT /v1/{customer,merchant,captain}/push-token`.
- **Push relay:** the worker claims rows in a short transaction, sends outside any transaction (`fcm-sender.ts`), and writes each outcome in its own. `FCM_SERVICE_ACCOUNT` is read by the worker only; without it push is off and production refuses to start.
- **Money and times in pushes** are formatted by content's `formatMoney`, `formatTime` and `formatDate`, on the city's clock (`GeoService.cityTimeZone`).
- **Proof:** `src/modules/ordering/order-realtime.test.ts` runs a real Centrifugo; the Centrifugo test helper is `src/centrifugo/test-centrifugo.ts`.

## More

Behaviour, decisions and history: `docs/code/apps/server/src/modules/notifications.md`. Grep it for what you change; never read it whole.
