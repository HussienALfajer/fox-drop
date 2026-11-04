# 8.6 Reject

> Part of the [restaurant app spec](../README.md) (RA). A bare "§n" here means RA §n.

- Rejecting is possible only while the order is `placed`. After acceptance the restaurant cannot reject or cancel; it uses §8.12 or calls operations.
- A reason is required, one of three (R3, Appendix C):

| Reason | Arabic | Extra step | Side effect |
|---|---|---|---|
| Item unavailable | «صنف غير متوفر» | Pick one or more items from the order (required), and for each «حتى الغد» (default) or «حتى أعيده» | Those items become unavailable immediately (§9.3) |
| Restaurant closed | «المطعم مغلق» | None. The dialog says: «سيتوقف مطعمك عن استقبال الطلبات حتى تعيد الفتح» | The restaurant is paused «حتى أعيد الفتح» (S2, §7.1). This happens only while the restaurant is open or busy, and no operations pause or auto-pause is active. |
| Too many orders | «ضغط طلبات» | Optional: «تفعيل وضع الضغط» or «إيقاف 30 د» | Only what the user picks |

- **Effect:** the order becomes `rejected`. The customer sees the customer-facing reason and similar restaurants (customer-app spec §11.9). The rejection counts in the restaurant's rejection rate (§11).
