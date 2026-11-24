# D.16 Customer screens 6: the active order

Status: Planned · Tier: T2 · Branch: `feat/customer-screens-active-order`
Spec: architecture §9.5 (R1 to R20; R16), §9.9, §6 (real time), §7.3 (the map); CU §4.3, §8.4, §11.1 to §11.10, §14 (rows 1 to 15 open the order) · Definition of done: the D.16 line of `docs/roadmap.md`; keeps CU §19 items 16 to 21 and 27 passing

## Goal

The order screen through every row of §11.2, live, with the captain card, the map from pickup, the banners of §11.6, the amount due at the door, the door ring, the help and cancel sheets, and the orders that do not complete (§11.9). `order_screen.dart` (513 lines) is split so each file stays under R20.

## Screen inventory (§9.9 step 1)

Sizes, R6 states and the cycle as in D.11. Offline here means the live feed lost: polling every 30 seconds with the offline banner (CU §4.3).

| Screen                                    | Cites                 | Purpose and main action      | States beyond R6                                                                                                                                                                                                                                                                                                                                                                      | Data and actions                                                                                          |
| ----------------------------------------- | --------------------- | ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| Order screen (`order_screen.dart`)        | CU §11.1, §11.2, §8.4 | Follow the order; «مساعدة»   | Every row of §11.2 (placed, accepted, captain assigned, at the restaurant, ready, pickup pending, picked up, arrived, delivered) with its title, subtitle and the five-step bar; the range then «يصل حوالي {الساعة}»; reassignment and handover; a free re-delivery («إعادة توصيل مجانية لطلب #{رقم}», total 0); the summary with the pay-in currency; behind a blocking screen (R16) | `GET /v1/customer/orders/{id}`, the live feed (`POST /v1/customer/realtime/token`), `serverClockProvider` |
| Captain card                              | CU §11.3, Q14         | «اتصال بالكابتن» from pickup | First name, photo or its fallback, vehicle type; the call recorded; hidden when the order ends                                                                                                                                                                                                                                                                                        | `POST /v1/customer/orders/{id}/captain-call`                                                              |
| Map (from pickup)                         | CU §11.3, U12         | Watch the captain            | Live position every 10 seconds; the delivery pin; the route line, or none without the routing service; position stale                                                                                                                                                                                                                                                                 | `GET /v1/customer/orders/{id}/route`, the live feed                                                       |
| Banners of the order                      | CU §11.6, §4.4        | Read                         | Item unavailable; edited by operations (the summary's «أُضيف», «حُذف», quantities, the new total); time changed; the late apology; the emergency delay notice; notifications off with a link to settings; the amount to collect now («المبلغ المطلوب الآن: {المبلغ}», «لن تدفع شيئاً لهذا الطلب»)                                                                                     | The order                                                                                                 |
| At the door                               | CU §11.7              | Pay                          | The amount due large with its equivalents; an order for someone else                                                                                                                                                                                                                                                                                                                  | The order                                                                                                 |
| Door ring (full screen, `door_ring.dart`) | CU §11.7              | «أنا قادم»                   | Ringing 30 seconds; «سأتصل بالمستلم» for a recipient; «اتصال بالكابتن»; answered                                                                                                                                                                                                                                                                                                      | `POST /v1/customer/orders/{id}/answer-ping`                                                               |
| Help (sheet, `order_help_sheet.dart`)     | CU §11.5, §11.10      | Call or WhatsApp support     | «الأسئلة الشائعة»; «تريد تغيير العنوان؟» with U13; «إلغاء الطلب» while placed, or «لإلغاء الطلب تواصل مع الدعم» with the warning after                                                                                                                                                                                                                                                | `GET /v1/customer/contact`                                                                                |
| Cancel (sheet, `cancel_order_sheet.dart`) | CU §11.4              | «نعم، ألغِ الطلب»            | A reason from the self-cancel list, «سبب آخر» with its text; the race with acceptance («قبل المطعم طلبك قبل لحظات. لإلغائه تواصل مع الدعم.»)                                                                                                                                                                                                                                          | `POST /v1/customer/orders/{id}/cancel`, `GET /v1/customer/content`                                        |
| Ended orders                              | CU §11.8, §11.9       | Rate, or order elsewhere     | Delivered (opens the rating sheet of D.17 once); rejected with the reason and up to 5 similar restaurants and «اطلب بدون الأصناف غير المتوفرة»; no response; cancelled by operations with its compensation code; cancelled by the customer; failed; delivered free or reduced; the dues banner after `fake`                                                                           | The order, `GET /v1/customer/restaurants` (similar)                                                       |

## Plan

0. Inventory check against `apps/customer/lib/src/orders/` (the live screen, its banners, door ring, help and cancel).
1. Draw, prototype, analysis, missing components (expected: the five-step progress bar, the captain card, the map frame with its pins, the full-screen ring, the amount-due block), designer pass, approval: §9.9 steps 2 to 7, as D.11 set up. The prototype plays the order through every row of §11.2 from a state switcher.
2. Code on `core_ui` and `core_maps`; split `order_screen.dart`; the folder joins the lint; goldens and the comparison with the drawing; R12 run with the map open.
3. Store review (R18): Android's full-screen intent for the door ring (Android 14's `USE_FULL_SCREEN_INTENT` policy), iOS time-sensitive notifications, the dialer for the call; record each with what the store asks.

Tests written first (locked in the red phase):

- R11 for every state above, each §11.2 row and each §11.9 case among the goldens.
- R14: «أنا قادم», «نعم، ألغِ الطلب» and «اتصال بالكابتن» cannot send twice; a lost answer resends the same key.
- R15: each push row 1 to 15 opens this screen; Android back from the ring, help and cancel.
- R16: the forced-update and maintenance screens leave this screen readable.
- Every countdown on `serverClockProvider` with a wrong device clock.

## Stopped at

Planned (2026-11-24); after D.15.

## Evidence

- `node scripts/verify.mjs --changed`: —
- Drawings, prototype and analysis: the screens canvas
- R12 profile run: —
- Review: —

## Before deploying

A new customer build; the full-screen intent declaration in the Play Console if the store asks for it.

## To check on staging

The owner runs a whole order from two phones (`docs/runbooks/staging-cycle.md`): each status arrives live, the map follows the captain from pickup, the door ring sounds, «أنا قادم» reaches the captain; a second order is rejected and shows similar restaurants.

## Notes for the next session

—
