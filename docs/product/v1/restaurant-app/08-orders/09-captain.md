# 8.9 Captain

> Part of the [restaurant app spec](../README.md) (RA). A bare "§n" here means RA §n.

- **Captain block on the card and detail:** photo, first name, vehicle, the captain line (§8.1), the ETA to the restaurant, and after arrival «وصل الكابتن» with a waiting timer.
- **Calling the captain (R17):**
  - The button «اتصال بالكابتن» shows from assignment until the order is delivered, failed or cancelled.
  - On Android it opens the dialer with the captain's number. On Windows it shows the number in a dialog.
  - The app does not display the number anywhere else. Every call is recorded in the order timeline.
- **Captain arrived:** every device chimes with «وصل الكابتن {الاسم} لاستلام الطلب #{رقم}». The captain can confirm arrival only within 150 metres of the restaurant, or operations record it when GPS fails (captain-app spec §9.2).
- **Captain waiting:** when the captain has waited `captain.waiting_threshold_min` (10) minutes and the order is not picked up, every device chimes with «الكابتن ينتظر الطلب #{رقم} منذ {د} دقائق». Operations get their warning at the same moment (AP §9.1.3).
- **Captain changed:** when operations reassign the order, every device chimes with «تغيّر كابتن الطلب #{رقم}: {الاسم}».
