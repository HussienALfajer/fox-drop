# 8.6 Currencies and exchange rates (D14, D25)

> Part of AP §8, the domain reference shared by all four V1 specs ([index](README.md)). A bare "§n" here means AP §n.

- **Supported currencies** are data rows with code, Arabic name, symbol, decimals and status. V1 seeds TRY «ليرة تركية», USD «دولار أمريكي» and SYP «ليرة سورية». Because currencies are data, a redenomination can be handled by adding a new currency row.
- **Base currency:** chosen when the city is created (D25). It can be changed until the city's first order. After that it is locked, because changing it would break ledgers. All menu prices, fees, commissions, captain pay, earnings, restaurant accounts and reports use it.
- **Accepted currencies:** the base currency plus any other enabled currencies for the city. Each one has:
  - `rate`: base units per 1 unit of this currency. The UI accepts input in either direction, for example "1 USD = 41.20 TRY" or "1 TRY = 290 SYP", and stores one canonical value with high precision.
  - `rounding_unit`: for example 5 for TRY, 0.5 for USD, 500 for SYP. OWN or FIN sets these (§9.10.4).
  - `rounding_mode`: `nearest` (default), `up` or `down`.
  - Display order and an enabled flag.
- **Rate changes:**
  - Each change is a new rate version that takes effect immediately, with the editor, time and an optional reason.
  - A change larger than `fx.large_change_confirm_pct` (10%) needs a second confirmation, to catch typos.
  - A rate older than `fx.stale_alert_hours` (24) raises an information alert for OWN and FIN.
- **Order snapshot:**
  - When an order is placed it stores the rate of every accepted currency. These are the rates of the quote the customer confirmed; if any rate changed since that quote, placing is refused and the customer sees the new quote (customer-app spec §10.7).
  - Every later calculation for that order uses the snapshot, including admin edits and the money check at delivery.
  - New rates affect new orders only.
- **What the customer sees:** the total in the base currency, plus the equivalent in each other accepted currency, each rounded by that currency's rule.
- **Payment at the door:**
  - The captain records what was received (one or more currency lines) and the change given (currency lines).
  - The server converts the lines with the order snapshot.
  - The net received is the received lines minus the change lines. A difference from the amount due within half the largest rounding unit among the currencies of all the lines is booked as rounding. A net above the amount due beyond that is refused (captain-app spec §9.7).
  - A larger shortfall is flagged to OPS as «نقص في التحصيل». OPS resolves it by choosing the responsible party, with the §8.9 effects applied to the missing amount: captain (`earn.charge`), customer, or platform (operating cost). For the customer, the dues are the missing amount only (`dues.charge`), with a block until it is paid (§8.8). The fake-order dues rule, the strike and any trust change do not apply. Until it is resolved, it shows as an open shortfall on the order and on the dashboard.
- **Payment at pickup:** by default the captain pays the restaurant in the base currency. A restaurant MAY also accept other enabled currencies (restaurant-app spec §12.7). The payment lines are converted with the order snapshot and rounded per currency, as at the door. The rounding difference goes to `platform.fx_rounding`. The restaurant account always counts the pickup payment as the full items value.
- **Custody** is tracked per currency, so the captain hands back exactly the currencies they received. They carry no exchange risk and gain nothing from rate moves.
- **Rounding and FX** differences go to the platform account `platform.fx_rounding` «فروقات التقريب والصرف» (§8.11), which appears in the daily report.
