# 8.14 Cancellation

> Part of the [restaurant app spec](../README.md) (RA). A bare "§n" here means RA §n.

- **Cancelled after acceptance** (by operations, AP §9.3.2): a prompt rings on every device until acknowledged with «حسناً»: «أوقف التحضير — أُلغي الطلب #{رقم}: {السبب}». The card moves to history as «ملغى».
- **Food already prepared:** operations record whether food was prepared and who is responsible (AP §8.9). If food was prepared and the restaurant is not responsible, the merchant net is credited. Owners see it in the account as «تعويض عن طلب أُلغي بعد التحضير».
- **Customer cancels while `placed`:** §8.3.
