# 9.9 The customer does not answer (AP §8.3)

> Part of the [captain app spec](../README.md) (CA). A bare "§n" here means CA §n.

1. After arrival, the captain calls the customer from the order screen.
2. **Pings:** «تنبيه الزبون» sends an alert to the customer's app, which rings (customer-app spec §11.7). It can be used `customer.no_answer_pings` (3) times, at least `customer.no_answer_ping_interval_min` (5) minutes apart. The screen shows the next allowed time.
   - If the customer answers «أنا قادم», the captain hears a chime and sees «الزبون رأى التنبيه وهو قادم». For an order with a recipient, the answer is «سأتصل بالمستلم», and the captain sees «الزبون يتواصل مع المستلم». The 15-minute rule still runs.
3. **After 15 minutes and three pings:** the button «الزبون لا يستجيب» appears. Pressing it tells OPS (AP §9.1.3, «زبون لا يرد») and shows «العمليات تراجع الطلب — انتظر تعليماتهم».
4. **OPS decide:**
   - «انتظر» (wait), with a message
   - or end the order with an outcome: `fake` or `failed_other` (AP §8.9)

   The captain sees the result and the food instruction (§9.12).
5. **The customer appears in the meantime:** the captain continues with payment and delivery as normal.
