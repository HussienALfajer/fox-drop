# Appendix A. Settings

> Part of the [captain app spec](README.md) (CA). A bare "§n" here means CA §n.

New settings introduced by this spec. They are also listed in AP Appendix A. Scope: **C** per city.

| Key                                       | Default | Scope | Edit | Description                                                                            |
| ----------------------------------------- | ------- | ----- | ---- | -------------------------------------------------------------------------------------- |
| `captain.offer_expiry_offline_count`      | 3       | C     | OWN  | Consecutive expired offers that set a captain offline (C3)                             |
| `captain.merchant_arrival_radius_m`       | 150     | C     | OWN  | Distance from the restaurant within which «وصلت إلى المطعم» works (C6)                 |
| `captain.customer_radius_m`               | 200     | C     | OWN  | Distance from the customer's pin within which arrival and delivery need no reason (C9) |
| `captain.criminal_record_validity_months` | 12      | C     | OWN  | Validity of the criminal record certificate from its issue date (C18)                  |

**Existing settings this app uses** (AP Appendix A):

- `dispatch.offer_timeout_sec`, `dispatch.manual_assign_requires_accept`
- `captain.waiting_threshold_min`, `captain.custody_warn_pct`, `captain.remit_tolerance`, `captain.remit_online_grace_hours`
- `captain.payout_weekday`, `captain.negative_earnings_policy`
- `captain.acceptance_window_offers`, `captain.acceptance_alert_pct`, `captain.acceptance_review_pct`
- `captain.violation_window_days`, `captain.document_expiry_notice_days`, `captain.min_age`, `captain.gps_stale_alert_min`
- `customer.no_answer_pings`, `customer.no_answer_ping_interval_min`
- `order.pickup_confirm_timeout_sec`
- `finance.business_day_cutoff`
- `otp.*`, `app.captain.*`

**Per-captain fields** (not settings): cash limit (FIN), maximum pickup amount (the captain), carried currencies (the captain), vehicle (OPS).

**Fixed values in this spec:**

| Value                                   | Fixed at                      |
| --------------------------------------- | ----------------------------- |
| Location interval while online          | 10 s (AP §4.2)                |
| Location while offline                  | None collected                |
| Offline chime                           | After 30 s without connection |
| Signed-in devices per captain           | 1                             |
| Re-apply after rejection                | 30 days                       |
| Emergency button press                  | 2 s                           |
| Hand-in reminder push                   | 22:00 city time               |
| GPS accuracy for the "weak signal" hint | Worse than 100 m              |
| On-time rate window                     | Last 50 delivered orders      |
