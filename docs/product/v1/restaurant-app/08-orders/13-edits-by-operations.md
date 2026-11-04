# 8.13 Edits by operations (AP §9.3.3)

> Part of the [restaurant app spec](../README.md) (RA). A bare "§n" here means RA §n.

- **Before pickup:** every edit opens a prompt on every device listing the changes:
  - items added, removed or changed in quantity
  - options changed
  - the new items value, and for owners the new net amount
- The user taps «اطلعت على التعديل» (I have seen the edit).
  - An edit that adds items rings until it is acknowledged, and blocks pickup requests until then (§8.10). If it is not acknowledged within `order.merchant_accept_alert_min` (3) minutes, operations get «المطعم لم يؤكد التعديل» (AP §9.1.3). They call the restaurant and MAY confirm the pickup on its behalf once it has seen the edit.
  - Any other edit chimes once and stays on the card until acknowledged. It does not block pickup.
- Operations cannot edit while a pickup request is open (§8.10). After an edit, any cash difference is settled in person, and the captain's next request carries the new amount.
- **Ready orders:** adding items to a `ready` order moves it back to «قيد التحضير» with the extra prep time operations entered.
- **After pickup:** operations may remove items with a responsible party (AP §9.3.3). When the restaurant is responsible, owners get a silent push with the amount to be returned on Saturday (§12.5).
