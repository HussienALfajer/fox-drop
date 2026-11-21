# ordering module

The quote, the order, its state machine, edits and outcomes, delivery, pickup, ratings, reports and the order reads of every app (architecture §4.2, §5.5; CU §10-§12; RA §8; CA §9; AP §8, §9.3). The biggest module; most files are one feature each (`cancellation.ts`, `outcome.ts`, `order-edits.ts`, ...).

## Rules

- **Patterns to copy:** a restaurant command is `order-commands.ts` (`OrderCommands.run`); placing is `orders.service.ts`; the state change and its events are `order-events.ts`; timers are `order-timers.ts`; the relay is `outbox-relay.ts`; the schema is `schema.ts`. Tests sit beside the code as `<feature>.test.ts`, with shared setups in `*.fixture.ts`.
- **The quote is computed, never stored** (`quote.ts`, `quote.service.ts`). Money is integer minor units, rounded to the base currency's unit and mode from the order's rate snapshot; the order keeps the money as the quote priced it.
- **Every transition is one transaction:** `lockOrder` (by id and `placed_at`), check the state and the version, write the new state with `version` + 1, then `recordTransition` writes the `order_events` row, the `outbox` row and the relay job (`QUEUES.outboxRelay`). Timers (pg-boss jobs) are sent in the same transaction. A change of the captain track or of the time, from a status to the same status, is a transition too.
- **Nothing slow inside the transaction:** never call the distance service or another slow one in it. Read what is slow (settings, distance, the quote) before it. Where two locks are taken, the customer's first, then the restaurant's.
- **Events leave through the outbox** (E4): `ordering.outbox`, with a payload of `schema: 1`. The relay publishes at least once; clients order events by the order version and ignore one not newer than the one they show. The application role may only insert outbox rows and change `published_at`; `order_events` is append-only.
- **Partitions:** `orders`, `order_lines` and `order_events` are partitioned by the UTC month of `placed_at`; lines and events carry the order's `placed_at`. `ordering.create_month_partitions()` runs from `OrderingWorkerModule`. A table keyed by the order needs `placed_at` too.
- **Idempotency** (architecture §5.3): every command takes `Idempotency-Key` except those `apps/server/CLAUDE.md` exempts (the captain's acknowledgements, a rating, the emergency stop) (`@Idempotent()`, `@IdempotencyKey()` from `src/http/idempotency.ts`; `idempotency-keys.ts` here). Replay the key before anything else and again under the lock; write it in the command's transaction, so a refused command keeps no key.
- **State errors:** a state a command no longer allows answers `409 order_state_changed` with the order as it is now (a reveal's carries none); another party's order is `404 unknown_order`.
- **Order numbers** (AP §4.8) are taken last in the order's transaction, so a refused order leaves no gap.
- **No cross-module reads:** other modules reach orders through exported services (`OrderAssignments`, `ReportOrdersService`, ...) or events; `OrdersService` registers ports with others (for example `MerchantsService.countActiveOrders`). Never import another module's schema.
- **Realtime:** the order's channel check is `OrderChannelAccess`; a customer subscribes only to their own order. The restaurant's board never carries the delivery fee, the total, the address, any phone, the promised time or operations' moments (R11); the customer's captain card never carries the captain's phone, nor the captain's order the customer's: a number leaves only through a reveal command that records the tap (`order-contacts.ts`).

## More

Behaviour, decisions and history: `docs/code/apps/server/src/modules/ordering.md`. Grep it for what you change; never read it whole.
