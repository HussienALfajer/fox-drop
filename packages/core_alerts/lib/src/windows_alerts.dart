import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications_windows/flutter_local_notifications_windows.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

import 'alerts.dart';

/// The tray's texts, from the app's strings.
class TrayTexts {
  const TrayTexts({
    required this.tooltip,
    required this.open,
    required this.quit,
  });

  final String tooltip;
  final String open;
  final String quit;
}

/// The restaurant app's identity in Windows' notifications: its Application
/// User Model ID and the GUID of its toasts' activator (fixed per app).
const windowsAppUserModelId = 'FOXDROP.Merchant';
const windowsToastGuid = '8f1c2a4e-5b7d-4e0a-9c3f-6d2b1e8a7f40';

/// The ring's one toast, replaced and removed with it.
const _ringToastId = 1;

/// The Windows layer (architecture §12.3; RA §4.3–4.5; slice 2.44): the
/// window stays running in the tray when closed and asks before quitting;
/// a ring loops the bundled sound on the default output device, brings the
/// window to the front (the taskbar button flashes where Windows keeps it
/// back) and shows a native notification; the device check's readings and
/// «Start with Windows». The Win32 side is `windows/core_alerts_plugin.cpp`.
class WindowsAlerts with WindowListener, TrayListener implements Alerts {
  WindowsAlerts({required this.appName});

  /// The brand, the notifications' sender.
  final String appName;

  static const _channel = MethodChannel('fox_drop/core_alerts');
  final _toasts = FlutterLocalNotificationsWindows();
  Future<bool> Function()? _confirmQuit;
  bool _quitting = false;
  bool _ringing = false;

  /// Called once by the app's `main` after the binding: closing the window
  /// hides it to the tray; the tray's menu opens it or quits after
  /// [confirmQuit] (RA §4.3: «إغلاق التطبيق يوقف استقبال الطلبات على هذا
  /// الجهاز. هل أنت متأكد؟»).
  Future<void> setUp(
    TrayTexts texts,
    Future<bool> Function() confirmQuit,
  ) async {
    _confirmQuit = confirmQuit;
    await windowManager.ensureInitialized();
    await windowManager.setPreventClose(true);
    windowManager.addListener(this);
    await trayManager.setIcon('packages/core_alerts/assets/tray.ico');
    await trayManager.setToolTip(texts.tooltip);
    await trayManager.setContextMenu(
      Menu(
        items: [
          MenuItem(key: 'open', label: texts.open),
          MenuItem.separator(),
          MenuItem(key: 'quit', label: texts.quit),
        ],
      ),
    );
    trayManager.addListener(this);
    try {
      await _toasts.initialize(
        settings: WindowsInitializationSettings(
          appName: appName,
          appUserModelId: windowsAppUserModelId,
          guid: windowsToastGuid,
        ),
      );
    } on Object catch (error) {
      // No notifications then; the ring still sounds and shows the window.
      debugPrint('Windows notifications did not start: $error');
    }
  }

  /// Closing the window keeps the app receiving in the tray.
  @override
  void onWindowClose() {
    if (!_quitting) unawaited(windowManager.hide());
  }

  @override
  void onWindowFocus() {
    if (_ringing) unawaited(_channel.invokeMethod('flash', {'on': false}));
  }

  @override
  void onTrayIconMouseDown() => unawaited(show());

  @override
  void onTrayIconRightMouseDown() => unawaited(trayManager.popUpContextMenu());

  @override
  void onTrayMenuItemClick(MenuItem menuItem) => switch (menuItem.key) {
    'open' => unawaited(show()),
    'quit' => unawaited(quit()),
    _ => null,
  };

  /// Brings the window to the front.
  Future<void> show() async {
    await windowManager.show();
    if (await windowManager.isMinimized()) await windowManager.restore();
    await windowManager.focus();
  }

  /// Quits once the user confirmed (the window shows first, for the
  /// question). [beforeQuit] runs last, such as an update to apply.
  Future<void> quit({Future<void> Function()? beforeQuit}) async {
    await show();
    final sure = await _confirmQuit?.call() ?? true;
    if (!sure) return;
    await quitNow(beforeQuit: beforeQuit);
  }

  /// Quits without asking (the self-update's restart, RA §4.2).
  Future<void> quitNow({Future<void> Function()? beforeQuit}) async {
    _quitting = true;
    await stopRing();
    await beforeQuit?.call();
    await trayManager.destroy();
    await windowManager.setPreventClose(false);
    await windowManager.destroy();
  }

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
  }) async {
    _ringing = true;
    await _channel.invokeMethod('playSound', {
      'path': soundPath(sound),
      'loop': true,
    });
    await show();
    // Windows keeps a background app from taking the focus: the taskbar
    // button flashes until the window comes to the front.
    if (!await windowManager.isFocused()) {
      await _channel.invokeMethod('flash', {'on': true});
    }
    try {
      await _toasts.show(
        id: _ringToastId,
        title: title,
        body: body,
        // The ring's own sound plays.
        notificationDetails: WindowsNotificationDetails(
          audio: WindowsNotificationAudio.silent(),
        ),
      );
    } on Object catch (error) {
      debugPrint('No ring notification: $error');
    }
  }

  @override
  Future<void> stopRing() async {
    if (!_ringing) return;
    _ringing = false;
    await _channel.invokeMethod('stopSound');
    await _channel.invokeMethod('flash', {'on': false});
    try {
      await _toasts.cancel(id: _ringToastId);
    } on Object catch (_) {}
  }

  @override
  Future<void> chime({bool cancellation = false}) async {
    if (_ringing) return;
    await _channel.invokeMethod('playSound', {
      'path': soundPathOf(cancellation ? 'fd_cancellation' : 'fd_chime'),
      'loop': false,
    });
  }

  @override
  Future<DeviceReadings?> readings() async {
    final map = await _channel.invokeMethod<Map<Object?, Object?>>('readings', {
      'appUserModelId': windowsAppUserModelId,
    });
    return map == null ? null : WindowsReadings.fromMap(map);
  }

  /// RA §4.5 on Windows: check 1 opens the notifications' settings, check 3
  /// turns «Start with Windows» on, check 5 opens the sound settings and
  /// check 6 the power settings.
  @override
  Future<void> openSettings(DeviceSetting setting) async {
    final page = switch (setting) {
      DeviceSetting.notifications => 'ms-settings:notifications',
      DeviceSetting.alarmVolume => 'ms-settings:sound',
      DeviceSetting.sleep => 'ms-settings:powersleep',
      DeviceSetting.autostart => null,
      _ => null,
    };
    if (setting == DeviceSetting.autostart) {
      await startWithWindows();
    } else if (page != null) {
      await Process.start('explorer.exe', [page]);
    }
  }

  /// RA §4.3: «Start with Windows» on (by default, at the first sign-in).
  Future<void> startWithWindows() =>
      _channel.invokeMethod('setStartup', {'on': true});
}

/// The bundled sound's file beside the executable, in the Flutter assets the
/// package declares (`pubspec.yaml`).
@visibleForTesting
String soundPath(RingSound sound) => soundPathOf(soundName(sound));

String soundPathOf(String name) => [
  File(Platform.resolvedExecutable).parent.path,
  'data',
  'flutter_assets',
  'packages',
  'core_alerts',
  'android',
  'src',
  'main',
  'res',
  'raw',
  '$name.wav',
].join(Platform.pathSeparator);
