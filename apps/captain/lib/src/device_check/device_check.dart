import 'package:core_alerts/core_alerts.dart';
import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../api.dart';
import '../auth.dart';
import '../profile/profile.dart';
import '../work/alerts.dart';

/// CA §4.5 (slice 2.43): the items of «فحص الجهاز» on Android, in the
/// spec's order, by the code the server keeps.
enum CheckItem {
  notifications(CaptainDeviceCheckReportDtoFailedEnum.notifications),
  location(CaptainDeviceCheckReportDtoFailedEnum.location),
  battery(CaptainDeviceCheckReportDtoFailedEnum.battery),
  autostart(CaptainDeviceCheckReportDtoFailedEnum.autostart),
  fullScreen(CaptainDeviceCheckReportDtoFailedEnum.fullScreen),
  alarmVolume(CaptainDeviceCheckReportDtoFailedEnum.alarmVolume),
  doNotDisturb(CaptainDeviceCheckReportDtoFailedEnum.doNotDisturb),
  testOffer(CaptainDeviceCheckReportDtoFailedEnum.testOffer),
  connection(CaptainDeviceCheckReportDtoFailedEnum.connection),
  gpsAccuracy(CaptainDeviceCheckReportDtoFailedEnum.gpsAccuracy),
  call(CaptainDeviceCheckReportDtoFailedEnum.call);

  const CheckItem(this.code);
  final CaptainDeviceCheckReportDtoFailedEnum code;
}

/// CA §4.5 check 5: the alarm stream's volume, at least 70%.
const minimumAlarmVolume = 70;

/// CA §4.5 check 7: as K3, worse than 100 metres is weak.
const maximumGpsMetres = 100;

/// CA §4.5 check 6: the test offer rings this long, time to lock the phone.
const testOfferRings = Duration(seconds: 30);

/// What the app reads of the phone besides `core_alerts`' readings: the
/// location always and precise (check 2) and the call permission (check 8).
class PhoneAccess {
  const PhoneAccess({
    required this.locationAlways,
    required this.locationPrecise,
    required this.callAllowed,
  });

  final bool locationAlways;
  final bool locationPrecise;
  final bool callAllowed;
}

/// Reads [PhoneAccess] and asks for what is missing; tests give a fake.
abstract interface class PhoneAccessReader {
  Future<PhoneAccess> read();

  /// Check 2: the app's settings, where «السماح دائماً» is (Android asks for
  /// the background location there, never in a dialog).
  Future<void> openLocationSettings();

  /// Check 8: the system's dialog.
  Future<void> requestCall();
}

class SystemPhoneAccess implements PhoneAccessReader {
  const SystemPhoneAccess();

  @override
  Future<PhoneAccess> read() async {
    final permission = await Geolocator.checkPermission();
    final accuracy = await Geolocator.getLocationAccuracy();
    return PhoneAccess(
      locationAlways: permission == LocationPermission.always,
      locationPrecise: accuracy == LocationAccuracyStatus.precise,
      callAllowed: await Permission.phone.isGranted,
    );
  }

  @override
  Future<void> openLocationSettings() async {
    if (await Geolocator.checkPermission() == LocationPermission.denied) {
      await Geolocator.requestPermission();
    } else {
      await Geolocator.openAppSettings();
    }
  }

  @override
  Future<void> requestCall() async {
    await Permission.phone.request();
  }
}

final phoneAccessReaderProvider = Provider<PhoneAccessReader>(
  (ref) => const SystemPhoneAccess(),
);

/// Everything the app reads of the phone (CA §4.5 checks 1–5 and 8), read
/// again whenever the app resumes (the captain comes back from the system's
/// settings), when it opens and at «متصل»; null where there is nothing to
/// read (iOS until slice 2.46).
class PhoneReadings {
  const PhoneReadings(this.device, this.access);

  final AndroidReadings device;
  final PhoneAccess access;
}

final phoneReadingsProvider = FutureProvider<PhoneReadings?>((ref) async {
  final listener = AppLifecycleListener(onResume: ref.invalidateSelf);
  ref.onDispose(listener.dispose);
  // The captain app runs on phones only: a PC's readings never come.
  final device = await ref.watch(alertsProvider).readings();
  if (device is! AndroidReadings) return null;
  return PhoneReadings(
    device,
    await ref.watch(phoneAccessReaderProvider).read(),
  );
});

/// What the captain answered: the brand's auto-start confirmed, the test
/// offer heard or not (null before it plays), and check 7's measures.
class CheckAnswers {
  const CheckAnswers({
    this.autostartConfirmed = false,
    this.heard,
    this.delayMs,
    this.gpsMetres,
  });

  final bool autostartConfirmed;
  final bool? heard;
  final int? delayMs;
  final int? gpsMetres;
}

/// The checks the app reads (1–5, 8) that fail now. The brand's auto-start
/// counts until the captain confirms it (no app can read it).
List<CheckItem> failedReadings(PhoneReadings readings, CheckAnswers answers) {
  final device = readings.device;
  final access = readings.access;
  return [
    if (!device.notificationsAllowed) CheckItem.notifications,
    if (!access.locationAlways || !access.locationPrecise) CheckItem.location,
    if (!device.batteryOptimizationOff) CheckItem.battery,
    if (device.autostartPage && !answers.autostartConfirmed)
      CheckItem.autostart,
    if (!device.fullScreenAllowed) CheckItem.fullScreen,
    if (device.alarmVolumePercent < minimumAlarmVolume) CheckItem.alarmVolume,
    if (device.doNotDisturbBlocks) CheckItem.doNotDisturb,
    if (!access.callAllowed) CheckItem.call,
  ];
}

/// Every item that fails, in the spec's order: the readings, the test offer
/// until heard, and check 7 until measured.
List<CheckItem> failedItems(PhoneReadings readings, CheckAnswers answers) {
  final read = failedReadings(readings, answers);
  final metres = answers.gpsMetres;
  final failed = {
    ...read,
    if (answers.heard != true) CheckItem.testOffer,
    if (answers.delayMs == null) CheckItem.connection,
    if (metres == null || metres > maximumGpsMetres) CheckItem.gpsAccuracy,
  };
  return [
    for (final item in CheckItem.values)
      if (failed.contains(item)) item,
  ];
}

/// The device store's mark that the check was opened on this phone, so the
/// first «متصل» opens it once, whether it was saved or not (CA §4.5: it never
/// blocks going online).
const deviceCheckOpenedKey = 'captain.device_check_opened';

/// This phone's last device check as the server keeps it (`GET
/// /v1/captain/device/check`), null before its first; the captain's report
/// after each run replaces it (CA §15).
class ThisDeviceCheck extends AsyncNotifier<CaptainDeviceCheckOutput?> {
  @override
  Future<CaptainDeviceCheckOutput?> build() async {
    final session = ref.watch(captainAuth.session).value;
    if (session is! SignedIn) return null;
    final response = await ref
        .read(coreApiProvider)
        .getCaptainApi()
        .captainDeviceCheck();
    return response.data!.check;
  }

  /// False when it failed.
  Future<bool> record(List<CheckItem> failed) async {
    try {
      final response = await ref
          .read(coreApiProvider)
          .getCaptainApi()
          .captainDeviceReport(
            captainDeviceCheckReportDto: CaptainDeviceCheckReportDto(
              (b) => b..failed.addAll(failed.map((item) => item.code)),
            ),
          );
      state = AsyncData(response.data!.check);
      return true;
    } on Object catch (error) {
      debugPrint('Device check: $error');
      return false;
    }
  }
}

final thisDeviceCheckProvider =
    AsyncNotifierProvider<ThisDeviceCheck, CaptainDeviceCheckOutput?>(
      ThisDeviceCheck.new,
    );

/// CA §4.5: «a failed check shows a yellow banner»: a check the app reads
/// fails now, or this phone's last check failed the test offer (the checks
/// the captain confirms are asked again only then). Nothing before the first
/// check, which the first «متصل» opens.
final deviceCheckBannerProvider = Provider<bool>((ref) {
  final readings = ref.watch(phoneReadingsProvider).value;
  final last = ref.watch(thisDeviceCheckProvider).value;
  if (readings == null || last == null) return false;
  // The auto-start counts as the last check found it: the captain confirms
  // it again only on a new run (CA §4.5).
  final autostart = !last.failed.contains(
    CaptainDeviceCheckOutputFailedEnum.autostart,
  );
  return failedReadings(
        readings,
        CheckAnswers(autostartConfirmed: autostart),
      ).isNotEmpty ||
      last.failed.contains(CaptainDeviceCheckOutputFailedEnum.testOffer);
});

/// CA §4.5: the check runs before the first time a captain goes online on
/// this phone: true while it was never opened nor saved here and the
/// platform has something to check. A failed read asks nothing (it never
/// blocks going online).
Future<bool> deviceCheckNeeded(WidgetRef ref) async {
  try {
    if (await ref.read(phoneReadingsProvider.future) == null) return false;
    if (await ref.read(deviceStoreProvider).read(deviceCheckOpenedKey) !=
        null) {
      return false;
    }
    return await ref.read(thisDeviceCheckProvider.future) == null;
  } on Object {
    return false;
  }
}
