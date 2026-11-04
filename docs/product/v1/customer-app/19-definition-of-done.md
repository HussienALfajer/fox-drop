# 19. Definition of done (customer app V1)

> Part of the [customer app spec](README.md) (CU). A bare "§n" here means CU §n.

The customer app is complete when all of the following can be demonstrated on a staging environment, on a low-cost Android phone and on an iPhone:

1. A guest can choose a location, browse, search, build a cart and see the checkout quote. Sign-in is asked for at «تأكيد الطلب» and on personal pages. The cart and the filled address survive it, and the quote is refreshed for the account.
2. Sign-in works with Syrian and Turkish numbers, a 6-digit code over WhatsApp only, the message for a number without WhatsApp, resend timing, attempt limits and the per-number, per-device and per-IP request limits.
3. A new account must give a first name and gender and accept the terms; the birthday can be skipped. Restaurants and captains never see gender or birthday.
4. The zone check, «قريباً في منطقتك» with the vote, and the no-coverage message work.
5. Addresses enforce every rule in §7.3, including the required landmark, the recipient's name for another phone, editable pins inside zones, the 10-address limit and the out-of-zone state.
6. «التوصيل إلى موقعي الحالي» works without saving. Checkout preselects the address from the browsing point. The far-pin check requests a fresh position, fires above 1 km, and is skipped without one.
7. Home sections follow the panel's order and show only restaurants that deliver to the point. Lists put closed restaurants last, faded, with their opening time.
8. Search finds restaurants and items, keeps 10 recent searches, and «لم تجده؟ أخبرنا» reaches the lost-demand report.
9. The restaurant page shows every element in §9.1, every state in §9.2 with ordering disabled where it should be, and the busy-mode note.
10. Hidden items never appear. Unavailable items, options and out-of-window categories show as specified. The item sheet enforces option rules with the scroll to the missing group.
11. The cart holds one restaurant, asks before replacing, expires after 24 hours, and shows price and availability changes.
12. The minimum order blocks with the progress message. The free-delivery progress shows.
13. Checkout shows the money lines, including rounding when not 0, and the equivalents in every accepted currency, rounded per currency. «سأدفع بـ» reaches the captain app and the panel. Notes with a phone number are refused.
14. Codes can be typed or picked. The best code is suggested and never applied automatically. Every refusal reason in AP §9.11.1 shows its message. A code never takes the total below 0, and a code used on a rejected or cancelled order comes back.
15. Every pre-order check in §10.6 refuses with its message, including the capacity check and the atomic restaurant limit. A changed total or exchange rate is never placed without a new confirmation. The cart empties when the order is placed.
16. The order screen follows every row of §11.2 in real time, with a polling fallback, and pushes arrive for the rows marked.
17. The captain card appears at assignment. The map and «اتصال بالكابتن» appear at pickup and disappear at the end. Reassignment and handover update the card.
18. Self-cancel works only while `placed`, with a reason, and the race with acceptance shows the right message.
19. Item-unavailable reports, edits, time changes, late apologies, the late code and the emergency delay notice reach the customer as in §11.6.
20. The arrival push and the door ping ring on both platforms. «أنا قادم», and «سأتصل بالمستلم» for an order with a recipient, reach the captain app.
21. After delivery, the order detail shows what the captain recorded. Rejected, cancelled and failed orders show the texts in §11.9, with similar restaurants and «اطلب بدون الأصناف غير المتوفرة».
22. Ratings work for the restaurant and the captain separately, within 3 days, cannot be edited, and appear to each viewer as in §12.1. «جديد» shows below 5 ratings.
23. A problem report works within 24 hours, once per order, with items and up to 3 photos, and its resolution reaches the order, «أكوادي» or a re-delivery order.
24. «أبلغ عن سعر مختلف» creates the price ticket, once per restaurant per day.
25. Reorder rebuilds the cart at current prices and lists skipped items. Favourites sync across devices.
26. Account states in §5.5 show the right banners and block ordering. The dues banner shows the office. Account closure needs a fresh code and is refused with an active order. «تسجيل الخروج من كل الأجهزة» works.
27. Forced update, maintenance, terms re-acceptance, platform hours and the emergency stop behave as in §4.2 and §4.7, without hiding an active order.
28. Weak internet: commands survive drops without double effects, cached browsing works offline, and timers stay correct with a wrong device clock.
