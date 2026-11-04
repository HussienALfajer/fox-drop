# 9. Restaurant page and items

> Part of the [customer app spec](README.md) (CU). A bare "§n" here means CU §n.

## 9.1 Restaurant page

- **Header:**
  - cover, logo, name and categories
  - the rating with the number of ratings, or «جديد» (Q16)
  - the estimate range and the delivery fee for the selected point
  - the minimum order
  - the free-delivery threshold, when there is one: «توصيل مجاني للطلبات من {المبلغ} فأكثر» (AP §9.12.3)
  - the price-parity badge (§9.5)
  - the heart (§9.6)
- **«أوقات العمل» (opening hours):** a sheet with the weekly schedule (RA §10).
- **Menu:** categories in the restaurant's order, with a category bar that follows the scroll, and «ابحث في القائمة».

## 9.2 Restaurant states (U6, Q8)

| State (RA §7.1) | What the customer sees | Can add to the cart |
|---|---|---|
| Open | Nothing extra | Yes |
| Open, busy mode on | The longer estimate, and «قد يستغرق الطلب وقتاً أطول قليلاً» (Q8) | Yes |
| Busy (limit reached) | «المطعم مشغول حالياً، جرّب بعد قليل» | No |
| Paused (any source) | «المطعم متوقف مؤقتاً، يعود خلال {المدة}», or «… يعود قريباً» when there is no end time, plus the operations message when operations paused it (AP §9.6.5) | No |
| Closed by schedule | «مغلق — يفتح {اليوم} {الساعة}» | No |
| Holiday close | «مغلق حتى {التاريخ}», plus the restaurant's message | No |
| Suspended | Not shown | — |

- In every state except open, the menu stays browsable and the add buttons are disabled with the state message (U6).
- **A cart from a restaurant that changed state** stays in the app. Checkout shows the state message until the restaurant can take orders again.

## 9.3 Menu and availability (U7)

- **Hidden** items and categories never appear (RA §9.2).
- **Unavailable items** stay in place, faded and not orderable, with:
  - «يتوفر غداً» when the restaurant switched them off until tomorrow (RA §9.3, R14)
  - «غير متوفر حالياً» otherwise
- **A category outside its availability window** (for example breakfast until 12:00) shows its items faded with «متوفر من {الساعة}».
- **Unavailable options** appear faded inside their group and cannot be picked.
- An item whose required option group has no available option is unavailable (RA §9.3).
- **Prices:** an item shows its price. If a required group changes the price, it shows «من {أقل سعر}».

## 9.4 Item sheet

- Photo, name, description and price.
- **Option groups** (RA §9.1), each with its rule:
  - «إجباري» (required)
  - «اختر {العدد}» (choose n), «اختر حتى {العدد}» (up to n), or «اختر من {أ} إلى {ب}» (from a to b)
  - each option with its price delta
- **Quantity:** 1 to 20 per line (fixed).
- **Item note:** up to 100 characters (fixed), with the placeholder «مثلاً: بدون بصل». The restaurant sees it (RA §8.4), so it cannot contain a phone number (Q25).
- **The add button** shows the line price live: «أضف — {المبلغ}».
- **Validation:** if a required group is incomplete, the sheet scrolls to it and highlights it with «اختر {العدد} على الأقل».
- The same item with different options or notes becomes separate cart lines.

## 9.5 Price parity (U17, Q18)

- **Badge:** every restaurant page shows «نفس أسعار المحل». A tap opens an explanation: «أسعار هذا المطعم في التطبيق هي نفس أسعاره في المحل. إن وجدت فرقاً فأخبرنا.»
- **«أبلغ عن سعر مختلف»** (signed-in customers) opens a form:

  | Field | Rule |
  |---|---|
  | Item | Optional, picked from the menu |
  | Price in the shop | Optional, in the base currency |
  | Note | Optional, up to 300 characters |
  | Photo | Optional, 1, for example of the shop's menu board |

- **Sending** creates a ticket of the type «سعر مختلف عن المحل», linked to the restaurant (AP §9.9.1). The app answers «شكراً، سنتحقق من السعر». The resolution, «تم تصحيح السعر» or «السعر صحيح», reaches the customer as a push (AP §9.9.3).
- **Limit:** one report per restaurant per customer per business day (fixed): «أرسلت بلاغاً عن هذا المطعم اليوم».

## 9.6 Favourites (U18)

- A heart on restaurant cards and pages. A guest is asked to sign in.
- «حسابي» → «المفضلة» lists the favourite restaurants with their current state and estimate, and only those that deliver to the selected point.
- Favourites belong to the account, so they appear on every device.
