# 9.2 Step 1: to the restaurant

> Part of the [captain app spec](../README.md) (CA). A bare "§n" here means CA §n.

- **Shown:**
  - the restaurant's name, address and location on the map, with the route
  - the ETA, and the preparation state: «قيد التحضير — جاهز بعد {د} د» or «جاهز»
  - the order number and item count
  - «تدفع للمطعم: {المبلغ}»
- **Buttons:** «ابدأ الملاحة» (§4.6) and «اتصال بالمطعم».
- **Arrival (C6):** «وصلت إلى المطعم» is enabled only within `captain.merchant_arrival_radius_m` (150) metres of the restaurant, using the latest GPS fix.
  - When the captain enters the radius, the app shows a banner, «هل وصلت إلى المطعم؟», with the button.
  - Outside the radius, the button is disabled with «اقترب من المطعم لتأكيد الوصول».
- **GPS problems (K3):** if the GPS accuracy is worse than 100 metres, the app shows «إشارة الموقع ضعيفة — اتصل بالعمليات لتسجيل وصولك». OPS can then record the arrival from the panel (AP §9.3.2).
- **Effect of arrival:** the restaurant gets «وصل الكابتن» (RA §8.9), and the captain track becomes `at_merchant`.
