# D.11 Customer screens 1: the frame, sign-in and account details

Status: In progress (design checkpoint) · Tier: T2 · Branch: `feat/customer-screens-sign-in`
Spec: architecture §9.5 (R1 to R20), §9.9 (the screen cycle), T13; CU §4.2, §4.7 (blocking screens, terms, platform hours, emergency stop), §5.1 to §5.5, §6.1 (bottom bar), §6.2 (banners), §13 («الشروط والخصوصية»); RA §5 and CA §5 for the shared sign-in screen · Definition of done: the D.11 line of `docs/roadmap.md`; keeps CU §19 items 1 to 3, 26 and 27 passing

## Goal

The customer app's first styled batch: the frame every later screen sits in (the bottom navigation, the banner stack, the blocking screens) and the way in (phone number, code, «أكمل بياناتك», the terms). The sign-in screen is shared by the three apps (`core_auth`), so it is drawn and built for the customer, the captain and the restaurant at once (owner, 2026-11-24). It also lays the foundations of every later customer batch: the shared fixtures (R19), the screen-test harness (R11), the file-length rule (R20) and the lint that follows the batches into the app (R2).

## Before the design checkpoint

- **No designer pass in this batch (owner, 2026-11-24).** The designer works in Figma, and the Figma slices are planned and built after D.11 (`docs/roadmap.md`, Phase D). Step 6 is skipped here: the owner approves the prototype directly, and these screens go to the designer once the Figma slices land; a change the designer makes then comes back through a screen change (§9.9, later changes).
- **R12 uses an emulator** limited to 2 GB of memory (owner, 2026-11-24), not a real phone; L.9 still runs the real-device lab.

## Screen inventory (§9.9 step 1)

Sizes for every screen: an Arabic phone at 360 × 640 and 412 × 915, and both at 130% text. The shared sign-in screen also at the restaurant tablet (RA §6.2, 840 dp and wider, Windows). Every screen has the five states of R6 (loading as a skeleton, empty, error, offline, partial) where they apply; the table names the others.

| Screen                                                   | Cites                     | Purpose and main action                                  | States beyond R6                                                                                                                                                              | Data and actions                                                           |
| -------------------------------------------------------- | ------------------------- | -------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------- |
| Starting (`starting_screen.dart`)                        | CU §4.2                   | While the session and the version check load             | First open; slow network                                                                                                                                                      | `GET /v1/customer/auth/session`, `GET /v1/customer/platform`               |
| The frame (bottom navigation, go_router shell)           | CU §6.1                   | Four tabs: «الرئيسية», «البحث», «طلباتي», «حسابي»        | A guest opening «طلباتي» or «حسابي» (sign-in first); the tab kept on back; the slots for the floating cart button and the active-order bar (built in D.13)                    | Routes only (R15)                                                          |
| Banner stack                                             | CU §6.2, §4.2, §4.7, §5.5 | The seven banners in §6.2's order, using D.10's stack    | Update available (dismissible), emergency stop, each account state of §5.5, outside platform hours, terms waiting, outside the zones, no internet                             | `GET /v1/customer/platform`, `/emergency-stop`, `/account-state`, `/terms` |
| Dues office sheet                                        | CU §5.5                   | Where and when to pay dues                               | Office hours closed now; map not loaded                                                                                                                                       | `GET /v1/customer/contact`, `/account-state`                               |
| Blocking update or maintenance (`core_platform`, shared) | CU §4.2, §4.7, R16        | «تحديث» to the store, or the maintenance message         | Forced update; maintenance; with an active order (the order stays reachable, R16); the restaurant and captain forms                                                           | `GET /v1/<app>/platform`                                                   |
| Phone number (`core_auth`, shared)                       | CU §5.2, RA §5, CA §5     | «متابعة» sends the code                                  | Country «سوريا +963» or «تركيا +90»; invalid number; no WhatsApp; daily limit; «لديّ رمز من العمليات» (captain and restaurant only); the captain's join path                  | `POST /v1/<app>/auth/code`                                                 |
| Code (`core_auth`, shared)                               | CU §5.2                   | Six digits, signed in                                    | «أرسلنا الرمز إلى واتساب على الرقم {الرقم}»; resend countdown, then «إعادة الإرسال»; wrong code; attempts used; expired; paste and the Android clipboard offer; «تعديل الرقم» | `POST /v1/<app>/auth/sign-in`, `/auth/code`                                |
| «أكمل بياناتك» (`profile_screen.dart`)                   | CU §5.3                   | «حفظ» with the required fields                           | Each field's error; terms not ticked; returning to `from` after saving                                                                                                        | `GET`/`PUT /v1/customer/profile`, `GET /v1/customer/terms`                 |
| Terms (`terms.dart`)                                     | CU §4.7, §13              | Read the current terms; «أوافق» when a new version waits | Opened from «أكمل بياناتك»; a new version pushed on open                                                                                                                      | `GET /v1/customer/terms`, `POST /v1/customer/terms/accept`                 |
| Not found                                                | R15                       | Back home                                                | —                                                                                                                                                                             | —                                                                          |

## Plan

0. **Inventory check:** confirm the table above against the code (`apps/customer/lib/src/`, `packages/core_auth/lib/src/sign_in_screen.dart`, `packages/core_platform`) and the spec; send any spec gap to the owner, never guess it.
1. **Foundations** (first used by this batch's tests and drawings):
   - R19: one synthetic fixture set (names, phones, addresses, restaurants, dishes, amounts) that the drawings, the goldens and the tests all read; replace the typed-in values of `apps/customer/test/fixtures.dart` with it. Decide its home and record it in `docs/code/apps/customer.md`.
   - R11: a screen-test harness in the customer app's tests: semantics names for every control, 48 dp targets, disabled actions, 130% text, and goldens at 360 × 640 and 412 × 915 (normal and 130%) for each screen.
   - R2 and R20 in `packages/fox_lints`: `enforcedPackages` also takes folders and files of an app, so each batch adds what it restyles; a `file_too_long` rule (400 lines without blank lines and comments) over the same paths. D.17 replaces the paths with `apps/customer` whole.
   - R12: the profile-mode run on the 2 GB emulator, its command and the result recorded here; each later batch repeats it.
   - The backlog item «Fox Lira's licence in the apps» for the customer app (`LicenseRegistry`).
2. **Draw** (§9.9 step 2): create the customer app's screens canvas (architecture §9.8, its link kept out of the repository, in the owner's memory file of design artifacts) and draw this batch with the Fox Drop Design System installed; the shared screens also in the captain's and restaurant's themes. Check the artboards for literal colours, unknown tokens and hand-drawn copies of components; write the result here.
3. **Prototype** (step 3): every artboard interactive, every state above reachable by its action or a labelled switcher; no real API.
4. **Analysis** (step 4), written here and shown with the drawings: (a) every route, response field and error code above, where each is shown or why not; (b) API gaps, fixed in the server in this slice or a small slice before it (T1); (c) spec gaps to the owner; (d) improvements for Azaz with their cost; (e) missing components, drawn on their own sheet (step 5).
5. **Designer pass** (step 6): skipped in this batch (see «Before the design checkpoint»).
6. **Approval** (step 7): the owner tests the prototype and approves. Nothing in the batch is coded before.
7. **Code** (step 8): the screens on `core_ui` only; the frame as a go_router shell route; the shared screens in `core_auth` and `core_platform`, which join the lint; goldens and the comparison with the drawing, each difference fixed or explained here. One commit per step, `checker` once per checkpoint.
8. **Store review (R18):** the sign-up's terms and privacy links, the WhatsApp code text, no age gate (CU §5.3); record the checklist here.

Tests written first (locked in the red phase):

- R11 for every screen above, in the customer theme and, for the shared screens, the captain and restaurant themes.
- R14: «متابعة» and the code entry cannot send twice; a lost answer resends with the same `Idempotency-Key` where the command has one.
- R15: each tab is a route; a guest's «طلباتي» and «حسابي» go through sign-in and back; Android back from each tab and from the code screen.
- R16: the blocking screen leaves an active order's screen reachable and readable.
- The banner stack shows the banners in §6.2's order and the counter of the rest.
- The lint: an `Image.network`, a Material import or a 401-line file in an enforced path is reported; outside it, not.

## Design checkpoint (steps 2 to 4, 2026-11-24)

Drawn on the customer screens canvas (architecture §9.8; its link is in the owner's memory file of design artifacts, never here) with the Fox Drop Design System installed (`FoxDrop` bundle, version of 2026-11-24). Owner's brief: «creative, professional and distinctive», full latitude.

- **Figma look (§2 of the build skill):** the file's API answered 429 (Starter rate limit) on 2026-11-24, so the ideas come from its recorded shape language (`docs/brand/expression.md` §2): the pill and circle, the offset shadow under the main action and the active tab, the floating accent bar, ivory ground with blue words and orange titles. The S-curve tab and cut-out dishes stay with home and the dish sheet (D.12, D.13).
- **The idea: «مدار» (orbit).** The sign-in screen puts the fox mark in a tinted circle on a dashed orbit, with three chips that say what signing in means (customer: code on WhatsApp, no password, to your door; captain and restaurant their own), echoing the icon set's name. The form rises from the bottom as a raised sheet, so the number and «إرسال الرمز» sit in the thumb zone (R17). The blocking screens reuse the orbit with an orange badge on its offset shadow; the starting screen uses the brand's drop that fills (expression §2).
- **Artboards:** one interactive prototype of the whole flow at 412 × 915 with a labelled state switcher beside the phone (screen, app, account state, the server's answers to the number and the code, blocking screen, the six banners of CU §6.2, active order, slow start, office closed, map failed, D.13 slots, 130% text); and, from the same drawing, 360 × 640 in normal and 130% text (number, code, details, frame with banners), the forced update over an active order, the dues office sheet, the captain's sign-in (captain theme and type scale) and the restaurant tablet (1280 × 800, brand pane and form).
- **Literal-value check:** no literal colour; every `--fd-*` name used is defined in the bundle's CSS; lengths are tokens except device sizes, and the illustration geometry is multiples of size tokens. No hand-drawn copy of a component: buttons, fields, code cells, banners, banner stack, cards, chips, timer, skeleton, empty state, list rows, select and switch are the bundle's own. Drawn from core_ui tokens (Flutter-only, no web counterpart): the floating bottom navigation, the bottom sheet, the date field.
- **Synthetic data (R19):** the drawings use one set (code 246810, `+963 900 112 233`, `+90 500 112 2334`, «سارة الخطيب», «مطعم الشام», «الحي الشمالي», dues 75000 TRY minor units); step 1 makes it the shared fixture file the goldens and tests read.

### Analysis (step 4)

(a) **Routes, fields and errors**, each placed: `auth/session` decides guest or signed in at start; `platform.updateNeed` (required: blocking screen; suggested: first banner), `updateMessage`, `maintenance`, `maintenanceMessage`; `emergency-stop.active`, `browseMessage` (second banner; `delayNotice` belongs to D.16, `startedAt` to the attempt count); `account-state.reviewStop`, `block.until`/`reason`, `dues`, `office` (sheet: map, open until / opens at, hours per weekday, null shows «لم يُحدَّد موقع المكتب بعد»); `contact.phone`/`whatsapp` (a missing number hides its button); `terms.version`, `body` (a paragraph per line), `publishedAt`, `pending` (fifth banner and «أوافق»); `profile.completed`, fields and `acceptTerms`; `auth/code.resendAfterSec` (the countdown), `channel`; refusals `not_on_whatsapp`, `daily_limit`, `hourly_limit`, `ip_limit`, `resend_wait`, `unavailable`, `not_registered`, `restaurant_draft`, `restaurant_terminated` in a banner inside the number sheet, `app_check_failed` as the generic failure; `auth/sign-in.newAccount`, `wrong_code` with `attemptsLeft`, `code_expired` under the cells. `expiresAt` is not shown.

(b) **API gaps:** the platform hours are not sent to the app, so the «outside platform hours» banner has no source outside checkout (proposed: `hours: {open, opensAt}` on `GET /v1/customer/platform`, T1 small); `code_expired` also covers used-up attempts, two cases the customer cannot tell apart (proposed: `attempts_used`, or one message for both).

(c) **Spec questions for the owner:** a guest's «طلباتي» and «حسابي» show an in-tab invitation with «تسجيل الدخول» instead of jumping to sign-in (CU §5.1); terms and help readable without an account from «حسابي» (store rules); how long a dismissed «يتوفر إصدار أحدث» stays hidden (drawn: until the next launch); terms and privacy are one `body`, drawn as one page that both links open.

(d) **Improvements with cost:** the reason line by origin («سلّتك محفوظة كما هي» from checkout) and the rule in the phone error («10 أرقام تبدأ بـ 09», «11 رقماً تبدأ بـ 05»), strings only; auto-submit on the sixth digit and the clipboard offer, in the batch; a «who sees what» note under the details, one string; the installed and required versions on the update screen (needs `minVersion` on `GET platform`, T1 small); a landmark description of the office under its map (a panel field and an `account-state` field, T1 medium); «الاتصال بطيء، ما زلنا نحاول…» on a slow start, in the batch.

(e) **Missing components** (their own artboard, approved with the screens): `FoxDropLoader` (the filling drop), `FoxOrbitHero` (the sign-in orbit), `Banner` with `onDismiss` and a second action (CU §4.2 and §5.5), `FoxTextLink` (inline underlined link with a 48 target), `FoxBrandStatus` (the blocking screens' head).

**R18 draft:** terms and privacy linked from «أكمل بياناتك» and readable without an account; the code text names WhatsApp and the app never reads messages, the clipboard offer shows itself; no age gate, birthday optional; no notification permission in this batch (first order, Q11).

## Stopped at

Design checkpoint drawn (2026-11-24): canvas, prototype, analysis and missing components ready for the owner. Waiting for the owner's answers to (b) to (e) and the approval of the screens (step 7); nothing coded. Step 1 (foundations) not started.

## Evidence

- `node scripts/verify.mjs --changed`: —
- Drawings, prototype and analysis: the screens canvas (link outside the repository)
- R12 profile run: —
- Review: —

## Before deploying

New store builds of the three apps (the shared sign-in screen changes in each).

## To check on staging

The owner installs the customer app fresh, opens each tab as a guest, signs in with a Syrian and a Turkish number, completes the details; turns maintenance on in the panel while an order is active; the captain and restaurant apps show the new sign-in.

## Notes for the next session

- The sign-in screen is one for the three apps (owner, 2026-11-24). The captain's and restaurant's other screens stay unstyled until their own batches.
- `checkout_screen.dart` (749 lines) and `order_screen.dart` (513) are split by D.15 and D.16 when they join the lint.
