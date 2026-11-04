# 8.5 Captain accounts: custody and earnings (D11, D12)

> Part of AP §8, the domain reference shared by all four V1 specs ([index](README.md)). A bare "§n" here means AP §n.

Each captain has two separate accounts. Both are append-only ledgers, and their balances are always the sum of their entries.

## 8.5.1 Custody «العهدة النقدية» (per currency)

Custody is the platform's physical cash in the captain's hands.

- A **positive** balance means the captain must hand cash in.
- A **negative** balance means the captain paid from their own pocket and the platform owes them.

| Entry type                  | Sign | When                                                                                                                                                                                                      |
| --------------------------- | ---- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `custody.collect`           | +    | At delivery, one entry per currency the customer paid in                                                                                                                                                  |
| `custody.change_given`      | −    | At delivery, per currency of the change the captain gave back                                                                                                                                             |
| `custody.pay_merchant`      | −    | At pickup: the full items value (D26), per currency the captain paid the restaurant in (normally the base currency)                                                                                       |
| `custody.hand_in`           | −    | Cash handed in at the desk (receipt)                                                                                                                                                                      |
| `custody.reimburse`         | +    | The desk pays back a negative custody (receipt)                                                                                                                                                           |
| `custody.fx_convert`        | ±    | Cross-currency settlement at the desk at the current rate (§9.10.3)                                                                                                                                       |
| `custody.pickup_correction` | ±    | A pickup dispute resolved in the accounts (§9.9.3), per currency: + when the captain paid the restaurant less in that currency than recorded at pickup (they still hold that cash), − when they paid more |
| `custody.adjustment`        | ±    | Manual correction (OWN/FIN, reason)                                                                                                                                                                       |

## 8.5.2 Earnings «المستحقات» (base currency)

Earnings are what the platform owes the captain for their work.

| Entry type                | Sign | When                                                        |
| ------------------------- | ---- | ----------------------------------------------------------- |
| `earn.order_pay`          | +    | Order finished with pay due to the captain (§8.9)           |
| `earn.waiting_pay`        | +    | Waiting past the threshold, if the pay table includes it    |
| `earn.peak_bonus`         | +    | Order delivered inside an active peak window (D15)          |
| `earn.bonus`              | +    | Manual bonus (OWN/FIN, reason)                              |
| `earn.charge`             | −    | Cost charged to the captain as the responsible party (§8.9) |
| `earn.deposit_instalment` | −    | Kit deposit instalment                                      |
| `earn.payout`             | −    | Thursday payout, or an off-cycle payout (receipt)           |
| `earn.adjustment`         | ±    | Manual correction (OWN/FIN, reason)                         |

## 8.5.3 Cash limit (D10)

- Each captain has a `custody_limit` in the base currency, set by OWN or FIN. It is required before activation.
- `captain.custody_limit_suggested.<vehicle>` only prefills the field.
- **Usage** = the sum of positive custody positions, converted at current exchange rates.
- At `captain.custody_warn_pct` (80%) of the limit, the captain gets a warning.
- At 100% the captain gets no new offers until they hand cash in. They can still finish their current order.

## 8.5.4 Daily hand-in rule (D11)

**What is due from closed days.** For each currency `c`:

```
closed_due_c = custody balance_c at the last business-day cutoff
               + desk entries in c posted since that cutoff
                 (custody.hand_in, custody.reimburse, custody.fx_convert, custody.adjustment)
closed_due   = Σ over currencies (closed_due_c × current rate to base)
```

- Desk entries after the cutoff settle the closed days first. Collections and pickup payments after the cutoff belong to the new day and do not count.
- Positive and negative currencies net against each other in `closed_due`, so a captain is not blocked for TRY while the platform owes them more in USD.
- Example: a captain pays a restaurant 400 at 05:50 and delivers for 410 at 06:20 (cutoff 06:00). At the cutoff their balance was −400, so `closed_due` is negative and they are not blocked. The +10 becomes due at the next cutoff.

**Blocking:**

- A captain cannot go online while `closed_due` > `captain.remit_tolerance` (0, base currency). The captain app shows «لديك نقد غير مسلّم من يوم {التاريخ}: {المبلغ}. سلّمه في المكتب لتتمكن من الاتصال.»
- A captain who is online when the cutoff passes is not forced offline and keeps receiving offers for `captain.remit_online_grace_hours` (4). After that they stop receiving new offers until they hand in. They can always finish their current order.
- The cash limit (§8.5.3) applies at all times as well.
- The custody tab (§9.7.4) and the cash desk (§9.10.3) show `closed_due` and today's custody separately.

**Hand-in grace:**

- OWN or FIN can grant a grace to one captain, with a reason, for example when the office was closed.
- OWN can grant a bulk grace for all captains for one business day, from the cash desk.
- A grace lifts the block until the next cutoff. It does not clear the custody, which stays due.

A hand-in is recorded at the cash desk (§9.10.3), and the receipt appears immediately in the captain app.

## 8.5.5 Thursday settlement (D12)

On `captain.payout_weekday` (Thursday), the desk performs «تصفية الحساب الكامل» (full account settlement) for each captain who comes in:

1. Custody is settled to zero in every currency: the captain hands in or the desk reimburses.
2. Pending deposit instalments are posted.
3. The full positive earnings balance is paid out (`earn.payout`) in the base currency, or in another accepted currency at the current rate. The cashier records which.
4. A weekly statement is generated and appears in the captain app. It covers the period since the previous payout and shows:
   - the number of orders
   - pay broken down into base, distance, waiting and peak
   - bonuses, charges and instalments
   - the net amount paid

- If the earnings balance is negative, `captain.negative_earnings_policy` decides what happens. The default `carry_forward` deducts it from the next week. The desk MAY instead collect it in cash.
- A captain who misses Thursday keeps their balance until the next payout.
- Payouts on any other day need OWN, for example at termination.
