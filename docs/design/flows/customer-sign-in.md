# Customer: sign-in

Step: 5 Polish, 2026-11-28: batch 1, the shared Core and Mobile components, built in the library with every state and audited to 0, v0.5 published by Claude at the owner's request and accepted in the customer file (Polish, below); next, batch 2, `Customer/Sign-in reason` on the customer file's components page, then the screens

The phone sign-in of `core_auth`, designed once here for the three apps (rules.md, Components and screens; surfaces.md). The restaurant and captain files link to these screens and add only what differs: «لديّ رمز من العمليات», the captain's «انضم ككابتن», the restaurant's Windows pairing and their own refusals. This file covers the customer's flow: from the moment sign-in is asked for to the customer being back where they were, «أكمل بياناتك» included.

## Analysis

### Sources

- Spec: CU §5.1 guest browsing and the return after sign-in, §5.2 sign-in, §5.3 «أكمل بياناتك», §5.4 sessions, §5.5 account states (the banners shown after sign-in), §6.1 screen map, §6.2 banner order, §4.5 weak internet; decisions U2, U3, U4, Q1, Q2, Q3, Q4; Appendix B «Sign-in» row; CU §18 item 2 (Syrian or Turkish default).
- Architecture §8.3.2 the code, §8.3.3 the limits and App Check, §8.3.4 in the apps. The customer app has no «لديّ رمز من العمليات» and no emergency code (§8.3.5).
- Settings (AP Appendix A): `customer.phone_default_country` (SY or TR, before launch), `otp.validity_min` 5, `otp.max_attempts` 5, `otp.resend_after_sec` 60, `otp.number_hourly_max` 3, `otp.number_daily_max` 6, `otp.number_daily_max_abroad` 3, `otp.device_daily_max` 6, `otp.ip_hourly_max` 30, `otp.app_check_required`.
- Code: `apps/server/src/modules/identity/customer-auth.controller.ts`, `app-sign-in.service.ts`, `app-auth.ts` (`codeRequestAnswer`); `apps/server/src/modules/customers/customer-profile.controller.ts`; `packages/core_auth/lib/src/` (`sign_in.dart` `SignInState`, `phone_rules.dart` `FoxPhoneProblem`, `auth_party.dart` `AuthRefusal`); `apps/customer/lib/src/router.dart` (`signInFrom`, still a stub that returns home).

### Entry points

Sign-in is never the first screen: a guest browses (U2). It is asked for when the guest:

| Entry                                                                                              | Where the customer returns                                                    |
| -------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| «تأكيد الطلب» at checkout                                                                          | Checkout, quote refreshed for the account (Q10); they tap «تأكيد الطلب» again |
| The code field at checkout («سجّل الدخول لاستخدام الأكواد»)                                        | Checkout                                                                      |
| Addresses, «أكوادي», favourites, notifications, a report, «أبلغ عن سعر مختلف»                      | The screen they opened                                                        |
| The invitation inside the «طلباتي» and «حسابي» tabs (the guest stays in the tab, owner 2026-11-24) | The tab                                                                       |

The cart stays as it was; an address filled at checkout is kept, and saved if «احفظ هذا العنوان» was ticked (§5.1). `router.dart` passes only a path of this app as the return (`_safeFrom`).

### Steps and screens

1. **Phone number.** Country chip (calling code, no flag) and the number field, left to right inside the right-to-left screen; «إرسال الرمز».
   - Country sheet «اختر الدولة»: search by Arabic name, English name or code; groups «الأكثر استعمالاً» (Syria +963, Turkey +90), «آخر ما استعملته», «كل الدول»; empty result «لا دولة بهذا الاسم أو الرمز».
   - The field reads a national number with or without 0, `+`, `00` or a calling code (which switches the country, with «عرفنا الدولة من رمزها: {country}»), and Arabic-Indic digits, shown as Western digits.
   - Inline problems (`FoxPhoneProblem`): empty, missing digits (plural), too long, landline, not a mobile prefix, unknown code; and a valid mark «الرقم صحيح».
2. **Code.** «أرسلنا الرمز إلى واتساب على الرقم {phone}», six digit cells (`Numeric/L`), paste and, on Android, the offer to paste a 6-digit code found on the clipboard (no SMS auto-fill for WhatsApp); a 60-second countdown «إعادة الإرسال بعد {seconds} ث», then «إعادة الإرسال»; «تعديل الرقم» back to step 1 with the number kept. Sent on the sixth digit (Decided, item 2).
3. **Existing account:** signed in («تم تسجيل الدخول») and back to the entry point.
4. **New account** (`newAccount: true`), and any account whose profile is not `completed`: «أكمل بياناتك» (§5.3), one screen: «الاسم» required, «الكنية» optional, «الجنس» «ذكر» or «أنثى» required, «تاريخ الميلاد» optional (past date, date picker), terms checkbox «أوافق على الشروط وسياسة الخصوصية» with links to both, «حفظ». The router keeps a signed-in customer on this screen until it is sent.
5. **After sign-in:** the account-state banner if any (§5.5: review stop, blocked for a duration, until further notice, until dues are paid), and the terms prompt if a newer version waits («termsNewVersion»). These screens belong to their own flows; this flow only shows that they can follow.

A «مغلق» account is not a state here: signing in with its number creates a new account (§5.5), so it lands on «أكمل بياناتك».

### Server routes and data

| Route                            | Body                                                            | Answer                                             |
| -------------------------------- | --------------------------------------------------------------- | -------------------------------------------------- |
| `POST /v1/customer/auth/code`    | `phone` (E.164), `deviceId`; header `X-Firebase-AppCheck`       | `channel: whatsapp`, `resendAfterSec`, `expiresAt` |
| `POST /v1/customer/auth/sign-in` | `phone`, `deviceId`, `code`                                     | `accountId`, `newAccount`, tokens                  |
| `GET /v1/customer/profile`       | —                                                               | `completed`, the fields, the account's phone       |
| `PUT /v1/customer/profile`       | `firstName`, `lastName`, `gender`, `birthday`, terms acceptance | The profile                                        |
| `POST /v1/customer/auth/refresh` | `refreshToken`                                                  | Tokens; `401` signs the app out silently           |

The code request answers the same whether the number has an account or not (architecture §8.3.2). The sender's answer comes within 10 seconds, so the send can take that long on a slow line: the button needs a loading state that lasts.

### Errors and limits

| Answer                                   | When                                              | String                                                                                                          | Screen behaviour                                             |
| ---------------------------------------- | ------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------ |
| Phone problem (client)                   | Before sending                                    | `phoneEmpty`, `phoneMissingDigits`, `phoneTooLong`, `phoneLandline`, `phoneNotMobilePrefix`, `phoneUnknownCode` | Field in Error, send disabled or refused                     |
| `400 not_on_whatsapp`                    | The number has no WhatsApp                        | `signInNotOnWhatsapp`                                                                                           | Stays on step 1, field in Error                              |
| `429 resend_wait` (`retryAfterSec`)      | A code was sent less than 60 s ago                | `signInResendWait`                                                                                              | Countdown from the server's seconds                          |
| `429 hourly_limit`, `ip_limit`           | 3 codes this hour on the number; 30 from the IP   | `signInTryLater` (minutes)                                                                                      | Message, send disabled until then                            |
| `429 daily_limit`                        | 6 a day (3 abroad), or 6 from the device          | `signInDailyLimit`                                                                                              | Message with no retry, and «اتصال بالدعم» and «واتساب الدعم» |
| `403 app_check_failed`                   | No valid App Check token (modified app, emulator) | `new:signInAppCheckFailed`                                                                                      | Message, and «اتصال بالدعم» and «واتساب الدعم»               |
| `503 unavailable`                        | No sending number can send                        | `signInUnavailable`                                                                                             | Retry later; the customer app has no operations code         |
| No answer                                | Lost connection or timeout                        | `signInError`                                                                                                   | Retry; the no-internet bar may also show (§6.2)              |
| `400 wrong_code` (`attemptsLeft`)        | Wrong code                                        | `signInWrongCode`                                                                                               | Shake and Error, cells cleared after about 1.5 s             |
| `400 attempts_used`                      | 5 wrong tries                                     | `new:signInAttemptsUsed`                                                                                        | Ask for a new code                                           |
| `400 code_expired`                       | After 5 minutes, or replaced by a newer code      | `signInCodeExpired`                                                                                             | Ask for a new code                                           |
| `400 terms_required`, `invalid_birthday` | «أكمل بياناتك» without terms, or a future date    | `customerProfileTermsRequired`, none for the date                                                               | Field in Error                                               |
| Save failed                              | «أكمل بياناتك»                                    | `customerSaveFailed`                                                                                            | Stays with the values kept                                   |

The server's error answers are not in the OpenAPI document yet, so `core_auth` maps them by hand (backlog, «Error answers in the API contract»).

### Strings

Existing `core_l10n` keys this flow uses: `signInTitle`, `signInPhoneLabel`, `signInInvalidPhone`, `phoneEmpty`, `phoneMissingDigits`, `phoneTooLong`, `phoneLandline`, `phoneNotMobilePrefix`, `phoneUnknownCode`, `phoneSwitchedCountry`, `phoneCountryChip`, `phoneValid`, `phoneClear`, `countrySheetTitle`, `countrySheetClose`, `countrySearch`, `countrySearchClear`, `countryPinned`, `countryLastUsed`, `countryAll`, `countryNone`, `signInSendCode`, `signInCodeSent`, `signInCodeLabel`, `signInConfirm`, `signInPasteCode`, `signInResend`, `signInResendIn`, `signInEditPhone`, `signInNotOnWhatsapp`, `signInDailyLimit`, `signInTryLater`, `signInResendWait`, `signInUnavailable`, `signInWrongCode`, `signInCodeExpired`, `signInError`, `signedIn`, `customerProfileTitle`, `customerProfileFirstName`, `customerProfileLastName`, `customerProfileInvalidName`, `customerProfileGender`, `customerProfileMale`, `customerProfileFemale`, `customerProfileGenderRequired`, `customerProfileBirthday`, `customerProfileTerms`, `customerProfileTermsRequired`, `customerSave`, `customerSaveFailed`.

Not for the customer: `signInOperationsCode`, `signInOperationsCodeHint`, `signInUnavailableOperations`, `signInCallOperations`, `signInWhatsappOperations` (restaurant and captain only).

`new:` proposals, approved by the owner on 2026-11-28 with the drawing: the text layers carry these names, and the keys enter the translation files at the polish step. The last row was written by Claude at the owner's request («the best and most professional»):

| Proposed key                         | Proposed text                                                                     | Why                                                                                                                                                                   |
| ------------------------------------ | --------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `new:customerCodesSignIn`            | «سجّل الدخول لاستخدام الأكواد»                                                    | CU §5.1 gives the text; not in the translation file yet                                                                                                               |
| `new:customerGuestOrders`            | «سجّل الدخول لترى طلباتك»                                                         | The «طلباتي» invitation (owner 2026-11-24); no text in the spec                                                                                                       |
| `new:customerGuestAccount`           | «سجّل الدخول لتحفظ عناوينك وأكوادك ومفضلتك»                                       | The «حسابي» invitation; no text in the spec                                                                                                                           |
| `new:signInPhoneIntro`               | «أدخل رقم جوالك عليه واتساب، وسنرسل لك رمز الدخول»                                | Says up front that the code comes over WhatsApp                                                                                                                       |
| `new:signInAttemptsUsed`             | «استنفدت محاولات هذا الرمز، اطلب رمزاً جديداً»                                    | `attempts_used` has no string                                                                                                                                         |
| `new:customerProfileInvalidBirthday` | «اختر تاريخاً قبل اليوم»                                                          | `invalid_birthday` has no string                                                                                                                                      |
| `new:customerProfileTermsLink`       | «الشروط»                                                                          | The checkbox links to both texts (§5.3)                                                                                                                               |
| `new:customerProfilePrivacyLink`     | «سياسة الخصوصية»                                                                  | Same                                                                                                                                                                  |
| `new:signInAppCheckFailed`           | «تعذّر التحقق من هذا التطبيق. حدّثه من المتجر وحاول مرة أخرى، أو تواصل مع الدعم.» | `app_check_failed`; it can also hit a genuine phone (an old or rooted Android, App Check from Syria, architecture §22 item 9), so it blames nobody and offers support |

Proposed for the chosen direction D and its revision (2026-11-28), approved by the owner with the choice; the keys enter the translation files at the polish step. B's and E's proposals were dropped with them. The tab label «الرئيسية» belongs to the navigation flow and is only drawn as context here.

| Proposed key                        | Proposed text                                      | Where                                                        |
| ----------------------------------- | -------------------------------------------------- | ------------------------------------------------------------ |
| `new:signInReasonCheckout`          | «طلبك جاهز، بقي تأكيد رقمك»                        | The checkout reason's title                                  |
| `new:signInReturnCheckout`          | «سنعيدك إلى طلبك فوراً»                            | The line under it                                            |
| `new:signInReasonItems`             | «{count} أصناف»                                    | The order drawing (plural forms in the ARB)                  |
| `new:signInStepPhone`               | «رقمك»                                             | The step line (with `customerCart` «السلة»)                  |
| `new:signInStepDetails`             | «بياناتك»                                          | The step line of «أكمل بياناتك»                              |
| `new:signInStepOrder`               | «الطلب»                                            | The step line's last step                                    |
| `new:signInStatusSent`              | «أُرسل»                                            | The delivery status                                          |
| `new:signInStatusDelivered`         | «وصل إلى واتساب»                                   | The delivery status, on WhatsApp's delivery receipt          |
| `new:signInStatusChecking`          | «جارٍ التحقق…»                                     | The delivery status after the sixth digit                    |
| `new:signInStatusLate`              | «لم يصل بعد؟ تأكد أن واتساب يعمل على هذا الرقم»    | The delivery status after 15 s with no receipt               |
| `new:signInReasonOrdersLine`        | «تابع طلبك لحظة بلحظة، وأعد طلب ما أحببت بلمسة»    | The «طلباتي» reason's line (title `new:customerGuestOrders`) |
| `new:signInReasonAccountLine`       | «حساب واحد يحفظ كل شيء، على أي هاتف»               | The «حسابي» reason's line (title `new:customerGuestAccount`) |
| `new:signInReasonAddresses`         | «سجّل الدخول لتحفظ عناوينك»                        | The addresses reason                                         |
| `new:signInReasonAddressesLine`     | «اطلب إلى البيت أو العمل دون كتابة العنوان كل مرة» | Its line                                                     |
| `new:signInReasonCodes`             | «سجّل الدخول لترى أكوادك»                          | The «أكوادي» reason                                          |
| `new:signInReasonCodesLine`         | «خصوماتك وعروضك في مكان واحد»                      | Its line                                                     |
| `new:signInReasonNotifications`     | «سجّل الدخول لترى إشعاراتك»                        | The notifications reason                                     |
| `new:signInReasonNotificationsLine` | «حالة طلبك وعروضك، أولاً بأول»                     | Its line                                                     |
| `new:signInReasonFavourite`         | «سجّل الدخول لتحفظ {restaurant} في مفضلتك»         | The heart's reason                                           |
| `new:signInReasonFavouriteLine`     | «تجده في «المفضلة» متى عدت إليه»                   | Its line                                                     |
| `new:signInReasonBannerCode`        | «سجّل الدخول لتستخدم الكود {code}»                 | A banner's code                                              |
| `new:signInReasonBannerCodeLine`    | «يُحفظ في «أكوادي» ويُطبّق عند الدفع»              | Its line                                                     |
| `new:signInReasonPriceReport`       | «سجّل الدخول لتبلغ عن سعر مختلف»                   | «أبلغ عن سعر مختلف»                                          |
| `new:signInReasonPriceReportLine`   | «نراجع البلاغ مع المطعم ونصحح السعر»               | Its line                                                     |
| `new:customerProfileIntro`          | «خطوة أخيرة، ليصل طلبك باسمك»                      | «أكمل بياناتك»                                               |
| `new:customerOptional`              | «اختياري»                                          | The optional fields' tag                                     |
| `new:customerProfileBirthdayHint`   | «اختر التاريخ»                                     | The birthday field's placeholder                             |
| `new:customerDatePickerDone`        | «تم»                                               | The date sheet's button                                      |

### States to design

- **Phone:** empty; typing; valid; each phone problem; country sheet open, searching, no result; sending (up to 10 s); each refusal of the code request; offline.
- **Code:** waiting with the countdown; resend offered; clipboard paste offered (Android); typing; checking; wrong code with attempts left; attempts used; expired; resend refused (limits); offline.
- **«أكمل بياناتك»:** empty; filled; each field's error; date picker; saving; save failed.
- **Entry and return:** the «طلباتي» and «حسابي» invitations; the checkout code field for a guest; the return to checkout with a changed quote (drawn in the checkout flow, referenced here).
- **Text 130%** and 360, 390, 430 wide for each, and the screen reader's text for the country chip, the code cells and the countdown (rules.md, Accessibility; «Ready for dev» items 4 and 6).

### What the system needs (no component exists yet)

The registry holds only brand assets, so every part is new and goes through the Choice step. Likely parts, by rules.md (Layers and naming): a button, a text field with a prefix and an error, a code input, a checkbox, a radio or segmented choice, a date field, a bottom sheet with a search field and grouped list rows, an inline message (error, info), a top bar with back, and a countdown or timed link. Most have no business meaning, so Core or Mobile; the phone field and the code input are shared by the three apps through `core_auth`, so they are not customer components.

## Directions

Discussed in the chat on 2026-11-28. Every direction is a full screen (Decided, item 1) with the code sent on the sixth digit and the wrong-code behaviour of item 2; «أكمل بياناتك» takes the chosen direction's style. Directions D and E came from the owner, F from research on delivery and WhatsApp sign-in (Baymard on showing the gain at the moment of sign-in; Meta's copy-code authentication templates, which our unofficial sender cannot use).

| Direction                         | Idea                                                                                                                                                                                                                                                                                                     | What it changes in components                                                                                                              | Risk                                                                                                                                                                   | Owner's decision and date                               |
| --------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| A «هادئ ومباشر»                   | Ivory canvas, small horizontal lockup, a large title and `new:signInPhoneIntro`, one field, the button pinned above the keyboard; the code screen's six large cells with a small WhatsApp mark; a thin progress line on the sixth digit, the cells turning to success one by one, then a check           | The fewest: button, text field, code input, inline message, country sheet with search and rows, top bar                                    | Low; can look ordinary                                                                                                                                                 | Drawn, then deleted at the owner's decision, 2026-11-28 |
| B «الهوية في الواجهة»             | A blue band with the fox mark and a welcome line over the top third, the form on an ivory card rising over it; the band shrinks to a thin bar with the lockup when the keyboard opens; on success the fox moves briefly                                                                                  | A's, plus a decorative header (`Mobile/Decor/…`)                                                                                           | Medium: the band must collapse at 360 × 800 and at «Text 130%»; more drawing                                                                                           | Not chosen: the owner chose D, 2026-11-28               |
| C «شاشة واحدة متصلة»              | Number and code on one screen: after the send, the phone field folds into a summary line «+963 9xx… · تعديل» and the code cells slide in under it                                                                                                                                                        | A's, plus a summary row with an edit action                                                                                                | Medium to high: many states on one screen, harder motion and screen-reader focus; the restaurant and captain additions crowd the shared screen                         | Drawn, then deleted at the owner's decision, 2026-11-28 |
| D «حسب سبب الدخول» (owner)        | The top section shows why sign-in was asked: the order card at «تأكيد الطلب» (restaurant, item count, total, «طلبك جاهز، بقي تأكيد رقمك»), codes, addresses and favourites together from «حسابي», an order on its way from «طلباتي», the item's own icon elsewhere; read from the device, no server call | A customer header with one variant per entry point; the shared `core_auth` screen gains an optional header slot the other apps leave empty | Four or five header variants, each with new strings; each must shrink with the keyboard, at 360 wide and at «Text 130%»                                                | Chosen, 2026-11-28, and revised (Decided, item 8)       |
| E «رحلة الدراجة» (owner)          | A simplified map in identity colours with a delivery bike on a route ending at the guest's chosen pin; the bike leaves the restaurant on the phone step, reaches halfway when the code is sent, speeds up on the sixth digit, arrives at the door on success, and pauses with the shake on a wrong code  | An illustrated, animated `Mobile/Decor/Delivery route`; Figma holds its key frames, the motion is made later (Rive or Lottie)              | Highest drawing and motion cost; must stay light on cheap phones; a still frame under reduced motion; the bike faces its direction of travel (rules.md, Right to left) | Not chosen: the owner chose D, 2026-11-28               |
| F «المحادثة مع واتساب» (research) | The code screen is built around the trip to WhatsApp: a bubble like the message the customer will get, from FOX DROP with the code hidden, a «فتح واتساب» button, and «لصق الرمز» offered at once on return when the clipboard holds a code                                                              | A message bubble; it belongs to `core_auth`, since the restaurant and captain codes also come over WhatsApp                                | «فتح واتساب» is not in CU §5.2: it needs the owner's spec change before code                                                                                           | Drawn, then deleted at the owner's decision, 2026-11-28 |

**What is drawn** (owner, 2026-11-28): each of the six as its own complete, creative design, not a variant of another (rules.md, Explorations): the phone screen, the code screen, the wrong-code moment and the success moment, on the customer file's «🧪 Explorations» page, one section per direction.

## Choice

Direction D, revised, approved by the owner on 2026-11-28 with this list; that approval covers the new Core and Mobile components (rules.md, Layers and naming). The registry held only brand assets, so every component is new. Shared components are built and published in the library (v0.5) before the screens, the customer's own on its components page, then the screens are rebuilt on the flow's own page from instances.

| `Draft/…` element                                           | Decision                                                                                                                     | Registry match | Layer    | Approved   |
| ----------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- | -------------- | -------- | ---------- |
| Button, button loading, the date sheet's «تم»               | New `Core/Button`: primary, secondary, text; Default, Pressed, Disabled, Loading                                             | None           | Core     | 2026-11-28 |
| Text field (name, last name, birthday)                      | New `Core/Text field`: label, «اختياري» tag, trailing icon; Default, Focused, Filled, Error, Disabled                        | None           | Core     | 2026-11-28 |
| Phone field, country chip                                   | New `Core/Phone field`: the three apps and the owner portal sign in by phone                                                 | None           | Core     | 2026-11-28 |
| Code input                                                  | New `Core/Code input`: Empty, Typing, Error, Success                                                                         | None           | Core     | 2026-11-28 |
| Delivery status                                             | New `Core/Code delivery status`: Sent, Delivered, Checking, Late                                                             | None           | Core     | 2026-11-28 |
| Inline message                                              | New `Core/Inline message`: Error, Success, Warning, Info                                                                     | None           | Core     | 2026-11-28 |
| Checkbox (terms)                                            | New `Core/Checkbox`, 48 target: Default, Checked, Error, Disabled                                                            | None           | Core     | 2026-11-28 |
| Choice tile (gender)                                        | New `Core/Choice tile`: Default, Selected, Error                                                                             | None           | Core     | 2026-11-28 |
| Icon button (back)                                          | New `Core/Icon button`, 48                                                                                                   | None           | Core     | 2026-11-28 |
| Spot illustrations                                          | New `Core/Decor/Illustration/<topic>`: Orders, Account, Addresses, Codes, Favourites, Notifications, Price report            | None           | Core     | 2026-11-28 |
| Top bar                                                     | New `Mobile/Top bar`: back and title                                                                                         | None           | Mobile   | 2026-11-28 |
| Bottom sheet (date; the country sheet, not drawn yet)       | New `Mobile/Bottom sheet`: handle, title, content                                                                            | None           | Mobile   | 2026-11-28 |
| Date wheels                                                 | New `Mobile/Date picker`                                                                                                     | None           | Mobile   | 2026-11-28 |
| Progress steps                                              | New `Mobile/Progress steps`: no business meaning                                                                             | None           | Mobile   | 2026-11-28 |
| Paste offer                                                 | New `Mobile/Paste offer`: with the code (Android), without it (iOS)                                                          | None           | Mobile   | 2026-11-28 |
| Status bar, system keyboard                                 | New `Mobile/Decor/Status bar` and `Mobile/Decor/Keyboard`: shown in Figma only, never coded                                  | None           | Mobile   | 2026-11-28 |
| Country sheet's search and rows (not drawn in D)            | New `Core/Search field` (Default, Focused, Filled, Disabled) and `Core/List row` (Default, Pressed, Selected, Disabled)      | None           | Core     | 2026-11-28 |
| The Solar stand-in icons                                    | New `Core/Icon/<name>`: 23 Solar Linear icons, as instance-swap targets (the spinner gave way to Core/Loader)                | None           | Core     | 2026-11-28 |
| Sign-in reason (header, tab invitation, compact invitation) | New `Customer/Sign-in reason`: three layouts × eight reasons; one part for the sign-in header and the tabs' guest invitation | None           | Customer | 2026-11-28 |
| Order waiting (checkout), restaurant logo, item thumbs      | Stays a drawing: waits for the order card of the cart and orders screens (owner, 2026-11-28)                                 | —              | —        | 2026-11-28 |
| Tab bar, app bar                                            | Stay drawings: designed in the navigation flow                                                                               | —              | —        | 2026-11-28 |
| «حسابي» list rows                                           | Stay drawings: designed in the «حسابي» flow                                                                                  | —              | —        | 2026-11-28 |

**What the flow's page holds** (step 5): every state of «States to design» above. A state that changes the screen's layout is a full 390 × 844 frame; a state that changes only a message is drawn once in a full frame and the others in a strip of states beside it (the six phone problems, the try-later and unavailable refusals); a component's own states (pressed, disabled, focused) live on the components page. About 35 full frames:

- **Phone:** empty, valid, a phone problem, the country sheet open, searching and with no result, sending, not on WhatsApp, the daily limit and `app_check_failed` with the support buttons, offline.
- **Code:** sent, delivered, late, paste on Android and on iOS, typing, checking, wrong code, attempts used, expired, resend refused, offline, success.
- **«أكمل بياناتك»:** empty, focused with the keyboard, errors, saving, the date sheet, save failed.
- **Reasons:** the two tab invitations, sign-in from checkout, from «طلباتي» and from the heart, and the sheet of the eight reasons.
- Then the «Text 130%», 360 and 430 copies, the prototype and the annotations («Ready for dev»).

## Polish

Batch 1, 2026-11-28 (the owner approved the analysis and its four recommendations in the chat the same day): every Core and Mobile part of Choice was built in the library (`ITmxeo3ipw0UH5OiV0880s`, page «🧩 Components», one section per family), with its states, its registry line as `Proposed` and its key, and its description starting `[Proposed]`. The page audit is at 0 for all 54 components; the only foundation change is the scrim's primitive (`alpha/blue-900-32`), and the foundations audit is at 0.

- **Analysis outcome.** Each part was compared with Material 3, Apple's HIG and product systems (Polaris, Atlassian, Base): labels sit above fields, never floating inside them (Arabic and «Text 130%»); every state differs by shape or words as well as colour; the code cells are one field for the screen reader and for paste; the choice tiles are one radio group; the sheet has no shadow, since its scrim already sets it apart.
- **States added to Choice:** Checking and Disabled for `Core/Code input`, Pressed for `Core/Choice tile` and the Picker type of `Core/Text field`, Scrolled for `Mobile/Top bar`, Today limit for `Mobile/Date picker`; `Core/Button` also has the Medium size (48) for actions inside messages.
- **Not added:** `border/brand` (`border/focus` already covers the selected control) and a sheet shadow.
- **Icons:** downloaded from the official `@iconify-json/solar` package 1.2.17 (CC BY 4.0) with the owner's approval and imported as vectors; their strokes bind `icon/*` and `border-width/default` (1.5).
- **Illustrations:** redrawn by hand as vectors on one 72 grid (no Figma AI), colours bound to semantic Color variables only.
- **Owner's corrections** (2026-11-28, after the screenshots): the Text button turned blue; the phone field's valid mark moved to the field's end edge (a spacer had pushed it inward, fixed in the search field too); the scrim lightened from 45% to 32%; a new `Mobile/Decor/Home indicator` sits under the keyboard and the sheet; the status bar and the indicator gained Blue and Ivory content by ground. Each became a rule in `rules.md`.
- **Loader** (owner's idea, 2026-11-28): `Core/Loader`, the brand mark faint, filling from the bottom and fading back, Orange, Blue or Ivory by ground, with a prototype loop on its variants; it replaced `Core/Icon/Spinner` (deleted) in `Core/Button` Loading and `Core/Code delivery status` Checking. A loading control is not pressable (rules.md).
- **Audit script changes** (`figma-audit.md`): the new kinds in `TARGETS`, every set's states in `STATES`, a labelled field's `Box` height or a row's minimum height counts as its control size, and a layer named `Disabled` (the date picker's future rows) is exempt from contrast.

## Figma

Customer file `FhvOwKGrGEv6p3JnIBHOof`, page «🧪 Explorations» (`7:16`), drawn 2026-11-28 with the library v0.4 (its variables, text styles and `Core/Brand/…` components; Almarai). One section per direction, each labelled «Not chosen yet» with one line on its idea; frames are 390 × 844, right to left, with the phone number and the code left to right. Every frame has a note under it for the behaviour a still cannot show (the shake, the timings, reduced motion). Every new element is drawn on the screen and named `Draft/…` (button, phone field, country chip, code input, inline message, top bar, the system keyboard, and each direction's own parts); nothing new entered the library. Icons are drawn in Solar Linear's style (24 grid, 1.5 stroke) as stand-ins, the chat-round icon standing in for WhatsApp's mark; the polish step replaces them with the Solar set. The amount on D's order card (`Draft/Sample amount`) and the restaurant name are sample data.

| Direction                            | Section  | Frames                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| ------------------------------------ | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| B «الهوية في الواجهة»                | `29:136` | B1 phone at rest `29:144`, B2 phone with the keyboard `29:191`, B3 code `29:266`, B4 wrong code `29:346`, B5 success `29:434`                                                                                                                                                                                                                                                                                                                                      |
| D «حسب سبب الدخول» · revised, chosen | `37:151` | From checkout: D1 phone `37:160`, D2 code delivered `37:266`, D3 paste `37:375`, D4 wrong code `37:488`, D5 checking `37:601`, D6 success `37:671`; «أكمل بياناتك»: D7 empty `39:147`, D8 errors `39:226`, D9 saving `39:322`, D10 date sheet `39:405`, D11 save failed `39:527`; reasons: D12 «طلباتي» tab `41:139`, D13 «حسابي» tab `41:186`, D14 sign-in from «طلباتي» `41:248`, D15 from the heart `41:328`, D16 every reason and the delivery status `41:404` |
| E «رحلة الدراجة»                     | `32:155` | E1 phone `32:163`, E2 code `32:247`, E3 wrong code `32:341`, E4 success `32:447`, E5 the bike's five key frames `32:503`                                                                                                                                                                                                                                                                                                                                           |

D was redrawn on 2026-11-28 with the owner's changes (Decided, item 8) as the section «D «حسب سبب الدخول» · revised» at the top of the page, and the first D section was deleted; B and E carry «Not chosen». A, C and F were drawn on 2026-11-28 and deleted the same day at the owner's decision after seeing them (Decided, item 7); Figma's version history still holds them, and their `new:` strings were dropped with them. The ids are node ids of this page and do not survive a rebuild; the chosen direction is rebuilt on the flow's own page at the polish step.

## Reviews

| Date | Who | What was approved | Version-history checkpoint |
| ---- | --- | ----------------- | -------------------------- |

## Decided

Owner, 2026-11-28, on the analysis's open points:

1. **A full screen,** pushed over the screen that asked for sign-in, not a bottom sheet; back returns there.
2. **The code is sent on the sixth digit,** with no «تأكيد» tap, and a short, simple animation while it is checked and on success. **A wrong code** shakes the cells, turns them to Error and shows `signInWrongCode` with the attempts left; after about 1.5 seconds the cells clear and the focus returns to the first cell, the message staying until the next digit. Under reduced motion the shake and the animation are replaced by the Error state alone (rules.md, Accessibility).
3. **`app_check_failed`** shows `new:signInAppCheckFailed` with «اتصال بالدعم» and «واتساب الدعم» (`customerCallSupport`, `customerWhatsappSupport`), Claude's wording at the owner's request.
4. **The daily limit** message `signInDailyLimit` carries «اتصال بالدعم» and «واتساب الدعم».
5. **The `new:` strings** are approved with the drawing.
6. **The default country is Syria** (+963); the design draws Syria and checks that a Turkish number fits.
7. **Directions A, C and F are dropped** after the owner saw the six drawn, 2026-11-28, and deleted from Figma; the choice is between B, D and E.
8. **D is chosen and revised** (2026-11-28), after the owner asked for an analysis of the whole customer sign-in and approved every proposal:
   - **No «ليس الآن»:** the back arrow and the system back return to the screen that asked; sign-in never opens unasked (U2).
   - **From checkout:** a step line «السلة ✓ · رقمك · الطلب» («بياناتك» added for a new account), the title «طلبك جاهز، بقي تأكيد رقمك», the line «سنعيدك إلى طلبك فوراً», and the waiting order as a drawing only, not a component, until the order card is designed.
   - **Other reasons:** one part, `Customer/Sign-in reason`, shows the reason as the sign-in header and as the guest's invitation inside «طلباتي» and «حسابي»; the heart, a banner's code and «أبلغ عن سعر مختلف» put the object's name in the title instead of drawing its card.
   - **Illustrations:** flat with soft depth in the identity's colours, not 3D (light, themable, can move in Rive later), shared by every surface as `Core/Decor/Illustration/<topic>` (owner's question, 2026-11-28).
   - **Code screen:** the WhatsApp delivery status (sent, delivered, late after 15 s), the copied code offered on return (Android reads the clipboard once when the app comes back; iOS reads it only on a tap), «جارٍ التحقق…» on the sixth digit, and the reason card turning to success.
   - **WhatsApp autofill is not possible** with our unofficial sender (it needs Meta's authentication templates, paid per message); the message will start with the code so it shows in the notification banner.
   - **«أكمل بياناتك»** in the same style: the step line, gender as two tiles, «اختياري» tags, a three-wheel date sheet, no back arrow.

## Open points

1. **The primary button's contrast exception** (rules.md, Tokens and colour) is judged on a phone outdoors at this flow's approval, since it is the first flow.
2. **`customer.phone_default_country`** is set to SY in the panel before launch; CU §18 item 2's delivery test to Syrian and Turkish numbers still runs.
3. **The delivery status and the message starting with the code** need a CU §5.2 change and a server slice before they are coded (backlog, «The code's delivery status in the apps»).
