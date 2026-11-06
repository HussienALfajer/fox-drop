# notifications module

Push, in-app messages, real-time publishing and sound levels (architecture §4.2). So far real-time publishing through Centrifugo, its connection tokens and its subscription proxy (architecture §6.1–6.2; RA §4.3; CU §4.3).

## Rules

- **Centrifugo** holds the WebSocket connections; the API stays stateless (§6.1). Its channels are `infra/centrifugo/config.yaml`, mounted by the local `compose.yaml`, each environment's `infra/compose.yaml` and the tests (`src/centrifugo/test-centrifugo.ts`); its secrets and subscription proxies come from the environment. A new namespace goes into that file, `NAMESPACE_PARTY` in `realtime-access.ts` and `channels.ts`.
- **Configuration** (`realtime-config.ts`): `CENTRIFUGO_API_URL`, `CENTRIFUGO_API_KEY`, `CENTRIFUGO_TOKEN_SECRET` and `CENTRIFUGO_PROXY_SECRET`, read at each call. Real time is off while any is missing: the token routes answer `503 realtime_unavailable`, the proxy refuses every call and the relay leaves the outbox as it is. No secret ships in an app (E7).
- **Connection tokens** (`realtime-tokens.ts`): `POST /v1/merchant/realtime/token` and `POST /v1/customer/realtime/token` (`@AppSignedIn()`) answer an HS256 JWT for 15 minutes (`CONNECTION_TOKEN_MINUTES`, as long as an access token): subject the account, `meta` the party and the session, which Centrifugo passes only to the proxy (`include_connection_meta`). The app asks again when Centrifugo says it expired.
- **The subscription proxy** (`realtime-access.ts`): Centrifugo asks the API about every subscription, by namespace: `merchant` calls `POST /v1/merchant/realtime/subscribe`, `order` calls `POST /v1/customer/realtime/subscribe` (the proxies `merchant` and `customer`). The routes are `@RealtimeProxy()`: the guard compares `X-Centrifugo-Proxy-Secret` with `CENTRIFUGO_PROXY_SECRET` in constant time, so only Centrifugo calls them; they stay out of the OpenAPI document (`@ApiExcludeEndpoint()`), so no client is generated and the route table of `admin-team.test.ts` does not list them. The connection's session is checked as a request's is (`AppSessionsService.openSession`): an ended one is disconnected (`4501`, the client does not reconnect with it). The channel must be the session's own: `merchant:{restaurant_id}` the restaurant user's restaurant, `order:{order_id}` the customer's order (checked by `ordering`, which registers it with `RealtimeAccess.allow`, since this module cannot read orders). Anything else is refused with `403`.
- **Publishing** (`realtime-publisher.ts`): `RealtimePublisher.broadcast` posts to Centrifugo's `broadcast` API with an idempotency key, so a repeat within a few minutes is dropped; it throws `PublishFailedError`, `answered` when Centrifugo refused and not when it was out of reach (2 s). The outbox relay in `ordering` is its only caller; the worker gets it from `NotificationsWorkerModule`.
- **History and recovery** (§6.1): each namespace keeps recent publications (`history_size`, `history_ttl` 10 minutes) and forces recovery, so a client that reconnects with its offset gets what it missed; when it cannot, it fetches the full state (RA §4.3). Centrifugo's engine is memory, so a Centrifugo restart loses history, and clients fetch the full state.
- The proof is `src/modules/ordering/order-realtime.test.ts`: a real Centrifugo, the API on a real port behind its proxy, and a `centrifuge` client.

## Not yet

- `captain:`, `customer:`, `ops:` and `ops_map:` channels (§6.2), with their first publishers.
- Presence and the restaurant devices' heartbeats (RA §4.3, §4.6, architecture §6.3), owner decision 2026-11-06: later, with the receiving-device rule.
- Push (FCM, APNs), owner decision 2026-11-06: later; the outbox relay is where it joins, and AP §8.3's apology on an automatic cancellation with it.
- A Valkey engine for Centrifugo, so history survives a restart and several Centrifugo nodes share it.
- `allowed_origins` for the web apps' connections (the panel's live board).
