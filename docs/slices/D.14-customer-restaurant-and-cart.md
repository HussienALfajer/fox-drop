# D.14 Customer screens 4: the restaurant page and the cart

Status: Planned · Tier: T2 · Branch: `feat/customer-screens-restaurant-cart`
Spec: architecture §9.5 (R1 to R20), §9.9; CU §9.1 to §9.6, §10.1, §10.2; RA §10 (opening hours) · Definition of done: the D.14 line of `docs/roadmap.md`; keeps CU §19 items 9 to 12 and 24 passing

## Goal

The restaurant page with its states and menu, the item sheet with its option rules, price parity and «أبلغ عن سعر مختلف», and the cart with the minimum order and free-delivery progress, styled.

## Screen inventory (§9.9 step 1)

Sizes, R6 states and the cycle as in D.11.

| Screen                                           | Cites                         | Purpose and main action   | States beyond R6                                                                                                                                                                                                                                                                                                                                                                                                                                                 | Data and actions                                                                            |
| ------------------------------------------------ | ----------------------------- | ------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| Restaurant page (`restaurant_screen.dart`)       | CU §9.1 to §9.3               | Add an item               | Every state of §9.2 (open, busy mode with its note, busy, paused with or without an end and with the operations message, closed by schedule, holiday close) with the add buttons disabled and the message; hidden items absent; unavailable items («يتوفر غداً», «غير متوفر حالياً»); a category out of its window («متوفر من {الساعة}»); «من {أقل سعر}»; the category bar following the scroll; «ابحث في القائمة» with no match; the free-delivery line; «جديد» | `GET /v1/customer/restaurants/{id}`                                                         |
| Opening hours (sheet)                            | CU §9.1, RA §10               | Read the week             | Today marked; a closed day; a holiday                                                                                                                                                                                                                                                                                                                                                                                                                            | Same                                                                                        |
| Price parity (sheet)                             | CU §9.5                       | Read; «أبلغ عن سعر مختلف» | A guest (signs in first)                                                                                                                                                                                                                                                                                                                                                                                                                                         | —                                                                                           |
| Item sheet (`item_sheet.dart`)                   | CU §9.4, D.10's S-curve sheet | «أضف — {المبلغ}»          | Each rule («إجباري», «اختر {العدد}», «اختر حتى {العدد}», «اختر من {أ} إلى {ب}»); an unavailable option; a required group incomplete (scrolls to it, «اختر {العدد} على الأقل»); quantity 1 to 20; the note with its 100 characters and a phone number refused; editing a cart line; no photo                                                                                                                                                                      | The page's menu                                                                             |
| Replace cart (dialog)                            | CU §10.1                      | «سلة جديدة» or «إلغاء»    | —                                                                                                                                                                                                                                                                                                                                                                                                                                                                | The local cart                                                                              |
| «أبلغ عن سعر مختلف» (`price_report_screen.dart`) | CU §9.5                       | «إرسال»                   | Item picked from the menu or not; price in the base currency; photo (camera or gallery); sent («شكراً، سنتحقق من السعر»); already sent today («أرسلت بلاغاً عن هذا المطعم اليوم»)                                                                                                                                                                                                                                                                                | `POST /v1/customer/restaurants/{id}/price-report`, `POST /v1/customer/uploads/report-photo` |
| Cart (`cart_screen.dart`)                        | CU §10.1, §10.2               | «متابعة»                  | Lines with «−», «+», «تعديل» and removal; empty; expired («انتهت صلاحية سلتك»); below the minimum (progress, «متابعة» disabled); free-delivery progress and «توصيلك مجاني»; changes since adding (unavailable with remove, new price, removed option); the restaurant no longer open                                                                                                                                                                             | `POST /v1/customer/quote`                                                                   |

## Plan

0. Inventory check against `apps/customer/lib/src/browsing/restaurant_screen.dart`, `price_report*`, `cart/`.
1. Draw, prototype, analysis, missing components (expected: the sticky category bar, the option group, the progress bar, the parity badge), designer pass, approval: §9.9 steps 2 to 7, as D.11 set up.
2. Code on `core_ui`; the folders join the lint; goldens and the comparison with the drawing; R12 run on the long menu.
3. Store review (R18): the camera and photo permission texts, asked only when a photo is added (CU §4.4); record it.

Tests written first (locked in the red phase):

- R11 for every screen and sheet above, each §9.2 state among the goldens.
- R14: «إرسال» of the price report cannot send twice; a lost answer resends the same key.
- R15: the item sheet and the sheets close on Android back; «متابعة» goes to checkout; a guest's price report goes through sign-in and back.
- The item sheet scrolls to the incomplete group.

## Stopped at

Planned (2026-11-24); after D.13.

## Evidence

- `node scripts/verify.mjs --changed`: —
- Drawings, prototype and analysis: the screens canvas
- R12 profile run: —
- Review: —

## Before deploying

A new customer build.

## To check on staging

The owner pauses a restaurant in its app and sees the page disable ordering, builds a cart below the minimum, adds an item with required options, sends a price report with a photo.

## Notes for the next session

—
