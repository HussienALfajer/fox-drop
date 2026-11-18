# packages/core_maps

The map of the three Flutter apps (architecture §7.2, §11.2) on `maplibre_gl`, drawing the one style served from our own storage (`docs/runbooks/maps.md`). Slice 2.29a: the customer's pin; 2.29b adds the captain's markers and route line.

## Layout

- `geo_point.dart`: `GeoPoint`, a point in degrees, and `metresTo` (great-circle metres). The apps' one point type.
- `map_camera.dart`: `MapCamera` (the centre and the zoom), `pinZoom` (16, fixed) and `pinConfirmable` (CU §7.1).
- `map_style.dart`: `mapStyleUrl(apiBaseUrl, debug:)`: `--dart-define=MAP_STYLE_URL`, else `/maps/style.json` on the API's host, or on port 8089 (compose's `maps` service) in a debug build against a plain-HTTP (development) API. The iOS Simulator reaches the development machine at `localhost`, while `.env.example`'s `MAPS_URL` names the Android emulator's `10.0.2.2`: publish with `MAPS_URL=http://localhost:8089/maps` for it.
- `pin_map.dart`: `PinMapBuilder`, a map under a fixed centre pin reporting each camera, and `maplibrePinMap(styleUrl)`, the real one.
- `route_view.dart`: `RouteView` (the markers, `MapMarker` of a `MapMarkerKind`: captain, restaurant or destination, and the route line or null), `GeoBounds.around` (the box the map first fits, at least `minSpan` degrees a side).
- `route_map.dart`: `RouteMapBuilder`, a map of a `RouteView` with no fixed pin (CA §9.2, §9.5, CU §11.3), and `maplibreRouteMap(styleUrl)`, the real one: fitted to the view's bounds when the style loads and once more when the captain first appears (a phone without a fix yet), then a new view (the captain moved) redraws the markers and the line without moving the camera, so the reader's pan stays.

## Rules

- **Logic apart from the widget:** the rules (the pin's zoom, the style's address) are plain Dart with tests; the MapLibre widget only draws and reports the camera. An app holds its `PinMapBuilder` in a provider so its widget tests draw a fake that reports cameras (the customer app's `pinMapProvider`).
- **One style, our own host (§7.2):** the apps never name a tile, glyph or sprite host; the style does, and it names only `/maps/` on the environment's host. No API key and no outside map provider.
- **Tile cache:** MapLibre's ambient cache on the phone keeps what it read for as long as its `Cache-Control` says (a year for a build's files, 5 minutes for the style), so the map opens from the cache after the first time.
- **Unstyled until the design (owner decision 2026-11-18):** the pin is Flutter's `Icons.location_pin` at the default colour; the route map's markers are MapLibre's default circles and its line MapLibre's default line, the captain alone in the theme's primary colour to read apart from the pin; the design system replaces them.
- **Google Maps for display only** is allowed later on the customer's pin screen if the field check of CU §18 item 3 finds OSM clearly weaker: it would be another `PinMapBuilder`, the screens unchanged.
