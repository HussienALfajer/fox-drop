# 8.3 Timers (defaults, all editable)

> Part of AP §8, the domain reference shared by all four V1 specs ([index](README.md)). A bare "§n" here means AP §n.

| Timer                                      | Key                                                                 | Default                           | What happens when it fires                                                                                                     |
| ------------------------------------------ | ------------------------------------------------------------------- | --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| Restaurant acceptance alert                | `order.merchant_accept_alert_min`                                   | 3 min                             | Critical alert: «مطعم لم يقبل»                                                                                                 |
| Auto-cancel for no restaurant response     | `order.merchant_auto_cancel_min`                                    | 7 min                             | The system cancels with reason «المطعم لم يستجب», apologises to the customer and counts an unanswered order for the restaurant |
| Captain offer                              | `dispatch.offer_timeout_sec`                                        | 45 s                              | The offer expires, the response is logged as «انتهت المهلة», and the next captain gets the offer                               |
| No captain after the search-start moment   | `dispatch.no_captain_alert_min`                                     | 5 min                             | Critical alert: «طلب بلا كابتن»                                                                                                |
| No captain after the order is ready        | `dispatch.no_captain_after_ready_min`                               | 15 min                            | Critical alert. OPS calls the customer: wait, or cancel with an apology and a code                                             |
| Prep running late (ops)                    | `order.prep_late_ops_alert_min`                                     | +10 min past the chosen prep time | Warning: «تحضير متأخر». The restaurant itself is alerted at +0.                                                                |
| Captain waiting at the restaurant          | `captain.waiting_threshold_min`                                     | 10 min                            | Waiting pay starts, if the pay table includes it. Warning: «كابتن ينتظر عند المطعم»                                            |
| Customer not answering                     | `customer.no_answer_pings` × `customer.no_answer_ping_interval_min` | 3 × 5 min                         | After 15 min the captain gets the «الزبون لا يستجيب» button. Warning: «زبون لا يرد». OPS decides.                              |
| Late delivery                              | `order.delivery_late_alert_min`                                     | +20 min past the promised time    | Warning: «توصيل متأخر». The customer gets an apology.                                                                          |
| Late delivery compensation                 | `order.delivery_late_compensation_min`                              | +45 min past the promised time    | The system issues a next-order code worth `order.late_compensation_value`                                                      |
| Captain GPS lost on an active order        | `captain.gps_stale_alert_min`                                       | 2 min                             | Critical alert: «انقطع اتصال كابتن أثناء طلب»                                                                                  |
| Pickup confirmation                        | `order.pickup_confirm_timeout_sec`                                  | 60 s                              | The server confirms the captain's pickup request automatically (§8.1)                                                          |
| Pickup dispute window                      | `order.pickup_dispute_window_min`                                   | 10 min after pickup               | The restaurant's «المبلغ غير صحيح» button disappears from the order                                                            |
| Open restaurant without a receiving device | `merchant.no_device_alert_min`                                      | 5 min                             | Warning: «مطعم مفتوح بلا جهاز استقبال» (restaurant-app spec §4.6)                                                              |
| Customer self-cancel                       | **fixed**                                                           | Only while `placed`               | After that, the customer asks support by call or WhatsApp, and OPS performs the cancellation (customer-app spec §11.4)         |

**Dispatch modes and the "search start" moment.** The server computes the search-start moment for every order in every mode (§9.12.6).

- **Automatic or mixed mode:** offers start at that moment.
- **Manual mode** (the launch mode, D6): no offers are sent automatically. At that moment the order is flagged «بحاجة لتعيين» (needs assignment), and the no-captain timer starts. A manual offer that is declined or expires returns the order to «بحاجة لتعيين».
- The capacity check applies in all modes.

**Delivery estimate and promised time** (customer-app spec Q7). The server computes both, and every app shows them from the server:

```
trip_min          = distance(restaurant → delivery pin, pricing.distance_method) ÷ order.eta_speed_kmh × 60
estimate_min      = restaurant default prep + busy-mode minutes + trip_min + order.eta_buffer_min
promised_time     = accepted_at + chosen prep time + trip_min + order.eta_buffer_min, rounded up to the next 5 minutes
```

- Before an order is placed, the customer sees `estimate_min` as a 10-minute range (customer-app spec §8.4).
- The promised time is set when the restaurant accepts, or OPS accept on its behalf. Before acceptance an order has no promised time.
- «تعديل الوقت» (§9.3.2) changes the promised time (owner decision 2026-11-10): operations add 1 to `order.eta_change_max_min` whole minutes, and the promised time moves by them, rounded up to the next 5 minutes. While the order is `accepted` the prep time moves with it: the restaurant's countdown, the prep-late alert and a search start still ahead. Once the food is ready, only the promised time moves.
- The late-delivery alert, the automatic late code (above) and the captain's on-time rate (captain-app spec §11.2) all count from the promised time.
