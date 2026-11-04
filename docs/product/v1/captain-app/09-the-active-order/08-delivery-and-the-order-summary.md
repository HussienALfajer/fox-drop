# 9.8 Delivery and the order summary

> Part of the [captain app spec](../README.md) (CA). A bare "§n" here means CA §n.

- **Where «تم التسليم» is accepted (C9):** within `captain.customer_radius_m` (200) metres of the pin. Farther away, the captain chooses a reason, unless they already gave one at arrival (K4). Operations get the information alert «تسليم بعيد عن العنوان» (AP §9.1.3).
- **Effect:**
  - the order becomes `delivered` (AP §8.1)
  - the server posts `custody.collect` and `custody.change_given` from the payment lines, and the captain's `earn.order_pay` (and any waiting pay or peak bonus)
  - the customer gets «تم التسليم»
- **Summary sheet:**
  - «ربحت من هذا الطلب: {الأجر}», split into base, distance, «إكمال للحد الأدنى» (top-up to the minimum pay, when `min_pay` applies, AP §8.4), waiting and peak
  - «تغيّرت عهدتك: {+المبلغ}» (custody change), and «عليك تسليم اليوم: {المجموع}»
  - a button to go back online, or «إنهاء العمل» (go offline)
- **After delivery:** the captain is «متصل متاح» again at once, unless last-order mode or a block applies, and can receive the next offer while the summary is open. «إنهاء العمل» on the summary goes offline.
- **Last-order mode:** the captain goes offline after the summary (§7.3). Last-order mode applies however the order leaves the captain: delivered, failed, withdrawn, handed over or cancelled.
