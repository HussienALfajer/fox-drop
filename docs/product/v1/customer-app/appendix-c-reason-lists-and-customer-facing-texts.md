# Appendix C. Reason lists and customer-facing texts

> Part of the [customer app spec](README.md) (CU). A bare "§n" here means CU §n.

These defaults are editable in Content: the lists in AP §9.13 and AP Appendix B, and the customer-facing texts in «نصوص الأسباب للزبون» (AP §9.13). A reason added later without a customer text shows «نعتذر، لم نتمكن من إكمال طلبك».

**Lists the customer picks from:**

| List                                       | Values                                                                                                                  |
| ------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------- |
| Self-cancel (AP Appendix B)                | «غيّرت رأيي» · «طلبت بالخطأ» · «العنوان خاطئ» · «سبب آخر»                                                               |
| Customer problem (AP Appendix B, with Q23) | «صنف ناقص» · «صنف خطأ» · «الطعام بارد» · «الطلب تالف» · «تأخير» · «سلوك الكابتن» · «مشكلة في المبلغ أو الباقي» · «أخرى» |
| Preset order notes                         | «اتصل بي عند الوصول» · «لا تطرق الباب» · «أرسلوا أدوات طعام» · «لا أحتاج أدوات طعام»                                    |
| Restaurant rating reasons, 1–2 stars       | «الطعام بارد» · «الطعم غير جيد» · «صنف ناقص أو خطأ» · «الكمية قليلة» · «التغليف سيئ»                                    |
| Restaurant rating reasons, 3 stars         | «جيد لكن يمكن أفضل» · «الكمية قليلة» · «التغليف يحتاج تحسيناً»                                                          |
| Restaurant rating reasons, 4–5 stars       | «طعم رائع» · «حار وطازج» · «كمية جيدة» · «تغليف ممتاز»                                                                  |
| Captain rating reasons, 1–2 stars          | «تأخر» · «سلوك غير لائق» · «لم يتصل عند الوصول» · «الطلب وصل تالفاً»                                                    |
| Captain rating reasons, 3 stars            | «تأخر قليلاً» · «يحتاج لطفاً أكثر»                                                                                      |
| Captain rating reasons, 4–5 stars          | «لطيف» · «سريع» · «حافظ على الطلب» · «ملتزم بالتعليمات»                                                                 |

**Customer-facing texts for reasons set by others:**

| Source                           | Reason                 | Customer sees                       |
| -------------------------------- | ---------------------- | ----------------------------------- |
| Restaurant rejection (RA §8.6)   | «صنف غير متوفر»        | «بعض الأصناف غير متوفرة: {الأصناف}» |
|                                  | «المطعم مغلق»          | «المطعم أغلق ولا يستقبل طلبات الآن» |
|                                  | «ضغط طلبات»            | «المطعم مشغول جداً الآن»            |
| System                           | No restaurant response | «لم يرد المطعم على طلبك»            |
| Ops cancellation (AP Appendix B) | «طلب الزبون»           | «أُلغي بناءً على طلبك»              |
|                                  | «المطعم لم يستجب»      | «لم يرد المطعم على طلبك»            |
|                                  | «المطعم أغلق»          | «المطعم أغلق ولا يستقبل طلبات الآن» |
|                                  | «صنف نفد»              | «أحد الأصناف نفد من المطعم»         |
|                                  | «لا يوجد كابتن»        | «لم نجد كابتناً متاحاً لطلبك»       |
|                                  | «العنوان خارج المنطقة» | «العنوان خارج منطقة التوصيل»        |
|                                  | «ظرف طارئ»             | «ظرف طارئ منعنا من إكمال طلبك»      |
|                                  | «سبب آخر»              | «نعتذر، أُلغي طلبك»                 |
| Failed outcome (AP §8.9)         | `failed_other`         | «تعذّر الوصول إليك أو إلى العنوان»  |
|                                  | `wrong_refused`        | «رفضت الطلب لأنه غير صحيح»          |
|                                  | `damaged` (failed)     | «وصل الطلب تالفاً»                  |
|                                  | `fake`                 | «لم يُستلم الطلب»                   |
| Customer block (AP Appendix B)   | «طلب وهمي»             | «طلب لم يُستلم»                     |
|                                  | «إساءة»                | «مخالفة شروط الاستخدام»             |
|                                  | «احتيال على الأكواد»   | «استخدام غير مسموح لأكواد الخصم»    |
|                                  | «أخرى»                 | «مخالفة شروط الاستخدام»             |

**Pre-order problems** (§10.6):

| Problem                       | Text                                         | Action           |
| ----------------------------- | -------------------------------------------- | ---------------- |
| Restaurant cannot take orders | The state text (§9.2)                        | —                |
| Item or option unavailable    | «{الصنف} لم يعد متوفراً»                     | «حذف»            |
| Price changed                 | «تغيّر سعر {الصنف} من {القديم} إلى {الجديد}» | «موافق»          |
| Below minimum order           | «أضف {المبلغ} لتصل إلى الحد الأدنى»          | «أضف أصنافاً»    |
| Outside coverage or zones     | «هذا المطعم لا يوصل إلى هذا العنوان»         | «تغيير العنوان»  |
| Active-order limit            | §5.5                                         | «طلباتي»         |
| Account state                 | §5.5                                         | «تواصل مع الدعم» |
| Emergency stop                | The browsing message (AP §9.1.6)             | —                |
| Outside platform hours        | «FOX DROP يستقبل الطلبات من الساعة {الساعة}» | —                |
| Capacity check                | «الضغط عالٍ الآن، جرّب بعد دقائق»            | «إعادة المحاولة» |
| Terms pending                 | «وافق على الشروط الجديدة لتتمكن من الطلب»    | «عرض الشروط»     |

**Code refusals** (AP §9.11.1):

| Reason                                     | Text                                                     |
| ------------------------------------------ | -------------------------------------------------------- |
| Unknown code                               | «الكود غير صحيح»                                         |
| Not started, expired, or outside its hours | «الكود غير صالح الآن»                                    |
| Below its minimum order                    | «أضف {المبلغ} لاستخدام هذا الكود»                        |
| Not for this restaurant or zone            | «هذا الكود لا يعمل مع هذا المطعم»                        |
| New users only                             | «هذا الكود للطلب الأول فقط»                              |
| Per-customer or total limit reached        | «استخدمت هذا الكود من قبل» / «انتهت استخدامات هذا الكود» |
| Daily budget reached                       | «الكود غير متاح اليوم»                                   |
