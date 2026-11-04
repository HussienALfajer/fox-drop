# 9.5 Order history «سجل الطلبات»

> Part of the [admin panel spec](../README.md) (AP). A bare "§n" here means AP §n.

- **Search and filters:**
  - order number
  - customer phone (for roles allowed to see phones)
  - restaurant, captain
  - date range (business days)
  - status, outcome, responsible party
  - code used
  - zone
  - test or real
- **Table columns:** number, time, restaurant, customer neighbourhood, captain, status, outcome, total and delivery time.
- **Detail:** any order opens the full detail and timeline (§9.3.1).
- **Finished orders are read-only.** OWN and FIN can post a financial correction, which is a reversing or adjusting ledger entry linked to the order, with a reason.
- **Export:** to Excel.
