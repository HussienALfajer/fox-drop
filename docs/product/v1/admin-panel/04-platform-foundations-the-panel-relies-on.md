# 4. Platform foundations the panel relies on

> Part of the [admin panel spec](README.md) (AP). A bare "§n" here means AP §n.

## 4.1 City scope

- A city selector sits in the top bar. V1 has only Azaz, but every screen, query, setting and report is filtered by the selected city.
- Some settings are global, such as admin security and app versions. Most are per city. Appendix A marks the scope of each one.

## 4.2 Real time

- The panel keeps a WebSocket connection per signed-in user. It subscribes to city channels: orders, captain positions, alerts, tickets and the cash desk.
- If the connection drops, a red bar shows «انقطع الاتصال المباشر — يُعاد الاتصال…». The panel reconnects automatically and then re-fetches the current state, so no event is missed.
- Captain positions update on the map at least every 10 seconds while a captain is online (fixed).

## 4.3 Business day

- Each city has `finance.business_day_cutoff` (default 06:00, city time). The platform runs 24/7, so this cutoff defines what "today" means for:
  - reports
  - the daily cash hand-in rule
  - the restaurant auto-pause counter
  - menu items a restaurant marked «غير متوفر حتى الغد» (unavailable until tomorrow), which become available again at the cutoff
  - drawer sessions
  - the weekly days: the Thursday payout and the Saturday restaurant settlement are business days. For example, with a 06:00 cutoff, "Thursday" runs from Thursday 06:00 to Friday 06:00.
- Dates in reports mean business days unless they are labelled as calendar dates.

## 4.4 Settings model

- Settings are typed values (duration, percentage, money, count, enum, boolean, text or schedule) with a default, a scope (global or city) and a list of roles allowed to edit them.
- Every change records the old value, the new value, the editor, the time and an optional reason.
- A change takes effect immediately, unless the setting is effective-dated. Captain pay tables are effective-dated (§9.12.5).
- Each settings screen has «استعادة القيمة الافتراضية» (reset to default) per field.

## 4.5 Reasons and notes

These actions require a reason, chosen from a list (Appendix B) or written as free text:

- cancelling an order
- accepting or rejecting an order on behalf of a restaurant
- editing an order
- reassigning a captain
- setting an outcome
- issuing compensation
- blocking or unblocking a customer
- suspending a captain or a restaurant
- any manual ledger entry
- changing a commission
- closing a customer account
- granting a hand-in grace
- an off-cycle payout
- confirming a pickup on a restaurant's behalf
- recording a captain's arrival or a delivery on their behalf
- releasing a captain's device
- closing an item-unavailable report without an edit
- rejecting a menu change request
- activating or deactivating the emergency stop

Internal notes are free text attached to an order, customer, captain, restaurant or ticket. Only panel users can see them.

## 4.6 Audit

Every write action and every sensitive view (such as revealing a customer phone number) creates an audit event. The audit log is append-only (§9.16).

## 4.7 Formatting

- Layout and text direction: Arabic, right to left. Numbers use Western digits (0–9).
- Money shows its currency symbol or code, for example `410 ₺` or `10.00 $`.
- Dates show as `dd/mm/yyyy`. Times use the 12-hour clock with «ص/م» in the UI. Exports use ISO 8601.
- Durations show as «12 د» for minutes and «45 ث» for seconds.

## 4.8 Identifiers

- **Order number:** sequential per city, shown as `#10423`.
- **Receipt number:** one sequence per city per year for every cash-desk receipt, formatted as `{CITY}-{YYYY}-{000001}`, for example `AZ-2026-000123`. The receipt type is printed on the receipt.
- **Ticket number:** sequential per city, shown as `T-5521`.
