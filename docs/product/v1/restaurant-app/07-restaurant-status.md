# 7. Restaurant status

> Part of the [restaurant app spec](README.md) (RA). A bare "§n" here means RA §n.

## 7.1 States

| State                      | Arabic (restaurant)   | Set by                                                                                                  | Customers                                                                                            | Ends                                                                                               |
| -------------------------- | --------------------- | ------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| Open                       | «مفتوح»               | The schedule (§10)                                                                                      | Can order                                                                                            | Schedule close, a pause, a holiday close, the limit, suspension                                    |
| Busy mode (a flag on Open) | «وضع الضغط +{د} د»    | MO, MC                                                                                                  | Can order; the time they see is longer by 10 or 20 minutes                                           | Turned off by MO, MC or OPS, or at the end of the current opening period (S3)                      |
| Busy (limit reached)       | «مشغول»               | The system, when active orders reach the limit (§7.4)                                                   | Cannot order: «المطعم مشغول حالياً، جرّب بعد قليل»                                                   | Automatically, when active orders drop below the limit                                             |
| Paused by the restaurant   | «موقوف مؤقتاً»        | MO, MC                                                                                                  | Cannot order: «المطعم متوقف مؤقتاً، يعود خلال {المدة}», or «… يعود قريباً» when there is no end time | Timer expiry, MO/MC/OPS resume, or for «حتى أعيد الفتح» the end of the current opening period (S3) |
| Paused by operations       | «أوقفته العمليات»     | OPS, OWN (AP §9.6.5)                                                                                    | Same as paused                                                                                       | Expiry of a timed pause, or OPS/OWN. The restaurant cannot end it (S4).                            |
| Auto-paused                | «أُوقف تلقائياً»      | The system, after `merchant.auto_pause_unanswered_count` (3) unanswered orders in a business day (§8.3) | Same as paused                                                                                       | OPS or OWN only. It holds across opening periods.                                                  |
| Closed by schedule         | «مغلق»                | The schedule                                                                                            | «مغلق — يفتح {اليوم} {الساعة}»                                                                       | The next opening period                                                                            |
| Holiday close              | «إجازة حتى {التاريخ}» | MO, OPS, OWN                                                                                            | «مغلق حتى {التاريخ}» plus the restaurant's message                                                   | The end date, or MO/OPS/OWN ends it                                                                |
| Suspended                  | «معلّق»               | OPS, OWN                                                                                                | The restaurant is hidden                                                                             | OPS or OWN                                                                                         |

- **Precedence:** suspended → holiday close → closed by schedule → paused (any source) → busy (limit) → open. The first one that applies is the state. Busy mode is a flag that matters only while the restaurant is open.
- **Pauses have no effect on active orders.** Orders already placed still need an answer, and orders in progress continue.
- **One pause at a time.** An operations pause or the auto-pause replaces a restaurant pause. The restaurant cannot pause while either of them is active.
- **Pauses and the schedule:** the restaurant cannot set a pause while it is closed. A restaurant pause that outlasts the opening period ends when the period ends. Operations pauses and the auto-pause do not follow the schedule. The auto-pause can start after closing time, for example when a late order is auto-cancelled, and it still applies at the next opening.
- **Logging:** every state change records its source (restaurant user and device, operations user, schedule or system) for reports (AP §9.6.5).

## 7.2 Status sheet

Tapping the status pill opens the status sheet (owners and cashiers).

- **Current state** with its remaining time, and the next schedule change, for example «يغلق اليوم 11:30 م».
- **Pause:** «إيقاف 15 د», «30 د», «60 د» (fixed choices, as in AP §9.6.5) and «حتى أعيد الفتح». No reason is asked, so pausing is fast.
- **Busy mode:** «وضع الضغط +10 د» and «+20 د» (`merchant.busy_extra_options_min`), and «إلغاء وضع الضغط».
- **Resume:** «استئناف الاستقبال».
- When operations or the auto-pause rule paused the restaurant, the buttons are disabled. The sheet explains why and shows a call button: «أوقفت العمليات مطعمك — اتصل بهم لإعادة التشغيل».

## 7.3 Busy mode «وضع الضغط»

- MO or MC turns it on with +10 or +20 minutes.
- While it is on:
  - the delivery time customers see before ordering, and the promised time of new orders, are longer by the chosen minutes
  - the prep time preselected on the accept prompt is the restaurant's default plus the chosen minutes (§8.5)
  - the customer app shows «قد يستغرق الطلب وقتاً أطول قليلاً» on the restaurant page (customer-app spec §9.2)
- It ends when MO, MC or OPS turns it off, or at the end of the current opening period (S3).
- While it is on, the app plays a reminder chime every `merchant.busy_mode_reminder_min` (60) minutes: «وضع الضغط ما زال مفعّلاً (+{د} د)».

## 7.4 Maximum active orders (R5, AP D18)

- The owner sets «الحد الأقصى للطلبات الجارية» in Status and hours (§10): off by default, or a number from 1 to 50 (fixed range).
- **Active orders** are the restaurant's orders in `placed`, `accepted` or `ready`. An order stops counting at pickup or when it ends.
- The server checks the limit atomically when an order is placed, together with the other pre-order checks (AP §1.3, principle 10). Two customers can never both take the last place.
- When the count reaches the limit:
  - the restaurant becomes «مشغول» and customers cannot order
  - the restaurant sees the banner «وصلت إلى الحد الأقصى ({العدد} طلبات جارية). لن تصلك طلبات جديدة حتى يُستلم أحدها.»
- When the count drops below the limit, the restaurant opens again automatically.
- OPS sees the limit in the restaurant profile and MAY change it on the restaurant's request (AP §9.6.5).
