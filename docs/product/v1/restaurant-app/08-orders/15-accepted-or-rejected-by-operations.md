# 8.15 Accepted or rejected by operations

> Part of the [restaurant app spec](../README.md) (RA). A bare "§n" here means RA §n.

- **Accepted on the restaurant's behalf:** the ring stops, and every device chimes with «قبلت العمليات الطلب #{رقم} نيابة عنكم — وقت التحضير {د} د». The card moves to «قيد التحضير» with the badge «قبلته العمليات».
- **Rejected on the restaurant's behalf:** the ring stops, and every device chimes with «رفضت العمليات الطلب #{رقم}: {السبب}».
- Reports count these separately from the restaurant's own decisions (§11).
