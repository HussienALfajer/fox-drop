# FOX DROP V1 — Restaurant App Specification

| | |
|---|---|
| Product | FOX DROP, a food delivery platform launching in Azaz, Syria, then expanding city by city |
| Scope | V1, the first version that completes a full order cycle |
| Component | The restaurant side «تطبيق المطعم»: an Android app (phone and tablet), a Windows desktop app, and an owner web portal «بوابة المطعم» |
| Status | Approved by the owner on 2026-11-02 (decisions in §2) |
| Audience | Engineers and coding agents (Claude Code) who build the restaurant apps and the server rules behind them |
| UI language | Arabic only, right to left |
| Related | Admin panel spec `docs/v1/admin-panel.md`, cited here as "AP §n". Captain app spec `docs/v1/captain-app.md`. Customer app spec `docs/v1/customer-app.md`. Arabic V1 plan page: https://claude.ai/artifact/8XR91QrZHk73nRHdu7E1q6 (section 19). BeeOrder merchant research: `docs/beeorder-research/02-merchant-side.md`. Technology stack: `docs/architecture/technology-stack.md` |

---

## 0. How to use this document

- This document is the source of truth for everything a restaurant sees and does in FOX DROP V1. If it differs from the Arabic plan page, this document wins.
- Shared domain rules live in AP §8: order statuses, timers, money formulas, ledgers, currencies and outcomes. This document cites them instead of repeating them. Where this document changes a shared rule, the admin panel spec was updated in the same change; §19 lists every such change.
- **MUST** means required for V1. **SHOULD** means expected unless there is a strong reason not to. **MAY** means optional.
- `dotted.keys` are server settings. New keys are listed in Appendix A; existing keys are in AP Appendix A. Every number is the default value of a setting unless it is marked **fixed**. A fixed number is a product rule; changing it needs a code change.
- Ledger entry types such as `merchant.commission` or `custody.pay_merchant` are enum values of ledger entries, not settings (AP §0).
- «Arabic text» is the UI label. Keep every label in a translation file, so V2 can add English without code changes. Appendix B collects the main strings.
- Role codes in this document: `MO` restaurant owner «مالك» and `MC` cashier «كاشير» (§5). `OWN`, `OPS`, `SUP`, `FIN` and `DATA` are admin-panel roles (AP §6).
- "The app" means the Android and Windows apps, which have the same features. "The portal" means the owner web portal (§17).
- Money examples use TRY as the base currency only to make them readable, as in AP.

---

## 1. Context and principles

### 1.1 What the restaurant app is

FOX DROP partners are restaurants and ready-food shops: restaurants, sweets, bakeries, cafés and juice shops (AP §1.1). They use one product to run their side of the platform:

- receive orders with a loud, repeating alert, accept or reject them, and prepare them on time
- hand orders to captains and confirm the cash they receive
- keep the menu and its availability up to date
- set opening hours, and pause or slow down when the kitchen is under pressure
- follow their sales, their performance and their account with FOX DROP

BeeOrder splits this between a Windows order receiver and a web dashboard (research `02-merchant-side.md` §2). FOX DROP gives each restaurant one app that runs on Android or Windows, plus a web portal for the owner.

### 1.2 The order cycle from the restaurant's side

1. A new order rings on every receiving device of the restaurant.
2. A cashier or owner accepts it with a prep time, or rejects it with a reason.
3. The kitchen prepares it. The app shows the captain on the way and when they arrive.
4. The restaurant presses «الطلب جاهز» (order ready) when the food is ready.
5. The captain checks the items, pays the full items value in cash, and asks the restaurant to confirm. The restaurant confirms with one tap (R4).
6. The order travels with the captain until delivery, then moves to history.
7. Every Saturday the owner settles the week's commission with FOX DROP.

### 1.3 Money in one paragraph (AP D26)

At pickup the captain pays the restaurant the **full items value** in cash, with nothing deducted. During the week, the restaurant's account with FOX DROP accumulates what it owes: the commission on each order and its share of any discount it funded. Every Saturday the owner pays that amount at the office or to a visiting staff member and gets a receipt in the app. The restaurant never sees the delivery fee or the customer's total (R11).

### 1.4 Principles (MUST)

1. **Never miss an order.** New orders ring loudly and repeatedly on every receiving device, with the screen off and the app in the background. The app checks each device and warns when it may not ring (§4.5). Operations are alerted when an open restaurant has no device connected (§4.6).
2. **The server is the authority.** The server owns order state, timers and every amount. The app shows them and sends commands; it never computes money on its own.
3. **Configured from the panel.** Timers, choices and limits come from server settings. Changing them needs no app update.
4. **Built for a busy counter.** One main action per card, large tap targets, almost no typing. A cashier with flour on their hands can accept an order with one tap.
5. **Works on unstable internet.** Commands retry safely and never apply twice. The connection state is always visible (§4.7).
6. **Customer privacy.** The restaurant never sees the customer's phone number, last name or full address. It sees the first name and the neighbourhood only.
7. **Money is for owners.** Cashiers see the items and their value, because they receive the cash. Commission, net amounts, the account, statements and reports are visible to owners only (R10).
8. **Every action is attributed.** Every command records the user, the device and the time. Admins see these in the order timeline and the restaurant change log (AP §9.3.1 and AP §9.6.4).

---

## 2. Decisions

### 2.1 Owner decisions (2026-11-02)

| ID | Topic | Decision |
|---|---|---|
| R1 | Platforms | An Android app for phones and tablets, and a Windows desktop app with the same features. The owner also gets a web portal (R15). |
| R2 | Roles and devices | Two roles only: «مالك» (owner) and «كاشير» (cashier). A restaurant may sign in on any number of devices. All receiving devices ring together, and the first device to act stops the ring everywhere. An owner may turn off ringing on their own device, which then gets silent notifications instead. |
| R3 | Rejection reasons | Three reasons: item unavailable, restaurant closed, too many orders. There is no free-text "other reason". |
| R4 | Pickup confirmation | The captain taps «دفعت للمطعم واستلمت الطلب». The restaurant immediately gets a prompt with the amount and confirms with one tap, or reports that the amount is wrong. The pickup completes only on the restaurant's confirmation. If the restaurant does not answer within 60 seconds, the pickup is confirmed automatically. The «المبلغ غير صحيح» (amount incorrect) button stays available for 10 minutes after pickup and opens an urgent ticket. |
| R5 | Max concurrent orders (AP D18) | A busy mode «وضع الضغط» adds 10 or 20 minutes to the time customers see, instead of pausing the restaurant. The owner may also set a maximum number of active orders, off by default. When the restaurant reaches it, the restaurant becomes «مشغول» (busy) automatically until the count drops. |
| R6 | Item unavailable after acceptance | A button «صنف غير متوفر — اتصلوا بالزبون» sends an urgent alert to operations, who call the customer and edit the order instead of cancelling all of it. |
| R7 | Prep time extension | The restaurant cannot extend the prep time it chose. Only operations can change it. |
| R8 | Auto-cancel countdown | The new-order card shows the time left before the order is cancelled automatically. |
| R9 | Pickup currency | By default the captain pays in the city's base currency only. The owner may also accept USD and/or SYP at the exchange rate set in the panel. |
| R10 | Who sees money | Owners only. Cashiers see the items and the items value, but not the commission, the net amount, the account or reports. |
| R11 | Delivery fee and customer total | Not shown to the restaurant. It sees the items, what the captain pays it, and (owners) the commission. |
| R12 | Menu edits | Availability and price changes publish immediately, with a log the admins see. New items and new photos go to admin review before customers see them. |
| R13 | Minimum order and delivery coverage | Set by admins only. The restaurant asks for changes through support. |
| R14 | «غير متوفر حتى الغد» | Added: an item marked unavailable until tomorrow becomes available again automatically. |
| R15 | Owner web portal | Included in V1. It has everything except receiving orders; live orders are shown read-only. |
| R16 | Replies to ratings | Not in V1. |
| R17 | Calling the captain | Allowed from a button during an active order only. |
| R18 | Printing | V2, for all platforms. |

### 2.2 Rules set by this spec

The owner did not decide these explicitly. They follow from the decisions above or close gaps found while writing this spec. The owner may change any of them.

| ID | Rule | Why |
|---|---|---|
| S1 | Name and description changes, new categories and option-group changes also go to admin review (§9.2). | They change what customers see as much as a new item does. |
| S2 | Rejecting an order with «المطعم مغلق» also pauses the restaurant until it reopens (§8.6). | Otherwise the next order arrives and is rejected again. |
| S3 | A pause «حتى أعيد الفتح» and busy mode both end at the end of the current opening period (§7). | A forgotten switch must not keep a restaurant closed or slow the next day. |
| S4 | A pause set by operations or by the auto-pause rule can be ended only by operations (§7.1). | Matches the auto-pause rule in AP §9.6.5. |
| S5 | Owners are added and removed only from the admin panel. Owners add and remove cashiers (§5.1). | A cashier can never gain access to money from inside the app. |
| S6 | In V1 one phone number belongs to one restaurant (fixed). | Multi-branch accounts are V2. |
| S7 | Every device runs a device check, and operations are alerted when an open restaurant has no receiving device (§4.5, §4.6). | Cheap phones kill background apps; this is the main reason restaurants miss orders. |
| S8 | If the restaurant forgot to press ready, the pickup confirmation records `ready` at the same moment (§8.10). | A forgotten button must not block the captain. |
| S9 | Operations can confirm a pickup on the restaurant's behalf, with a reason (§8.10). | Resolves a deadlock when the restaurant disputes but the captain has paid. |
| S10 | A pickup dispute after confirmation is corrected in the accounts with `custody.pickup_correction` and a restaurant credit or debit (§8.10, AP §9.9.3). | The cash difference sits with the captain and has to reach the restaurant. |
| S11 | A price change larger than 30% raises an information alert for operations (§9.4). | Prices publish immediately (R12), so operations need a signal for typos and price-parity problems. |
| S12 | Cashiers see today plus the previous 7 business days of history, without money (§8.18). | Enough to answer a captain or a customer complaint. |
| S13 | A new version of the restaurant terms blocks every owner screen except Orders until the owner accepts it. Owner and cashier devices keep receiving orders (§4.10). | Orders must not stop because the owner is away. |
| S14 | Portal sessions last 30 days (§5.3). | The portal shows money; app devices stay signed in. |
| S15 | Owners are notified when FOX DROP changes their commission (§12.2, AP §10). | The restaurant must know its terms before they apply. |
| S16 | While an order is late and not ready, the prep-late chime repeats every 5 minutes (fixed) (§8.7). | A single chime is easy to miss in a loud kitchen. |
| S17 | The pickup prompt has a third, smaller option «الطلب غير مكتمل» (§8.10). | A restaurant that notices a missing item must not be pushed into an automatic confirmation. |
| S18 | Owners see a restaurant-funded delivery discount as its own line (§8.4). This is the only delivery amount the restaurant ever sees. | The restaurant pays it on Saturday, so it must see it. This is an exception to R11. |
| S19 | While a pickup request is open (at most 60 s), operations cannot edit the order or reassign the captain, and the restaurant cannot report an item unavailable. After cancelling or reassigning, operations record whether the cash was returned (§8.10, AP §8.1). | The captain pays before tapping, so cash may already have changed hands. |

### 2.3 Admin-panel decisions that shape this app

| AP decision | Effect here |
|---|---|
| D7 Emergency stop | A banner on every screen; active orders continue (§8.17) |
| D8 Admin order editing | Edits reach the restaurant with a prompt to acknowledge (§8.13) |
| D9 Platform hours | The platform runs 24/7; each restaurant keeps its own hours (§10) |
| D13, D26 Settlement | The captain pays the full items value at pickup; the restaurant settles every Saturday (§12) |
| D16 Commission changes | Apply to new orders only; owners are notified (§12.2) |
| D17 Admin price edits | The restaurant is notified of every change (§9.4) |
| D18 Max concurrent orders | Decided here: R5 (§7.4) |
| D25 Currencies | USD, TRY and SYP; pickup currencies per R9 (§12.7) |

---

## 3. Glossary

Terms from AP §3 (items value, pickup payment, commission, merchant net, base currency, business day, outcome, responsible party) apply unchanged.

| Term | Meaning |
|---|---|
| Receiving device «جهاز استقبال» | A signed-in app device that rings for new orders: connected, ringing turned on, and on a supported app version (§4.6). The portal is never a receiving device. |
| Ring «رنين» | A sound that loops until someone acts (§4.4). |
| Pickup request «طلب تأكيد الاستلام» | Created when the captain taps «دفعت للمطعم واستلمت الطلب». The restaurant confirms or disputes it (§8.10). |
| Pickup dispute «خلاف على مبلغ الاستلام» | The restaurant reporting that the cash it received differs from the pickup payment (§8.10). |
| Busy mode «وضع الضغط» | A flag on an open restaurant that adds 10 or 20 minutes to the time customers see (§7). |
| Busy «مشغول» | The state of a restaurant that has reached its maximum active orders. Customers cannot order until the count drops (§7.4). |
| Active orders | For the limit: the restaurant's orders in `placed`, `accepted` or `ready` (not yet picked up). |
| Device check «فحص الجهاز» | A guided check that the device will ring and stay connected (§4.5). |
| Menu change request «طلب تعديل القائمة» | A menu change that waits for admin review before customers see it (§9.5). |
| Owner web portal «بوابة المطعم» | The browser version for owners (§17). |

---

## 4. Platforms and technical foundations

### 4.1 Platforms

| Platform | Users | Receives orders | Other screens | Minimum |
|---|---|---|---|---|
| Android phone | MO, MC | Yes, with tabs | By role (§5.4) | Android 8.0 (API 26) |
| Android tablet | MO, MC | Yes, with four columns | By role | Android 8.0 (API 26) |
| Windows desktop app | MO, MC | Yes, with four columns | By role | Windows 10 or 11, 64-bit |
| Owner web portal | MO only | No: a read-only live view | Everything an owner can do | Current Chrome, Edge, Firefox or Safari |

- The Android and Windows apps MUST have the same features and rules. They are one Flutter codebase, with native layers for ringing on Android and Windows (technology-stack §12).
- Layout follows the window width, not the platform: at 840 dp or wider, the orders screen shows four columns; below that it shows tabs (§6.2).

### 4.2 Distribution and updates

- **Android:** through Google Play where it is available, and as a signed APK from the FOX DROP website. Both use the same signing certificate, so either can update the other. FOX DROP's Google Play account is available (technology-stack T3); the APK serves phones without Google Play.
- **Windows:** a signed installer from the FOX DROP website. The app updates itself: it downloads in the background and installs on the next restart. It never restarts while a ring or a pickup prompt is open, or while the restaurant has active orders.
- **Version check:** at launch and on every reconnect, the app compares its version with `app.merchant.min_version` and `app.merchant.latest_version` (AP §9.14).
  - Below the minimum: a blocking update screen with the download link for the platform.
  - Below the latest: a dismissible update banner.
- OWN SHOULD publish forced updates outside peak hours. A restaurant whose devices are all below the minimum version has no receiving device (§4.6).

### 4.3 Real-time connection and waking up

- **Connection:** every signed-in device keeps a WebSocket connection to the server, subscribed to its restaurant's channel. It sends a heartbeat every 20 seconds (fixed). The server marks a device disconnected after 60 seconds without a heartbeat (fixed).
- **Android background:** a foreground service keeps the connection open and allows ringing while the app is in the background or the screen is off. It shows a permanent notification, «FOX DROP يستقبل طلباتك». The service starts again after a reboot and after an app update.
- **Android push:** a high-priority push message is a second channel for new orders, pickup requests and cancellations. It wakes the app if the system killed the service. The app MUST NOT depend on push alone, because Google services may be missing or unreliable on some devices (§21).
- **Windows:**
  - The app starts with Windows (on by default; the device check covers it).
  - It runs in the system tray. Closing the window minimizes it to the tray.
  - Quitting asks for confirmation: «إغلاق التطبيق يوقف استقبال الطلبات على هذا الجهاز. هل أنت متأكد؟»
  - A ring brings the window to the front. Where Windows blocks that, the taskbar button flashes. A native Windows notification is shown as well.
- **Reconnect:** after any reconnect, the app fetches the full current state (active orders, restaurant state, open prompts) before showing it, so no event is missed.
- **Ordering:** every order event carries the order's version number. The app ignores an event older than the version it already shows.

### 4.4 Sounds and alert levels

| Level | Arabic | Behaviour | Used for |
|---|---|---|---|
| Ring | «رنين» | Loops until someone handles it. On Android, a full-screen prompt where the system allows it (§4.5), otherwise a heads-up notification. On Windows, the window comes to the front. | New order, pickup request, cancellation after acceptance, an edit that adds items |
| Chime | «تنبيه» | Plays once, with a notification | The events marked Chime in §16 |
| Silent | «صامت» | A notification or a screen update only | The events marked Silent in §16 |

- **Stopping a ring:** a ring stops on every device of the restaurant as soon as any device handles it (accept, reject, confirm, dispute, acknowledge), or when its condition ends (for example the order was auto-cancelled or operations accepted it).
- **Several rings at once:** one sound loop plays. The prompts stack, oldest first, with a counter.
- **Volume:** on Android, ring sounds play through the alarm audio stream, so the media volume and the ringer's silent mode do not mute them. Do Not Disturb may still silence them; the device check covers this. On Windows, the sound plays through the default output device.
- **Owner devices:** each owner device has «الرنين على هذا الجهاز» (ring on this device), on by default. When it is off, ring events reach that device as silent notifications. Cashier devices always ring (fixed). The setting affects only that device.
- **Sound files:** distinct, fixed sounds for a new order, a pickup request, a cancellation or edit, and a chime. They are bundled with the app.

### 4.5 Device check «فحص الجهاز»

The device check runs at the first sign-in on each device, and can be run again from Settings. Each step explains what to do with screenshots, including the settings path for common phone brands (Samsung, Xiaomi/Redmi/Poco, Huawei/Honor, Oppo/Realme, Vivo).

| # | Check | Android | Windows |
|---|---|---|---|
| 1 | Notifications allowed | Yes | Yes |
| 2 | Battery optimisation off for the app | Yes | — |
| 3 | Auto-start allowed (brand setting) | Yes, where the brand has one | Start with Windows on |
| 4 | Full-screen notifications allowed (Android 14+) | Yes | — |
| 5 | Alarm volume at least 70% and Do Not Disturb off or allowing the app | Yes | Output not muted |
| 6 | The computer does not sleep during opening hours | — | SHOULD read the power plan and warn |
| 7 | Test ring: the device plays the new-order sound and the user taps «سمعت الصوت» (I heard it) | Yes | Yes |
| 8 | Server connection and its delay | Yes | Yes |

- Checks 1–6 are read again automatically each time the app opens. If any check fails, a yellow banner stays on the orders screen: «هذا الجهاز قد لا يرن عند وصول طلب — أكمل فحص الجهاز».
- The result of each device's last check is sent to the server and shown in the panel (AP §9.6.4).
- At least one device MUST pass the check before a restaurant can be activated (AP §9.6.3).

### 4.6 Receiving devices and the no-device alert

- A device counts as a **receiving device** when it is signed in, connected (§4.3), has ringing on (§4.4), and runs a version at or above the minimum (§4.2).
- While the restaurant's operating state is open or busy (§7), if it has no receiving device for `merchant.no_device_alert_min` (5) minutes:
  - operations get the warning «مطعم مفتوح بلا جهاز استقبال» (restaurant open with no receiving device) (AP §9.1.3)
  - owners get a push on all their devices: «لا يوجد جهاز يستقبل الطلبات في مطعمك الآن»
  - the alert resolves itself when a receiving device connects or the restaurant stops being open
- The server does not pause the restaurant for this. The unanswered-order rule (§8.3) still applies.

### 4.7 Unstable internet

- **Safe retries:** every command carries a client-generated idempotency key. The app retries with backoff until the server answers. A command repeated with the same key is never applied twice.
- **Pending state:** while waiting, the button shows «جارٍ الإرسال…» and cannot be pressed again.
- **State conflicts:** the server checks every command against the current state when it arrives. If the state changed, the server returns the current state and the app explains what happened, for example «قُبل الطلب من جهاز {اسم الجهاز}» or «أُلغي الطلب قبل وصول قبولك».
- **Lost connection:** a red bar shows on every screen: «لا يوجد اتصال بالإنترنت — لن تصلك الطلبات الجديدة حتى يعود الاتصال». After 30 seconds offline (fixed), the device plays a chime once.
- **Clocks:** all countdowns use server time. The app measures the offset between its clock and the server's and corrects every timer, so a wrong phone clock never changes a countdown.
- **Images:** menu photos are cached on the device.

### 4.8 Formatting

As in AP §4.7: Arabic, right to left, Western digits, money with its currency symbol (`400 ₺`), dates as `dd/mm/yyyy`, 12-hour times with «ص/م», durations as «12 د» and «45 ث». Order numbers as `#10423`, receipts as `AZ-2026-000123`, tickets as `T-5521` (AP §4.8).

The app SHOULD stay usable with the system font enlarged up to 130%.

### 4.9 Business day

Daily counts and reports use the city's business day (AP §4.3; cutoff 06:00 by default). This covers:

- «اليوم» (today) in reports
- the unanswered-order counter
- items marked «غير متوفر حتى الغد», which become available again at the cutoff (§9.3)
- the Saturday statement, which closes at the Saturday cutoff (§12.3)

### 4.10 Maintenance and terms

- **Maintenance:** when `app.merchant.maintenance` is on, every device shows a blocking screen with the maintenance message (AP §9.14).
- **Terms:** when a new version of the restaurant terms is published (AP §9.13):
  - an owner must accept it on their next open, in the app or the portal, before using any screen other than Orders
  - owner devices keep ringing and keep the Orders screen until then, and cashier devices are not affected, so orders keep arriving (S13)

---

## 5. Accounts, sign-in and roles

### 5.1 Accounts

- A restaurant has one or more owners «مالك» and any number of cashiers «كاشير» (R2).
- The first owner is the owner phone entered in the admin wizard (AP §9.6.3, step 6).
- Further owners are added or removed only by OPS or OWN in the panel, on the restaurant's request (S5). In the app, owners appear read-only with the note «لإضافة مالك أو إزالته تواصل مع FOX DROP».
- Owners add cashiers with a name and phone number, and remove them. Removing a cashier signs out all their devices immediately.
- In V1 a phone number belongs to at most one restaurant (S6, fixed). Adding a phone that already belongs to another restaurant is refused.
- An owner's phone number is changed only from the panel.

### 5.2 Sign-in

1. The user enters their phone number.
2. The server sends a code over WhatsApp, the only channel in V1 (`otp.channel_order`, technology-stack §8.3), with `otp.validity_min` (5), `otp.max_attempts` (5) and `otp.resend_after_sec` (60) (AP Appendix A).
3. If the number belongs to no restaurant: «هذا الرقم غير مسجّل لدى أي مطعم في FOX DROP» with call and WhatsApp buttons for the team. There is no self-signup.
4. If the restaurant's account is `draft`: «حساب مطعمك قيد الإعداد. سنتواصل معك عند جاهزيته.»
5. **First sign-in on a device (app):**
   1. Name the device, for example «كاشير 1» or «تابلت المطبخ».
   2. Run the device check (§4.5). It can be skipped, but the yellow banner stays until it passes.
   3. Owners accept the terms if a version is pending (§4.10).

### 5.3 Sessions and devices

- **App sessions** do not expire with inactivity. A session ends when:
  - the user signs out
  - an owner signs the device out (§14.2)
  - the user is removed
  - an admin forces the restaurant's devices to sign out (AP §9.6.4)
- **Portal sessions** last `merchant.web_session_days` (30) days and end on sign-out (S14).
- **Each device record** holds its name, platform, app version, user and role, ring on or off, last device-check result, connected now or last seen, and signed-in since.

### 5.4 Permissions

The server enforces every permission. The app hides what a role cannot do.

| Capability | Owner (app) | Cashier (app) | Owner (portal) |
|---|---|---|---|
| Receive, accept and reject new orders | Yes | Yes | No |
| Mark ready, confirm or dispute a pickup, report an item unavailable, acknowledge edits and cancellations | Yes | Yes | No |
| See live orders | Yes | Yes | Read-only |
| See items and the items value (the pickup payment) | Yes | Yes | Yes |
| See commission, restaurant-funded discounts and the net amount | Yes | No | Yes |
| Order history | Full, with money | Today plus the previous 7 business days, without money (S12) | Full, with money |
| Call the captain | Yes | Yes | No |
| Menu availability | Yes | Yes | Yes |
| Menu prices, items, photos, categories and options | Yes | No | Yes |
| Pause, resume and busy mode | Yes | Yes | Yes |
| Hours, holiday close, default prep time, maximum active orders | Yes | No | Yes |
| Pickup currencies | Yes | No | Yes |
| Reports | Yes | No | Yes, with Excel export |
| Account, statements and receipts | Yes | No | Yes, with PDF and Excel |
| Ratings | Yes | No | Yes |
| Staff and devices | Yes | No | Yes |
| Ring on or off for this device | Yes | No (always on) | — |
| Support | Yes | Yes | Yes |

### 5.5 Restaurant account status (AP §9.6.1)

| Status | What the app does |
|---|---|
| `draft` | Sign-in refused (§5.2) |
| `test` | Everything works. A blue banner says «وضع تجريبي — مطعمك ظاهر لحسابات الاختبار فقط». Test orders are marked (§8.16). |
| `active` | Normal |
| `suspended` | No new orders arrive. A red banner shows «حساب مطعمك معلّق: {السبب}. تواصل مع فريق العمليات.» Active orders, history, menu, money and support still work. |
| `terminated` | Cashiers cannot sign in. Owners can sign in to the money section only, read-only: statements, receipts and the final balance. |

---

## 6. Navigation

### 6.1 Screen map

| # | Screen | Arabic | Owner | Cashier | Portal |
|---|---|---|---|---|---|
| 1 | Orders | «الطلبات» | Yes | Yes | Read-only (§17) |
| 2 | History | «السجل» | Yes | Limited (§5.4) | Yes |
| 3 | Menu | «القائمة» | Yes | Availability only | Yes |
| 4 | Status and hours | «الحالة والأوقات» | Yes | Status only | Yes |
| 5 | Reports | «التقارير» | Yes | — | Yes |
| 6 | Account | «الحساب» | Yes | — | Yes |
| 7 | Ratings | «التقييمات» | Yes | — | Yes |
| 8 | Staff and devices | «الموظفون والأجهزة» | Yes | — | Yes |
| 9 | Settings | «الإعدادات» | Yes | This device only | Restaurant settings |
| 10 | Support | «الدعم» | Yes | Yes | Yes |

### 6.2 Layout

- **Top bar (every screen):** restaurant name, a status pill (tap to open the status sheet, §7.2), a connection dot (green when connected, red when not) and a support button.
- **Phone:** bottom navigation with «الطلبات», «القائمة», «الحالة» and «المزيد» (more). «المزيد» holds the other screens.
- **Tablet (840 dp or wider) and Windows:** a navigation rail on the right, and the orders board in four columns.
- **Touch targets:** at least 48 dp. The main action on a card is at least 56 dp tall.
- **Keep screen on:** an option on Android, on by default for tablets and off for phones. While on, the orders screen keeps the display awake.
- **Theme:** light theme in V1, with high-contrast status colours.

### 6.3 Banners (highest priority first)

Banners sit under the top bar. When several apply, up to two show and the rest are behind a counter.

1. No connection (red, §4.7)
2. Platform emergency stop (red, §8.17)
3. Restaurant suspended, auto-paused or paused by operations (red, §5.5, §7)
4. Device check failed (yellow, §4.5)
5. Test mode (blue, §5.5)
6. Busy because of the active-orders limit, or busy mode on (amber, §7)
7. Settlement overdue (owners; amber, §12.6)
8. App update available (grey, §4.2)

---

## 7. Restaurant status

### 7.1 States

| State | Arabic (restaurant) | Set by | Customers | Ends |
|---|---|---|---|---|
| Open | «مفتوح» | The schedule (§10) | Can order | Schedule close, a pause, a holiday close, the limit, suspension |
| Busy mode (a flag on Open) | «وضع الضغط +{د} د» | MO, MC | Can order; the time they see is longer by 10 or 20 minutes | Turned off by MO, MC or OPS, or at the end of the current opening period (S3) |
| Busy (limit reached) | «مشغول» | The system, when active orders reach the limit (§7.4) | Cannot order: «المطعم مشغول حالياً، جرّب بعد قليل» | Automatically, when active orders drop below the limit |
| Paused by the restaurant | «موقوف مؤقتاً» | MO, MC | Cannot order: «المطعم متوقف مؤقتاً، يعود خلال {المدة}», or «… يعود قريباً» when there is no end time | Timer expiry, MO/MC/OPS resume, or for «حتى أعيد الفتح» the end of the current opening period (S3) |
| Paused by operations | «أوقفته العمليات» | OPS, OWN (AP §9.6.5) | Same as paused | Expiry of a timed pause, or OPS/OWN. The restaurant cannot end it (S4). |
| Auto-paused | «أُوقف تلقائياً» | The system, after `merchant.auto_pause_unanswered_count` (3) unanswered orders in a business day (§8.3) | Same as paused | OPS or OWN only. It holds across opening periods. |
| Closed by schedule | «مغلق» | The schedule | «مغلق — يفتح {اليوم} {الساعة}» | The next opening period |
| Holiday close | «إجازة حتى {التاريخ}» | MO, OPS, OWN | «مغلق حتى {التاريخ}» plus the restaurant's message | The end date, or MO/OPS/OWN ends it |
| Suspended | «معلّق» | OPS, OWN | The restaurant is hidden | OPS or OWN |

- **Precedence:** suspended → holiday close → closed by schedule → paused (any source) → busy (limit) → open. The first one that applies is the state. Busy mode is a flag that matters only while the restaurant is open.
- **Pauses have no effect on active orders.** Orders already placed still need an answer, and orders in progress continue.
- **One pause at a time.** An operations pause or the auto-pause replaces a restaurant pause. The restaurant cannot pause while either of them is active.
- **Pauses and the schedule:** the restaurant cannot set a pause while it is closed. A restaurant pause that outlasts the opening period ends when the period ends. Operations pauses and the auto-pause do not follow the schedule. The auto-pause can start after closing time, for example when a late order is auto-cancelled, and it still applies at the next opening.
- **Logging:** every state change records its source (restaurant user and device, operations user, schedule or system) for reports (AP §9.6.5).

### 7.2 Status sheet

Tapping the status pill opens the status sheet (owners and cashiers).

- **Current state** with its remaining time, and the next schedule change, for example «يغلق اليوم 11:30 م».
- **Pause:** «إيقاف 15 د», «30 د», «60 د» (fixed choices, as in AP §9.6.5) and «حتى أعيد الفتح». No reason is asked, so pausing is fast.
- **Busy mode:** «وضع الضغط +10 د» and «+20 د» (`merchant.busy_extra_options_min`), and «إلغاء وضع الضغط».
- **Resume:** «استئناف الاستقبال».
- When operations or the auto-pause rule paused the restaurant, the buttons are disabled. The sheet explains why and shows a call button: «أوقفت العمليات مطعمك — اتصل بهم لإعادة التشغيل».

### 7.3 Busy mode «وضع الضغط»

- MO or MC turns it on with +10 or +20 minutes.
- While it is on:
  - the delivery time customers see before ordering, and the promised time of new orders, are longer by the chosen minutes
  - the prep time preselected on the accept prompt is the restaurant's default plus the chosen minutes (§8.5)
  - the customer app shows «قد يستغرق الطلب وقتاً أطول قليلاً» on the restaurant page (customer-app spec §9.2)
- It ends when MO, MC or OPS turns it off, or at the end of the current opening period (S3).
- While it is on, the app plays a reminder chime every `merchant.busy_mode_reminder_min` (60) minutes: «وضع الضغط ما زال مفعّلاً (+{د} د)».

### 7.4 Maximum active orders (R5, AP D18)

- The owner sets «الحد الأقصى للطلبات الجارية» in Status and hours (§10): off by default, or a number from 1 to 50 (fixed range).
- **Active orders** are the restaurant's orders in `placed`, `accepted` or `ready`. An order stops counting at pickup or when it ends.
- The server checks the limit atomically when an order is placed, together with the other pre-order checks (AP §1.3, principle 10). Two customers can never both take the last place.
- When the count reaches the limit:
  - the restaurant becomes «مشغول» and customers cannot order
  - the restaurant sees the banner «وصلت إلى الحد الأقصى ({العدد} طلبات جارية). لن تصلك طلبات جديدة حتى يُستلم أحدها.»
- When the count drops below the limit, the restaurant opens again automatically.
- OPS sees the limit in the restaurant profile and MAY change it on the restaurant's request (AP §9.6.5).

---

## 8. Orders

### 8.1 Statuses as the restaurant sees them

| Order status (AP §8.1) | Where it shows | Arabic |
|---|---|---|
| `placed` | Column 1 | «جديدة» |
| `accepted` | Column 2 | «قيد التحضير» |
| `ready` | Column 3 | «جاهزة» |
| `picked_up`, `arrived` | Column 4 | «مع الكابتن» |
| `delivered` | History | «تم التسليم» |
| `failed` | History | «فشل التسليم» |
| `rejected` | History | «مرفوض» |
| `cancelled` | History | «ملغى» |

**Captain line on the card** (from the captain track, AP §8.2):

| Captain track | Card line |
|---|---|
| `searching`, `offered` | «بانتظار كابتن» |
| `assigned` | «الكابتن {الاسم} في الطريق — يصل خلال {د} د» |
| `at_merchant` | «وصل الكابتن — ينتظر منذ {د} د» |
| `pickup_pending` | «الكابتن يطلب تأكيد الاستلام» |
| `picked_up` onwards | «مع الكابتن {الاسم}» |

### 8.2 Orders screen

- **Columns, right to left:** «جديدة» → «قيد التحضير» → «جاهزة» → «مع الكابتن». Each header shows the count, and how many of its orders are late.
- **On phones:** the four columns become four tabs with counts. A ringing new order switches to the «جديدة» tab.
- **Sorting:**
  - «جديدة»: oldest first
  - «قيد التحضير»: least time left first, late orders on top
  - «جاهزة»: by captain arrival, orders with the captain waiting on top
  - «مع الكابتن»: by pickup time
- **Card (compact):**
  - order number and time since it was placed
  - item count and the first items
  - the captain line (§8.1)
  - the running timer for the column: auto-cancel countdown, prep countdown, or captain waiting time
  - badges (§8.4)
  - one main button: «قبول» (accept), «الطلب جاهز» or «تأكيد الاستلام» (confirm pickup), depending on the state
- **Late cards** turn red: a new order past `order.merchant_accept_alert_min` (3), or an order in preparation past its prep time.
- Tapping a card opens the order detail (§8.4). An order leaves the board when it is delivered or ends.

### 8.3 New order

- Every receiving device rings (§4.4). The full-screen prompt shows:
  - «طلب جديد #{رقم}»
  - the items with their options and notes, and the customer note
  - the items value, «يدفعها لك الكابتن عند الاستلام»
  - the countdown to automatic cancellation, «يُلغى تلقائياً خلال {د:ث}», counting to `order.merchant_auto_cancel_min` (7) (R8)
  - the prep-time chooser and the buttons «قبول — {د} د» and «رفض»
- After `order.merchant_accept_alert_min` (3) minutes, the prompt adds «تأخرتم في الرد — سيتصل بكم فريق العمليات». Operations get their critical alert at the same moment (AP §9.1.3).
- Opening the detail does not stop the ring; only a decision does.
- **No answer:** when the order is cancelled automatically, the prompt closes with a chime and «أُلغي الطلب #{رقم} لعدم الرد». A banner shows the count: «طلبات دون رد اليوم: {العدد} من {الحد}. عند {الحد} يتوقف مطعمك تلقائياً.»
- **Auto-pause:** at `merchant.auto_pause_unanswered_count` (3) unanswered orders in one business day, the restaurant is auto-paused (§7.1, AP §9.6.5).
- **Customer cancels first:** if the customer cancels while the order is `placed`, the prompt closes with a chime and «ألغى الزبون الطلب #{رقم}». This does not count as unanswered.

### 8.4 Order detail

- **Header:** order number, the time it was placed, status, the running timer and badges.
- **Customer:** first name and neighbourhood, the customer's note, and the preset notes they picked. Never the phone number, the last name or the full address (principle 6).
- **Items:** quantity × name; options as «{المجموعة}: {الاختيار}»; add-ons; the item note; the line price. Items added by operations are marked «أضافته العمليات». Items removed by operations are struck through, marked «حذفته العمليات».
- **Money** (§12.1):
  - Everyone: «قيمة الأصناف — يدفعها لك الكابتن نقداً عند الاستلام: {المبلغ}». If the restaurant accepts other pickup currencies (§12.7), the equivalents are shown under it.
  - Owners only:
    - «العمولة {النسبة}% — تُسدَّد يوم السبت: {المبلغ}»
    - «خصم يموّله المطعم: {المبلغ}», only when there is one. A restaurant-funded free-delivery code shows as «خصم توصيل يموّله المطعم: {المبلغ}». This is the only delivery amount the restaurant sees, because it pays it (S18).
    - «صافيك من الطلب: {المبلغ}»
  - Test orders show «طلب تجريبي — لا عمولة» instead of the commission lines.
  - The delivery fee and the customer total are never shown (R11).
- **Captain:** §8.9.
- **Badges:**
  - «طلب تجريبي» (test order)
  - «قبلته العمليات» (accepted by operations)
  - «معدّل» (edited)
  - «صنف نفد — بانتظار العمليات» (item unavailable, waiting for operations)
  - «متأخر» (late)
- **Timeline (short):** placed; accepted (user and device, or operations); ready; captain arrived; pickup requested; pickup confirmed (user and device, automatically, or by operations); delivered or ended; edits and cancellations with their reasons.
- **Actions:** by state and role, as in §18.

### 8.5 Accept

- **Prep time chooser:**
  - chips from `merchant.prep_time_options` (10, 15, 20, 30, 45 minutes)
  - «−» and «+» buttons in steps of `merchant.prep_time_step_min` (5)
  - limited to `merchant.prep_time_floor_min` (5) and `merchant.prep_time_ceiling_min` (90)
- **Preselected value:** the restaurant's default prep time (§10), plus the busy-mode minutes when busy mode is on (§7.3). The accept button shows the chosen time, «قبول — 20 د», so one tap accepts with the default.
- **Effect:**
  - the order becomes `accepted` with the chosen prep time
  - the customer sees «المطعم يحضّر طلبك» with the time
  - the server computes the search-start moment for dispatch (AP §8.3)
  - the ring stops on every device, and the card moves to «قيد التحضير»

### 8.6 Reject

- Rejecting is possible only while the order is `placed`. After acceptance the restaurant cannot reject or cancel; it uses §8.12 or calls operations.
- A reason is required, one of three (R3, Appendix C):

| Reason | Arabic | Extra step | Side effect |
|---|---|---|---|
| Item unavailable | «صنف غير متوفر» | Pick one or more items from the order (required), and for each «حتى الغد» (default) or «حتى أعيده» | Those items become unavailable immediately (§9.3) |
| Restaurant closed | «المطعم مغلق» | None. The dialog says: «سيتوقف مطعمك عن استقبال الطلبات حتى تعيد الفتح» | The restaurant is paused «حتى أعيد الفتح» (S2, §7.1). This happens only while the restaurant is open or busy, and no operations pause or auto-pause is active. |
| Too many orders | «ضغط طلبات» | Optional: «تفعيل وضع الضغط» or «إيقاف 30 د» | Only what the user picks |

- **Effect:** the order becomes `rejected`. The customer sees the customer-facing reason and similar restaurants (customer-app spec §11.9). The rejection counts in the restaurant's rejection rate (§11).

### 8.7 Preparing

- A countdown runs from acceptance to the end of the chosen prep time.
- **At zero:** the card turns red and counts up, «متأخر {د} د». Every device plays a chime with «تحضير متأخر #{رقم} — اضغط «الطلب جاهز» فور الانتهاء». The chime repeats every 5 minutes (fixed) until the order is ready (S16).
- Operations are alerted `order.prep_late_ops_alert_min` (10) minutes after the prep time (AP §8.3).
- **No extension (R7):** the restaurant cannot change the prep time. The card shows a link, «تحتاج وقتاً أطول؟ اتصل بالعمليات», which calls operations.
- **Time changed by operations** (AP §9.3.2 «تعديل الوقت»): the countdown updates and every device chimes with «عدّلت العمليات وقت تحضير #{رقم} إلى {د} د».

### 8.8 Ready

- «الطلب جاهز» is available while the order is `accepted`. Pressing it early is allowed.
- A help link, «لماذا أضغط «الطلب جاهز»؟», explains: the captain is told at once, the customer sees «طلبك جاهز», and pressing it on time keeps the restaurant's late rate low.
- **Effect:** the order becomes `ready`. The assigned captain gets «الطلب جاهز». If no captain is assigned yet, the card shows «بانتظار كابتن», and operations' no-captain-after-ready timer starts (AP §8.3).
- There is no undo (fixed). A user who pressed it by mistake calls operations.
- If operations add items to a `ready` order, it goes back to «قيد التحضير» with the extra time they entered (§8.13).

### 8.9 Captain

- **Captain block on the card and detail:** photo, first name, vehicle, the captain line (§8.1), the ETA to the restaurant, and after arrival «وصل الكابتن» with a waiting timer.
- **Calling the captain (R17):**
  - The button «اتصال بالكابتن» shows from assignment until the order is delivered, failed or cancelled.
  - On Android it opens the dialer with the captain's number. On Windows it shows the number in a dialog.
  - The app does not display the number anywhere else. Every call is recorded in the order timeline.
- **Captain arrived:** every device chimes with «وصل الكابتن {الاسم} لاستلام الطلب #{رقم}». The captain can confirm arrival only within 150 metres of the restaurant, or operations record it when GPS fails (captain-app spec §9.2).
- **Captain waiting:** when the captain has waited `captain.waiting_threshold_min` (10) minutes and the order is not picked up, every device chimes with «الكابتن ينتظر الطلب #{رقم} منذ {د} دقائق». Operations get their warning at the same moment (AP §9.1.3).
- **Captain changed:** when operations reassign the order, every device chimes with «تغيّر كابتن الطلب #{رقم}: {الاسم}».

### 8.10 Pickup confirmation (R4)

**Flow:**

1. The captain arrives (`at_merchant`), checks the items against the list in the captain app, and pays the full items value in cash. They pay in the base currency, or in the currencies the restaurant accepts (§12.7).
2. The captain taps «دفعت للمطعم واستلمت الطلب» and records the currency lines they paid. The server creates a pickup request with those lines, and the captain track becomes `pickup_pending`. The amount on the request is always the order's current pickup payment, set by the server; the captain only chooses the currency lines (§12.7).
3. Every receiving device rings with the pickup prompt:
   - «الكابتن {الاسم} يؤكد أنه دفع لك {المبلغ} واستلم الطلب #{رقم}»
   - the captain's photo
   - the payment lines, for example «400 ₺» or «5 $ + 195 ₺», with the base-currency equivalent
   - two buttons: «تأكيد الاستلام» (confirm pickup) and «المبلغ غير صحيح» (amount incorrect)
   - a text link under them, «الطلب غير مكتمل» (order not complete) (S17)
   - a countdown: «يُؤكَّد تلقائياً خلال {ث} ث»

   Owner devices with ringing off show the same prompt silently.
4. **Confirm:** the server performs the pickup as one atomic action (AP §8.1): it posts `custody.pay_merchant` with the payment lines and sets the order to `picked_up`. If the restaurant had not pressed ready, `ready` is recorded at the same moment and flagged «لم يُضغط جاهز» (S8). Both apps show «تم الاستلام» at once, and the captain may leave.
5. **No answer:** after `order.pickup_confirm_timeout_sec` (60) seconds without an answer, the server confirms the pickup automatically. The timeline records «تأكيد تلقائي» (automatic confirmation).
6. **Dispute before confirmation:**
   1. The user taps «المبلغ غير صحيح» and enters what the restaurant actually received, as currency lines prefilled with the captain's lines.
   2. The request is rejected, and the order stays in its status.
   3. The captain sees «المطعم يفيد بأنه استلم {المبلغ}. أكمل المبلغ ثم أعد التأكيد.»
   4. Operations get the critical alert «خلاف على مبلغ الاستلام» (AP §9.1.3). It resolves itself when the pickup completes or the order is cancelled.
   5. The captain pays the difference and sends a new request.
   6. If they cannot agree, operations call both. They MAY confirm the pickup on the restaurant's behalf with the agreed payment lines and a reason (S9, AP §9.3.2). Or they MAY reassign or cancel the order, which asks the cash question below.
7. **Order not complete:** «الطلب غير مكتمل» rejects the request like a dispute, but without amounts and without the operations alert. The captain sees «المطعم يفيد بأن الطلب غير مكتمل». The restaurant can then report an item unavailable (§8.12).
8. **Dispute after confirmation:** after any confirmation (by the restaurant, automatic, or by operations), «المبلغ غير صحيح» stays on the order for `order.pickup_dispute_window_min` (10) minutes.
   - Using it asks for the currency lines actually received. It opens a ticket «خلاف على دفعة الاستلام», always urgent and linked to the order.
   - The order continues normally.
   - Operations or finance resolve the ticket per AP §9.9.3 (S10):
     - the captain pays the difference later, with no entries
     - or the difference is corrected in the accounts: `custody.pickup_correction` per currency on the captain, and a `merchant.credit` (or `merchant.debit`) to the restaurant
     - or the claim is rejected
   - The owner sees any resulting credit or debit in the account (§12.5).

**Rules:**

- A pickup request is possible only when:
  - the order is `accepted` or `ready`
  - the captain is the assigned captain and is at the restaurant
  - there is no open item-unavailable report (§8.12)
  - there is no unacknowledged edit that added items (§8.13)
- An order has one open pickup request at a time.
- **Payment lines:** the server proposes lines for the current pickup payment (§12.7). The captain may change the split. The server refuses lines whose converted total differs from the pickup payment by more than half the largest rounding unit among their currencies (AP §8.1).
- **While a request is open** (at most 60 seconds): the restaurant app hides «صنف غير متوفر — اتصلوا بالزبون», and operations cannot edit the order or reassign the captain (S19). Operations can still cancel; the cancellation voids the request, and the prompt closes with the reason.
- **Cash already handed over:** the captain pays before tapping, so cash may already have changed hands when a request is rejected or voided (AP §8.1).
  - The restaurant and the captain settle any difference in person before the captain sends a new request for the current amount.
  - If operations cancel the order or reassign the captain after the captain arrived at the restaurant, their dialog asks whether the restaurant returned the cash to the captain (AP §8.1).
  - If it did not, the server posts the payment on that captain's custody and a `merchant.debit` of the same amount. The restaurant then returns the cash in the Saturday settlement (§12.5).
- **Several devices:** the first answer wins. The prompt closes on the other devices with «أكّد {اسم المستخدم} الاستلام» or «أبلغ {اسم المستخدم} أن المبلغ غير صحيح».
- If every device of the restaurant is offline, the automatic confirmation after 60 seconds still applies. The restaurant can still dispute within the 10-minute window once it is back online.

### 8.11 With the captain, and finishing

- The «مع الكابتن» column shows:
  - the captain's name
  - the time since pickup
  - «المبلغ غير صحيح», while the dispute window is open
  - the call button
- **Delivered:** the order moves to history without a sound.
- **Failed** (AP §8.9): owners get a silent push with the outcome. When the restaurant is the responsible party, the push shows the money effect, for example «يُسترد منك 400 ₺ في تسوية السبت».
- **Outcome changed later** (AP §8.9, within 7 days): owners get a silent push when the restaurant's money changes.

### 8.12 Item unavailable after acceptance (R6)

- The button «صنف غير متوفر — اتصلوا بالزبون» is on orders in `accepted` or `ready`, before pickup, while no pickup request is open (§8.10).
- **The dialog asks for:**
  - the items (required)
  - for each item, «حتى الغد» (default) or «حتى أعيده»
  - an optional note: «يوجد بديل مشابه» (a similar substitute exists) or «الكمية غير كافية» (not enough quantity)
- **Effect:**
  - the items become unavailable in the menu immediately (§9.3)
  - operations get the critical alert «صنف نفد بعد القبول» (AP §9.1.3)
  - the customer app tells the customer that FOX DROP will call them (customer-app spec §11.6)
  - the card shows the badge «صنف نفد — بانتظار العمليات» and the line «العمليات تتواصل مع الزبون»
  - pickup requests are blocked until the report is resolved (§8.10)
- The restaurant keeps preparing the rest of the order.
- **Resolution:**
  - operations edit the order, removing or replacing the items (§8.13), or cancel it (§8.14); either clears the report automatically
  - operations MAY close the report without an edit, with a reason (AP §9.3.2)
  - before operations act, the restaurant MAY withdraw the report with «تراجع — الصنف متوفر», which makes the items available again

### 8.13 Edits by operations (AP §9.3.3)

- **Before pickup:** every edit opens a prompt on every device listing the changes:
  - items added, removed or changed in quantity
  - options changed
  - the new items value, and for owners the new net amount
- The user taps «اطلعت على التعديل» (I have seen the edit).
  - An edit that adds items rings until it is acknowledged, and blocks pickup requests until then (§8.10). If it is not acknowledged within `order.merchant_accept_alert_min` (3) minutes, operations get «المطعم لم يؤكد التعديل» (AP §9.1.3). They call the restaurant and MAY confirm the pickup on its behalf once it has seen the edit.
  - Any other edit chimes once and stays on the card until acknowledged. It does not block pickup.
- Operations cannot edit while a pickup request is open (§8.10). After an edit, any cash difference is settled in person, and the captain's next request carries the new amount.
- **Ready orders:** adding items to a `ready` order moves it back to «قيد التحضير» with the extra prep time operations entered.
- **After pickup:** operations may remove items with a responsible party (AP §9.3.3). When the restaurant is responsible, owners get a silent push with the amount to be returned on Saturday (§12.5).

### 8.14 Cancellation

- **Cancelled after acceptance** (by operations, AP §9.3.2): a prompt rings on every device until acknowledged with «حسناً»: «أوقف التحضير — أُلغي الطلب #{رقم}: {السبب}». The card moves to history as «ملغى».
- **Food already prepared:** operations record whether food was prepared and who is responsible (AP §8.9). If food was prepared and the restaurant is not responsible, the merchant net is credited. Owners see it in the account as «تعويض عن طلب أُلغي بعد التحضير».
- **Customer cancels while `placed`:** §8.3.

### 8.15 Accepted or rejected by operations

- **Accepted on the restaurant's behalf:** the ring stops, and every device chimes with «قبلت العمليات الطلب #{رقم} نيابة عنكم — وقت التحضير {د} د». The card moves to «قيد التحضير» with the badge «قبلته العمليات».
- **Rejected on the restaurant's behalf:** the ring stops, and every device chimes with «رفضت العمليات الطلب #{رقم}: {السبب}».
- Reports count these separately from the restaurant's own decisions (§11).

### 8.16 Test orders

- In test mode (AP §9.6.3), test orders run the full real flow, including the cash between the captain and the restaurant and the pickup confirmation.
- Cards show «طلب تجريبي». No commission or discount share is posted (AP §9.6.3).
- Test orders appear in history with their badge. They are excluded from reports and statements.

### 8.17 Emergency stop (AP D7)

- While the platform emergency stop is on, every screen shows a red banner: «المنصة متوقفة مؤقتاً عن استقبال طلبات جديدة. أكملوا الطلبات الحالية.»
- Active orders continue normally. The restaurant's own state does not change.
- When the stop ends, the banner disappears and every device chimes once.

### 8.18 History

- **Filters:** business-day range, status. Search by order number.
- **Columns:** number, time, status, item count, items value. Owners also see commission and net.
- **Detail:** the full order detail (§8.4) with its timeline.
- **Cashiers:** today and the previous 7 business days (fixed), without money columns except the items value (S12).
- **Portal:** any range, with Excel export (§17).

### 8.19 Problems on an order

- Every order has «مشكلة في الطلب» (problem with the order), with three options:
  - call operations
  - WhatsApp operations
  - report with a quick reason (Appendix C)
- A report creates a ticket linked to the order (AP §9.9.1). It is urgent while the order is active.
- The reporter sees the ticket in Support with its status and resolution (§15).

---

## 9. Menu

The FOX DROP team builds and photographs the first menu for free (AP §9.6.3). The restaurant maintains it afterwards.

### 9.1 Structure

The structure matches the admin menu editor (AP §9.6.6):

- **Categories:** name, order, hidden or shown, and an optional availability window (for example breakfast until 12:00).
- **Items:** name, description, price, photo, category, order, available or unavailable, hidden or shown.
- **Option groups:** name, required or optional, minimum and maximum choices, and options with price deltas. Add-ons are option groups with a minimum of 0. One group can be linked to many items.
- **Admin only:** item codes, badges («جديد», «الأكثر طلباً», «حار»), Excel import and deleting items.

### 9.2 What publishes immediately and what needs review (R12, S1)

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

### 9.3 Availability

- An item, an option or a whole category can be switched off. Switching off asks how long:
  - «حتى الغد» (until tomorrow, the default): available again at the next business-day cutoff (§4.9) (R14)
  - «حتى أعيده» (until I turn it back on)
- An unavailable category makes all its items unavailable without changing each item's own setting.
- If an option group is required and all its options are unavailable, the items that use it are unavailable automatically.
- Customers cannot order unavailable items. They stay visible, faded, with «غير متوفر حالياً», or «يتوفر غداً» for «حتى الغد» (customer-app spec §9.3).
- Every availability change records the user, the device and the time.

### 9.4 Prices

- **Validation:** an item price is greater than 0. An option delta is 0 or more (fixed). Decimals follow the base currency's settings (AP §8.6).
- **When it applies:** a new price applies to new orders only. Orders already placed keep their snapshot prices (AP §9.6.6).
- **Price parity:** the price screen shows the reminder «تذكير: سعر التطبيق يجب ألا يزيد على سعر المحل».
- **Bulk change (owners):** raise or lower by a percentage or a fixed amount, for one category or the whole menu, with rounding to the base currency's rounding unit and a before-and-after preview. This is the same tool as AP §9.6.6.
- **Large changes (S11):** if any single price changes by more than `merchant.price_change_alert_pct` (30)% in one edit or bulk change, operations get the information alert «تغيير أسعار كبير» (AP §9.1.3).
- **Admin price changes (D17):** owners are notified with a chime: «عدّلت FOX DROP سعر {الصنف}: {القديم} ← {الجديد}». A bulk admin change arrives as one summary notification.
- **Price log «سجل الأسعار»:** item, old price, new price, who changed it (the restaurant user's name, or «FOX DROP»), and when. Admins see the same log (AP §9.6.6).

### 9.5 Change requests

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

### 9.6 Quick edit «تعديل سريع»

- One list of every item and option, with an inline price field (owners) and an availability switch (owners and cashiers).
- Search by name and filter by category.
- Price edits from this list follow §9.4.

### 9.7 Customer preview

«معاينة كما يراها الزبون» shows the menu exactly as the customer app shows it, including unavailable and hidden items as customers see them.

---

## 10. Status and hours (owners)

- **Weekly schedule:**
  - each weekday has one or more opening periods, or «مغلق طوال اليوم» (closed all day)
  - a period may cross midnight, for example 18:00–02:00; it belongs to the day it starts
  - periods may not overlap, and each lasts at least 30 minutes (fixed)
  - the restaurant opens and closes automatically by the schedule
  - there is no manual "open now" outside the schedule in V1
- **Holiday close «إغلاق لعدة أيام»:**
  - from now, or from a chosen date and time, until a date and time
  - with an optional message to customers, up to 100 characters (fixed)
  - active orders are not affected
  - operations can end it too
- **Default prep time:** preselected on the accept prompt (§8.5). Within the chooser's limits.
- **Maximum active orders:** off, or 1–50 (§7.4).
- **Read-only, set by admins (R13):**
  - minimum order
  - delivery coverage
  - commission %
  - settlement day
  - contract dates

  A «طلب تعديل» button opens a support ticket of the type «طلب تعديل بيانات» (§15).
- **Effect of changes:** they apply immediately and are recorded in the restaurant change log that admins see (AP §9.6.4).

---

## 11. Reports (owners)

- **Periods:** «اليوم» (today), «أمس» (yesterday), «آخر 7 أيام» (last 7 days), «آخر 30 يوماً» (last 30 days). The portal adds a custom range. All periods are business days.
- **Comparison:** each number is compared with the previous period of the same length, with an up or down arrow.
- **Exclusions:** test orders are excluded everywhere.

| Metric | Definition |
|---|---|
| Orders received | Orders that reached the restaurant (`placed`) |
| Accepted by you | Accepted by a restaurant user |
| Accepted by operations | Accepted on the restaurant's behalf (§8.15) |
| Rejected | By reason, and whether the restaurant or operations rejected it |
| Unanswered | Cancelled automatically for no response (§8.3) |
| Acceptance rate | Accepted by you ÷ (orders received − orders the customer cancelled before any answer) |
| Delivered orders | Orders that reached `delivered` |
| Sales | Items value of delivered orders, after any edits |
| Average order | Sales ÷ delivered orders |
| Commission, restaurant-funded discounts, net | From the restaurant account entries of the period (§12) |
| Average time to accept | From placed to accepted, restaurant users only |
| Average actual prep time | From acceptance to ready, or to pickup when ready was not pressed, compared with the average chosen time |
| Late rate | Orders that became ready (or were picked up, when ready was not pressed) after the chosen prep time ÷ accepted orders |
| Ready not pressed | Orders picked up without «الطلب جاهز» |
| Average captain wait | From the captain's arrival to pickup |
| Rating | Average stars and number of ratings in the period |
| Top items | Top 10 items by quantity and by sales, in delivered orders |
| Orders by hour | Delivered orders per hour of the business day |
| Pause and busy time | Minutes paused (by source) and minutes in busy mode or at the limit |

- **Definitions:** an info icon next to each metric explains its definition.
- **Daily summary image:** the app builds an image of a chosen day's key numbers and shares it through the system share sheet.
- **Excel export:** in the portal (§17).

---

## 12. Money (owners)

### 12.1 How the restaurant's money works

The formulas are in AP §8.4. The restaurant sees only its own part.

| Line | Example | When |
|---|---|---|
| Items value, paid by the captain in cash | 400 | At pickup |
| Commission 15% | 60 | Owed; paid on Saturday |
| **The restaurant keeps** | **340** | |

With a 20 restaurant-funded item discount, the captain still pays 400. The commission is calculated after the restaurant's item discount: 15% × 380 = 57. On Saturday the restaurant owes 57 + 20 = 77, and keeps 400 − 77 = 323.

### 12.2 Account screen «الحساب»

- **Balance card:**
  - «المستحق عليك حتى الآن: {المبلغ}» (owed so far), live for the current week
  - «موعد التسوية: السبت {التاريخ}»
  - if a statement is overdue, a red line: «متأخر: {المبلغ} من كشف {التاريخ}»
- **Today:** «قبضت اليوم من الكباتن: {المبلغ} ({العدد} طلباً)», then the list: order, time, captain, payment lines.
- **This week:** every entry since the last statement closed, grouped by day:
  - commission and discount share per order
  - exceptions listed separately, with the order and the reason (§12.5)
- **Tabs:** «الكشوف» (statements, §12.3) and «الإيصالات» (receipts, §12.4).
- **Questions:** «لدي استفسار» on any entry or statement opens a ticket of the type «استفسار مالي», linked to that entry (§15).
- **Commission changes** (AP D16): owners get a push, «تتغيّر عمولتك إلى {النسبة}% اعتباراً من {التاريخ}» (S15). The account screen shows the current rate and any scheduled change, including a launch commission's end date.

### 12.3 Weekly statement

- **When:** generated at the business-day cutoff that starts the settlement day, Saturday 06:00 by default (AP §8.7). Owners get a push: «كشف الأسبوع جاهز: المستحق {المبلغ}. التسوية اليوم في المكتب أو عند زيارة موظفنا.»
- **Contents** (AP §8.7):
  - each order: items value received from the captain (with the currency lines), commission, restaurant-funded discount
  - exceptions (credits and debits), each with the order number and reason
  - the earlier unpaid balance
  - the total due
- **Status:** «غير مسدّد» (unpaid), «مسدّد جزئياً» (partly paid) or «مسدّد» (paid).
- **Sharing:** as an image or PDF in the app; as PDF or Excel in the portal.

### 12.4 Settlement and receipts

- V1 has no payment inside the app; electronic payments are V5. The owner pays at the office or to a visiting FOX DROP staff member (AP §9.10.3).
- **Payment:** in any accepted currency, converted at the current rate. Partial payments are allowed, and the rest stays due.
- **Receipt:** each payment gets a numbered receipt that appears in the app, with the number, amounts per currency, method («في المكتب» or «زيارة ميدانية»), staff member and time.
  - When the visitor holds the OWN or FIN role, the receipt appears at once.
  - Otherwise it appears when the cash reaches the desk (AP §9.10.3).
- **Safety note** in the app: «لا تسلّم المبلغ إلا لموظف FOX DROP معروف لديك، وتأكد من وصول الإيصال إلى التطبيق.»

### 12.5 Exceptions

Exceptions are entries other than the commission and discount share (AP §8.7):

| Entry | Arabic in the app | Effect | When |
|---|---|---|---|
| `merchant.credit` | «تعويض عن طلب أُلغي بعد التحضير» | Lowers what you owe | An order was cancelled after the food was prepared, and you were not responsible (AP §8.9) |
| `merchant.credit` | «تصحيح مبلغ الاستلام» | Lowers what you owe | A pickup dispute was resolved: the captain paid you less than the items value (§8.10) |
| `merchant.debit` | «استرداد مبلغ الاستلام» | Raises what you owe | A failed or refused order where you were responsible: you return the full pickup payment (AP §8.9) |
| `merchant.debit` | «أصناف حُذفت بعد الاستلام» | Raises what you owe | Items removed after pickup, with you responsible (AP §9.3.3) |
| `merchant.debit` | «مشكلة بعد التسليم» | Raises what you owe | A post-delivery ticket with you responsible (AP §8.10) |
| `merchant.debit` | «تصحيح مبلغ الاستلام» | Raises what you owe | A pickup dispute was resolved: the captain paid you more than the items value |
| `merchant.commission` (reversal) | «إلغاء عمولة» | Lowers what you owe | The commission on removed or affected items is reversed |
| `merchant.adjustment` | «تسوية يدوية: {السبب}» | Either way | A manual correction by FOX DROP finance |

Each exception shows the order number, the reason, and who decided it.

### 12.6 Overdue

- If a statement is not fully paid `merchant.settlement_overdue_days` (2) days after the settlement day:
  - owners get a reminder push
  - an amber banner shows: «لديك مبلغ متأخر: {المبلغ}. يرجى التسوية في أقرب وقت.»
  - OWN and FIN get the alert «مطعم متأخر في التسوية» (AP §8.7)
- The app does not pause the restaurant for this. The policy is an open item (§21, AP §13).

### 12.7 Pickup currencies (R9)

- **Setting:** «العملات التي تقبلها من الكابتن» (currencies you accept from the captain) in Settings, owners only.
  - The base currency is always accepted (fixed).
  - The owner can also switch on any other currency enabled for the city (USD, SYP).
  - Changes apply to pickups requested after the change.
  - OPS can see and change this in the restaurant profile on the restaurant's request (AP §9.6.4).
- **Conversion:** amounts in another currency use the order's snapshot exchange rates (AP §8.6), rounded by each currency's rounding rule.
- **Payment lines:** the server proposes the payment lines to the captain, as described in captain-app spec §10.5. Any rounding difference goes to `platform.fx_rounding` (AP §8.11).
- **Restaurant account:** the pickup always counts as the full items value, whatever the currency mix.
- **Display:** the pickup prompt, the order money lines and the statement show the actual currency lines and the base equivalent.

---

## 13. Ratings (owners)

- **Summary:** the average stars, the number of ratings and the distribution by stars.
- **Each rating:** stars, the reasons the customer picked, the comment and the date. Neither the customer's name nor the order number is shown, so a comment cannot be traced back to a customer (customer-app spec U15, AP §9.6.4).
- **Filters:** stars and period.
- **Replies:** none in V1 (R16).

---

## 14. Staff, devices and settings

### 14.1 Staff (owners)

- **List:** name, phone, role, number of devices, last active. Owners are listed read-only (§5.1).
- **Add a cashier:** name and phone number. The cashier signs in with that phone (§5.2).
- **Remove a cashier:** after a confirmation, all their devices are signed out.

### 14.2 Devices (owners)

- **List:** device name, platform, user, app version, ringing on or off, connected now or last seen, last device-check result.
- **Actions:** rename a device, or sign it out. Signing out a cashier's device does not remove the cashier.
- **Warning:** a banner shows when the restaurant has no receiving device (§4.6).

### 14.3 Settings

- **This device:**
  - «الرنين على هذا الجهاز» (owner devices only, §4.4)
  - «إبقاء الشاشة مضاءة» (Android, §6.2)
  - «تجربة الصوت» (test sound)
  - «فحص الجهاز» (device check, §4.5)
  - app version, and sign out
- **Restaurant (owners):** pickup currencies (§12.7). Prep time, the limit and hours are in Status and hours (§10).
- **Restaurant info (read-only):** name, logo, address, phone, category, commission %, contract dates, and the FOX DROP contact numbers.

---

## 15. Support

- **Contact:** «اتصال بالعمليات» and «واتساب العمليات», using the numbers from Content (AP §9.13). Both are reachable from the top bar and from every order.
- **Report a problem «إبلاغ عن مشكلة»:** pick a type (Appendix C), optionally an order, a note and a photo. This creates a ticket in the admin panel (AP §9.9.1).
- **My reports «بلاغاتي»:** the restaurant's tickets with their status and resolution messages. Owners see every ticket of the restaurant; cashiers see their own.
- **Data change requests:** «طلب تعديل بيانات» covers the minimum order, delivery coverage, adding or removing an owner, and changing the owner's phone.
- **FAQ «الأسئلة الشائعة»:** the restaurant FAQ set from Content (AP §9.13).

> In V1, conversations happen by phone or WhatsApp. In-app chat comes in V2.

---

## 16. Notifications and sounds

"All" means every signed-in device of the restaurant. "Owners" means owner devices and owner portal sessions. Owner devices with ringing off get Ring events silently.

| # | Event | Level | Who | Text |
|---|---|---|---|---|
| 1 | New order | Ring | All | «طلب جديد #{رقم}» |
| 2 | Auto-cancelled for no answer | Chime | All | «أُلغي الطلب #{رقم} لعدم الرد ({العدد} من {الحد} اليوم)» |
| 3 | Restaurant auto-paused | Chime | All | «أُوقف مطعمك تلقائياً بعد {العدد} طلبات دون رد. تواصل مع العمليات لإعادة التشغيل.» |
| 4 | Customer cancelled a new order | Chime | All | «ألغى الزبون الطلب #{رقم}» |
| 5 | Accepted by operations | Chime | All | «قبلت العمليات الطلب #{رقم} نيابة عنكم — وقت التحضير {د} د» |
| 6 | Rejected by operations | Chime | All | «رفضت العمليات الطلب #{رقم}: {السبب}» |
| 7 | Captain assigned | Silent | All | Card update |
| 8 | Captain changed | Chime | All | «تغيّر كابتن الطلب #{رقم}: {الاسم}» |
| 9 | Captain arrived | Chime | All | «وصل الكابتن {الاسم} لاستلام الطلب #{رقم}» |
| 10 | Captain waiting 10 min | Chime | All | «الكابتن ينتظر الطلب #{رقم} منذ {د} دقائق» |
| 11 | Prep late (repeats every 5 min) | Chime | All | «تحضير متأخر #{رقم} — اضغط «الطلب جاهز» فور الانتهاء» |
| 12 | Prep time changed by operations | Chime | All | «عدّلت العمليات وقت تحضير #{رقم} إلى {د} د» |
| 13 | Pickup request | Ring | All | «الكابتن {الاسم} يؤكد أنه دفع لك {المبلغ} واستلم الطلب #{رقم}» |
| 14 | Pickup confirmed (another device or automatic) | Silent | All | «تم استلام الطلب #{رقم}» |
| 15 | Pickup confirmed by operations | Chime | All | «أكّدت العمليات استلام الكابتن للطلب #{رقم}» |
| 16 | Order edited, items added | Ring until acknowledged | All | «تم تعديل الطلب #{رقم} — أُضيفت أصناف» |
| 17 | Order edited, other changes | Chime | All | «تم تعديل الطلب #{رقم}» |
| 18 | Cancelled after acceptance | Ring until acknowledged | All | «أوقف التحضير — أُلغي الطلب #{رقم}: {السبب}» |
| 19 | Failed, or an outcome that affects your money | Silent push | Owners | «لم يُسلَّم الطلب #{رقم}: {النتيجة}» with the money effect |
| 20 | Delivered | Silent | All | Moves to history |
| 21 | Admin price change | Chime | Owners | «عدّلت FOX DROP سعر {الصنف}: {القديم} ← {الجديد}» |
| 22 | Menu change request decided | Silent push | Owners | «قُبل تعديلك على {الصنف}» / «رُفض تعديلك على {الصنف}: {السبب}» |
| 23 | Paused, resumed or suspended by operations; busy mode ended by operations | Chime | All | «أوقفت العمليات مطعمك مؤقتاً: {السبب}» / «أعادت العمليات تشغيل مطعمك» / «أنهت العمليات وضع الضغط» |
| 24 | Pause ended automatically | Chime | All | «انتهى الإيقاف المؤقت — مطعمك يستقبل الطلبات» |
| 25 | Busy-mode reminder (hourly) | Chime | All | «وضع الضغط ما زال مفعّلاً (+{د} د)» |
| 26 | Limit reached or cleared | Silent | All | Banner (§7.4) |
| 27 | No receiving device for 5 min | Push | Owners | «لا يوجد جهاز يستقبل الطلبات في مطعمك الآن» |
| 28 | Connection lost for 30 s | Chime | That device only | Red bar (§4.7) |
| 29 | Ticket resolved | Silent push | Owners and the reporter | «تم حل بلاغك T-{رقم}: {الرد}» |
| 30 | Weekly statement | Silent push | Owners | «كشف الأسبوع جاهز: المستحق {المبلغ}…» |
| 31 | Settlement receipt | Silent push | Owners | «إيصال {رقم}: استلمنا منك {المبلغ}» |
| 32 | Settlement overdue | Silent push and banner | Owners | «لديك مبلغ متأخر: {المبلغ}…» |
| 33 | Commission change scheduled | Silent push | Owners | «تتغيّر عمولتك إلى {النسبة}% اعتباراً من {التاريخ}» |
| 34 | Emergency stop on or off | Chime | All | Banner (§8.17) |
| 35 | Terms version published | Blocking on next open | Owners | Accept screen (§4.10) |
| 36 | Forced update or maintenance | Blocking | All | Update or maintenance screen (§4.2, §4.10) |
| 37 | Item-unavailable report closed by operations without an edit | Chime | All | «أغلقت العمليات بلاغ الصنف في الطلب #{رقم}: {السبب}» |
| 38 | Pickup request rejected as incomplete (another device) | Silent | All | The prompt closes |

Notification texts come from Content templates (AP §9.13), so admins can edit them. The texts above are the defaults.

---

## 17. Owner web portal «بوابة المطعم» (R15)

- **Access:** owners only. Sign-in by phone and OTP, as in the app (§5.2). Sessions last 30 days (§5.3).
- **Layout:** Arabic, right to left. Built for desktop and laptop, and usable on a phone.
- **What it has:** everything an owner can do in the app (§5.4), plus:
  - Excel export for reports and history
  - PDF and Excel for statements
  - a custom date range in reports
- **Live orders, read-only:**
  - the same four columns, updated in real time, with timers and captain lines
  - no sound, and no accept, reject, ready, pickup or edit actions
  - a banner explains: «لاستقبال الطلبات استخدم تطبيق أندرويد أو ويندوز»
- **Status:** pause, resume, busy mode and holiday close work from the portal, because they are not receiving orders.
- **Not a receiving device:** the portal never counts as one (§4.6).

---

## 18. Server commands

Every command:

- carries an idempotency key (§4.7)
- is checked on the server for the user's role, the restaurant's status and the order's state
- returns the new state
- records the user, the device and the time

| Command | Roles | Allowed when | Effect |
|---|---|---|---|
| Accept with prep time | MO, MC (app) | Order `placed` | `accepted`; customer notified; search start computed (§8.5) |
| Reject with reason | MO, MC (app) | Order `placed` | `rejected`; items unavailable or restaurant paused, per reason (§8.6) |
| Mark ready | MO, MC (app) | Order `accepted` | `ready` (§8.8) |
| Report item unavailable | MO, MC (app) | `accepted` or `ready`, before pickup, no open report, no open pickup request | Items unavailable; alert to operations; pickup blocked (§8.12) |
| Withdraw item-unavailable report | MO, MC (app) | Report open, operations have not acted | Report closed; items available again |
| Acknowledge edit | MO, MC (app) | An unacknowledged edit | Ring stops; acknowledgement recorded (§8.13) |
| Acknowledge cancellation | MO, MC (app) | An unacknowledged cancellation | Ring stops (§8.14) |
| Confirm pickup | MO, MC (app) | An open pickup request | Atomic pickup (§8.10, AP §8.1) |
| Dispute pickup | MO, MC (app) | An open pickup request, or within 10 min after any pickup confirmation | Rejects the request and alerts operations; or, after pickup, opens an urgent ticket (§8.10) |
| Reject pickup as incomplete | MO, MC (app) | An open pickup request | Rejects the request without amounts or an alert (§8.10) |
| Call captain | MO, MC (app) | From assignment until the order ends | Reveals the number; recorded (§8.9) |
| Pause / resume | MO, MC (app); MO (portal) | Pause: open or busy, and no operations or auto pause. Resume: paused by the restaurant. | State change (§7) |
| Busy mode on / off | MO, MC (app); MO (portal) | Restaurant open | Flag change (§7.3) |
| Holiday close / end | MO (app, portal) | Not suspended | State change (§10) |
| Set hours, default prep time, limit | MO (app, portal) | Any time | Applies immediately (§10) |
| Set pickup currencies | MO (app, portal) | Any time | Applies to new pickup requests (§12.7) |
| Set availability | MO, MC (app); MO (portal) | Any time | Immediate (§9.3) |
| Set price / bulk price change | MO (app, portal) | Any time | Immediate; logged; may alert operations (§9.4) |
| Hide, show, reorder, category window | MO (app, portal) | Any time | Immediate (§9.2) |
| Request a menu change / withdraw it | MO (app, portal) | Any time / while pending | Creates or withdraws a request (§9.5) |
| Add or remove a cashier | MO (app, portal) | Any time | Account change; removal signs out devices (§14.1) |
| Rename or sign out a device | MO (app, portal) | Any time | Device change (§14.2) |
| Set ringing on this device | MO (app) | Own device | Device setting (§4.4) |
| Create a ticket | MO, MC (app); MO (portal) | Any time | Ticket in the panel (§15) |
| Report the device check | MO, MC (app) | After a check | Stored on the device record (§4.5) |

**Real-time events the app subscribes to** (restaurant channel): order created, order updated (status, captain track, edits, timers), pickup request opened or closed, restaurant state changed, menu changed (including admin changes and review decisions), account entry posted, statement or receipt issued, and platform broadcasts (emergency stop, maintenance, version).

---

## 19. Changes made to the admin panel spec

These were applied to `docs/v1/admin-panel.md` together with this document:

1. **D18** now points to R5 (§2), and the D18 row in AP §12 was removed.
2. **Pickup:**
   - AP §8.1 describes the confirmed pickup: restaurant confirmation, automatic confirmation, or operations on the restaurant's behalf. It also covers:
     - the implicit `ready` when ready was not pressed
     - the frozen commission base after pickup
     - what is blocked while a request is open
     - payment-line validation
     - the cash question when a request is followed by a cancellation or reassignment
   - AP §8.2 adds the captain-track state `pickup_pending` «بانتظار تأكيد المطعم».
   - AP §8.9 and AP §9.3.2 (cancel, reassign, confirm on behalf) and AP §9.3.3 (edits) follow these rules.
3. **Timers:** AP §8.3 adds pickup confirmation (60 s), the dispute window (10 min) and the no-device alert (5 min).
4. **Ledgers:** AP §8.5.1 adds `custody.pickup_correction`. AP §8.7 extends `merchant.credit` and `merchant.debit` to pickup corrections.
5. **Pickup currencies:** AP §8.6 adds payment at pickup in other currencies (R9).
6. **New alerts in AP §9.1.3:**
   - «صنف نفد بعد القبول» (critical)
   - «خلاف على مبلغ الاستلام» (critical)
   - «مطعم مفتوح بلا جهاز استقبال» (warning)
   - «تغيير أسعار كبير» (information)
7. **Dashboard and board:** menu change requests in pending tasks (AP §9.1.4); busy restaurants and restaurants without a receiving device in the status strip (AP §9.1.1); new board badges (AP §9.2.1).
8. **Order detail:** new timeline events (AP §9.3.1), and two new actions: «تأكيد الاستلام نيابة عن المطعم» and «إغلاق بلاغ صنف نفد» (AP §9.3.2). An edit voids an open pickup request (AP §9.3.3).
9. **Restaurant states:** AP §9.6.1 adds the operating state `busy` and the busy-mode flag.
10. **Restaurant wizard:** the role «موظف طلبات» is renamed «كاشير», further owners are added from the panel only, and the activation checklist requires a passed device check (AP §9.6.3).
11. **Restaurant profile and actions:** AP §9.6.4 shows devices, the limit and pickup currencies. AP §9.6.5 adds ending busy mode and editing the limit and pickup currencies, and states who can end which pause.
12. **Menu changes from restaurants:** AP §9.6.6 notes restaurant edits. The new AP §9.6.7 holds the review queue.
13. **Tickets:** AP §9.9.1 adds the automatic pickup-dispute ticket. AP §9.9.2 makes it always urgent. AP §9.9.3 adds its per-currency resolution. The urgent-ticket alert also reaches FIN for these tickets (AP §9.1.3).
14. **Permissions, reasons and pauses:** AP §6.2 and AP §6.3 add the new permissions, including FIN resolving pickup disputes. AP §4.5 adds the new reasons. AP §9.6.5 states that only one pause exists at a time and how each pause ends. AP §9.13 lists the new reason lists.
15. **Notifications:** AP §10 adds commission changes, pickup confirmations by operations, menu review results and busy-mode changes.
16. **Appendices:** new settings in AP Appendix A; the restaurant rejection list loses «سبب آخر» and a restaurant problem list is added (AP Appendix B); operating-state labels are added (AP Appendix C).
17. **Platforms and done:** AP §1.1 and the header now say the restaurant app is Android and Windows with an owner portal. AP §14 adds a restaurant-integration item.

---

## 20. Not in the restaurant app V1

| Feature | Version |
|---|---|
| Printing orders on a printer (R18) | V2 |
| In-app chat with operations or captains | V2 |
| Replies to ratings (R16) | V2 |
| Scheduled orders and pickup from the restaurant by the customer | V2 |
| Several branches under one account | V2 |
| More roles than owner and cashier (for example a kitchen screen) | V2 |
| Opening outside the schedule with one tap | V2 |
| English UI and dark theme | V2 |
| Excel menu import by the restaurant (admins have it in V1) | V2 |
| Campaigns created by the restaurant, with return on investment | V4 |
| Customer insights | V4 |
| Electronic payments and paying the settlement in the app | V5 |
| Suggested prep time by order size | V6 |

---

## 21. Open items (these do not block the build)

1. **A restaurant that does not pay on Saturday.** Same as AP §13 item 2: should the restaurant be paused automatically after some days or above some amount? Until decided, there is only the reminder and the alert (§12.6).
2. **Distribution and push in Azaz.** The Google Play and Firebase accounts are available (technology-stack T3, 2026-11-04). Still test on real devices and networks before launch that push messages arrive; where they do not, the foreground connection (§4.3) is the main route, and the signed APK serves phones without Google Play.
3. **Lending devices.** Will FOX DROP lend a tablet to restaurants without a suitable device, and on what terms (deposit, return, damage)?
4. **Full-screen alerts on Android 14+.** Google Play limits full-screen notifications to some app types. Verify the policy at submission. The fallback is a heads-up notification with the looping sound, which the device check prepares (§4.5).
5. **Printer survey for V2.** Which printers restaurants in Azaz use (Bluetooth or USB thermal, paper width), so V2 printing fits them.

---

## 22. Definition of done (restaurant app V1)

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

---

## Appendix A. Settings

New settings introduced by this spec. They are also listed in AP Appendix A. Scope: **G** global, **C** per city.

| Key | Default | Scope | Edit | Description |
|---|---|---|---|---|
| `merchant.prep_time_options` | 10, 15, 20, 30, 45 | C | OWN | Prep-time chips on the accept prompt (minutes) |
| `merchant.prep_time_step_min` | 5 | C | OWN | Step of the «−» and «+» buttons |
| `merchant.prep_time_floor_min` | 5 | C | OWN | Shortest prep time allowed |
| `merchant.prep_time_ceiling_min` | 90 | C | OWN | Longest prep time allowed |
| `merchant.busy_extra_options_min` | 10, 20 | C | OWN | Minutes busy mode can add |
| `merchant.busy_mode_reminder_min` | 60 | C | OWN | Reminder interval while busy mode is on |
| `merchant.no_device_alert_min` | 5 | C | OWN | Minutes an open restaurant may have no receiving device before the alert |
| `merchant.price_change_alert_pct` | 30 | C | OWN | Price change that raises the «تغيير أسعار كبير» alert |
| `merchant.web_session_days` | 30 | G | OWN | Portal session length |
| `order.pickup_confirm_timeout_sec` | 60 | C | OWN | Seconds before a pickup request is confirmed automatically |
| `order.pickup_dispute_window_min` | 10 | C | OWN | Minutes after pickup during which the restaurant can dispute the amount |

**Existing settings this app uses** (AP Appendix A):

- `order.merchant_accept_alert_min` (3)
- `order.merchant_auto_cancel_min` (7)
- `order.prep_late_ops_alert_min` (10)
- `merchant.auto_pause_unanswered_count` (3)
- `merchant.settlement_weekday` (Saturday)
- `merchant.settlement_overdue_days` (2)
- `merchant.default_prep_min` (20, the prefill for a new restaurant's default prep time)
- `captain.waiting_threshold_min` (10)
- `finance.business_day_cutoff` (06:00)
- `otp.*`
- `app.merchant.*`

**Per-restaurant fields** (not settings): default prep time, maximum active orders (off by default), pickup currencies (base only by default), opening hours.

**Fixed values in this spec:**

| Value | Fixed at |
|---|---|
| Heartbeat interval | 20 s |
| Device marked disconnected after | 60 s without a heartbeat |
| Offline chime | After 30 s offline |
| Prep-late chime repeat | Every 5 min |
| Restaurant pause choices | 15, 30, 60 min, or until reopening |
| Maximum active orders range | 1–50 |
| Shortest opening period | 30 min |
| Holiday message length | 100 characters |
| Cashier history | Today plus the previous 7 business days |
| Restaurants per phone number | 1 |
| Base currency at pickup | Always accepted |
| Cashier devices | Always ring |
| «الطلب جاهز» | No undo |

---

## Appendix B. Main Arabic UI strings

| Key | Arabic |
|---|---|
| Columns | «جديدة» · «قيد التحضير» · «جاهزة» · «مع الكابتن» |
| History statuses | «تم التسليم» · «فشل التسليم» · «مرفوض» · «ملغى» |
| Roles | «مالك» · «كاشير» |
| Restaurant states | «مفتوح» · «وضع الضغط +{د} د» · «مشغول» · «موقوف مؤقتاً» · «أوقفته العمليات» · «أُوقف تلقائياً» · «مغلق» · «إجازة حتى {التاريخ}» · «معلّق» |
| Main buttons | «قبول — {د} د» · «رفض» · «الطلب جاهز» · «تأكيد الاستلام» · «المبلغ غير صحيح» · «صنف غير متوفر — اتصلوا بالزبون» · «اطلعت على التعديل» · «حسناً» · «اتصال بالكابتن» · «مشكلة في الطلب» |
| Status sheet | «إيقاف 15 د» · «30 د» · «60 د» · «حتى أعيد الفتح» · «وضع الضغط +10 د» · «+20 د» · «إلغاء وضع الضغط» · «استئناف الاستقبال» |
| Availability | «متوفر» · «غير متوفر» · «حتى الغد» · «حتى أعيده» |
| Rejection reasons | «صنف غير متوفر» · «المطعم مغلق» · «ضغط طلبات» |
| New order | «طلب جديد #{رقم}» · «يُلغى تلقائياً خلال {د:ث}» · «تأخرتم في الرد — سيتصل بكم فريق العمليات» |
| Pickup prompt | «الكابتن {الاسم} يؤكد أنه دفع لك {المبلغ} واستلم الطلب #{رقم}» · «الطلب غير مكتمل» · «يُؤكَّد تلقائياً خلال {ث} ث» · «تم الاستلام» · «تأكيد تلقائي» |
| Money lines | «قيمة الأصناف — يدفعها لك الكابتن نقداً عند الاستلام» · «العمولة {النسبة}% — تُسدَّد يوم السبت» · «خصم يموّله المطعم» · «صافيك من الطلب» · «طلب تجريبي — لا عمولة» |
| Account | «المستحق عليك حتى الآن» · «موعد التسوية: السبت {التاريخ}» · «قبضت اليوم من الكباتن» · «الكشوف» · «الإيصالات» · «لدي استفسار» · «غير مسدّد» · «مسدّد جزئياً» · «مسدّد» |
| Banners | «لا يوجد اتصال بالإنترنت — لن تصلك الطلبات الجديدة حتى يعود الاتصال» · «هذا الجهاز قد لا يرن عند وصول طلب — أكمل فحص الجهاز» · «وضع تجريبي — مطعمك ظاهر لحسابات الاختبار فقط» · «المنصة متوقفة مؤقتاً عن استقبال طلبات جديدة. أكملوا الطلبات الحالية.» · «وصلت إلى الحد الأقصى ({العدد} طلبات جارية). لن تصلك طلبات جديدة حتى يُستلم أحدها.» · «لديك مبلغ متأخر: {المبلغ}. يرجى التسوية في أقرب وقت.» |
| Badges | «طلب تجريبي» · «قبلته العمليات» · «معدّل» · «صنف نفد — بانتظار العمليات» · «متأخر» · «بانتظار المراجعة» · «أضافته العمليات» · «حذفته العمليات» |
| Device | «الرنين على هذا الجهاز» · «إبقاء الشاشة مضاءة» · «تجربة الصوت» · «فحص الجهاز» · «سمعت الصوت» |
| Windows quit | «إغلاق التطبيق يوقف استقبال الطلبات على هذا الجهاز. هل أنت متأكد؟» |
| Portal | «لاستقبال الطلبات استخدم تطبيق أندرويد أو ويندوز» |

The texts in §16 are the defaults of the notification templates.

---

## Appendix C. Reason lists used by the app

These defaults are editable in Content (AP §9.13, AP Appendix B).

| List | Values |
|---|---|
| Restaurant rejection (R3) | «صنف غير متوفر» (pick the items) · «المطعم مغلق» (pauses the restaurant) · «ضغط طلبات» |
| Item unavailable after acceptance, optional note | «يوجد بديل مشابه» · «الكمية غير كافية» |
| Restaurant problem on an order (§8.19) | «الكابتن تأخر» · «سلوك الكابتن» · «مشكلة في مبلغ الاستلام» · «مشكلة في الطلب» · «أخرى» |
| Restaurant ticket types (§15) | «مشكلة في طلب» · «استفسار مالي» · «طلب تعديل بيانات» · «مشكلة في التطبيق» · «أخرى» |
