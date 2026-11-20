# support module

Tickets «الدعم» (architecture §4.2; AP §9.9): manual tickets, resolving and closing, SLA timers, «تذكرة عاجلة», the pickup dispute's ticket, and the reports from the customer, restaurant and captain apps. Compensation and its approvals live in `marketing`.

## Rules

- **Ownership:** this module owns `support.tickets`, `support.ticket_numbers`, `support.ticket_notes` and `support.note_keys`; the application role writes them only through column grants and can neither change nor delete a note. Orders, parties and accounts are plain ids (architecture §4.3).
- **Pure rules first:** `tickets.ts` holds the rules (urgency, resolutions, SLA state, which status changes are allowed, `moneyProblem`) with `tickets.test.ts`; `reports.ts`, `merchant-reports.ts` and `captain-reports.ts` do the same for each app. Put a new rule there, test it pure, then call it from `support.service.ts`.
- **No imports from other modules:** support cannot read orders or customers. Ordering and customers register ports at start (`usePickupDisputes` in `pickup-disputes.ts`, `useTicketOrders` in `ticket-orders.ts`, `CustomersService.useCustomerTickets`); add a port instead of an import.
- **Opening through ordering:** an order's ticket opens in ordering's transaction under the order's lock (`openIn`, `openPickupDisputeIn`), after the settings are read through the pool (`prepare`). `order_active` is then exactly the order's state at that moment.
- **Idempotency:** opening and notes take `Idempotency-Key` kept for good, with the request's hash (`422 idempotency_key_reused`). Assigning and status changes set a value, so they take none; a repeat is `409 invalid_status_change`.
- **Locks and audit:** every change runs under the ticket's row lock and writes its audit line (`ticket.open`, `.note`, `.assign`, `.status`, `.resolve`, `.close`). A closed or resolved ticket takes no change (`409 ticket_not_open`).
- **Alerts and broadcasts:** in the change's transaction `TicketSync.changed` (`ticket-sync.ts`) syncs the alert and writes `ticket.changed` through `PlatformBroadcasts` to `ops:city.{id}` only. A ticket whose order ends turns «عادية» through `TicketSync.orderEnded`, called by ordering's `OrderAlerts.sync`.
- **Resolving:** the resolution, its timer stop, any money entries, the message push and the audit commit in one transaction. A pickup dispute needs `support.resolve_pickup_dispute`, every other ticket `support.manage`.
- **Money:** a ticket's money is in minor units and is decided by ordering's ports, never read from orders here.
- **Words:** type labels come from the Content lists; the two fixed types are in `FIXED_TYPE_LABELS`. Every user-facing string is a translation, in Arabic.

## More

Behaviour, decisions and slice history: `docs/code/apps/server/src/modules/support.md`. Grep it for the feature, route, table or label you are changing and read only those lines; never read it whole.
