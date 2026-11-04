# 14. Notifications

> Part of the [customer app spec](README.md) (CU). A bare "§n" here means CU §n.

| # | Event | Sound | Text |
|---|---|---|---|
| 1 | Restaurant accepted | Default | «المطعم يحضّر طلبك. يصل حوالي {الساعة}» |
| 2 | Captain assigned | Default | «الكابتن {الاسم} في طريقه إلى المطعم» |
| 3 | Picked up | Default | «طلبك في الطريق إليك مع {الاسم}» |
| 4 | Captain arrived | High priority (time-sensitive on iPhone) | «الكابتن عند الباب. جهّز {المبلغ}», or the recipient text (§11.7) |
| 5 | Door ping | Ring, high priority | «الكابتن عند الباب ويحاول الوصول إليك», or the recipient text (§11.7) |
| 6 | Delivered | Default | «تم التسليم. قيّم طلبك» |
| 7 | Rejected | Default | «نعتذر، لم يقبل {المطعم} طلبك: {السبب}» |
| 8 | Cancelled (no response, operations) | Default | «أُلغي طلبك: {السبب}» |
| 9 | Failed | Default | «تعذّر تسليم طلبك: {السبب}» |
| 10 | Item unavailable reported | Default | «صنف في طلبك غير متوفر. سيتصل بك فريق FOX DROP الآن» |
| 11 | Order edited | Default | «عدّلت FOX DROP طلبك. المجموع الجديد: {المبلغ}» |
| 12 | Time changed | Default | «تغيّر موعد وصول طلبك إلى {الساعة}» |
| 13 | Captain changed | Default | «تغيّر الكابتن: {الاسم} يكمل طلبك» |
| 14 | Late apology | Default | «نعتذر، طلبك متأخر قليلاً. نتابعه الآن» |
| 15 | Late code | Default | «تأخر طلبك، وهذا كود خصم لطلبك القادم: {الكود}» |
| 16 | Compensation code | Default | «لك كود تعويض {القيمة}: {الكود}» |
| 17 | Ticket resolved (problem or price report) | Default | «تم الرد على بلاغك T-{رقم}» |
| 18 | Emergency delay notice | Default | The delay notice (AP §9.1.6) |
| 19 | Service back after an emergency stop (only if OPS send it) | Default | The OPS text |
| 20 | Account blocked, unblocked or closed | Default | With the reason (§5.5) |
| 21 | Dues paid, block lifted | Default | «تم استلام {المبلغ}. حسابك فعّال من جديد» |
| 22 | Mass push (AP §9.11.4) | Default | The campaign text |

- Rows 1 to 15 open the order. Rows 16 and 21 open «أكوادي» or the account. Row 22 opens its target.
- Texts come from Content templates (AP §9.13). The texts above are the defaults.
- Every push is also stored in «الإشعارات» (§13).
