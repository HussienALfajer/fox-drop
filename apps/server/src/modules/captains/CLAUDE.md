# captains module

The captain record, its application and contract, vehicle, status, cash limit, availability and location, and the city's pay table and peak bonus (architecture §4.2, §7.3; AP §9.7, §9.12.5, §8.5.3–8.5.4; CA §4.3, §5, §7).

## Rules

- **Files:** `applications.ts`, `availability.ts`, `pay.ts`, `peak-bonus.ts`, `violations.ts` hold the pure rules (copy their tests, e.g. `availability.test.ts`); `captains.service.ts`, `applications.service.ts`, `application-pipeline.service.ts` and the `*.service.ts` files hold the steps; controllers are split by caller (`captain-*.controller.ts` for the app, `admin-*.controller.ts` for the panel). Real-Garage tests share `application-pipeline.fixture.ts`.
- **Money:** integer minor units; the cash limit, the max pickup and the peak bonus are in the city's base currency, checked under `lockCityCurrencies` (`not_in_base_currency`) and registered with `FxService.useCityAmounts`, so the base never moves under them. A captain's custody and earnings are read through `LedgerService` only, never `ledger.*`.
- **Time:** services take `now`; the city's day and clock come from geo and `Intl`, never the server's zone. Pay-table starts count from the database clock.
- **Status:** change it only through `setStatus` or `setStatusIn` along `statusChanges` (terminated is final), always with a reason, followed by `afterStatus`. A suspension past its end reads as active with no write, so read the captain through `captain(id, now)`. A suspension or termination ends the online period (last-order mode if an order is active).
- **Active orders:** this module never reads ordering's tables; ordering registers `useActiveOrders`. Going offline with an active order is refused under the captain's row lock, which assignment takes too. Before moving a captain's money, take the captain row's lock.
- **Transactions and listeners:** a state change and its listener calls (`onAvailabilityChanged`, `custodyChanged`, `onChanged`, `onRecorded`) happen in one transaction; what runs after the commit (`afterStatus`, live position removal, `onWentOffline`) is returned to the caller, and a listener's failure there is only logged.
- **Idempotency:** a route that sets a value sends no `Idempotency-Key` (a repeat changes nothing more); a note, a violation and other appends keep a key per admin or application. A wrong stage or state is a `409` with the state, so a repeat is refused.
- **Audit:** every admin write is audited (`captain.status`, `captain.custody_limit`, `captain_application.<action>`, `peak_bonus.set`). Not audited: the captain's or applicant's own preferences and data. A phone shown in full needs `captains.manage` and is audited as a view; otherwise it is masked.
- **Tables:** `captains.locations` is partitioned by UTC month, append-only, created by `captains.create_month_partitions()` from the worker. Versioned tables (`pay_tables`, `peak_bonus_versions`) and notes, events and graces are insert-only: the application role has no `UPDATE`.
- **Live position:** Valkey holds the newest point only as a copy; a failed Valkey write is logged and never fails the request, and a reader checks the database state too. A simulated point is never the live position.
- **Offboarding:** a contract's end is its own checklist (`offboardingMissing`); an ended contract leaves the board, the sweeps and the unique indexes (`activeContracts` skips it).
- **Documents:** photos are checked by `FilesService.prepare` before the transaction and linked in it; the applicant never uploads `signed_contract`.

## More

Behaviour, decisions and history: `docs/code/apps/server/src/modules/captains.md`. Grep it for what you change; never read it whole.
