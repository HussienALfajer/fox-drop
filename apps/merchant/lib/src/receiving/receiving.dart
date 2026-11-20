import 'dart:async';

import 'package:core_alerts/core_alerts.dart';
import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../auth.dart';
import '../board/alerts.dart';
import '../board/board.dart';
import '../device.dart';
import '../push.dart';

/// This device as the server keeps it (RA §4.4–4.5): whether it rings, and
/// its last device check.
class ThisDevice {
  const ThisDevice({required this.ringing, required this.check});

  final bool ringing;
  final MerchantDeviceCheckOutput? check;

  static ThisDevice of(MerchantThisDeviceDtoOutput dto) =>
      ThisDevice(ringing: dto.ringing, check: dto.check);
}

/// Reports the app's version at every start (and after naming the device),
/// which answers the ring setting and the last check; an owner turns ringing
/// on or off and every device sends its check through it (`PUT
/// /v1/merchant/device`, `/device/check`). Null while signed out or before
/// the device is named.
class ThisDeviceNotifier extends AsyncNotifier<ThisDevice?> {
  @override
  Future<ThisDevice?> build() async {
    // A report that failed (offline at start) is sent again once the
    // restaurant's channel is back, so the server never keeps an old version
    // that would count this device out (RA §4.2, §4.6).
    ref.listen(boardProvider, (previous, next) {
      final live = next.value?.live == true;
      final wasLive = previous?.value?.live == true;
      if (live && !wasLive && state.hasError) ref.invalidateSelf();
    });
    final session = await ref.watch(merchantSessionProvider.future);
    if (session == null || !session.deviceNamed) return null;
    return _report(null);
  }

  Future<ThisDevice> _report(bool? ringing) async {
    final appVersion = await ref.read(appVersionProvider.future);
    final response = await ref
        .read(coreApiProvider)
        .getMerchantApi()
        .merchantDeviceReport(
          merchantDeviceReportDto: MerchantDeviceReportDto(
            (b) => b
              ..appVersion = appVersion
              ..ringing = ringing,
          ),
        );
    return ThisDevice.of(response.data!);
  }

  /// RA §4.4 «الرنين على هذا الجهاز», an owner's. False when it failed.
  Future<bool> setRinging(bool on) async {
    try {
      state = AsyncData(await _report(on));
      return true;
    } catch (_) {
      return false;
    }
  }

  /// RA §4.5: the check's result, which the panel shows. False when it
  /// failed.
  Future<bool> recordCheck(List<CheckItem> failed, int? delayMs) async {
    try {
      final response = await ref
          .read(coreApiProvider)
          .getMerchantApi()
          .merchantDeviceCheck(
            merchantDeviceCheckDto: MerchantDeviceCheckDto(
              (b) => b
                ..failed.addAll(failed.map((item) => item.code))
                ..delayMs = delayMs,
            ),
          );
      state = AsyncData(ThisDevice.of(response.data!));
      return true;
    } catch (_) {
      return false;
    }
  }
}

final thisDeviceProvider =
    AsyncNotifierProvider<ThisDeviceNotifier, ThisDevice?>(
      ThisDeviceNotifier.new,
    );

/// Whether ring events ring here (RA §4.4): yes until the server says an
/// owner turned it off, so a failed read never silences the device.
final ringsHereProvider = Provider<bool>(
  (ref) => ref.watch(thisDeviceProvider).value?.ringing ?? true,
);

/// RA §4.3: the foreground service runs while a user is signed in on this
/// device, and stops at sign-out (so a reboot starts it only for a
/// signed-in device). Watched by `MerchantApp`.
final receivingProvider = Provider<void>((ref) {
  final alerts = ref.watch(alertsProvider);
  ref.listen(merchantAuth.session, (previous, next) {
    final session = next.value;
    if (session is SignedIn) {
      unawaited(alerts.startReceiving());
      if (alerts is WindowsAlerts) {
        unawaited(_startWithWindowsOnce(ref, alerts));
      }
    } else if (next.hasValue) {
      unawaited(alerts.stopReceiving());
    }
  }, fireImmediately: true);
});

/// RA §4.3: the app starts with Windows by default: turned on at the first
/// sign-in of the installation; the device check covers it after that.
Future<void> _startWithWindowsOnce(Ref ref, WindowsAlerts alerts) async {
  final store = ref.read(deviceStoreProvider);
  if (await store.read(startupSetKey) == 'true') return;
  await alerts.startWithWindows();
  await store.write(startupSetKey, 'true');
}

/// The device store's key: «Start with Windows» was turned on once.
const startupSetKey = 'windows_startup_set';

/// RA §4.5: the items the app checks, in the spec's order; on Windows
/// `autostart` is «Start with Windows», `alarmVolume` the output not muted,
/// and `sleep` the power plan (a warning the server never fails).
enum CheckItem {
  notifications(MerchantDeviceCheckDtoFailedEnum.notifications),
  battery(MerchantDeviceCheckDtoFailedEnum.battery),
  autostart(MerchantDeviceCheckDtoFailedEnum.autostart),
  fullScreen(MerchantDeviceCheckDtoFailedEnum.fullScreen),
  alarmVolume(MerchantDeviceCheckDtoFailedEnum.alarmVolume),
  sleep(MerchantDeviceCheckDtoFailedEnum.sleep),
  testRing(MerchantDeviceCheckDtoFailedEnum.testRing),
  connection(MerchantDeviceCheckDtoFailedEnum.connection);

  const CheckItem(this.code);
  final MerchantDeviceCheckDtoFailedEnum code;
}

/// RA §4.5 check 5: the alarm stream's volume, at least 70%.
const minimumAlarmVolume = 70;

/// What the user answered in the check: the brand's auto-start page they
/// confirmed, and the test ring heard or not (null before it plays).
class CheckAnswers {
  const CheckAnswers({
    this.autostartConfirmed = false,
    this.heard,
    this.delayMs,
    this.connectionFailed = false,
  });

  final bool autostartConfirmed;
  final bool? heard;
  final int? delayMs;
  final bool connectionFailed;
}

/// RA §4.5 checks 1–6, read from the device: those that fail now. A phone's
/// brand auto-start counts until the user confirms it (no app can read it);
/// a PC's sleep is check 6's warning.
List<CheckItem> failedReadings(DeviceReadings readings, CheckAnswers answers) =>
    switch (readings) {
      AndroidReadings() => [
        if (!readings.notificationsAllowed) CheckItem.notifications,
        if (!readings.batteryOptimizationOff) CheckItem.battery,
        if (readings.autostartPage && !answers.autostartConfirmed)
          CheckItem.autostart,
        if (!readings.fullScreenAllowed) CheckItem.fullScreen,
        if (readings.alarmVolumePercent < minimumAlarmVolume ||
            readings.doNotDisturbBlocks)
          CheckItem.alarmVolume,
      ],
      WindowsReadings() => [
        if (!readings.notificationsAllowed) CheckItem.notifications,
        if (!readings.startsWithWindows) CheckItem.autostart,
        if (readings.outputMuted || readings.outputVolumePercent == 0)
          CheckItem.alarmVolume,
        if (readings.sleepAfterSeconds > 0) CheckItem.sleep,
      ],
      // The restaurant app has no iOS build (architecture §11).
      IosReadings() => [],
    };

/// Every item that fails: the readings, the test ring until heard, and the
/// connection until measured.
List<CheckItem> failedItems(DeviceReadings readings, CheckAnswers answers) => [
  ...failedReadings(readings, answers),
  if (answers.heard != true) CheckItem.testRing,
  if (answers.delayMs == null) CheckItem.connection,
];

/// The device store's keys: the check was run once on this installation (RA
/// §4.5: «at the first sign-in on each device»), and the brand's auto-start
/// the user confirmed.
const deviceCheckDoneKey = 'device_check_done';
const autostartConfirmedKey = 'autostart_confirmed';

/// The phone's readings, read again whenever the app resumes (the user comes
/// back from the system's settings); null where the platform has none.
final deviceReadingsProvider = FutureProvider<DeviceReadings?>((ref) async {
  final listener = AppLifecycleListener(onResume: ref.invalidateSelf);
  ref.onDispose(listener.dispose);
  return ref.watch(alertsProvider).readings();
});

/// Whether the user confirmed the brand's auto-start page.
final autostartConfirmedProvider = FutureProvider<bool>(
  (ref) async =>
      await ref.watch(deviceStoreProvider).read(autostartConfirmedKey) ==
      'true',
);

/// RA §4.5: «Checks 1–6 are read again automatically each time the app
/// opens»: the yellow banner shows while one fails.
final deviceCheckBannerProvider = Provider<bool>((ref) {
  final readings = ref.watch(deviceReadingsProvider).value;
  if (readings == null) return false;
  final confirmed = ref.watch(autostartConfirmedProvider).value ?? false;
  return failedReadings(
    readings,
    CheckAnswers(autostartConfirmed: confirmed),
  ).isNotEmpty;
});
