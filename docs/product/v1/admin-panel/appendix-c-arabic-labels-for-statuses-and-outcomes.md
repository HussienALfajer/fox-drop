# Appendix C. Arabic labels for statuses and outcomes

> Part of the [admin panel spec](README.md) (AP). A bare "§n" here means AP §n.

| Code                                                                                                                 | Arabic                                                                                                                     |
| -------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| Order: `placed` / `accepted` / `ready` / `picked_up` / `arrived` / `delivered` / `rejected` / `cancelled` / `failed` | «بانتظار المطعم» / «قيد التحضير» / «جاهز» / «مع الكابتن» / «الكابتن وصل» / «تم التسليم» / «مرفوض» / «ملغى» / «فشل التسليم» |
| Outcome: `normal` / `free` / `fake` / `damaged` / `wrong_refused` / `failed_other`                                   | «عادي» / «مجاني» / «وهمي» / «تالف» / «خطأ ورفضه الزبون» / «تعذّر التسليم»                                                  |
| Responsible party: restaurant / captain / customer / platform                                                        | «المطعم» / «الكابتن» / «الزبون» / «المنصة»                                                                                 |
| Restaurant account: `draft` / `test` / `active` / `suspended` / `terminated`                                         | «مسودة» / «تجريبي» / «فعّال» / «معلّق» / «منتهي»                                                                           |
| Restaurant operating state: `open` / `busy` / `paused` / `closed`, and the busy-mode flag                            | «مفتوح» / «مشغول» / «موقوف مؤقتاً» / «مغلق», and «وضع الضغط»                                                               |
| Restaurant roles: owner / cashier                                                                                    | «مالك» / «كاشير»                                                                                                           |
| Captain status: online-available / busy / offline / suspended / cash-blocked                                         | «متصل متاح» / «مشغول» / «غير متصل» / «موقوف» / «محجوب لعدم تسليم النقد»                                                    |
| Captain contract: probation / commitment / open-ended                                                                | «فترة تجربة» / «فترة التزام» / «مفتوح»                                                                                     |
| Customer: active / review stop / blocked / closed / trusted                                                          | «نشط» / «موقوف حتى مراجعة الدعم» / «محظور» / «مغلق» / «موثوق»                                                              |
| Ticket: new / in progress / waiting / resolved / closed                                                              | «جديدة» / «قيد المعالجة» / «بانتظار رد» / «محلولة» / «مغلقة»                                                               |
| Alert severity: critical / warning / information                                                                     | «حرج» / «تحذير» / «معلومة»                                                                                                 |
