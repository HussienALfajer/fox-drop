import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// RA §4.4: the bundled ring sounds, distinct for a new order, a pickup
/// request, and a cancellation or an edit; CA §4.4: the captain's offer.
/// Placeholders until the design's sounds (owner decision 2026-11-20).
enum RingSound { newOrder, pickupRequest, cancellation, offer }

/// What the device check reads of the device (RA §4.5): the phone's checks
/// 1–5 ([AndroidReadings]) or the PC's checks 1, 3, 5 and 6
/// ([WindowsReadings]).
sealed class DeviceReadings {
  const DeviceReadings();
}

/// A phone's readings (RA §4.5 checks 1–5).
class AndroidReadings extends DeviceReadings {
  const AndroidReadings({
    required this.notificationsAllowed,
    required this.batteryOptimizationOff,
    required this.fullScreenAllowed,
    required this.alarmVolumePercent,
    required this.doNotDisturbBlocks,
    required this.autostartPage,
  });

  /// Check 1.
  final bool notificationsAllowed;

  /// Check 2: the app is left out of battery optimisation.
  final bool batteryOptimizationOff;

  /// Check 4: always true below Android 14, which needs no permission.
  final bool fullScreenAllowed;

  /// Check 5: the alarm stream's volume, 0 to 100.
  final int alarmVolumePercent;

  /// Check 5: Do Not Disturb silences alarms now.
  final bool doNotDisturbBlocks;

  /// Check 3: the phone's brand has its own auto-start page, which the app
  /// cannot read, so the user confirms it; false on a brand without one.
  final bool autostartPage;

  static AndroidReadings fromMap(Map<Object?, Object?> map) => AndroidReadings(
    notificationsAllowed: map['notificationsAllowed'] == true,
    batteryOptimizationOff: map['batteryOptimizationOff'] == true,
    fullScreenAllowed: map['fullScreenAllowed'] == true,
    alarmVolumePercent: (map['alarmVolumePercent'] as int?) ?? 0,
    doNotDisturbBlocks: map['doNotDisturbBlocks'] == true,
    autostartPage: map['autostartPage'] == true,
  );
}

/// A PC's readings (RA §4.5 checks 1, 3, 5 and 6; slice 2.44).
class WindowsReadings extends DeviceReadings {
  const WindowsReadings({
    required this.notificationsAllowed,
    required this.startsWithWindows,
    required this.outputMuted,
    required this.outputVolumePercent,
    required this.sleepAfterSeconds,
  });

  /// Check 1: Windows' notifications on, for the user and the app.
  final bool notificationsAllowed;

  /// Check 3: «Start with Windows» on.
  final bool startsWithWindows;

  /// Check 5: the default output device is muted (or there is none).
  final bool outputMuted;

  /// Check 5: its volume, 0 to 100.
  final int outputVolumePercent;

  /// Check 6: how long the PC waits on mains power before it sleeps; 0 when
  /// it never does.
  final int sleepAfterSeconds;

  static WindowsReadings fromMap(Map<Object?, Object?> map) => WindowsReadings(
    notificationsAllowed: map['notificationsAllowed'] == true,
    startsWithWindows: map['startsWithWindows'] == true,
    outputMuted: map['outputMuted'] != false,
    outputVolumePercent: (map['outputVolumePercent'] as int?) ?? 0,
    sleepAfterSeconds: (map['sleepAfterSeconds'] as int?) ?? 0,
  );
}

/// A system settings page the device check opens (RA §4.5). On Windows,
/// [autostart] turns «Start with Windows» on itself, and [sleep] opens the
/// power settings (check 6).
enum DeviceSetting {
  notifications,
  battery,
  autostart,
  fullScreen,
  alarmVolume,
  doNotDisturb,
  sleep,
}

/// The native ringing layer (architecture §12.2): the foreground service
/// that keeps the app receiving with the screen off, the ring on the alarm
/// stream with a full-screen prompt, the chime, and the device check's
/// readers.
abstract interface class Alerts {
  /// Starts the foreground service «FOX DROP يستقبل طلباتك», kept after a
  /// reboot and an update until [stopReceiving] (RA §4.3).
  Future<void> startReceiving();

  /// Ends it, when the device signs out.
  Future<void> stopReceiving();

  /// Loops [sound] on the alarm stream with a full-screen prompt where the
  /// system allows it, else a heads-up notification (RA §4.4, §21 item 4),
  /// until [stopRing], or [stopAfter] when given (CA §4.4: an offer rings
  /// until its end). [vibrate] vibrates the phone while it rings (CA §4.4).
  /// A ring already playing changes its sound and text.
  Future<void> ring(
    RingSound sound, {
    required String title,
    required String body,
    bool vibrate = false,
    Duration? stopAfter,
  });

  Future<void> stopRing();

  /// Plays the chime once, or the cancellation sound (CA §4.4, §14 #11),
  /// never over a ring.
  Future<void> chime({bool cancellation = false});

  /// The device check's readings, or null where the platform has none.
  Future<DeviceReadings?> readings();

  Future<void> openSettings(DeviceSetting setting);
}

/// Where there is no native layer (the tests' platform, and any but Android
/// and Windows).
class NoAlerts implements Alerts {
  const NoAlerts();

  @override
  Future<void> startReceiving() async {}

  @override
  Future<void> stopReceiving() async {}

  @override
  Future<void> ring(
    RingSound sound, {
    required String title,
    required String body,
    bool vibrate = false,
    Duration? stopAfter,
  }) async {}

  @override
  Future<void> stopRing() async {}

  @override
  Future<void> chime({bool cancellation = false}) async {}

  @override
  Future<DeviceReadings?> readings() async => null;

  @override
  Future<void> openSettings(DeviceSetting setting) async {}
}

/// The Android layer (`CoreAlertsPlugin.kt`).
class AndroidAlerts implements Alerts {
  const AndroidAlerts();

  static const _channel = MethodChannel('fox_drop/core_alerts');

  /// RA §4.3: a high-priority push wakes the app when the system ended the
  /// service: from the push's background isolate, this starts the service
  /// again (and with it the app's engine), only while a signed-in device
  /// asked to receive.
  static Future<void> wake() => _channel.invokeMethod('wake');

  @override
  Future<void> startReceiving() => _channel.invokeMethod('startReceiving');

  @override
  Future<void> stopReceiving() => _channel.invokeMethod('stopReceiving');

  @override
  Future<void> ring(
    RingSound sound, {
    required String title,
    required String body,
    bool vibrate = false,
    Duration? stopAfter,
  }) => _channel.invokeMethod('ring', {
    'sound': soundName(sound),
    'title': title,
    'body': body,
    'vibrate': vibrate,
    'stopAfterMs': stopAfter?.inMilliseconds,
  });

  @override
  Future<void> stopRing() => _channel.invokeMethod('stopRing');

  @override
  Future<void> chime({bool cancellation = false}) => _channel.invokeMethod(
    'chime',
    {'sound': cancellation ? 'fd_cancellation' : 'fd_chime'},
  );

  @override
  Future<DeviceReadings?> readings() async {
    final map = await _channel.invokeMethod<Map<Object?, Object?>>('readings');
    return map == null ? null : AndroidReadings.fromMap(map);
  }

  @override
  Future<void> openSettings(DeviceSetting setting) =>
      _channel.invokeMethod('openSettings', {'setting': setting.name});
}

/// The raw resource of each sound (`android/src/main/res/raw`), which the
/// Windows layer plays from the app's assets.
String soundName(RingSound sound) => switch (sound) {
  RingSound.newOrder => 'fd_new_order',
  RingSound.pickupRequest => 'fd_pickup_request',
  RingSound.cancellation => 'fd_cancellation',
  RingSound.offer => 'fd_offer',
};

/// The platform's layer: Android's, Windows' ([windows], set up by the app's
/// `main`), else none.
Alerts platformAlerts({Alerts? windows}) => switch (defaultTargetPlatform) {
  TargetPlatform.android => const AndroidAlerts(),
  TargetPlatform.windows => windows ?? const NoAlerts(),
  _ => const NoAlerts(),
};
