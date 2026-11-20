# cashdesk module

The cash desk «الصندوق» at the office counter: drawer sessions, numbered receipts, captain settlement, restaurant and customer payments, statements and manual entries (architecture §4.2; AP §9.10, §4.8, §8.5-§8.8). The money itself moves only through the ledger.

## Rules

- **Ownership:** this module owns the `cashdesk` schema (sessions, receipts and lines, counters, statements, merchant statements, `manual_entries`, `idempotency_keys`). Captains, restaurants, customers and admins are plain ids. Custody is read and locked through `CaptainsService` (`deskCustody`, `deskLock`), never `ledger.*` directly; journals go through `LedgerService.post` (`test/ledger-boundary.test.ts`).
- **Every desk transaction is a receipt:** numbered `{CITY}-{YYYY}-{000001}` per city and year by an upsert of `receipt_counters` in the receipt's own transaction (a rollback gives the number back; never a sequence). Receipts, statements, merchant statements and manual entries are never changed: the application role has no `UPDATE`. A receipt names exactly one party (`receipts_party`). Audit `cash_desk.receipt`.
- **Needs an open session:** a desk transaction takes the user's open session of the right kind in the party's city `FOR SHARE` (`409 no_open_session`), so a close (which locks it `FOR UPDATE`) waits for it. A party, journal or drawer of another city is `404 unknown_*`. Session variance lives on the session only, never in the ledger.
- **Lock order:** session `FOR SHARE`, then the party's desk lock (`CaptainsService.deskLock`, `lockRestaurantAccount`, `lockCustomerDues`), then re-check the idempotency key, then the checks (`nothing_due`, `balance_changed`, `rate_changed`, `above_*`, `drawer_short`). Manual entries take the party's lock first, so a settlement or statement never reads a balance being changed.
- **Idempotency:** every money command takes `Idempotency-Key` (architecture §5.3), stored in `idempotency_keys` (command hash, result ids) in the command's transaction; a repeat within 24 hours answers the first result, another command with the key is `422 idempotency_key_reused`. Reads sent as a POST (previews, searches) take none; neither do opening or closing a session, nor commands that set a value.
- **Confirm what the screen showed:** commands carry the figures the user saw (due, rates, base values) and refuse when they moved. Money travels as strings of minor units in the city's base or an enabled currency, converted by `quoteOf` at the current rate, with `platform.fx_rounding` taking the rounding difference.
- **Pushes in the same transaction:** a receipt queues its silent push (`captain.desk_receipt`, `merchant.settlement_receipt`, `customer.dues_paid`) and, for a captain, `CaptainsService.custodyChanged`, so the app reads its state again.
- **Statements are built by pure functions** (`merchant-statement.ts`, `earnings.ts`, tested) and written under an advisory lock, reading ledger entries from an overlap window before the previous cutoff, because an entry committed late carries an earlier time. Business days and cutoffs use the city's clock, never the server's.
- **Routes:** admin desk routes use `cash_desk.record` (OWN, FIN) and share `desk-http.ts` (`deskUser`, `refusalsAsHttp`); captain routes use `@AppSignedIn()`; restaurant routes use `@AppSignedIn({ portal: true })` and are owners only (`403 owner_only`). Nested enums travel as strings (the Dart generator misnames them).
- **Add a desk command:** copy `manual-entries.service.ts` (key, party lock, audit, journal) with its controller and `manual-entries.test.ts`; a hand-in is the pattern in `cashdesk.service.ts` and `cashdesk.test.ts`.
- **Workers:** weekly statements and overdue alerts run in `merchant-statements.worker.ts`, once per restaurant.

## More

Behaviour, decisions and history: `docs/code/apps/server/src/modules/cashdesk.md`. Grep it for what you change; never read it whole.
