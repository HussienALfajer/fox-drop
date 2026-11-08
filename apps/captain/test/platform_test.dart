import 'package:captain/src/platform.dart';
import 'package:core_realtime/core_realtime.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

// CA §4.2, §4.8: the update and maintenance screens never interrupt a
// current order.
void main() {
  testWidgets('maintenance blocks an offline captain', (tester) async {
    final app = TestApp();
    app.platform(maintenance: true);
    app.work(availability: [availabilityJson()]);
    await app.pump(tester);
    await app.live(tester);
    expect(find.text('التطبيق في صيانة'), findsOneWidget);
    expect(find.text('غير متصل'), findsNothing);
    await app.done(tester);
  });

  testWidgets('maintenance keeps the current order on screen', (tester) async {
    final app = TestApp();
    app.platform(maintenance: true);
    app.work(
      availability: [availabilityJson(state: 'busy')],
      orders: [orderJson()],
    );
    await app.pump(tester);
    await app.live(tester);
    expect(find.text('التطبيق في صيانة'), findsNothing);
    expect(find.text('الخطوة 1 من 4: إلى المطعم'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('a required update blocks only once the captain is offline', (
    tester,
  ) async {
    final app = TestApp();
    app.platform(updateNeed: 'required');
    app.work(availability: [availabilityJson(state: 'online_available')]);
    await app.pump(tester);
    await app.live(tester);
    expect(find.text('متصل متاح'), findsOneWidget);
    expect(
      app.server
          .to('/v1/captain/platform')
          .first
          .uri
          .queryParameters['version'],
      '0.1.0',
    );

    app.work(availability: [availabilityJson()]);
    app.container.read(platformCheckProvider);
    await app.live(tester);
    expect(find.text('يلزم تحديث التطبيق'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('maintenance leaves an online captain their offers and switch', (
    tester,
  ) async {
    final app = TestApp();
    app.platform(maintenance: true);
    app.work(availability: [availabilityJson(state: 'online_available')]);
    await app.pump(tester);
    await app.live(tester);
    expect(find.text('التطبيق في صيانة'), findsNothing);
    expect(find.text('متصل متاح'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('checks again when the channel comes back (CA §4.2)', (
    tester,
  ) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    await app.pump(tester);
    await app.live(tester);
    final before = app.server.to('/v1/captain/platform').length;
    app.transport.send(captainChannel, const RealtimeDown());
    await app.settle(tester);
    await app.live(tester);
    expect(app.server.to('/v1/captain/platform').length, before + 1);
    await app.done(tester);
  });
}
