# 9.13 Content «المحتوى»

> Part of the [admin panel spec](../README.md) (AP). A bare "§n" here means AP §n.

| Item | What the admin edits |
|---|---|
| Categories «التصنيفات» | Name, icon or image, order |
| FAQs «الأسئلة الشائعة» | Three separate sets: customer, captain, restaurant |
| Terms and privacy «الشروط والخصوصية» | One document per audience, versioned. Publishing a new version requires users to accept it again on their next app open. |
| Reason lists «قوائم الأسباب» | Restaurant rejection, restaurant problems on an order, restaurant ticket types, the optional note for an item unavailable after acceptance, captain cannot-complete reasons, captain away-from-pin reasons, collection-shortfall reasons, food after a failed order, captain ticket types, customer cancellation, ops cancellation, reassignment, customer problems, captain problems, captain suspension, customer block, and rating reasons per star count (Appendix B holds the defaults) |
| Preset order notes «الملاحظات الجاهزة» | What the customer can pick at checkout (defaults in Appendix B) |
| Customer-facing reason texts «نصوص الأسباب للزبون» | The text the customer sees for each restaurant rejection reason, ops cancellation reason, failed outcome and block reason (defaults in customer-app spec Appendix C). A reason added without a customer text shows a generic apology. |
| Notification templates «نصوص الإشعارات» | Text per event and audience, with variables such as `{اسم_الكابتن}`, `{الوقت}`, `{رقم_الطلب}`, `{السبب}` |
| Captain work rules page | The rules and pay table text shown in the captain app |
| Contact info | Support WhatsApp and phone as shown in the apps |
| Canned replies «الردود الجاهزة» | Used in tickets (SUP can edit) |
