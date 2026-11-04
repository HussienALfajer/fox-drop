# FOX DROP V1 — Customer App Specification

| | |
|---|---|
| Product | FOX DROP, a food delivery platform launching in Azaz, Syria, then expanding city by city |
| Scope | V1, the first version that completes a full order cycle |
| Component | The customer app «تطبيق الزبون» for Android and iOS |
| Status | Approved by the owner on 2026-11-03 (decisions in §2) |
| Audience | Engineers and coding agents (Claude Code) who build the customer app and the server rules behind it |
| UI language | Arabic only, right to left |
| Related | Admin panel spec `docs/v1/admin-panel.md`, cited as "AP §n". Restaurant app spec `docs/v1/restaurant-app.md`, cited as "RA §n". Captain app spec `docs/v1/captain-app.md`, cited as "CA §n". Arabic V1 plan page: https://claude.ai/artifact/8XR91QrZHk73nRHdu7E1q6. BeeOrder customer research: `docs/beeorder-research/01-customer-app.md`. Technology stack: `docs/architecture/technology-stack.md` |

---

## 0. How to use this document

- This document is the source of truth for everything a customer sees and does in FOX DROP V1. If it differs from the Arabic plan page, this document wins.
- Shared domain rules live in AP §8: order statuses, timers, money formulas, currencies, customer trust and outcomes. This document cites them instead of repeating them. Where this document changes a shared rule, the other three specs were updated in the same change; §16 lists every such change.
- **MUST**, **SHOULD** and **MAY** as in AP §0.
- `dotted.keys` are server settings. New keys are listed in Appendix A; existing keys are in AP Appendix A. Every number is the default value of a setting unless it is marked **fixed**.
- «Arabic text» is the UI label. Keep every label in a translation file, so V2 can add English without code changes. Appendix B collects the main strings.
- `OWN`, `OPS`, `SUP`, `FIN` and `DATA` are admin-panel roles (AP §6).
- Money examples use TRY as the base currency only to make them readable.

---

## 1. Context and principles

### 1.1 What the customer app is

The customer app is how people in Azaz order food from FOX DROP's partner restaurants (AP §1.1). With it a customer:

- picks where to deliver, and sees the restaurants that deliver there
- browses menus with real prices, delivery fees and delivery times
- places an order and pays in cash at the door
- follows the order live, from the restaurant to the door
- rates the restaurant and the captain, and reports a problem if something went wrong

### 1.2 An order from the customer's side

1. The customer opens the app and chooses a location, by GPS or on the map. Inside a service zone, they see the restaurants that deliver there.
2. They browse a restaurant and add items to the cart.
3. At checkout they sign in if they are a guest, choose the address, add notes and a code, and see the exact total. They confirm. Nothing is paid yet.
4. The restaurant accepts and the customer sees the expected arrival time. When a captain is assigned, the customer sees the captain's name and photo.
5. When the captain picks up the order, the customer follows them on the map and can call them.
6. The captain arrives. The customer pays the total in cash, in any accepted currency, and gets their change.
7. The customer rates the restaurant and the captain, and can report a problem within 24 hours.

### 1.3 Money in one paragraph (AP §8.4)

The customer pays one amount, the **customer total**: the items value, plus the delivery fee, minus any discount, rounded to the base currency's rounding unit (AP §8.4). They pay it in cash at the door, in the base currency or in any accepted currency at the order's exchange-rate snapshot (AP §8.6). Menu prices equal the prices in the restaurant itself (§9.5). The app never charges anything and has no tip field (CA C12). A compensation is a code for a next order; V1 has no wallet and no refunds (AP §3).

### 1.4 Principles (MUST)

1. **The full price before the order.** The customer sees the items value, the delivery fee, the discount and the total, with its equivalents in the other accepted currencies, before confirming. There are no hidden fees.
2. **Never accept an order we cannot deliver** (AP §1.3, principle 10). When an order cannot be placed, the app says why in plain words and keeps the cart.
3. **The server is the authority.** Prices, availability, fees, codes, the estimate and the total come from a server quote. The app never places an order with a total the customer did not see (Q10).
4. **Fast on cheap phones and weak internet.** Lists render before their extras, images are light, and commands retry safely (§4.5).
5. **Privacy.**
   - The restaurant sees the customer's first name and neighbourhood only (RA §1.4).
   - The captain sees the contact details only during the order (CA §1.4).
   - Gender and birthday stay in the admin panel (Q2).
   - The app reads location only while it is in use (§4.4).
6. **Honest status.** Every step says what is happening and who acts next. Delays, changes and problems are announced, never hidden.
7. **Few steps.** A returning customer can reorder in a few taps. Each screen has one main action.

---

## 2. Decisions

### 2.1 Owner decisions (2026-11-03)

| ID | Topic | Decision |
|---|---|---|
| U1 | Platforms | Android and iOS (iPhone). No web version for customers in V1. |
| U2 | Guest browsing | A guest can see restaurants, menus, prices and fees without an account. Sign-in is asked for only when the order is confirmed. |
| U3 | Phone numbers | Syrian (+963) and Turkish (+90) mobile numbers are both accepted. |
| U4 | Registration details | The name and the gender are required. The birthday is optional. No email is asked for. |
| U5 | Addresses | The landmark «بالقرب من» is required. The contact phone of an address may belong to another person, for example when ordering for family. A saved address's pin can be moved. A customer can order to their current location without saving an address. If the pin is more than 1 km from the customer's current location, the app asks «هل أنت متأكد من العنوان؟». |
| U6 | Closed restaurants | Shown faded at the end of lists, with «يفتح {اليوم} {الساعة}». Their menu can be browsed, but nothing can be ordered. |
| U7 | Unavailable items | Shown in place, faded, and not orderable, with «غير متوفر حالياً», or «يتوفر غداً» when the restaurant switched them off until tomorrow. Items the restaurant hid never appear. |
| U8 | Cart | One cart, from one restaurant. Adding an item from another restaurant asks whether to empty the cart and start again. |
| U9 | Minimum order | Below the restaurant's minimum, ordering is blocked with «أضف {المبلغ} لتصل إلى الحد الأدنى». There is no small-order fee. |
| U10 | Pay-in currency «سأدفع بـ» | An optional choice at checkout of the currency the customer will pay in. The captain sees it to prepare change. It does not bind the customer. |
| U11 | Codes | The customer types a code or picks one from «الأكواد المتاحة لك». The app suggests the best available code with a «تطبيق» button and never applies a code automatically. One code per order. Compensation codes appear in «أكوادي». |
| U12 | Tracking and calling the captain | The live map shows from the moment the captain picks the order up until delivery. A «اتصال بالكابتن» button works in the same period. The customer sees the captain's number on the phone's call screen, because masked numbers are not available in V1. |
| U13 | Changing the address after ordering | Not possible in the app in V1. For a small change, the customer calls the captain or support, and the captain records «الزبون طلب مكاناً آخر». For a large change, operations cancel the order and the customer orders again. |
| U14 | A new account's first order | No confirmation call from operations. The existing protections apply: the WhatsApp code, one active order for new accounts, and the block with dues after a fake order (AP §8.8). |
| U15 | Ratings | The restaurant and the captain are rated separately, within 3 days of delivery. The restaurant page shows only the average and the number of ratings. Comments are not published: the restaurant sees them without the customer's name, and admins see them. |
| U16 | Reporting a problem | Possible within 24 hours of delivery, with an optional photo. During an active order, a «مساعدة» button calls support or opens WhatsApp. |
| U17 | Price parity badge | Every restaurant page shows «نفس أسعار المحل», with a «أبلغ عن سعر مختلف» link that opens a ticket. |
| U18 | Reorder and favourites | Both in V1. «اطلب مرة أخرى» fills the cart from a past order at current prices and skips unavailable items. Favourites are for restaurants. |
| U19 | Language | Arabic only in V1. English comes in V2, as in the admin panel (AP D21). |

### 2.2 Rules set by this spec

The owner did not decide these explicitly. They follow from the decisions above or close gaps found while writing this spec. The owner may change any of them.

| ID | Rule | Why |
|---|---|---|
| Q1 | Sign-in is needed only to confirm an order and to open personal pages: orders, addresses, codes, favourites, notifications and reports. A guest can open checkout and see the quote, but cannot use codes. After sign-in, the cart and the address they filled carry over, and the quote is refreshed for the account before they confirm again (§5.1, §10.7). | U2 asks for sign-in only at confirmation. |
| Q2 | The first name is required and the last name is optional. Restaurants see the first name only (RA §8.4). Gender and birthday are visible only in the admin panel and are used for statistics (§5.3). | Privacy, and U4. |
| Q3 | A customer can be signed in on several devices at once. Changing the phone number goes through support (§5.4). | A family may share a phone or a tablet. Unlike a captain, a customer holds no cash for the platform. |
| Q4 | Sign-in codes have 6 digits (fixed) in every FOX DROP app (§5.2, AP §9.14). | Harder to guess than 4 digits, and the same in every app. |
| Q5 | When an address's contact phone is not the account's phone, the address also needs the recipient's name. The captain sees that name and calls that number (§7.3, CA §9.5). | U5 allows ordering for someone else, so the captain must know whom to ask for. |
| Q6 | A saved address outside every active zone stays saved, but cannot be used until a zone covers it again. Editing an address never changes an order already placed (§7.3). | Zones can change, and an order keeps the address it was placed with. |
| Q7 | One formula gives the delivery estimate and the promised time (AP §8.3). The customer sees a 10-minute range before ordering and an arrival time after acceptance (§8.4). | The late alert and the automatic late code count from the promised time, which no spec had defined. |
| Q8 | While a restaurant's busy mode is on, its page shows «قد يستغرق الطلب وقتاً أطول قليلاً» (§9.2, RA §7.3). | The customer should know why the time is longer. |
| Q9 | The cart is kept on the device for 24 hours (fixed). If a price, an option or availability changed in the meantime, checkout shows what changed and the customer confirms again (§10.1, §10.6). | Principle 3. |
| Q10 | «تأكيد الطلب» places the order only at exactly the total the customer saw. If anything changed, the server refuses it and the app shows the new quote (§10.6, §10.7). | No surprise totals at the door. |
| Q11 | The app asks for notification permission when the customer places their first order (§4.4). | The reason is obvious then: «لتعرف متى يصل طلبك». |
| Q12 | Cancelling an order is one tap, a reason and a confirmation, and is possible only while the order is `placed` (AP §8.3). There is no hold gesture (§11.4). | BeeOrder's 5-second hold is friction without benefit (research §11 item 8). |
| Q13 | When the restaurant reports an item unavailable after accepting, the order screen tells the customer that FOX DROP will call them now (§11.6, RA §8.12). | The customer must answer that call. |
| Q14 | The captain card shows the captain's first name, photo and vehicle type only (§11.3). | Enough to recognise the captain, without exposing more. |
| Q15 | The captain's door ping rings in the customer app. The customer can answer «أنا قادم», or «سأتصل بالمستلم» for an order with a recipient, and the captain sees the answer (§11.7, CA §9.9). | Fewer customer-not-answering escalations. |
| Q16 | A rating needs stars. Reasons and the comment are optional, and a sent rating cannot be edited (fixed). The restaurant page shows «جديد» until it has 5 ratings (fixed). The captain sees their stars and reasons, never comments; admins see comments (§12.1, CA §11.2). | Comments may identify the customer, and a few ratings are not a fair average. |
| Q17 | One problem report per order from the app (fixed), with up to 3 photos (fixed). Further contact goes through support (§12.2). | One ticket per order keeps support simple. |
| Q18 | «أبلغ عن سعر مختلف» opens a ticket of the type «سعر مختلف عن المحل», linked to the restaurant. A customer can send one per restaurant per day (fixed) (§9.5, AP §9.9.1). | U17 needs a ticket type that is not tied to an order. |
| Q19 | The best code to suggest is the eligible code with the largest discount on the current cart (§10.4). | Clear and predictable. |
| Q20 | Closing the account needs a fresh sign-in code and is not possible while an order is active (§5.6). | Prevents closing someone else's account on a borrowed phone, and closing mid-order. |
| Q21 | A customer blocked for dues sees the amount and the office's location and hours, where they pay (§5.5, AP §9.12.1). | The block lifts only when the dues are paid at the desk (AP §8.8). |
| Q22 | When a restaurant rejects an order because an item is unavailable, the app offers «اطلب بدون الأصناف غير المتوفرة», which rebuilds the cart without them (§11.9). | The customer still wants the rest of the order. |
| Q23 | After delivery, the order detail shows what the captain recorded: what they received and the change they gave. The problem list gets «مشكلة في المبلغ أو الباقي» (§11.8, §12.2). | A wrong record can be caught and reported the same day. |
| Q24 | U13's "operations cancel the order" applies before pickup only, because an order cannot be cancelled after pickup (AP §9.3.2). After pickup, the captain goes to the new place if it is inside an active zone and operations agree; otherwise the order goes to the original address (§11.10). | Failing the order instead would charge the customer fake-order dues (AP §8.9). |
| Q25 | A note to the restaurant (the order note or an item note) cannot contain a run of 7 or more digits (fixed) (§9.4, §10.3). | A phone number typed there would reach the restaurant, which must never see it (RA §1.4). |

### 2.3 Decisions in the other specs that shape this app

| Decision | Effect here |
|---|---|
| AP D3 Customer phone numbers | Only OWN, OPS and SUP see them. Restaurants never do (§1.4) |
| AP D7 Emergency stop | Browsing continues and ordering stops, with the message. Active orders get a delay notice (§4.7, §11.6) |
| AP D9 Platform hours | 24/7 by default. Each restaurant keeps its own hours (§9.2) |
| AP D19 Account deletion | Inside the app (§5.6) |
| AP D23 Customer trust | One active order for a new account, three after 3 orders delivered with a `normal` outcome (§5.5) |
| AP D25 Currencies | The total in the base currency, with equivalents in USD, TRY and SYP (§10.3) |
| AP §8.3 Self-cancel | Only while `placed` (fixed) (§11.4) |
| AP §8.3 Late timers | An apology 20 minutes after the promised time, a code at 45 minutes (§11.6) |
| AP §9.12.6 Capacity check | No order without an eligible captain nearby (§10.6) |
| RA R5 Busy | Busy mode adds minutes; the limit makes the restaurant «مشغول» (§9.2) |
| RA R13 Minimum order and coverage | Set by admins per restaurant (§8.2, §10.2) |
| RA R14 Until tomorrow | «يتوفر غداً» (§9.3) |
| RA R16 Replies to ratings | None in V1 (§12.1) |
| CA C9 Delivery confirmation | No code from the customer. The captain confirms within 200 m of the pin (§11.8) |
| CA C10 Contact | The captain can call or WhatsApp the address's contact phone during the order (§11.7) |
| CA C12 Tips | Cash only, outside the app (§1.3) |

---

## 3. Glossary

Terms from AP §3 (customer total, items value, base currency, accepted currency, exchange rate, zone, outcome, responsible party, compensation) apply unchanged.

| Term | Meaning |
|---|---|
| Guest «زائر» | Someone using the app without signing in (§5.1) |
| Pin «النقطة على الخريطة» | The exact delivery point of an address |
| Landmark «بالقرب من» | A nearby place the captain can find, for example «قرب جامع النور» |
| Contact phone «رقم التواصل» | The number the captain calls for an address. The account's phone by default (§7.3) |
| Recipient «المستلم» | The person who receives the order when the contact phone is not the account's (Q5) |
| Coverage «نطاق التوصيل» | Where a restaurant delivers, set by admins (RA R13) |
| Quote «عرض السعر» | The server's calculation of a cart for an address: lines, fee, discount, total, equivalents, estimate and problems (§10.6) |
| Delivery estimate «الوقت المتوقع» | The time an order would take, shown as a range before ordering (§8.4) |
| Promised time «موعد الوصول المتوقع» | The arrival time set when the restaurant accepts. Late alerts count from it (AP §8.3) |
| Pay-in currency «سأدفع بـ» | The currency the customer says they will pay in (U10) |
| Visible code / secret code | A code listed in the app, or one shared outside it (AP §9.11.1) |
| Personal code | A code issued to one customer: compensation or the automatic late code (AP §6.4 and AP §8.3) |

---

## 4. Platforms and technical foundations

### 4.1 Platforms

| Platform | Minimum | Notes |
|---|---|---|
| Android phone | Android 8.0 (API 26) | Full features |
| iPhone | iOS 15 | Same features |

- Both apps MUST have the same features and rules. They are one Flutter codebase, as in CA §4.1 (technology-stack §13).
- Phones, portrait. The layout MUST not break on a tablet.

### 4.2 Distribution and updates

- **Android:** Google Play, and a signed APK on the FOX DROP website for phones without Play, with the same signing certificate (as RA §4.2).
- **iPhone:** the App Store. FOX DROP's Apple Developer account is available (technology-stack T3).
- **Version check:** at launch and on every reconnect, the app compares its version with `app.customer.min_version` and `app.customer.latest_version` (AP §9.14).
  - Below the minimum, a blocking update screen appears with `app.customer.update_message`. An active order's status screen stays readable, so the customer can follow it.
  - Below the latest, a dismissible banner appears.

### 4.3 Real time and push

- **Order updates:** while an order is active and the app is open, the app subscribes to the order on a WebSocket. On reconnect it fetches the current state, so no change is missed. If the socket is down while an order screen is open, the app polls every 30 seconds (fixed).
- **Captain position:** on the map it updates as the captain app sends it, every 10 seconds (AP §4.2).
- **Push:** FCM on Android and APNs on iOS, for status changes and messages (§14). The arrival and the captain's door ping use high-priority pushes. On iPhone they are time-sensitive notifications.
- **Promotional pushes** come from the panel's mass push (AP §9.11.4).

### 4.4 Location and permissions

- **Location:** «أثناء استخدام التطبيق» (while using the app) only, never in the background (fixed). The app uses it for:
  - the first location (§7.1)
  - «التوصيل إلى موقعي الحالي» (§7.4)
  - the far-pin check, which runs on the device (§7.5)
- Every use has a map alternative. A customer who refuses location can still choose a point on the map.
- The device's position is sent to the server only to check a chosen point against the zones, or to record a vote (§7.2). It is not stored with orders.
- **Notifications (Q11):** asked when the customer places their first order: «اسمح بالإشعارات لتعرف متى يصل طلبك». If refused, the order still goes, and the order screen shows a banner with a link to the phone's settings.
- **Camera and photos:** asked only when the customer adds a photo to a report (§12.2, §9.5).

### 4.5 Weak internet and cheap phones

- **Commands** (place an order, cancel, rate, report) carry an idempotency key and retry with backoff, and are never applied twice (as CA §4.6). While waiting, the button shows «جارٍ الإرسال…» and cannot be pressed again.
- **Lists first, extras after:** restaurant lists render from cache or a light call first, and estimates and fees fill in after (research §11 item 12). Skeletons show while loading.
- **Caching:** home sections, restaurant pages and menus are cached and refreshed in the background. A changed menu replaces the cached one on the next open.
- **Images:** served in sizes that fit the screen, compressed, and cached. A report photo is compressed before upload.
- **Lost connection:** a bar shows «لا يوجد اتصال بالإنترنت». Browsing works from the cache. Placing an order needs a connection.
- **Timers** shown to the customer use server time, as in RA §4.7.

### 4.6 Formatting

As in AP §4.7:

- Arabic, right to left, with Western digits.
- Money with its symbol, for example `410 ₺` or `10.00 $`.
- Dates as `dd/mm/yyyy`, and 12-hour times with «ص/م».
- Durations as «12 د».
- Order numbers as `#10423`, and tickets as `T-5521`.

Distances show as «850 م» below 1 km and «2.4 كم» above. The app SHOULD stay usable with the system font enlarged up to 130%.

### 4.7 Maintenance, terms, platform hours and the emergency stop

- **Maintenance:** when `app.customer.maintenance` is on, a blocking screen shows the message. An active order's status screen stays readable.
- **Terms:** a new version of the customer terms (AP §9.13) is shown on the next open. Browsing continues, but ordering waits until the customer accepts it.
- **Platform hours:** outside `platform.hours` (24/7 by default, AP D9), browsing continues. The order button is disabled with «FOX DROP يستقبل الطلبات من الساعة {الساعة}».
- **Emergency stop (AP §9.1.6):**
  - Browsing continues. The order button is disabled, and a banner shows the browsing message. A customer who opens checkout during the stop counts once per stop as an attempt (AP §9.1.6).
  - Customers with an active order get a push and a banner on the order screen with the delay notice.
  - When the stop ends, the banner disappears. A push about the service being back is sent only if OPS choose to send it.

---

## 5. Account

### 5.1 Guest browsing (U2, Q1)

- **A guest can:**
  - choose a location and see the restaurants that deliver there
  - open restaurant pages and menus, with prices, fees and estimates
  - search
  - vote for an area outside the zones (§7.2)
  - build a cart
- **At checkout** a guest fills the address form for the selected point as an unsaved address (§7.4), and sees the full quote. The code field shows «سجّل الدخول لاستخدام الأكواد».
- **Sign-in is asked for** when the guest:
  - taps «تأكيد الطلب» at checkout (U2)
  - or opens «طلباتي», addresses, «أكوادي», favourites, notifications, a report, or «أبلغ عن سعر مختلف»
- **After sign-in** the customer returns to where they were:
  - the cart stays as it was
  - the address they filled is kept, and saved if they ticked «احفظ هذا العنوان»
  - at checkout, the quote is refreshed for the account. The customer sees any change, such as the active-order limit or an account block, and taps «تأكيد الطلب» again (Q10)

### 5.2 Sign-in (U3, Q4)

1. **Phone number:**
   - A country picker offers «سوريا +963» and «تركيا +90». The default is `customer.phone_default_country`.
   - Syrian mobiles have 9 digits after +963 and start with 9. The app accepts `09xxxxxxxx` and `9xxxxxxxx`.
   - Turkish mobiles have 10 digits after +90 and start with 5. The app accepts `05xxxxxxxxx` and `5xxxxxxxxx`.
   - The number is stored in E.164 format.
2. **Code:**
   - 6 digits (fixed), sent over WhatsApp, the only channel in V1 (`otp.channel_order`, technology-stack §8.3). There is no SMS or voice code.
   - A number without WhatsApp gets «هذا الرقم غير مسجّل على واتساب» and no code is sent.
   - The screen says where the code was sent: «أرسلنا الرمز إلى واتساب على الرقم {الرقم}».
   - After `otp.resend_after_sec` (60) seconds, it offers «إعادة الإرسال».
   - Validity and attempts follow `otp.validity_min` and `otp.max_attempts`. The server limits requests per number, per device and per IP address (AP Appendix A, `otp.*`). Past the daily limit: «تجاوزت عدد المحاولات المسموح، حاول غداً أو تواصل مع الدعم».
   - The code field accepts paste. On Android the app offers to paste a 6-digit code it finds on the clipboard. SMS auto-fill does not apply to WhatsApp messages.
   - «تعديل الرقم» goes back to step 1.
3. **Existing account:** signed in, and back to where the customer was.
4. **New account:** the details screen (§5.3).

### 5.3 New account details (U4, Q2)

One screen, «أكمل بياناتك»:

| Field | Rule |
|---|---|
| «الاسم» first name | Required. 2 to 30 Arabic or Latin letters, with spaces and «-» |
| «الكنية» last name | Optional. Same rule |
| «الجنس» gender | Required: «ذكر» or «أنثى» |
| «تاريخ الميلاد» birthday | Optional. A past date from a date picker. No age check in V1 |
| Terms | Required checkbox: «أوافق على الشروط وسياسة الخصوصية», with links to both (AP §9.13) |

- **Who sees what (Q2):**
  - The restaurant sees the first name (RA §8.4).
  - The captain sees the first and last name, or the recipient's name (Q5).
  - Gender and birthday appear only in the admin panel (AP §9.8). They feed the customer report (AP §9.17), and birthday offers come in V4.
- The customer can edit these fields later in «حسابي» (§13).

### 5.4 Sessions and devices (Q3)

- A session lasts until sign-out. It uses refresh tokens and does not expire with inactivity.
- A customer may be signed in on several devices. Order pushes and the door ping reach every signed-in device.
- Blocking or closing an account in the panel applies at once on every device.
- **Phone number changes:** «لتغيير رقمك تواصل مع الدعم». OPS change it in the panel (AP §9.8 «تغيير الرقم»). Every session ends, and the customer signs in again with the new number.
- **Lost or sold phone:** «تسجيل الخروج من كل الأجهزة» in «حسابي» (§13), or support does it from the panel (AP §9.8). Active orders are not affected.

### 5.5 Account states (AP §8.8, Q21)

| State | What the app shows | Browse | Order |
|---|---|---|---|
| Active, at the active-order limit (D23) | At checkout: «يمكنك طلب واحد في كل مرة حتى يكتمل طلبك الحالي» for a new account, or «وصلت إلى الحد الأقصى للطلبات الجارية» for a trusted one | Yes | Not until an active order ends |
| «موقوف حتى مراجعة الدعم» (review stop) | Banner: «حسابك موقوف حتى مراجعة فريق الدعم», with call and WhatsApp buttons | Yes | No |
| «محظور» for a duration | Banner: «حسابك محظور حتى {التاريخ}: {السبب}» | Yes | No |
| «محظور» until further notice | Banner: «حسابك محظور: {السبب}. تواصل مع الدعم.» | Yes | No |
| «محظور» until dues are paid | Banner: «عليك {المبلغ} لـ FOX DROP. ادفعه في المكتب ليُفك الحظر تلقائياً.» A sheet shows the office location on a map and its hours (AP §9.12.1) | Yes | No |
| «مغلق» (closed) | Signed out on every device. Signing in again with the same number creates a new account, linked to the closed one (AP §8.8) | — | — |

- The customer-facing reason comes from the block reason list (AP Appendix B), mapped in Appendix C.
- Trust itself, «موثوق», is not shown to the customer. Only its effect on the limit is shown.

### 5.6 Closing the account (AP D19, Q20)

1. «حسابي» → «حذف الحساب».
2. An explanation:
   - you will not be able to sign in
   - your codes and favourites will be lost
   - your data is handled as the privacy policy says (AP §13 item 6)
3. A fresh code sent to the phone (Q20).
4. The account becomes «مغلق», and the app signs out on every device.

- **Not possible with an active order:** «لا يمكن حذف الحساب أثناء وجود طلب جارٍ». Admins cannot close it during an active order either (AP §8.8).
- **Unpaid dues** do not prevent closing. They carry over to any new account on the same number (AP §8.8).

---

## 6. Navigation

### 6.1 Screen map

- **Bottom bar:**
  - «الرئيسية» (home)
  - «البحث» (search)
  - «طلباتي» (my orders)
  - «حسابي» (my account)
- **Floating cart button:** shows while the cart is not empty, with the item count and the items value.
- **Active-order bar:** pinned above the bottom bar on home and search while an order is active: «طلبك من {المطعم}: {الحالة}». With several active orders, it shows their count and opens a list.
- **Screens:**
  - First location, coming soon
  - Home, category, restaurant list, search
  - Restaurant page, item sheet
  - Cart, checkout, address picker, address form
  - Order status, order detail, rating, report a problem
  - Sign-in, code, account details
  - «حسابي»: profile, addresses, favourites, «أكوادي», notifications, help, terms, about, delete account

### 6.2 Banners (highest priority first)

1. Forced update or maintenance (blocking)
2. Emergency stop
3. Account state (§5.5)
4. Outside platform hours
5. Terms waiting for acceptance
6. Outside the zones (§7.2)
7. No internet

---

## 7. Location and addresses

### 7.1 First location and the zone check

- **First open:** «أين نوصل طلبك؟», with «استخدم موقعي الحالي» and «اختر على الخريطة».
- **Map:**
  - the customer moves the map under a fixed pin
  - the pin can be confirmed only at street-level zoom: zoom 16 or closer (fixed). Below that: «قرّب الخريطة لتحديد موقعك بدقة»
- **Zone check:** the server checks the point against the active zones (AP §9.12.2).
  - Inside a zone with restaurants that cover it: the home screen.
  - Inside a zone, but no restaurant covers the point: «لا توجد مطاعم توصل إلى موقعك حالياً»
  - Outside every zone: §7.2.
- **The home header** shows the current location's label, or the neighbourhood name for an unsaved point. Tapping it opens the address picker.

### 7.2 Outside the zones

- The screen shows «قريباً في منطقتك» with «صوّت لمنطقتك» (AP §9.12.2).
- A vote records the point and appears in the panel's vote map and the lost-demand report (AP §9.17).
- A device can vote once per point (fixed). The app then shows «شكراً، سنخبرك عندما نصل إلى منطقتك».
- The customer can choose another point at any time.

### 7.3 Saved addresses (U5, Q5, Q6)

| Field | Rule |
|---|---|
| Pin | Required, inside an active zone, at street-level zoom (§7.1) |
| Label | «البيت», «العمل» or «آخر» with a custom name |
| Neighbourhood «الحي» | Filled from the zone name. Read-only |
| Street and building «الشارع والبناء» | Required, 3 to 100 characters |
| Floor and apartment «الطابق والشقة» | Optional |
| Landmark «بالقرب من» | Required, 3 to 100 characters (U5). Placeholder «مثلاً: قرب جامع النور» |
| Contact phone «رقم التواصل» | The account's phone by default. May be another Syrian or Turkish mobile (U5) |
| Recipient's name «اسم المستلم» | Required only when the contact phone is not the account's (Q5) |
| Directions for the captain «توجيهات للكابتن» | Optional, up to 200 characters, for example «الباب الأزرق بجانب الصيدلية» |

- **Limits:** up to 10 saved addresses (fixed). One is the default.
- **Editing (U5):** every field can be edited, including the pin. The pin can move only inside active zones.
- **Snapshots:** an order keeps the address as it was when it was placed. Editing or deleting an address never changes an active or past order (Q6).
- **A zone that is turned off:** an address outside every active zone shows «خارج منطقة التوصيل حالياً» and cannot be chosen (Q6).
- **Deleting:** allowed, with a confirmation.

### 7.4 Deliver to my current location (U5)

- At checkout, «التوصيل إلى موقعي الحالي» takes the GPS position as the pin.
  - If the accuracy is worse than 100 m (fixed), the app asks the customer to adjust the pin on the map.
- The form is the same as §7.3, with «احفظ هذا العنوان» off by default.
- An unsaved address belongs to that order only.

### 7.5 The far-pin check (U5)

- **When:** the customer taps «تأكيد الطلب» and location permission is granted. The app requests a fresh position and waits up to 5 seconds (fixed). The check runs when the position is accurate to 100 m (fixed).
- **Check:** if the pin is farther than `customer.far_pin_warn_m` (1000) metres from the device, a dialog asks:
  - «هل أنت متأكد من العنوان؟ النقطة تبعد {المسافة} عن موقعك الحالي.»
  - with «نعم، أرسل إلى هذا العنوان» and «تغيير العنوان»
- Without permission, or without an accurate position within the 5 seconds, there is no check, and the order continues.
- The check runs on the device. Its result is not sent to the server (§4.4).

---

## 8. Finding food

### 8.1 Home

- **Sections** come from the panel in its order (AP §9.11.3):
  - «البانرات» (banners)
  - «التصنيفات» (categories)
  - «الأقرب إليك» (nearest to you)
  - «الأكثر طلباً» (most ordered)
  - «جديد على FOX DROP» (new on FOX DROP)
  - «العروض» (offers): restaurants with active visible codes
  - custom sections
- **Restaurants:** only those that deliver to the selected location appear (§8.2).
- **Banners:** a tap opens the banner's target: a restaurant, a category, a list of restaurants, or a code (AP §9.11.2). A code target opens «أكوادي» with that code shown.
- Pull to refresh.

### 8.2 Restaurant cards and lists

- **Which restaurants appear:** `active` and `visible` restaurants (AP §9.6.1) whose coverage includes the selected point (RA R13).
  - Test-mode restaurants appear only to admin test accounts, with the badge «تجريبي» (AP §9.8).
  - Suspended restaurants never appear.
- **A card shows:**
  - cover, logo and name
  - categories
  - the rating, or «جديد» (Q16)
  - the delivery estimate as a range (§8.4)
  - the delivery fee for the selected point, or «توصيل مجاني»
  - a state badge when it is not open: «مشغول», «متوقف مؤقتاً», or «مغلق — يفتح {اليوم} {الساعة}» (U6)
  - a heart for favourites (§9.6)
- **Order inside any list:**
  1. open restaurants, in the section's own order
  2. then busy and paused restaurants
  3. then closed ones, faded, at the end (U6)
- **Category page:** every restaurant of that category, in the same order.

### 8.3 Search

- One search box on «البحث», and on the home header.
- **Results:** restaurants and items, in two tabs.
  - Items show their restaurant and price.
  - Only restaurants that deliver to the selected point are searched.
  - Closed restaurants and their items come last.
- **Typing:** the search waits until typing stops.
- **Recent searches:** the last 10 (fixed), kept on the device, with «مسح».
- **No results:** «لم تجده؟ أخبرنا» opens a short form: the restaurant's name (required) and a note (optional).
  - The suggestion and the empty search feed the lost-demand report (AP §9.17).
  - The app answers «شكراً، سنحاول إضافته».

### 8.4 Delivery estimate and promised time (Q7)

The formula is shared and lives in AP §8.3. The customer sees it in two forms.

- **Before ordering** (cards, the restaurant page and checkout): a 10-minute range (fixed).
  - It starts at the estimate rounded up to 5 minutes, for example «30–40 د».
  - The estimate includes busy-mode minutes (RA §7.3).
- **While the order is `placed`:** the same range, as an indication.
- **From acceptance:** «يصل حوالي {الساعة}», which is the promised time.
  - A change by OPS updates it, with a push: «تغيّر موعد وصول طلبك إلى {الساعة}».
  - Late alerts and the automatic late code count from it (AP §8.3).

---

## 9. Restaurant page and items

### 9.1 Restaurant page

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

### 9.2 Restaurant states (U6, Q8)

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

### 9.3 Menu and availability (U7)

- **Hidden** items and categories never appear (RA §9.2).
- **Unavailable items** stay in place, faded and not orderable, with:
  - «يتوفر غداً» when the restaurant switched them off until tomorrow (RA §9.3, R14)
  - «غير متوفر حالياً» otherwise
- **A category outside its availability window** (for example breakfast until 12:00) shows its items faded with «متوفر من {الساعة}».
- **Unavailable options** appear faded inside their group and cannot be picked.
- An item whose required option group has no available option is unavailable (RA §9.3).
- **Prices:** an item shows its price. If a required group changes the price, it shows «من {أقل سعر}».

### 9.4 Item sheet

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

### 9.5 Price parity (U17, Q18)

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

### 9.6 Favourites (U18)

- A heart on restaurant cards and pages. A guest is asked to sign in.
- «حسابي» → «المفضلة» lists the favourite restaurants with their current state and estimate, and only those that deliver to the selected point.
- Favourites belong to the account, so they appear on every device.

---

## 10. Cart and checkout

### 10.1 Cart (U8, Q9)

- **One restaurant:** adding an item from another restaurant asks:
  - «سلتك فيها أصناف من {المطعم}. هل تفرغها وتبدأ سلة جديدة من {المطعم الجديد}؟»
  - with «سلة جديدة» and «إلغاء»
- **Each line:** quantity with «−» and «+», «تعديل» (reopens the item sheet), and removal.
- **Kept on the device:** for 24 hours (fixed) after the last change. After that it empties with «انتهت صلاحية سلتك».
- **Changes since adding:** the cart and checkout show them before the customer can confirm (§10.6):
  - an unavailable item, with a remove button
  - a new price: «تغيّر سعر {الصنف} من {القديم} إلى {الجديد}»
  - a removed option
- **«متابعة»** (continue) leads to checkout. A guest signs in at «تأكيد الطلب» (§5.1).

### 10.2 Minimum order and free delivery (U9)

- **Minimum order:** set per restaurant by admins (RA R13), compared with the items value before discounts.
  - Below it: «أضف {المبلغ} لتصل إلى الحد الأدنى ({الحد})», with a progress bar, and «متابعة» disabled (U9).
- **Free delivery:** when the restaurant has a threshold (AP §9.12.3), compared with the items value:
  - below it: «أضف {المبلغ} لتحصل على توصيل مجاني», with a progress bar
  - at or above it: «توصيلك مجاني»
- Neither threshold is re-checked after the order is placed (AP §9.3.3).

### 10.3 Checkout

From top to bottom:

1. **Address:**
   - preselected from the point the customer browsed with: that saved address, or else a saved address within 200 m (fixed) of the point, or else the point itself as an unsaved address to complete (§7.4)
   - «تغيير», «إضافة عنوان» and «التوصيل إلى موقعي الحالي» (§7). Changing the address here also changes the point used for browsing.
   - the recipient and contact phone, when they are not the account's
2. **Notes:**
   - preset chips from Content (AP §9.13, Appendix C)
   - a free note to the restaurant and the captain, up to 200 characters (fixed). A note with a run of 7 or more digits is refused: «لا تكتب أرقام هواتف في الملاحظة. رقم التواصل يصل إلى الكابتن تلقائياً.» (Q25)
3. **«سأدفع بـ»** (§10.5).
4. **Code** (§10.4).
5. **Payment:** «نقداً عند الاستلام» (cash on delivery), the only method in V1.
6. **Estimate:** «يصل خلال {الحد الأدنى}–{الحد الأعلى} د».
7. **Money:**
   - «قيمة الأصناف» (items value)
   - «رسوم التوصيل» (delivery fee), or «مجاني»
   - «الخصم» (discount), with the code
   - «تقريب» (rounding), only when it is not 0 (AP §8.4)
   - «المجموع» (total) in the base currency
   - under it: «أو {المبلغ} $ · {المبلغ} ل.س» and so on, one equivalent per accepted currency, each rounded by its own rule (AP §8.6)
8. **«تأكيد الطلب — {المجموع}».**

### 10.4 Codes (U11, Q19)

- **Entering:** «أدخل الكود» and «تطبيق». Visible and secret codes both work.
- **«الأكواد المتاحة لك»:** a list of the visible codes this customer is eligible for, and their personal codes (§12.4). Each shows its value, its conditions and its expiry.
- **Suggestion (Q19):** when an eligible code would give a discount, a line shows «لديك كود يوفر عليك {المبلغ}: {الكود}» with «تطبيق».
  - It suggests the code with the largest discount on the current cart.
  - It never applies a code by itself (U11).
- **One code per order** (AP §9.11.1). Applying another replaces it, after a confirmation. «إزالة» removes it.
- **Caps (AP §8.4):** a code never takes the total below 0. When a fixed-amount code is larger than the items value, checkout warns before confirming: «قيمة الكود أكبر من قيمة الأصناف، ولا يُستعاد الفرق».
- **Given back:** a code used on an order that ends rejected, cancelled, or failed without the customer at fault returns to «متاحة» (AP §9.11.1), with «أُعيد الكود {الكود} إلى أكوادك».
- **Validation** is on the server, with every rule in AP §9.11.1. A refused code shows the reason (Appendix C), for example:
  - «هذا الكود للطلب الأول فقط»
  - «أضف {المبلغ} لاستخدام هذا الكود»
- **When a code stops working** between quote and confirmation (for example its daily budget ran out), the quote shows it. The customer confirms again without it, or with another code.

### 10.5 «سأدفع بـ» (U10)

- **Choices:** chips for each accepted currency, plus «لم أحدد» (not set), which is the default.
- **Choosing a currency** shows the total in it: «ستدفع حوالي {المبلغ} {العملة}».
- **The choice is saved on the order.** The captain sees it (CA §9.5) and the panel shows it (AP §9.3.1).
- **It is not binding.** The customer can pay in any accepted currency, and the captain records what they actually received (CA §9.7).
- The app remembers the last choice on the device.

### 10.6 The quote and the pre-order checks (Q9, Q10)

- **When the app asks for a quote:** every time the cart, the address or the code changes, and on opening checkout.
- **The quote contains:**
  - each line with its current price and availability
  - the items value, the delivery fee, the discount, the rounding and the total
  - the equivalents in each accepted currency
  - the estimate range
  - the minimum-order and free-delivery status
  - a list of problems
  - the exchange-rate version
  - a quote version, which changes only when a money line, an equivalent, the exchange rates or a blocking problem changes. A new estimate alone does not change it.
- **Problems that block ordering** show at the top of checkout with the action to fix each. The texts are in Appendix C.

  | Check | Source |
  |---|---|
  | App version, maintenance, terms accepted | §4.2, §4.7 |
  | Platform hours and emergency stop | §4.7 |
  | Account state and the active-order limit | §5.5 |
  | Point inside an active zone and inside the restaurant's coverage | §7, §8.2 |
  | Restaurant can take orders, including its maximum active orders | §9.2, RA §7.4 |
  | Every item and option available, prices accepted | §9.3, §10.1 |
  | Minimum order | §10.2 |
  | Code valid (otherwise the order can go without it) | §10.4 |
  | An eligible captain nearby (capacity check) | AP §9.12.6 |

- **The capacity check** is part of every quote while `dispatch.capacity_check` is on. A refusal shows «الضغط عالٍ الآن، جرّب بعد دقائق». It is logged as lost demand once per checkout session, which runs from opening checkout until the customer leaves it or places the order (AP §9.12.6).

### 10.7 Placing the order (Q10, Q11)

1. The customer taps «تأكيد الطلب — {المجموع}».
2. A guest signs in here (§5.1), and returns to checkout with the refreshed quote.
3. The far-pin check runs (§7.5).
4. On the first order only, the notification permission is asked (Q11).
5. **The command** carries the quote version, the address snapshot, the notes, the pay-in currency, the code and an idempotency key.
6. **The server re-runs every check atomically** (AP §1.3 principle 10, RA §7.4). Two customers can never take a restaurant's last place, and a new account can never place two orders at once.
   - **Everything still matches:** the order becomes `placed`, with the quote's exchange rates as its snapshot (AP §8.6). The cart empties, and the app opens the order screen with «أرسلنا طلبك إلى {المطعم}».
   - **The total, a line or an exchange rate changed:** the server refuses, and the app shows the new quote with what changed. The customer confirms again (Q10).
   - **A blocking problem appeared:** the server refuses, and the app shows the problem. The cart stays.
7. **While sending:** «جارٍ إرسال طلبك…». The button cannot be pressed twice, and leaving the screen does not cancel the command.

---

## 11. The active order

### 11.1 Order screen

- **Top:**
  - the status title and subtitle (§11.2)
  - a five-step progress bar: «تأكيد المطعم» · «التحضير» · «في الطريق» · «عند الباب» · «التسليم»
- **Time:** the estimate range while `placed`, then «يصل حوالي {الساعة}» (§8.4).
- **Captain card:** from assignment (§11.3).
- **Map:** from pickup (§11.3).
- **Banners:** emergency delay, item unavailable, edited order, late apology (§11.6).
- **Summary:**
  - the restaurant
  - the items with options and notes
  - the address
  - the total, with its equivalents
  - the pay-in currency, when chosen
- **Buttons:**
  - «مساعدة» (§11.5)
  - «إلغاء الطلب», while `placed` only (§11.4)

### 11.2 Statuses and texts

The labels follow the "What the customer sees" column of AP §8.1. The order screen also shows the captain's progress, and the captain's own track (AP §8.2) is never shown as such.

| Moment | Title | Subtitle | Push |
|---|---|---|---|
| `placed` | «بانتظار تأكيد المطعم» | «أرسلنا طلبك إلى {المطعم}» | — |
| `accepted` | «المطعم يحضّر طلبك» | «يصل حوالي {الساعة}» | Yes |
| Captain assigned (before pickup) | Unchanged | «الكابتن {الاسم} في طريقه إلى المطعم» | Yes |
| Captain at the restaurant | Unchanged | «الكابتن {الاسم} وصل إلى المطعم» | — |
| `ready` | «طلبك جاهز» | «ينتظر الكابتن», or «الكابتن يستلم طلبك الآن» when the captain is there | — |
| `picked_up` | «في الطريق إليك» | «الكابتن {الاسم} استلم طلبك» | Yes |
| `arrived` | «الكابتن عند الباب» | «جهّز {المبلغ}» | Yes, high priority |
| `delivered` | «تم التسليم» | «بالعافية!» | Yes |
| `rejected`, `cancelled`, `failed` | §11.9 | §11.9 | Yes |

- **Pickup request:** while the captain's pickup request is pending (`pickup_pending`), the customer still sees the restaurant step.
- **Reassignment before pickup:** the captain card changes to the new captain with «تغيّر الكابتن: {الاسم} في طريقه إلى المطعم».
- **Handover after pickup** (AP §9.3.2): the card changes with «تغيّر الكابتن: {الاسم} يكمل توصيل طلبك». The map follows the new captain from their receipt.
- **A free re-delivery order** (AP §9.9.3) appears as its own order, «إعادة توصيل مجانية لطلب #{رقم}», with a total of 0 and the same screens. It goes to the original order's address. The customer cannot cancel or rate it, and it does not count toward the active-order limit or trust.

### 11.3 The captain and the map (U12, Q14)

- **Captain card (Q14):** from assignment, the captain's first name, photo and vehicle type («دراجة نارية», «سيارة», «دراجة» or «سيراً على الأقدام»).
- **Map:** from `picked_up` until the order ends (U12).
  - It shows the captain's live position, the delivery pin and, when the routing service is available, the route line.
  - Before pickup there is no map, only the text steps.
- **«اتصال بالكابتن»:** from `picked_up` until the order ends (U12).
  - It opens the phone's dialer with the captain's number. The app never prints the number.
  - The customer sees the number on the call screen; this is accepted in V1 (U12).
  - Each tap is recorded in the order timeline (AP §9.3.1).
  - The button disappears when the order ends.

### 11.4 Cancelling (AP §8.3, Q12)

- **While `placed`:**
  1. «إلغاء الطلب».
  2. A reason from the self-cancel list (AP Appendix B), with optional text for «سبب آخر».
  3. «نعم، ألغِ الطلب».

  The order becomes `cancelled`. The restaurant's prompt closes (RA §8.3). There is no strike.
- **Race with acceptance:** if the restaurant accepted in the meantime, the server refuses: «قبل المطعم طلبك قبل لحظات. لإلغائه تواصل مع الدعم.»
- **After acceptance:**
  - The cancel button is replaced, inside «مساعدة», by «لإلغاء الطلب تواصل مع الدعم».
  - The sheet warns: «الإلغاء بعد قبول المطعم يُحتسب عليك، وتكراره قد يوقف حسابك مؤقتاً.»
  - Support cancels in the panel (AP §9.3.2), and the late-cancellation strike applies when the customer is responsible (AP §8.8).

### 11.5 Help during an order (U16)

«مساعدة» opens a sheet with:

- «اتصال بالدعم» (call support)
- «واتساب الدعم» (WhatsApp support), with the message prefilled: «بخصوص الطلب #{رقم}»
- «الأسئلة الشائعة» (FAQ)
- «تريد تغيير العنوان؟», which explains U13 (§11.10)
- «إلغاء الطلب» while `placed`, or the explanation in §11.4 after that

Support's numbers come from Content (AP §9.13). There is no in-app ticket during an active order; support staff open a manual ticket when needed (AP §9.9.1).

### 11.6 Changes by the restaurant or operations (Q13)

| Change | What the customer sees |
|---|---|
| Item unavailable after acceptance (RA §8.12) | A push with sound and a banner: «المطعم أبلغ أن صنفاً في طلبك غير متوفر. سيتصل بك فريق FOX DROP الآن.» The banner clears when operations edit or cancel the order or close the report, or when the restaurant withdraws the report (RA §8.12). |
| Edit by operations (AP §9.3.3) | A push: «عدّلت FOX DROP طلبك. المجموع الجديد: {المبلغ}». The summary marks added items «أُضيف», strikes removed items «حُذف», shows quantity changes, and shows the new total. No approval is asked in the app, because operations agree it by phone. |
| Prep or promised time changed | «تغيّر موعد وصول طلبك إلى {الساعة}» |
| Late, 20 minutes past the promised time (AP §8.3) | A push and a banner: «نعتذر، طلبك متأخر قليلاً. نتابعه الآن.» |
| Late, 45 minutes past the promised time | A push: «تأخر طلبك، وهذا كود خصم {القيمة} لطلبك القادم: {الكود}». The code is in «أكوادي». |
| Emergency stop | A push and a banner with the delay notice (AP §9.1.6) |
| Outcome with an amount to collect (AP §9.3.2 «تحديد النتيجة») | The order screen updates the amount: «المبلغ المطلوب الآن: {المبلغ}», or «لن تدفع شيئاً لهذا الطلب» |

### 11.7 The captain at the door (Q15)

- **Arrival:** a high-priority push, «الكابتن عند الباب», time-sensitive on iPhone. The order screen shows the amount due large, with its equivalents.
- **The captain calls** the address's contact phone (CA §9.5). When the order is for someone else, the recipient gets the call.
- **The door ping** («تنبيه الزبون», up to `customer.no_answer_pings` (3) times, CA §9.9) reaches every signed-in device of the account:
  - **App open:** a full-screen alert that rings for 30 seconds (fixed): «الكابتن عند الباب ويحاول الوصول إليك», with «أنا قادم» and «اتصال بالكابتن».
  - **App closed:** a push with sound, time-sensitive on iPhone.
- **«أنا قادم»** sends a reply. The captain sees «الزبون رأى التنبيه وهو قادم» (CA §9.9). The reply does not stop the captain's no-answer timer.
- **An order for someone else** (Q5): the arrival push says «الكابتن عند باب {المستلم}. المبلغ المطلوب {المبلغ}». The ping alert says «الكابتن عند الباب ويحاول الوصول إلى {المستلم}», and its reply button is «سأتصل بالمستلم», which the captain sees as «الزبون يتواصل مع المستلم».

### 11.8 Delivery and payment (Q23)

- **Paying:** the customer pays the captain the total in cash, in one or more accepted currencies. The captain gives change and records both (CA §9.7).
- **After «تم التسليم»:** the order screen shows «تم التسليم» and opens the rating sheet (§12.1).
- **Order detail (Q23)** shows what the captain recorded: «استلم الكابتن: {المبالغ}» and «أعاد لك: {المبالغ}».
- **If the record is wrong**, the customer reports «مشكلة في المبلغ أو الباقي» within 24 hours (§12.2). When the customer got less change than recorded, they get the difference back as a code or in person through the captain (AP §8.10).
- **A collection shortfall** that OPS charge to the customer becomes dues of the missing amount only, with a block until it is paid, and no strike (AP §8.6 and AP §8.8). The customer then sees the dues banner (§5.5).

### 11.9 Orders that do not complete (Q22)

| Case | What the customer sees |
|---|---|
| Rejected by the restaurant (RA §8.6) | «نعتذر، لم يقبل المطعم طلبك», with the customer-facing reason (Appendix C), and up to 5 similar restaurants: open, same category, delivering to the pin. For «صنف غير متوفر», also «اطلب بدون الأصناف غير المتوفرة», which rebuilds the cart without those items (Q22). |
| Cancelled for no restaurant response (AP §8.3) | «لم يرد المطعم على طلبك، نعتذر», with similar restaurants |
| Cancelled by operations | «أُلغي طلبك», with the customer-facing reason (Appendix C), and the compensation code when one was given |
| Cancelled by the customer | «ألغيت طلبك» |
| Failed after pickup (AP §8.9) | «تعذّر التسليم», with the reason. For a `fake` outcome, the dues banner applies (§5.5). |
| Delivered as `free`, or `damaged` with a reduction | «تم التسليم», with «لم تدفع شيئاً لهذا الطلب» or the reduced amount |

- The cart was emptied when the order was placed (§10.7). «اطلب بدون الأصناف غير المتوفرة» and «اطلب مرة أخرى» (§12.3) rebuild it, and ask first when the current cart is not empty.
- A code used on a rejected, cancelled or failed order comes back when the customer was not at fault (§10.4).

### 11.10 Changing the address after ordering (U13)

- There is no edit in the app.
- **Before pickup:**
  - a small change: the customer calls support, who tells the captain. The captain delivers to the new place.
  - a large change: operations cancel the order (AP §9.3.2), and the customer orders again. After acceptance this is a cancellation at the customer's request, so the late-cancellation rule applies (AP §8.8).
- **After pickup** (Q24): the order cannot be cancelled. The customer calls the captain or support.
  - If the new place is inside an active zone and operations agree, the captain delivers there. The amounts do not change. OWN or FIN MAY add a bonus for the captain's extra distance (AP §8.5.2).
  - Otherwise the order goes to the original address.
- In every case the captain records «الزبون طلب مكاناً آخر» (CA §9.6).
- The help sheet explains this (§11.5).

---

## 12. After the order

### 12.1 Ratings (U15, Q16)

- **When:** the rating sheet opens once after delivery. Afterwards it is available from the order detail for `customer.rating_window_days` (3) days.
- **Which orders:** delivered orders only, whatever the outcome. Failed and cancelled orders and free re-deliveries cannot be rated.
- **Two parts on one screen, rated separately:**
  - «قيّم المطعم» (rate the restaurant)
  - «قيّم الكابتن» (rate the captain): the captain who delivered, after a handover
- **Each part has:**
  - stars from 1 to 5 (required to send that part)
  - reason chips for the chosen stars (Content; defaults in AP Appendix B)
  - a comment, up to 300 characters (optional)
- The customer can send one part and skip the other. A sent part cannot be edited (Q16).
- **Who sees what:**

  | Viewer | Sees |
  |---|---|
  | Customers | The restaurant's average and number of ratings, or «جديد» until it has 5 ratings (Q16). Nothing about captains. |
  | The restaurant | Stars, reasons and comments, without the customer's name (RA §13) |
  | The captain | Their average, and reasons with counts. No comments (CA §11.2) |
  | Admins | Everything, in the restaurant, captain and customer profiles (AP §9.6.4, AP §9.7.4 and AP §9.8) |

- **No replies** to ratings in V1 (RA R16).

### 12.2 Reporting a problem (U16, Q17, Q23)

- **«الإبلاغ عن مشكلة»** is on the detail of a delivered order, for `customer.report_problem_window_hours` (24) hours after delivery.
- **The form:**

  | Field | Rule |
  |---|---|
  | Type | One of the customer problem list (AP Appendix B): «صنف ناقص» · «صنف خطأ» · «الطعام بارد» · «الطلب تالف» · «تأخير» · «سلوك الكابتن» · «مشكلة في المبلغ أو الباقي» · «أخرى» |
  | Items | Required for «صنف ناقص», «صنف خطأ» and «الطلب تالف»: picked from the order's lines, with the quantity |
  | Note | Optional, up to 300 characters. Required for «أخرى» |
  | Photos | Optional, up to 3 (fixed) |

- **Sending** creates a ticket in the panel (AP §9.9.1), resolved within `support.resolution_post_delivery_hours` (24) hours. The app answers «استلمنا بلاغك T-{رقم}. سنرد عليك خلال 24 ساعة.»
- **One report per order** (Q17). After that, the order shows «بلاغك T-{رقم}: {الحالة}».
- **On resolution** (AP §9.9.3):
  - the customer gets the resolution message as a push, and it appears on the order
  - a compensation code goes to «أكوادي»
  - a free re-delivery appears as a new active order (§11.2)
- **Outside the window**, or for a failed or cancelled order, the detail shows «تواصل مع الدعم» with call and WhatsApp.

### 12.3 «طلباتي» and reorder (U18)

- **The list:** active orders first, then past orders, newest first, loaded in pages. Each shows the restaurant, the date, the status and the total.
- **The order detail:**
  - the items with options and notes, and the marks of edits by operations
  - the money lines: items value, delivery fee, discount, rounding when not 0, and total
  - the pay-in currency, and what the captain recorded (Q23)
  - the address used
  - the captain's first name
  - a short timeline
  - a link to the re-delivery order, if any
  - the actions: rate (§12.1), report a problem (§12.2), «اطلب مرة أخرى»
- **«اطلب مرة أخرى»** (U18):
  - available on delivered, rejected and cancelled orders (not on free re-deliveries), while the restaurant is visible
  - it rebuilds the cart from the restaurant's current menu at current prices, after confirming that the current cart will be replaced
  - lines whose item or options are no longer available are skipped and listed: «لم نضف: {الأصناف} لأنها غير متوفرة»
  - item notes are copied; the code is not
  - if the restaurant cannot take orders now, the cart is still built, and checkout shows the state (§9.2)

### 12.4 «أكوادي» (my codes)

- **«متاحة» (available):**
  - personal codes: compensation and automatic late codes
  - the visible codes this customer is eligible for. A new-user code is shown only to an account that is still a new user (AP §9.11.1).
- **Each code shows:**
  - its value
  - its conditions: minimum order, restaurants, zones, hours
  - its expiry, «ينتهي {التاريخ}»
  - the uses left
  - «استخدم», which opens the restaurant when the code is for one restaurant, and home otherwise
- **«منتهية» (used or expired):** codes used or expired in the last 30 days (fixed). A use that is given back (§10.4) returns the code to «متاحة» if it has not expired.
- **A new personal code** arrives with a push (§14).

---

## 13. «حسابي» (my account)

| Item | Content |
|---|---|
| Profile | First name, last name, gender, birthday (editable, §5.3). The phone is read-only: «لتغيير رقمك تواصل مع الدعم» |
| «عناويني» | Saved addresses (§7.3) |
| «المفضلة» | Favourite restaurants (§9.6) |
| «أكوادي» | §12.4 |
| «الإشعارات» | Every push the account received in the last 30 days (fixed), newest first. A tap opens its target. |
| «المساعدة» | FAQ (customer set, AP §9.13), «واتساب الدعم», «اتصال بالدعم» |
| «انضم إلينا» | «انضم ككابتن», which opens the captain app's store page, and «أضف مطعمك», which opens WhatsApp to support with «أريد إضافة مطعمي إلى FOX DROP» |
| «الشروط والخصوصية» | The current versions (AP §9.13) |
| «عن التطبيق» | The version number |
| «تسجيل الخروج» | Signs out this device |
| «تسجيل الخروج من كل الأجهزة» | Signs out every device of the account, for example after losing a phone (§5.4) |
| «حذف الحساب» | §5.6 |

---

## 14. Notifications

| # | Event | Sound | Text |
|---|---|---|---|
| 1 | Restaurant accepted | Default | «المطعم يحضّر طلبك. يصل حوالي {الساعة}» |
| 2 | Captain assigned | Default | «الكابتن {الاسم} في طريقه إلى المطعم» |
| 3 | Picked up | Default | «طلبك في الطريق إليك مع {الاسم}» |
| 4 | Captain arrived | High priority (time-sensitive on iPhone) | «الكابتن عند الباب. جهّز {المبلغ}», or the recipient text (§11.7) |
| 5 | Door ping | Ring, high priority | «الكابتن عند الباب ويحاول الوصول إليك», or the recipient text (§11.7) |
| 6 | Delivered | Default | «تم التسليم. قيّم طلبك» |
| 7 | Rejected | Default | «نعتذر، لم يقبل {المطعم} طلبك: {السبب}» |
| 8 | Cancelled (no response, operations) | Default | «أُلغي طلبك: {السبب}» |
| 9 | Failed | Default | «تعذّر تسليم طلبك: {السبب}» |
| 10 | Item unavailable reported | Default | «صنف في طلبك غير متوفر. سيتصل بك فريق FOX DROP الآن» |
| 11 | Order edited | Default | «عدّلت FOX DROP طلبك. المجموع الجديد: {المبلغ}» |
| 12 | Time changed | Default | «تغيّر موعد وصول طلبك إلى {الساعة}» |
| 13 | Captain changed | Default | «تغيّر الكابتن: {الاسم} يكمل طلبك» |
| 14 | Late apology | Default | «نعتذر، طلبك متأخر قليلاً. نتابعه الآن» |
| 15 | Late code | Default | «تأخر طلبك، وهذا كود خصم لطلبك القادم: {الكود}» |
| 16 | Compensation code | Default | «لك كود تعويض {القيمة}: {الكود}» |
| 17 | Ticket resolved (problem or price report) | Default | «تم الرد على بلاغك T-{رقم}» |
| 18 | Emergency delay notice | Default | The delay notice (AP §9.1.6) |
| 19 | Service back after an emergency stop (only if OPS send it) | Default | The OPS text |
| 20 | Account blocked, unblocked or closed | Default | With the reason (§5.5) |
| 21 | Dues paid, block lifted | Default | «تم استلام {المبلغ}. حسابك فعّال من جديد» |
| 22 | Mass push (AP §9.11.4) | Default | The campaign text |

- Rows 1 to 15 open the order. Rows 16 and 21 open «أكوادي» or the account. Row 22 opens its target.
- Texts come from Content templates (AP §9.13). The texts above are the defaults.
- Every push is also stored in «الإشعارات» (§13).

---

## 15. Server commands

Every command carries an idempotency key (§4.5), is checked on the server against the account's state and the order's state, and returns the new state.

| Command | Allowed when | Effect |
|---|---|---|
| Check a point | Any time | Zone, coverage and the list of restaurants (§7.1) |
| Vote for an area | Point outside every zone, once per device per point | Vote recorded (§7.2) |
| Request a code / verify a code | Not signed in | Session, or the new-account step (§5.2) |
| Complete the account | New account | Name, gender, birthday and terms recorded (§5.3) |
| Update the profile | Signed in | Fields updated (§13) |
| Add, edit or delete an address | Signed in, pin inside an active zone | Address saved (§7.3) |
| Get a quote | Any time | The quote (§10.6) |
| Place an order | Signed in, the quote version is current, every check passes | `placed` (§10.7) |
| Cancel an order | Own order, `placed` | `cancelled` (§11.4) |
| Reveal the captain's number | Own order, `picked_up` or `arrived` | The number for the dialer only; the tap is recorded (§11.3) |
| Answer a ping («أنا قادم» or «سأتصل بالمستلم») | Own order, `arrived`, after a ping | The captain is told (§11.7) |
| Rate | Own delivered order, within the window, part not yet rated | Rating stored (§12.1) |
| Report a problem | Own delivered order, within the window, no report yet | Ticket created (§12.2) |
| Report a price | Signed in, not yet today for this restaurant | Ticket created (§9.5) |
| Suggest a restaurant | Any time | Lost-demand entry (§8.3) |
| Add or remove a favourite | Signed in | Favourites updated (§9.6) |
| Accept terms | A pending version | Recorded (§4.7) |
| Register the push token | Every launch | Token stored for this device |
| Sign out | Signed in | This device's session ends |
| Sign out every device | Signed in | Every session of the account ends (§5.4) |
| Close the account | No active order, fresh code | `مغلق` (§5.6) |

**Real-time events** the app subscribes to, on its order and account channels:

- order status, captain assignment and change, captain position (after pickup)
- edits, time changes, item-unavailable reports opened and closed, outcomes and amounts to collect
- door pings
- account state changes, new codes, ticket resolutions
- platform broadcasts: emergency stop, maintenance, version

---

## 16. Changes made to the other specs

### 16.1 Admin panel spec (`docs/v1/admin-panel.md`)

1. **Header, AP §0 and AP §1.1:** the customer spec is linked.
2. **AP §8.3:** a new paragraph defines the delivery estimate and the promised time (Q7), with the new keys `order.eta_buffer_min` and `order.eta_speed_kmh`.
3. **AP §9.3.1:** the customer section of the order detail shows the pay-in currency (U10), and the recipient's name and contact phone when they are not the account's (Q5).
4. **AP §9.8:** the customer profile shows the gender and the birthday (U4).
5. **AP §9.9.1:** customer reports are possible within 24 hours of delivery, one per order (U16, Q17). A new source: «أبلغ عن سعر مختلف» creates a ticket of the type «سعر مختلف عن المحل», linked to the restaurant (U17, Q18).
6. **AP §9.12.1:** the office location and hours are also shown to customers blocked for dues (Q21).
7. **AP §9.13 and AP Appendix B:**
   - default rating reasons per star group
   - default preset order notes
   - «مشكلة في المبلغ أو الباقي» in the customer problem list (Q23)
8. **AP §9.14:** sign-in codes have 6 digits in every app (Q4).
9. **AP §9.17:** the customers report splits by gender and age band when known.
10. **AP Appendix A:** the new keys of Appendix A here.
11. **AP §14:** a customer-integration item.
12. **Money and codes:**
    - AP §8.4: discounts are capped, so the customer total is never below 0.
    - AP §8.6: the confirmed quote's exchange rates become the order's snapshot; a collection shortfall charged to the customer is dues of the missing amount only, without the fake-order rule or a strike.
    - AP §9.11.1: a code use is held at placement and given back when the order ends rejected, cancelled, or failed without the customer at fault. A "new user" has no delivered order.
    - AP §9.12.3: the free-delivery threshold is compared with the items value, at or above it.
13. **Tickets:**
    - AP §8.10 and AP §6.4: a wrong-change rule for «مشكلة في المبلغ أو الباقي», with an uncapped code.
    - AP §9.9.3: resolutions for price-difference tickets. A free re-delivery goes to the original address, cannot be cancelled or rated, and counts toward neither the active-order limit nor trust.
14. **Customers module and closure:** AP §9.8 adds «تغيير الرقم» and «تسجيل الخروج من كل الأجهزة»; AP §8.8 and AP §9.8 refuse closure during an active order.
15. **Order detail:** AP §9.3.1 masks the recipient's phone like the customer's, and the timeline records the customer's captain calls and ping answers.
16. **Lost demand:** AP §9.12.6 and AP §9.1.6 count a capacity refusal once per checkout session, and an emergency-stop attempt once per customer per stop.
17. **Smaller alignments:** AP §8.3 (self-cancel after acceptance goes through support by call or WhatsApp), AP §9.13 (customer-facing reason texts in Content), AP §10 (the customer is told about a handover).

### 16.2 Restaurant app spec (`docs/v1/restaurant-app.md`)

1. Header: the customer spec is linked.
2. RA §7.3: the busy-mode note is shown to customers (Q8).
3. RA §8.6 and RA §9.3: the customer-app references point to §11.9 and §9.3 here.
4. RA §8.12: the customer is told that FOX DROP will call (Q13).
5. RA §13: ratings no longer show the order number, so a comment cannot be traced to a customer (U15).

### 16.3 Captain app spec (`docs/v1/captain-app.md`)

1. Header: the customer spec is linked.
2. CA §9.5:
   - the captain sees the pay-in currency (U10)
   - the call and WhatsApp buttons use the address's contact phone, and the name shown is the recipient's when there is one (Q5)
   - the customer can call the captain from pickup until delivery (U12)
3. CA §9.7: the quick button of the pay-in currency comes first.
4. CA §9.9 and CA §14: the captain sees the customer's «أنا قادم» reply, or «الزبون يتواصل مع المستلم» for an order with a recipient (Q15).
5. CA §11.2: the captain never sees comments (Q16).
6. CA §9.10: a table row that sat after the handover list was moved back into the table.

---

## 17. Not in the customer app V1

| Feature | Version |
|---|---|
| A web version for customers | Not planned yet (U1) |
| Scheduled orders and self-pickup | V2 |
| In-app chat with support | V2 |
| Changing the address of an active order in the app | V2 |
| Masked calls between customer and captain | V2 |
| A delivery code given to the captain | V2 |
| Photos in ratings, published comments | V2 |
| «أخبرني عندما يفتح» (notify me when a restaurant opens or an item is back) | V2 |
| Favourite items, share links to restaurants | V2 |
| English UI and dark theme | V2 |
| Supermarkets and stores, several carts at once | V3 |
| Loyalty points, referral and invite codes, birthday offers | V4 |
| Online payment, wallet, in-app tips | V5 |
| Gift orders paid from abroad | V5 |

---

## 18. Open items (these do not block the build)

1. **Store availability in Syria.** *Closed* (technology-stack T3, 2026-11-04): the Apple Developer, Google Play and Firebase accounts are available. Store review requirements are handled at submission. The APK on the website serves phones without Google Play.
2. **Phone numbers in Azaz.** Check which numbers customers use most, Turkish or Syrian, to set `customer.phone_default_country`. Test WhatsApp code delivery to both.
3. **Maps for customers.** *Decided* (technology-stack §7.2): MapLibre with OpenStreetMap tiles; place search is not needed in V1. Before launch, check the OSM map quality of Azaz's neighbourhoods; if it is clearly weaker than Google Maps, the pin screen may use Google Maps for display only.
4. **Privacy policy.** It must say that gender and birthday are collected and why, and what happens to data after account closure (AP §13 item 6).
5. **Push in Azaz.** The Firebase account is available (technology-stack T3). As RA §21 item 2: still test FCM and APNs delivery on real devices and networks.
6. **Neighbourhood names.** Name the zones as people in Azaz name their neighbourhoods, because customers see the zone name in addresses and restaurants see it on orders.

---

## 19. Definition of done (customer app V1)

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

---

## Appendix A. Settings

New settings introduced by this spec. They are also listed in AP Appendix A. Scope: **C** per city.

| Key | Default | Scope | Edit | Description |
|---|---|---|---|---|
| `customer.phone_default_country` | Before launch | C | OWN | Country preselected on the sign-in screen: SY or TR (U3) |
| `customer.far_pin_warn_m` | 1000 | C | OWN | Distance between the pin and the device above which the app asks to confirm the address (U5) |
| `customer.rating_window_days` | 3 | C | OWN | Days after delivery during which the order can be rated (U15) |
| `customer.report_problem_window_hours` | 24 | C | OWN | Hours after delivery during which a problem can be reported in the app (U16) |
| `order.eta_buffer_min` | 10 | C | OWN | Minutes added to prep and trip time for the captain's arrival at the restaurant and the handover at the door (Q7) |
| `order.eta_speed_kmh` | 20 | C | OWN | Average speed used to turn the trip distance into minutes (Q7) |

**Existing settings this app uses** (AP Appendix A):

- `platform.hours`, `platform.emergency_default_message_browse`, `platform.emergency_default_message_active`
- `order.delivery_late_alert_min`, `order.delivery_late_compensation_min`, `order.late_compensation_value`
- `customer.no_answer_pings`, `customer.no_answer_ping_interval_min`
- `customer.new_max_active_orders`, `customer.trusted_after_delivered_orders`, `customer.trusted_max_active_orders`
- `customer.late_cancel_strikes`, `customer.late_cancel_window_days`
- `dispatch.capacity_check`, `pricing.distance_method`
- `support.resolution_post_delivery_hours`
- `finance.business_day_cutoff`
- `otp.*`, `app.customer.*`

**Fixed values in this spec:**

| Value | Fixed at |
|---|---|
| Sign-in code length | 6 digits |
| Order polling when the socket is down | Every 30 s |
| Location use | While the app is in use only |
| Street-level zoom to confirm a pin | Zoom 16 or closer |
| GPS accuracy for «موقعي الحالي» and the far-pin check | 100 m |
| Wait for a fresh position for the far-pin check | 5 s |
| Distance to preselect a saved address at checkout | 200 m |
| Digits that make a note look like a phone number | A run of 7 or more |
| Votes | One per device per point |
| Saved addresses | 10 |
| Recent searches | 10 |
| Estimate range | 10 min wide, starting at the estimate rounded up to 5 min |
| Quantity per cart line | 1 to 20 |
| Item note / order note | 100 / 200 characters |
| Cart kept on the device | 24 h after the last change |
| Door ping ring with the app open | 30 s |
| Ratings before the average is shown | 5 |
| Rating comment / report note | 300 characters |
| Problem reports per order | 1, with up to 3 photos |
| Price reports | 1 per restaurant per customer per business day |
| Notifications list and expired codes | 30 days |

---

## Appendix B. Main Arabic UI strings

| Key | Arabic |
|---|---|
| Navigation | «الرئيسية» · «البحث» · «طلباتي» · «حسابي» · «السلة» |
| Location | «أين نوصل طلبك؟» · «استخدم موقعي الحالي» · «اختر على الخريطة» · «قرّب الخريطة لتحديد موقعك بدقة» · «قريباً في منطقتك» · «صوّت لمنطقتك» · «لا توجد مطاعم توصل إلى موقعك حالياً» |
| Address | «البيت» · «العمل» · «آخر» · «الحي» · «الشارع والبناء» · «الطابق والشقة» · «بالقرب من» · «رقم التواصل» · «اسم المستلم» · «توجيهات للكابتن» · «احفظ هذا العنوان» · «خارج منطقة التوصيل حالياً» · «هل أنت متأكد من العنوان؟» |
| Sign-in | «رقم الهاتف» · «أرسلنا الرمز إلى واتساب على الرقم {الرقم}» · «إعادة الإرسال» · «هذا الرقم غير مسجّل على واتساب» · «تجاوزت عدد المحاولات المسموح، حاول غداً أو تواصل مع الدعم» · «تعديل الرقم» · «أكمل بياناتك» · «الاسم» · «الكنية» · «الجنس» · «ذكر» · «أنثى» · «تاريخ الميلاد» · «أوافق على الشروط وسياسة الخصوصية» |
| Restaurant | «جديد» · «توصيل مجاني» · «نفس أسعار المحل» · «أبلغ عن سعر مختلف» · «أوقات العمل» · «ابحث في القائمة» · «مشغول» · «متوقف مؤقتاً» · «مغلق — يفتح {اليوم} {الساعة}» · «قد يستغرق الطلب وقتاً أطول قليلاً» |
| Item | «غير متوفر حالياً» · «يتوفر غداً» · «متوفر من {الساعة}» · «إجباري» · «اختر {العدد}» · «مثلاً: بدون بصل» · «أضف — {المبلغ}» |
| Cart | «سلة جديدة» · «متابعة» · «أضف {المبلغ} لتصل إلى الحد الأدنى» · «أضف {المبلغ} لتحصل على توصيل مجاني» · «انتهت صلاحية سلتك» · «تغيّر سعر {الصنف} من {القديم} إلى {الجديد}» |
| Checkout | «قيمة الأصناف» · «رسوم التوصيل» · «الخصم» · «المجموع» · «سأدفع بـ» · «لم أحدد» · «نقداً عند الاستلام» · «أدخل الكود» · «الأكواد المتاحة لك» · «تطبيق» · «إزالة» · «تأكيد الطلب — {المجموع}» · «جارٍ إرسال طلبك…» |
| Order | «بانتظار تأكيد المطعم» · «المطعم يحضّر طلبك» · «طلبك جاهز» · «في الطريق إليك» · «الكابتن عند الباب» · «تم التسليم» · «يصل حوالي {الساعة}» · «اتصال بالكابتن» · «مساعدة» · «إلغاء الطلب» · «أنا قادم» · «سأتصل بالمستلم» |
| After | «قيّم المطعم» · «قيّم الكابتن» · «الإبلاغ عن مشكلة» · «اطلب مرة أخرى» · «لم نضف: {الأصناف} لأنها غير متوفرة» · «استلم الكابتن: {المبالغ}» · «أعاد لك: {المبالغ}» |
| Account | «عناويني» · «المفضلة» · «أكوادي» · «متاحة» · «منتهية» · «الإشعارات» · «المساعدة» · «انضم ككابتن» · «أضف مطعمك» · «تسجيل الخروج» · «تسجيل الخروج من كل الأجهزة» · «حذف الحساب» |

---

## Appendix C. Reason lists and customer-facing texts

These defaults are editable in Content: the lists in AP §9.13 and AP Appendix B, and the customer-facing texts in «نصوص الأسباب للزبون» (AP §9.13). A reason added later without a customer text shows «نعتذر، لم نتمكن من إكمال طلبك».

**Lists the customer picks from:**

| List | Values |
|---|---|
| Self-cancel (AP Appendix B) | «غيّرت رأيي» · «طلبت بالخطأ» · «العنوان خاطئ» · «سبب آخر» |
| Customer problem (AP Appendix B, with Q23) | «صنف ناقص» · «صنف خطأ» · «الطعام بارد» · «الطلب تالف» · «تأخير» · «سلوك الكابتن» · «مشكلة في المبلغ أو الباقي» · «أخرى» |
| Preset order notes | «اتصل بي عند الوصول» · «لا تطرق الباب» · «أرسلوا أدوات طعام» · «لا أحتاج أدوات طعام» |
| Restaurant rating reasons, 1–2 stars | «الطعام بارد» · «الطعم غير جيد» · «صنف ناقص أو خطأ» · «الكمية قليلة» · «التغليف سيئ» |
| Restaurant rating reasons, 3 stars | «جيد لكن يمكن أفضل» · «الكمية قليلة» · «التغليف يحتاج تحسيناً» |
| Restaurant rating reasons, 4–5 stars | «طعم رائع» · «حار وطازج» · «كمية جيدة» · «تغليف ممتاز» |
| Captain rating reasons, 1–2 stars | «تأخر» · «سلوك غير لائق» · «لم يتصل عند الوصول» · «الطلب وصل تالفاً» |
| Captain rating reasons, 3 stars | «تأخر قليلاً» · «يحتاج لطفاً أكثر» |
| Captain rating reasons, 4–5 stars | «لطيف» · «سريع» · «حافظ على الطلب» · «ملتزم بالتعليمات» |

**Customer-facing texts for reasons set by others:**

| Source | Reason | Customer sees |
|---|---|---|
| Restaurant rejection (RA §8.6) | «صنف غير متوفر» | «بعض الأصناف غير متوفرة: {الأصناف}» |
| | «المطعم مغلق» | «المطعم أغلق ولا يستقبل طلبات الآن» |
| | «ضغط طلبات» | «المطعم مشغول جداً الآن» |
| System | No restaurant response | «لم يرد المطعم على طلبك» |
| Ops cancellation (AP Appendix B) | «طلب الزبون» | «أُلغي بناءً على طلبك» |
| | «المطعم لم يستجب» | «لم يرد المطعم على طلبك» |
| | «المطعم أغلق» | «المطعم أغلق ولا يستقبل طلبات الآن» |
| | «صنف نفد» | «أحد الأصناف نفد من المطعم» |
| | «لا يوجد كابتن» | «لم نجد كابتناً متاحاً لطلبك» |
| | «العنوان خارج المنطقة» | «العنوان خارج منطقة التوصيل» |
| | «ظرف طارئ» | «ظرف طارئ منعنا من إكمال طلبك» |
| | «سبب آخر» | «نعتذر، أُلغي طلبك» |
| Failed outcome (AP §8.9) | `failed_other` | «تعذّر الوصول إليك أو إلى العنوان» |
| | `wrong_refused` | «رفضت الطلب لأنه غير صحيح» |
| | `damaged` (failed) | «وصل الطلب تالفاً» |
| | `fake` | «لم يُستلم الطلب» |
| Customer block (AP Appendix B) | «طلب وهمي» | «طلب لم يُستلم» |
| | «إساءة» | «مخالفة شروط الاستخدام» |
| | «احتيال على الأكواد» | «استخدام غير مسموح لأكواد الخصم» |
| | «أخرى» | «مخالفة شروط الاستخدام» |

**Pre-order problems** (§10.6):

| Problem | Text | Action |
|---|---|---|
| Restaurant cannot take orders | The state text (§9.2) | — |
| Item or option unavailable | «{الصنف} لم يعد متوفراً» | «حذف» |
| Price changed | «تغيّر سعر {الصنف} من {القديم} إلى {الجديد}» | «موافق» |
| Below minimum order | «أضف {المبلغ} لتصل إلى الحد الأدنى» | «أضف أصنافاً» |
| Outside coverage or zones | «هذا المطعم لا يوصل إلى هذا العنوان» | «تغيير العنوان» |
| Active-order limit | §5.5 | «طلباتي» |
| Account state | §5.5 | «تواصل مع الدعم» |
| Emergency stop | The browsing message (AP §9.1.6) | — |
| Outside platform hours | «FOX DROP يستقبل الطلبات من الساعة {الساعة}» | — |
| Capacity check | «الضغط عالٍ الآن، جرّب بعد دقائق» | «إعادة المحاولة» |
| Terms pending | «وافق على الشروط الجديدة لتتمكن من الطلب» | «عرض الشروط» |

**Code refusals** (AP §9.11.1):

| Reason | Text |
|---|---|
| Unknown code | «الكود غير صحيح» |
| Not started, expired, or outside its hours | «الكود غير صالح الآن» |
| Below its minimum order | «أضف {المبلغ} لاستخدام هذا الكود» |
| Not for this restaurant or zone | «هذا الكود لا يعمل مع هذا المطعم» |
| New users only | «هذا الكود للطلب الأول فقط» |
| Per-customer or total limit reached | «استخدمت هذا الكود من قبل» / «انتهت استخدامات هذا الكود» |
| Daily budget reached | «الكود غير متاح اليوم» |
