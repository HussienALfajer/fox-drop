# 14. Notifications and sounds

> Part of the [captain app spec](README.md) (CA). A bare "§n" here means CA §n.

| # | Event | Sound | Text |
|---|---|---|---|
| 1 | New offer | Offer ring (§4.4) | «عرض جديد: {الأجر} — {المطعم}» |
| 2 | Offer taken or withdrawn before an answer | Silent | The sheet closes with «لم يعد العرض متاحاً» |
| 3 | Auto-offline after 3 expired offers | Chime | «لم ترد على 3 عروض متتالية، فأصبحت غير متصل…» |
| 4 | Assigned by operations (no offer) | Chime | «عيّنتك العمليات على طلب #{رقم}» |
| 5 | Order ready | Chime | «الطلب #{رقم} جاهز» |
| 6 | Waiting pay started | Silent | Screen update |
| 7 | Pickup confirmed (restaurant, automatic or operations) | Chime | «تم الاستلام — توجّه إلى الزبون» |
| 8 | Pickup disputed or marked incomplete | Chime | §9.4 texts |
| 9 | Pickup dispute after confirmation | Chime | «فتح المطعم بلاغاً عن مبلغ الاستلام…» |
| 10 | Edit by operations | Chime | «تم تعديل الطلب #{رقم}…» |
| 11 | Withdrawn, cancelled or handed over | Cancellation sound | §9.10 texts |
| 12 | Order cancelled while it was still waiting for the restaurant (an early manual assignment) | Cancellation sound | «أُلغي الطلب #{رقم}» |
| 13 | Operations answered «الزبون لا يستجيب» | Chime | «انتظر» or the outcome |
| 13a | The customer answered a ping | Chime | «الزبون رأى التنبيه وهو قادم», or «الزبون يتواصل مع المستلم» for an order with a recipient |
| 14 | Outcome posted with a charge | Silent push | «خُصم من مستحقاتك {المبلغ}: {السبب}» |
| 15 | Cash limit at 80% / 100% | Chime | §10.4 texts |
| 16 | Hand-in reminder (22:00) | Chime | «عليك تسليم {المبلغ} اليوم. المكتب مفتوح حتى {الساعة}.» |
| 17 | Cutoff passed with cash due while online | Chime | «سلّم نقد أمس قبل {الساعة} لتستمر العروض» |
| 18 | Hand-in grace granted | Silent push | «مُنحت مهلة حتى {الساعة}» |
| 19 | Desk receipt (hand-in, reimbursement, payout, deposit) | Silent push | «إيصال {رقم}: {النوع} {المبلغ}» |
| 20 | Weekly statement | Silent push | «كشف الأسبوع جاهز: قبضت {المبلغ}» |
| 21 | Bonus | Silent push | «مكافأة {المبلغ}: {السبب}» |
| 22 | Pay table change announced | Silent push | «جدول أجور جديد يبدأ في {التاريخ}» |
| 23 | Peak window starts | Chime | «مكافأة الذروة الآن…» |
| 24 | Operations announcement or direct message | Chime | The message |
| 25 | Violation recorded | Silent push | «سُجّلت عليك مخالفة: {النوع} — {النتيجة}» |
| 26 | Suspension, reactivation, force offline | Chime | With the reason |
| 27 | Document expiring (30 days) or rejected | Silent push | «تنتهي صلاحية {المستند} في {التاريخ}» / «رُفض {المستند}: {السبب}» |
| 28 | Contract phase change | Silent push | «بدأت {المرحلة} من {التاريخ}» |
| 29 | Application stage change | Silent push | §5.4 texts |
| 30 | Ticket or appeal resolved | Silent push | «تم الرد على بلاغك T-{رقم}» |
| 31 | Emergency stop on or off | Chime | Banner (§6.3) |
| 32 | Signed in on another device | — | The old device shows «سُجّل دخولك من جهاز آخر» |
| 33 | Terms version, forced update, maintenance | Blocking | §4.8, §4.2 |

Notification texts come from Content templates (AP §9.13), so admins can edit them. The texts above are the defaults.
