# 9.8 Customers «الزبائن»

> Part of the [admin panel spec](../README.md) (AP). A bare "§n" here means AP §n.

- **Search:** by phone or name.
- **Customer profile:**
  - name and masked phone
  - gender, and birthday when given (customer-app spec U4)
  - addresses on a map
  - trust level (§8.8)
  - status: «نشط» (active), «موقوف حتى مراجعة الدعم» (stopped until support review), «محظور» (blocked, with the reason and dues), «مغلق» (closed)
  - orders: count, total spent, last order
  - tickets, ratings written, codes used
  - strikes (late cancellations, fake orders)
  - internal notes
  - linked closed accounts (§8.8)

**Actions:**

| Action | Detail | Who | Reason |
|---|---|---|---|
| Block «حظر» | For a duration, until further notice, or until dues of a set amount are paid | OWN, OPS | Required |
| Unblock «فك الحظر» | Manual unblock | OWN, OPS | Required |
| Record dues payment «تسجيل دفع المستحق» | Done at the cash desk with a receipt; unblocks automatically when the dues reach zero | OWN, FIN | — |
| Clear strikes or end a review stop | After a support review | OWN, OPS, SUP | Required |
| Compensation code | Amount, or % with a maximum amount; linked to one of the customer's orders and within the role's cumulative cap for that order (§6.4) | OWN, OPS, SUP | Required |
| Mark trusted or remove trust | Overrides the automatic rule (§8.8) | OWN, OPS | Required |
| Flag as an admin test account | Can see restaurants in test mode | OWN | — |
| Internal note | For example «يفضل الاتصال قبل الوصول» (prefers a call before arrival) | All with access | — |
| Close the account on request «إغلاق الحساب» | The customer can no longer sign in and the data is kept (D19, §8.8). Refused while the customer has an active order. | OWN, OPS, SUP | Required |
| Change the phone number «تغيير الرقم» | On the customer's request. The new Syrian or Turkish number must not belong to another open account. Every session ends, and the customer signs in again with the new number and a code (customer-app spec §5.4). | OWN, OPS | Required |
| Sign out every device «تسجيل الخروج من كل الأجهزة» | For example after a lost or sold phone. Active orders are not affected. | OWN, OPS, SUP | Required |
