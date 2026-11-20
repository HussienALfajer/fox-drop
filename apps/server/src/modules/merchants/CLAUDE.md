# merchants module

Restaurants, their account status, hours, operating state, coverage, minimum order, commission, devices and menu (architecture §4.2; AP §9.6, RA §7, §9, §10).

## Rules

- **Ownership:** this module owns the `merchants` schema. Other modules read restaurants through `MerchantsService` (`restaurant(id)` answers null for an incomplete draft). It cannot read `ordering`: active orders come from the count ordering registers with `countActiveOrders`.
- **Every change takes the restaurant's row lock** (`FOR UPDATE`; `lockEditable` refuses a terminated restaurant with `403 restaurant_terminated`) and is audited in the same transaction with the user, role and device. The same value again writes nothing.
- **Account status:** only along `statusChanges` in `merchants.service.ts`; suspending, reactivating and terminating need a reason; terminated is final. Never skip test mode's activation checklist (`activation-checklist.ts`, pure).
- **Operating state** is the pure rule in `operating-state.ts` (account status, holiday close, schedule, pause, busy, open); only `open` takes orders. Status commands check `status-rules.ts` inside their transaction; the restaurant pauses one at a time, and operations' pauses outrank its own.
- **State changes and timers:** every status change writes a `merchants.state_outbox` row in its transaction (`recordStateChange`, `state-events.ts`); the relay lives in `notifications`. Timers (`status-timers.ts`) run in the worker through queues.
- **Hours:** `weekly_schedules` are versions, never changed. Times are minutes after midnight on the city's clock (`GeoService.cityTimeZone`); a period whose end is not after its start crosses midnight. Reuse geo's `weekly-hours.ts` (`checkWeeklySchedule`, `inDailyWindow`, `nextOpening`).
- **Money:** minimum order, item prices and option deltas are `bigint` minor units in the city's base, checked under `lockCityCurrencies` and registered with `FxService.useCityAmounts`. An item price is above 0, a delta 0 or more. The audit log keeps amounts as strings.
- **Menu:** rows are never deleted (`deleted_at`, `removed_at`). An admin's rows publish at once; a restaurant's new rows and edits wait for a change request's approval (`change-requests.service.ts`), except the owners' commands that publish at once (`restaurant-menu.service.ts`). Any reader goes through `menu(id, now)`, never the raw `available` column (a switch off «حتى الغد» ends by itself).
- **Price and commission history** (`price_changes`, `commission_rates`) are never changed; a commission change needs a reason, never starts in the past and never applies to a draft. An order keeps the commission in force when it was placed.
- **Routes and scope:** panel routes (`restaurants.read`, `restaurants.manage`) are in `admin-*.controller.ts`; restaurant app routes are scoped to `AppSession.merchant.restaurantId` (another restaurant's row is `404`), and the portal's declare `@AppSignedIn({ portal: true })`. Owner-only commands answer `403 owner_only` to a cashier. A terminated restaurant's owners keep only the money section (RA §5.5).
- **Images** go through `FilesService.prepare` before the transaction and `FilesService.link` inside it, never a storage call under the lock.
- **Add a menu or status command:** copy `restaurant-status.service.ts` (status) or `menu-editor.service.ts` (menu), its controller, and a test beside it (`merchant-status.test.ts`, `admin-restaurant-menu.test.ts`).

## More

Behaviour, decisions and history: `docs/code/apps/server/src/modules/merchants.md`. Grep it for what you change; never read it whole.
