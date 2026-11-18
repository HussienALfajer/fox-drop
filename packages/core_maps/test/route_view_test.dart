import 'package:core_maps/core_maps.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const restaurant = GeoPoint(36.587, 37.046);
  const pin = GeoPoint(36.59, 37.05);
  const captain = GeoPoint(36.5875, 37.047);

  group('GeoBounds.around', () {
    test('holds every point', () {
      final bounds = GeoBounds.around([restaurant, pin, captain], minSpan: 0);
      expect(bounds, const GeoBounds(restaurant, pin));
    });

    test('opens one point to the minimum span around it', () {
      final bounds = GeoBounds.around([pin], minSpan: 0.004);
      expect(bounds.southwest.latitude, closeTo(36.588, 1e-9));
      expect(bounds.northeast.latitude, closeTo(36.592, 1e-9));
      expect(bounds.southwest.longitude, closeTo(37.048, 1e-9));
      expect(bounds.northeast.longitude, closeTo(37.052, 1e-9));
      expect(bounds.centre, pin);
    });

    test('refuses no points', () {
      expect(() => GeoBounds.around([]), throwsArgumentError);
    });
  });

  test('RouteView fits its markers and the whole line', () {
    const view = RouteView(
      markers: [
        MapMarker(MapMarkerKind.captain, captain),
        MapMarker(MapMarkerKind.destination, pin),
      ],
      line: [captain, GeoPoint(36.586, 37.049), pin],
    );
    expect(
      view.bounds,
      GeoBounds.around([captain, pin, const GeoPoint(36.586, 37.049)]),
    );
    expect(
      view,
      const RouteView(
        markers: [
          MapMarker(MapMarkerKind.captain, captain),
          MapMarker(MapMarkerKind.destination, pin),
        ],
        line: [captain, GeoPoint(36.586, 37.049), pin],
      ),
    );
    expect(
      view == const RouteView(markers: [MapMarker(MapMarkerKind.captain, pin)]),
      isFalse,
    );
  });
}
