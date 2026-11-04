# 5. Account

> Part of the [customer app spec](README.md) (CU). A bare "§n" here means CU §n.

## 5.1 Guest browsing (U2, Q1)

- **A guest can:**
  - choose a location and see the restaurants that deliver there
  - open restaurant pages and menus, with prices, fees and estimates
  - search
  - vote for an area outside the zones (§7.2)
  - build a cart
- **At checkout** a guest fills the address form for the selected point as an unsaved address (§7.4), and sees the full quote. The code field shows «سجّل الدخول لاستخدام الأكواد».
- **Sign-in is asked for** when the guest:
  - taps «تأكيد الطلب» at checkout (U2)
  - or opens «طلباتي», addresses, «أكوادي», favourites, notifications, a report, or «أبلغ عن سعر مختلف»
- **After sign-in** the customer returns to where they were:
  - the cart stays as it was
  - the address they filled is kept, and saved if they ticked «احفظ هذا العنوان»
  - at checkout, the quote is refreshed for the account. The customer sees any change, such as the active-order limit or an account block, and taps «تأكيد الطلب» again (Q10)

## 5.2 Sign-in (U3, Q4)

1. **Phone number:**
   - A country picker offers «سوريا +963» and «تركيا +90». The default is `customer.phone_default_country`.
   - Syrian mobiles have 9 digits after +963 and start with 9. The app accepts `09xxxxxxxx` and `9xxxxxxxx`.
   - Turkish mobiles have 10 digits after +90 and start with 5. The app accepts `05xxxxxxxxx` and `5xxxxxxxxx`.
   - The number is stored in E.164 format.
2. **Code:**
   - 6 digits (fixed), sent over WhatsApp, the only channel in V1 (`otp.channel_order`, technology-stack §8.3). There is no SMS or voice code.
   - A number without WhatsApp gets «هذا الرقم غير مسجّل على واتساب» and no code is sent.
   - The screen says where the code was sent: «أرسلنا الرمز إلى واتساب على الرقم {الرقم}».
   - After `otp.resend_after_sec` (60) seconds, it offers «إعادة الإرسال».
   - Validity and attempts follow `otp.validity_min` and `otp.max_attempts`. The server limits requests per number, per device and per IP address (AP Appendix A, `otp.*`). Past the daily limit: «تجاوزت عدد المحاولات المسموح، حاول غداً أو تواصل مع الدعم».
   - The code field accepts paste. On Android the app offers to paste a 6-digit code it finds on the clipboard. SMS auto-fill does not apply to WhatsApp messages.
   - «تعديل الرقم» goes back to step 1.
3. **Existing account:** signed in, and back to where the customer was.
4. **New account:** the details screen (§5.3).

## 5.3 New account details (U4, Q2)

One screen, «أكمل بياناتك»:

| Field | Rule |
|---|---|
| «الاسم» first name | Required. 2 to 30 Arabic or Latin letters, with spaces and «-» |
| «الكنية» last name | Optional. Same rule |
| «الجنس» gender | Required: «ذكر» or «أنثى» |
| «تاريخ الميلاد» birthday | Optional. A past date from a date picker. No age check in V1 |
| Terms | Required checkbox: «أوافق على الشروط وسياسة الخصوصية», with links to both (AP §9.13) |

- **Who sees what (Q2):**
  - The restaurant sees the first name (RA §8.4).
  - The captain sees the first and last name, or the recipient's name (Q5).
  - Gender and birthday appear only in the admin panel (AP §9.8). They feed the customer report (AP §9.17), and birthday offers come in V4.
- The customer can edit these fields later in «حسابي» (§13).

## 5.4 Sessions and devices (Q3)

- A session lasts until sign-out. It uses refresh tokens and does not expire with inactivity.
- A customer may be signed in on several devices. Order pushes and the door ping reach every signed-in device.
- Blocking or closing an account in the panel applies at once on every device.
- **Phone number changes:** «لتغيير رقمك تواصل مع الدعم». OPS change it in the panel (AP §9.8 «تغيير الرقم»). Every session ends, and the customer signs in again with the new number.
- **Lost or sold phone:** «تسجيل الخروج من كل الأجهزة» in «حسابي» (§13), or support does it from the panel (AP §9.8). Active orders are not affected.

## 5.5 Account states (AP §8.8, Q21)

| State | What the app shows | Browse | Order |
|---|---|---|---|
| Active, at the active-order limit (D23) | At checkout: «يمكنك طلب واحد في كل مرة حتى يكتمل طلبك الحالي» for a new account, or «وصلت إلى الحد الأقصى للطلبات الجارية» for a trusted one | Yes | Not until an active order ends |
| «موقوف حتى مراجعة الدعم» (review stop) | Banner: «حسابك موقوف حتى مراجعة فريق الدعم», with call and WhatsApp buttons | Yes | No |
| «محظور» for a duration | Banner: «حسابك محظور حتى {التاريخ}: {السبب}» | Yes | No |
| «محظور» until further notice | Banner: «حسابك محظور: {السبب}. تواصل مع الدعم.» | Yes | No |
| «محظور» until dues are paid | Banner: «عليك {المبلغ} لـ FOX DROP. ادفعه في المكتب ليُفك الحظر تلقائياً.» A sheet shows the office location on a map and its hours (AP §9.12.1) | Yes | No |
| «مغلق» (closed) | Signed out on every device. Signing in again with the same number creates a new account, linked to the closed one (AP §8.8) | — | — |

- The customer-facing reason comes from the block reason list (AP Appendix B), mapped in Appendix C.
- Trust itself, «موثوق», is not shown to the customer. Only its effect on the limit is shown.

## 5.6 Closing the account (AP D19, Q20)

1. «حسابي» → «حذف الحساب».
2. An explanation:
   - you will not be able to sign in
   - your codes and favourites will be lost
   - your data is handled as the privacy policy says (AP §13 item 6)
3. A fresh code sent to the phone (Q20).
4. The account becomes «مغلق», and the app signs out on every device.

- **Not possible with an active order:** «لا يمكن حذف الحساب أثناء وجود طلب جارٍ». Admins cannot close it during an active order either (AP §8.8).
- **Unpaid dues** do not prevent closing. They carry over to any new account on the same number (AP §8.8).
