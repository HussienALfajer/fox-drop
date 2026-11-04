# 9.10 Finance «المالية»

> Part of the [admin panel spec](../README.md) (AP). A bare "§n" here means AP §n.

## 9.10.1 Daily report «التقرير اليومي» (per business day; Excel export)

- Orders: count, GMV (customer totals), items value.
- Delivery fees; discounts split by funder (platform, restaurant); commissions earned today.
- Captain pay (base, distance, waiting, peak, bonuses); compensation costs; operating costs from outcomes; rounding and FX differences.
- **Platform margin.**
- **Cash from captains, per currency:**
  - custody created today
  - handed in today
  - reimbursed today
  - open custody at the cutoff
  - captains blocked
- **Owed by restaurants:**
  - commission and restaurant-funded discounts posted today
  - the total open restaurant balances, to be collected on Saturday
  - overdue restaurants
- Comparison with previous days.

The margin is earned when orders finish, but the cash arrives at different times: custody daily, earnings paid on Thursday, commission collected on Saturday (§8.4). The report shows both: what was earned, and what cash actually came in or went out.

## 9.10.2 Captain balances «أرصدة الكباتن»

- **Columns:**
  - captain
  - custody per currency and base equivalent
  - `closed_due` (due from closed days, §8.5.4)
  - cash limit and usage %
  - blocked flag, and any grace
  - earnings balance
  - last hand-in
  - last payout
- Sorted by highest custody by default. «سجّل تسليماً» (record a hand-in) opens the cash desk for that captain.

## 9.10.3 Cash desk «الصندوق»

The cash desk is used at the office counter. Every transaction gets a numbered receipt (§4.8). Receipts are printable on an 80 mm thermal printer or on A4, and appear immediately in the other party's app.

**Tabs:**

1. **«تسليم النقد اليومي»** (daily hand-in):
   1. Find the captain by name or phone.
   2. See their custody per currency, split into `closed_due` (blocks going online, §8.5.4) and today's custody, with the expected amount.
   3. Enter what is physically received per currency.
   4. Confirm.
   5. The receipt is issued.

   - If custody is negative in a currency, the desk pays it back (`custody.reimburse`).
   - **Cross-currency settlement:** if the captain holds one currency and settles in another, the desk converts at the current rate, shown on screen (`custody.fx_convert`). FIN and OWN only.
   - A difference between expected and received stays as open custody. It is not hidden.
2. **«تصفية الخميس»** (Thursday settlement):
   - Lists the captains with an earnings balance or open custody.
   - Performs the full settlement in §8.5.5 in one flow and issues the weekly statement.
   - On other days the tab is read-only, except for OWN.
3. **«تسوية المطاعم»** (restaurant settlement, Saturdays):
   - Lists every restaurant with a non-zero account balance: the week's commission, restaurant-funded discounts, exceptions and the total due. Overdue restaurants are shown first.
   - Opening a restaurant shows its weekly statement (§8.7), entry by entry.
   - Record the settlement: the amount collected from the restaurant per currency (or paid to it, if the balance is positive), the method («في المكتب» or «زيارة ميدانية» plus the staff member), and the receipt.
   - A partial payment is allowed. The rest stays on the account and counts as overdue.
   - **Field visit:**
     - If the visitor is an OWN or FIN user, they record the payment on the spot from their phone, in a field drawer session opened with a zero float. The receipt is issued and reaches the restaurant app immediately. They close the field session when they hand the cash to the office.
     - If the visitor has no FIN role, the payment is recorded when the cash reaches the desk, naming the visitor, and the receipt is issued then.
4. **«مستحقات الزبائن»** (customer dues): find the customer, see the dues, record the payment (`dues.payment`, any accepted currency at the current rate), issue a receipt and unblock automatically.
5. **«التأمينات»** (deposits): kit deposits and instalments, and refunds at termination.

**Bulk hand-in grace** (OWN): a button on the daily hand-in tab grants a grace for one business day to all captains (§8.5.4), with a reason, for example when the office was closed.

**Drawer sessions «جلسة الصندوق»:**

- Every desk user opens a drawer session with an opening float counted per currency. Every transaction belongs to the open session. A user can have one office session and one field session (§9.10.3, field visit) open at a time.
- **Close «إقفال الصندوق»:**
  - the system shows the expected cash per currency
  - the user enters the counted cash
  - any variance is recorded with a note
- A session cannot be closed while a transaction is unconfirmed.
- OWN sees all sessions and variances.

## 9.10.4 Exchange rates «أسعار الصرف» (OWN, FIN)

- The current rate for each accepted currency, with its last update, the editor and the history.
- Edit a rate with a large-change confirmation (§8.6).
- Rounding unit and mode for each currency (D14).

## 9.10.5 Restaurant statements «كشوف المطاعم»

For any restaurant and any period:

- orders and items value received in cash from captains (the pickup payments), with the currency lines when the restaurant accepted another currency
- commission per order
- restaurant-funded discounts
- exceptions (credits and debits) with the order and reason
- Saturday settlements with receipts
- the opening and closing balance

Exportable to Excel and printable.

## 9.10.6 Compensation and discount costs

The cost of codes, compensations and operating costs for a period, split by reason, by code, by responsible party and by restaurant.

## 9.10.7 Adjustments and reversals «القيود التصحيحية» (OWN, FIN)

- Post a manual entry on any ledger (custody, earnings, restaurant account, customer dues) with a reason, or reverse an existing entry. The reversal links to the original.
- A list of all manual entries: who posted it, when, why, and what it corrects.
- Nothing can be deleted.
