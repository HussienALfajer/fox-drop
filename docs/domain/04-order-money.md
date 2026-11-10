# 8.4 Order money

> Part of AP §8, the domain reference shared by all four V1 specs ([index](README.md)). A bare "§n" here means AP §n.

All amounts are in the city's base currency. Each order stores every component and the exchange-rate snapshot taken when it was placed.

```
customer_total      = items_value + delivery_fee − discount_total + rounding_adjustment
pickup_payment      = items_value                  // the captain pays the restaurant in full (D26)
custody_delta       = customer_total − pickup_payment   // cash the captain hands in for this order
commission          = commission_pct × (items_value − merchant_funded_item_discount)
merchant_weekly_due = commission + merchant_funded_discount   // the restaurant pays this on Saturday
merchant_net        = items_value − commission − merchant_funded_discount   // what the restaurant keeps

order_pay           = max(min_pay, base_pay + extra_km × per_km_rate)     // earn.order_pay
waiting_pay         = waiting_minutes_after_threshold × waiting_rate       // earn.waiting_pay
peak_bonus          = window_amount if delivered inside an active window   // earn.peak_bonus
captain_pay         = order_pay + waiting_pay + peak_bonus

platform_margin     = commission + delivery_fee − platform_funded_discount
                      − captain_pay + rounding_adjustment
```

- `discount_total` = `platform_funded_discount` + `merchant_funded_discount`. A shared code splits by the code's funding ratio.
- **Discount caps:** a percentage or fixed-amount code discounts the items value and is capped at it. A free-delivery code discounts the delivery fee and is capped at it. So `customer_total` is never below 0. The unused part of a fixed-amount code is lost, and the customer app says so before confirming (customer-app spec §10.4).
- `merchant_funded_discount` = `merchant_funded_item_discount` (a discount on items) + `merchant_funded_delivery_discount` (a free- or reduced-delivery code funded by the restaurant).
- **The captain never deducts anything at pickup.** They pay exactly the items value shown on the order. Commission and the restaurant's share of any discount go to the restaurant account (§8.7) and are collected on Saturday.
- Commission is calculated on the items value after restaurant-funded **item** discounts and before platform-funded discounts. A restaurant-funded delivery discount does not reduce the commission base; it only goes to `merchant.discount_share`.
- **Captain pay parts:**
  - `min_pay` applies to `order_pay` only, so it never absorbs waiting pay or the peak bonus.
  - Waiting pay counts from the later of the captain's arrival at the restaurant and `accepted_at` + the chosen prep time, after the first `captain.waiting_threshold_min` (10) minutes. A captain who arrives early is not paid for waiting before the food was due. The chosen prep time is the one at acceptance: «تعديل الوقت» never moves the start of paid waiting (slice 2.9, to confirm with the owner).
  - The peak bonus applies when the order is delivered inside an active peak window for the restaurant's zone (§9.12.5).
- `custody_delta` is usually small and can be negative, for example when a platform code is larger than the delivery fee. A negative custody is reimbursed at the desk (§8.5.1).
- The captain must carry enough cash to pay the full items value at pickup. The captain app shows the pickup payment on every offer before the captain accepts.
- `rounding_adjustment` comes from rounding the customer total to the base currency's rounding unit (§8.6). It may be positive or negative, and the platform books it in `platform.fx_rounding` (§8.11).
- There is no tax line in V1 (§13).

**Worked example** (base TRY, numbers for illustration):

| Line                              | Amount  | Note                                                                                  |
| --------------------------------- | ------- | ------------------------------------------------------------------------------------- |
| Items value                       | 400     | Menu prices, which equal in-store prices                                              |
| Delivery fee                      | 40      | From the published fee table                                                          |
| Platform code (10%, capped at 30) | −30     | Funded by the platform                                                                |
| **Customer pays the captain**     | **410** | Cash at the door                                                                      |
| **Captain pays the restaurant**   | **400** | Cash at pickup, the full items value. Nothing is deducted.                            |
| Custody gained                    | +10     | 410 − 400. Handed in at the desk the same business day.                               |
| Captain pay                       | 35      | Base 25 for the first 3 km, plus 2 extra km × 5. Added to earnings, paid on Thursday. |
| Commission 15%                    | 60      | On 400. Added to the restaurant account and collected on Saturday.                    |
| Restaurant keeps                  | 340     | 400 received − 60 paid on Saturday                                                    |
| Platform margin                   | 35      | 60 + 40 − 30 − 35, before fixed costs                                                 |

**When each amount reaches the platform:**

| When              | Platform cash | From                               |
| ----------------- | ------------- | ---------------------------------- |
| Same business day | +10           | The captain hands in custody       |
| Thursday          | −35           | The captain is paid their earnings |
| Saturday          | +60           | The restaurant pays its commission |
| **Total**         | **+35**       | Equals the platform margin         |

**If a discount is funded by the restaurant**, the captain still pays the full items value, so custody is lower by the discount. The restaurant pays the discount back on Saturday, together with the commission (`merchant_weekly_due`).
