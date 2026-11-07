# The whole cycle on staging

The run book of slice 1.14h (`docs/roadmap.md`): one order through its whole cycle on real Android phones in Azaz, then its money checked in the ledger against AP §8.4 (`docs/domain/04-order-money.md`). Owner decisions 2026-11-07: the owner plays every party alone, with three phones and the panel on a computer, in Azaz.

Operating the server (deploys, secrets, the commands below) is in the `deploy` skill; this page only lists what the run needs.

## What the run needs

| What                 | Where                                                                                                                                                                    |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| The panel            | `https://foxdrop-staging-admin.109-199-111-169.sslip.io`, signed in as OWN (password and TOTP)                                                                           |
| The three APKs       | The artifacts `foxdrop-customer-staging-<n>`, `foxdrop-merchant-staging-<n>` and `foxdrop-captain-staging-<n>` of the latest green CI run on `main` (the `deploy` skill) |
| The customer         | Any phone number with WhatsApp; the account is created at the first sign-in                                                                                              |
| The restaurant owner | The demo restaurant «مطعم فوكس التجريبي»'s owner, moved from `+963900000001` to a real number with the server command (the `deploy` skill, «Real numbers…»)              |
| The captain          | «كابتن فوكس التجريبي» (motorbike, cash limit 3000 TRY), moved from `+963900000003` to a real number the same way; or signed in with an emergency code from the panel     |
| Three phones         | Android with Google Play services (App Check is on), location on, in Azaz. Each staging app on its own phone: the captain and the restaurant must ring and stay in front |

The placeholder values on staging (`TASKS.md`): base currency TRY with a rounding unit of 5 TRY, a flat delivery fee of 40 TRY, a 15% commission, a minimum order of 100 TRY, captain pay of 25 TRY including the first 3 km plus 5 TRY per extra km, no waiting pay, manual dispatch (`dispatch.mode` `manual`), and the demo restaurant open 10:00–02:00 every day.

## Where to stand

- The demo restaurant is at **36.5866, 37.0463** (near Azaz's centre). The captain's phone must be within **150 m** of it to press «وصلت إلى المطعم» (`captain.merchant_arrival_radius_m`), with a position better than 100 m.
- The customer's delivery point is where the customer's phone is when ordering; it must be inside the zone «أعزاز» (36.57–36.605 N, 37.025–37.07 E) and within the restaurant's 3 km.
- The captain must be online within 3 km of the restaurant before the order is placed: the quote refuses an order with no captain nearby (`dispatch.capacity_check`, `no_captain_nearby`).
- The captain's phone must be within **200 m** of the delivery point at «وصلت» and «تم التسليم» (`captain.customer_radius_m`), or the app asks for a reason.

The short run: place the order from beside the restaurant and deliver there (distance under 3 km, pay 25 TRY). The full run: place the order from another spot in the zone, carry the captain's phone to the restaurant, then back to that spot.

## Before the run

1. **`main` is deployed:** the latest CI run on `main` is green, including `deploy-staging` and the three `staging-apks` jobs. Its commit is the one in `readlink /srv/foxdrop-staging/current` on the server.
2. **The APKs are installed** from that run (uninstall an older staging app first if Android refuses the update).
3. **The real numbers are set** for the restaurant owner and the captain (once; the `deploy` skill).
4. **The time:** run the cycle between 10:00 and 02:00 (the restaurant's hours) and in one business day: the cash desk is not built yet, so after the next cutoff the captain cannot go online again while the cycle's custody is unhanded (AP §8.5.4).

## The cycle

Each step says who acts, what to press, and what the other parties should see. Write down anything that differs, with the time and a screenshot: each one becomes a fix.

| #   | Who        | Action                                                                                                                                 | What the others should see                                                                                                     |
| --- | ---------- | -------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| 1   | Panel      | Sign in as OWN; open «غرفة العمليات» and pick the city «أعزاز»                                                                         | The board, empty or with older orders                                                                                          |
| 2   | Restaurant | Sign in with the WhatsApp code; the board opens                                                                                        | —                                                                                                                              |
| 3   | Captain    | Sign in (WhatsApp code, or «لديّ رمز من العمليات» with a code from the panel's «رمز دخول طارئ»); allow the location; turn on «متصل»    | The permanent notification «أنت متصل — FOX DROP يتابع موقعك لتصلك العروض»                                                      |
| 4   | Customer   | Sign in; complete the account («أكمل بياناتك»); allow the location; open «مطعم فوكس التجريبي»; add «شاورما دجاج» (120 TRY, size «وسط») | —                                                                                                                              |
| 5   | Customer   | Open the cart and checkout: items 120, delivery 40, total **160 TRY**; «سأدفع بـ» TRY; place the order                                 | Restaurant: the order rings. Panel: the order «بانتظار المطعم» with «بلا كابتن»                                                |
| 6   | Restaurant | Accept with the prep time (20 minutes)                                                                                                 | Customer: «المطعم يحضّر طلبك» and «يصل حوالي». Panel: «قيد التحضير»                                                            |
| 7   | Panel      | Open the order; «تعيين كابتن»; pick «كابتن فوكس التجريبي»                                                                              | Captain: the offer rings for 45 seconds, with the pickup payment **120 TRY**                                                   |
| 8   | Captain    | Accept the offer                                                                                                                       | Panel: the captain on the order. Customer: the captain on the order                                                            |
| 9   | Captain    | At the restaurant (within 150 m): «وصلت إلى المطعم»                                                                                    | Restaurant: «وصل الكابتن — ينتظر منذ … د»                                                                                      |
| 10  | Restaurant | «الطلب جاهز»                                                                                                                           | Captain: the ready chime                                                                                                       |
| 11  | Captain    | Check the items; request the pickup with **120 TRY** paid                                                                              | Restaurant: «الكابتن يطلب تأكيد الاستلام», with one minute to confirm                                                          |
| 12  | Restaurant | Confirm the pickup (or wait a minute for «تأكيد تلقائي»)                                                                               | Captain: the pickup confirmed. Customer: «في الطريق إليك». Panel: the order moves on                                           |
| 13  | Captain    | At the delivery point: «وصلت»                                                                                                          | Customer: «الكابتن عند الباب»                                                                                                  |
| 14  | Captain    | The door payment: received **200 TRY**, change **40 TRY**; «تم التسليم»                                                                | Captain: the summary (pay 25 TRY, «عليك تسليم اليوم: 40 ₺»). Customer: «تم التسليم». Restaurant and panel: the order delivered |
| 15  | Captain    | Go offline                                                                                                                             | Captain: the hand-in reminder for 40 TRY                                                                                       |

The order's number shows in the panel and the apps (from 10001). Keep it for the ledger check.

## The ledger check (AP §8.4)

For the delivered order above, AP §8.4 gives:

| Line                                      | Amount  | Ledger (platform's side, minor units)                              |
| ----------------------------------------- | ------- | ------------------------------------------------------------------ |
| Customer pays the captain                 | 160 TRY | `custody.collect` +20000, `custody.change_given` −4000 (net 16000) |
| Captain pays the restaurant (items value) | 120 TRY | `custody.pay_merchant` −12000                                      |
| Custody gained (`custody_delta`)          | +40 TRY | `captain.custody` sums to +4000                                    |
| Delivery fee                              | 40 TRY  | `platform.revenue_delivery` −4000                                  |
| Commission 15%                            | 18 TRY  | `merchant.account` +1800, `platform.revenue_commission` −1800      |
| Captain pay                               | 25 TRY  | `captain.earnings` −2500, `platform.captain_pay` +2500             |
| Order clearing account                    | 0       | `platform.order_clearing` sums to 0                                |
| Platform margin (commission + fee − pay)  | 33 TRY  | −(revenue + pay cost + rounding) = 3300                            |

The script `infra/server/check-order-ledger.sql` checks these lines for any delivered order, from the order's own values (so a different item, distance or payment still checks), and lists every entry. As root on the server, with the order's number:

```bash
docker exec -i foxdrop-staging-postgres-1 psql -U postgres -d fox_drop -v number=10001 < /srv/foxdrop-staging/current/infra/server/check-order-ledger.sql
```

Every line must read `ok`. A `MISMATCH` is a finding: keep the script's whole output with the finding.

## After the run

- Send Claude the findings: the step, what was expected, what showed, the time and the screenshot. Each becomes its own `fix/` pull request with its test first (owner decision 2026-11-07).
- The custody of 40 TRY stays on the demo captain until the cash desk exists (AP §9.10.3).
