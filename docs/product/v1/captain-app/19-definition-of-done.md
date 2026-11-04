# 19. Definition of done (captain app V1)

> Part of the [captain app spec](README.md) (CA). A bare "§n" here means CA §n.

The captain app is complete when all of the following can be demonstrated on a staging environment, on a low-cost Android phone and on an iPhone:

1. Applying works end to end: phone code, form, documents with quality checks, status updates at every stage, document requests, rejection with re-apply after 30 days, waitlist.
2. Activation by the panel turns the applicant into a captain, runs the welcome tour, the device check, and the maximum pickup amount and currency setup.
3. Sign-in by code works, with one device at a time and the other device signed out.
4. Every block in §7.2 refuses going online with its message, and each lifts when its condition ends.
5. While online, the location reaches the server every 10 seconds on both platforms with the screen off. It stops completely when offline. Positions queued without signal arrive later.
6. An offer rings with the screen off on the low-cost Android phone after 8 hours of idle time online. On the iPhone it arrives as a time-sensitive notification with sound, and as a full screen with the app open.
7. The offer shows every item in §8.2 and hides the address and phone. Accept, reject and expiry work, and 3 expired offers in a row set the captain offline.
8. Orders above the captain's maximum pickup amount are never offered automatically. A manual offer above it shows the warning.
9. Arrival at the restaurant works only within 150 m, with the suggestion banner. OPS can record arrival when GPS fails.
10. The item checklist is mandatory before payment. Waiting time and waiting pay show as specified.
11. The pickup request works with the restaurant app: confirmation, automatic confirmation after 60 s, confirmation by OPS, dispute and «الطلب غير مكتمل», blocks for an item-unavailable report or an unacknowledged added-items edit, and voiding on cancellation with the cash instruction.
12. Proposed payment lines follow §10.5. Lines outside the tolerance are refused.
13. Customer details appear only after acceptance, and call and WhatsApp work only during the order. History hides the customer data after the order ends.
14. Arrival and delivery within 200 m pass without a reason. Farther away they need a reason, and OPS get the information alert.
15. The door payment screen records multi-currency lines and change, computes the change, warns on a shortfall with a required reason, and never records a tip.
16. The order summary shows the pay breakdown and the custody change, and the ledger entries match AP §8.5.
17. The customer-not-answering flow follows the pings and the 15-minute rule, then OPS decide.
18. Edits, withdrawal, cancellation and OPS outcomes show the right screens. An outcome with an amount to collect opens the payment screen, keeps the captain busy, and posts from the recorded net.
    - The cash question appears when an order is cancelled or withdrawn after the captain arrived at the restaurant.
    - The handover leg works in `picked_up` and `arrived`: the second captain pays nothing, confirms receipt near the first captain, and delivers. The first captain's custody is reimbursed, and they go offline.
    - OPS can release a captain's device mid-order, and the captain continues on a new phone. OPS can also record a delivery on the captain's behalf.
    - After a «لا أستطيع إكمال الطلب» request or an emergency, the captain goes offline when the order leaves them. Force offline during an order means last-order mode.
19. «لا أستطيع إكمال الطلب» raises the OPS alert, can be withdrawn, and keeps the order until OPS act.
20. «طوارئ» needs a 2-second press, calls operations, sends the location and raises the alert.
21. Last-order mode takes the captain offline after the current order. Going offline with an active order is not possible.
22. The custody screen shows custody per currency, split into previous days and today, with receipts that appear as soon as the desk records them. The hand-in reminders fire as specified.
23. The cash limit warns at 80% and stops offers at 100%.
24. The earnings screen shows every entry type with reasons. The Thursday statement appears after the settlement and can be shared.
25. Performance shows the acceptance rate with the last 50 offers, the on-time rate, cancellations, the rating without names, and violations with a working appeal.
26. The profile shows documents with expiry and replacement, the criminal record certificate expiring 12 months after issue, the contract with the early-exit explanation, the kit and deposit, and the pay table with the calculator and announced changes.
27. Weak internet: commands survive drops without double effects, conflicts show the current state, and timers stay correct with a wrong device clock.
28. Forced update, maintenance, terms re-acceptance and the emergency-stop banner behave as specified, without interrupting a current order.
