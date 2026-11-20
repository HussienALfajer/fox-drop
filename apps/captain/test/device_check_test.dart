import 'dart:convert';

import 'package:captain/src/device_check/device_check.dart';
import 'package:captain/src/device_check/device_check_screen.dart';
import 'package:core_alerts/core_alerts.dart';
import 'package:core_auth/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'fixtures.dart';

// CA §4.5 (slice 2.43): «فحص الجهاز» on Android.
const _good = AndroidReadings(
  notificationsAllowed: true,
  batteryOptimizationOff: true,
  fullScreenAllowed: true,
  alarmVolumePercent: 80,
  doNotDisturbBlocks: false,
  autostartPage: false,
);

const _allowed = PhoneAccess(
  locationAlways: true,
  locationPrecise: true,
  callAllowed: true,
);

Map<String, Object?> checkJson(List<String> failed) => {
  'check': {
    'at': '2026-11-20T09:00:00.000Z',
    'passed': failed.isEmpty,
    'failed': failed,
  },
};

Object? lastBody(TestApp app, String path) {
  final data = app.server.to(path).last.data;
  return data is String ? jsonDecode(data) : data;
}

void main() {
  test('lists what fails in the spec’s order, the confirmed and measured '
      'checks until answered', () {
    const readings = PhoneReadings(
      AndroidReadings(
        notificationsAllowed: false,
        batteryOptimizationOff: true,
        fullScreenAllowed: false,
        alarmVolumePercent: 60,
        doNotDisturbBlocks: true,
        autostartPage: true,
      ),
      PhoneAccess(
        locationAlways: false,
        locationPrecise: true,
        callAllowed: false,
      ),
    );
    expect(failedItems(readings, const CheckAnswers()), [
      CheckItem.notifications,
      CheckItem.location,
      CheckItem.autostart,
      CheckItem.fullScreen,
      CheckItem.alarmVolume,
      CheckItem.doNotDisturb,
      CheckItem.testOffer,
      CheckItem.connection,
      CheckItem.gpsAccuracy,
      CheckItem.call,
    ]);
    const good = PhoneReadings(_good, _allowed);
    expect(
      failedItems(
        good,
        const CheckAnswers(heard: true, delayMs: 120, gpsMetres: 15),
      ),
      isEmpty,
    );
    // K3: worse than 100 metres is weak.
    expect(
      failedItems(
        good,
        const CheckAnswers(heard: true, delayMs: 120, gpsMetres: 140),
      ),
      [CheckItem.gpsAccuracy],
    );
  });

  // CA §4.5's iPhone column (slice 2.46): checks 1 with time-sensitive
  // notifications, 3 as Background App Refresh and Low Power Mode, 5 the
  // ring switch the captain confirms; no 4 or 8.
  test('lists an iPhone’s failed checks', () {
    const readings = PhoneReadings(
      IosReadings(
        notificationsAllowed: true,
        timeSensitiveAllowed: false,
        criticalAlertsAllowed: false,
        backgroundRefreshOn: false,
        lowPowerMode: true,
      ),
      _allowed,
    );
    expect(failedReadings(readings, const CheckAnswers()), [
      CheckItem.notifications,
      CheckItem.backgroundRefresh,
      CheckItem.lowPowerMode,
      CheckItem.ringSwitch,
    ]);
    const good = PhoneReadings(
      IosReadings(
        notificationsAllowed: true,
        timeSensitiveAllowed: true,
        criticalAlertsAllowed: false,
        backgroundRefreshOn: true,
        lowPowerMode: false,
      ),
      PhoneAccess(
        locationAlways: true,
        locationPrecise: true,
        callAllowed: true,
      ),
    );
    expect(
      failedItems(
        good,
        const CheckAnswers(
          ringSwitchConfirmed: true,
          heard: true,
          delayMs: 120,
          gpsMetres: 15,
        ),
      ),
      isEmpty,
    );
    expect(failedReadings(good, const CheckAnswers()), [CheckItem.ringSwitch]);
  });

  testWidgets('shows an iPhone’s checks and sends the ring switch until '
      'confirmed', (tester) async {
    final app = TestApp();
    app.alerts.deviceReadings = const IosReadings(
      notificationsAllowed: true,
      timeSensitiveAllowed: true,
      criticalAlertsAllowed: false,
      backgroundRefreshOn: true,
      lowPowerMode: true,
    );
    app.server.on('/v1/captain/device/check', [
      const FakeAnswer(200, {'check': null}),
      FakeAnswer(200, checkJson(['low_power_mode'])),
    ]);
    app.server.on('/v1/captain/auth/current', [
      const FakeAnswer(200, {
        'accountId': accountId,
        'captainId': captainId,
        'sessionId': '00000000-0000-4000-8000-000000000003',
      }),
    ]);
    app.work(availability: [availabilityJson()]);
    await app.pump(tester);
    await app.live(tester);

    await tester.tap(find.byKey(const Key('online-switch')));
    await app.settle(tester);
    expect(find.text('وضع الطاقة المنخفضة متوقف'), findsOneWidget);
    expect(find.text('إشعارات ملء الشاشة مسموحة'), findsNothing);
    expect(find.text('إذن الاتصال لزر «طوارئ»'), findsNothing);
    await tester.ensureVisible(find.byKey(const Key('ring-switch-done')));
    await app.settle(tester);
    await tester.tap(find.byKey(const Key('ring-switch-done')));
    await app.settle(tester);

    await tester.ensureVisible(find.byKey(const Key('test-offer')));
    await app.settle(tester);
    await tester.tap(find.byKey(const Key('test-offer')));
    await app.settle(tester);
    await tester.tap(find.byKey(const Key('test-offer-heard')));
    await app.settle(tester);
    await tester.ensureVisible(find.byKey(const Key('save-check')));
    await app.settle(tester);
    await tester.tap(find.byKey(const Key('save-check')));
    await app.settle(tester);
    expect(lastBody(app, '/v1/captain/device/check'), {
      'failed': ['low_power_mode'],
    });
    await app.done(tester);
  });

  testWidgets('runs before the first «متصل» on this phone, rings the test '
      'offer and sends the result', (tester) async {
    final app = TestApp();
    app.alerts.deviceReadings = const AndroidReadings(
      notificationsAllowed: true,
      batteryOptimizationOff: false,
      fullScreenAllowed: true,
      alarmVolumePercent: 80,
      doNotDisturbBlocks: false,
      autostartPage: false,
    );
    app.server.on('/v1/captain/device/check', [
      const FakeAnswer(200, {'check': null}),
      FakeAnswer(200, checkJson(['battery'])),
    ]);
    app.server.on('/v1/captain/auth/current', [
      const FakeAnswer(200, {
        'accountId': accountId,
        'captainId': captainId,
        'sessionId': '00000000-0000-4000-8000-000000000003',
      }),
    ]);
    app.work(availability: [availabilityJson()]);
    await app.pump(tester);
    await app.live(tester);

    await tester.tap(find.byKey(const Key('online-switch')));
    await app.settle(tester);
    // It opens instead of going online.
    expect(find.text('فحص الجهاز'), findsWidgets);
    expect(app.server.to('/v1/captain/availability/online'), isEmpty);
    expect(find.text('توفير البطارية متوقف للتطبيق'), findsOneWidget);
    await tester.tap(find.byKey(const Key('fix-battery')));
    expect(app.alerts.opened, [DeviceSetting.battery]);

    await tester.ensureVisible(find.byKey(const Key('test-offer')));
    await app.settle(tester);
    await tester.tap(find.byKey(const Key('test-offer')));
    await app.settle(tester);
    expect(app.ringer.testText, 'عرض تجريبي — فحص الجهاز');
    expect(app.ringer.testLength, testOfferRings);
    await tester.tap(find.byKey(const Key('test-offer-heard')));
    await app.settle(tester);
    expect(app.ringer.testText, isNull);

    await tester.ensureVisible(find.byKey(const Key('save-check')));
    await app.settle(tester);
    await tester.tap(find.byKey(const Key('save-check')));
    await app.settle(tester);
    expect(lastBody(app, '/v1/captain/device/check'), {
      'failed': ['battery'],
    });
    expect(find.text('حُفظت نتيجة الفحص.'), findsOneWidget);

    // Closing the check goes online, whatever it found (CA §4.5).
    app.server.on('/v1/captain/availability/online', [
      FakeAnswer(200, availabilityJson(state: 'online_available')),
    ]);
    app.work(availability: [availabilityJson(state: 'online_available')]);
    GoRouter.of(tester.element(find.byType(DeviceCheckScreen))).pop();
    await app.settle(tester);
    expect(app.server.to('/v1/captain/availability/online'), hasLength(1));
    expect(find.text('متصل متاح'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('shows the yellow banner while a check the app reads fails, '
      'and goes online all the same', (tester) async {
    final app = TestApp();
    app.alerts.deviceReadings = _good;
    app.access.access = const PhoneAccess(
      locationAlways: false,
      locationPrecise: true,
      callAllowed: true,
    );
    app.server.on('/v1/captain/device/check', [FakeAnswer(200, checkJson([]))]);
    app.work(availability: [availabilityJson()]);
    await app.pump(tester);
    await app.live(tester);
    expect(
      find.text('هاتفك قد لا يرن عند وصول عرض — أكمل فحص الجهاز'),
      findsOneWidget,
    );

    app.server.on('/v1/captain/availability/online', [
      FakeAnswer(200, availabilityJson(state: 'online_available')),
    ]);
    app.work(availability: [availabilityJson(state: 'online_available')]);
    await tester.tap(find.byKey(const Key('online-switch')));
    await app.settle(tester);
    expect(find.text('متصل متاح'), findsOneWidget);
    await app.done(tester);
  });
}
