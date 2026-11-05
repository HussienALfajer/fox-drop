# 7. Maps, routing and location

> Part of the [technology stack](README.md). A bare "§n" here means §n of the technology stack.

## 7.1 Routing: OSRM, self-hosted

- **OSRM** with the OpenStreetMap extract for Syria, rebuilt weekly from fresh OSM data. V1 routes over Azaz's region only, about 20 km around the city, cut from that extract (owner decision 2026-11-06, `infra/osrm/cut.sh`); widen the region before adding a city.
- Used for: road distance for the delivery fee (AP §9.12.3), the ETA, the captain route line, and the distance matrix in dispatch.
- Profiles: car and motorbike (on the car profile with adjusted speeds), bicycle, walking.
- Fallback when OSRM does not answer: straight line × 1.3 (fixed, AP §9.12.3). The same fallback when OSRM answers that there is no route between the points (owner decision 2026-11-06).
- OSRM is reached only through the server, never from an app.
- This closes AP §13 item 8.

## 7.2 Map display: MapLibre with OpenStreetMap tiles

- **MapLibre GL JS** on the web and **`maplibre_gl`** in Flutter, with vector tiles built from OpenStreetMap (Protomaps PMTiles in the object storage on FOX DROP's domain (§5.8), or OpenFreeMap if it is reachable from Syria).
- No per-view billing, one style shared by all products, Arabic labels.
- **Field check before launch (CU §18 item 3):** compare the OSM map of Azaz's neighbourhoods with Google Maps. If OSM is clearly weaker, the customer pin screen MAY use Google Maps for display only, behind the same map interface in `core_maps` (§11.2).
- Navigation is handed to Google Maps or Apple Maps (CA §4.6).
- Place search is not required in V1: customers set a pin and a landmark (CU §7.3).

## 7.3 Location data

- Captain positions arrive every 10 s while online (CA §4.3), are written to Valkey for dispatch and published to the map channel, and are written in batches to a partitioned `captain_locations` table for routes and disputes.
- History is kept for 90 days, then aggregated. Positions are never collected while offline (CA §4.3).
- Customer device positions are not stored with orders (CU §4.4).
