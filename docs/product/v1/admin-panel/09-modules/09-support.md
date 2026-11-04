# 9.9 Support «الدعم»

> Part of the [admin panel spec](../README.md) (AP). A bare "§n" here means AP §n.

## 9.9.1 Ticket sources

- «الإبلاغ عن مشكلة» (report a problem) in the customer app: problem type, items concerned, note and up to 3 photos. It is available for `customer.report_problem_window_hours` (24) hours after delivery, once per order (customer-app spec §12.2).
- «أبلغ عن سعر مختلف» (report a different price) on a restaurant page in the customer app: a ticket of the type «سعر مختلف عن المحل», linked to the restaurant rather than an order, with the item, the shop price, a note and a photo, all optional (customer-app spec §9.5). Normal priority.
- The support button in the captain app, with quick reasons.
- The support button in the restaurant app, with ticket types (restaurant-app spec §15) and quick reasons on an order (restaurant-app spec §8.19).
- A pickup dispute after confirmation: the restaurant's «المبلغ غير صحيح» within `order.pickup_dispute_window_min` (10) minutes creates an urgent ticket «خلاف على دفعة الاستلام» automatically (§8.1). A captain's «مشكلة في مبلغ الاستلام» creates the same kind of ticket (captain-app spec §9.4).
- Manual tickets created by staff after a phone call or WhatsApp message «تذكرة يدوية».

## 9.9.2 Ticket list

- **Columns:**
  - number and source
  - linked order
  - type
  - priority («عاجلة» urgent for any active order and for every pickup-dispute ticket; «عادية» normal)
  - status: «جديدة» (new), «قيد المعالجة» (in progress), «بانتظار رد» (waiting for reply), «محلولة» (resolved), «مغلقة» (closed)
  - assignee
  - SLA timer
- **SLA timers:**
  - First response for an active order: `support.first_response_active_min` (15 min).
  - Resolution after delivery: `support.resolution_post_delivery_hours` (24 h).
  - The timer turns amber at 80% (fixed) and red when it is breached.
- **Filters:** status, type, assignee, source, breached SLA.

## 9.9.3 Ticket page

- The linked order (opens the full detail), problem type, photos and the customer's note.
- Internal handling notes and canned replies «ردود جاهزة».
- **Resolution:**
  - «كود تعويض» (compensation code): within the cap; above it, an approval request (§6.4).
  - «إعادة توصيل مجانية» (free re-delivery of missing or wrong items): creates a linked order with a customer total of 0 and the affected items.
    - Restaurant responsible: the restaurant replaces the items for free. The pickup payment is 0 and no commission is posted.
    - Captain or platform responsible: the captain pays the restaurant normally at pickup, commission is posted as usual, and the desk reimburses the captain's negative custody. The merchant net of the re-delivered items is borne by the responsible party per §8.9: captain (`earn.charge`) or platform (`platform.compensation_cost`).
    - Not available when the customer is responsible.
    - It goes to the original order's address snapshot. The customer cannot cancel or rate it, and it does not count toward the active-order limit or toward trust (§8.8).
    - The captain pay for the re-delivery goes to `platform.compensation_cost`, unless OPS charges it to the responsible restaurant or captain.
  - «لا شيء مع توضيح» (no remedy, with an explanation).
- **Responsible party** (required to resolve, except for price-difference tickets): restaurant, captain, customer or platform. The money effect follows §8.10, including the wrong-change rule, and is previewed before the ticket is resolved.
- **Pickup dispute «خلاف على دفعة الاستلام»** (resolved by OWN, OPS or FIN). The ticket shows the pickup payment, the captain's payment lines, the amount the restaurant says it received, and whether the restaurant confirmed manually or the confirmation was automatic. Resolutions:
  - «دفع الكابتن الفرق» (the captain paid the difference in person): no entries.
  - «تصحيح في الحسابات» (correct the accounts). The ticket holds the currency lines the restaurant says it actually received, and OPS may correct them.
    - **Captain:** for each currency, the difference between the lines recorded at pickup (`custody.pay_merchant`) and the received lines is posted as `custody.pickup_correction` in that currency. It is + when the captain paid less than recorded, because they still hold that cash and hand it in. It is − when they paid more, and the desk reimburses them.
    - **Restaurant:** take `D` = recorded total − received total in the base currency, converted with the order snapshot. If `D` > 0, post `merchant.credit` of `D`. If `D` < 0, post `merchant.debit` of |`D`|.
    - **Example:** the captain recorded 5 $ + 195 ₺, and the restaurant received only 195 ₺. The server posts +5 $ custody on the captain and a 206 ₺ credit to the restaurant.
    - The entries are shown in a preview first.
  - «الدفعة صحيحة» (the payment was correct): no entries; the restaurant gets the explanation.
- **Price difference «سعر مختلف عن المحل»** (from the customer app, linked to a restaurant, not an order). It needs no responsible party and gives no compensation. Resolutions:
  - «تم تصحيح السعر» (the price was corrected): OPS corrected the menu price with the restaurant (§9.6.6)
  - «السعر صحيح» (the price is correct)

  The customer gets the resolution message. The ticket follows `support.resolution_post_delivery_hours` (24) as its SLA.
- **Close:** a resolution message is sent to the customer as a notification. For restaurant and captain tickets, it is sent to the restaurant or captain instead.

> In V1, real conversations with customers happen by phone or WhatsApp outside the system, and the ticket documents them. In-app chat comes in V2.
