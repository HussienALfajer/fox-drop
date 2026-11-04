# 9.3 Order detail and order actions

> Part of the [admin panel spec](../README.md) (AP). A bare "§n" here means AP §n.

## 9.3.1 Order detail

- **Header:**
  - order number, status and a step progress bar
  - promised time compared with the expected or actual time
  - outcome and responsible party, when the order is finished
  - badges
- **Customer:**
  - name and masked phone (reveal is logged, §5.4)
  - address on a mini map, with the details and the nearby landmark
  - the recipient's name and contact phone, when the order is for someone else (customer-app spec Q5). The contact phone is masked and revealed like the customer's phone (§5.4).
  - the pay-in currency «سأدفع بـ», when the customer chose one (customer-app spec U10)
  - delivered-order count and trust level
  - strikes and internal notes
- **Restaurant:** name, phone and current state.
- **Captain:**
  - name, phone and vehicle
  - live position and last GPS time
  - cash-limit usage
- **Items:** each item with its options, add-ons, quantity, note and line price. Items added or removed by admins are marked with who made the change.
- **Money:**
  - every line from §8.4: items value, delivery fee, discounts split by funder, rounding, customer total, pickup payment (paid by the captain), custody for this order, commission and restaurant-funded discount (owed by the restaurant on Saturday), merchant net, captain pay and platform margin
  - the exchange-rate snapshot
  - after delivery: the payment lines (currency and amount), the change given, and any shortfall
- **Timeline:** every event with its time and actor (system, restaurant user, captain or admin user). The events are:
  - created
  - restaurant notified
  - accepted (with prep time and who accepted)
  - rejected (with reason)
  - accepted on behalf by an admin
  - search started
  - each offer (captain and response: accepted, rejected or expired)
  - assigned (automatically, or manually by whom)
  - captain at the restaurant
  - ready
  - items verified
  - pickup requested (payment lines)
  - pickup disputed (the amount the restaurant says it received)
  - pickup confirmed, one event with the payment lines (§8.1): by the restaurant (user and device), automatically, or by OPS on its behalf
  - item reported unavailable, and how the report was closed
  - edit acknowledged by the restaurant (user and device)
  - restaurant called the captain
  - handed over to another captain
  - captain at the customer
  - each customer ping, and the customer's «أنا قادم» answer
  - each customer call to the captain
  - delivered (with payment lines)
  - edits (with the money difference)
  - ETA changes
  - cancellation (reason and party)
  - outcome
  - compensation
  - tickets linked
  - notes
  - emergency notices sent
- **Map:** the restaurant, the customer and the captain (live), with the captain's track after pickup.
- **Related:** tickets and compensations on this order.

## 9.3.2 Actions

Each action is available only when the order's status and the user's role allow it. The server re-checks both.

**Who:** OWN and OPS can take every action below, except that changing an outcome after it was set is OWN only (§8.9). SUP can take only these: compensate the customer, call, internal note, open a ticket, resend a notification.

| Action | Arabic label | Allowed in | What happens | Reason |
|---|---|---|---|---|
| Accept for the restaurant | «قبول نيابة عن المطعم» | `placed` | The admin picks a prep time and the order continues normally. The restaurant app shows that ops accepted. | Required |
| Reject for the restaurant | «رفض نيابة عن المطعم» | `placed` | The order becomes `rejected`. The customer sees the reason and similar restaurants. | Required |
| Assign a captain | «تعيين كابتن» | No captain, before pickup | Opens the assignment picker (below) | — |
| Reassign | «سحب وإعادة تعيين» | Assigned, **before pickup only**, and no pickup request open | Takes the order from the captain. The admin chooses «بخطأ من الكابتن» (counts as a captain cancellation) or «دون خطأ» (no penalty), then the order goes back to dispatch or to a picked captain. If the captain had already reached the restaurant, the cash question in §8.1 comes first. | Required |
| Hand over after pickup | «تسليم لكابتن آخر» | `picked_up` or `arrived`, emergencies only (for example an accident or a breakdown) | The admin picks a second captain, who goes to the first captain and takes the order. The second captain's offer shows that they pay nothing, and the maximum pickup amount does not apply. The second captain confirms receipt near the first captain, which sets the status back to `picked_up` if it was `arrived`. The first captain's track ends and they go offline (captain-app spec §9.10.1). The pickup payment stays in the first captain's custody, where the desk reimburses it. The second captain collects at the door, so the collection goes to their custody. The second captain earns the order pay. OWN or FIN MAY add a manual bonus for the first captain. If the food cannot continue, use «تحديد النتيجة» instead. | Required |
| Record delivery for the captain | «تسجيل التسليم نيابة عن الكابتن» | `picked_up`, `arrived` | For when the captain has no working phone. The admin enters the payment lines and change as the captain reports them by phone. The order becomes `delivered` with outcome `normal`, with the same entries as a delivery from the app. | Required |
| Set the outcome | «تحديد النتيجة» | `picked_up`, `arrived` | Ends the order as `failed`, or as `delivered` with outcome `free` or `damaged`. The admin picks the outcome, the responsible party, the amount to collect from the customer and, for a failed order, where the food went (§8.9), and sees the money preview. If the amount to collect is above 0, the order stays active with «بانتظار تسجيل التحصيل», and the captain records the payment lines in the captain app (OPS MAY enter them instead when the captain cannot). The outcome is posted then, from the recorded net, so the preview is marked provisional until collection. A gap below the amount beyond rounding follows the collection-shortfall flow (§8.6). Problems found after a normal delivery go through tickets (§8.10), not outcomes. | Required |
| Record the captain's arrival | «تسجيل وصول الكابتن» | Assigned, before pickup, captain not yet `at_merchant` | Sets the captain track to `at_merchant`, for when GPS fails at the restaurant (captain-app spec §9.2) | Required |
| Change prep time or promised time | «تعديل الوقت» | `accepted`, `ready`, `picked_up` | The customer is notified of the new time | — |
| Edit the order | «تعديل الطلب» | §9.3.3 | Recalculates the money and notifies everyone involved | Required |
| Cancel | «إلغاء الطلب» | `placed`, `accepted`, `ready` | The admin picks a reason and a responsible party, says whether food was prepared, and may add compensation. If the captain had already reached the restaurant, the admin also answers the cash question (§8.1). Shows the money preview (§8.9). | Required |
| Change the outcome | «تغيير النتيجة» | Finished, within `order.outcome_change_days` (7) | OWN only. Reverses the old outcome's entries and side effects and posts the new ones (§8.9). | Required |
| Compensate the customer | «تعويض الزبون» | Any status | A next-order code (amount, or % with a maximum amount), within the role's cumulative cap for this order (§6.4) | Required |
| Call | «اتصال» | Any status | Reveals the number (logged) and opens `tel:` | — |
| Internal note | «ملاحظة داخلية» | Any status | Saved on the order, visible to panel users only | — |
| Open a ticket | «فتح تذكرة» | Any status | Creates a ticket linked to this order | — |
| Resend a notification | «إعادة إرسال الإشعار» | Active orders | Pushes the current state again to the customer, restaurant or captain | — |
| Manual dispatch for this order | «توزيع يدوي لهذا الطلب» | Before assignment | Takes this order out of automatic dispatch | — |
| Confirm pickup for the restaurant | «تأكيد الاستلام نيابة عن المطعم» | `accepted` or `ready`, the assigned captain at the restaurant, and no open item-unavailable report | The admin enters the payment lines, prefilled from the captain's last request, and the server performs the pickup (§8.1). It does not wait for an unacknowledged edit, because the admin confirmed it by phone. The restaurant app shows that ops confirmed. Used when the restaurant cannot answer, or a dispute or edit was settled by phone. | Required |
| Close an item-unavailable report | «إغلاق بلاغ صنف نفد» | A report is open (restaurant-app spec §8.12) | Clears the report without an edit, for example when the restaurant found the item. An edit or a cancellation clears it automatically. | Required |

**Assignment picker:**

- Lists eligible captains (§9.12.6 eligibility rules), sorted by distance to the restaurant. For each captain it shows:
  - distance and ETA to the restaurant
  - vehicle
  - orders today
  - cash-limit usage
  - acceptance rate
- Ineligible captains appear greyed out with the reason: busy, over the cash limit, blocked for unhanded cash, out of range, vehicle not allowed, or «المبلغ أكبر مما يحمله» (the pickup payment is above the captain's maximum pickup amount). OPS MAY still send a manual offer to a captain greyed out only for that last reason; the captain sees a warning and decides (captain-app spec §8.4).
- With `dispatch.manual_assign_requires_accept` (true), a manual assignment reaches the captain as an offer, and the admin sees whether they accept. With false, the assignment is direct.

## 9.3.3 Editing rules (D8)

| Status | Add items | Remove items or lower quantity | Change options | Change delivery fee |
|---|---|---|---|---|
| `placed`, `accepted` | Yes | Yes | Yes | Yes |
| `ready` | Yes. The order goes back to `accepted` with an extra prep time that the admin enters. | Yes | Yes | Yes |
| `picked_up`, `arrived` | No | Yes (the customer refuses part of the order), with a responsible party | No | Lower only, with a responsible party |
| Finished | No edits. Use a ticket (§8.10), an outcome change (§8.9) or a ledger adjustment. | | | |

- **Adding items:**
  - Items come from the restaurant's current menu at current prices and must be available.
  - The restaurant app gets a sound alert, «تم تعديل الطلب», and must acknowledge it.
  - If the restaurant does not acknowledge within `order.merchant_accept_alert_min` (3 min), OPS gets the critical alert «المطعم لم يؤكد التعديل» (§9.1.3).
- **Every edit before pickup** opens a prompt in the restaurant app that the restaurant acknowledges.
  - Only an unacknowledged edit that adds items blocks pickup requests, and only additions raise the «المطعم لم يؤكد التعديل» alert.
  - Edits are blocked while a pickup request is open (§8.1).
  - After an edit, the restaurant and the captain settle any cash difference in person, and the captain's next request carries the new amount.
- **Every edit:**
  - shows a before-and-after money preview
  - recalculates the totals with the order's snapshots (§8.1). Before pickup this includes the pickup payment, commission and merchant net. After pickup, the pickup payment and the base of the commission and discount share are frozen (§8.1). Removals then post only the separate entries below.
  - notifies the customer of the new total and the captain of the new amounts to pay (before pickup) and to collect
- **Edits and discount codes:**
  - The code stays on the order.
  - A percentage discount is recomputed on the new items value, capped at the original discount amount.
  - Minimum-order and free-delivery thresholds are not re-checked after the order was placed.
- **After pickup**, the captain has already paid the restaurant the full items value, so removing items applies the §8.9 rule to the removed items only:
  - restaurant responsible: the restaurant returns the removed items' value (`merchant.debit`), and a reversing `merchant.commission` removes the commission on them
  - captain responsible: `earn.charge` of the removed items' merchant net
  - platform responsible: the removed items' merchant net goes to `platform.operating_cost`
  - customer responsible: not allowed. A customer who changes their mind at the door pays the full total, unless OPS gives a compensation code.
- **Lowering the delivery fee after pickup:** the reduction is borne by the responsible party, as in §8.9: captain (`earn.charge`), restaurant (`merchant.debit`) or platform (operating cost).
