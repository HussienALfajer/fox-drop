# 8.1 Order statuses

> Part of AP §8, the domain reference shared by all four V1 specs ([index](README.md)). A bare "§n" here means AP §n.

| Status | Arabic label (panel) | What the customer sees | Changed by | Next statuses |
|---|---|---|---|---|
| `placed` | «بانتظار المطعم» | «بانتظار تأكيد المطعم» | System when the order is placed | `accepted`, `rejected`, `cancelled` |
| `accepted` | «قيد التحضير» | «المطعم يحضّر طلبك» | Restaurant, or OPS on its behalf | `ready`, `picked_up` (pickup confirmed before ready was pressed; `ready` is recorded at the same moment), `cancelled` |
| `ready` | «جاهز» | «طلبك جاهز» | Restaurant | `picked_up`, `cancelled`, `accepted` (only when OPS adds items, §9.3.3) |
| `picked_up` | «مع الكابتن» | «في الطريق إليك» | Pickup confirmation: the restaurant confirms the captain's pickup request, the server confirms it automatically, or OPS confirms it on the restaurant's behalf | `arrived`, `delivered` (OPS via «تحديد النتيجة»), `failed` |
| `arrived` | «الكابتن وصل» | «الكابتن عند الباب» | Captain | `delivered`, `failed`, `picked_up` (handover to another captain, §9.3.2) |
| `delivered` | «تم التسليم» | «تم التسليم» | Captain, or OPS via «تحديد النتيجة» | Final |
| `rejected` | «مرفوض» | Apology with the reason | Restaurant, or OPS on its behalf | Final |
| `cancelled` | «ملغى» | «أُلغي الطلب» with the reason | Customer (only while `placed`), OPS, or the system (no restaurant response) | Final |
| `failed` | «فشل التسليم» | «تعذّر التسليم» | OPS (after pickup) | Final |

- A finished order (`delivered` or `failed`) always has an **outcome** (§8.9).
- A `cancelled` order also records whether food had been prepared.
- **Pickup is one atomic server action, confirmed by the restaurant** (restaurant-app spec §8.10).
  1. The captain's «دفعت للمطعم واستلمت الطلب» (paid the restaurant and picked up) creates a pickup request with the payment lines. The captain track becomes `pickup_pending`.
  2. The restaurant confirms it with one tap. If it does not answer within `order.pickup_confirm_timeout_sec` (60) seconds, the server confirms it automatically. OPS MAY confirm it on the restaurant's behalf (§9.3.2).
  3. On confirmation the server posts `custody.pay_merchant` and sets `picked_up` together. There is no state where the pickup payment is booked but the order is not yet `picked_up`. If the restaurant had not pressed ready, `ready` is recorded at the same moment and flagged «لم يُضغط جاهز».
  4. From that moment the pickup payment, and the base of the commission and the restaurant's discount share, are frozen. Later changes never edit them; they post `merchant.debit`, a reversing `merchant.commission` or other entries (§9.3.3). A pickup dispute after confirmation is resolved through a ticket (§9.9.3).
- **When a pickup request is refused:** while the order has an open item-unavailable report, or an edit that added items and was not yet acknowledged.
- **While a request is open** (at most 60 seconds): edits, reassignment and the restaurant's item-unavailable report are blocked. A cancellation voids the request.
- **Payment lines:** the server proposes lines for the current pickup payment (§8.6). Lines whose converted total differs from it by more than half the largest rounding unit among their currencies are refused.
- **Cash handed over without a pickup.** The captain pays before tapping, so cash can change hands without a confirmed pickup. This covers a rejected or voided request, or a cancellation or reassignment after the captain reached the restaurant, even before any request.
  - The restaurant and the captain settle any difference in person before the captain sends a new request for the current amount. A captain who paid more and did not get the difference back opens a pickup-dispute ticket (§9.9.1).
  - When OPS cancels the order or reassigns the captain after the captain track reached `at_merchant`, the dialog asks «هل أعاد المطعم المبلغ للكابتن؟» (did the restaurant return the cash?), with «لم يدفع الكابتن بعد» (the captain had not paid yet) as an answer.
  - If not, the server posts `custody.pay_merchant` on that captain with the lines the restaurant received, and a `merchant.debit` of the same base amount, so the restaurant returns it on Saturday. The other money effects of the cancellation (§8.9) apply as usual.
- Each order snapshots the restaurant's `commission_pct`, the exchange rates (§8.6) and the captain pay table version when it is placed. Later changes to these never affect existing orders.
