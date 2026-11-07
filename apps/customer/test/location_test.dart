import 'package:core_auth/testing.dart';
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
}
