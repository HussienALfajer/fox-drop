# 8.3 New order

> Part of the [restaurant app spec](../README.md) (RA). A bare "§n" here means RA §n.

- Every receiving device rings (§4.4). The full-screen prompt shows:
  - «طلب جديد #{رقم}»
  - the items with their options and notes, and the customer note
  - the items value, «يدفعها لك الكابتن عند الاستلام»
  - the countdown to automatic cancellation, «يُلغى تلقائياً خلال {د:ث}», counting to `order.merchant_auto_cancel_min` (7) (R8)
  - the prep-time chooser and the buttons «قبول — {د} د» and «رفض»
- After `order.merchant_accept_alert_min` (3) minutes, the prompt adds «تأخرتم في الرد — سيتصل بكم فريق العمليات». Operations get their critical alert at the same moment (AP §9.1.3).
- Opening the detail does not stop the ring; only a decision does.
- **No answer:** when the order is cancelled automatically, the prompt closes with a chime and «أُلغي الطلب #{رقم} لعدم الرد». A banner shows the count: «طلبات دون رد اليوم: {العدد} من {الحد}. عند {الحد} يتوقف مطعمك تلقائياً.»
- **Auto-pause:** at `merchant.auto_pause_unanswered_count` (3) unanswered orders in one business day, the restaurant is auto-paused (§7.1, AP §9.6.5).
- **Customer cancels first:** if the customer cancels while the order is `placed`, the prompt closes with a chime and «ألغى الزبون الطلب #{رقم}». This does not count as unanswered.
