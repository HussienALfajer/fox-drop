# D.15 Customer screens 5: checkout

Status: Planned · Tier: T2 · Branch: `feat/customer-screens-checkout`
Spec: architecture §9.5 (R1 to R20), §9.9; CU §4.4 (notifications, Q11), §5.1 (a guest at «تأكيد الطلب»), §7.4, §7.5, §10.3 to §10.7, Appendix C (the problems' texts) · Definition of done: the D.15 line of `docs/roadmap.md`; keeps CU §19 items 1, 6 and 12 to 15 passing

## Goal

Checkout from top to bottom, styled: the address (with D.12's picker and form), notes, «سأدفع بـ», the code and «الأكواد المتاحة لك», the money lines and equivalents, the problems that block ordering, the far-pin check, the first-order notification ask and placing the order. `checkout_screen.dart` (749 lines) is split into its sections so each file stays under R20.

## Screen inventory (§9.9 step 1)

Sizes, R6 states and the cycle as in D.11. Checkout needs a connection: offline shows the banner and disables «تأكيد الطلب».

| Screen                                          | Cites           | Purpose and main action     | States beyond R6                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | Data and actions                                              |
| ----------------------------------------------- | --------------- | --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------- |
| Checkout (`checkout_screen.dart`)               | CU §10.3, §10.6 | «تأكيد الطلب — {المجموع}»   | The address preselected (saved, within 200 m, or unsaved to complete), «تغيير», «إضافة عنوان», «التوصيل إلى موقعي الحالي»; the recipient line; the preset note chips and the free note (a phone number refused); a guest («سجّل الدخول لاستخدام الأكواد»); every blocking problem of §10.6 at the top with its action (each Appendix C text); rounding shown only when not 0; the equivalents line; the estimate; the order button disabled outside platform hours, in an emergency stop or with terms waiting; the quote refreshing | `POST /v1/customer/quote`, `GET /v1/customer/content` (notes) |
| «سأدفع بـ» (section)                            | CU §10.5        | Pick a currency             | «لم أحدد» default; a currency chosen («ستدفع حوالي {المبلغ} {العملة}»); the last choice remembered                                                                                                                                                                                                                                                                                                                                                                                                                                   | The quote's equivalents                                       |
| Code (section) and «الأكواد المتاحة لك» (sheet) | CU §10.4        | «تطبيق»                     | Typed or picked; the suggestion «لديك كود يوفر عليك {المبلغ}: {الكود}» (never applied by itself); applied with «إزالة»; replacing after a confirmation; each refusal reason (Appendix C); the fixed-amount warning; a code that stopped working since the quote                                                                                                                                                                                                                                                                      | `GET /v1/customer/promo-codes`, `POST /v1/customer/quote`     |
| Far-pin check (dialog)                          | CU §7.5         | «نعم، أرسل إلى هذا العنوان» | «تغيير العنوان»; waiting up to 5 seconds for a position                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | The device's position only                                    |
| Notifications ask (first order)                 | CU §4.4, Q11    | Allow                       | Refused (the order still goes)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | The system prompt                                             |
| Placing                                         | CU §10.7        | —                           | «جارٍ إرسال طلبك…»; the total or a rate changed (the new quote, confirm again); a blocking problem appeared; the capacity check («الضغط عالٍ الآن، جرّب بعد دقائق»); a guest signs in and returns with the refreshed quote; placed («أرسلنا طلبك إلى {المطعم}»)                                                                                                                                                                                                                                                                      | `POST /v1/customer/orders`                                    |

## Plan

0. Inventory check against `apps/customer/lib/src/checkout/` and the place-order flow.
1. Draw, prototype, analysis, missing components (expected: the choice chips for notes and currencies, the problem card with its action, the code row), designer pass, approval: §9.9 steps 2 to 7, as D.11 set up. The analysis covers every field of the quote and every problem code; a problem the server sends without an action the screen can take is an API gap.
2. Code on `core_ui`; split `checkout_screen.dart` by section; the folder joins the lint; goldens and the comparison with the drawing; R12 run.
3. Store review (R18): notifications asked at the first order, never at launch (Q11), with Android 13's runtime permission; record it.

Tests written first (locked in the red phase):

- R11 for every section and dialog, each blocking problem among the goldens.
- R14: «تأكيد الطلب» cannot send twice; a lost answer resends the same `Idempotency-Key`; leaving the screen does not cancel the command.
- R15: a guest at «تأكيد الطلب» goes through sign-in and back to checkout with the refreshed quote; the placed order opens its screen; Android back while sending.
- The far-pin dialog fires above 1 km and is skipped without a position.

## Stopped at

Planned (2026-11-24); after D.14.

## Evidence

- `node scripts/verify.mjs --changed`: —
- Drawings, prototype and analysis: the screens canvas
- R12 profile run: —
- Review: —

## Before deploying

A new customer build.

## To check on staging

The owner checks out as a guest, signs in at «تأكيد الطلب», applies a suggested code, picks «سأدفع بـ» in dollars, places the order; turns the emergency stop on and sees the button disabled.

## Notes for the next session

—
