# 9.12 Zones and pricing «المناطق والتسعير»

> Part of the [admin panel spec](../README.md) (AP). A bare "§n" here means AP §n.

## 9.12.1 Cities «المدن» (OWN)

- **Fields:**
  - name and city code (used in receipts)
  - time zone (default `Asia/Damascus`)
  - **base currency** (D25; locked after the first order)
  - accepted currencies, with their rates and rounding (§8.6)
  - business-day cutoff
  - office location (a map pin) and desk hours, shown to captains (captain-app spec C13) and to customers blocked for dues (customer-app spec Q21)
  - platform hours (`platform.hours`, default 24/7, D9)
  - status (active or not)

## 9.12.2 Service zones «مناطق الخدمة»

- Draw polygons on the map, name each one (neighbourhood), and activate or deactivate it.
- A customer outside every active zone sees «قريباً في منطقتك» (coming soon to your area) and a vote button.
- **Votes from outside the zones** appear as dots or a heatmap, to guide expansion.

## 9.12.3 Delivery fees «رسوم التوصيل» (OWN)

- **Rule type:**
  - «ثابت» (flat): one fee for every order.
  - «شرائح مسافة» (distance bands): for example 0–2 km = X, 2–4 km = Y, and so on.
- **Also:**
  - a minimum fee
  - an optional free-delivery threshold, compared with the items value (for example free delivery for orders of 500 or more)
  - per-restaurant overrides
- **Distance:** `pricing.distance_method` (default `road`, using the routing service, with straight-line × 1.3 (fixed) as a fallback).
- **Preview calculator:** pick a restaurant and a point on the map to see the fee the customer would pay.
- Fees are published: the customer sees the fee on the restaurant page before ordering.

## 9.12.4 Defaults

- `merchant.default_commission_pct` (15%, OWN)
- `merchant.default_min_order`
- `merchant.default_prep_min` (20)
- `captain.custody_limit_suggested.<vehicle>`

## 9.12.5 Captain pay «أجور الكباتن» (OWN; effective-dated)

For each vehicle type (motorbike, car, bicycle or e-bike, walking):

- base pay, which includes the first N km
- a rate per extra km
- a waiting rate per minute after `captain.waiting_threshold_min` (10)
- a minimum pay per order
- the maximum distance allowed (`dispatch.max_distance_km.<vehicle>`)

**Effective date:** any change to the pay table takes effect no earlier than 7 days after it is published, a **fixed** policy. Captains get an automatic announcement and see the new table in the app. A preview calculator shows the pay for a sample trip.

**Peak-hour bonus «مكافأة ساعة الذروة» (D15, disabled by default):**

- On/off switch, off by default.
- Windows: days of the week and hours, for example 20:00–22:00.
- Amount per delivered order inside a window, optionally limited to zones. The window is matched on the delivery time and the restaurant's zone (§8.4).
- Enabling or raising the bonus can take effect immediately. Lowering or disabling an announced bonus takes effect at the end of the current announced window.
- Captains see the active windows in the app.

## 9.12.6 Dispatch rules (OWN; OPS can only switch the mode)

- **Mode:** `dispatch.mode`:
  - «يدوي» (manual) at launch (D6)
  - «آلي» (automatic)
  - «مختلط» (mixed): automatic, then manual after `dispatch.max_offers_before_manual` (5) failed offers or the no-captain alert
- **Eligibility:**
  - online and active
  - no active order (no stacking in V1)
  - custody under the cash limit
  - not blocked for unhanded cash, and not past `captain.remit_online_grace_hours` since a cutoff with `closed_due` still open (§8.5.4)
  - within `dispatch.search_radius_km` (3) of the restaurant
  - vehicle allowed for the trip distance
  - the order's pickup payment is not above the captain's maximum pickup amount, when the captain set one (captain-app spec C4). The capacity check below ignores this condition, so a large order is never refused only because of it.
- **Ranking:** nearest to the restaurant first; on a tie, fewest orders today.
- **Offers:** one captain at a time, for `dispatch.offer_timeout_sec` (45). Every offer and response is logged. After `captain.offer_expiry_offline_count` (3) consecutive expired offers, the captain is set offline (§9.7.6).
- **Search start:** when the remaining prep time is no more than the nearest eligible captain's ETA to the restaurant plus `dispatch.search_start_buffer_min` (5). If that is already true at acceptance, the search starts immediately. The moment is computed in every mode; in manual mode it raises «بحاجة لتعيين» instead of sending offers (§8.3).
- **Capacity check** (`dispatch.capacity_check`, on): if no eligible captain is within range when the customer places the order, the order is not accepted. The customer sees «الضغط عالٍ الآن، جرّب بعد دقائق» (busy right now, try again in a few minutes). The customer app runs this check in every quote, so the refusal is logged as lost demand once per customer checkout session (customer-app spec §10.6).
