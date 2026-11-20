import 'package:core_alerts/core_alerts.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:merchant/src/receiving/receiving.dart';

// RA §4.5 on Windows (slice 2.44): checks 1, 3, 5 and 6 from the PC.
void main() {
  const good = WindowsReadings(
    notificationsAllowed: true,
    startsWithWindows: true,
    outputMuted: false,
    outputVolumePercent: 40,
    sleepAfterSeconds: 0,
  );

  test('passes a PC that rings: notifications, startup, sound, no sleep', () {
    expect(failedReadings(good, const CheckAnswers()), isEmpty);
    expect(
      failedItems(good, const CheckAnswers(heard: true, delayMs: 80)),
      isEmpty,
    );
  });

  test('fails each check by its reading, sleep as check 6', () {
    const bad = WindowsReadings(
      notificationsAllowed: false,
      startsWithWindows: false,
      outputMuted: true,
      outputVolumePercent: 40,
      sleepAfterSeconds: 1800,
    );
    expect(failedReadings(bad, const CheckAnswers()), [
      CheckItem.notifications,
      CheckItem.autostart,
      CheckItem.alarmVolume,
      CheckItem.sleep,
    ]);
    // A volume of 0 is as silent as muted.
    const silent = WindowsReadings(
      notificationsAllowed: true,
      startsWithWindows: true,
      outputMuted: false,
      outputVolumePercent: 0,
      sleepAfterSeconds: 0,
    );
    expect(failedReadings(silent, const CheckAnswers()), [
      CheckItem.alarmVolume,
    ]);
  });
}
