# 14. Definition of done (V1 admin panel)

> Part of the [admin panel spec](README.md) (AP). A bare "§n" here means AP §n.

The panel is complete when all of the following can be demonstrated on a staging environment:

1. Sign-in requires a password and TOTP. Lockout, session expiry, force sign-out and TOTP reset work.
2. Each role sees only its modules and actions, and the server rejects forbidden calls made directly to the API. A user with two roles (for example OPS + FIN) gets the union of both.
3. The dashboard shows live tiles and every alert in §9.1.3 fires on its trigger, reaches only its recipient roles, plays its sound (critical alerts repeat until acknowledged), can be acknowledged and resolves itself.
4. The emergency stop blocks new orders, sends the delay notice to every active-order customer, shows banners in all apps, and resumes cleanly.
5. The operations board updates in real time, SLA colours change at the right moments, and filters work.
6. Every order action in §9.3.2 works in the allowed statuses only, with reasons, previews, notifications and timeline events, including the post-pickup handover.
7. Order edits follow §9.3.3, including adding items to a `ready` order (back to `accepted`), the edit acknowledgement alert, and post-pickup removals with a responsible party. The pickup payment and `picked_up` happen as one action when the restaurant confirms, when the 60-second automatic confirmation fires, or when OPS confirms on the restaurant's behalf (§8.1).
8. Outcomes post exactly the entries their preview showed, for each responsible party (§8.9). OWN can change an outcome within 7 days, and every side effect is reversed.
9. Dispatch works in all three modes: manual («بحاجة لتعيين» at the search-start moment), automatic (eligibility, ranking, one offer at a time, 45 s timeout) and mixed (falls back to manual after 5 failed offers). The capacity check refuses orders with no eligible captain.
10. Tickets follow §9.9 and §8.10: SLA timers, every resolution type, the free re-delivery order, and the money effect for each responsible party.
11. Restaurant auto-pause triggers after 3 unanswered orders in a business day.
12. The live map shows zones, restaurants, captains and orders, and manual assignment from the map works.
13. The restaurant wizard enforces the activation checklist. Test mode hides the restaurant from normal customers, and test orders are excluded from KPIs.
14. The menu editor supports option groups, bulk price change with preview, Excel import with validation and dry run, and the price log. Every admin price change notifies the restaurant.
15. Commission changes are OWN-only and affect new orders only.
16. The captain pipeline enforces every required document, the contract, kit, deposit and cash limit before activation. Duplicate detection warns.
17. Probation and document-expiry tasks appear on time.
18. Custody is tracked per currency. The daily hand-in rule blocks going online exactly as in §8.5.4, and grace works.
19. Thursday settlement settles custody, posts instalments, pays earnings and issues the weekly statement. Off-cycle payouts need OWN.
20. The captain pays the full items value at pickup. Commission and restaurant-funded discounts accrue on the restaurant account. The weekly statement appears in the restaurant app before Saturday. The Saturday settlement works at the office or by visit, accepts partial payments, issues receipts in the restaurant app, and raises the overdue alert on time.
21. Cash-desk receipts are numbered without gaps, are printable and appear in the other party's app. Drawer sessions open and close with variance.
22. Exchange rates are versioned. Orders keep their snapshot. Customer equivalents and door payments in USD, TRY and SYP convert and round correctly. Shortfalls raise alerts.
23. Customer trust, strikes, the fake-order block and dues, and account closure with re-registration linking behave as in §8.8.
24. Compensation caps per role work, and above-cap requests go through OWN approval.
25. Promo codes enforce every field in §9.11.1, including the new-user once-per-phone-and-device rule and the daily budget cap.
26. Mass push sends to each audience type, now or scheduled, and shows the audience size first.
27. Zones, delivery fees (flat and bands) and captain pay tables (effective-dated) have working preview calculators. The peak bonus is off by default and pays correctly when on.
28. Every setting in Appendix A is editable by the right roles and audited.
29. The audit log records every write and sensitive view and cannot be modified.
30. Every report in §9.17 renders and exports to Excel with Arabic headers.
31. Restaurant-app integration:
    - The new alerts fire on their triggers: «صنف نفد بعد القبول», «خلاف على مبلغ الاستلام», «مطعم مفتوح بلا جهاز استقبال» and «تغيير أسعار كبير».
    - Pickup disputes resolve through tickets with the correct per-currency entries.
    - Cancelling or reassigning after a pickup request asks the cash question and posts the entries when the cash was not returned.
    - Removing items after pickup never cuts the commission twice.
    - Menu change requests can be approved or rejected.
    - The busy state and busy mode show correctly.
    - Restaurant users' actions appear in timelines and change logs with the user and device.
32. Captain-app integration:
    - The alerts «كابتن لا يستطيع إكمال الطلب», «طوارئ كابتن» and «تسليم بعيد عن العنوان» fire on their triggers.
    - Dispatch respects the maximum pickup amount, with the manual override.
    - Three expired offers in a row set a captain offline.
    - «تسجيل وصول الكابتن» works.
    - «تحديد النتيجة» with an amount to collect waits for the captain's payment lines, or for OPS to enter them, and posts from the recorded net.
    - The handover leg works from `picked_up` and `arrived`.
    - «تسجيل التسليم نيابة عن الكابتن» and «تحرير الجهاز» work.
    - The cash question appears after the captain reached the restaurant.
    - Failed orders record where the food went.
    - Re-application and the early-exit approval work.
33. Customer-app integration:
    - The delivery estimate and the promised time follow §8.3, and late alerts count from the promised time.
    - The order detail shows the pay-in currency and the recipient of an order for someone else.
    - Customer problem reports respect the 24-hour window and one report per order. Price reports «سعر مختلف عن المحل» arrive as restaurant-linked tickets.
    - The customer profile shows gender and birthday, and the customers report splits by them.
    - Sign-in codes have 6 digits in every app.
    - Discounts never take the customer total below 0. Code uses come back when an order is rejected, cancelled, or failed without the customer at fault.
    - The quote's exchange rates become the order's snapshot, and a changed rate refuses the order.
    - Account closure is refused while an order is active. «تغيير الرقم» and «تسجيل الخروج من كل الأجهزة» work.
    - Wrong-change tickets and price-difference tickets resolve as in §8.10 and §9.9.3.
