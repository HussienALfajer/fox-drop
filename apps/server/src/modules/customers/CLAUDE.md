# customers module

Customers' profiles, saved addresses and restaurant browsing, plus strikes, blocks, trust, dues reads and the panel's customers module (architecture §4.2; CU §5.3, §7–9; AP §8.8, §9.8; docs/domain/08).

## Rules

- **The account is identity's:** `customer_accounts` and sign-in live in `identity`. This module keys its rows by the account id, a plain column, and reads `AppSession.accountId`.
- **Ports instead of imports:** this module cannot import ordering, support or marketing. They register ports at start (`useOrderFacts`, `useActiveOrders`, `useRatings`, `useCustomerTickets`, `useLastDeliveries`, `useDeliveredCounts`); read through them.
- **The customer's line:** a new account on a closed account's number continues its line (`lineage_id`). Every read of standing (blocks, strikes, clears, trust, dues) takes the line (`CustomersService.lineage`); dues are the line's (`lineDues`).
- **The ordering lock:** commands that change blocks, strikes, trust or closing run under the customer's ordering lock (`customerOrderLock`; `lockLine` for a line), the lock placing takes first, so a command and a placing take turns. Placing reads blocks, review stop and dues again under it.
- **Append-only tables:** blocks, strikes, clears, trust marks, test flags, device lifts, notes, search misses and suggestions; the application role may change only the end columns of blocks and review stops. Never delete a row (addresses and favourites are soft-deleted).
- **The menu customers see** is read through `MerchantsService.menu(id, now)` only. Restaurants customers do not see answer `404`. A card reads the list's shared `listed` cards; reuse it, do not re-measure trips.
- **Phones:** another contact number is encrypted with `PhoneCipher` and needs a recipient name; the panel gets only the masked form (`maskedPhone`), full numbers only for `customers.reveal_phone`.
- **Snapshots:** an order keeps its own copy of the address (`orderAddress`); never link an order to a saved address row.
- **Panel routes** declare a permission (`customers.read`, `customers.manage`, `customers.block`, `customers.close_account`, `customers.test_account`, and so on, per AP §6.3), audit every write (`customer.*`) and answer the profile. A command that sets a value takes no `Idempotency-Key`; one that appends a row keeps the key on the row and answers `422 idempotency_key_reused` for another body.
- **Guest routes** use `@AppSignedInOrGuest()` and must work with no session; routes that need the customer use `@AppSignedIn()`.
- **Public routes** read the database and OSRM per card: keep nginx's per-IP limits in mind (architecture §15.5).
- **Time and zones:** birthdays and clocks are on Syria's or the city's clock; the zone at a pin comes from `GeoService.locate`; «الحي» is never stored.
- **Pure rules have tests next to them** (`blocks.ts`, `trust.ts`, `devices.ts`, `search-text.ts`); change the rule and its test together.

## More

Behaviour, decisions and slice history: `docs/code/apps/server/src/modules/customers.md`. Grep it for the feature, route, table or label you are changing and read only those lines; never read it whole.
