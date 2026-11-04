# 2. Decisions

> Part of the [customer app spec](README.md) (CU). A bare "§n" here means CU §n.

## 2.1 Owner decisions (2026-11-03)

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

## 2.2 Rules set by this spec

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

## 2.3 Decisions in the other specs that shape this app

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
