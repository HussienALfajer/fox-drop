# 8.11 Platform accounts

> Part of AP §8, the domain reference shared by all four V1 specs ([index](README.md)). A bare "§n" here means AP §n.

The platform's own side of every entry is booked to one of these accounts, which feed the finance reports (§9.10):

| Account                       | Arabic                   | Receives                                                                                                                     |
| ----------------------------- | ------------------------ | ---------------------------------------------------------------------------------------------------------------------------- |
| `platform.revenue_commission` | «عمولات»                 | Commission entries                                                                                                           |
| `platform.revenue_delivery`   | «رسوم التوصيل»           | Delivery fees                                                                                                                |
| `platform.discount_cost`      | «كلفة الخصومات»          | Platform-funded discounts on orders                                                                                          |
| `platform.compensation_cost`  | «كلفة التعويضات»         | Compensation codes when used, automatic late codes, free re-deliveries borne by the platform                                 |
| `platform.operating_cost`     | «كلفة تشغيلية»           | Losses and captain pay borne by the platform under §8.9, captain cancellation compensation, shortfalls borne by the platform |
| `platform.captain_pay`        | «أجور الكباتن»           | All captain earnings entries except charges                                                                                  |
| `platform.fx_rounding`        | «فروقات التقريب والصرف»  | Rounding adjustments and FX conversion differences                                                                           |
| `platform.test_cost`          | «كلفة الطلبات التجريبية» | Captain pay and losses on test orders (§9.6.3)                                                                               |
| `platform.order_clearing`     | «طلبات قيد التسليم»      | The items value paid to restaurants and not yet settled by the order's other entries; each order's part returns to zero      |
| `platform.adjustments`        | «القيود التصحيحية»       | The platform's side of every manual correction (§9.10.7)                                                                     |
| `platform.cash`               | «نقد الصندوق»            | The cash in each cash-desk drawer, per currency (§9.10.3)                                                                    |

Owner decisions 2026-11-05: an order's cash and exceptions (pickup payment, collection, change, pickup corrections, restaurant discount share, credits, debits, captain charges, and the order's fee, discount, compensation, loss and rounding entries) are booked against `platform.order_clearing`, and every manual correction against `platform.adjustments`. On an order that ends after pickup with an outcome other than `normal`, the commission is booked against `platform.order_clearing` too, not `platform.revenue_commission`: it recovers part of the pickup payment, so the loss is the merchant net (§8.9 rule 3). Each entry type's counter-account is listed in `apps/server/src/modules/ledger/CLAUDE.md`.
