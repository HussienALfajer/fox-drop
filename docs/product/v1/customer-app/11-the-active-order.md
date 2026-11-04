# 11. The active order

> Part of the [customer app spec](README.md) (CU). A bare "§n" here means CU §n.

## 11.1 Order screen

- **Top:**
  - the status title and subtitle (§11.2)
  - a five-step progress bar: «تأكيد المطعم» · «التحضير» · «في الطريق» · «عند الباب» · «التسليم»
- **Time:** the estimate range while `placed`, then «يصل حوالي {الساعة}» (§8.4).
- **Captain card:** from assignment (§11.3).
- **Map:** from pickup (§11.3).
- **Banners:** emergency delay, item unavailable, edited order, late apology (§11.6).
- **Summary:**
  - the restaurant
  - the items with options and notes
  - the address
  - the total, with its equivalents
  - the pay-in currency, when chosen
- **Buttons:**
  - «مساعدة» (§11.5)
  - «إلغاء الطلب», while `placed` only (§11.4)

## 11.2 Statuses and texts

The labels follow the "What the customer sees" column of AP §8.1. The order screen also shows the captain's progress, and the captain's own track (AP §8.2) is never shown as such.

| Moment | Title | Subtitle | Push |
|---|---|---|---|
| `placed` | «بانتظار تأكيد المطعم» | «أرسلنا طلبك إلى {المطعم}» | — |
| `accepted` | «المطعم يحضّر طلبك» | «يصل حوالي {الساعة}» | Yes |
| Captain assigned (before pickup) | Unchanged | «الكابتن {الاسم} في طريقه إلى المطعم» | Yes |
| Captain at the restaurant | Unchanged | «الكابتن {الاسم} وصل إلى المطعم» | — |
| `ready` | «طلبك جاهز» | «ينتظر الكابتن», or «الكابتن يستلم طلبك الآن» when the captain is there | — |
| `picked_up` | «في الطريق إليك» | «الكابتن {الاسم} استلم طلبك» | Yes |
| `arrived` | «الكابتن عند الباب» | «جهّز {المبلغ}» | Yes, high priority |
| `delivered` | «تم التسليم» | «بالعافية!» | Yes |
| `rejected`, `cancelled`, `failed` | §11.9 | §11.9 | Yes |

- **Pickup request:** while the captain's pickup request is pending (`pickup_pending`), the customer still sees the restaurant step.
- **Reassignment before pickup:** the captain card changes to the new captain with «تغيّر الكابتن: {الاسم} في طريقه إلى المطعم».
- **Handover after pickup** (AP §9.3.2): the card changes with «تغيّر الكابتن: {الاسم} يكمل توصيل طلبك». The map follows the new captain from their receipt.
- **A free re-delivery order** (AP §9.9.3) appears as its own order, «إعادة توصيل مجانية لطلب #{رقم}», with a total of 0 and the same screens. It goes to the original order's address. The customer cannot cancel or rate it, and it does not count toward the active-order limit or trust.

## 11.3 The captain and the map (U12, Q14)

- **Captain card (Q14):** from assignment, the captain's first name, photo and vehicle type («دراجة نارية», «سيارة», «دراجة» or «سيراً على الأقدام»).
- **Map:** from `picked_up` until the order ends (U12).
  - It shows the captain's live position, the delivery pin and, when the routing service is available, the route line.
  - Before pickup there is no map, only the text steps.
- **«اتصال بالكابتن»:** from `picked_up` until the order ends (U12).
  - It opens the phone's dialer with the captain's number. The app never prints the number.
  - The customer sees the number on the call screen; this is accepted in V1 (U12).
  - Each tap is recorded in the order timeline (AP §9.3.1).
  - The button disappears when the order ends.

## 11.4 Cancelling (AP §8.3, Q12)

- **While `placed`:**
  1. «إلغاء الطلب».
  2. A reason from the self-cancel list (AP Appendix B), with optional text for «سبب آخر».
  3. «نعم، ألغِ الطلب».

  The order becomes `cancelled`. The restaurant's prompt closes (RA §8.3). There is no strike.
- **Race with acceptance:** if the restaurant accepted in the meantime, the server refuses: «قبل المطعم طلبك قبل لحظات. لإلغائه تواصل مع الدعم.»
- **After acceptance:**
  - The cancel button is replaced, inside «مساعدة», by «لإلغاء الطلب تواصل مع الدعم».
  - The sheet warns: «الإلغاء بعد قبول المطعم يُحتسب عليك، وتكراره قد يوقف حسابك مؤقتاً.»
  - Support cancels in the panel (AP §9.3.2), and the late-cancellation strike applies when the customer is responsible (AP §8.8).

## 11.5 Help during an order (U16)

«مساعدة» opens a sheet with:

- «اتصال بالدعم» (call support)
- «واتساب الدعم» (WhatsApp support), with the message prefilled: «بخصوص الطلب #{رقم}»
- «الأسئلة الشائعة» (FAQ)
- «تريد تغيير العنوان؟», which explains U13 (§11.10)
- «إلغاء الطلب» while `placed`, or the explanation in §11.4 after that

Support's numbers come from Content (AP §9.13). There is no in-app ticket during an active order; support staff open a manual ticket when needed (AP §9.9.1).

## 11.6 Changes by the restaurant or operations (Q13)

| Change | What the customer sees |
|---|---|
| Item unavailable after acceptance (RA §8.12) | A push with sound and a banner: «المطعم أبلغ أن صنفاً في طلبك غير متوفر. سيتصل بك فريق FOX DROP الآن.» The banner clears when operations edit or cancel the order or close the report, or when the restaurant withdraws the report (RA §8.12). |
| Edit by operations (AP §9.3.3) | A push: «عدّلت FOX DROP طلبك. المجموع الجديد: {المبلغ}». The summary marks added items «أُضيف», strikes removed items «حُذف», shows quantity changes, and shows the new total. No approval is asked in the app, because operations agree it by phone. |
| Prep or promised time changed | «تغيّر موعد وصول طلبك إلى {الساعة}» |
| Late, 20 minutes past the promised time (AP §8.3) | A push and a banner: «نعتذر، طلبك متأخر قليلاً. نتابعه الآن.» |
| Late, 45 minutes past the promised time | A push: «تأخر طلبك، وهذا كود خصم {القيمة} لطلبك القادم: {الكود}». The code is in «أكوادي». |
| Emergency stop | A push and a banner with the delay notice (AP §9.1.6) |
| Outcome with an amount to collect (AP §9.3.2 «تحديد النتيجة») | The order screen updates the amount: «المبلغ المطلوب الآن: {المبلغ}», or «لن تدفع شيئاً لهذا الطلب» |

## 11.7 The captain at the door (Q15)

- **Arrival:** a high-priority push, «الكابتن عند الباب», time-sensitive on iPhone. The order screen shows the amount due large, with its equivalents.
- **The captain calls** the address's contact phone (CA §9.5). When the order is for someone else, the recipient gets the call.
- **The door ping** («تنبيه الزبون», up to `customer.no_answer_pings` (3) times, CA §9.9) reaches every signed-in device of the account:
  - **App open:** a full-screen alert that rings for 30 seconds (fixed): «الكابتن عند الباب ويحاول الوصول إليك», with «أنا قادم» and «اتصال بالكابتن».
  - **App closed:** a push with sound, time-sensitive on iPhone.
- **«أنا قادم»** sends a reply. The captain sees «الزبون رأى التنبيه وهو قادم» (CA §9.9). The reply does not stop the captain's no-answer timer.
- **An order for someone else** (Q5): the arrival push says «الكابتن عند باب {المستلم}. المبلغ المطلوب {المبلغ}». The ping alert says «الكابتن عند الباب ويحاول الوصول إلى {المستلم}», and its reply button is «سأتصل بالمستلم», which the captain sees as «الزبون يتواصل مع المستلم».

## 11.8 Delivery and payment (Q23)

- **Paying:** the customer pays the captain the total in cash, in one or more accepted currencies. The captain gives change and records both (CA §9.7).
- **After «تم التسليم»:** the order screen shows «تم التسليم» and opens the rating sheet (§12.1).
- **Order detail (Q23)** shows what the captain recorded: «استلم الكابتن: {المبالغ}» and «أعاد لك: {المبالغ}».
- **If the record is wrong**, the customer reports «مشكلة في المبلغ أو الباقي» within 24 hours (§12.2). When the customer got less change than recorded, they get the difference back as a code or in person through the captain (AP §8.10).
- **A collection shortfall** that OPS charge to the customer becomes dues of the missing amount only, with a block until it is paid, and no strike (AP §8.6 and AP §8.8). The customer then sees the dues banner (§5.5).

## 11.9 Orders that do not complete (Q22)

| Case | What the customer sees |
|---|---|
| Rejected by the restaurant (RA §8.6) | «نعتذر، لم يقبل المطعم طلبك», with the customer-facing reason (Appendix C), and up to 5 similar restaurants: open, same category, delivering to the pin. For «صنف غير متوفر», also «اطلب بدون الأصناف غير المتوفرة», which rebuilds the cart without those items (Q22). |
| Cancelled for no restaurant response (AP §8.3) | «لم يرد المطعم على طلبك، نعتذر», with similar restaurants |
| Cancelled by operations | «أُلغي طلبك», with the customer-facing reason (Appendix C), and the compensation code when one was given |
| Cancelled by the customer | «ألغيت طلبك» |
| Failed after pickup (AP §8.9) | «تعذّر التسليم», with the reason. For a `fake` outcome, the dues banner applies (§5.5). |
| Delivered as `free`, or `damaged` with a reduction | «تم التسليم», with «لم تدفع شيئاً لهذا الطلب» or the reduced amount |

- The cart was emptied when the order was placed (§10.7). «اطلب بدون الأصناف غير المتوفرة» and «اطلب مرة أخرى» (§12.3) rebuild it, and ask first when the current cart is not empty.
- A code used on a rejected, cancelled or failed order comes back when the customer was not at fault (§10.4).

## 11.10 Changing the address after ordering (U13)

- There is no edit in the app.
- **Before pickup:**
  - a small change: the customer calls support, who tells the captain. The captain delivers to the new place.
  - a large change: operations cancel the order (AP §9.3.2), and the customer orders again. After acceptance this is a cancellation at the customer's request, so the late-cancellation rule applies (AP §8.8).
- **After pickup** (Q24): the order cannot be cancelled. The customer calls the captain or support.
  - If the new place is inside an active zone and operations agree, the captain delivers there. The amounts do not change. OWN or FIN MAY add a bonus for the captain's extra distance (AP §8.5.2).
  - Otherwise the order goes to the original address.
- In every case the captain records «الزبون طلب مكاناً آخر» (CA §9.6).
- The help sheet explains this (§11.5).
