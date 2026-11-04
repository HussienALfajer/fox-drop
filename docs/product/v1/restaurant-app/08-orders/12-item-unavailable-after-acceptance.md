# 8.12 Item unavailable after acceptance (R6)

> Part of the [restaurant app spec](../README.md) (RA). A bare "§n" here means RA §n.

- The button «صنف غير متوفر — اتصلوا بالزبون» is on orders in `accepted` or `ready`, before pickup, while no pickup request is open (§8.10).
- **The dialog asks for:**
  - the items (required)
  - for each item, «حتى الغد» (default) or «حتى أعيده»
  - an optional note: «يوجد بديل مشابه» (a similar substitute exists) or «الكمية غير كافية» (not enough quantity)
- **Effect:**
  - the items become unavailable in the menu immediately (§9.3)
  - operations get the critical alert «صنف نفد بعد القبول» (AP §9.1.3)
  - the customer app tells the customer that FOX DROP will call them (customer-app spec §11.6)
  - the card shows the badge «صنف نفد — بانتظار العمليات» and the line «العمليات تتواصل مع الزبون»
  - pickup requests are blocked until the report is resolved (§8.10)
- The restaurant keeps preparing the rest of the order.
- **Resolution:**
  - operations edit the order, removing or replacing the items (§8.13), or cancel it (§8.14); either clears the report automatically
  - operations MAY close the report without an edit, with a reason (AP §9.3.2)
  - before operations act, the restaurant MAY withdraw the report with «تراجع — الصنف متوفر», which makes the items available again
