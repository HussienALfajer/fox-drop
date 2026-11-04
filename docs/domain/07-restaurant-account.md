# 8.7 Restaurant account «حساب المطعم» (D13, D26)

> Part of AP §8, the domain reference shared by all four V1 specs ([index](README.md)). A bare "§n" here means AP §n.

The restaurant receives the full items value in cash at pickup, so during the week it accumulates what it owes the platform: commission, plus its share of any discounts it funded. The account also records exceptions in both directions. The balance is normally negative, meaning the restaurant owes the platform, and the restaurant pays it every Saturday.

| Entry | Sign (from the restaurant's view) | When |
|---|---|---|
| `merchant.commission` | − (restaurant owes) | When an order finishes (delivered, or failed after pickup), unless the restaurant is the responsible party for a non-normal outcome (§8.9). A reversing entry (+) is posted when items are removed with the restaurant responsible (§9.3.3, §8.10). Never posted on test orders (§9.6.3). |
| `merchant.discount_share` | − (restaurant owes) | Same moment and same exceptions as the commission: the restaurant-funded part of a discount, because the captain paid the full items value |
| `merchant.credit` | + (platform owes) | The order was cancelled after the food was prepared and the restaurant was not responsible: the platform credits the merchant net (§8.9). Also a pickup dispute resolved in the accounts where the captain paid the restaurant less than the pickup payment (§9.9.3). |
| `merchant.debit` | − (restaurant owes) | The restaurant is responsible: it returns the full pickup payment for a failed or refused order (§8.9), the value of items removed after pickup (§9.3.3), or the value of items affected by a post-delivery problem (§8.10). Also a pickup dispute resolved in the accounts where the captain paid the restaurant more than the pickup payment (§9.9.3). |
| `merchant.settlement` | ± | The Saturday settlement: the restaurant pays the platform, or the platform pays the restaurant if the balance is positive (receipt) |
| `merchant.adjustment` | ± | Manual correction (OWN/FIN, reason) |

- **Settlement day:** `merchant.settlement_weekday` (Saturday, a business day, §4.3).
- **Statement cutoff:** the weekly statement closes at the business-day cutoff that starts the settlement day (Saturday 06:00 by default). It covers every entry since the previous statement closed. Entries posted after the cutoff, such as orders finished on Saturday, go to next week's statement.
- **Amount due** = the statement total + any unpaid balance from earlier statements.
- **Settlement method:** «في المكتب» (at the office) or «زيارة ميدانية» (field visit), recording the staff member who visited. Payment can be in any accepted currency, converted at the current rate. Payments can be recorded on any day, and partial payments are allowed.
- **Weekly statement:** generated at the cutoff and visible in the restaurant app. It lists:
  - each order: items value received from the captain, commission, restaurant-funded discount
  - exceptions (credits and debits) with the order number and reason
  - the earlier unpaid balance and the total due
- **Receipt:** each settlement gets a receipt, which appears in the restaurant app.
- **Overdue:** if a restaurant has not settled `merchant.settlement_overdue_days` (2) days after Saturday, OWN and FIN get a warning, «مطعم متأخر في التسوية». The panel does not pause the restaurant automatically. OWN decides what to do (§13).
