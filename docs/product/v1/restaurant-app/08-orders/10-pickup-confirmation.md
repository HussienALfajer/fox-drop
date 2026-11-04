# 8.10 Pickup confirmation (R4)

> Part of the [restaurant app spec](../README.md) (RA). A bare "§n" here means RA §n.

**Flow:**

1. The captain arrives (`at_merchant`), checks the items against the list in the captain app, and pays the full items value in cash. They pay in the base currency, or in the currencies the restaurant accepts (§12.7).
2. The captain taps «دفعت للمطعم واستلمت الطلب» and records the currency lines they paid. The server creates a pickup request with those lines, and the captain track becomes `pickup_pending`. The amount on the request is always the order's current pickup payment, set by the server; the captain only chooses the currency lines (§12.7).
3. Every receiving device rings with the pickup prompt:
   - «الكابتن {الاسم} يؤكد أنه دفع لك {المبلغ} واستلم الطلب #{رقم}»
   - the captain's photo
   - the payment lines, for example «400 ₺» or «5 $ + 195 ₺», with the base-currency equivalent
   - two buttons: «تأكيد الاستلام» (confirm pickup) and «المبلغ غير صحيح» (amount incorrect)
   - a text link under them, «الطلب غير مكتمل» (order not complete) (S17)
   - a countdown: «يُؤكَّد تلقائياً خلال {ث} ث»

   Owner devices with ringing off show the same prompt silently.
4. **Confirm:** the server performs the pickup as one atomic action (AP §8.1): it posts `custody.pay_merchant` with the payment lines and sets the order to `picked_up`. If the restaurant had not pressed ready, `ready` is recorded at the same moment and flagged «لم يُضغط جاهز» (S8). Both apps show «تم الاستلام» at once, and the captain may leave.
5. **No answer:** after `order.pickup_confirm_timeout_sec` (60) seconds without an answer, the server confirms the pickup automatically. The timeline records «تأكيد تلقائي» (automatic confirmation).
6. **Dispute before confirmation:**
   1. The user taps «المبلغ غير صحيح» and enters what the restaurant actually received, as currency lines prefilled with the captain's lines.
   2. The request is rejected, and the order stays in its status.
   3. The captain sees «المطعم يفيد بأنه استلم {المبلغ}. أكمل المبلغ ثم أعد التأكيد.»
   4. Operations get the critical alert «خلاف على مبلغ الاستلام» (AP §9.1.3). It resolves itself when the pickup completes or the order is cancelled.
   5. The captain pays the difference and sends a new request.
   6. If they cannot agree, operations call both. They MAY confirm the pickup on the restaurant's behalf with the agreed payment lines and a reason (S9, AP §9.3.2). Or they MAY reassign or cancel the order, which asks the cash question below.
7. **Order not complete:** «الطلب غير مكتمل» rejects the request like a dispute, but without amounts and without the operations alert. The captain sees «المطعم يفيد بأن الطلب غير مكتمل». The restaurant can then report an item unavailable (§8.12).
8. **Dispute after confirmation:** after any confirmation (by the restaurant, automatic, or by operations), «المبلغ غير صحيح» stays on the order for `order.pickup_dispute_window_min` (10) minutes.
   - Using it asks for the currency lines actually received. It opens a ticket «خلاف على دفعة الاستلام», always urgent and linked to the order.
   - The order continues normally.
   - Operations or finance resolve the ticket per AP §9.9.3 (S10):
     - the captain pays the difference later, with no entries
     - or the difference is corrected in the accounts: `custody.pickup_correction` per currency on the captain, and a `merchant.credit` (or `merchant.debit`) to the restaurant
     - or the claim is rejected
   - The owner sees any resulting credit or debit in the account (§12.5).

**Rules:**

- A pickup request is possible only when:
  - the order is `accepted` or `ready`
  - the captain is the assigned captain and is at the restaurant
  - there is no open item-unavailable report (§8.12)
  - there is no unacknowledged edit that added items (§8.13)
- An order has one open pickup request at a time.
- **Payment lines:** the server proposes lines for the current pickup payment (§12.7). The captain may change the split. The server refuses lines whose converted total differs from the pickup payment by more than half the largest rounding unit among their currencies (AP §8.1).
- **While a request is open** (at most 60 seconds): the restaurant app hides «صنف غير متوفر — اتصلوا بالزبون», and operations cannot edit the order or reassign the captain (S19). Operations can still cancel; the cancellation voids the request, and the prompt closes with the reason.
- **Cash already handed over:** the captain pays before tapping, so cash may already have changed hands when a request is rejected or voided (AP §8.1).
  - The restaurant and the captain settle any difference in person before the captain sends a new request for the current amount.
  - If operations cancel the order or reassign the captain after the captain arrived at the restaurant, their dialog asks whether the restaurant returned the cash to the captain (AP §8.1).
  - If it did not, the server posts the payment on that captain's custody and a `merchant.debit` of the same amount. The restaurant then returns the cash in the Saturday settlement (§12.5).
- **Several devices:** the first answer wins. The prompt closes on the other devices with «أكّد {اسم المستخدم} الاستلام» or «أبلغ {اسم المستخدم} أن المبلغ غير صحيح».
- If every device of the restaurant is offline, the automatic confirmation after 60 seconds still applies. The restaurant can still dispute within the 10-minute window once it is back online.
