# 12. Money (owners)

> Part of the [restaurant app spec](README.md) (RA). A bare "§n" here means RA §n.

## 12.1 How the restaurant's money works

The formulas are in AP §8.4. The restaurant sees only its own part.

| Line                                     | Example | When                   |
| ---------------------------------------- | ------- | ---------------------- |
| Items value, paid by the captain in cash | 400     | At pickup              |
| Commission 15%                           | 60      | Owed; paid on Saturday |
| **The restaurant keeps**                 | **340** |                        |

With a 20 restaurant-funded item discount, the captain still pays 400. The commission is calculated after the restaurant's item discount: 15% × 380 = 57. On Saturday the restaurant owes 57 + 20 = 77, and keeps 400 − 77 = 323.

## 12.2 Account screen «الحساب»

- **Balance card:**
  - «المستحق عليك حتى الآن: {المبلغ}» (owed so far), live for the current week
  - «موعد التسوية: السبت {التاريخ}»
  - if a statement is overdue, a red line: «متأخر: {المبلغ} من كشف {التاريخ}»
- **Today:** «قبضت اليوم من الكباتن: {المبلغ} ({العدد} طلباً)», then the list: order, time, captain, payment lines.
- **This week:** every entry since the last statement closed, grouped by day:
  - commission and discount share per order
  - exceptions listed separately, with the order and the reason (§12.5)
- **Tabs:** «الكشوف» (statements, §12.3) and «الإيصالات» (receipts, §12.4).
- **Questions:** «لدي استفسار» on any entry or statement opens a ticket of the type «استفسار مالي», linked to that entry (§15).
- **Commission changes** (AP D16): owners get a push, «تتغيّر عمولتك إلى {النسبة}% اعتباراً من {التاريخ}» (S15). The account screen shows the current rate and any scheduled change, including a launch commission's end date.

## 12.3 Weekly statement

- **When:** generated at the business-day cutoff that starts the settlement day, Saturday 06:00 by default (AP §8.7). Owners get a push: «كشف الأسبوع جاهز: المستحق {المبلغ}. التسوية اليوم في المكتب أو عند زيارة موظفنا.»
- **Contents** (AP §8.7):
  - each order: items value received from the captain (with the currency lines), commission, restaurant-funded discount
  - exceptions (credits and debits), each with the order number and reason
  - the earlier unpaid balance
  - the total due
- **Status:** «غير مسدّد» (unpaid), «مسدّد جزئياً» (partly paid) or «مسدّد» (paid).
- **Sharing:** as an image or PDF in the app; as PDF or Excel in the portal.

## 12.4 Settlement and receipts

- V1 has no payment inside the app; electronic payments are V5. The owner pays at the office or to a visiting FOX DROP staff member (AP §9.10.3).
- **Payment:** in any accepted currency, converted at the current rate. Partial payments are allowed, and the rest stays due.
- **Receipt:** each payment gets a numbered receipt that appears in the app, with the number, amounts per currency, method («في المكتب» or «زيارة ميدانية»), staff member and time.
  - When the visitor holds the OWN or FIN role, the receipt appears at once.
  - Otherwise it appears when the cash reaches the desk (AP §9.10.3).
- **Safety note** in the app: «لا تسلّم المبلغ إلا لموظف FOX DROP معروف لديك، وتأكد من وصول الإيصال إلى التطبيق.»

## 12.5 Exceptions

Exceptions are entries other than the commission and discount share (AP §8.7):

| Entry                            | Arabic in the app                | Effect              | When                                                                                               |
| -------------------------------- | -------------------------------- | ------------------- | -------------------------------------------------------------------------------------------------- |
| `merchant.credit`                | «تعويض عن طلب أُلغي بعد التحضير» | Lowers what you owe | An order was cancelled after the food was prepared, and you were not responsible (AP §8.9)         |
| `merchant.credit`                | «تصحيح مبلغ الاستلام»            | Lowers what you owe | A pickup dispute was resolved: the captain paid you less than the items value (§8.10)              |
| `merchant.debit`                 | «استرداد مبلغ الاستلام»          | Raises what you owe | A failed or refused order where you were responsible: you return the full pickup payment (AP §8.9) |
| `merchant.debit`                 | «أصناف حُذفت بعد الاستلام»       | Raises what you owe | Items removed after pickup, with you responsible (AP §9.3.3)                                       |
| `merchant.debit`                 | «مشكلة بعد التسليم»              | Raises what you owe | A post-delivery ticket with you responsible (AP §8.10)                                             |
| `merchant.debit`                 | «تصحيح مبلغ الاستلام»            | Raises what you owe | A pickup dispute was resolved: the captain paid you more than the items value                      |
| `merchant.commission` (reversal) | «إلغاء عمولة»                    | Lowers what you owe | The commission on removed or affected items is reversed                                            |
| `merchant.adjustment`            | «تسوية يدوية: {السبب}»           | Either way          | A manual correction by FOX DROP finance                                                            |

Each exception shows the order number, the reason, and who decided it.

## 12.6 Overdue

- If a statement is not fully paid `merchant.settlement_overdue_days` (2) days after the settlement day:
  - owners get a reminder push
  - an amber banner shows: «لديك مبلغ متأخر: {المبلغ}. يرجى التسوية في أقرب وقت.»
  - OWN and FIN get the alert «مطعم متأخر في التسوية» (AP §8.7)
- The app does not pause the restaurant for this. The policy is an open item (§21, AP §13).

## 12.7 Pickup currencies (R9)

- **Setting:** «العملات التي تقبلها من الكابتن» (currencies you accept from the captain) in Settings, owners only.
  - The base currency is always accepted (fixed).
  - The owner can also switch on any other currency enabled for the city (USD, SYP).
  - Changes apply to pickups requested after the change.
  - OPS can see and change this in the restaurant profile on the restaurant's request (AP §9.6.4).
- **Conversion:** amounts in another currency use the order's snapshot exchange rates (AP §8.6), rounded by each currency's rounding rule.
- **Payment lines:** the server proposes the payment lines to the captain, as described in captain-app spec §10.5. Any rounding difference goes to `platform.fx_rounding` (AP §8.11).
- **Restaurant account:** the pickup always counts as the full items value, whatever the currency mix.
- **Display:** the pickup prompt, the order money lines and the statement show the actual currency lines and the base equivalent.
