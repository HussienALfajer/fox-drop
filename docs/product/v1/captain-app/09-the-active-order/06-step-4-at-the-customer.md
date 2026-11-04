# 9.6 Step 4: at the customer

> Part of the [captain app spec](../README.md) (CA). A bare "§n" here means CA §n.

- **Arrival (K4):** «وصلت» is enabled within `captain.customer_radius_m` (200) metres of the customer's pin.
  - The app suggests it when the captain enters the radius.
  - Farther away, the button asks for a reason first (Appendix C): «الزبون طلب مكاناً آخر», «موقع الزبون على الخريطة غير دقيق», «أخرى» (with text). The reason is recorded and also covers delivery.
- **Effect of arrival:** the customer gets «الكابتن عند الباب», and the track becomes `at_customer`.
- **Next:** the payment screen (§9.7), then «تم التسليم» (§9.8).
- **The customer does not answer:** §9.9.
