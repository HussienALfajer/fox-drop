# geo module

Cities (AP §9.12.1), distances (architecture §7.1), service zones and the delivery fee (AP §9.12.2–9.12.3).

## Rules

- **Distances:** `GeoService.distance(from, to, { vehicle })` returns whole metres and how they were measured: `road` (OSRM) or `straight_x1.3`. Points are `{ latitude, longitude }` in degrees; one outside ±90 and ±180, or not a number, throws a `RangeError`, so the routes validate the points they take. Never call OSRM from another module or an app.
- **Fallback (AP §9.12.3):** the straight line (haversine) × 1.3, a fixed factor, when OSRM fails, takes longer than 1 second or has no server for the vehicle, and when it answers that there is no route between the points (owner decision 2026-11-06). It is also the only method when `pricing.distance_method` is `straight_line`, which never calls OSRM. Every fallback logs a warning with the vehicle; never log the points, since a delivery point is personal data.
- **The port:** `RoadDistances` (`distance.ts`), injected as `ROAD_DISTANCES`. The server's adapter is `OsrmRoadDistances`; tests replace it with a fake (`overrideProvider(ROAD_DISTANCES)`), or point it at a local HTTP server.
- **OSRM:** one `osrm-routed` per vehicle profile (car, motorbike, bicycle, walking), at `OSRM_CAR_URL`, `OSRM_MOTORBIKE_URL`, `OSRM_BICYCLE_URL` and `OSRM_WALKING_URL`. An unset URL makes that vehicle fall back, with a warning at start; the tests and the OpenAPI generation set none. The data covers Azaz's region only (owner decision 2026-11-06; `infra/osrm/cut.sh`), so a point outside it gets a poor road distance: widen the region before adding a city.
- **Profiles (`infra/osrm/`):** OSRM's own car, bicycle and foot profiles, and `motorbike.lua`, the car profile with placeholder motorbike speeds until the ETA is tuned.
- **Zones (AP §9.12.2):** `geo.zones` holds each neighbourhood's polygon (`geometry(Polygon,4326)`, GiST-indexed, valid by a `CHECK`), its name, unique in its city, and whether it is active. `createZone` takes the corners in order and closes the ring; an outline that crosses itself or has fewer than three corners is `invalid_area`, a repeated name `zone_name_taken`. Polygons are written and read through PostGIS SQL only, never as JavaScript values.
- **The zone check (CU §7.1):** `zoneAt(cityId, point)` returns the active zone that covers the point, its edge included, or null outside every active zone; where two overlap, the smaller one. Whether a restaurant covers the point is the restaurants' coverage (slice 1.5), not a zone.
- **The delivery fee (AP §9.12.3; owner decisions 2026-11-06):** geo owns the fee rule. `geo.fee_rules` and `geo.fee_bands` are versions, never updated: `setDeliveryFeeRule` adds one in effect at once, and one that charges the same as the current rule adds nothing. A rule is «ثابت» (`flat`) or «شرائح مسافة» (`distance_bands`); each band includes its upper edge in metres and the last has none, so every distance has a fee. Then the minimum fee raises a lower fee, and an items value at or above the free-delivery threshold pays 0. The pure rules are in `delivery-fee.ts`.
- **Fee distance:** `deliveryFee(cityId, { from, to, itemsValue })` measures a distance-band fee by the motorbike's distance (`GeoService.distance`, so `pricing.distance_method` and the fallback apply), before any captain is known; a flat rule measures nothing. It returns the rule version it priced with, for the quote.
- **Money:** amounts are `bigint` minor units in the city's base currency (AP §8.6). `setDeliveryFeeRule` checks the currency under `lockCityCurrencies`, and geo registers its rule with `FxService.useCityAmounts`, so fx refuses a base change while the rule is in another currency (`amounts_in_other_currency`). The audit log keeps the amounts as strings.
- **Every change** of a zone or a fee rule is audited in its transaction (`zone.create`, `delivery_fee_rule.set`).
- **Locally:** `docker compose run --rm osrm-build`, then `docker compose --profile osrm up --detach` (root `compose.yaml`). On staging one shared OSRM project serves every environment and rebuilds weekly (`infra/CLAUDE.md`).

## Not yet

- `pricing.distance_method` is the fee's setting (AP §9.12.3), and the delivery estimate follows it too (`trip_min`, `docs/domain/03-timers.md`). When dispatch uses distances, decide with the owner whether it follows it.
- Durations (the ETA), the route line and the distance matrix (OSRM `table`) for dispatch join with their slices.
- Per-restaurant fee overrides join with the restaurants (slice 1.5); votes from outside the zones (CU §7.2) with the customer app (slice 1.7); editing and deactivating a zone, the fee screen, its preview calculator and the vote map with the panel's zones and pricing screen.
