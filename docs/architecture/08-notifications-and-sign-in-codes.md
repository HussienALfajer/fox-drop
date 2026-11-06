# 8. Notifications and sign-in codes

> Part of the [technology stack](README.md). A bare "§n" here means §n of the technology stack.

## 8.1 Push

- **Firebase Cloud Messaging** for Android and for iOS (through APNs). One Firebase project per environment (development, staging, production).
- Message types: high priority for new orders, pickup requests, offers, cancellations and arrival (RA §4.3, CA §4.4, CU §4.3); normal for the rest; time-sensitive on iOS where the specs say so.
- Sending runs in the `worker` from the outbox, with retries and removal of invalid tokens.
- Apply to Apple for the **Critical Alerts** entitlement for the captain app (CA §4.4, CA §18 item 2).

## 8.2 In-app sounds

Ring, chime and silent levels are played by the apps themselves (RA §4.4, CA §4.4), not by the push payload. Push only wakes the app or shows a notification when the app cannot run.

## 8.3 Sign-in codes over WhatsApp (T4, T5)

### 8.3.1 The channel abstraction

- The `identity` module asks a **`CodeSender` port** to deliver a code. V1 has one adapter: `WhatsAppLibrarySender`.
- The adapter runs in the separate `otp-sender` process (§4.4). The API puts a send request on a queue and waits for the sender's short answer within a timeout, so the app still hears «هذا الرقم غير مسجّل على واتساب» (owner decision 2026-11-06); it never loads the library. No answer in time means no code was sent.
- **Library:** the chosen third-party WhatsApp library. The default candidate for a Node.js server is **Baileys** (WhatsApp multi-device protocol, no browser needed). The adapter hides it completely, so it can be replaced by another library, by the official WhatsApp Cloud API, or by an SMS adapter later, with no change in the apps.
- `otp.channel_order` stays a setting, with `whatsapp` as its only value in V1. SMS and voice are reserved for later (T5).

### 8.3.2 The code itself (MUST)

- 6 digits (fixed, CU §5.2), generated with a cryptographic random generator.
- Stored only as a hash with the number, the device and the expiry (an emergency code has no device, §8.3.5). Compared in constant time.
- One active code per number: a new request replaces the old code.
- Validity `otp.validity_min` (5), attempts `otp.max_attempts` (5), resend wait `otp.resend_after_sec` (60) (AP Appendix A).
- The response to "send a code" is the same whether the number has an account or not, except where a spec shows a specific message (RA §5.2 items 3–4).

### 8.3.3 Protection against banning the sending numbers

WhatsApp bans numbers that send many messages to people who did not expect them, that get reported or blocked, or that behave like automation. The design below keeps the sending numbers' behaviour close to a normal business account and stops abuse before it reaches WhatsApp.

**A. Only real users can trigger a message**

1. **App integrity:** a code request MUST carry a valid **Firebase App Check** token (Play Integrity on Android, App Attest on iOS; the Windows app uses its device registration). Requests from scripts and modified apps are refused before any message is sent. This stops the main cause of bans: mass requests to random numbers. Owner decisions 2026-11-06 and 2026-11-07: the server verifies now and the apps add the token with slice 1.14, so the check stays behind the global setting `otp.app_check_required` (OWN, off) until then. The token travels in the `X-Firebase-AppCheck` header; a missing or invalid one answers `403 app_check_failed` after the IP limit of item 2 counts the request, so a script without a token still runs into it. The server checks the token against Firebase's public keys with the project number from its environment, holding no service-account secret; a token can therefore be replayed until it expires (one hour by default), within the limits of item 2, since Firebase's replay protection needs that secret. The restaurant app on Windows, which App Check does not cover, declares its platform and is exempt until its device registration exists; the limits of item 2 remain its guard.
2. **Requester limits** (server side, in Valkey):
   - per phone number: `otp.number_hourly_max` (3) and `otp.number_daily_max` (6)
   - per device: `otp.device_daily_max` (6)
   - per IP address: `otp.ip_hourly_max` (30)
   - the resend wait (60 s) between two codes to the same number
   - after the daily limit: «تجاوزت عدد المحاولات المسموح، حاول غداً أو تواصل مع الدعم»
3. **The number must be on WhatsApp:** before sending, the sender checks that the number has a WhatsApp account (cached for 30 days). If it does not, nothing is sent and the app shows «هذا الرقم غير مسجّل على واتساب». Messages to numbers without WhatsApp are a strong ban signal.

**B. The sending numbers behave like a business**

4. **Dedicated numbers:** two or more numbers owned by FOX DROP, used only for sign-in codes. Never a personal number, never the support number, never used for marketing or mass push (AP §9.11.4 uses push, not WhatsApp).
5. **Business profile complete** on every number: name «FOX DROP», logo, description, website.
6. **Warm-up:** a new number starts with a low daily cap that rises over two weeks (`otp.sender_warmup_caps`, default 50 → 100 → 200 → 400 → 800 → full). Owner decision 2026-11-06: each step lasts `otp.sender_warmup_step_days` (3), so the number is `active` after 15 days; while `warming` it sends real codes within its step's cap, only when no `active` number can.
7. **Pacing:** each number sends at most `otp.sender_per_minute_max` (12) and `otp.sender_daily_max` (1500) messages, with a random delay of `otp.send_jitter_sec` (1–4) seconds between sends. A short queue absorbs peaks.
8. **One short, fixed message.** No links, no marketing, the same structure every time, chosen from a few approved wordings in Content (AP §9.13), for example:
   «رمز الدخول إلى FOX DROP: 482913
   لا تشارك هذا الرمز مع أحد. إن لم تطلبه فتجاهل هذه الرسالة.»
9. **Replies are answered:** when someone writes to a sending number, it answers once with a fixed message pointing to the support WhatsApp number. Unanswered conversations and confused users lead to reports.
10. **Stable server:** the sessions run from a fixed server IP in one region. Session credentials are stored encrypted in PostgreSQL, so a restart does not force a new pairing.

**C. Failover and monitoring**

11. **Sender pool:** each number has a state: `warming`, `active`, `standby`, `throttled`, `disconnected` or `banned`. Sending uses the active numbers in rotation. If a number disconnects, is throttled or is banned, sending moves to the next number at once.
12. **Health signals** recorded per number: sent, delivered, read, failed, blocks and reports where the library exposes them. A rising failure rate throttles the number automatically.
13. **Panel screen «أرقام إرسال الرموز»** (OWN, in Settings, AP §9.14): add a number and pair it by scanning a QR code, see its state and daily counts, set it active or standby, disable it.
14. **Alerts** (AP §9.1.3):
    - «رقم إرسال الرموز متوقف» (Warning, OWN): one number is disconnected, throttled or banned.
    - «لا يمكن إرسال رموز الدخول» (Critical, OWN and OPS): no active or warming number can send.
    - Owner decision 2026-11-06: until the panel's alerts feed exists, both show in the read of «أرقام إرسال الرموز» and go to Sentry. A number throttles when 30% or more of its last 20 sends (at least 10) failed, for 60 minutes (item 12).

**D. Fewer codes overall**

15. Sessions are long, so codes are rare: customer and captain sessions do not expire with inactivity (CU §5.4, CA §4.9), restaurant app sessions likewise (RA §5.3).
16. Opening the app never asks for a code again. A code is needed only for a new device or after a sign-out.

**What this cannot guarantee.** A third-party library uses an unofficial interface; WhatsApp may still restrict or ban a number, and its terms do not allow automated sending outside its official Business Platform. With WhatsApp as the only channel, a full outage means no **new** sign-ins until a number works again; existing sessions continue. The long-term fix is the official WhatsApp Cloud API with authentication templates, or an SMS provider as a second channel. Both plug into the `CodeSender` port (§8.3.1). See §22.

### 8.3.4 In the apps

- The screen says where the code was sent: «أرسلنا الرمز إلى واتساب على الرقم {الرقم}» (CU §5.2).
- After the resend wait, only «إعادة الإرسال» and «تعديل الرقم» are offered. There is no SMS or voice option in V1.
- SMS auto-fill does not apply to WhatsApp messages. The code field accepts paste, and on Android the app offers to paste a 6-digit code it finds on the clipboard.

### 8.3.5 Emergency sign-in (owner decisions 2026-11-07)

When no code reaches a captain or a restaurant user (every sending number stopped, or one person's code lost), operations sign them in by phone:

- OWN or OPS (AP §6.3, `sign_in.emergency_code`) verify the person by a phone call and issue a code for the app (captain or restaurant) and the number, with a required reason. The number must belong to an account that may sign in.
- The code is 6 digits like any other, shown once to the issuer, who reads it out. It is valid 10 minutes (fixed), used once, ends after `otp.max_attempts` wrong attempts, and replaces the number's open code.
- It is bound to the number, not to a device: the person types it in the app's usual code screen and the first device that enters it signs in. The sign-in then runs as for a WhatsApp code (the account checks, one device for a captain).
- The issue is audited with the issuer, the account and the reason, never the code or the number.
- Customers are not covered: they wait for the channel to return (§22 item 1).
- The apps must let the person reach the code screen when the code request fails (§8.3.4); the panel screen waits for the design.
