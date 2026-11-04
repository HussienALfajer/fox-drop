# Appendix A. Settings catalogue

> Part of the [admin panel spec](README.md) (AP). A bare "§n" here means AP §n.

Scope: **G** global, **C** per city. "Before launch" means the owner enters the value before going live.

| Key | Default | Scope | Edit | Description |
|---|---|---|---|---|
| `platform.hours` | 24/7 | C | OWN | Platform operating schedule (D9) |
| `platform.emergency_default_message_browse` | «نعتذر، توقفنا مؤقتاً عن استقبال الطلبات. نعود قريباً.» | C | OWN | Default emergency message for browsing customers |
| `platform.emergency_default_message_active` | «قد يتأخر طلبك قليلاً بسبب {السبب}. نعتذر عن الانتظار.» | C | OWN | Default delay notice for active orders |
| `order.merchant_accept_alert_min` | 3 | C | OWN | Restaurant acceptance alert |
| `order.merchant_auto_cancel_min` | 7 | C | OWN | Auto-cancel for no response |
| `order.prep_late_ops_alert_min` | 10 | C | OWN | Prep-late alert to ops, after the chosen time |
| `order.delivery_late_alert_min` | 20 | C | OWN | Late-delivery alert after the promised time |
| `order.delivery_late_compensation_min` | 45 | C | OWN | Automatic compensation after the promised time |
| `order.late_compensation_value` | Before launch | C | OWN | Value of the automatic late code (amount or %) |
| `order.outcome_change_days` | 7 | C | OWN | Days during which OWN can change an outcome (§8.9) |
| `order.pickup_confirm_timeout_sec` | 60 | C | OWN | Seconds before a pickup request is confirmed automatically (§8.1) |
| `order.pickup_dispute_window_min` | 10 | C | OWN | Minutes after pickup during which the restaurant can dispute the amount |
| `order.eta_buffer_min` | 10 | C | OWN | Minutes added to prep and trip time in the delivery estimate and the promised time (§8.3) |
| `order.eta_speed_kmh` | 20 | C | OWN | Average speed that turns the trip distance into minutes (§8.3) |
| `merchant.auto_pause_unanswered_count` | 3 | C | OWN | Unanswered orders per business day before auto-pause |
| `merchant.settlement_weekday` | Saturday | C | OWN | Restaurant account settlement day (D13, D26) |
| `merchant.settlement_overdue_days` | 2 | C | OWN | Days after the settlement day before the overdue alert |
| `merchant.default_commission_pct` | 15 | C | OWN | Prefill for new restaurants |
| `merchant.default_prep_min` | 20 | C | OWN | Prefill for new restaurants |
| `merchant.default_min_order` | Before launch | C | OWN | Prefill for new restaurants |
| `merchant.prep_time_options` | 10, 15, 20, 30, 45 | C | OWN | Prep-time choices in the restaurant app (minutes) |
| `merchant.prep_time_step_min` | 5 | C | OWN | Step of the prep-time «−» and «+» buttons |
| `merchant.prep_time_floor_min` | 5 | C | OWN | Shortest prep time a restaurant can choose |
| `merchant.prep_time_ceiling_min` | 90 | C | OWN | Longest prep time a restaurant can choose |
| `merchant.busy_extra_options_min` | 10, 20 | C | OWN | Minutes a restaurant's busy mode can add |
| `merchant.busy_mode_reminder_min` | 60 | C | OWN | Reminder interval while busy mode is on |
| `merchant.no_device_alert_min` | 5 | C | OWN | Minutes an open restaurant may have no receiving device before the alert |
| `merchant.price_change_alert_pct` | 30 | C | OWN | Restaurant price change that raises «تغيير أسعار كبير» |
| `merchant.web_session_days` | 30 | G | OWN | Restaurant owner portal session length |
| `dispatch.mode` | manual | C | OWN, OPS | manual · auto · mixed (D6) |
| `dispatch.offer_timeout_sec` | 45 | C | OWN | Offer duration |
| `dispatch.search_radius_km` | 3 | C | OWN | Eligibility radius around the restaurant |
| `dispatch.ranking` | nearest_then_fewest_today | C | OWN | Ranking rule |
| `dispatch.max_offers_before_manual` | 5 | C | OWN | Mixed mode: failed offers before manual |
| `dispatch.no_captain_alert_min` | 5 | C | OWN | Alert after the search-start moment, in every dispatch mode |
| `dispatch.no_captain_after_ready_min` | 15 | C | OWN | Alert after ready, still unassigned |
| `dispatch.search_start_buffer_min` | 5 | C | OWN | Buffer added to the captain ETA for search start |
| `dispatch.manual_assign_requires_accept` | true | C | OWN | Manual assignment is sent as an offer |
| `dispatch.capacity_check` | true | C | OWN | Refuse orders with no eligible captain nearby |
| `dispatch.max_distance_km.walking` | 1.5 | C | OWN | Max trip distance |
| `dispatch.max_distance_km.bicycle` | 4 | C | OWN | Max trip distance (bicycle and e-bike) |
| `dispatch.max_distance_km.motorbike` | 10 | C | OWN | Max trip distance |
| `dispatch.max_distance_km.car` | 15 | C | OWN | Max trip distance |
| `pricing.distance_method` | road | G | OWN | road (routing service) · straight-line × 1.3 fallback |
| `captain.waiting_threshold_min` | 10 | C | OWN | Waiting pay start and ops alert |
| `captain.custody_warn_pct` | 80 | C | OWN | Cash-limit warning threshold |
| `captain.custody_limit_suggested.<vehicle>` | Before launch | C | OWN | Prefill only (D10) |
| `captain.remit_tolerance` | 0 | C | OWN | Allowed `closed_due` before blocking (base currency, §8.5.4) |
| `captain.remit_online_grace_hours` | 4 | C | OWN | Hours a captain online across the cutoff keeps getting offers while `closed_due` is open |
| `captain.payout_weekday` | Thursday | C | OWN | Weekly settlement day (D12) |
| `captain.negative_earnings_policy` | carry_forward | C | OWN | carry_forward · collect_at_desk |
| `captain.acceptance_window_offers` | 50 | C | OWN | Window for the acceptance rate |
| `captain.acceptance_alert_pct` | 70 | C | OWN | Warning to the captain below this |
| `captain.acceptance_review_pct` | 50 | C | OWN | Ops review task below this |
| `captain.probation_days` | 30 | C | OWN | Probation length (D24) |
| `captain.min_commitment_months` | 3 | C | OWN | Commitment after probation (D24) |
| `captain.probation_review_notice_days` | 3 | C | OWN | Task before probation ends |
| `captain.document_expiry_notice_days` | 30 | C | OWN | Task before a document expires |
| `captain.violation_window_days` | 90 | C | OWN | Window for the conduct ladder |
| `captain.min_age` | 18 | G | OWN | Minimum applicant age |
| `captain.gps_stale_alert_min` | 2 | C | OWN | No GPS during an active order |
| `captain.offer_expiry_offline_count` | 3 | C | OWN | Consecutive expired offers that set a captain offline (captain-app C3) |
| `captain.merchant_arrival_radius_m` | 150 | C | OWN | Distance from the restaurant within which the captain can confirm arrival (captain-app C6) |
| `captain.customer_radius_m` | 200 | C | OWN | Distance from the customer's pin within which arrival and delivery need no reason (captain-app C9) |
| `captain.criminal_record_validity_months` | 12 | C | OWN | Validity of the criminal record certificate from its issue date (captain-app C18) |
| `customer.no_answer_pings` | 3 | C | OWN | App pings to a customer who does not answer |
| `customer.no_answer_ping_interval_min` | 5 | C | OWN | Interval between pings |
| `customer.new_max_active_orders` | 1 | C | OWN | Active orders for a new account (D23) |
| `customer.trusted_after_delivered_orders` | 3 | C | OWN | Delivered orders to become trusted (D23) |
| `customer.trusted_max_active_orders` | 3 | C | OWN | Active orders for a trusted account |
| `customer.late_cancel_strikes` | 2 | C | OWN | Strikes before a review stop |
| `customer.late_cancel_window_days` | 30 | C | OWN | Strike window |
| `customer.fake_order_dues_rule` | fee_plus_merchant_net | C | OWN | Dues after a fake order: fee_plus_merchant_net · fee_plus_items_value · fixed |
| `customer.fake_order_dues_fixed` | — | C | OWN | Amount used when the rule is `fixed` |
| `customer.phone_default_country` | Before launch | C | OWN | Country preselected on the customer sign-in screen: SY or TR (customer-app U3) |
| `customer.far_pin_warn_m` | 1000 | C | OWN | Pin-to-device distance above which the customer app asks to confirm the address (customer-app U5) |
| `customer.rating_window_days` | 3 | C | OWN | Days after delivery during which an order can be rated (customer-app U15) |
| `customer.report_problem_window_hours` | 24 | C | OWN | Hours after delivery during which a customer can report a problem in the app (customer-app U16) |
| `otp.validity_min` | 5 | G | OWN | App sign-in code validity |
| `otp.max_attempts` | 5 | G | OWN | Attempts per code |
| `otp.resend_after_sec` | 60 | G | OWN | Resend wait |
| `otp.channel_order` | whatsapp | G | OWN | Channel priority for app OTP. WhatsApp is the only channel in V1; sms and voice are reserved for later (technology-stack T5) |
| `otp.number_hourly_max` | 3 | G | OWN | Codes per phone number per hour |
| `otp.number_daily_max` | 6 | G | OWN | Codes per phone number per day |
| `otp.device_daily_max` | 6 | G | OWN | Codes per device per day |
| `otp.ip_hourly_max` | 30 | G | OWN | Code requests per IP address per hour |
| `otp.sender_per_minute_max` | 12 | G | OWN | Messages per WhatsApp sending number per minute |
| `otp.sender_daily_max` | 1500 | G | OWN | Messages per WhatsApp sending number per day |
| `otp.send_jitter_sec` | 1–4 | G | OWN | Random delay between two sends from the same number |
| `otp.sender_warmup_caps` | 50, 100, 200, 400, 800, full | G | OWN | Daily caps for a new sending number during its warm-up, one step every 2–3 days |
| `support.first_response_active_min` | 15 | C | OWN | SLA for active-order tickets |
| `support.resolution_post_delivery_hours` | 24 | C | OWN | SLA after delivery |
| `support.compensation_cap_pct.SUP` | 30 | C | OWN | Cap without approval (D4) |
| `support.compensation_cap_pct.OPS` | 30 | C | OWN | Cap without approval |
| `finance.business_day_cutoff` | 06:00 | C | OWN | Start of the business day |
| `fx.stale_alert_hours` | 24 | C | OWN | Stale-rate alert |
| `fx.large_change_confirm_pct` | 10 | C | OWN | Second confirmation for large rate changes |
| `currency.<code>.rounding_unit` | Before launch | C | OWN, FIN | Rounding unit per currency (D14) |
| `currency.<code>.rounding_mode` | nearest | C | OWN, FIN | nearest · up · down (D14) |
| `push.daily_limit` | none | C | OWN | Mass-push limit (D20: none) |
| `admin.password_min_length` | 10 | G | OWN | Panel password length |
| `admin.login_max_attempts` | 5 | G | OWN | Failures before lockout |
| `admin.lockout_min` | 15 | G | OWN | Lockout duration |
| `admin.session_idle_min` | 30 | G | OWN | Idle timeout |
| `admin.session_max_hours` | 12 | G | OWN | Absolute session length |
| `app.<customer\|merchant\|captain>.min_version` | — | G | OWN | Force update below this |
| `app.<customer\|merchant\|captain>.latest_version` | — | G | OWN | Suggest update below this |
| `app.<customer\|merchant\|captain>.update_message` | — | G | OWN | Update screen text |
| `app.<customer\|merchant\|captain>.maintenance` | false | G | OWN | Maintenance mode and message |

Pricing data (delivery fee rules, captain pay tables, peak bonus windows) and exchange rates are managed in their own screens (§9.12, §9.10.4), not as plain settings.
