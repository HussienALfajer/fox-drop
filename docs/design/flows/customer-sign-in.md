# Customer: sign-in

Step: 3 Explorations, 2026-11-28 (analysis and six directions discussed with the owner the same day; nothing drawn yet)

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

| Direction                         | Idea                                                                                                                                                                                                                                                                                                     | What it changes in components                                                                                                              | Risk                                                                                                                                                                   | Owner's decision and date |
| --------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------- |
| A «هادئ ومباشر»                   | Ivory canvas, small horizontal lockup, a large title and `new:signInPhoneIntro`, one field, the button pinned above the keyboard; the code screen's six large cells with a small WhatsApp mark; a thin progress line on the sixth digit, the cells turning to success one by one, then a check           | The fewest: button, text field, code input, inline message, country sheet with search and rows, top bar                                    | Low; can look ordinary                                                                                                                                                 | Draw, 2026-11-28          |
| B «الهوية في الواجهة»             | A blue band with the fox mark and a welcome line over the top third, the form on an ivory card rising over it; the band shrinks to a thin bar with the lockup when the keyboard opens; on success the fox moves briefly                                                                                  | A's, plus a decorative header (`Mobile/Decor/…`)                                                                                           | Medium: the band must collapse at 360 × 800 and at «Text 130%»; more drawing                                                                                           | Draw, 2026-11-28          |
| C «شاشة واحدة متصلة»              | Number and code on one screen: after the send, the phone field folds into a summary line «+963 9xx… · تعديل» and the code cells slide in under it                                                                                                                                                        | A's, plus a summary row with an edit action                                                                                                | Medium to high: many states on one screen, harder motion and screen-reader focus; the restaurant and captain additions crowd the shared screen                         | Draw, 2026-11-28          |
| D «حسب سبب الدخول» (owner)        | The top section shows why sign-in was asked: the order card at «تأكيد الطلب» (restaurant, item count, total, «طلبك جاهز، بقي تأكيد رقمك»), codes, addresses and favourites together from «حسابي», an order on its way from «طلباتي», the item's own icon elsewhere; read from the device, no server call | A customer header with one variant per entry point; the shared `core_auth` screen gains an optional header slot the other apps leave empty | Four or five header variants, each with new strings; each must shrink with the keyboard, at 360 wide and at «Text 130%»                                                | Draw, 2026-11-28          |
| E «رحلة الدراجة» (owner)          | A simplified map in identity colours with a delivery bike on a route ending at the guest's chosen pin; the bike leaves the restaurant on the phone step, reaches halfway when the code is sent, speeds up on the sixth digit, arrives at the door on success, and pauses with the shake on a wrong code  | An illustrated, animated `Mobile/Decor/Delivery route`; Figma holds its key frames, the motion is made later (Rive or Lottie)              | Highest drawing and motion cost; must stay light on cheap phones; a still frame under reduced motion; the bike faces its direction of travel (rules.md, Right to left) | Draw, 2026-11-28          |
| F «المحادثة مع واتساب» (research) | The code screen is built around the trip to WhatsApp: a bubble like the message the customer will get, from FOX DROP with the code hidden, a «فتح واتساب» button, and «لصق الرمز» offered at once on return when the clipboard holds a code                                                              | A message bubble; it belongs to `core_auth`, since the restaurant and captain codes also come over WhatsApp                                | «فتح واتساب» is not in CU §5.2: it needs the owner's spec change before code                                                                                           | Draw, 2026-11-28          |

**What is drawn** (owner, 2026-11-28): each of the six as its own complete, creative design, not a variant of another (rules.md, Explorations): the phone screen, the code screen, the wrong-code moment and the success moment, on the customer file's «🧪 Explorations» page, one section per direction.

## Choice

Not started (step 4).

| `Draft/…` element | Decision (reuse, extend, new) | Registry match | Layer | Approved |
| ----------------- | ----------------------------- | -------------- | ----- | -------- |

## Figma

Nothing drawn yet. Customer file `FhvOwKGrGEv6p3JnIBHOof`.

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

## Open points

1. **The primary button's contrast exception** (rules.md, Tokens and colour) is judged on a phone outdoors at this flow's approval, since it is the first flow.
2. **`customer.phone_default_country`** is set to SY in the panel before launch; CU §18 item 2's delivery test to Syrian and Turkish numbers still runs.
3. **«فتح واتساب»** (direction F) is not in CU §5.2; if F is chosen, the owner amends the spec before it is coded.
