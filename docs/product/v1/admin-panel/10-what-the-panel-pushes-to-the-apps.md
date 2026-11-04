# 10. What the panel pushes to the apps

> Part of the [admin panel spec](README.md) (AP). A bare "§n" here means AP §n.

| Panel action | Customer | Restaurant | Captain |
|---|---|---|---|
| Accept or reject on behalf | Status and time, or the reason plus alternatives | «قبلت العمليات الطلب» / «رفضت العمليات الطلب» | — |
| Edit the order | New total | «تم تعديل الطلب» (sound; acknowledgement needed when items are added) | New amounts to pay and to collect |
| Change the time | New ETA | New prep time (if changed) | — |
| Cancel | Reason | «أوقف التحضير» (stop preparing) | «أُلغيت المهمة» (task cancelled) |
| Outcome set or changed | Result; if blocked, the dues and how to pay them | Commission or return of the pickup payment, when it applies | Reimbursement due at the desk, pay or charge |
| Hand over after pickup | «تغيّر الكابتن: {الاسم} يكمل توصيل طلبك» | — | First captain: «سُلّم الطلب لكابتن آخر». Second captain: the task. |
| Customer blocked, unblocked or account closed | Status with the reason | — | — |
| Ticket resolved | Resolution message | Debit, when the restaurant is responsible | Charge, when the captain is responsible |
| Assign or reassign | Captain name and photo | Captain and ETA | Offer or assignment / «سُحب الطلب» (order withdrawn) |
| Compensation | The code and its message | — | — |
| Emergency stop on or off | Message, or a delay notice for active orders / service back | Banner | Banner |
| Menu price change by admin | — | Change notice (D17) | — |
| Menu change request approved or rejected | — | Decision, with the reason when rejected | — |
| Pickup confirmed on the restaurant's behalf | — | «أكّدت العمليات استلام الكابتن للطلب» | Pickup complete |
| Captain's arrival recorded by OPS | — | «وصل الكابتن» | Arrival recorded; pickup can start |
| Captain set offline after expired offers | — | — | «لم ترد على 3 عروض متتالية، فأصبحت غير متصل» |
| Item-unavailable report closed | — | The report is closed, with the reason | Pickup allowed again |
| Commission change (D16) | — | New rate and its start date | — |
| Restaurant pause, suspend or resume; busy mode ended | Restaurant state | State with the reason | — |
| Captain suspend, force offline, limit change, grace | — | — | State with the reason |
| Cash-desk receipt | Dues receipt | Settlement receipt | Hand-in, reimbursement, payout, deposit |
| Weekly statement generated | — | Restaurant statement before Saturday: commission, discounts, exceptions, total due | Captain statement on Thursday: orders, pay breakdown, deductions, net paid |
| Restaurant overdue on settlement | — | Reminder of the amount due | — |
| Pay table change or peak bonus | — | — | Announcement and new table |
| Application stage change | — | — | Stage, missing documents, interview time, rejection reason |
| Contract phase change | — | — | New phase and its dates |
| Terms version published | Re-accept on next open | Re-accept | Re-accept |
| Force update or maintenance | Update or maintenance screen | Same | Same |
