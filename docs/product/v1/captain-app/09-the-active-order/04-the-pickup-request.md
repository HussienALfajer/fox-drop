# 9.4 The pickup request (RA §8.10)

> Part of the [captain app spec](../README.md) (CA). A bare "§n" here means CA §n.

1. The captain pays the restaurant the amount shown, in the proposed lines or their own split (§10.5).
2. They tap «دفعت للمطعم واستلمت الطلب».
   - The server checks the payment lines. Lines whose converted total differs from the pickup payment by more than half the largest rounding unit among their currencies are refused with «المبلغ لا يطابق المطلوب» (AP §8.1).
   - The captain track becomes `pickup_pending`.
3. The screen shows «بانتظار تأكيد المطعم» with a 60-second countdown (`order.pickup_confirm_timeout_sec`).
4. **Results:**

   | Restaurant answer                           | Captain sees                                                   | Next                                                        |
   | ------------------------------------------- | -------------------------------------------------------------- | ----------------------------------------------------------- |
   | Confirmed, or no answer within 60 s         | «تم الاستلام»                                                  | Step 3. The pickup payment is now in custody (AP §8.1).     |
   | Confirmed by OPS on the restaurant's behalf | «أكّدت العمليات الاستلام»                                      | Step 3                                                      |
   | «المبلغ غير صحيح»                           | «المطعم يفيد بأنه استلم {المبلغ}. أكمل المبلغ ثم أعد التأكيد.» | Pay the difference, then tap again with the corrected lines |
   | «الطلب غير مكتمل»                           | «المطعم يفيد بأن الطلب غير مكتمل. راجع الأصناف معه.»           | Recheck the items, then tap again                           |

5. **Cancelled while waiting:** the request is voided. Reassignment and edits are blocked while a request is open (AP §8.1). The screen tells the captain whether to take the cash back from the restaurant, as operations recorded it.
6. **Cash and the restaurant disagree:** if the captain paid more than the pickup payment and the restaurant does not return the difference, the captain uses «مشكلة» → «مشكلة في مبلغ الاستلام». This opens the same pickup-dispute ticket the restaurant can open, resolved per AP §9.9.3.

**After pickup:** if the restaurant disputes the amount within 10 minutes (RA §8.10, step 8), the captain is notified, «فتح المطعم بلاغاً عن مبلغ الاستلام — ستتواصل معك العمليات». The order continues normally.
