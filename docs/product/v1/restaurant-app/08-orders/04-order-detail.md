# 8.4 Order detail

> Part of the [restaurant app spec](../README.md) (RA). A bare "§n" here means RA §n.

- **Header:** order number, the time it was placed, status, the running timer and badges.
- **Customer:** first name and neighbourhood, the customer's note, and the preset notes they picked. Never the phone number, the last name or the full address (principle 6).
- **Items:** quantity × name; options as «{المجموعة}: {الاختيار}»; add-ons; the item note; the line price. Items added by operations are marked «أضافته العمليات». Items removed by operations are struck through, marked «حذفته العمليات».
- **Money** (§12.1):
  - Everyone: «قيمة الأصناف — يدفعها لك الكابتن نقداً عند الاستلام: {المبلغ}». If the restaurant accepts other pickup currencies (§12.7), the equivalents are shown under it.
  - Owners only:
    - «العمولة {النسبة}% — تُسدَّد يوم السبت: {المبلغ}»
    - «خصم يموّله المطعم: {المبلغ}», only when there is one. A restaurant-funded free-delivery code shows as «خصم توصيل يموّله المطعم: {المبلغ}». This is the only delivery amount the restaurant sees, because it pays it (S18).
    - «صافيك من الطلب: {المبلغ}»
  - Test orders show «طلب تجريبي — لا عمولة» instead of the commission lines.
  - The delivery fee and the customer total are never shown (R11).
- **Captain:** §8.9.
- **Badges:**
  - «طلب تجريبي» (test order)
  - «قبلته العمليات» (accepted by operations)
  - «معدّل» (edited)
  - «صنف نفد — بانتظار العمليات» (item unavailable, waiting for operations)
  - «متأخر» (late)
- **Timeline (short):** placed; accepted (user and device, or operations); ready; captain arrived; pickup requested; pickup confirmed (user and device, automatically, or by operations); delivered or ended; edits and cancellations with their reasons.
- **Actions:** by state and role, as in §18.
