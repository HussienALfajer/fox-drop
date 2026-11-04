# 9.2 Operations room «غرفة العمليات»

> Part of the [admin panel spec](../README.md) (AP). A bare "§n" here means AP §n.

**Purpose:** watch every live order and step in at any moment. This is the dispatcher's screen for the whole shift.

## 9.2.1 Board

The board has five columns, laid out right to left:

«بانتظار المطعم» → «قيد التحضير» → «جاهز» → «مع الكابتن» → «الكابتن وصل»

Each column header shows its count and how many of its cards are late.

**An order card shows:**

- The order number, the restaurant name and the customer's neighbourhood.
- **Time in the current state**, with an SLA colour:
  - green: within the limit
  - amber: 80% or more of the limit used (fixed)
  - red: past the limit

  The limit for each column:

  | Column | Limit |
  |---|---|
  | «بانتظار المطعم» | The acceptance alert (3 min) |
  | «قيد التحضير» | The chosen prep time |
  | «جاهز» | The no-captain-after-ready limit (15 min) |
  | «مع الكابتن» | The promised delivery time |
  | «الكابتن وصل» | The no-answer window (15 min) |

- The captain's name, or a red «بلا كابتن» (no captain) when unassigned.
- The customer total in the base currency.
- Badges:
  - «زبون جديد» (new customer)
  - «كود خصم» (discount code)
  - «ملاحظة» (note)
  - «طلب ثانٍ اليوم» (customer's second order today)
  - «معدّل» (edited by admin)
  - «تجريبي» (test order)
  - «بحاجة لتعيين» (needs assignment, §8.3)
  - «بانتظار تأكيد الاستلام» (pickup request waiting for the restaurant, §8.1)
  - «صنف نفد» (open item-unavailable report)
  - «إيقاف طارئ» (the order was active while the emergency stop was on)

**Filters:** restaurant, captain, neighbourhood or zone, «المتأخر فقط» (late only), «بلا كابتن فقط» (no captain only), «لها تذكرة» (has a ticket), and test orders shown or hidden.

**Interaction:** clicking a card opens the order detail (§9.3) in a side panel, so the board stays visible.
