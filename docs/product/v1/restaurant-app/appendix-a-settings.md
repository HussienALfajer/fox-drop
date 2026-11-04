# Appendix A. Settings

> Part of the [restaurant app spec](README.md) (RA). A bare "§n" here means RA §n.

New settings introduced by this spec. They are also listed in AP Appendix A. Scope: **G** global, **C** per city.

| Key | Default | Scope | Edit | Description |
|---|---|---|---|---|
| `merchant.prep_time_options` | 10, 15, 20, 30, 45 | C | OWN | Prep-time chips on the accept prompt (minutes) |
| `merchant.prep_time_step_min` | 5 | C | OWN | Step of the «−» and «+» buttons |
| `merchant.prep_time_floor_min` | 5 | C | OWN | Shortest prep time allowed |
| `merchant.prep_time_ceiling_min` | 90 | C | OWN | Longest prep time allowed |
| `merchant.busy_extra_options_min` | 10, 20 | C | OWN | Minutes busy mode can add |
| `merchant.busy_mode_reminder_min` | 60 | C | OWN | Reminder interval while busy mode is on |
| `merchant.no_device_alert_min` | 5 | C | OWN | Minutes an open restaurant may have no receiving device before the alert |
| `merchant.price_change_alert_pct` | 30 | C | OWN | Price change that raises the «تغيير أسعار كبير» alert |
| `merchant.web_session_days` | 30 | G | OWN | Portal session length |
| `order.pickup_confirm_timeout_sec` | 60 | C | OWN | Seconds before a pickup request is confirmed automatically |
| `order.pickup_dispute_window_min` | 10 | C | OWN | Minutes after pickup during which the restaurant can dispute the amount |

**Existing settings this app uses** (AP Appendix A):

- `order.merchant_accept_alert_min` (3)
- `order.merchant_auto_cancel_min` (7)
- `order.prep_late_ops_alert_min` (10)
- `merchant.auto_pause_unanswered_count` (3)
- `merchant.settlement_weekday` (Saturday)
- `merchant.settlement_overdue_days` (2)
- `merchant.default_prep_min` (20, the prefill for a new restaurant's default prep time)
- `captain.waiting_threshold_min` (10)
- `finance.business_day_cutoff` (06:00)
- `otp.*`
- `app.merchant.*`

**Per-restaurant fields** (not settings): default prep time, maximum active orders (off by default), pickup currencies (base only by default), opening hours.

**Fixed values in this spec:**

| Value | Fixed at |
|---|---|
| Heartbeat interval | 20 s |
| Device marked disconnected after | 60 s without a heartbeat |
| Offline chime | After 30 s offline |
| Prep-late chime repeat | Every 5 min |
| Restaurant pause choices | 15, 30, 60 min, or until reopening |
| Maximum active orders range | 1–50 |
| Shortest opening period | 30 min |
| Holiday message length | 100 characters |
| Cashier history | Today plus the previous 7 business days |
| Restaurants per phone number | 1 |
| Base currency at pickup | Always accepted |
| Cashier devices | Always ring |
| «الطلب جاهز» | No undo |
