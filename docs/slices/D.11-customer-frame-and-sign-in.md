# D.11 Customer screens 1: the frame, sign-in and account details

Status: Planned · Tier: T2 · Branch: `feat/customer-screens-sign-in`
Spec: architecture §9.5 (R1 to R20), §9.9 (the screen cycle), T13; CU §4.2, §4.7 (blocking screens, terms, platform hours, emergency stop), §5.1 to §5.5, §6.1 (bottom bar), §6.2 (banners), §13 («الشروط والخصوصية»); RA §5 and CA §5 for the shared sign-in screen · Definition of done: the D.11 line of `docs/roadmap.md`; keeps CU §19 items 1 to 3, 26 and 27 passing

## Goal

The customer app's first styled batch: the frame every later screen sits in (the bottom navigation, the banner stack, the blocking screens) and the way in (phone number, code, «أكمل بياناتك», the terms). The sign-in screen is shared by the three apps (`core_auth`), so it is drawn and built for the customer, the captain and the restaurant at once (owner, 2026-11-24). It also lays the foundations of every later customer batch: the shared fixtures (R19), the screen-test harness (R11), the file-length rule (R20) and the lint that follows the batches into the app (R2).

## Before the design checkpoint

- **The designer pass (§9.9 step 6) is not decided yet.** The owner discusses it after this planning and before any batch starts (owner, 2026-11-24: the plan, the seat and the Figma file). Do not start step 2 until it is settled and recorded here.
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
5. **Designer pass** (step 6), as the owner decides before this slice starts.
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

## Stopped at

Planned (2026-11-24); waits for the designer-pass decision.

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
