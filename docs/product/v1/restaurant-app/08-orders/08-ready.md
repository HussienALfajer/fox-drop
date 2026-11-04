# 8.8 Ready

> Part of the [restaurant app spec](../README.md) (RA). A bare "§n" here means RA §n.

- «الطلب جاهز» is available while the order is `accepted`. Pressing it early is allowed.
- A help link, «لماذا أضغط «الطلب جاهز»؟», explains: the captain is told at once, the customer sees «طلبك جاهز», and pressing it on time keeps the restaurant's late rate low.
- **Effect:** the order becomes `ready`. The assigned captain gets «الطلب جاهز». If no captain is assigned yet, the card shows «بانتظار كابتن», and operations' no-captain-after-ready timer starts (AP §8.3).
- There is no undo (fixed). A user who pressed it by mistake calls operations.
- If operations add items to a `ready` order, it goes back to «قيد التحضير» with the extra time they entered (§8.13).
