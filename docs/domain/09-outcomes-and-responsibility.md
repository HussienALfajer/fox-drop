# 8.9 Outcomes and responsibility (money effects)

> Part of AP §8, the domain reference shared by all four V1 specs ([index](README.md)). A bare "§n" here means AP §n.

Every order that ends after pickup gets an outcome. Every outcome except `normal` also needs a **responsible party**: restaurant, captain, customer or platform.

| Outcome         | Arabic             | Status                               | Customer pays                                        |
| --------------- | ------------------ | ------------------------------------ | ---------------------------------------------------- |
| `normal`        | «عادي»             | delivered                            | Full total                                           |
| `free`          | «مجاني»            | delivered                            | 0, or a reduced amount set by OPS                    |
| `fake`          | «وهمي»             | failed                               | 0 (customer at fault, dues apply)                    |
| `damaged`       | «تالف»             | failed or delivered with a reduction | 0, or a reduced amount                               |
| `wrong_refused` | «خطأ ورفضه الزبون» | failed                               | 0                                                    |
| `failed_other`  | «تعذّر التسليم»    | failed                               | 0 (for example address unreachable or force majeure) |

**One rule computes the money effect of every non-normal outcome:**

1. **Custody** reflects what really happened: the pickup payment (the full items value) and whatever the captain actually collected. A negative position is reimbursed at the desk on the same business day.
2. **Commission and discount share** are posted to the restaurant account as usual, because the restaurant was paid in full at pickup. The only exception: when the restaurant is the responsible party, neither is posted.
3. **Loss amount** = merchant net − amount collected from the customer (floored at 0). Because the platform still collects the commission from the restaurant, its real loss on the food is the merchant net, not the full items value.
4. **Captain pay:** the captain receives `earn.order_pay` (and any waiting pay) unless the captain is the responsible party.
5. **The responsible party bears the cost:**
   - **Restaurant:** returns the full pickup payment (`merchant.debit`). No commission or discount share is posted, so the restaurant ends with nothing from the order. Whatever the customer paid stays with the platform and offsets the captain's pay; any remainder of the captain's pay is an operating cost.
   - **Captain:** `earn.charge` of the loss amount, and no pay.
   - **Customer:** a `dues.charge` per `customer.fake_order_dues_rule` (default delivery fee + merchant net), a block until paid, and a strike. The fake-order rule applies.
   - **Platform:** the loss amount and the captain's pay are booked to `platform.operating_cost` «كلفة تشغيلية».

**Check with the §8.4 example** (fake order, customer responsible): the captain paid the restaurant 400 and collected 0, so the desk reimburses 400. The restaurant still owes 60 commission on Saturday. The captain earns 35. The customer owes 40 + 340 = 380. Platform result once the customer pays: −400 + 60 − 35 + 380 = +5. The platform recovers its costs but does not earn its usual margin.

**Preview:** the outcome dialog MUST list each entry that will be posted, with its amount, account and party, before the user confirms. For example: «سيُعاد للكابتن 400 ₺ (عهدة) ويُقيَّد له أجر 35 ₺ (مستحقات). تُسجَّل عمولة 60 ₺ على المطعم. سيُحظر الزبون حتى دفع 380 ₺.»

**Food after a failed order.** OPS record where the food went: «يبقى مع الكابتن» (stays with the captain, the default), «أُعيد إلى المطعم» (returned to the restaurant) or «أُتلف» (disposed of) (captain-app spec C11). The record has no money effect of its own. «أُعيد إلى المطعم» is allowed only when the restaurant is the responsible party, which is the case where it returns the full pickup payment (rule 5 above).

**Changing an outcome.** OWN MAY change the outcome or the responsible party within `order.outcome_change_days` (7) of it being set, with a reason. The server reverses every entry and side effect of the old outcome (ledger entries, dues, block, strike, trust change), then posts the new ones. The same preview is shown first.

**Cancellation before pickup** (status `accepted` or `ready`). Normally the captain has not paid the restaurant yet (pickup is atomic, §8.1). If the captain had already reached the restaurant, the cash question in §8.1 is answered first. Then:

- OPS records whether food was prepared, and who is responsible.
- If food was prepared and the restaurant is not responsible, the platform credits the restaurant with the merchant net (`merchant.credit`), which is what it would have kept from a normal order.
- If the customer is responsible, the late-cancel strike applies.
- If no food was prepared, there is no money effect on the restaurant.
- **Captain:** if a captain was assigned and had already arrived at the restaurant, OPS MAY tick «تعويض الكابتن» (compensate the captain). This posts `earn.order_pay` equal to the order's base pay, booked to `platform.operating_cost`. There is no automatic pay otherwise.
