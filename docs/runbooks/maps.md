# The map

The run book of the map's tiles (slice 2.29a, architecture §7.2): Azaz's OpenStreetMap vector tiles, the style, the glyphs and the sprite, served from our own storage on FOX DROP's domain, so the phones reach no outside host at run time. Operating the server is in the `deploy` skill; this page lists what the map needs.

## How it is served

- **Storage:** the `public-maps` bucket of each environment's Garage, which the storage setup creates on every deploy with website access (no other bucket has it). Only the server's key writes it; nothing reads it with a key.
- **Address:** `https://<host>/maps/` on every host of the environment (staging: `https://foxdrop-staging-api.109-199-111-169.sslip.io/maps/style.json`). nginx sends `GET` to Garage's website endpoint (`MAPS_PORT`, 3116 on staging) with `Host: public-maps`, range requests included; any other method is `403`.
- **Layout:** `style.json` (cached 5 minutes) names the newest build's folder, `<YYYYMMDD>/`, which holds `region.pmtiles`, `fonts/<font stack>/<range>.pbf` and `sprites/light[@2x].{json,png}` (cached a year: a build's folder never changes). Older builds stay in the bucket; each is a few megabytes.
- **Style:** `infra/maps/style.json`, Protomaps' light basemap with Arabic labels (`name:ar`, then the local name), written by `pnpm --filter @fox-drop/infra maps:style` from the pinned `@protomaps/basemaps`; `infra.test.mjs` fails when it is stale or names another host.
- **Region:** the bounding box of OSRM's region (`infra/osrm/cut.sh`), about 20 km around Azaz; a test keeps the two equal. Widen both before adding a city.

## Building and publishing

As root on the server, with the environment's current release:

```bash
foxdrop-maps-build staging
```

It builds the `maps-build` image (`infra/maps/Dockerfile`: the pmtiles CLI and curl), runs `infra/maps/build.sh` into the `maps-data` volume, then `maps-publish` (the server image) uploads it to `public-maps` and writes the environment's address into the style, last. The build downloads the region from the newest Protomaps daily build (`build.protomaps.com`, by range requests, a few megabytes) and the glyphs and sprite from `github.com/protomaps/basemaps-assets`; it fails, leaving the published map as it was, when the glyphs have no Arabic block. `provision.sh` runs it once with `--if-missing`; run it again by hand to refresh the map from newer OpenStreetMap data (no timer: the map of a town changes slowly).

In development: `docker compose run --rm maps-build` (into `.maps/`), then `pnpm --filter @fox-drop/server maps:publish`; the compose `maps` service serves it at `http://127.0.0.1:8089/maps/` (the Android emulator: `10.0.2.2:8089`).

## Checking

```bash
curl --silent --range 0-15 --output /dev/null --write-out '%{http_code}\n' "https://foxdrop-staging-api.109-199-111-169.sslip.io/maps/$(curl --silent https://foxdrop-staging-api.109-199-111-169.sslip.io/maps/style.json | grep -o '[0-9]\{8\}/region.pmtiles' | head -1)"
```

answers `206`. On a phone, the customer app's pin screen («اختر على الخريطة») shows Azaz's streets with Arabic names.

## Before launch

- **The field check (CU §18 item 3):** compare the OSM map of Azaz's neighbourhoods with Google Maps. If OSM is clearly weaker, the customer pin screen may use Google Maps for display only, behind `core_maps` (architecture §7.2).
- The map's requests count against the site's general rate limit (`limit_req zone=general burst=50`); watch for `503` on `/maps/` while panning, and give `/maps/` its own zone if they appear.
