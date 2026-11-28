# Customer sign-in

The customer app's sign-in: the phone number, the WhatsApp code and, for a new account, «أكمل بياناتك». Spec: CU §5.1–5.5. Code: `packages/core_auth` (one sign-in for the three apps), `apps/server/src/modules/identity`. Figma: «FOX DROP — Customer app», page «🔑 Sign-in».

**Step:** 1, analysis done (2026-11-28). The six screens drawn on 2026-11-28 become «Idea A» on the Explorations page when the directions are drawn.

## Analysis

### Entry points (CU §5.1)

Sign-in is never the first screen: a guest browses, searches, votes for an area and builds a cart without an account. It is asked for when the guest:

- taps «تأكيد الطلب» at checkout (the most important moment);
- opens addresses, «أكوادي», favourites, notifications, a report, or «أبلغ عن سعر مختلف».

«طلباتي» and «حسابي» are tabs: a guest stays in the tab and sees an invitation with «تسجيل الدخول» (owner, 2026-11-24). After sign-in the customer returns where they were: the cart as it was, the filled address kept (saved if «احفظ هذا العنوان» was ticked), and at checkout the quote is refreshed for the account and «تأكيد الطلب» is tapped again.

### Before sign-in: the platform

`GET /v1/customer/platform` (`version`, `latitude`, `longitude`): `updateNeed` (`required`, `suggested`, `none`) with `minVersion` and `updateMessage`; `maintenance` with `maintenanceMessage` and `maintenanceReturnsAt`; `hours` (`open`, `opensAt`). App-wide, not sign-in only.

### Step 1: the phone number (CU §5.2 item 1)

On the device, before any request:

- **Country picker:** searchable by Arabic name, English name or calling code; no flags; «سوريا +963» and «تركيا +90» pinned first, then the last one used, then the rest in Arabic order. Default from `customer.phone_default_country` (SY or TR).
- **The field reads** a national number with or without its leading 0, a number typed or pasted with `+`, `00` or its calling code (which switches the country), and Arabic-Indic digits. It refuses a landline and a number too short or too long, with the fix in its message. Syrian mobiles: 9 digits after +963, starting with 9; Turkish: 10 after +90, starting with 5. Cases tested in `packages/core_auth/test/phone-cases.json`.
- **Strings** (`core_l10n`): `phoneEmpty`, `phoneMissingDigits` (plural), `phoneTooLong`, `phoneLandline`, `phoneNotMobilePrefix`, `phoneUnknownCode`, `phoneSwitchedCountry`, `phoneValid`, `phoneClear`, `countrySheetTitle`, `countrySearch`, `countryPinned`, `countryLastUsed`, `countryAll`, `countryNone`.

`POST /v1/customer/auth/code` `{ phone (E.164), deviceId (uuid) }`, header `X-Firebase-AppCheck` when `otp.app_check_required`. 200: `{ channel: "whatsapp", resendAfterSec, expiresAt }`.

| Error              | Status | Meaning                                                       | String                       |
| ------------------ | ------ | ------------------------------------------------------------- | ---------------------------- |
| `not_on_whatsapp`  | 400    | The number has no WhatsApp; found only when the send is tried | `signInNotOnWhatsapp`        |
| `resend_wait`      | 429    | Asked again before the wait ended                             | `signInResendWait` (seconds) |
| `hourly_limit`     | 429    | More than `otp.number_hourly_max` (3) codes this hour         | `signInTryLater` (minutes)   |
| `ip_limit`         | 429    | More than `otp.ip_hourly_max` (30) requests from one address  | `signInTryLater` (minutes)   |
| `daily_limit`      | 429    | More than the number's or the device's daily limit            | `signInDailyLimit`           |
| `app_check_failed` | 403    | The app failed App Check                                      | none yet                     |
| `unavailable`      | 503    | The WhatsApp sender is down                                   | `signInUnavailable`          |

429 answers carry `retryAfterSec` and a `Retry-After` header. Limits: per number 3 an hour and 6 a day (3 a day outside Syria and Turkey, `otp.number_daily_max_abroad`), per device 6 a day. The operations code («لديّ رمز من العمليات») is for captains and restaurants only; a customer waits for the sender.

The send is not instant: codes go through a queue with 1–4 s of random delay between sends from one WhatsApp number (`otp.send_jitter_sec`), so the request needs a sending state, and `not_on_whatsapp` arrives after that wait.

### Step 2: the code (CU §5.2 item 2)

Six digits over WhatsApp only (no SMS, no call). The screen says «أرسلنا الرمز إلى واتساب على الرقم {الرقم}». The field accepts paste; on Android the app offers to paste a 6-digit code found on the clipboard (SMS auto-fill does not apply to WhatsApp). «إعادة الإرسال» after `resendAfterSec` (`otp.resend_after_sec`, 60). «تعديل الرقم» returns to step 1. Validity `otp.validity_min` (5), attempts `otp.max_attempts` (5).

`POST /v1/customer/auth/sign-in` `{ phone, deviceId, code }`. 200: `{ accountId, newAccount, accessToken, accessTokenExpiresAt, refreshToken }`.

| Error           | Status | Meaning                          | String                       |
| --------------- | ------ | -------------------------------- | ---------------------------- |
| `wrong_code`    | 400    | Wrong code; `attemptsLeft` given | `signInWrongCode` (attempts) |
| `attempts_used` | 400    | All attempts used                | asks for a new code          |
| `code_expired`  | 400    | Older than the validity          | `signInCodeExpired`          |

Other strings: `signInCodeSent`, `signInCodeLabel`, `signInConfirm`, `signInPasteCode`, `signInResend`, `signInResendIn`, `signInEditPhone`, `signInError` (network).

### Step 3: «أكمل بياناتك», new accounts only (CU §5.3)

`GET /v1/customer/profile`: `{ completed, profile | null, phone }`. `PUT /v1/customer/profile`:

| Field         | Rule                                                            |
| ------------- | --------------------------------------------------------------- |
| `firstName`   | Required; 2–30 Arabic or Latin letters, spaces and «-»          |
| `lastName`    | Optional (null); same rule                                      |
| `gender`      | Required: `male` or `female`                                    |
| `birthday`    | Optional (null); a past date; no age check in V1                |
| `acceptTerms` | Required true; «أوافق على الشروط وسياسة الخصوصية» links to both |

`GET /v1/customer/terms`: `{ version, body, publishedAt, pending }`; a later version is accepted with `POST /v1/customer/terms/accept { version }` on the next open, browsing continuing meanwhile. The restaurant sees the first name, the captain first and last name; gender and birthday appear only in the panel. The customer edits them later in «حسابي».

### After sign-in: account state (CU §5.4–5.5)

`GET /v1/customer/account-state`: `reviewStop`; `block { until | null, reason }`; `dues { amount, currency }`; `office { location, landmark, hours }`. Each blocks ordering, never browsing, with the banners of CU §5.5. A closed account signing in again with the same number gets a new account, linked to the closed one. Sessions do not expire with inactivity (refresh tokens), several devices may be signed in, «تسجيل الخروج من كل الأجهزة» is in «حسابي», and a number changes only through support.

### What the data allows in the design

- `retryAfterSec`: an exact countdown instead of «try later».
- `attemptsLeft`: the remaining attempts shown visually.
- `expiresAt`: the code's five minutes can be shown; the current drawing does not.
- `newAccount`: room for a real welcome before «أكمل بياناتك».
- The reason for sign-in (not from the server; the app knows it): «سجّل الدخول لتأكيد طلبك» at checkout instead of a generic welcome.

### States still to design

Sending (the queue's wait), each rate limit with its countdown, the sender down, no network, the code expired, attempts used, the moment between the sixth digit and the answer, success, the welcome for a new account, terms reading, and the account states after sign-in.

## Directions

Not discussed yet. «Idea A» is the drawing of 2026-11-28: an orange hero with the mark inside delivery-radius rings and a dotted route, a generic welcome, and a light brand corner on the following screens.

## Choice

Not made yet.

## Open points

- `app_check_failed` has no customer-facing string yet.
- The API contract documents only the 200 answers of these routes; the error bodies are mapped by hand in `core_auth` (backlog).
- The proposed copy not in the translation files waits for the owner: «أهلاً بك في فوكس دروب», «سجّل برقم هاتفك لتتابع طلبك وتحفظ عناوينك.», «نرسل رمز التحقق عبر واتساب، لا عبر الرسائل النصية», «رمز التحقق», «خطوة أخيرة ونكمل طلبك.», «حفظ ومتابعة».
