# 8.11 Platform accounts

> Part of AP §8, the domain reference shared by all four V1 specs ([index](README.md)). A bare "§n" here means AP §n.

The platform's own side of every entry is booked to one of these accounts, which feed the finance reports (§9.10):

| Account | Arabic | Receives |
|---|---|---|
| `platform.revenue_commission` | «عمولات» | Commission entries |
| `platform.revenue_delivery` | «رسوم التوصيل» | Delivery fees |
| `platform.discount_cost` | «كلفة الخصومات» | Platform-funded discounts on orders |
| `platform.compensation_cost` | «كلفة التعويضات» | Compensation codes when used, automatic late codes, free re-deliveries borne by the platform |
| `platform.operating_cost` | «كلفة تشغيلية» | Losses and captain pay borne by the platform under §8.9, captain cancellation compensation, shortfalls borne by the platform |
| `platform.captain_pay` | «أجور الكباتن» | All captain earnings entries except charges |
| `platform.fx_rounding` | «فروقات التقريب والصرف» | Rounding adjustments and FX conversion differences |
| `platform.test_cost` | «كلفة الطلبات التجريبية» | Captain pay and losses on test orders (§9.6.3) |
