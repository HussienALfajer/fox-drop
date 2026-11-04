# 9.1 Steps

> Part of the [captain app spec](../README.md) (CA). A bare "§n" here means CA §n.

The active order is four steps. Each step has one main button.

| Step | Captain track (AP §8.2) | Main button |
|---|---|---|
| 1. To the restaurant | `assigned` | «وصلت إلى المطعم» |
| 2. At the restaurant | `at_merchant` → `pickup_pending` | «دفعت للمطعم واستلمت الطلب» |
| 3. To the customer | `picked_up` | «وصلت» |
| 4. At the customer | `at_customer` | «تم التسليم» |

A progress bar at the top shows the four steps. The «مشكلة» (problem) menu and «طوارئ» are on every step (§9.11).
