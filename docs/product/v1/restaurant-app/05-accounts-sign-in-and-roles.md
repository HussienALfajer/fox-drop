# 5. Accounts, sign-in and roles

> Part of the [restaurant app spec](README.md) (RA). A bare "§n" here means RA §n.

## 5.1 Accounts

- A restaurant has one or more owners «مالك» and any number of cashiers «كاشير» (R2).
- The first owner is the owner phone entered in the admin wizard (AP §9.6.3, step 6).
- Further owners are added or removed only by OPS or OWN in the panel, on the restaurant's request (S5). In the app, owners appear read-only with the note «لإضافة مالك أو إزالته تواصل مع FOX DROP».
- Owners add cashiers with a name and phone number, and remove them. Removing a cashier signs out all their devices immediately.
- In V1 a phone number belongs to at most one restaurant (S6, fixed). Adding a phone that already belongs to another restaurant is refused.
- An owner's phone number is changed only from the panel.

## 5.2 Sign-in

1. The user enters their phone number.
2. The server sends a code over WhatsApp, the only channel in V1 (`otp.channel_order`, technology-stack §8.3), with `otp.validity_min` (5), `otp.max_attempts` (5) and `otp.resend_after_sec` (60) (AP Appendix A).
3. If the number belongs to no restaurant: «هذا الرقم غير مسجّل لدى أي مطعم في FOX DROP» with call and WhatsApp buttons for the team. There is no self-signup.
4. If the restaurant's account is `draft`: «حساب مطعمك قيد الإعداد. سنتواصل معك عند جاهزيته.»
5. **First sign-in on a device (app):**
   1. Name the device, for example «كاشير 1» or «تابلت المطبخ».
   2. Run the device check (§4.5). It can be skipped, but the yellow banner stays until it passes.
   3. Owners accept the terms if a version is pending (§4.10).

## 5.3 Sessions and devices

- **App sessions** do not expire with inactivity. A session ends when:
  - the user signs out
  - an owner signs the device out (§14.2)
  - the user is removed
  - an admin forces the restaurant's devices to sign out (AP §9.6.4)
- **Portal sessions** last `merchant.web_session_days` (30) days and end on sign-out (S14).
- **Each device record** holds its name, platform, app version, user and role, ring on or off, last device-check result, connected now or last seen, and signed-in since.

## 5.4 Permissions

The server enforces every permission. The app hides what a role cannot do.

| Capability                                                                                               | Owner (app)      | Cashier (app)                                                | Owner (portal)          |
| -------------------------------------------------------------------------------------------------------- | ---------------- | ------------------------------------------------------------ | ----------------------- |
| Receive, accept and reject new orders                                                                    | Yes              | Yes                                                          | No                      |
| Mark ready, confirm or dispute a pickup, report an item unavailable, acknowledge edits and cancellations | Yes              | Yes                                                          | No                      |
| See live orders                                                                                          | Yes              | Yes                                                          | Read-only               |
| See items and the items value (the pickup payment)                                                       | Yes              | Yes                                                          | Yes                     |
| See commission, restaurant-funded discounts and the net amount                                           | Yes              | No                                                           | Yes                     |
| Order history                                                                                            | Full, with money | Today plus the previous 7 business days, without money (S12) | Full, with money        |
| Call the captain                                                                                         | Yes              | Yes                                                          | No                      |
| Menu availability                                                                                        | Yes              | Yes                                                          | Yes                     |
| Menu prices, items, photos, categories and options                                                       | Yes              | No                                                           | Yes                     |
| Pause, resume and busy mode                                                                              | Yes              | Yes                                                          | Yes                     |
| Hours, holiday close, default prep time, maximum active orders                                           | Yes              | No                                                           | Yes                     |
| Pickup currencies                                                                                        | Yes              | No                                                           | Yes                     |
| Reports                                                                                                  | Yes              | No                                                           | Yes, with Excel export  |
| Account, statements and receipts                                                                         | Yes              | No                                                           | Yes, with PDF and Excel |
| Ratings                                                                                                  | Yes              | No                                                           | Yes                     |
| Staff and devices                                                                                        | Yes              | No                                                           | Yes                     |
| Ring on or off for this device                                                                           | Yes              | No (always on)                                               | —                       |
| Support                                                                                                  | Yes              | Yes                                                          | Yes                     |

## 5.5 Restaurant account status (AP §9.6.1)

| Status       | What the app does                                                                                                                                         |
| ------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `draft`      | Sign-in refused (§5.2)                                                                                                                                    |
| `test`       | Everything works. A blue banner says «وضع تجريبي — مطعمك ظاهر لحسابات الاختبار فقط». Test orders are marked (§8.16).                                      |
| `active`     | Normal                                                                                                                                                    |
| `suspended`  | No new orders arrive. A red banner shows «حساب مطعمك معلّق: {السبب}. تواصل مع فريق العمليات.» Active orders, history, menu, money and support still work. |
| `terminated` | Cashiers cannot sign in. Owners can sign in to the money section only, read-only: statements, receipts and the final balance.                             |
