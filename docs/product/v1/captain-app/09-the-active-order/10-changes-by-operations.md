# 9.10 Changes by operations

> Part of the [captain app spec](../README.md) (CA). A bare "§n" here means CA §n.

| Change | What the captain sees |
|---|---|
| Edit before pickup | A chime and the change list: «تم تعديل الطلب — المبلغ الجديد للمطعم {المبلغ}، للتحصيل {المبلغ}». The item checklist updates. If cash was already paid, the captain settles the difference with the restaurant in person (AP §8.1). |
| Items removed after pickup | «حُذفت أصناف من الطلب — المبلغ الجديد للتحصيل {المبلغ}». The captain does not deliver those items. |
| Lower delivery fee after pickup | The new amount to collect |
| Prep or promised time changed | The new times |
| Withdrawn before pickup (reassignment) | The cancellation sound and «سُحب منك الطلب: {السبب}». If the captain had already arrived at the restaurant, also whether to take the cash back from it (AP §8.1). The order leaves the app. |
| Handed over after pickup (emergency) | §9.10.1 |
| Cancelled | The cancellation sound and «أُلغيت المهمة: {السبب}». If the captain had already arrived at the restaurant, also whether to take the cash back from it (AP §8.1). If OPS compensated the captain for arriving at the restaurant, the summary shows «تعويض: {المبلغ}» (AP §8.9). |
| Outcome set with the captain responsible | The charge appears in earnings with the reason (§10.6) |
| Outcome set by OPS with an amount to collect (K9) | «أنهت العمليات الطلب: {النتيجة}. اقبض {المبلغ}.» The payment screen (§9.7) opens for that amount. The order stays active, with the badge «بانتظار تسجيل التحصيل», and the captain stays busy until they record the lines. The server then posts the outcome from the recorded net. A gap below the amount beyond rounding follows the shortfall flow (K16, AP §8.6). If the amount is 0, the order ends at once. |

After a withdrawal, a handover or a cancellation, the captain's next state follows K17.

## 9.10.1 Handover to another captain (AP §9.3.2)

OPS can hand an order over in `picked_up` or `arrived`, for example after an accident or a breakdown.

- **First captain:**
  - They see «سيستلم الكابتن {الاسم} الطلب منك. انتظره في موقعك.» with the second captain's live position and a call button.
  - The pickup payment stays in their custody, and the desk reimburses it (AP §9.3.2).
  - When the second captain confirms, the order leaves the first captain's app with «سلّمت الطلب للكابتن {الاسم}». Their track becomes `done`, and they go offline (K17).
- **Second captain:**
  - They get a handover offer (or assignment) marked «استلام من كابتن». It shows «لا تدفع شيئاً» instead of the pickup payment, the amount to collect, the first captain's location, and the customer's neighbourhood.
  - C4 does not apply, because they pay nothing.
  - Step 1 leads to the first captain's live location. Its button is «استلمت الطلب من الكابتن {الاسم}», enabled within `captain.customer_radius_m` (200) m of the first captain.
  - Confirming sets their track to `picked_up` (the order status returns to `picked_up` if it was `arrived`). They continue with steps 3 and 4.
  - They collect at the door, so the collection goes to their custody, and they earn the order pay (AP §9.3.2).
