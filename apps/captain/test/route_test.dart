import 'package:captain/src/work/location.dart';
import 'package:captain/src/work/route.dart';
import 'package:core_auth/testing.dart';
import 'package:core_maps/core_maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

// CA §4.6, §9.2, §9.5 (slice 2.29b): the map with the route and the ETA in
// steps 1 and 3, the route read once per leg.
Map<String, Object?> routeJson(
  String leg,
  ({double latitude, double longitude}) to, {
  int seconds = 250,
  bool line = true,
}) => {
  'leg': leg,
  'destination': {'latitude': to.latitude, 'longitude': to.longitude},
  'route': {
    'metres': 1200,
    'seconds': seconds,
    'method': line ? 'road' : 'straight_x1.3',
    'line': line
        ? [
            {'latitude': 36.59, 'longitude': 37.05},
            {'latitude': to.latitude, 'longitude': to.longitude},
          ]
        : null,
  },
};

void main() {
  test('legView marks the destination and the captain at the latest fix', () {
    const destination = GeoPoint(36.586, 37.044);
    const line = [GeoPoint(36.59, 37.05), destination];
    final view = legView(
      destinationKind: MapMarkerKind.restaurant,
      destination: destination,
      fix: Fix(
        latitude: 36.59,
        longitude: 37.05,
        accuracyMetres: 8,
        recordedAt: DateTime.utc(2026, 11, 7, 12),
        simulated: false,
      ),
      route: LegRoute(arriveAt: DateTime.utc(2026, 11, 7, 12, 5), line: line),
    );
    expect(view.markers, const [
      MapMarker(MapMarkerKind.restaurant, destination),
      MapMarker(MapMarkerKind.captain, GeoPoint(36.59, 37.05)),
    ]);
    expect(view.line, line);
    // Without a fix or a route: the destination alone, no line.
    expect(
      legView(
        destinationKind: MapMarkerKind.destination,
        destination: destination,
        fix: null,
        route: null,
      ),
      const RouteView(
        markers: [MapMarker(MapMarkerKind.destination, destination)],
      ),
    );
  });

  testWidgets('step 1 maps the route to the restaurant with its ETA, step 3 '
      'to the pin, each read once', (tester) async {
    final app = TestApp();
    app.work(
      availability: [availabilityJson(state: 'busy')],
      orders: [orderJson()],
    );
    final path = '/v1/captain/orders/$orderId/route';
    app.server.on(path, [
      FakeAnswer(200, routeJson('to_restaurant', restaurant)),
    ]);
    await app.pump(tester);
    await app.live(tester);
    expect(find.byKey(const Key('route-map')), findsOneWidget);
    expect(find.text('الوصول حوالي 3:04 م'), findsOneWidget);
    expect(app.mapViews.last.markers.first.kind, MapMarkerKind.restaurant);
    expect(app.mapViews.last.line, hasLength(2));
    expect(find.text('ابدأ الملاحة'), findsOneWidget);

    // The captain moves: the map follows the fix, the route is not read
    // again.
    app.location.move(pin);
    await app.settle(tester);
    expect(
      app.mapViews.last.markers.last,
      MapMarker(MapMarkerKind.captain, GeoPoint(pin.latitude, pin.longitude)),
    );
    expect(app.server.to(path), hasLength(1));

    // Picked up: the leg to the pin, without a line when OSRM is down.
    app.server.on(path, [
      FakeAnswer(200, routeJson('to_customer', pin, seconds: 600, line: false)),
    ]);
    app.work(
      availability: [availabilityJson(state: 'busy')],
      orders: [
        orderJson(status: 'picked_up', track: 'picked_up', pickedUp: true),
      ],
    );
    app.transport.event('order.picked_up', 9);
    await app.settle(tester);
    expect(find.text('الخطوة 3 من 4: إلى الزبون'), findsOneWidget);
    expect(find.text('الوصول حوالي 3:10 م'), findsOneWidget);
    expect(app.mapViews.last.markers.first.kind, MapMarkerKind.destination);
    expect(app.mapViews.last.line, isNull);
    expect(app.server.to(path), hasLength(2));
    await app.done(tester);
  });

  testWidgets('a failed read leaves the map without a line or a time, and '
      'reads again 30 seconds later', (tester) async {
    final app = TestApp();
    app.work(
      availability: [availabilityJson(state: 'busy')],
      orders: [orderJson()],
    );
    app.server.on('/v1/captain/orders/$orderId/route', [
      const FakeAnswer(500, {}),
    ]);
    await app.pump(tester);
    await app.live(tester);
    expect(find.byKey(const Key('route-map')), findsOneWidget);
    expect(find.textContaining('الوصول حوالي'), findsNothing);
    expect(app.mapViews.last.line, isNull);

    app.server.on('/v1/captain/orders/$orderId/route', [
      FakeAnswer(200, routeJson('to_restaurant', restaurant)),
    ]);
    await tester.pump(legRetry);
    await app.settle(tester);
    expect(app.server.to('/v1/captain/orders/$orderId/route'), hasLength(2));
    expect(app.mapViews.last.line, hasLength(2));
    await app.done(tester);
  });
}
