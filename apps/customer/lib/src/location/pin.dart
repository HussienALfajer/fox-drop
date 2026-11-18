import 'package:core_maps/core_maps.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';

/// The map under the fixed pin (`packages/core_maps`); tests draw a fake.
final pinMapProvider = Provider<PinMapBuilder>(
  (ref) => maplibrePinMap(mapStyleUrl(apiBaseUrl(), debug: kDebugMode)),
);

/// Where the map opens when no point is known yet: Azaz's centre, the city
/// of V1 (CU §1).
const cityCentre = GeoPoint(36.5866, 37.0463);

/// The first location's map shows the city, so the customer zooms in to
/// their street (CU §7.1); adjusting a known point starts at street level.
const cityZoom = 14.0;
const streetZoom = 17.0;

/// The pin screen's path, opening at [camera]; it answers the confirmed
/// point, or null when the customer goes back.
String pinPath(MapCamera camera) => Uri(
  path: '/pin',
  queryParameters: {
    'lat': '${camera.centre.latitude}',
    'lng': '${camera.centre.longitude}',
    'zoom': '${camera.zoom}',
  },
).toString();

/// The camera [pinPath] names; the city when it names none.
MapCamera pinCameraOf(Map<String, String> query) {
  final latitude = double.tryParse(query['lat'] ?? '');
  final longitude = double.tryParse(query['lng'] ?? '');
  final zoom = double.tryParse(query['zoom'] ?? '');
  if (latitude == null || longitude == null || zoom == null) {
    return const MapCamera(cityCentre, cityZoom);
  }
  return MapCamera(GeoPoint(latitude, longitude), zoom);
}
