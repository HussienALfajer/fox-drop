# dispatch module

Eligibility, ranking, offers, assignments and handovers: manual dispatch (the launch mode), the automatic dispatcher of «آلي» and «مختلط», the captain's answer and the offer timer (architecture §4.2; AP §9.3.2, §9.12.6, §8.3; CA §8, §15).

## Rules

- **Ownership:** this module owns `dispatch.offers`, `dispatch.manual_orders` and `dispatch.idempotency_keys`. The order, its captain and its captain track belong to `ordering`: every change goes through `OrderAssignments` from `ordering/index.ts` (`find`, `lock`, `assignable`, `change`), which writes the order, its event and its outbox row in this module's transaction. Captains' state, eligibility and pay come from `CaptainsService`, the restaurant from `MerchantsService`, distances from `GeoService`.
- **Lock order:** the order first (`OrderAssignments.lock`), then the offer (`FOR UPDATE`), then the captain (`CaptainsService.assignmentLock`). Run slow reads (candidates, road distance, settings) before the transaction, and let pg-boss connect (`jobs.ready()`) before any lock. A command that locks in another order risks a deadlock.
- **Timers and outbox:** every offer sends its `QUEUES.offerExpiry` job in its own transaction. `OfferTimersWorker` runs `DispatchService.expire`, which acts only on an offer still open and closes it through the same `close` as every other path. A job that starts before `expires_at` by the database's clock throws, so the queue retries.
- **Idempotency:** every command takes `Idempotency-Key` (`idempotency_keys` per account, with a hash of the command; a repeat within 24 hours answers the same state, another command with the key is `422 idempotency_key_reused`).
- **Offers stay as logged:** the application role may change only `status` and `responded_at` of an offer (AP §9.7.4). The offer keeps the pay and distance it showed when it opened.
- **Privacy:** before acceptance the captain never sees the customer's name, phone or exact address (C2).
- **Processes:** the API serves the routes (`DispatchModule`), the worker runs the offer timers (`DispatchWorkerModule`), and the `dispatcher` role runs `AutoDispatcher` (`DispatcherModule`), one leader per city holding an advisory lock. Two leaders for a moment must never offer one order twice, so every offer is checked again under the order's and the captain's locks.
- **Cancellation and going offline:** `onModuleInit` registers `OrderAssignments.onCancel`, and `CaptainsService.onWentOffline` calls `withdraw`. A new path that ends an order or a captain's online period must close the open offer the same way.
- **Where to look:** `dispatch.service.ts` (commands), `ranking.ts` (pure ranking), `live-map.ts`, `acceptance-reviews.ts`. Copy `dispatch.fixture.ts` and `dispatch.test.ts` for a new test; `ranking.test.ts` shows the pure-rule style.

## More

Behaviour, decisions and slice history: `docs/code/apps/server/src/modules/dispatch.md`. Grep it for the feature, route, table or label you are changing and read only those lines; never read it whole.
