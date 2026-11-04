# 9.16 Audit log «سجل التدقيق» (OWN)

> Part of the [admin panel spec](../README.md) (AP). A bare "§n" here means AP §n.

- **Each event records:**
  - time and actor: its kind, id and role at that moment (D27)
  - city, except for an action on the whole platform (D28)
  - action, target type and ID
  - values before and after (as a diff)
  - reason
  - IP address and device
- **Sensitive views are events too:** phone reveals, exports containing phone numbers, and document file views.
- **Filters:** actor, action type, target (order, restaurant, captain, customer, setting), date range.
- **Immutable:** nobody can edit or delete the log, including OWN. This is enforced at the database level (append-only table, no update or delete grants).
