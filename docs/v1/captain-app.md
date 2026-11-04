# FOX DROP V1 — Captain App Specification

| | |
|---|---|
| Product | FOX DROP, a food delivery platform launching in Azaz, Syria, then expanding city by city |
| Scope | V1, the first version that completes a full order cycle |
| Component | The captain app «تطبيق الكابتن» for Android and iOS |
| Status | Approved by the owner on 2026-11-03 (decisions in §2) |
| Audience | Engineers and coding agents (Claude Code) who build the captain app and the server rules behind it |
| UI language | Arabic only, right to left |
| Related | Admin panel spec `docs/v1/admin-panel.md`, cited as "AP §n". Restaurant app spec `docs/v1/restaurant-app.md`, cited as "RA §n". Customer app spec `docs/v1/customer-app.md`. Arabic V1 plan page: https://claude.ai/artifact/8XR91QrZHk73nRHdu7E1q6 (section 20). BeeOrder captain research: `docs/beeorder-research/03-captain.md`. Technology stack: `docs/architecture/technology-stack.md` |

---

## 0. How to use this document

- This document is the source of truth for everything a captain sees and does in FOX DROP V1. If it differs from the Arabic plan page, this document wins.
- Shared domain rules live in AP §8: order statuses, the captain track, timers, money formulas, custody and earnings ledgers, currencies and outcomes. This document cites them instead of repeating them. Where this document changes a shared rule, the admin panel and restaurant app specs were updated in the same change; §16 lists every such change.
- **MUST**, **SHOULD** and **MAY** as in AP §0.
- `dotted.keys` are server settings. New keys are listed in Appendix A; existing keys are in AP Appendix A. Every number is the default value of a setting unless it is marked **fixed**.
- Ledger entry types such as `custody.pay_merchant` or `earn.order_pay` are enum values of ledger entries, not settings (AP §0).
- «Arabic text» is the UI label. Keep every label in a translation file. Appendix B collects the main strings.
- `OWN`, `OPS`, `SUP`, `FIN` and `DATA` are admin-panel roles (AP §6).
- Money examples use TRY as the base currency only to make them readable.

---

## 1. Context and principles

### 1.1 What the captain app is

A captain «كابتن» picks up orders from restaurants and delivers them to customers (AP §3). The captain app is the captain's only tool:

- apply to join and follow the application
- go online, receive offers, and accept or reject them
- carry out each order: go to the restaurant, check the items, pay the restaurant, deliver, collect the cash
- see the cash they hold for the platform, hand it in every business day, and follow their earnings until the Thursday payout
- see their performance, contract, documents, kit and the rules they work under

### 1.2 A working day

1. The captain opens the app and goes online. If they still hold cash from a previous business day, they hand it in at the office first (AP D11).
2. Offers arrive one at a time. The captain accepts one.
3. They ride to the restaurant, check the items, pay the full items value in cash, and the restaurant confirms the pickup (RA R4).
4. They ride to the customer, hand over the order, and collect the order total.
5. They see what they earned from the order and how much cash they now owe the office.
6. They go online for the next offer, or offline.
7. They hand in the platform's cash at the office every business day, and collect their earnings every Thursday.

### 1.3 Money in one paragraph (AP D11, D12, D26)

At pickup the captain pays the restaurant the **full items value** from their own cash. At the door they collect the full order total. The difference is the platform's cash in their hands, their **custody** «العهدة». They hand it in at the office every business day. Separately, the platform owes them **earnings** «المستحقات» for each order. Earnings are paid in full every Thursday. The two accounts never mix in the app: custody is cash they hold for the platform, and earnings are what the platform owes them.

### 1.4 Principles (MUST)

1. **Never miss an offer.** Offers ring with the screen off. The device check makes sure the phone can ring (§4.5).
2. **Show the money before the choice.** Every offer shows the captain's pay, what they will pay the restaurant, and what they will collect, before they accept (C2).
3. **The server is the authority.** The server owns order state, timers, every amount and every ledger entry. The app shows them and sends commands.
4. **One big action at a time.** Each step of an order has one main button. A captain on a motorbike can use the app with one hand, in sunlight, with gloves.
5. **Works on weak internet and cheap phones.** Commands retry safely. Maps and data stay light (§4.6).
6. **Customer privacy.** The captain sees the customer's name, phone and exact address only after accepting and only until the order ends (C2, C10, K8).
7. **Fair and transparent rules.** Every block, warning or charge tells the captain why and what to do next. Every violation can be appealed (C16).
8. **Every action is recorded.** Each command records the captain, the device, the time and the location. Admins see these in the order timeline (AP §9.3.1).

---

## 2. Decisions

### 2.1 Owner decisions (2026-11-03)

| ID | Topic | Decision |
|---|---|---|
| C1 | Platforms | Android and iOS (iPhone), with the same features. |
| C2 | Offer content | Before accepting, the offer shows: the restaurant and its distance from the captain, the customer's neighbourhood, the trip distance, the captain's pay, the amount to pay the restaurant, the amount to collect from the customer, and the order's preparation state. The exact address and the customer's phone appear only after acceptance. |
| C3 | Unanswered offers | After 3 offers in a row expire without an answer, the captain is set offline automatically and notified. |
| C4 | Maximum pickup amount | The captain sets «أقصى مبلغ أحمله» (the most I can pay a restaurant). Offers whose pickup payment is above it are not sent to them. This closes AP §13 item 3. |
| C5 | Withdrawing after acceptance | A button «لا أستطيع إكمال الطلب», with a reason, sends an urgent request to operations. The order is withdrawn only when operations withdraw it, and the event is recorded. |
| C6 | Arrival at the restaurant | «وصلت إلى المطعم» works only within 150 metres of the restaurant. The app suggests it automatically when the captain gets close. |
| C7 | Item check | A mandatory checklist: the captain ticks every item before the payment button appears. No photo in V1. |
| C8 | Paying the restaurant in other currencies | The captain chooses in Settings the currencies they usually carry. The app proposes a split based on them, and the captain can change it. |
| C9 | Delivery confirmation | No code from the customer in V1. «تم التسليم» is accepted within 200 metres of the customer's address; farther away, the captain gives a reason that operations see. |
| C10 | Contacting the customer | Call and WhatsApp buttons during the order only. They disappear when the order ends. |
| C11 | Food from a failed order | Operations decide in each case. By default the food stays with the captain, because it was paid for and is not returned to the restaurant. |
| C12 | Tips | Cash, entirely the captain's, outside the system. There is no tip field in V1. |
| C13 | Office hours | Set by admins and shown in the app with the office location on a map. When a captain goes offline holding cash, they get a reminder such as «عليك 120 ₺، المكتب مفتوح حتى 11 م». |
| C14 | Captain rating | The captain sees their average rating and the reasons customers picked, without customer names. |
| C15 | Emergency button | A clear «طوارئ» button during an order calls operations, sends the captain's location and marks the order urgent, so operations can hand it to another captain if needed. |
| C16 | Appealing a violation | An «اعتراض» button on each violation opens a ticket for the supervisor. |
| C17 | Early exit from the commitment period | No financial penalty in V1. The kit must be returned, otherwise the deposit is withheld. The captain's file is flagged «خروج مبكر», and they can be rehired only with the owner's approval. This closes AP §13 item 1. |
| C18 | Criminal record certificate | Renewed every 12 months, with a reminder 30 days before it expires. This closes AP §13 item 7. |

### 2.2 Rules set by this spec

The owner did not decide these explicitly. They follow from the decisions above or close gaps found while writing this spec. The owner may change any of them.

| ID | Rule | Why |
|---|---|---|
| K1 | Only consecutive **expired** offers count toward C3. Any accept or reject resets the count (§7.4). | A captain who rejects is present; one who never answers is not. |
| K2 | «أقصى مبلغ أحمله» is empty (no limit) by default. The app asks for it during the activation setup (§5.5), and again the first time the captain goes online if it is still empty. C4 applies to automatic offers. OPS MAY still send a **manual** offer above it, with a warning, which the captain can accept or reject (§8.4, §10.5). | Small orders should not be blocked by an empty field, and operations need a way out for a large order. |
| K3 | If GPS fails at the restaurant, OPS can record the captain's arrival from the panel, with a reason (§9.2, AP §9.3.2). | A broken GPS must not block the pickup. |
| K4 | Arrival at the customer follows the same 200-metre rule as delivery. A reason given once covers both (§9.6). | A wrong map pin must not block the order. |
| K5 | A captain is signed in on one device at a time (fixed). Signing in on a new device signs the old one out (§4.9). | The account holds cash and earnings. |
| K6 | An expired required document blocks going online. An expired optional document does not (§7.2, §12.2). | The rules in AP §9.7.1 require the documents to be valid. |
| K7 | A new version of the captain terms blocks going online until it is accepted. A current order continues (§4.8). | The captain must agree to the rules they work under. |
| K8 | The customer's name, phone and exact address disappear from the app when the order ends. History keeps the restaurant, the neighbourhood and the amounts (§9.13). | Privacy, from the plan: customer data is for delivery only. |
| K9 | When OPS ends an order with an amount still to collect, the captain records the payment lines in the app (§9.10, AP §9.3.2). | Custody is tracked per currency, so only the captain knows what was received. |
| K10 | A failed order records where the food went: with the captain (default), returned to the restaurant, or disposed of. «أُعيد إلى المطعم» is allowed only when the restaurant is the responsible party, because only then does the restaurant return the pickup payment (§9.12, AP §8.9). | C11 needs a record, and food must not go back to a restaurant that keeps the cash. |
| K11 | A rejected applicant can apply again after 30 days (fixed) (§5.4). | Avoids repeated applications while keeping the door open. |
| K12 | The emergency button needs a 2-second press (fixed) (§9.11). | Prevents accidental emergencies in a pocket or on a bumpy road. |
| K13 | A captain with an active order cannot go offline. They use «لا أريد طلبات جديدة» instead (§7.3). | An order must never be left without a captain. |
| K14 | A tip is never recorded. If the customer leaves the change as a tip, the captain records the change the customer was due as given (§9.7, §10.8). | C12 keeps tips outside the system, and a recorded tip would become custody. |
| K15 | On iPhone, offers use time-sensitive notifications with a sound of at most 30 seconds. The device check asks the captain to keep the ring switch on. FOX DROP SHOULD apply for Apple's Critical Alerts permission (§4.4). | iOS limits how loudly and how long an app can ring in the background. |
| K16 | Collecting less than the amount due needs a reason (§9.7). | Operations resolve every shortfall (AP §8.6) and need the captain's account of it. |
| K17 | After a «لا أستطيع إكمال الطلب» request, an emergency, or handing an order over to another captain, the captain is set offline when the order leaves them. After any other withdrawal they become available again, unless last-order mode is on (§7.3, §9.10). | A captain who just reported a breakdown or an accident must not get a new offer seconds later. |
| K18 | Force offline or a suspension during an active order puts the captain in last-order mode. Tracking continues until the order ends, then the captain goes offline (§7.6). | The customer's tracking and the arrival checks need the location until the order is done. |

### 2.3 Admin-panel decisions that shape this app

| AP decision | Effect here |
|---|---|
| D6 Dispatch at launch | Manual dispatch first, then mixed. Manual assignments reach the captain as offers (§8.4) |
| D10 Cash limit | Set per captain by finance. At 100% the captain gets no new offers (§10.4) |
| D11 Daily hand-in | Cash from a previous business day blocks going online (§10.3) |
| D12 Thursday settlement | Full settlement and payout every Thursday (§10.7) |
| D15 Peak bonus | Built and off by default. When on, the captain sees the windows (§12.5) |
| D24 Onboarding | Required documents, a signed contract, 1 month of probation, then 3 months of commitment (§5, §12.3) |
| D25 Currencies | USD, TRY and SYP, with the order's exchange-rate snapshot (§9.7, §10.5) |
| D26 Pickup payment | The captain pays the restaurant the full items value at pickup (§9.4) |
| RA R4 | The restaurant confirms the pickup with one tap, or it is confirmed automatically after 60 seconds (§9.4) |

---

## 3. Glossary

Terms from AP §3 (pickup payment, custody, earnings, hand-in, Thursday settlement, business day, outcome, responsible party, offer) and RA §3 (pickup request, pickup dispute) apply unchanged.

| Term | Meaning |
|---|---|
| Offer «عرض» | A proposal of one order to one captain for `dispatch.offer_timeout_sec` (45) seconds (AP §8.3) |
| Active order «الطلب الجاري» | The order a captain has accepted and not yet finished |
| Last-order mode «لا أريد طلبات جديدة» | The captain finishes the current order and then goes offline automatically (§7.3) |
| Maximum pickup amount «أقصى مبلغ أحمله» | The highest pickup payment the captain can pay a restaurant from their own cash (C4) |
| Carried currencies «العملات التي أحملها» | The currencies the captain usually carries, used to propose payment lines (C8) |
| Payment lines «سطور الدفع» | Amounts per currency that make up a payment, at pickup or at the door (AP §8.6) |
| `closed_due` «من أيام سابقة» | Custody from closed business days, which blocks going online (AP §8.5.4) |
| Arrival radius | The distance within which arrival or delivery is accepted without a reason: 150 m at the restaurant, 200 m at the customer (C6, C9) |
| Device check «فحص الجهاز» | A guided check that the phone can ring and track location (§4.5) |

---

## 4. Platforms and technical foundations

### 4.1 Platforms

| Platform | Minimum | Notes |
|---|---|---|
| Android phone | Android 8.0 (API 26) | Full behaviour, including a foreground service while online |
| iPhone | iOS 15 | Same features. Background rules differ (§4.3, §4.4). |

- Both apps MUST have the same features and rules. They are one Flutter codebase, with `flutter_background_geolocation` for location and native layers for offers and sounds (technology-stack §14).
- Phones only. Tablets are not a target, but the layout MUST not break on one.

### 4.2 Distribution and updates

- **Android:** through Google Play where it is available, and as a signed APK from the FOX DROP website, with the same signing certificate (as RA §4.2).
- **iPhone:** through the App Store. FOX DROP's Apple Developer account is available (technology-stack T3).
- **Version check:** at launch and on every reconnect, the app compares its version with `app.captain.min_version` and `app.captain.latest_version` (AP §9.14).
  - Below the minimum, a blocking update screen appears. A captain with an active order can finish it first: the block applies to going online again.
  - Below the latest, a dismissible banner appears.

### 4.3 Location

- **While online:** the app sends the captain's location every 10 seconds (fixed, AP §4.2), with its accuracy. The panel's map, dispatch, ETAs and the customer's tracking use it.
- **While offline:** no location is collected or sent (fixed). The app says so in the permission explanation.
- **Android:** a foreground service runs while the captain is online. It shows a permanent notification, «أنت متصل — FOX DROP يتابع موقعك لتصلك العروض».
- **iPhone:** the app asks for location «دائماً» (Always) with precise location, and uses background location updates while online. iOS shows its blue location indicator while the app tracks in the background.
- **No signal:** points recorded without a connection are queued and sent when the connection returns, so the route is complete. If no point reaches the server for `captain.gps_stale_alert_min` (2) minutes during an active order, OPS get «انقطع اتصال كابتن أثناء طلب» (AP §9.1.3).
- **Mock locations:** the app detects simulated locations: mock-location apps on Android, and `isSimulatedBySoftware` on iOS 15+. While one is active, the captain cannot go online, or gets no new offers if already online (§7.2). The panel records it.

### 4.4 Offers and sounds

- **Android:**
  - An offer opens a full-screen offer screen, also over the lock screen where the system allows it. On Android 14+ the app asks for the full-screen permission.
  - The offer sound loops for the whole offer time. It plays through the alarm audio stream, so the media volume and the ringer's silent mode do not mute it. The phone vibrates as well.
- **iPhone (K15):**
  - With the app open, the offer screen appears and the sound plays for the whole offer time.
  - With the app in the background or the phone locked, the offer arrives as a **time-sensitive notification** with the offer sound. iOS limits the sound to 30 seconds and lets the ring/silent switch mute it.
  - The device check asks the captain to keep the ring switch on and to allow time-sensitive notifications.
  - FOX DROP SHOULD apply to Apple for the Critical Alerts entitlement. If Apple grants it, offers use critical alerts, which sound even on silent.
- **Channels:** a WebSocket while the app runs, and push (FCM on Android, APNs on iOS) when it does not. The app MUST NOT depend on push alone on Android (as RA §4.3).
- **Other sounds:** a short chime for order events (ready, restaurant confirmed, edits, messages) and a distinct sound for cancellation or withdrawal. Sounds are fixed assets bundled with the app.

### 4.5 Device check «فحص الجهاز»

The device check runs before the first time a captain goes online, and again from Settings. Each step explains with screenshots what to do, including settings paths for common Android brands (Samsung, Xiaomi/Redmi/Poco, Huawei/Honor, Oppo/Realme, Vivo).

| # | Check | Android | iPhone |
|---|---|---|---|
| 1 | Notifications allowed | Read by the app | Read by the app, including time-sensitive notifications |
| 2 | Location always, precise | Read by the app | Read by the app |
| 3 | Running in the background | Battery optimisation off: read by the app. Brand auto-start: confirmed by the captain | Background App Refresh on and Low Power Mode off: read by the app |
| 4 | Full-screen notifications allowed (Android 14+) | Read by the app | — |
| 5 | Sound can be heard | Alarm volume at least 70%: read by the app. Do Not Disturb allowing the app: confirmed by the captain | Ring switch on and Focus allowing the app: confirmed by the captain (iOS does not let apps read the switch) |
| 6 | Test offer: the phone plays the offer sound with the screen locked, and the captain taps «سمعت الصوت» | Yes | Yes |
| 7 | Server connection and GPS accuracy | Read by the app | Read by the app |
| 8 | Call permission for the emergency button | Read by the app | — (iOS asks to confirm each call) |

- **Re-checks:** the checks the app can read are read again each time the app opens and each time the captain goes online. The checks the captain confirms are asked again only when the test offer (check 6) fails or the captain runs the check again. A failed check shows a yellow banner: «هاتفك قد لا يرن عند وصول عرض — أكمل فحص الجهاز».
- **Going online:** a failed check never blocks going online. It warns only, because a captain can still work with the app open.
- **Panel:** the result of the last check is sent to the server and shown in the captain profile (AP §9.7.4).

### 4.6 Weak internet and cheap phones

- **Commands:** every command carries an idempotency key and retries with backoff until the server answers, and it is never applied twice (as RA §4.7). While waiting, the button shows «جارٍ الإرسال…» and cannot be pressed again.
- **State conflicts:** the server checks each command against the current state. If the state changed (for example, the order was withdrawn), the app explains what happened.
- **Lost connection:** a red bar shows «لا يوجد اتصال بالإنترنت — لن تصلك العروض حتى يعود الاتصال». After 30 seconds offline (fixed), a chime plays once.
- **Timers** use server time, as in RA §4.7.
- **Light data:**
  - map tiles are cached
  - the route line is fetched once per leg
  - photos (documents) are compressed before upload
  - the app SHOULD stay under 2 MB of data per delivered order, excluding first-time map tiles
- **Navigation hand-off:** the in-app map shows the route for overview. «ابدأ الملاحة» opens Google Maps, or on iPhone Google Maps or Apple Maps as the captain prefers.

### 4.7 Formatting and business day

- **Formatting:** as in AP §4.7, with Western digits, money with its symbol, 12-hour times with «ص/م», and durations as «12 د».
- **Business day:** cutoff 06:00 by default (AP §4.3). It decides:
  - «اليوم» in earnings
  - what counts as custody from a previous day (§10.3)
- **Distances** show as «850 م» below 1 km and «2.4 كم» above.
- **Font size:** the app SHOULD stay usable with the system font enlarged up to 130%.

### 4.8 Maintenance and terms

- **Maintenance:** when `app.captain.maintenance` is on, the app shows a blocking screen with the message. A captain with an active order keeps the order screens, so they can finish.
- **Terms:** a new version of the captain terms (AP §9.13) must be accepted before going online (K7). A current order continues.
- **Work rules page:** the captain work rules page and the pay table text come from Content (AP §9.13) and are always available in the app.

### 4.9 Sign-in, session and device

- **Sign-in:** by phone number and a code sent over WhatsApp, the only channel in V1 (`otp.channel_order`, technology-stack §8.3), with the `otp.*` settings (AP Appendix A). A number without WhatsApp gets «هذا الرقم غير مسجّل على واتساب».
- **One device (K5):** a captain is signed in on one device at a time (fixed). Signing in on a new device signs the old one out, and the old device shows «سُجّل دخولك من جهاز آخر».
- **During an active order:** the captain cannot sign in on a second device by themselves. If the phone is lost, broken or out of battery, OPS release the old device from the panel (AP §9.7.5, «تحرير الجهاز»). The captain then signs in on the new device and continues the same order from its current step. If the captain has no phone at all, OPS can record the delivery on their behalf (AP §9.3.2).
- **Session length:** sessions do not expire with inactivity. They end on sign-out, a sign-in on another device, termination, or an admin forcing sign-out.
- **Phone number changes** go through OPS in the panel.

---

## 5. Joining

### 5.1 Entry screen

A person who is not signed in sees two buttons:

- «انضم ككابتن» (join as a captain)
- «تسجيل الدخول» (sign in)

Both start with the phone number and a code (§4.9). After the code is verified:

- **No account:** the application form opens. A draft is saved after every step.
- **An application in progress:** the application status page opens (§5.4).
- **An active captain:** the home screen opens.

### 5.2 Application form

| Step | Fields |
|---|---|
| 1. Personal | Full three-part name, date of birth (at least `captain.min_age` (18)), neighbourhood |
| 2. Vehicle | Type: «دراجة نارية» (motorbike), «سيارة» (car), «دراجة هوائية أو كهربائية» (bicycle or e-bike), «مشياً» (walking). For motor vehicles: plate number and vehicle papers. Only licensed vehicles are accepted. |
| 3. Documents | §5.3 |
| 4. Terms | The captain terms and the work rules, with a required checkbox |
| 5. Review and send | A summary, then «إرسال الطلب» |

- Phone numbers are validated as Syrian or Turkish mobile numbers.
- The server runs the duplicate check on the ID number, phone and plate (AP §9.7.1). The applicant does not see the result.

### 5.3 Documents (AP D24)

| Document | Arabic | Required | How |
|---|---|---|---|
| National ID, front and back | «الهوية» | Yes | Camera, with a guide frame |
| Personal photo | «صورة شخصية» | Yes | Front camera, plain background, no sunglasses |
| Civil registry extract | «إخراج قيد» | Yes | Camera or a file |
| Criminal record certificate | «لا حكم عليه» | Yes; valid for 12 months from its issue date (C18) | Camera or a file, with the issue date |
| Vehicle papers | «أوراق المركبة» | Yes for motor vehicles | Camera |
| Driving licence | «شهادة قيادة» | Optional | Camera |

- **Quality checks:** the app checks each photo for blur and darkness before upload, and asks for a retake when it fails.
- **Status:** each document shows «بانتظار التحقق» (pending), «مقبول» (accepted) or «مرفوض» (rejected) with the reason. A rejected document can be uploaded again.
- **Signed contract:** signed at the office and uploaded by staff (AP §9.7.1). It is not uploaded from the app.

### 5.4 Application status

The status page shows the current stage, what the applicant needs to do, and the history. The applicant gets a push at every change.

| Panel stage (AP §9.7.1) | What the applicant sees |
|---|---|
| «جديد» | «أُرسل طلبك. سنراجعه قريباً.» |
| «قيد المراجعة» | «طلبك قيد المراجعة.» Plus any document requested: «يرجى رفع {المستند}: {السبب}» |
| «مقابلة وتدريب» | «موعد المقابلة والتدريب: {اليوم} {الساعة} في {المكان}», with the office on a map |
| «بانتظار العدة» | «اجتزت التدريب. استلم العدة ووقّع العقد في المكتب.» |
| «مفعّل» | «مرحباً بك في FOX DROP!», and the app moves to the home screen |
| «قائمة انتظار» (waitlist) | «لا نحتاج كباتن جدداً حالياً. طلبك محفوظ وسنتواصل معك.» |
| «مرفوض» | «نعتذر، لم يُقبل طلبك: {السبب}. يمكنك التقديم مجدداً بعد {التاريخ}.» A rejected applicant can apply again after 30 days (K11, fixed). |

A former captain flagged «خروج مبكر» can apply again, but activation needs OWN's approval (C17, AP §9.7.1).

### 5.5 Activation

The panel activates the captain when everything in AP §9.7.1 is done: documents accepted, training passed, kit issued, deposit recorded, contract signed, vehicle set and cash limit set. On activation:

- the app shows a short welcome tour: going online, an offer, an order, custody and earnings
- the device check runs (§4.5)
- the app asks for «أقصى مبلغ أحمله» and «العملات التي أحملها» (§10.5)

---

## 6. Navigation

### 6.1 Screen map

| # | Screen | Arabic | Section |
|---|---|---|---|
| 1 | Home | «الرئيسية» | §7 |
| 2 | Offer | «عرض» (full screen) | §8 |
| 3 | Active order | «الطلب الجاري» | §9 |
| 4 | Earnings | «أرباحي» | §10.6 |
| 5 | Custody | «عهدتي» | §10.2 |
| 6 | Performance | «أدائي» | §11 |
| 7 | Profile | «ملفي» | §12 |
| 8 | History | «السجل» | §9.13 |
| 9 | Support | «الدعم» | §13 |
| 10 | Settings | «الإعدادات» | §10.5, §4.5 |

### 6.2 Layout

- **Bottom navigation:** «الرئيسية» · «أرباحي» · «عهدتي» · «المزيد». «المزيد» holds the other screens.
- **Active order:** while an order is active, the home screen shows it as a large card, and a bar on every screen returns to it.
- **Touch targets:** at least 48 dp. The main button of each order step is full width and at least 64 dp tall.
- **Sunlight:** high-contrast colours and text that is readable outdoors. A dark theme is V2.

### 6.3 Banners (highest priority first)

1. No connection (red, §4.6)
2. Platform emergency stop (red): «المنصة متوقفة مؤقتاً عن استقبال طلبات جديدة. أكملوا الطلبات الحالية.» (AP §9.1.6)
3. A block on going online, with its reason (red, §7.2)
4. Device check failed (yellow, §4.5)
5. Cash limit at 80% or more (amber, §10.4)
6. A document expiring within 30 days (amber, §12.2)
7. An operations announcement, for example «نحتاج كباتن الآن في حي الشهداء» (blue)
8. App update available (grey)

---

## 7. Availability

### 7.1 States

| State | Arabic | Meaning |
|---|---|---|
| Offline | «غير متصل» | No offers, no location tracking |
| Online, available | «متصل متاح» | Can receive offers |
| Busy | «مشغول» | Has an active order. Gets no offers in V1, because there is no order stacking (AP §9.12.6). |
| Last-order mode | «آخر طلب» | Busy, and will go offline after this order (§7.3) |
| Not receiving offers | «لا تصلك عروض» | Online, but at the cash limit or past the hand-in grace (§10.3, §10.4). The reason is shown. |
| Suspended | «موقوف» | Set by OPS, with a reason and an end time if any (AP §9.7.5) |

### 7.2 Going online, and what blocks it

The «متصل» switch on the home screen is refused in these cases. Each shows its reason and the next step:

| Block | Message | Ends when |
|---|---|---|
| Cash from a previous business day (AP §8.5.4) | «لديك نقد غير مسلّم من يوم {التاريخ}: {المبلغ}. سلّمه في المكتب لتتمكن من الاتصال.» with the office hours and a map button | Hand-in at the desk, or a grace from OWN or FIN |
| Cash limit reached (AP §8.5.3) | «بلغت حد العهدة ({المبلغ}). سلّم النقد في المكتب لتصلك العروض.» | Custody below the limit |
| Required document expired (K6) | «انتهت صلاحية {المستند}. ارفع نسخة جديدة من «ملفي».» | The new document is accepted by OPS |
| Suspended | «حسابك موقوف حتى {التاريخ}: {السبب}» with «اعتراض» (§11.3) | The suspension ends or OPS lift it |
| Terms not accepted (K7) | The terms screen | Accepted |
| Version below the minimum | The update screen | Updated |
| Simulated location active | «أوقف تطبيقات تغيير الموقع لتتمكن من الاتصال.» | Turned off |
| Contract ended | «انتهى تعاقدك مع FOX DROP.» | — |

**Already online when a block starts.** A current order always continues to the end.

| Block that starts while online | What happens |
|---|---|
| Cutoff with `closed_due` open | Offers continue for `captain.remit_online_grace_hours` (4) hours, then «لا تصلك عروض» until the hand-in (AP §8.5.4) |
| Cash limit reached | «لا تصلك عروض» until custody drops below the limit |
| Required document expired | «لا تصلك عروض» until the new document is accepted |
| Simulated location detected | «لا تصلك عروض» until it is turned off |
| New terms version, or version below the minimum | Offers continue. The block applies the next time the captain goes online. |
| Suspension, force offline or contract end | Last-order mode (K18): no new offers, tracking continues, offline when the order ends. Without an order, offline at once. |

### 7.3 Last-order mode «لا أريد طلبات جديدة»

- With an active order, the captain cannot go offline (K13). The switch is replaced by «لا أريد طلبات جديدة».
- In this mode no new offers arrive. After the current order ends, the captain goes offline automatically, with the hand-in reminder if they hold cash (§7.5).
- The captain can cancel the mode before the order ends.
- There is no daily limit on this mode in V1.

### 7.4 Automatic offline after unanswered offers (C3)

- After `captain.offer_expiry_offline_count` (3) offers **in a row** expire without an answer, the captain is set offline (K1).
- They get a push and a sound: «لم ترد على 3 عروض متتالية، فأصبحت غير متصل. اضغط «متصل» عندما تكون جاهزاً.»
- The count resets on any accept or reject, and when the captain goes offline.
- Manual offers from operations count too (§8.4). The expired offers still count in the acceptance rate (§11.1).

### 7.5 Going offline, and the hand-in reminder (C13)

- **Going offline** is one tap when there is no active order.
- **Reminder:** if the captain holds custody above `captain.remit_tolerance`, a sheet opens:
  - «عليك تسليم {المبلغ}. المكتب مفتوح حتى {الساعة}.»
  - when the office is closed: «المكتب مغلق الآن، يفتح {اليوم} {الساعة}.»
  - a button opens the office location on the map
- **Office details:** the office hours and location come from the city's office fields in the panel (AP §9.12.1).

### 7.6 Actions by operations

- **Force offline** (AP §9.7.5): the captain goes offline with the reason. With an active order, they enter last-order mode instead: tracking continues and they go offline when the order ends (K18).
- **Suspend:** the state becomes «موقوف» with the reason. An active order continues to the end in last-order mode, then the captain goes offline (K18).
- **Release the device** (AP §9.7.5): the signed-in device is signed out, so the captain can sign in on another phone, including during an order (§4.9).
- **Message:** a direct push from OPS appears as a notification and in «الرسائل» under Support.

---

## 8. Offers

### 8.1 When offers come

- The server sends offers only to eligible captains (AP §9.12.6):
  - online, active and with no active order
  - custody under the cash limit, and not blocked for unhanded cash
  - within the search radius of the restaurant
  - a vehicle allowed for the trip distance
  - and now also: a pickup payment not above the captain's «أقصى مبلغ أحمله», when set (C4). The capacity check at order placement ignores this condition, so a large order is never refused only because of it (AP §9.12.6).
- **Timing:** an order is offered once the restaurant has accepted it and the search-start moment has come (AP §8.3), so the captain arrives about when the food is ready.
- **One at a time:** one offer per captain at a time, for `dispatch.offer_timeout_sec` (45) seconds.

### 8.2 The offer screen (C2)

A full-screen sheet with the offer sound (§4.4) and a countdown ring.

| Item | Example |
|---|---|
| The captain's pay for this order (largest text) | «35 ₺» |
| Restaurant and distance from the captain | «مطعم الشام · 1.2 كم» |
| Customer neighbourhood and trip distance (restaurant to customer) | «حي الشهداء · 2.8 كم» |
| Pay to the restaurant at pickup | «تدفع للمطعم: 400 ₺» |
| Collect from the customer | «تقبض من الزبون: 410 ₺» |
| Preparation state | «قيد التحضير — جاهز بعد 8 د تقريباً» or «جاهز» |
| Peak bonus, when one applies | «يشمل مكافأة الذروة +5 ₺» |
| Map | The restaurant and the customer's neighbourhood, without the exact pin |

- **Pay estimate:** the pay shown is the order pay from the pay table (AP §8.4), plus the peak bonus if it would apply now. Waiting pay is added later, if any. The offer says «قد يُضاف أجر انتظار».
- **Hidden until acceptance:** the customer's name, phone and exact address (C2).

### 8.3 Accept, reject, expire

- **«قبول»** (accept, a large button): the order becomes the captain's active order (§9). The server checks that the offer is still valid; if another action took the order, the app says «لم يعد العرض متاحاً».
- **«رفض»** (reject): no reason is needed. It counts in the acceptance rate (§11.1).
- **Expired:** the sheet closes with «انتهى العرض». It counts in the acceptance rate and toward C3 (§7.4).
- **Logging:** every offer and response is logged with its time (AP §9.7.4).

### 8.4 Manual assignment

- With `dispatch.manual_assign_requires_accept` (true), a manual assignment from OPS arrives as a normal offer, marked «تعيين من العمليات» (AP §9.3.2).
- **Override (K2):** OPS MAY send a manual offer to a captain whose «أقصى مبلغ أحمله» is below the pickup payment. The offer then says «المبلغ أكبر من الحد الذي حددته — اقبل فقط إذا كان معك ما يكفي».
- If the setting is false, a manual assignment becomes the active order directly, with a chime and «عيّنتك العمليات على طلب».

---

## 9. The active order

### 9.1 Steps

The active order is four steps. Each step has one main button.

| Step | Captain track (AP §8.2) | Main button |
|---|---|---|
| 1. To the restaurant | `assigned` | «وصلت إلى المطعم» |
| 2. At the restaurant | `at_merchant` → `pickup_pending` | «دفعت للمطعم واستلمت الطلب» |
| 3. To the customer | `picked_up` | «وصلت» |
| 4. At the customer | `at_customer` | «تم التسليم» |

A progress bar at the top shows the four steps. The «مشكلة» (problem) menu and «طوارئ» are on every step (§9.11).

### 9.2 Step 1: to the restaurant

- **Shown:**
  - the restaurant's name, address and location on the map, with the route
  - the ETA, and the preparation state: «قيد التحضير — جاهز بعد {د} د» or «جاهز»
  - the order number and item count
  - «تدفع للمطعم: {المبلغ}»
- **Buttons:** «ابدأ الملاحة» (§4.6) and «اتصال بالمطعم».
- **Arrival (C6):** «وصلت إلى المطعم» is enabled only within `captain.merchant_arrival_radius_m` (150) metres of the restaurant, using the latest GPS fix.
  - When the captain enters the radius, the app shows a banner, «هل وصلت إلى المطعم؟», with the button.
  - Outside the radius, the button is disabled with «اقترب من المطعم لتأكيد الوصول».
- **GPS problems (K3):** if the GPS accuracy is worse than 100 metres, the app shows «إشارة الموقع ضعيفة — اتصل بالعمليات لتسجيل وصولك». OPS can then record the arrival from the panel (AP §9.3.2).
- **Effect of arrival:** the restaurant gets «وصل الكابتن» (RA §8.9), and the captain track becomes `at_merchant`.

### 9.3 Step 2: at the restaurant

- **Waiting:** a timer counts from arrival. Waiting pay follows AP §8.4: if the pay table includes it, it counts from the later of the arrival and the moment the food was due, after the first `captain.waiting_threshold_min` (10) minutes. When it starts, the screen shows «بدأ احتساب أجر الانتظار». OPS and the restaurant are alerted at the threshold (AP §9.1.3, RA §8.9).
- **Ready:** when the restaurant presses «الطلب جاهز», the captain gets a chime and «الطلب جاهز».
- **Item check (C7):**
  - The screen lists every item with its quantity, options and notes, each with a tick box.
  - The payment section appears only when every box is ticked.
  - A line above the list says «بعد تأكيد الأصناف يصبح أي نقص من مسؤوليتك» (after you confirm the items, any shortage is your responsibility).
  - If something is missing or wrong, the captain uses «مشكلة» → «صنف ناقص» (§9.11) and does not pay until it is sorted.
- **Payment (§9.4):** «ادفع للمطعم: {المبلغ}» with the proposed payment lines.
- **The restaurant reports an item unavailable** (RA §8.12): the screen shows «بانتظار تعديل الطلب من العمليات» and the pickup is blocked until operations edit, cancel or close the report.
- **The restaurant has not acknowledged an edit that added items:** the screen shows «بانتظار تأكيد المطعم للتعديل» and the pickup is blocked (RA §8.13).

### 9.4 The pickup request (RA §8.10)

1. The captain pays the restaurant the amount shown, in the proposed lines or their own split (§10.5).
2. They tap «دفعت للمطعم واستلمت الطلب».
   - The server checks the payment lines. Lines whose converted total differs from the pickup payment by more than half the largest rounding unit among their currencies are refused with «المبلغ لا يطابق المطلوب» (AP §8.1).
   - The captain track becomes `pickup_pending`.
3. The screen shows «بانتظار تأكيد المطعم» with a 60-second countdown (`order.pickup_confirm_timeout_sec`).
4. **Results:**

   | Restaurant answer | Captain sees | Next |
   |---|---|---|
   | Confirmed, or no answer within 60 s | «تم الاستلام» | Step 3. The pickup payment is now in custody (AP §8.1). |
   | Confirmed by OPS on the restaurant's behalf | «أكّدت العمليات الاستلام» | Step 3 |
   | «المبلغ غير صحيح» | «المطعم يفيد بأنه استلم {المبلغ}. أكمل المبلغ ثم أعد التأكيد.» | Pay the difference, then tap again with the corrected lines |
   | «الطلب غير مكتمل» | «المطعم يفيد بأن الطلب غير مكتمل. راجع الأصناف معه.» | Recheck the items, then tap again |

5. **Cancelled while waiting:** the request is voided. Reassignment and edits are blocked while a request is open (AP §8.1). The screen tells the captain whether to take the cash back from the restaurant, as operations recorded it.
6. **Cash and the restaurant disagree:** if the captain paid more than the pickup payment and the restaurant does not return the difference, the captain uses «مشكلة» → «مشكلة في مبلغ الاستلام». This opens the same pickup-dispute ticket the restaurant can open, resolved per AP §9.9.3.

**After pickup:** if the restaurant disputes the amount within 10 minutes (RA §8.10, step 8), the captain is notified, «فتح المطعم بلاغاً عن مبلغ الاستلام — ستتواصل معك العمليات». The order continues normally.

### 9.5 Step 3: to the customer

- **Shown after acceptance only (C2):**
  - the customer's name, or the recipient's name when the order is for someone else (customer-app spec Q5)
  - the exact pin on the map, with the route
  - the address text with the building, floor, the nearby landmark and the customer's directions
  - the customer's note and preset notes
  - «تقبض من الزبون: {المبلغ}», with the equivalents in the other accepted currencies
  - the pay-in currency, when the customer chose one: «الزبون سيدفع بـ {العملة}» (customer-app spec U10). It is an indication, not a commitment.
  - the promised time: «التسليم المتوقع قبل {الساعة}» (AP §8.3)
- **Buttons (C10):** «ابدأ الملاحة», «اتصال بالزبون» and «واتساب الزبون». They work only while the order is active.
  - The call button opens the phone's dialer with the address's contact phone, which is the customer's own number unless the order is for someone else. WhatsApp opens a chat with that number.
  - The app does not display the number anywhere else.
  - Each call or WhatsApp tap is recorded in the order timeline.
- **Tracking:** from pickup until the order ends, the customer sees the captain on the map and can call them. The customer sees the captain's number on their call screen (customer-app spec §11.3, U12).

### 9.6 Step 4: at the customer

- **Arrival (K4):** «وصلت» is enabled within `captain.customer_radius_m` (200) metres of the customer's pin.
  - The app suggests it when the captain enters the radius.
  - Farther away, the button asks for a reason first (Appendix C): «الزبون طلب مكاناً آخر», «موقع الزبون على الخريطة غير دقيق», «أخرى» (with text). The reason is recorded and also covers delivery.
- **Effect of arrival:** the customer gets «الكابتن عند الباب», and the track becomes `at_customer`.
- **Next:** the payment screen (§9.7), then «تم التسليم» (§9.8).
- **The customer does not answer:** §9.9.

### 9.7 Payment at the door

The screen shows the amount due and helps the captain record what really happened.

1. **Amount due:** the order total in the base currency, large, with its equivalents in the other accepted currencies, each rounded by its own rule (AP §8.6).
2. **Received:** the captain enters what they received, in one or more currency lines. Buttons for each currency fill the exact equivalent with one tap. The button of the customer's pay-in currency comes first (customer-app spec U10).
3. **Change:** the app computes the change in the base currency. The captain can switch the change to another currency, or split it, and records the change the customer was due. If the customer left that change as a tip, the captain still records it as given (K14).
4. **Check:** the server converts the lines with the order's snapshot rates.
   - The net received is the received lines minus the change lines. A difference from the amount due within half the largest rounding unit among the currencies of all the lines is rounding (AP §8.6).
   - If the net received is lower, the app warns «المبلغ المقبوض أقل من المطلوب بـ {المبلغ}». The captain must choose a reason (K16, Appendix C): «الزبون لا يملك المبلغ كاملاً», «خطأ في العد», «أخرى». Operations get «نقص في التحصيل» and resolve it (AP §8.6).
   - A net received above the amount due beyond rounding is refused: «سجّل الباقي الذي أعدته للزبون».
   - The command carries the version of the amount due that the screen showed. If operations changed the amount in the meantime, the server refuses it, and the screen reloads with the new amount: «تغيّر المبلغ المطلوب إلى {المبلغ}».
5. **Tips (K14):** a line under the screen says «إذا ترك لك الزبون الباقي إكرامية فهو لك، سجّله كأنك أعدته» (a tip is yours; record the change as if you gave it back).

### 9.8 Delivery and the order summary

- **Where «تم التسليم» is accepted (C9):** within `captain.customer_radius_m` (200) metres of the pin. Farther away, the captain chooses a reason, unless they already gave one at arrival (K4). Operations get the information alert «تسليم بعيد عن العنوان» (AP §9.1.3).
- **Effect:**
  - the order becomes `delivered` (AP §8.1)
  - the server posts `custody.collect` and `custody.change_given` from the payment lines, and the captain's `earn.order_pay` (and any waiting pay or peak bonus)
  - the customer gets «تم التسليم»
- **Summary sheet:**
  - «ربحت من هذا الطلب: {الأجر}», split into base, distance, «إكمال للحد الأدنى» (top-up to the minimum pay, when `min_pay` applies, AP §8.4), waiting and peak
  - «تغيّرت عهدتك: {+المبلغ}» (custody change), and «عليك تسليم اليوم: {المجموع}»
  - a button to go back online, or «إنهاء العمل» (go offline)
- **After delivery:** the captain is «متصل متاح» again at once, unless last-order mode or a block applies, and can receive the next offer while the summary is open. «إنهاء العمل» on the summary goes offline.
- **Last-order mode:** the captain goes offline after the summary (§7.3). Last-order mode applies however the order leaves the captain: delivered, failed, withdrawn, handed over or cancelled.

### 9.9 The customer does not answer (AP §8.3)

1. After arrival, the captain calls the customer from the order screen.
2. **Pings:** «تنبيه الزبون» sends an alert to the customer's app, which rings (customer-app spec §11.7). It can be used `customer.no_answer_pings` (3) times, at least `customer.no_answer_ping_interval_min` (5) minutes apart. The screen shows the next allowed time.
   - If the customer answers «أنا قادم», the captain hears a chime and sees «الزبون رأى التنبيه وهو قادم». For an order with a recipient, the answer is «سأتصل بالمستلم», and the captain sees «الزبون يتواصل مع المستلم». The 15-minute rule still runs.
3. **After 15 minutes and three pings:** the button «الزبون لا يستجيب» appears. Pressing it tells OPS (AP §9.1.3, «زبون لا يرد») and shows «العمليات تراجع الطلب — انتظر تعليماتهم».
4. **OPS decide:**
   - «انتظر» (wait), with a message
   - or end the order with an outcome: `fake` or `failed_other` (AP §8.9)

   The captain sees the result and the food instruction (§9.12).
5. **The customer appears in the meantime:** the captain continues with payment and delivery as normal.

### 9.10 Changes by operations

| Change | What the captain sees |
|---|---|
| Edit before pickup | A chime and the change list: «تم تعديل الطلب — المبلغ الجديد للمطعم {المبلغ}، للتحصيل {المبلغ}». The item checklist updates. If cash was already paid, the captain settles the difference with the restaurant in person (AP §8.1). |
| Items removed after pickup | «حُذفت أصناف من الطلب — المبلغ الجديد للتحصيل {المبلغ}». The captain does not deliver those items. |
| Lower delivery fee after pickup | The new amount to collect |
| Prep or promised time changed | The new times |
| Withdrawn before pickup (reassignment) | The cancellation sound and «سُحب منك الطلب: {السبب}». If the captain had already arrived at the restaurant, also whether to take the cash back from it (AP §8.1). The order leaves the app. |
| Handed over after pickup (emergency) | §9.10.1 |
| Cancelled | The cancellation sound and «أُلغيت المهمة: {السبب}». If the captain had already arrived at the restaurant, also whether to take the cash back from it (AP §8.1). If OPS compensated the captain for arriving at the restaurant, the summary shows «تعويض: {المبلغ}» (AP §8.9). |
| Outcome set with the captain responsible | The charge appears in earnings with the reason (§10.6) |
| Outcome set by OPS with an amount to collect (K9) | «أنهت العمليات الطلب: {النتيجة}. اقبض {المبلغ}.» The payment screen (§9.7) opens for that amount. The order stays active, with the badge «بانتظار تسجيل التحصيل», and the captain stays busy until they record the lines. The server then posts the outcome from the recorded net. A gap below the amount beyond rounding follows the shortfall flow (K16, AP §8.6). If the amount is 0, the order ends at once. |

After a withdrawal, a handover or a cancellation, the captain's next state follows K17.

#### 9.10.1 Handover to another captain (AP §9.3.2)

OPS can hand an order over in `picked_up` or `arrived`, for example after an accident or a breakdown.

- **First captain:**
  - They see «سيستلم الكابتن {الاسم} الطلب منك. انتظره في موقعك.» with the second captain's live position and a call button.
  - The pickup payment stays in their custody, and the desk reimburses it (AP §9.3.2).
  - When the second captain confirms, the order leaves the first captain's app with «سلّمت الطلب للكابتن {الاسم}». Their track becomes `done`, and they go offline (K17).
- **Second captain:**
  - They get a handover offer (or assignment) marked «استلام من كابتن». It shows «لا تدفع شيئاً» instead of the pickup payment, the amount to collect, the first captain's location, and the customer's neighbourhood.
  - C4 does not apply, because they pay nothing.
  - Step 1 leads to the first captain's live location. Its button is «استلمت الطلب من الكابتن {الاسم}», enabled within `captain.customer_radius_m` (200) m of the first captain.
  - Confirming sets their track to `picked_up` (the order status returns to `picked_up` if it was `arrived`). They continue with steps 3 and 4.
  - They collect at the door, so the collection goes to their custody, and they earn the order pay (AP §9.3.2).

### 9.11 Problems, withdrawal and emergencies

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

### 9.12 Failed orders and the food (C11)

- **When an order fails after pickup** (`fake`, `wrong_refused`, `failed_other`, or `damaged` as failed), OPS record where the food goes (K10, AP §8.9):
  - «يبقى مع الكابتن» (stays with the captain), the default
  - «أُعيد إلى المطعم» (returned to the restaurant)
  - «أُتلف» (disposed of)
- «أُعيد إلى المطعم» is allowed only when the restaurant is the responsible party, which means it also returns the pickup payment (AP §8.9) (K10).
- The captain sees the instruction in the app.
- **Money:** the captain's custody shows what really happened. If they paid the restaurant and collected nothing, their custody goes negative, and the office pays them back the same business day (AP §8.9). Their pay follows the outcome: they are paid unless they are the responsible party.

### 9.13 History «السجل»

- A list of past orders by business day, with:
  - order number and date
  - restaurant and customer neighbourhood
  - status and outcome
  - pay earned
  - the custody effect: paid to the restaurant, collected and change
- **Detail:** the timeline of the captain's own steps and the amounts.
- **Privacy (K8):** after an order ends, the customer's name, phone and exact address are no longer shown.
- **Filter:** by date range.

---

## 10. Money

### 10.1 One order, end to end

| Step | Amount | Account |
|---|---|---|
| Pay the restaurant at pickup | −400 ₺ | Custody (`custody.pay_merchant`) |
| Collect from the customer | +410 ₺ | Custody (`custody.collect`) |
| **Custody from this order** | **+10 ₺** | Handed in at the office the same business day |
| Order pay | +35 ₺ | Earnings (`earn.order_pay`), paid on Thursday |

Custody can be negative: for example when a platform discount code is larger than the delivery fee, or when an order fails. The office then pays the captain back (AP §8.5.1).

### 10.2 Custody screen «عهدتي»

- **The total**, with a plain sentence: «عليك تسليم {المبلغ}» (you must hand in) or «لك عند المكتب {المبلغ}» (the office owes you).
- **Per currency:** the balance in each currency held, with the base equivalent. The captain hands back exactly the currencies they received (AP §8.6).
- **Two parts (AP §8.5.4):**
  - «من أيام سابقة» (from previous days): `closed_due`, which blocks going online
  - «من اليوم» (from today)
- **Cash limit:** the limit and a usage bar (§10.4).
- **Entries:** every entry, with the order number, type and amount: pickup payment, collection, change, hand-in, reimbursement, conversion, correction.
- **Receipts:** every desk receipt, with its number, time, amounts and cashier. Receipts appear the moment the desk records them (AP §9.10.3).
- **Office:** the hours and location, with a map button (C13).

### 10.3 Daily hand-in (AP D11)

- **The rule:** hand in the platform's cash every business day. Custody from a closed business day blocks going online (§7.2).
- **At the desk:** the cashier finds the captain, counts what they hand in per currency, and records it. The receipt appears in the app at once, and the block lifts.
- **Reminders:**
  - when going offline with custody (§7.5)
  - a push at 22:00 city time (fixed) if the captain holds custody from today and the office is open, with the closing time
  - on the next attempt to go online, the block message
- **Online across the cutoff:** the captain keeps getting offers for 4 hours after the cutoff (AP §8.5.4). The home screen shows «سلّم نقد أمس قبل {الساعة} لتستمر العروض».
- **Grace:** OWN or FIN MAY grant a grace (AP §8.5.4). The app then shows «مُنحت مهلة حتى {الساعة}». The custody stays due.

### 10.4 Cash limit (AP D10)

- Each captain has a limit set by finance. The app shows it on the custody screen and as a bar on the home screen.
- At `captain.custody_warn_pct` (80%), an amber banner and a push: «اقتربت من حد العهدة. سلّم النقد قريباً.»
- At 100%, the captain gets no new offers until they hand in (§7.1). A current order always continues.

### 10.5 Maximum pickup amount and carried currencies (C4, C8)

**«أقصى مبلغ أحمله»** (maximum pickup amount):

- An amount in the base currency, in Settings. It is empty (no limit) by default. The app asks for it during the activation setup (§5.5), and again the first time the captain goes online if it is still empty (K2).
- Automatic dispatch does not offer orders whose pickup payment is above it (§8.1). OPS MAY override it with a manual offer (§8.4). Handover offers ignore it (§9.10.1).
- The captain can change it at any time without an active order. The new value applies to the next offer.

**«العملات التي أحملها»** (carried currencies):

- Switches for the city's accepted currencies. The base currency is on by default.

**Proposed payment lines at pickup:** the server proposes lines for the pickup payment, using the currencies the captain carries **and** the restaurant accepts (RA §12.7).

1. If both include the base currency, the proposal is the whole amount in the base currency.
2. Otherwise, it is the whole amount in the first common currency in the city's currency display order (AP §8.6), rounded by that currency's rule.
3. If there is no common currency, it is in the base currency, which every restaurant accepts.

The proposal is always one line, and it is always within the tolerance. The captain can split it across currencies or edit it (C8). The server validates the lines (§9.4), and rounding goes to `platform.fx_rounding` (AP §8.11).

### 10.6 Earnings screen «أرباحي»

- **Today and this week:** the earnings so far, the number of orders, and the online hours.
- **Each order:**
  - base pay (including the first km), distance pay, «إكمال للحد الأدنى» when the minimum pay applies, waiting pay, peak bonus
  - the total for that order
- **Other entries:**
  - bonuses (`earn.bonus`), with the reason
  - charges (`earn.charge`), with the order and the reason, when the captain was the responsible party (AP §8.9)
  - deposit instalments (`earn.deposit_instalment`)
  - payouts (`earn.payout`), with their receipt
- **Balance:** «رصيدك المستحق: {المبلغ}» and «موعد القبض: الخميس {التاريخ}».
- **Pay table:** a link to the current pay table and any announced change (§12.5).

### 10.7 Thursday settlement (AP D12)

On `captain.payout_weekday` (Thursday, a business day), the captain comes to the office. The desk does the full settlement (AP §8.5.5):

1. Custody is settled to zero in every currency: the captain hands in, or the desk pays them.
2. Pending deposit instalments are posted.
3. The full positive earnings balance is paid in cash, in the base currency or another accepted currency at the current rate.

The weekly statement then appears in the app. It covers the period since the previous payout:

- the number of orders
- pay by part (base, distance, waiting, peak)
- bonuses, charges and instalments
- the net amount paid

The captain can share the statement as an image.

**Edge cases:**

- A captain who misses Thursday keeps their balance until the next one.
- A negative earnings balance is carried to next week by default (`captain.negative_earnings_policy`). The app explains this.

### 10.8 Tips (C12)

Tips are cash between the customer and the captain. They are entirely the captain's and are never recorded (K14). The work rules page states that the captain must never ask for one.

---

## 11. Performance and rules «أدائي»

### 11.1 Acceptance rate

- **Calculation:** over the last `captain.acceptance_window_offers` (50) offers. Rejected and expired offers lower it (AP §9.7.6).
- **Shown** as a percentage, with the last 50 offers listed: time, restaurant, and the response (accepted, rejected or expired).
- **Below `captain.acceptance_alert_pct` (70%):** a warning in the app, «نسبة قبولك منخفضة ({النسبة}%). حاول قبول العروض المناسبة لك.»
- **Below `captain.acceptance_review_pct` (50%):** operations review the captain (AP §9.7.6). There is no automatic suspension in V1.

### 11.2 On time, cancellations and rating

- **On-time rate:** delivered orders at or before the promised time ÷ delivered orders, over the last 50 delivered orders.
- **Cancellations:** the number of captain cancellations in the last `captain.violation_window_days` (90) days (§9.11).
- **Rating (C14):**
  - the average stars and the number of ratings
  - the reasons customers picked, with counts, for example «لطيف» or «تأخر»
  - no customer names and no comments. Comments are visible to admins only (customer-app spec Q16).
- **Online hours:** today and this week.

### 11.3 Violations and appeals (C16)

- **Each violation** (AP §9.7.6) shows the date, the type, the step on the ladder, the order if any, and the consequence:
  - «تنبيه» (warning)
  - «إيقاف يوم» (1-day suspension)
  - «إيقاف 7 أيام» (7-day suspension)
  - «إنهاء التعاقد» (termination)
- **Window:** the ladder counts violations within 90 days. Serious violations (theft, harassment, violence) mean immediate termination.
- **Appeal:** «اعتراض» on each violation opens a ticket for the supervisor, with a text field and an optional photo. The captain sees its status and the decision in Support. OPS record the appeal result on the violation (AP §9.7.5).

### 11.4 Work rules

The work rules page (Content, AP §9.13) is always one tap away. It covers at least:

- free work hours, with no mandatory shifts in V1
- the item check, and responsibility after it
- never asking a customer for more than the app shows
- carrying enough cash for pickups (C4)
- the daily hand-in, the Thursday payout and the cash limit
- the acceptance rate and the conduct ladder
- packaging care (hot and cold apart, bag closed)
- customer data used for delivery only
- the helmet for motorbikes

---

## 12. Profile «ملفي»

### 12.1 Data and vehicle

- **Read-only:** name, phone, neighbourhood, vehicle type, plate, and the captain's FOX DROP ID number.
- **Changes** to the phone, vehicle or neighbourhood are requested through Support (§13) and made by OPS.

### 12.2 Documents

- **List:** every document with its status, issue date and expiry date.
- **Criminal record certificate (C18):** its expiry is set to the issue date plus `captain.criminal_record_validity_months` (12).
- **Expiry reminder:** `captain.document_expiry_notice_days` (30) days before a document expires, the captain gets a push and an amber banner, and OPS get a task (AP §9.7.4).
- **Replacement:** «رفع نسخة جديدة» uploads a replacement, which waits for OPS verification. The old document stays valid until it expires.
- **On expiry (K6):** an expired required document blocks going online. An expired optional document does not.

### 12.3 Contract and early exit (C17)

- **Shown:** the phase («فترة تجربة», «فترة التزام» or «مفتوح»), the start date, the probation end, the commitment end, and the contract scan (AP §9.7.2).
- **Phase changes:** each one sends a push.
- **Early exit:** the page explains what happens when a captain leaves during the commitment period:
  - there is no financial penalty
  - the kit must be returned, otherwise the deposit is withheld
  - the file is flagged «خروج مبكر», and rehiring needs the owner's approval
- **Ending the contract:** a captain who wants to stop working asks through Support. OPS run the offboarding checklist (AP §9.7.5).

### 12.4 Kit and deposit

- **Shown:** the items issued (thermal bag, vest, with sizes), the deposit paid, the instalments remaining (deducted on Thursdays), and the items returned.
- **Refund:** the deposit is refunded at offboarding when the kit is returned in good condition (AP §9.7.5).

### 12.5 Pay table and peak windows

- **Pay table:** the current table for the captain's vehicle (AP §9.12.5): base pay and the km it includes, the rate per extra km, the waiting rate, and the minimum pay.
- **Calculator:** «احسب أجري» shows the pay for a sample distance.
- **Announced changes:** they are shown at least 7 days before they apply (AP §9.12.5), with a push on announcement.
- **Peak windows (AP D15):** when the bonus is on, the days, hours, zones and amount appear here and on the home screen during a window: «مكافأة الذروة الآن: +{المبلغ} لكل طلب حتى {الساعة}».

---

## 13. Support «الدعم»

- **Contact:** «اتصال بالعمليات» and «واتساب العمليات» use the numbers from Content (AP §9.13).
- **Report a problem:** pick a type (Appendix C), optionally an order, a note and a photo. This creates a ticket in the panel (AP §9.9.1).
- **My reports «بلاغاتي»:** the captain's tickets and appeals, with their status and resolution messages.
- **Messages «الرسائل»:** direct messages from OPS, and announcements.
- **FAQ:** the captain FAQ set from Content (AP §9.13).
- **Requests:** changes to the phone, vehicle or neighbourhood; ending the contract; a kit swap.

> In V1, conversations happen by phone or WhatsApp. In-app chat comes in V2.

---

## 14. Notifications and sounds

| # | Event | Sound | Text |
|---|---|---|---|
| 1 | New offer | Offer ring (§4.4) | «عرض جديد: {الأجر} — {المطعم}» |
| 2 | Offer taken or withdrawn before an answer | Silent | The sheet closes with «لم يعد العرض متاحاً» |
| 3 | Auto-offline after 3 expired offers | Chime | «لم ترد على 3 عروض متتالية، فأصبحت غير متصل…» |
| 4 | Assigned by operations (no offer) | Chime | «عيّنتك العمليات على طلب #{رقم}» |
| 5 | Order ready | Chime | «الطلب #{رقم} جاهز» |
| 6 | Waiting pay started | Silent | Screen update |
| 7 | Pickup confirmed (restaurant, automatic or operations) | Chime | «تم الاستلام — توجّه إلى الزبون» |
| 8 | Pickup disputed or marked incomplete | Chime | §9.4 texts |
| 9 | Pickup dispute after confirmation | Chime | «فتح المطعم بلاغاً عن مبلغ الاستلام…» |
| 10 | Edit by operations | Chime | «تم تعديل الطلب #{رقم}…» |
| 11 | Withdrawn, cancelled or handed over | Cancellation sound | §9.10 texts |
| 12 | Order cancelled while it was still waiting for the restaurant (an early manual assignment) | Cancellation sound | «أُلغي الطلب #{رقم}» |
| 13 | Operations answered «الزبون لا يستجيب» | Chime | «انتظر» or the outcome |
| 13a | The customer answered a ping | Chime | «الزبون رأى التنبيه وهو قادم», or «الزبون يتواصل مع المستلم» for an order with a recipient |
| 14 | Outcome posted with a charge | Silent push | «خُصم من مستحقاتك {المبلغ}: {السبب}» |
| 15 | Cash limit at 80% / 100% | Chime | §10.4 texts |
| 16 | Hand-in reminder (22:00) | Chime | «عليك تسليم {المبلغ} اليوم. المكتب مفتوح حتى {الساعة}.» |
| 17 | Cutoff passed with cash due while online | Chime | «سلّم نقد أمس قبل {الساعة} لتستمر العروض» |
| 18 | Hand-in grace granted | Silent push | «مُنحت مهلة حتى {الساعة}» |
| 19 | Desk receipt (hand-in, reimbursement, payout, deposit) | Silent push | «إيصال {رقم}: {النوع} {المبلغ}» |
| 20 | Weekly statement | Silent push | «كشف الأسبوع جاهز: قبضت {المبلغ}» |
| 21 | Bonus | Silent push | «مكافأة {المبلغ}: {السبب}» |
| 22 | Pay table change announced | Silent push | «جدول أجور جديد يبدأ في {التاريخ}» |
| 23 | Peak window starts | Chime | «مكافأة الذروة الآن…» |
| 24 | Operations announcement or direct message | Chime | The message |
| 25 | Violation recorded | Silent push | «سُجّلت عليك مخالفة: {النوع} — {النتيجة}» |
| 26 | Suspension, reactivation, force offline | Chime | With the reason |
| 27 | Document expiring (30 days) or rejected | Silent push | «تنتهي صلاحية {المستند} في {التاريخ}» / «رُفض {المستند}: {السبب}» |
| 28 | Contract phase change | Silent push | «بدأت {المرحلة} من {التاريخ}» |
| 29 | Application stage change | Silent push | §5.4 texts |
| 30 | Ticket or appeal resolved | Silent push | «تم الرد على بلاغك T-{رقم}» |
| 31 | Emergency stop on or off | Chime | Banner (§6.3) |
| 32 | Signed in on another device | — | The old device shows «سُجّل دخولك من جهاز آخر» |
| 33 | Terms version, forced update, maintenance | Blocking | §4.8, §4.2 |

Notification texts come from Content templates (AP §9.13), so admins can edit them. The texts above are the defaults.

---

## 15. Server commands

Every command:

- carries an idempotency key (§4.6)
- is checked on the server for the captain's status, the order's state and the captain track
- returns the new state
- records the captain, the device, the time and the location

| Command | Allowed when | Effect |
|---|---|---|
| Submit or update an application | No active captain account | Application created or updated (§5) |
| Upload a document | Applicant or captain | Document pending verification (§5.3, §12.2) |
| Go online | No block in §7.2 | `متصل متاح` (§7.2) |
| Go offline | No active order | `غير متصل` (§7.5) |
| Last-order mode on / off | Active order | No new offers; offline after the order (§7.3) |
| Accept offer | Offer open for this captain | Order assigned (§8.3) |
| Reject offer | Offer open | Offer closed, next captain (§8.3) |
| Arrived at the restaurant | `assigned`, within 150 m | `at_merchant` (§9.2) |
| Request pickup with payment lines | `at_merchant`, all items ticked, no block in RA §8.10 | `pickup_pending` (§9.4) |
| Confirm a handover receipt | Handover order, within 200 m of the first captain | Second captain `picked_up`; first captain `done` (§9.10.1) |
| Arrived at the customer | `picked_up`, within 200 m or with a reason | `at_customer` (§9.6) |
| Ping customer | `at_customer`, ping allowed | Ping sent (§9.9) |
| Customer not responding | `at_customer`, 3 pings and 15 min | Alert to OPS (§9.9) |
| Record payment and deliver | `at_customer`, within 200 m or with a reason, and the amount-due version still current | `delivered` and ledger entries (§9.7, §9.8) |
| Record payment for an OPS outcome | OPS ended the order with an amount to collect | Outcome posted (§9.10) |
| Can't complete, or withdraw that request | Active order | Alert to OPS, or alert closed (§9.11) |
| Emergency | Active order | Alert with location, order marked (§9.11) |
| Report a problem or appeal | Any time | Ticket (§9.11, §11.3, §13) |
| Call or WhatsApp the customer | Active order, after acceptance | Number revealed to the dialer; recorded (§9.5) |
| Set the maximum pickup amount or carried currencies | No active order | Applies to the next offer (§10.5) |
| Report the device check | After a check | Stored on the captain profile (§4.5) |
| Accept terms | A pending version | Recorded (§4.8) |
| Location batch | Online | Positions stored (§4.3) |

**Real-time events the app subscribes to** (captain channel):

- an offer opened or closed
- the active order updated: status, restaurant ready, pickup request result, edits, withdrawal, handover, cancellation, outcome
- custody or earnings entry posted
- a receipt or statement issued
- a block, grace or suspension changed
- messages and announcements
- platform broadcasts: emergency stop, maintenance, version

---

## 16. Changes made to the other specs

### 16.1 Admin panel spec (`docs/v1/admin-panel.md`)

1. **Header and AP §1.1:** the captain app is for Android and iOS, and the captain spec is linked.
2. **Dispatch (AP §9.12.6):**
   - eligibility adds the captain's maximum pickup amount (C4)
   - 3 expired offers in a row set the captain offline (C3)
   - the assignment picker shows «المبلغ أكبر مما يحمله» as a reason, which OPS may override (AP §9.3.2)
3. **New alerts (AP §9.1.3):**
   - «كابتن لا يستطيع إكمال الطلب» (critical)
   - «طوارئ كابتن» (critical)
   - «تسليم بعيد عن العنوان» (information)
4. **Order actions (AP §9.3.2):**
   - «تسجيل وصول الكابتن» (record the captain's arrival when GPS fails)
   - «تحديد النتيجة» asks for the amount to collect, and the captain records the payment lines (K9)
5. **Outcomes and pickups:**
   - AP §8.9: failed orders record where the food went, and «أُعيد إلى المطعم» only when the restaurant is responsible (K10).
   - AP §8.1: the cash question is asked once the captain has arrived at the restaurant, not only after a pickup request.
   - AP §8.6: the door-payment rounding tolerance uses the largest rounding unit among the lines.
   - AP §9.3.2: the handover is allowed in `arrived` too, with a defined second-captain leg, and OPS can record a delivery on the captain's behalf.
   - AP §9.9.1: captains can open pickup-dispute tickets.
6. **Captains module:**
   - AP §9.7.1: re-applications and the early-exit approval
   - AP §9.7.2: the early-exit policy (C17)
   - AP §9.7.4: the profile shows the maximum pickup amount, carried currencies, the device check and the signed-in device
   - AP §9.7.5: appeals from the app (C16), «تحرير الجهاز» (release the device), and force offline during an order meaning last-order mode (K18)
   - AP §9.7.6: withdrawal after acceptance through the in-app button (C5), and automatic offline after expired offers (C3)
7. **Cities (AP §9.12.1):** the office location as well as its hours (C13).
8. **Open items (AP §13):** items 1 (early exit), 3 (captain cash at pickup) and 7 (criminal record validity) are now decided.
9. **Settings and lists:** new keys in AP Appendix A, new reason lists in AP Appendix B and AP §9.13, and new permissions and reasons in AP §6.3 and AP §4.5.
10. **Done (AP §14):** a captain-integration item.

### 16.2 Restaurant app spec (`docs/v1/restaurant-app.md`)

1. Header: the captain spec is linked.
2. RA §12.7: how payment lines are proposed now points to §10.5 here.
3. RA §8.9: the captain's arrival uses the 150-metre rule (C6).

---

## 17. Not in the captain app V1

| Feature | Version |
|---|---|
| Two orders in one trip (stacking) | V3 |
| In-app chat with operations or customers | V2 |
| The captain rating customers or restaurants | V2 |
| Shifts, booking hours and a commitment ratio | V2 |
| A demand map showing where orders are likely | V6 |
| Leaderboards and ranks | V4 |
| Incentive programmes beyond the peak bonus | V4 |
| Paying the restaurant through the platform (no cash float) | V5 |
| Payouts to a bank or wallet | V5 |
| Photo proof at pickup or delivery | V2 |
| A customer delivery code | V2 |
| Masked calls (a proxy number) | V2 |
| Errands and parcel delivery | V3 |
| English UI and dark theme | V2 |

---

## 18. Open items (these do not block the build)

1. **iPhone distribution in Azaz.** *Closed* (technology-stack T3, 2026-11-04): the Apple Developer account is available. App review requirements are handled at submission.
2. **Critical Alerts on iPhone.** Apply to Apple for the entitlement (K15). Without it, an iPhone on silent may not sound for offers. Field-test both cases before launch.
3. **Push in Azaz.** The Google Play and Firebase accounts are available (technology-stack T3). As RA §21 item 2: still test FCM and APNs delivery on real devices and networks.
4. **Distance service.** *Decided* (AP §13 item 8): self-hosted OSRM (technology-stack §7.1), with the straight-line fallback.
5. **Insurance and accidents.** Who covers a captain's accident during an order, and what the emergency procedure is beyond calling operations. The app has the button; the procedure is a business decision.
6. **Full-screen offers on Android 14+.** Google Play limits the full-screen notification permission to some app types (as RA §21 item 4). Verify the policy at submission. The fallback is a heads-up notification with the looping alarm sound, which the device check prepares.

---

## 19. Definition of done (captain app V1)

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

---

## Appendix A. Settings

New settings introduced by this spec. They are also listed in AP Appendix A. Scope: **C** per city.

| Key | Default | Scope | Edit | Description |
|---|---|---|---|---|
| `captain.offer_expiry_offline_count` | 3 | C | OWN | Consecutive expired offers that set a captain offline (C3) |
| `captain.merchant_arrival_radius_m` | 150 | C | OWN | Distance from the restaurant within which «وصلت إلى المطعم» works (C6) |
| `captain.customer_radius_m` | 200 | C | OWN | Distance from the customer's pin within which arrival and delivery need no reason (C9) |
| `captain.criminal_record_validity_months` | 12 | C | OWN | Validity of the criminal record certificate from its issue date (C18) |

**Existing settings this app uses** (AP Appendix A):

- `dispatch.offer_timeout_sec`, `dispatch.manual_assign_requires_accept`
- `captain.waiting_threshold_min`, `captain.custody_warn_pct`, `captain.remit_tolerance`, `captain.remit_online_grace_hours`
- `captain.payout_weekday`, `captain.negative_earnings_policy`
- `captain.acceptance_window_offers`, `captain.acceptance_alert_pct`, `captain.acceptance_review_pct`
- `captain.violation_window_days`, `captain.document_expiry_notice_days`, `captain.min_age`, `captain.gps_stale_alert_min`
- `customer.no_answer_pings`, `customer.no_answer_ping_interval_min`
- `order.pickup_confirm_timeout_sec`
- `finance.business_day_cutoff`
- `otp.*`, `app.captain.*`

**Per-captain fields** (not settings): cash limit (FIN), maximum pickup amount (the captain), carried currencies (the captain), vehicle (OPS).

**Fixed values in this spec:**

| Value | Fixed at |
|---|---|
| Location interval while online | 10 s (AP §4.2) |
| Location while offline | None collected |
| Offline chime | After 30 s without connection |
| Signed-in devices per captain | 1 |
| Re-apply after rejection | 30 days |
| Emergency button press | 2 s |
| Hand-in reminder push | 22:00 city time |
| GPS accuracy for the "weak signal" hint | Worse than 100 m |
| On-time rate window | Last 50 delivered orders |

---

## Appendix B. Main Arabic UI strings

| Key | Arabic |
|---|---|
| States | «غير متصل» · «متصل متاح» · «مشغول» · «آخر طلب» · «لا تصلك عروض» · «موقوف» |
| Home | «متصل» · «لا أريد طلبات جديدة» · «أرباح اليوم» · «طلبات اليوم» · «نسبة القبول» · «عليك تسليم {المبلغ}» · «لك عند المكتب {المبلغ}» |
| Offer | «عرض جديد» · «تدفع للمطعم» · «تقبض من الزبون» · «قبول» · «رفض» · «انتهى العرض» · «لم يعد العرض متاحاً» · «تعيين من العمليات» · «قد يُضاف أجر انتظار» |
| Steps | «وصلت إلى المطعم» · «دفعت للمطعم واستلمت الطلب» · «بانتظار تأكيد المطعم» · «تم الاستلام» · «وصلت» · «تم التسليم» |
| Restaurant | «هل وصلت إلى المطعم؟» · «اقترب من المطعم لتأكيد الوصول» · «بعد تأكيد الأصناف يصبح أي نقص من مسؤوليتك» · «ادفع للمطعم: {المبلغ}» · «بانتظار تعديل الطلب من العمليات» · «المبلغ لا يطابق المطلوب» |
| Customer | «اتصال بالزبون» · «واتساب الزبون» · «تنبيه الزبون» · «الزبون لا يستجيب» · «التسليم المتوقع قبل {الساعة}» |
| Payment | «المبلغ المطلوب» · «المبلغ المقبوض» · «الباقي للزبون» · «المبلغ المقبوض أقل من المطلوب بـ {المبلغ}» · «سجّل الباقي الذي أعدته للزبون» · «تغيّر المبلغ المطلوب إلى {المبلغ}» · «إذا ترك لك الزبون الباقي إكرامية فهو لك، سجّله كأنك أعدته» |
| Summary | «ربحت من هذا الطلب» · «تغيّرت عهدتك» · «عليك تسليم اليوم» · «إنهاء العمل» |
| Problems | «مشكلة» · «لا أستطيع إكمال الطلب» · «تراجع» · «بانتظار العمليات» · «طوارئ» · «بانتظار تسجيل التحصيل» |
| Handover | «استلام من كابتن» · «لا تدفع شيئاً» · «استلمت الطلب من الكابتن {الاسم}» · «سيستلم الكابتن {الاسم} الطلب منك. انتظره في موقعك.» · «سلّمت الطلب للكابتن {الاسم}» |
| Custody | «عهدتي» · «من أيام سابقة» · «من اليوم» · «حد العهدة» · «الإيصالات» · «المكتب مفتوح حتى {الساعة}» |
| Earnings | «أرباحي» · «رصيدك المستحق» · «موعد القبض: الخميس {التاريخ}» · «كشف الأسبوع» · «احسب أجري» |
| Settings | «أقصى مبلغ أحمله» · «العملات التي أحملها» · «فحص الجهاز» · «سمعت الصوت» |
| Device | «هاتفك قد لا يرن عند وصول عرض — أكمل فحص الجهاز» · «سُجّل دخولك من جهاز آخر» · «أوقف تطبيقات تغيير الموقع لتتمكن من الاتصال.» |
| Joining | «انضم ككابتن» · «تسجيل الدخول» · «إرسال الطلب» · «بانتظار التحقق» · «مقبول» · «مرفوض» · «رفع نسخة جديدة» |

---

## Appendix C. Reason lists used by the app

These defaults are editable in Content (AP §9.13, AP Appendix B).

| List | Values |
|---|---|
| Captain problem on an order (AP Appendix B) | «المطعم متأخر» · «صنف ناقص» · «مشكلة في مبلغ الاستلام» (opens a pickup-dispute ticket) · «العنوان خاطئ» · «الزبون لا يرد» · «حادث أو طارئ» · «أخرى» |
| Can't complete the order (C5) | «عطل في المركبة» · «حادث» · «ظرف طارئ» · «لا أملك المبلغ المطلوب للمطعم» · «أخرى» (text) |
| Arrival or delivery away from the pin (C9, K4) | «الزبون طلب مكاناً آخر» · «موقع الزبون على الخريطة غير دقيق» · «أخرى» (text) |
| Collected less than due (K16) | «الزبون لا يملك المبلغ كاملاً» · «خطأ في العد» · «أخرى» (text) |
| Food after a failed order (K10) | «يبقى مع الكابتن» · «أُعيد إلى المطعم» · «أُتلف» |
| Captain ticket types (§13) | «مشكلة في طلب» · «مشكلة في العهدة أو الأرباح» · «طلب تعديل بيانات» · «إنهاء التعاقد» · «تبديل العدة» · «مشكلة في التطبيق» · «أخرى» |
