# 3. Glossary

> Part of the [restaurant app spec](README.md) (RA). A bare "§n" here means RA §n.

Terms from AP §3 (items value, pickup payment, commission, merchant net, base currency, business day, outcome, responsible party) apply unchanged.

| Term                                    | Meaning                                                                                                                                                        |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Receiving device «جهاز استقبال»         | A signed-in app device that rings for new orders: connected, ringing turned on, and on a supported app version (§4.6). The portal is never a receiving device. |
| Ring «رنين»                             | A sound that loops until someone acts (§4.4).                                                                                                                  |
| Pickup request «طلب تأكيد الاستلام»     | Created when the captain taps «دفعت للمطعم واستلمت الطلب». The restaurant confirms or disputes it (§8.10).                                                     |
| Pickup dispute «خلاف على مبلغ الاستلام» | The restaurant reporting that the cash it received differs from the pickup payment (§8.10).                                                                    |
| Busy mode «وضع الضغط»                   | A flag on an open restaurant that adds 10 or 20 minutes to the time customers see (§7).                                                                        |
| Busy «مشغول»                            | The state of a restaurant that has reached its maximum active orders. Customers cannot order until the count drops (§7.4).                                     |
| Active orders                           | For the limit: the restaurant's orders in `placed`, `accepted` or `ready` (not yet picked up).                                                                 |
| Device check «فحص الجهاز»               | A guided check that the device will ring and stay connected (§4.5).                                                                                            |
| Menu change request «طلب تعديل القائمة» | A menu change that waits for admin review before customers see it (§9.5).                                                                                      |
| Owner web portal «بوابة المطعم»         | The browser version for owners (§17).                                                                                                                          |
