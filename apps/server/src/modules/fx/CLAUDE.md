# fx module

Currencies, a city's base and accepted currencies, rate versions, rounding and the rate snapshot an order keeps (AP §8.6, §9.10.4; architecture §4.2, §5.2).

## Rules

- **No floats:** amounts are `bigint` minor units; a rate is an exact reduced fraction (`Rate`, `rate_numerator` and `rate_denominator`), parsed by `parseRate` (a numerator or denominator beyond PostgreSQL `bigint` is `invalid_rate`).
- **Currencies are data** (`fx.currencies`); a redenomination is a new row. The app role may change a currency's status only, never its decimals.
- **Rates are append-only:** a change is a new version with its editor (an admin, never the system); the app role cannot update or delete one. The current rate is the newest version of the current epoch. A change above `fx.large_change_confirm_pct` is refused until the caller passes `confirmLargeChange`.
- **The base currency** (D25) can change only until the city's first order, and only once the city's money settings and other modules' amounts are in the new base (`amounts_in_other_currency`). A change starts a new `epoch`: a rate counts only in the epoch it was set in. A process that changes a base must import every module that registers with `useCityAmounts` (today `GeoModule`), or fx cannot see their amounts.
- **The lock:** `snapshotForOrder(cityId, tx)` runs inside the order's transaction, sets the city's `locked_at` on the first order and holds a shared row lock on `fx.city_bases`, so a base change either happens before an order or is refused after it. A trigger refuses any change of a locked base.
- **Rounding** is the settings `currency.<code>.rounding_unit` and `rounding_mode`, read through `SettingsService`. A currency without a rounding unit refuses the snapshot (`rounding_unit_missing`), so no order is placed until the owner enters it.
- **Use the order's snapshot** for every later calculation of that order (`equivalent`, `toBase`); never re-read live rates for an existing order. `snapshot` serves a quote; every read of `snapshotForOrder` goes through the transaction. Converters without a snapshot: `currentValue` and `valueAt` (a report; `rate_missing` when no rate).
- **Registration:** `FxService` registers with `SettingsService.useCityCurrencies` at module start, since settings cannot import fx back; a process that changes settings must import `FxModule`.
- **Audit every change** of a city's currencies, base or rates in its transaction (`city_currency.set`, `base_currency.set`, `rate.set`); a change that changes nothing records nothing. Changes of a city's currencies and its money settings take turns on `lockCityCurrencies`.
- **Journals:** a ledger journal spanning two currencies names the rate version of each but the base; ordering takes them from the order's snapshot (`ordering/journal-rates.ts`).
- **Routes** for rates live in `cashdesk` (fx cannot import identity for editors' names); a rate edit sets a value and takes no `Idempotency-Key`.
- **Refusals** throw `FxRefusedError` with its `refusal`; routes and ordering map them.

## More

Behaviour, decisions and history: `docs/code/apps/server/src/modules/fx.md`. Grep it for what you change; never read it whole.
