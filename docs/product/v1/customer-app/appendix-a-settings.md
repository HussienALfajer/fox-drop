# Appendix A. Settings

> Part of the [customer app spec](README.md) (CU). A bare "§n" here means CU §n.

New settings introduced by this spec. They are also listed in AP Appendix A. Scope: **C** per city.

| Key                                    | Default       | Scope | Edit | Description                                                                                                       |
| -------------------------------------- | ------------- | ----- | ---- | ----------------------------------------------------------------------------------------------------------------- |
| `customer.phone_default_country`       | Before launch | C     | OWN  | Country preselected on the sign-in screen: SY or TR (U3)                                                          |
| `customer.far_pin_warn_m`              | 1000          | C     | OWN  | Distance between the pin and the device above which the app asks to confirm the address (U5)                      |
| `customer.rating_window_days`          | 3             | C     | OWN  | Days after delivery during which the order can be rated (U15)                                                     |
| `customer.report_problem_window_hours` | 24            | C     | OWN  | Hours after delivery during which a problem can be reported in the app (U16)                                      |
| `order.eta_buffer_min`                 | 10            | C     | OWN  | Minutes added to prep and trip time for the captain's arrival at the restaurant and the handover at the door (Q7) |
| `order.eta_speed_kmh`                  | 20            | C     | OWN  | Average speed used to turn the trip distance into minutes (Q7)                                                    |

**Existing settings this app uses** (AP Appendix A):

- `platform.hours`, `platform.emergency_default_message_browse`, `platform.emergency_default_message_active`
- `order.delivery_late_alert_min`, `order.delivery_late_compensation_min`, `order.late_compensation_value`
- `customer.no_answer_pings`, `customer.no_answer_ping_interval_min`
- `customer.new_max_active_orders`, `customer.trusted_after_delivered_orders`, `customer.trusted_max_active_orders`
- `customer.late_cancel_strikes`, `customer.late_cancel_window_days`
- `dispatch.capacity_check`, `pricing.distance_method`
- `support.resolution_post_delivery_hours`
- `finance.business_day_cutoff`
- `otp.*`, `app.customer.*`

**Fixed values in this spec:**

| Value                                                 | Fixed at                                                  |
| ----------------------------------------------------- | --------------------------------------------------------- |
| Sign-in code length                                   | 6 digits                                                  |
| Order polling when the socket is down                 | Every 30 s                                                |
| Location use                                          | While the app is in use only                              |
| Street-level zoom to confirm a pin                    | Zoom 16 or closer                                         |
| GPS accuracy for «موقعي الحالي» and the far-pin check | 100 m                                                     |
| Wait for a fresh position for the far-pin check       | 5 s                                                       |
| Distance to preselect a saved address at checkout     | 200 m                                                     |
| Digits that make a note look like a phone number      | A run of 7 or more                                        |
| Votes                                                 | One per device per point                                  |
| Saved addresses                                       | 10                                                        |
| Recent searches                                       | 10                                                        |
| Estimate range                                        | 10 min wide, starting at the estimate rounded up to 5 min |
| Quantity per cart line                                | 1 to 20                                                   |
| Item note / order note                                | 100 / 200 characters                                      |
| Cart kept on the device                               | 24 h after the last change                                |
| Door ping ring with the app open                      | 30 s                                                      |
| Ratings before the average is shown                   | 5                                                         |
| Rating comment / report note                          | 300 characters                                            |
| Problem reports per order                             | 1, with up to 3 photos                                    |
| Price reports                                         | 1 per restaurant per customer per business day            |
| Notifications list and expired codes                  | 30 days                                                   |
