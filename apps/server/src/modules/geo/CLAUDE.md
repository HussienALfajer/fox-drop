# geo module

Cities (AP §9.12.1) and distances (architecture §7.1); zones join with slice 1.4.

## Rules

- **Distances:** `GeoService.distance(from, to, { vehicle })` returns whole metres and how they were measured: `road` (OSRM) or `straight_x1.3`. Points are `{ latitude, longitude }` in degrees. Never call OSRM from another module or an app.
- **Fallback (AP §9.12.3):** the straight line (haversine) × 1.3, a fixed factor, when OSRM fails, takes longer than 1 second, finds no route or has no server for the vehicle. It is also the only method when `pricing.distance_method` is `straight_line`, which never calls OSRM. Every fallback logs a warning with the vehicle; never log the points, since a delivery point is personal data.
- **The port:** `RoadDistances` (`distance.ts`), injected as `ROAD_DISTANCES`. The server's adapter is `OsrmRoadDistances`; tests replace it with a fake (`overrideProvider(ROAD_DISTANCES)`), or point it at a local HTTP server.
- **OSRM:** one `osrm-routed` per vehicle profile (car, motorbike, bicycle, walking), at `OSRM_CAR_URL`, `OSRM_MOTORBIKE_URL`, `OSRM_BICYCLE_URL` and `OSRM_WALKING_URL`. An unset URL makes that vehicle fall back, with a warning at start; the tests and the OpenAPI generation set none. The data covers Azaz's region only (owner decision 2026-11-06; `infra/osrm/cut.sh`), so a point outside it gets a poor road distance: widen the region before adding a city.
- **Profiles (`infra/osrm/`):** OSRM's own car, bicycle and foot profiles, and `motorbike.lua`, the car profile with placeholder motorbike speeds until the ETA is tuned.
- **Locally:** `docker compose run --rm osrm-build`, then `docker compose --profile osrm up --detach` (root `compose.yaml`). On staging one shared OSRM project serves every environment and rebuilds weekly (`infra/CLAUDE.md`).

## Not yet

- `pricing.distance_method` is the fee's setting (AP §9.12.3). When dispatch and the ETA use distances, decide with the owner whether they follow it too.
- Durations (the ETA), the route line and the distance matrix (OSRM `table`) for dispatch join with their slices; which vehicle's distance the delivery fee uses is decided with the fees (slice 1.4).
