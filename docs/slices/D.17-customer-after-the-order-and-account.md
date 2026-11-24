# D.17 Customer screens 7: after the order and my account

Status: Planned · Tier: T2 · Branch: `feat/customer-screens-account`
Spec: architecture §9.5 (R1 to R20), §9.9; CU §5.4 to §5.6, §9.6, §12.1 to §12.4, §13, §14 · Definition of done: the D.17 line of `docs/roadmap.md`; keeps CU §19 items 22 to 26 passing

## Goal

The last customer batch: «طلباتي» and the order detail, rating, reporting a problem, «اطلب مرة أخرى», «أكوادي», and «حسابي» with every page of §13, styled. With it the whole customer app is on `core_ui`: `apps/customer` joins the lint whole (R2, R13, R20) and no Material import is left.

## Screen inventory (§9.9 step 1)

Sizes, R6 states and the cycle as in D.11. This batch has more screens than the others (owner, 2026-11-24: seven batches as in §9.9); if the checkpoint shows it cannot finish in one session, it splits at the drawing into «after the order» and «my account», asked of the owner first.

| Screen                                            | Cites                | Purpose and main action      | States beyond R6                                                                                                                                                                                                                                                                         | Data and actions                                                                 |
| ------------------------------------------------- | -------------------- | ---------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------- |
| «طلباتي» (`my_orders_screen.dart`)                | CU §12.3             | Open an order                | Active first, then past, newest first, in pages; a guest signs in; empty                                                                                                                                                                                                                 | `GET /v1/customer/orders`                                                        |
| Order detail                                      | CU §12.3, §11.8, Q23 | «اطلب مرة أخرى»              | Lines with options, notes and the edit marks; the money lines (rounding when not 0); the pay-in currency and «استلم الكابتن» and «أعاد لك»; the address; the captain's name; the timeline; the re-delivery link; rate and report while their windows last; «تواصل مع الدعم» outside them | `GET /v1/customer/orders/{id}`                                                   |
| «اطلب مرة أخرى»                                   | CU §12.3, §11.9      | Rebuild the cart             | Replacing a non-empty cart (confirm); skipped lines («لم نضف: {الأصناف} لأنها غير متوفرة»); the restaurant closed now; not on a free re-delivery                                                                                                                                         | `GET /v1/customer/restaurants/{id}`                                              |
| Rating (sheet, `rate_order_sheet.dart`)           | CU §12.1, Q16        | Send a part                  | «قيّم المطعم» and «قيّم الكابتن» apart; stars required; reason chips per stars; comment 300; one part sent, the other skipped; sent parts not editable; the window over                                                                                                                  | `POST /v1/customer/orders/{id}/rating`, `GET /v1/customer/content`               |
| «الإبلاغ عن مشكلة» (`report_problem_screen.dart`) | CU §12.2, Q17        | «إرسال»                      | Each type; items required for three types; note required for «أخرى»; up to 3 photos with their upload progress and failure; sent («استلمنا بلاغك T-{رقم}…»); already reported («بلاغك T-{رقم}: {الحالة}»); the resolution                                                                | `POST /v1/customer/orders/{id}/report`, `POST /v1/customer/uploads/report-photo` |
| «أكوادي» (`my_codes_screen.dart`)                 | CU §12.4, §8.1       | «استخدم»                     | «متاحة» and «منتهية»; personal codes; value, conditions, expiry, uses left; opened on one code from a banner or a push; empty                                                                                                                                                            | `GET /v1/customer/promo-codes`                                                   |
| «حسابي» (`my_account_screen.dart`)                | CU §13               | Open a page                  | Every row of §13; «تسجيل الخروج» and «تسجيل الخروج من كل الأجهزة» with their confirmations; «عن التطبيق» with the version; «انضم إلينا»                                                                                                                                                  | `POST /v1/customer/auth/sign-out[-everywhere]`                                   |
| «بياناتي» (D.11's form, editing)                  | CU §5.3, §13         | «حفظ»                        | The phone read-only with «لتغيير رقمك تواصل مع الدعم»                                                                                                                                                                                                                                    | `GET`/`PUT /v1/customer/profile`                                                 |
| «المفضلة» (`favourites_screen.dart`)              | CU §9.6              | Open a restaurant            | Only those delivering to the point, with their state; empty                                                                                                                                                                                                                              | `GET /v1/customer/favourites`                                                    |
| «الإشعارات» (`notifications_screen.dart`)         | CU §13, §14          | Open a notification's target | The last 30 days, newest first; empty                                                                                                                                                                                                                                                    | `GET /v1/customer/notifications`                                                 |
| «المساعدة» and the FAQ (`content.dart`)           | CU §13               | Call or WhatsApp support     | The customer FAQ set                                                                                                                                                                                                                                                                     | `GET /v1/customer/content`, `/contact`                                           |
| «حذف الحساب» (`delete_account_screen.dart`)       | CU §5.6              | Confirm with a fresh code    | The explanation; the code; refused with an active order («لا يمكن حذف الحساب أثناء وجود طلب جارٍ»); closed and signed out                                                                                                                                                                | `POST /v1/customer/account/close-code`, `/account/close`                         |

## Plan

0. Inventory check against `apps/customer/lib/src/orders/` (my orders, detail, rating, report, order again), `codes/`, `account/`, `notifications/`, `content.dart`.
1. Draw, prototype, analysis, missing components (expected: the star input, the reason chips, the photo fields, the code card, the timeline), designer pass, approval: §9.9 steps 2 to 7, as D.11 set up.
2. Code on `core_ui`; then `apps/customer` replaces its folder paths in `enforcedPackages` and the app has no Material import left; goldens and the comparison with the drawing; R12 run on «طلباتي» with many pages.
3. Store review (R18): account deletion inside the app (the App Store's rule), the photo permission for reports, the privacy policy link; and the whole app's list across D.11 to D.17 for the store submission (L-phase).

Tests written first (locked in the red phase):

- R11 for every screen and sheet above.
- R14: rating, report, «اطلب مرة أخرى», sign-out everywhere and closing the account cannot send twice; a lost answer resends the same key.
- R15: push rows 16, 21 and 23 open «أكوادي» or the account and row 22 its target; a guest's «طلباتي» goes through sign-in; Android back through «حسابي».
- The lint over `apps/customer` whole passes.

## Stopped at

Planned (2026-11-24); after D.16.

## Evidence

- `node scripts/verify.mjs --changed`: —
- Drawings, prototype and analysis: the screens canvas
- R12 profile run: —
- Review: —

## Before deploying

A new customer build.

## To check on staging

The owner rates a delivered order, reports a problem with a photo, reorders an earlier order, opens a code from «أكوادي», signs out of every device, and tries to delete the account with an active order.

## Notes for the next session

—
