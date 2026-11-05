# fx module

Currencies, a city's base and accepted currencies, rate versions, rounding and the rate snapshot an order keeps (AP §8.6, §9.10.4; architecture §4.2, §5.2).

## Rules

- **No floats:** amounts are `bigint` minor units; a rate is an exact reduced fraction (`Rate`: base major units per one major unit of the currency), stored as `rate_numerator` and `rate_denominator`. `parseRate` takes the panel's input in either direction («1 USD = 41.20 TRY» is `base_per_unit`, «1 TRY = 290 SYP» `units_per_base`), up to 18 significant digits, so both parts fit a PostgreSQL `bigint`.
- **Currencies are data** (`fx.currencies`): the migration seeds TRY, USD and SYP in every environment, with ISO 4217 decimals (owner decision 2026-11-05: 2 for all three). A redenomination is a new row. Never change a currency's decimals once amounts use it.
- **A city's currencies** (`fx.city_currencies`): its accepted currencies with display order and enabled flag, the base among them (`fx.city_bases`). Once the city has a base, another currency is enabled only with a rate against it, and the base stays enabled.
- **The base currency** (D25) can change until the city's first order. A change enables the new base and disables the other currencies, since their rates were against the old base; they are enabled again once each has a rate against the new one. `snapshotForOrder` sets `locked_at` inside the transaction that places the order, so a base change either waits for it or happens before it; a rolled-back order locks nothing.
- **Rates** (`fx.rate_versions`) are append-only: a change is a new version with its editor (an admin, never the system) and an optional reason; the application role cannot update or delete one. The current rate is the newest version against the current base. A change above `fx.large_change_confirm_pct` from the current rate is refused until the caller passes `confirmLargeChange` (the screen's second confirmation).
- **Rounding** is the settings `currency.<code>.rounding_unit` (in the currency's minor units) and `currency.<code>.rounding_mode`, read through `SettingsService`, so their history, reasons and edit roles stay in one place. `roundToUnit` rounds `nearest` (a half goes up), `up` (towards +∞) or `down` (towards −∞).
- **The snapshot** (`RateSnapshot`) holds every enabled currency with its rate version, decimals and rounding rule. `snapshot` serves a quote; `snapshotForOrder(cityId, tx)` serves the order and locks the base. Every later calculation for the order uses the snapshot it kept (`equivalent` for what the customer sees in another currency, rounded by its rule; `toBase` for a payment line, to the nearest base minor unit). A currency without a rounding unit refuses the snapshot (`rounding_unit_missing`, owner decision 2026-11-05), so no order is placed until the owner enters it.
- **The settings check the city's currencies through fx:** `FxService` registers itself with `SettingsService.useCityCurrencies` when the module starts, since fx reads the rounding settings and settings cannot import fx back. A process that changes settings must import `FxModule` (the API does).
- **Every change** of a city's currencies, base or rates is audited in its transaction (`city_currency.set`, `base_currency.set`, `rate.set`). Changes of one city's currencies take turns on an advisory lock.
- **Refusals** throw `FxRefusedError` with its `refusal`; the routes and the ordering module map them to their answers.

## Not built yet

- The exchange rates routes and screen (AP §9.10.4): the current rates, their history and the rate edit (owner decision 2026-11-05: the service first, the routes with the finance screen).
- The stale-rate alert for OWN and FIN after `fx.stale_alert_hours` (AP §8.6): `currentRates` gives each rate's `setAt` for it.
- A rate version (or the base equivalent) on cross-currency ledger journals, so `platform.fx_rounding` can be read in the base currency: with the first journal that spans two currencies.
