# 22. Definition of done (restaurant app V1)

> Part of the [restaurant app spec](README.md) (RA). A bare "§n" here means RA §n.

The restaurant side is complete when all of the following can be demonstrated on a staging environment, on a low-cost Android phone, an Android tablet, a Windows PC and the portal:

1. Sign-in by OTP works for owners and cashiers. Unknown and draft accounts are refused. A phone cannot join two restaurants.
2. Owners and cashiers see exactly what §5.4 allows, and the server rejects forbidden commands sent directly to the API.
3. A new order rings on every receiving device with the screen off and the app in the background, for at least 8 hours of idle time on the low-cost phone. The first action stops the ring everywhere.
4. Owner devices with ringing off get silent notifications. Cashier devices cannot turn ringing off.
5. The device check runs at first sign-in, detects each failed condition in §4.5, and shows the banner until fixed. Its result reaches the panel.
6. The «مطعم مفتوح بلا جهاز استقبال» alert fires after 5 minutes without a receiving device and resolves when one connects.
7. Accept with a prep time, and reject with each of the three reasons, including their side effects (items unavailable, pause, optional busy mode or pause).
8. The auto-cancel countdown is visible. Auto-cancel and the unanswered counter work, and the third unanswered order auto-pauses the restaurant, which only operations can resume.
9. The preparation countdown, the late state, the repeating prep-late chime and «الطلب جاهز» work. The restaurant cannot change the prep time; a change by operations updates the card.
10. The captain line follows the captain track. Arrival and waiting chimes fire. Calling the captain works only during an active order and is recorded.
11. Pickup confirmation works end to end:
    - the prompt rings, and a manual confirmation completes the pickup atomically
    - automatic confirmation after 60 s
    - a dispute before confirmation (alert, new request) and «الطلب غير مكتمل»
    - a dispute within 10 min after any confirmation (urgent ticket, per-currency correction)
    - confirmation by operations on the restaurant's behalf
    - edits, reassignment and the item-unavailable report are blocked while a request is open
    - cancelling or reassigning after a request asks the cash question
12. A pickup without pressing ready records ready at the same moment, flagged.
13. Pickup in another accepted currency shows the right lines and base equivalent, and the restaurant account counts the full items value.
14. Item unavailable after acceptance: the alert reaches operations, pickup is blocked until resolved, and an edit, a cancellation, closing by operations or the restaurant's withdrawal each clear it.
15. Edits by operations show the changes, ring or chime as specified, require acknowledgement, move a ready order back to preparing when items are added, and raise the operations alert after 3 min without acknowledgement.
16. Cancellation after acceptance rings until acknowledged. A credit for prepared food appears in the owner's account when operations decide it.
17. Pause (15, 30, 60, until reopening), resume, busy mode (+10, +20, hourly reminder, end of period), holiday close and the precedence in §7.1 behave as specified, and customers see the right state.
18. The maximum active orders limit makes the restaurant busy at the limit and open again below it, with no race between two simultaneous orders.
19. Menu: availability with «حتى الغد» returns at the cutoff; price changes publish immediately with the price log; bulk price change works; the 30% alert fires; changes needing review wait for approval and publish or are rejected with a reason; admin price changes notify owners.
20. Hours with several periods, overnight periods and days off open and close the restaurant automatically.
21. Reports show every metric in §11 with the stated definitions, exclude test orders, and match the panel's numbers for the same period. The daily summary image can be shared.
22. The account screen shows today's pickups, the running weekly balance and exceptions. The Saturday statement appears at the cutoff with the right totals. Receipts appear when finance records them, and partial payments and the overdue banner work.
23. Commission is never visible to cashiers, and the delivery fee and customer total are never visible to anyone in the restaurant.
24. Ratings show without customer names and without a reply option.
25. Staff and devices: owners add and remove cashiers, rename and sign out devices; removal signs devices out at once.
26. Support: call, WhatsApp, report with types and photo, and «بلاغاتي» with resolution messages.
27. Unstable internet: commands survive drops without double effects, conflicts show the current state, the red bar and the offline chime work, and timers stay correct with a wrong device clock.
28. Windows: auto-start, tray, quit confirmation, window to front on a ring, native notifications and self-update outside active orders.
29. The portal offers every owner feature except receiving orders, shows live orders read-only, and exports reports, history and statements.
30. Forced update, maintenance, terms re-acceptance (owners only) and the emergency-stop banner behave as specified.
