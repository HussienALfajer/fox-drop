# geo module

Cities (AP §9.12.1), distances (architecture §7.1), service zones and the delivery fee (AP §9.12.2–9.12.3).

## Rules

- **Distances only through `GeoService`:** `distance`, `distancesTo` and `route` return whole metres. Never call OSRM from another module or an app. Points are `{ latitude, longitude }` in degrees; an out-of-range or non-numeric point throws `RangeError`, so routes validate the points they take.
- **Fallback (AP §9.12.3):** the straight line (haversine) x 1.3 when OSRM fails, takes over 1 second, has no server for the vehicle or no route; also the only method when `pricing.distance_method` is `straight_line`. Log a warning with the vehicle; never log the points (a delivery point is personal data).
- **The port:** OSRM is behind `RoadDistances` (`distance.ts`, token `ROAD_DISTANCES`); tests replace it with a fake (`overrideProvider(ROAD_DISTANCES)`). An unset `OSRM_*_URL` makes that vehicle fall back. The data covers Azaz's region only: widen it before adding a city.
- **Zones:** polygons are written and read through PostGIS SQL only, never as JavaScript values. Active zones never overlap (sharing an edge is allowed). Changes of a city's zones take turns on an advisory lock.
- **Audit every change** of a zone, a city, the office or a fee rule in its transaction (`zone.create`, `zone.update`, `city.update`, `city.office`, `delivery_fee_rule.set`, `restaurant_fee_rule.set`); write only what changed, and a change that changes nothing records nothing.
- **Versions, never updates:** fee rules and bands (the city's and a restaurant's own, in tables of their own) and the office's periods are inserted, never updated; the newest is in force.
- **Money:** fee amounts are `bigint` minor units in the city's base currency (AP §8.6). `deliveryFee` refuses a rule outside the current base (`fee_not_in_base_currency`). `setDeliveryFeeRule` checks the currency under `lockCityCurrencies`, and geo registers its rule with `FxService.useCityAmounts` so fx refuses a base change while the rule is in another currency. The audit log keeps amounts as strings.
- **The fee rule:** a distance on a band's edge takes the lower fee; the minimum fee raises a lower fee; an items value at or above the free-delivery threshold pays 0. The items value is after the restaurant's item discounts (docs/domain/04). The pure rules are in `delivery-fee.ts`.
- **Admin routes** that set a value take no `Idempotency-Key`. `GET /v1/admin/cities` is `@SignedIn()` (the city selector); the other city, zone and office routes use `zones.read` and `zones.manage`.
- **Shared pure code:** `weekly-hours.ts` (restaurant hours, platform hours, the office), `delivery-estimate.ts`, `business-day.ts`; reuse them instead of writing new week or cutoff logic.
- **Time zones:** a city's clock is `cityTimeZone(cityId)`; business-day cutoffs are computed with the offset in force then.
- **Locally:** `docker compose run --rm osrm-build`, then `docker compose --profile osrm up --detach`.

## More

Behaviour, decisions and history: `docs/code/apps/server/src/modules/geo.md`. Grep it for what you change; never read it whole.
