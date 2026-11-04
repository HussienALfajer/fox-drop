# 9. Menu

> Part of the [restaurant app spec](README.md) (RA). A bare "§n" here means RA §n.

The FOX DROP team builds and photographs the first menu for free (AP §9.6.3). The restaurant maintains it afterwards.

## 9.1 Structure

The structure matches the admin menu editor (AP §9.6.6):

- **Categories:** name, order, hidden or shown, and an optional availability window (for example breakfast until 12:00).
- **Items:** name, description, price, photo, category, order, available or unavailable, hidden or shown.
- **Option groups:** name, required or optional, minimum and maximum choices, and options with price deltas. Add-ons are option groups with a minimum of 0. One group can be linked to many items.
- **Admin only:** item codes, badges («جديد», «الأكثر طلباً», «حار»), Excel import and deleting items.

## 9.2 What publishes immediately and what needs review (R12, S1)

| Change | Who | Publishes |
|---|---|---|
| Availability of an item, option or category | MO, MC | Immediately |
| Item price or option price delta | MO | Immediately, with a log; large changes alert operations (§9.4) |
| Hide or show an item or category | MO | Immediately |
| Order of items and categories | MO | Immediately |
| Category availability window | MO | Immediately |
| New item | MO | After admin review |
| New or replaced photo | MO | After admin review. The old photo stays until the new one is approved. |
| Item or category name or description | MO | After admin review. The old text stays until approved. |
| New category | MO | After admin review |
| Option groups: a new group or option, linking a group to items, or changing required, minimum or maximum | MO | After admin review |
| Delete | — | Not in the app. The restaurant hides the item, and operations delete it in the panel if needed. |

## 9.3 Availability

- An item, an option or a whole category can be switched off. Switching off asks how long:
  - «حتى الغد» (until tomorrow, the default): available again at the next business-day cutoff (§4.9) (R14)
  - «حتى أعيده» (until I turn it back on)
- An unavailable category makes all its items unavailable without changing each item's own setting.
- If an option group is required and all its options are unavailable, the items that use it are unavailable automatically.
- Customers cannot order unavailable items. They stay visible, faded, with «غير متوفر حالياً», or «يتوفر غداً» for «حتى الغد» (customer-app spec §9.3).
- Every availability change records the user, the device and the time.

## 9.4 Prices

- **Validation:** an item price is greater than 0. An option delta is 0 or more (fixed). Decimals follow the base currency's settings (AP §8.6).
- **When it applies:** a new price applies to new orders only. Orders already placed keep their snapshot prices (AP §9.6.6).
- **Price parity:** the price screen shows the reminder «تذكير: سعر التطبيق يجب ألا يزيد على سعر المحل».
- **Bulk change (owners):** raise or lower by a percentage or a fixed amount, for one category or the whole menu, with rounding to the base currency's rounding unit and a before-and-after preview. This is the same tool as AP §9.6.6.
- **Large changes (S11):** if any single price changes by more than `merchant.price_change_alert_pct` (30)% in one edit or bulk change, operations get the information alert «تغيير أسعار كبير» (AP §9.1.3).
- **Admin price changes (D17):** owners are notified with a chime: «عدّلت FOX DROP سعر {الصنف}: {القديم} ← {الجديد}». A bulk admin change arrives as one summary notification.
- **Price log «سجل الأسعار»:** item, old price, new price, who changed it (the restaurant user's name, or «FOX DROP»), and when. Admins see the same log (AP §9.6.6).

## 9.5 Change requests

- A change that needs review (§9.2) becomes a request with the status «بانتظار المراجعة» (waiting for review).
- **Restaurant side:**
  - the item shows the badge «بانتظار المراجعة», and the restaurant can see the pending value
  - while it is pending, the owner can withdraw the request
  - a later edit to the same field replaces the pending value, so there is one pending request per field per item
- **Review:** OWN or OPS review the request in the panel (AP §9.6.7) with a before-and-after view.
  - Approve: the change publishes immediately. The reviewer MAY correct the text or crop the photo first; the restaurant then sees the approved version.
  - Reject: requires a reason.
- **Notification:** owners get a silent push, «قُبل تعديلك على {الصنف}» or «رُفض تعديلك على {الصنف}: {السبب}».
- **New items:** a new item is visible to customers only after approval, and only while it is available. Its price is part of the request.
- Operations SHOULD review requests within 24 hours. The panel shows each request's age.

## 9.6 Quick edit «تعديل سريع»

- One list of every item and option, with an inline price field (owners) and an availability switch (owners and cashiers).
- Search by name and filter by category.
- Price edits from this list follow §9.4.

## 9.7 Customer preview

«معاينة كما يراها الزبون» shows the menu exactly as the customer app shows it, including unavailable and hidden items as customers see them.
