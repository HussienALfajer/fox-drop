# 3. Glossary

> Part of the [captain app spec](README.md) (CA). A bare "§n" here means CA §n.

Terms from AP §3 (pickup payment, custody, earnings, hand-in, Thursday settlement, business day, outcome, responsible party, offer) and RA §3 (pickup request, pickup dispute) apply unchanged.

| Term                                     | Meaning                                                                                                                             |
| ---------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| Offer «عرض»                              | A proposal of one order to one captain for `dispatch.offer_timeout_sec` (45) seconds (AP §8.3)                                      |
| Active order «الطلب الجاري»              | The order a captain has accepted and not yet finished                                                                               |
| Last-order mode «لا أريد طلبات جديدة»    | The captain finishes the current order and then goes offline automatically (§7.3)                                                   |
| Maximum pickup amount «أقصى مبلغ أحمله»  | The highest pickup payment the captain can pay a restaurant from their own cash (C4)                                                |
| Carried currencies «العملات التي أحملها» | The currencies the captain usually carries, used to propose payment lines (C8)                                                      |
| Payment lines «سطور الدفع»               | Amounts per currency that make up a payment, at pickup or at the door (AP §8.6)                                                     |
| `closed_due` «من أيام سابقة»             | Custody from closed business days, which blocks going online (AP §8.5.4)                                                            |
| Arrival radius                           | The distance within which arrival or delivery is accepted without a reason: 150 m at the restaurant, 200 m at the customer (C6, C9) |
| Device check «فحص الجهاز»                | A guided check that the phone can ring and track location (§4.5)                                                                    |
