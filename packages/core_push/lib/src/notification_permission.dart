import 'package:permission_handler/permission_handler.dart';

/// The phone's permission to show notifications: Android 13's runtime
/// permission (`POST_NOTIFICATIONS`); granted at install on older Androids.
abstract interface class NotificationPermission {
  Future<bool> granted();

  /// Asks the phone; true when the person allowed it.
  Future<bool> request();

  /// Opens the app's page in the phone's settings.
  Future<void> openSettings();
}

/// [NotificationPermission] on `permission_handler` (architecture §11.3).
class SystemNotificationPermission implements NotificationPermission {
  const SystemNotificationPermission();

  @override
  Future<bool> granted() => Permission.notification.isGranted;

  @override
  Future<bool> request() async =>
      (await Permission.notification.request()).isGranted;

  @override
  Future<void> openSettings() async => openAppSettings();
}
