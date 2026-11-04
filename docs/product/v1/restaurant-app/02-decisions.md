# 2. Decisions

> Part of the [restaurant app spec](README.md) (RA). A bare "§n" here means RA §n.

## 2.1 Owner decisions (2026-11-02)

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

## 2.2 Rules set by this spec

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

## 2.3 Admin-panel decisions that shape this app

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
