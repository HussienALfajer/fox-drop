# 9.3 Step 2: at the restaurant

> Part of the [captain app spec](../README.md) (CA). A bare "§n" here means CA §n.

- **Waiting:** a timer counts from arrival. Waiting pay follows AP §8.4: if the pay table includes it, it counts from the later of the arrival and the moment the food was due, after the first `captain.waiting_threshold_min` (10) minutes. When it starts, the screen shows «بدأ احتساب أجر الانتظار». OPS and the restaurant are alerted at the threshold (AP §9.1.3, RA §8.9).
- **Ready:** when the restaurant presses «الطلب جاهز», the captain gets a chime and «الطلب جاهز».
- **Item check (C7):**
  - The screen lists every item with its quantity, options and notes, each with a tick box.
  - The payment section appears only when every box is ticked.
  - A line above the list says «بعد تأكيد الأصناف يصبح أي نقص من مسؤوليتك» (after you confirm the items, any shortage is your responsibility).
  - If something is missing or wrong, the captain uses «مشكلة» → «صنف ناقص» (§9.11) and does not pay until it is sorted.
- **Payment (§9.4):** «ادفع للمطعم: {المبلغ}» with the proposed payment lines.
- **The restaurant reports an item unavailable** (RA §8.12): the screen shows «بانتظار تعديل الطلب من العمليات» and the pickup is blocked until operations edit, cancel or close the report.
- **The restaurant has not acknowledged an edit that added items:** the screen shows «بانتظار تأكيد المطعم للتعديل» and the pickup is blocked (RA §8.13).
