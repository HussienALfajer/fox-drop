# 9.11 Problems, withdrawal and emergencies

> Part of the [captain app spec](../README.md) (CA). A bare "§n" here means CA §n.

**«مشكلة» (problem)** is on every step. It has three options:

- call operations
- WhatsApp operations
- report with a quick reason: «المطعم متأخر», «صنف ناقص», «مشكلة في مبلغ الاستلام», «العنوان خاطئ», «الزبون لا يرد», «حادث أو طارئ», «أخرى». «مشكلة في مبلغ الاستلام» opens a pickup-dispute ticket (§9.4).

A report creates a ticket linked to the order, urgent while the order is active (AP §9.9.1).

**«لا أستطيع إكمال الطلب» (C5)** is inside «مشكلة»:

- **The dialog asks for a reason** (Appendix C): «عطل في المركبة», «حادث», «ظرف طارئ», «لا أملك المبلغ المطلوب للمطعم», «أخرى» (with text).
- **Effect:**
  - OPS get the critical alert «كابتن لا يستطيع إكمال الطلب» (AP §9.1.3)
  - the order shows «بانتظار العمليات», and the captain keeps it until OPS act
  - the captain can withdraw the request with «تراجع»
- **OPS decide:** reassign before pickup (with the cash question if a request was made, AP §8.1), hand over after pickup, or call the captain and resolve it.
- **Recording:** it counts as a captain cancellation, unless OPS mark it «دون خطأ» (no fault) (AP §9.7.6).

**«طوارئ» (C15)** is a red button on the order screen during an active order:

- **Activation:** a 2-second press (K12, fixed), with a progress ring, so it is never pressed by accident.
- **Effect:**
  - the phone calls the operations number: directly on Android (with the call permission from the device check), and after iOS's own one-tap call confirmation on iPhone
  - the server receives the captain's current location and marks the order «طوارئ»
  - OWN and OPS get the critical alert «طوارئ كابتن» with the location (AP §9.1.3)
- **Next:** operations decide the next step, usually a handover after pickup or a reassignment before it.
- The button does not cancel anything by itself.
