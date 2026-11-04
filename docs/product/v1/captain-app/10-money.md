# 10. Money

> Part of the [captain app spec](README.md) (CA). A bare "§n" here means CA §n.

## 10.1 One order, end to end

| Step | Amount | Account |
|---|---|---|
| Pay the restaurant at pickup | −400 ₺ | Custody (`custody.pay_merchant`) |
| Collect from the customer | +410 ₺ | Custody (`custody.collect`) |
| **Custody from this order** | **+10 ₺** | Handed in at the office the same business day |
| Order pay | +35 ₺ | Earnings (`earn.order_pay`), paid on Thursday |

Custody can be negative: for example when a platform discount code is larger than the delivery fee, or when an order fails. The office then pays the captain back (AP §8.5.1).

## 10.2 Custody screen «عهدتي»

- **The total**, with a plain sentence: «عليك تسليم {المبلغ}» (you must hand in) or «لك عند المكتب {المبلغ}» (the office owes you).
- **Per currency:** the balance in each currency held, with the base equivalent. The captain hands back exactly the currencies they received (AP §8.6).
- **Two parts (AP §8.5.4):**
  - «من أيام سابقة» (from previous days): `closed_due`, which blocks going online
  - «من اليوم» (from today)
- **Cash limit:** the limit and a usage bar (§10.4).
- **Entries:** every entry, with the order number, type and amount: pickup payment, collection, change, hand-in, reimbursement, conversion, correction.
- **Receipts:** every desk receipt, with its number, time, amounts and cashier. Receipts appear the moment the desk records them (AP §9.10.3).
- **Office:** the hours and location, with a map button (C13).

## 10.3 Daily hand-in (AP D11)

- **The rule:** hand in the platform's cash every business day. Custody from a closed business day blocks going online (§7.2).
- **At the desk:** the cashier finds the captain, counts what they hand in per currency, and records it. The receipt appears in the app at once, and the block lifts.
- **Reminders:**
  - when going offline with custody (§7.5)
  - a push at 22:00 city time (fixed) if the captain holds custody from today and the office is open, with the closing time
  - on the next attempt to go online, the block message
- **Online across the cutoff:** the captain keeps getting offers for 4 hours after the cutoff (AP §8.5.4). The home screen shows «سلّم نقد أمس قبل {الساعة} لتستمر العروض».
- **Grace:** OWN or FIN MAY grant a grace (AP §8.5.4). The app then shows «مُنحت مهلة حتى {الساعة}». The custody stays due.

## 10.4 Cash limit (AP D10)

- Each captain has a limit set by finance. The app shows it on the custody screen and as a bar on the home screen.
- At `captain.custody_warn_pct` (80%), an amber banner and a push: «اقتربت من حد العهدة. سلّم النقد قريباً.»
- At 100%, the captain gets no new offers until they hand in (§7.1). A current order always continues.

## 10.5 Maximum pickup amount and carried currencies (C4, C8)

**«أقصى مبلغ أحمله»** (maximum pickup amount):

- An amount in the base currency, in Settings. It is empty (no limit) by default. The app asks for it during the activation setup (§5.5), and again the first time the captain goes online if it is still empty (K2).
- Automatic dispatch does not offer orders whose pickup payment is above it (§8.1). OPS MAY override it with a manual offer (§8.4). Handover offers ignore it (§9.10.1).
- The captain can change it at any time without an active order. The new value applies to the next offer.

**«العملات التي أحملها»** (carried currencies):

- Switches for the city's accepted currencies. The base currency is on by default.

**Proposed payment lines at pickup:** the server proposes lines for the pickup payment, using the currencies the captain carries **and** the restaurant accepts (RA §12.7).

1. If both include the base currency, the proposal is the whole amount in the base currency.
2. Otherwise, it is the whole amount in the first common currency in the city's currency display order (AP §8.6), rounded by that currency's rule.
3. If there is no common currency, it is in the base currency, which every restaurant accepts.

The proposal is always one line, and it is always within the tolerance. The captain can split it across currencies or edit it (C8). The server validates the lines (§9.4), and rounding goes to `platform.fx_rounding` (AP §8.11).

## 10.6 Earnings screen «أرباحي»

- **Today and this week:** the earnings so far, the number of orders, and the online hours.
- **Each order:**
  - base pay (including the first km), distance pay, «إكمال للحد الأدنى» when the minimum pay applies, waiting pay, peak bonus
  - the total for that order
- **Other entries:**
  - bonuses (`earn.bonus`), with the reason
  - charges (`earn.charge`), with the order and the reason, when the captain was the responsible party (AP §8.9)
  - deposit instalments (`earn.deposit_instalment`)
  - payouts (`earn.payout`), with their receipt
- **Balance:** «رصيدك المستحق: {المبلغ}» and «موعد القبض: الخميس {التاريخ}».
- **Pay table:** a link to the current pay table and any announced change (§12.5).

## 10.7 Thursday settlement (AP D12)

On `captain.payout_weekday` (Thursday, a business day), the captain comes to the office. The desk does the full settlement (AP §8.5.5):

1. Custody is settled to zero in every currency: the captain hands in, or the desk pays them.
2. Pending deposit instalments are posted.
3. The full positive earnings balance is paid in cash, in the base currency or another accepted currency at the current rate.

The weekly statement then appears in the app. It covers the period since the previous payout:

- the number of orders
- pay by part (base, distance, waiting, peak)
- bonuses, charges and instalments
- the net amount paid

The captain can share the statement as an image.

**Edge cases:**

- A captain who misses Thursday keeps their balance until the next one.
- A negative earnings balance is carried to next week by default (`captain.negative_earnings_policy`). The app explains this.

## 10.8 Tips (C12)

Tips are cash between the customer and the captain. They are entirely the captain's and are never recorded (K14). The work rules page states that the captain must never ask for one.
