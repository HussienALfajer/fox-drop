import 'package:core_auth/testing.dart';
import 'package:core_maps/core_maps.dart';
import 'package:customer/src/location/pin.dart';
import 'package:customer/src/location/position.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';
import 'support.dart';

TestApp _app(FakePositionSource position, {String state = 'served'}) {
  final app = TestApp(
    overrides: [positionSourceProvider.overrideWithValue(position)],
  );
  app.server.on('/v1/customer/location', [
    FakeAnswer(200, {
      'state': state,
      'zone': state == 'outside_zones'
          ? null
          : {
              'id': '00000000-0000-4000-8000-0000000000a1',
              'name': 'الحي الشمالي',
            },
    }),
  ]);
  app.server.on('/v1/customer/restaurants', [
    const FakeAnswer(200, {'restaurants': <Object>[]}),
  ]);
  return app;
}

void main() {
  test('distances between two points', () {
    const north = GeoPoint(36.5952, 37.0463);
    expect(azaz.metresTo(north), closeTo(1000, 5));
    expect(azaz.metresTo(azaz), 0);
  });

  testWidgets('the phone\'s position is checked against the zones', (
    tester,
  ) async {
    final position = FakePositionSource();
    final app = _app(position);
    await app.pump(tester);
    await tester.tap(find.text('استخدم موقعي الحالي'));
    await tester.pumpAndSettle();

    final check = app.server.to('/v1/customer/location').single;
    expect(check.uri.queryParameters, {
      'latitude': '${azaz.latitude}',
      'longitude': '${azaz.longitude}',
    });
    expect(position.calls.single.ask, isTrue);
    expect(find.widgetWithText(TextButton, 'الحي الشمالي'), findsOneWidget);
  });

  testWidgets('no restaurant covers the point', (tester) async {
    final app = _app(FakePositionSource(), state: 'no_restaurants');
    await app.pump(tester);
    await tester.tap(find.text('استخدم موقعي الحالي'));
    await tester.pumpAndSettle();

    expect(find.text('لا توجد مطاعم توصل إلى موقعك حالياً'), findsOneWidget);
  });

  testWidgets('outside every zone, the customer votes for the area', (
    tester,
  ) async {
    final app = _app(FakePositionSource(), state: 'outside_zones');
    app.server.on('/v1/customer/zone-votes', [
      const FakeAnswer(200, {'status': 'recorded'}),
    ]);
    await app.pump(tester);
    await tester.tap(find.text('استخدم موقعي الحالي'));
    await tester.pumpAndSettle();
    expect(find.text('قريباً في منطقتك'), findsOneWidget);
    await tester.tap(find.text('صوّت لمنطقتك'));
    await tester.pumpAndSettle();

    final vote = app.bodyOf('/v1/customer/zone-votes');
    expect(vote['location'], {
      'latitude': azaz.latitude,
      'longitude': azaz.longitude,
    });
    expect(vote['deviceId'], app.secure.values['device.id']);
    expect(find.text('شكراً، سنخبرك عندما نصل إلى منطقتك'), findsOneWidget);
  });

  testWidgets('says why there is no position', (tester) async {
    final position = FakePositionSource((
      fix: null,
      failure: PositionFailure.denied,
    ));
    final app = _app(position);
    await app.pump(tester);
    await tester.tap(find.text('استخدم موقعي الحالي'));
    await tester.pumpAndSettle();
    expect(
      find.text('اسمح للتطبيق بالوصول إلى موقعك لنعرف أين نوصل طلبك.'),
      findsOneWidget,
    );
    expect(app.server.to('/v1/customer/location'), isEmpty);

    position.result = (fix: const PositionFix(azaz, 12), failure: null);
    await tester.tap(find.text('حاول مجدداً'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextButton, 'الحي الشمالي'), findsOneWidget);
  });

  group('the pin on the map (CU §7.1)', () {
    const street = GeoPoint(36.5901, 37.0412);

    testWidgets('confirms only at zoom 16 or closer, then checks the zone', (
      tester,
    ) async {
      final position = FakePositionSource();
      final app = _app(position);
      await app.pump(tester);
      await tester.tap(find.text('اختر على الخريطة'));
      await tester.pumpAndSettle();

      // The first location opens on the city, too far to confirm.
      expect(app.pinMap.initial, const MapCamera(cityCentre, cityZoom));
      expect(find.text('قرّب الخريطة لتحديد موقعك بدقة'), findsOneWidget);
      final confirm = find.byKey(const Key('confirm-pin'));
      expect(tester.widget<FilledButton>(confirm).onPressed, isNull);

      app.pinMap.move(const MapCamera(street, 15.9));
      await tester.pump();
      expect(tester.widget<FilledButton>(confirm).onPressed, isNull);

      app.pinMap.move(const MapCamera(street, 16));
      await tester.pump();
      expect(find.text('قرّب الخريطة لتحديد موقعك بدقة'), findsNothing);
      await tester.tap(confirm);
      await tester.pumpAndSettle();

      final check = app.server.to('/v1/customer/location').single;
      expect(check.uri.queryParameters, {
        'latitude': '${street.latitude}',
        'longitude': '${street.longitude}',
      });
      expect(position.calls, isEmpty);
      expect(find.widgetWithText(TextButton, 'الحي الشمالي'), findsOneWidget);
    });

    testWidgets('going back keeps the question', (tester) async {
      final app = _app(FakePositionSource());
      await app.pump(tester);
      await tester.tap(find.text('اختر على الخريطة'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      expect(find.text('أين نوصل طلبك؟'), findsOneWidget);
      expect(app.server.to('/v1/customer/location'), isEmpty);
    });

    testWidgets('a refused permission can still choose on the map', (
      tester,
    ) async {
      final app = _app(
        FakePositionSource((fix: null, failure: PositionFailure.denied)),
      );
      await app.pump(tester);
      await tester.tap(find.text('استخدم موقعي الحالي'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('اختر على الخريطة'));
      await tester.pumpAndSettle();
      app.pinMap.move(const MapCamera(street, 17));
      await tester.pump();
      await tester.tap(find.byKey(const Key('confirm-pin')));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextButton, 'الحي الشمالي'), findsOneWidget);
    });

    test('the pin screen opens where its path says, else on the city', () {
      const camera = MapCamera(street, 17);
      final uri = Uri.parse(pinPath(camera));
      expect(uri.path, '/pin');
      expect(pinCameraOf(uri.queryParameters), camera);
      expect(pinCameraOf(const {}), const MapCamera(cityCentre, cityZoom));
    });
  });
}
