# 8.7 Preparing

> Part of the [restaurant app spec](../README.md) (RA). A bare "§n" here means RA §n.

- A countdown runs from acceptance to the end of the chosen prep time.
- **At zero:** the card turns red and counts up, «متأخر {د} د». Every device plays a chime with «تحضير متأخر #{رقم} — اضغط «الطلب جاهز» فور الانتهاء». The chime repeats every 5 minutes (fixed) until the order is ready (S16).
- Operations are alerted `order.prep_late_ops_alert_min` (10) minutes after the prep time (AP §8.3).
- **No extension (R7):** the restaurant cannot change the prep time. The card shows a link, «تحتاج وقتاً أطول؟ اتصل بالعمليات», which calls operations.
- **Time changed by operations** (AP §9.3.2 «تعديل الوقت»): the countdown updates and every device chimes with «عدّلت العمليات وقت تحضير #{رقم} إلى {د} د».
