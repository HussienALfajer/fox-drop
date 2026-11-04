# 8.2 Captain track

> Part of AP §8, the domain reference shared by all four V1 specs ([index](README.md)). A bare "§n" here means AP §n.

The captain track is recorded separately from the order status:

`searching` «بحث» → `offered` «عرض» → `assigned` «معيّن» → `at_merchant` «عند المطعم» → `pickup_pending` «بانتظار تأكيد المطعم» → `picked_up` «استلم» → `at_customer` «عند الزبون» → `done` «انتهى»

A rejected or voided pickup request returns the track from `pickup_pending` to `at_merchant`.

"Ready" and "assigned" can happen in either order.
