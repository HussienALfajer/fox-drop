# ledger module

Accounts and append-only double-entry journals in every currency (AP §8.4–§8.11; architecture §4.3 item 5, §5.2, §5.6). Money moves only here.

## How another module posts money

- Import `LedgerModule` and call `LedgerService` from `index.ts`. No other module reads or writes `ledger.*`, not even with raw SQL (`test/ledger-boundary.test.ts`).
- **Accounts:** `openAccount({ cityId, purpose, ownerId, currency })` gives the account's id, opening it the first time. A captain, a restaurant, a customer or a drawer account names its owner's id (`captain.custody`, `captain.earnings`, `captain.deposit`, `customer.dues`, `merchant.account`, `platform.cash`); every other platform account is one per city and currency, without an owner.
- **Journals:** `post(journal, tx)` inside the transaction of the change the money belongs to, so both commit or neither does (E3). One journal per entry type, such as `custody.pay_merchant` (`catalogue.ts`). A business event posts several journals in one transaction, all with the same source.
- **Corrections:** `reverse(journalId, { actor, reason }, tx)` posts the journal that cancels another, entry by entry, linked through `reverses_journal_id`; a journal is reversed once. Then post the right journal, if any.
- **Concurrency:** `post` is not idempotent, and the ledger takes no lock. The caller's state change stops a second post (the order's version, the receipt), and a post whose amount comes from a balance, such as a full payout (AP §8.5.5), first locks the owning record in its own module (`SELECT … FOR UPDATE` on the captain or the drawer session), so two desks cannot pay the same balance.
- Call `openAccount` at `READ COMMITTED`, the default: in an older snapshot it cannot see an account a concurrent transaction just opened.
- **Amounts** are `bigint` minor units with the account's currency on every entry, from the platform's side: `+` a debit (the platform holds or is owed more, or spent more), `−` a credit. Each journal sums to zero in each currency. Never a `number`, never a float.
- **Balances** are the sum of the entries (`balance(accountId)`; `balanceAt(accountId, at, plusSince)` for the custody at a cutoff plus the desk entries since, AP §8.5.4, with an entry at its transaction's time; `ownerAccounts(cityId, ownerId, purpose)` lists an owner's accounts), shown from the party's view as the specs state them: custody `+` the captain must hand in, earnings `+` the platform owes the captain, the restaurant account `−` the restaurant owes. No balance is cached yet; the first cache brings the nightly reconciliation job (architecture §5.6).

## Counter-accounts

`journalRules` in `catalogue.ts` gives each type the account it is named for and the accounts its other side may use; `post` refuses any other (owner decisions 2026-11-05):

- **The order clearing account** `platform.order_clearing` «طلبات قيد التسليم» is the other side of the order's cash and exceptions: `custody.pay_merchant`, `collect`, `change_given`, `pickup_correction`, `merchant.discount_share`, `credit`, `debit`, `earn.charge`, and the order's platform journals (`platform.revenue_delivery`, `discount_cost`, `compensation_cost`, `operating_cost`, `test_cost`, `fx_rounding`). Only a journal whose source is an order touches it, and an order's entries on it sum to zero once its money is settled. In the AP §8.4 example: pickup `+400`, collection `−410`, delivery fee `+40`, platform code `−30` (`worked-example.test.ts`).
- `merchant.commission` against `platform.revenue_commission` on a normal order. On an order that ends after pickup with another outcome, it goes against the order clearing account instead: the commission then recovers part of the pickup payment, so the platform's loss is the merchant net (AP §8.9 rule 3). For example, captain responsible: pickup `+400`, `earn.charge` `−340`, commission `−60`.
- After a normal delivery the order is settled, so a ticket's `merchant.debit` or `earn.charge` (AP §8.10) goes against `platform.compensation_cost`, recovering the remedy's cost.
- `earn.order_pay`, `waiting_pay` and `peak_bonus` against `platform.captain_pay`, or `operating_cost` when the platform bears the pay (AP §8.9), or `test_cost` on a test order (AP §9.6.3); `earn.bonus` against `platform.captain_pay`.
- At the desk: `custody.hand_in`, `custody.reimburse`, `earn.payout` and `merchant.settlement` against the drawer's `platform.cash`, which they must reach; a payment in another currency than the account's adds its two sides on `platform.fx_rounding`, one per currency. `platform.fx_rounding` takes a party journal's side only when the journal spans two currencies. `custody.fx_convert` moves custody between two currencies of one captain through `platform.fx_rounding`.
- `earn.deposit_instalment` against the same captain's `captain.deposit`, paid back at termination.
- `dues.charge` on the customer's `customer.dues` «مستحقات الزبون» (AP §8.8, base currency, owned by the customer's account; + the customer owes) against the order clearing account for the loss it recovers and `platform.revenue_delivery` for the rest (a fake order, AP §8.9). `dues.payment` and `dues.adjustment` come with the desk (slice 2.25).
- Every `*.adjustment` against `platform.adjustments` «القيود التصحيحية», with a reason. `earn.bonus` needs a reason too (AP §8.5.2); the database refuses either without one.

One journal reaches the accounts of one captain, one restaurant or one customer only.

## Rules

- **Append-only:** the application role can `INSERT` and `SELECT` only, on every table and every partition (`migrations/0007_ledger_accounts_journals_entries.sql`, proved by `src/database/migrations.test.ts`). A correction is a reversing journal with a reason (`reverses_journal_id`), never an update.
- **Database guards beside the service:** entries reference their journal's city and their account's city and currency; the checks refuse an unknown type or purpose, a zero amount and a correction without a reason. Two triggers keep the double entry even against raw SQL: an entry joins only a journal posted in its own transaction, and at commit every journal has two entries or more and sums to zero in each currency (`ledger.journal_balances`, deferred). The counter-account rules are checked in `post` only.
- **A new entry type or account purpose** goes into `catalogue.ts` with its rule and into a new migration that replaces the matching `CHECK`s (`journals_type_values`, `journals_reason_required`, `accounts_purpose_values`, `accounts_owner_present`; the catalogue test compares them both ways).
- **Partitions:** the entries are partitioned by UTC month, created by `ledger.create_month_partitions()` as the migration role; the `worker` calls it at start and every day (`LedgerWorkerModule`).
- **Not built yet:** `openAccount` takes any currency code, not only the city's currencies (`FxService.cityCurrencies`); a cross-currency journal records no rate version yet (`src/modules/fx/CLAUDE.md`); the customer's dues payment and adjustment (AP §8.8, slice 2.25) and the deposit refund come with their slices.
