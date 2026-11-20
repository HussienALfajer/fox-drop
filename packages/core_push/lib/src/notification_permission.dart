import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

/// The phone's permission to show notifications: Android 13's runtime
/// permission (`POST_NOTIFICATIONS`), granted at install on older Androids;
/// iOS' alert, sound and badge authorisation.
abstract interface class NotificationPermission {
  Future<bool> granted();

  /// Asks the phone; true when the person allowed it.
  Future<bool> request();

  /// Opens the app's page in the phone's settings.
  Future<void> openSettings();
}

/// [NotificationPermission] on `permission_handler` (architecture §11.3).
/// [criticalAlerts] also asks an iPhone for Critical Alerts (the captain's
/// offers, K15; slice 2.46), which iOS offers only to an app Apple granted
/// the entitlement, and ignores otherwise.
class SystemNotificationPermission implements NotificationPermission {
  const SystemNotificationPermission({this.criticalAlerts = false});

  final bool criticalAlerts;

  @override
  Future<bool> granted() => Permission.notification.isGranted;

  @override
  Future<bool> request() async {
    final allowed = (await Permission.notification.request()).isGranted;
    if (criticalAlerts &&
        allowed &&
        defaultTargetPlatform == TargetPlatform.iOS) {
      await Permission.criticalAlerts.request();
    }
    return allowed;
  }

  @override
  Future<void> openSettings() async => openAppSettings();
}
