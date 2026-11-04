# 8.17 Emergency stop (AP D7)

> Part of the [restaurant app spec](../README.md) (RA). A bare "§n" here means RA §n.

- While the platform emergency stop is on, every screen shows a red banner: «المنصة متوقفة مؤقتاً عن استقبال طلبات جديدة. أكملوا الطلبات الحالية.»
- Active orders continue normally. The restaurant's own state does not change.
- When the stop ends, the banner disappears and every device chimes once.
