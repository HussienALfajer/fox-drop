# 8.2 Orders screen

> Part of the [restaurant app spec](../README.md) (RA). A bare "§n" here means RA §n.

- **Columns, right to left:** «جديدة» → «قيد التحضير» → «جاهزة» → «مع الكابتن». Each header shows the count, and how many of its orders are late.
- **On phones:** the four columns become four tabs with counts. A ringing new order switches to the «جديدة» tab.
- **Sorting:**
  - «جديدة»: oldest first
  - «قيد التحضير»: least time left first, late orders on top
  - «جاهزة»: by captain arrival, orders with the captain waiting on top
  - «مع الكابتن»: by pickup time
- **Card (compact):**
  - order number and time since it was placed
  - item count and the first items
  - the captain line (§8.1)
  - the running timer for the column: auto-cancel countdown, prep countdown, or captain waiting time
  - badges (§8.4)
  - one main button: «قبول» (accept), «الطلب جاهز» or «تأكيد الاستلام» (confirm pickup), depending on the state
- **Late cards** turn red: a new order past `order.merchant_accept_alert_min` (3), or an order in preparation past its prep time.
- Tapping a card opens the order detail (§8.4). An order leaves the board when it is delivered or ends.
