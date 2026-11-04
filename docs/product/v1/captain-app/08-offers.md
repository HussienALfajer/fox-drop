# 8. Offers

> Part of the [captain app spec](README.md) (CA). A bare "§n" here means CA §n.

## 8.1 When offers come

- The server sends offers only to eligible captains (AP §9.12.6):
  - online, active and with no active order
  - custody under the cash limit, and not blocked for unhanded cash
  - within the search radius of the restaurant
  - a vehicle allowed for the trip distance
  - and now also: a pickup payment not above the captain's «أقصى مبلغ أحمله», when set (C4). The capacity check at order placement ignores this condition, so a large order is never refused only because of it (AP §9.12.6).
- **Timing:** an order is offered once the restaurant has accepted it and the search-start moment has come (AP §8.3), so the captain arrives about when the food is ready.
- **One at a time:** one offer per captain at a time, for `dispatch.offer_timeout_sec` (45) seconds.

## 8.2 The offer screen (C2)

A full-screen sheet with the offer sound (§4.4) and a countdown ring.

| Item | Example |
|---|---|
| The captain's pay for this order (largest text) | «35 ₺» |
| Restaurant and distance from the captain | «مطعم الشام · 1.2 كم» |
| Customer neighbourhood and trip distance (restaurant to customer) | «حي الشهداء · 2.8 كم» |
| Pay to the restaurant at pickup | «تدفع للمطعم: 400 ₺» |
| Collect from the customer | «تقبض من الزبون: 410 ₺» |
| Preparation state | «قيد التحضير — جاهز بعد 8 د تقريباً» or «جاهز» |
| Peak bonus, when one applies | «يشمل مكافأة الذروة +5 ₺» |
| Map | The restaurant and the customer's neighbourhood, without the exact pin |

- **Pay estimate:** the pay shown is the order pay from the pay table (AP §8.4), plus the peak bonus if it would apply now. Waiting pay is added later, if any. The offer says «قد يُضاف أجر انتظار».
- **Hidden until acceptance:** the customer's name, phone and exact address (C2).

## 8.3 Accept, reject, expire

- **«قبول»** (accept, a large button): the order becomes the captain's active order (§9). The server checks that the offer is still valid; if another action took the order, the app says «لم يعد العرض متاحاً».
- **«رفض»** (reject): no reason is needed. It counts in the acceptance rate (§11.1).
- **Expired:** the sheet closes with «انتهى العرض». It counts in the acceptance rate and toward C3 (§7.4).
- **Logging:** every offer and response is logged with its time (AP §9.7.4).

## 8.4 Manual assignment

- With `dispatch.manual_assign_requires_accept` (true), a manual assignment from OPS arrives as a normal offer, marked «تعيين من العمليات» (AP §9.3.2).
- **Override (K2):** OPS MAY send a manual offer to a captain whose «أقصى مبلغ أحمله» is below the pickup payment. The offer then says «المبلغ أكبر من الحد الذي حددته — اقبل فقط إذا كان معك ما يكفي».
- If the setting is false, a manual assignment becomes the active order directly, with a chime and «عيّنتك العمليات على طلب».
