import 'package:core_alerts/core_alerts.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('fox_drop/core_alerts');
  final calls = <MethodCall>[];

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          if (call.method == 'readings') {
            return {
              'notificationsAllowed': true,
              'batteryOptimizationOff': false,
              'fullScreenAllowed': true,
              'alarmVolumePercent': 60,
              'doNotDisturbBlocks': false,
              'autostartPage': true,
            };
          }
          return null;
        });
  });

  test(
    'rings each sound by its bundled resource, with the prompt’s text',
    () async {
      const alerts = AndroidAlerts();
      await alerts.ring(
        RingSound.pickupRequest,
        title: 'FOX DROP',
        body: 'طلب جديد #10001',
      );
      await alerts.stopRing();
      expect(calls.map((call) => call.method), ['ring', 'stopRing']);
      expect(calls.first.arguments, {
        'sound': 'fd_pickup_request',
        'title': 'FOX DROP',
        'body': 'طلب جديد #10001',
        'vibrate': false,
        'stopAfterMs': null,
      });
      expect(RingSound.values.map(soundName), [
        'fd_new_order',
        'fd_pickup_request',
        'fd_cancellation',
        'fd_offer',
      ]);
    },
  );

  test(
    'rings an offer with vibration until its end, and plays a sound once',
    () async {
      const alerts = AndroidAlerts();
      await alerts.ring(
        RingSound.offer,
        title: 'FOX DROP',
        body: 'عرض جديد: 25 ₺ — مطعم الاختبار',
        vibrate: true,
        stopAfter: const Duration(seconds: 42),
      );
      await alerts.chime(cancellation: true);
      expect(calls.first.arguments, {
        'sound': 'fd_offer',
        'title': 'FOX DROP',
        'body': 'عرض جديد: 25 ₺ — مطعم الاختبار',
        'vibrate': true,
        'stopAfterMs': 42000,
      });
      expect(calls.last.method, 'chime');
      expect(calls.last.arguments, {'sound': 'fd_cancellation'});
    },
  );

  test(
    'reads the device check’s readings and opens a setting by name',
    () async {
      const alerts = AndroidAlerts();
      final readings = await alerts.readings();
      expect(readings?.batteryOptimizationOff, isFalse);
      expect(readings?.alarmVolumePercent, 60);
      await alerts.openSettings(DeviceSetting.fullScreen);
      expect(calls.last.arguments, {'setting': 'fullScreen'});
    },
  );

  test('has nothing to read where there is no native layer', () async {
    expect(await const NoAlerts().readings(), isNull);
  });
}
