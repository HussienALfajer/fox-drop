# 7. Availability

> Part of the [captain app spec](README.md) (CA). A bare "§n" here means CA §n.

## 7.1 States

| State | Arabic | Meaning |
|---|---|---|
| Offline | «غير متصل» | No offers, no location tracking |
| Online, available | «متصل متاح» | Can receive offers |
| Busy | «مشغول» | Has an active order. Gets no offers in V1, because there is no order stacking (AP §9.12.6). |
| Last-order mode | «آخر طلب» | Busy, and will go offline after this order (§7.3) |
| Not receiving offers | «لا تصلك عروض» | Online, but at the cash limit or past the hand-in grace (§10.3, §10.4). The reason is shown. |
| Suspended | «موقوف» | Set by OPS, with a reason and an end time if any (AP §9.7.5) |

## 7.2 Going online, and what blocks it

The «متصل» switch on the home screen is refused in these cases. Each shows its reason and the next step:

| Block | Message | Ends when |
|---|---|---|
| Cash from a previous business day (AP §8.5.4) | «لديك نقد غير مسلّم من يوم {التاريخ}: {المبلغ}. سلّمه في المكتب لتتمكن من الاتصال.» with the office hours and a map button | Hand-in at the desk, or a grace from OWN or FIN |
| Cash limit reached (AP §8.5.3) | «بلغت حد العهدة ({المبلغ}). سلّم النقد في المكتب لتصلك العروض.» | Custody below the limit |
| Required document expired (K6) | «انتهت صلاحية {المستند}. ارفع نسخة جديدة من «ملفي».» | The new document is accepted by OPS |
| Suspended | «حسابك موقوف حتى {التاريخ}: {السبب}» with «اعتراض» (§11.3) | The suspension ends or OPS lift it |
| Terms not accepted (K7) | The terms screen | Accepted |
| Version below the minimum | The update screen | Updated |
| Simulated location active | «أوقف تطبيقات تغيير الموقع لتتمكن من الاتصال.» | Turned off |
| Contract ended | «انتهى تعاقدك مع FOX DROP.» | — |

**Already online when a block starts.** A current order always continues to the end.

| Block that starts while online | What happens |
|---|---|
| Cutoff with `closed_due` open | Offers continue for `captain.remit_online_grace_hours` (4) hours, then «لا تصلك عروض» until the hand-in (AP §8.5.4) |
| Cash limit reached | «لا تصلك عروض» until custody drops below the limit |
| Required document expired | «لا تصلك عروض» until the new document is accepted |
| Simulated location detected | «لا تصلك عروض» until it is turned off |
| New terms version, or version below the minimum | Offers continue. The block applies the next time the captain goes online. |
| Suspension, force offline or contract end | Last-order mode (K18): no new offers, tracking continues, offline when the order ends. Without an order, offline at once. |

## 7.3 Last-order mode «لا أريد طلبات جديدة»

- With an active order, the captain cannot go offline (K13). The switch is replaced by «لا أريد طلبات جديدة».
- In this mode no new offers arrive. After the current order ends, the captain goes offline automatically, with the hand-in reminder if they hold cash (§7.5).
- The captain can cancel the mode before the order ends.
- There is no daily limit on this mode in V1.

## 7.4 Automatic offline after unanswered offers (C3)

- After `captain.offer_expiry_offline_count` (3) offers **in a row** expire without an answer, the captain is set offline (K1).
- They get a push and a sound: «لم ترد على 3 عروض متتالية، فأصبحت غير متصل. اضغط «متصل» عندما تكون جاهزاً.»
- The count resets on any accept or reject, and when the captain goes offline.
- Manual offers from operations count too (§8.4). The expired offers still count in the acceptance rate (§11.1).

## 7.5 Going offline, and the hand-in reminder (C13)

- **Going offline** is one tap when there is no active order.
- **Reminder:** if the captain holds custody above `captain.remit_tolerance`, a sheet opens:
  - «عليك تسليم {المبلغ}. المكتب مفتوح حتى {الساعة}.»
  - when the office is closed: «المكتب مغلق الآن، يفتح {اليوم} {الساعة}.»
  - a button opens the office location on the map
- **Office details:** the office hours and location come from the city's office fields in the panel (AP §9.12.1).

## 7.6 Actions by operations

- **Force offline** (AP §9.7.5): the captain goes offline with the reason. With an active order, they enter last-order mode instead: tracking continues and they go offline when the order ends (K18).
- **Suspend:** the state becomes «موقوف» with the reason. An active order continues to the end in last-order mode, then the captain goes offline (K18).
- **Release the device** (AP §9.7.5): the signed-in device is signed out, so the captain can sign in on another phone, including during an order (§4.9).
- **Message:** a direct push from OPS appears as a notification and in «الرسائل» under Support.
