# 9.1 Dashboard «لوحة التحكم»

> Part of the [admin panel spec](../README.md) (AP). A bare "§n" here means AP §n.

**Purpose:** understand the state of the whole platform within 10 seconds of opening the panel.

## 9.1.1 Status strip

- **Platform:** «تعمل» (running) or «إيقاف طارئ» (emergency stop), with the emergency message and its start time.
- **Dispatch mode** with a switch for OWN and OPS.
- **Captains:** online, available, busy, and blocked for unhanded cash, each with a count.
- **Restaurants:** open, busy (at their maximum active orders), paused, closed by schedule, and suspended, each with a count, plus how many open restaurants have no receiving device connected.

## 9.1.2 Today tiles (current business day, compared with the same weekday last week)

- Orders delivered, in progress, cancelled and rejected.
- GMV (customer totals), items value, delivery fees, commissions and platform margin, all in the base currency.
- Average delivery time from placement to delivery, the on-time rate and the success rate (delivered ÷ placed).
- New customers and first orders.

## 9.1.3 Alerts list (the most important part)

Alerts are sorted by severity, then by age. Each one has direct action buttons. Only users with a recipient role see an alert, hear it and can acknowledge it (§7.3).

| Alert                                                                    | Severity    | Recipients                                            | Trigger                                                                                                                                                                       | Actions on the alert                                                                   |
| ------------------------------------------------------------------------ | ----------- | ----------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| «مطعم لم يقبل» (restaurant has not accepted)                             | Critical    | OWN, OPS                                              | `placed` for 3 min                                                                                                                                                            | Call the restaurant · Accept on its behalf · Open the order                            |
| «طلب بلا كابتن» (order without a captain)                                | Critical    | OWN, OPS                                              | 5 min after the search-start moment (in every dispatch mode, §8.3)                                                                                                            | Assign manually · Open the map                                                         |
| «جاهز بلا كابتن» (ready, no captain)                                     | Critical    | OWN, OPS                                              | 15 min after ready, still unassigned                                                                                                                                          | Call the customer · Assign · Cancel with a code                                        |
| «انقطع اتصال كابتن أثناء طلب» (captain lost connection mid-order)        | Critical    | OWN, OPS                                              | No GPS for 2 min during an active order                                                                                                                                       | Call the captain · Reassign (before pickup) · Hand over (after pickup)                 |
| «المطعم لم يؤكد التعديل» (restaurant did not acknowledge an edit)        | Critical    | OWN, OPS                                              | Items added and not acknowledged by the restaurant for 3 min (§9.3.3)                                                                                                         | Call the restaurant · Open the order                                                   |
| «تذكرة عاجلة» (urgent ticket)                                            | Critical    | OWN, OPS, SUP; FIN as well for pickup-dispute tickets | A ticket on an active order, or any pickup-dispute ticket (§9.9.3)                                                                                                            | Open the ticket                                                                        |
| «صنف نفد بعد القبول» (item ran out after acceptance)                     | Critical    | OWN, OPS                                              | The restaurant reported an item unavailable on an accepted order (restaurant-app spec §8.12)                                                                                  | Call the customer · Edit the order · Cancel · Close the report                         |
| «خلاف على مبلغ الاستلام» (pickup amount dispute)                         | Critical    | OWN, OPS                                              | The restaurant disputed a pickup request before confirming it (§8.1)                                                                                                          | Call the restaurant · Call the captain · Confirm pickup on its behalf · Open the order |
| «كابتن لا يستطيع إكمال الطلب» (captain cannot complete the order)        | Critical    | OWN, OPS                                              | A captain pressed «لا أستطيع إكمال الطلب» with a reason (captain-app spec §9.11)                                                                                              | Call the captain · Reassign (before pickup) · Hand over (after pickup)                 |
| «طوارئ كابتن» (captain emergency)                                        | Critical    | OWN, OPS                                              | A captain pressed «طوارئ» during an order; the alert carries their location (captain-app spec §9.11)                                                                          | Call the captain · Open the map · Hand over · Reassign                                 |
| «تحضير متأخر» (prep late)                                                | Warning     | OWN, OPS                                              | 10 min past the chosen prep time                                                                                                                                              | Call the restaurant · Update the ETA                                                   |
| «كابتن ينتظر عند المطعم» (captain waiting at the restaurant)             | Warning     | OWN, OPS                                              | 10 min at the restaurant                                                                                                                                                      | Call the restaurant                                                                    |
| «توصيل متأخر» (late delivery)                                            | Warning     | OWN, OPS                                              | 20 min past the promised time                                                                                                                                                 | Call the captain · Send an apology                                                     |
| «زبون لا يرد» (customer not answering)                                   | Warning     | OWN, OPS                                              | After 3 pings over 15 min                                                                                                                                                     | Call the customer · Decide: wait or fake                                               |
| «نقص في التحصيل» (collection shortfall)                                  | Warning     | OWN, OPS, FIN                                         | Collected less than due beyond rounding (§8.6)                                                                                                                                | Open the order · Call the captain · Resolve                                            |
| «كابتن بلغ حد العهدة» (captain reached the cash limit)                   | Warning     | OWN, OPS, FIN                                         | 100% of the cash limit                                                                                                                                                        | Open the captain's custody                                                             |
| «مطعم أوقف تلقائياً» (restaurant auto-paused)                            | Warning     | OWN, OPS                                              | 3 unanswered orders in a business day                                                                                                                                         | Call the restaurant · Resume                                                           |
| «مطعم مفتوح بلا جهاز استقبال» (open restaurant with no receiving device) | Warning     | OWN, OPS                                              | Open or busy for 5 min with no receiving device connected (restaurant-app spec §4.6)                                                                                          | Call the restaurant · Pause                                                            |
| «لا يمكن إرسال رموز الدخول» (sign-in codes cannot be sent)               | Critical    | OWN, OPS                                              | No WhatsApp sending number is able to send (technology-stack §8.3.3). New sign-ins stop; existing sessions continue.                                                          | Open «أرقام إرسال الرموز» (OWN) · Call the owner (OPS)                                 |
| «رقم إرسال الرموز متوقف» (a code-sending number stopped)                 | Warning     | OWN                                                   | A WhatsApp sending number is disconnected, throttled or banned (technology-stack §8.3.3)                                                                                      | Open «أرقام إرسال الرموز»                                                              |
| «مطعم متأخر في التسوية» (restaurant overdue on settlement)               | Warning     | OWN, FIN                                              | Account not settled 2 days after Saturday (§8.7)                                                                                                                              | Open the statement · Call the restaurant · Record a payment                            |
| «طلب موافقة تعويض» (compensation approval request)                       | Information | OWN                                                   | SUP or OPS asked for more than their cap                                                                                                                                      | Approve · Edit · Reject                                                                |
| «طلب انضمام كابتن» (captain application)                                 | Information | OWN, OPS                                              | New application                                                                                                                                                               | Review                                                                                 |
| «نهاية فترة تجربة» (probation ending)                                    | Information | OWN, OPS                                              | 3 days before a captain's probation ends                                                                                                                                      | Open the contract                                                                      |
| «مستند ينتهي» (document expiring)                                        | Information | OWN, OPS                                              | 30 days before a document expires                                                                                                                                             | Open the documents                                                                     |
| «مراجعة نسبة القبول» (acceptance-rate review)                            | Information | OWN, OPS                                              | A captain's acceptance rate fell below 50%                                                                                                                                    | Open the captain                                                                       |
| «سعر صرف قديم» (stale exchange rate)                                     | Information | OWN, FIN                                              | A rate not updated for 24 h                                                                                                                                                   | Update the rates                                                                       |
| «تغيير أسعار كبير» (large price change)                                  | Information | OWN, OPS                                              | A restaurant changed a price by more than 30% in one edit or bulk change (restaurant-app spec §9.4)                                                                           | Open the price log · Call the restaurant                                               |
| «تسليم بعيد عن العنوان» (delivery away from the address)                 | Information | OWN, OPS                                              | A captain recorded arrival or delivery more than `captain.customer_radius_m` (200) m from the customer's pin, with a reason (captain-app spec §9.6 and captain-app spec §9.8) | Open the order · Call the captain                                                      |

## 9.1.4 Pending tasks «المهام»

A widget with counts and links, filtered to the user's roles:

- approvals waiting (OWN)
- menu change requests from restaurants (OWN, OPS; §9.6.7)
- applications to review
- probation reviews
- expiring documents
- acceptance-rate reviews
- open collection shortfalls
- captains blocked for unhanded cash
- Saturday restaurant settlements due, and overdue restaurants
- Thursday payouts due (on Thursday)

## 9.1.5 Charts and lists

- Orders per hour today, compared with the same weekday last week.
- Top restaurants today by orders.
- Restaurants with the most rejections or delays today.

## 9.1.6 Emergency stop «الإيقاف الطارئ» (D7; OWN, OPS)

**Starting the stop.** The dialog has these fields:

- an internal reason (required)
- the message shown to browsing customers (prefilled from `platform.emergency_default_message_browse`, editable)
- the delay notice for customers with active orders (prefilled from `platform.emergency_default_message_active`, editable). Its `{السبب}` placeholder is filled from the customer-facing reason below.
- the customer-facing reason text, for example «سوء الأحوال الجوية» (bad weather)
- an optional automatic resume time

**While the stop is on:**

1. New orders stop. Customers can browse, but the order button is disabled and the message is shown.
2. Every customer with an active order gets a push notification and an in-app banner on the tracking screen, such as «قد يتأخر طلبك قليلاً بسبب {السبب}».
3. Restaurant and captain apps show a banner: «المنصة متوقفة مؤقتاً عن استقبال طلبات جديدة. أكملوا الطلبات الحالية.» Active orders continue normally, including dispatch for orders that have no captain yet.
4. The top bar turns red. The dashboard shows how long the stop has lasted and how many orders customers tried to place during it: each customer who opens checkout during the stop counts once per stop (customer-app spec §10.6).

**Ending the stop:** «استئناف» (resume), with an option to send customers a push saying the service is back. An automatic resume never sends that push; OPS can send it afterwards from marketing. Starting and ending are both audited.
