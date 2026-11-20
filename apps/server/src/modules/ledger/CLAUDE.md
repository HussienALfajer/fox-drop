# ledger module

Accounts and append-only double-entry journals in every currency (AP §8.4–§8.11; architecture §4.3 item 5, §5.2, §5.6). Money moves only here.

## Rules

- **Only through `LedgerService`:** import `LedgerModule` and use the service from `index.ts`. No other module reads or writes `ledger.*`, not even with raw SQL (`test/ledger-boundary.test.ts`).
- **Post in the change's transaction:** `post(journal, tx)` runs in the transaction of the change the money belongs to, so both commit or neither does (E3). One journal per entry type (`catalogue.ts`); a business event posts several journals in one transaction, all with the same source.
- **Amounts** are `bigint` minor units, with the account's currency on every entry, from the platform's side: `+` a debit, `-` a credit. Each journal sums to zero in each currency. Never a `number`, never a float.
- **Accounts:** `openAccount({ cityId, purpose, ownerId, currency })` returns the id, opening it the first time. Call it at `READ COMMITTED` (the default). A captain, restaurant, customer or drawer account names its owner; other platform accounts are one per city and currency.
- **Concurrency:** `post` is not idempotent and takes no lock. The caller's state change (the order's version, the receipt) stops a second post; a post whose amount comes from a balance (a full payout) first locks the owning record in its own module (`SELECT ... FOR UPDATE`).
- **Corrections:** `reverse(journalId, { actor, reason }, tx)` posts the cancelling journal, linked by `reverses_journal_id`; a journal is reversed once. Never update or delete an entry.
- **Append-only:** the app role can `INSERT` and `SELECT` only, on every table and partition (`src/database/migrations.test.ts`). Never grant `UPDATE` or `DELETE`.
- **Counter-accounts:** `journalRules` in `catalogue.ts` gives each type the account it is named for and the accounts its other side may use; `post` refuses any other. A journal reaches the accounts of one captain, one restaurant or one customer only. The order clearing account (`platform.order_clearing`) is touched only by a journal whose source is an order, and an order's entries on it sum to zero once settled (`worked-example.test.ts` is the AP §8.4 example).
- **Reasons:** every `*.adjustment` and `earn.bonus` needs a reason; the database refuses one without.
- **Database guards:** triggers keep the double entry even against raw SQL (an entry joins only a journal posted in its own transaction; at commit each journal has two entries or more and sums to zero per currency). The counter-account rules are checked in `post` only.
- **A new entry type or account purpose** goes into `catalogue.ts` with its rule and into a new migration replacing the matching `CHECK`s (`journals_type_values`, `journals_reason_required`, `accounts_purpose_values`, `accounts_owner_present`); the catalogue test compares both ways.
- **Rate versions (AP §8.6):** a journal spanning two currencies or more carries `rates`, `[{ currency, rateVersionId }]` for each currency but the base; a one-currency journal carries none (`post` refuses either way). `reverse` copies the original's rates.
- **Balances** are the sum of entries (`balance`, `balanceAt`), shown from the party's view as the specs state them. No balance is cached yet.
- **Partitions:** entries are partitioned by UTC month by `ledger.create_month_partitions()` (migration role); the `worker` calls it at start and daily (`LedgerWorkerModule`).

## More

Behaviour, decisions and history: `docs/code/apps/server/src/modules/ledger.md`. Grep it for what you change; never read it whole.
