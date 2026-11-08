import 'package:core_push/core_push.dart';
import 'package:core_storage/core_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../device.dart';

/// The phone's notification permission; tests give a fake.
final notificationPermissionProvider = Provider<NotificationPermission>(
  (ref) => const SystemNotificationPermission(),
);

/// The device remembers that the customer was asked, so only the first
/// order asks (Q11).
const _askedKey = 'notifications_asked';

/// The notification permission at the first order (CU §4.4, §10.7 item 4,
/// Q11): «اسمح بالإشعارات لتعرف متى يصل طلبك».
class NotificationAsk {
  NotificationAsk(this._ref);

  final Ref _ref;

  DeviceStore get _device => _ref.read(deviceStoreProvider);
  NotificationPermission get _permission =>
      _ref.read(notificationPermissionProvider);

  /// Whether this order asks: the first from this installation, on a phone
  /// that does not already allow notifications.
  Future<bool> due() async {
    if (await _device.read(_askedKey) != null) return false;
    if (await _permission.granted()) {
      await _device.write(_askedKey, '1');
      return false;
    }
    return true;
  }

  /// The customer's answer: «سماح» asks the phone, «ليس الآن» does not.
  /// Either way the order goes, and no later order asks again.
  Future<void> answer({required bool allow}) async {
    await _device.write(_askedKey, '1');
    if (allow) await _permission.request();
    _ref.invalidate(notificationsOffProvider);
  }
}

final notificationAskProvider = Provider<NotificationAsk>(NotificationAsk.new);

/// The order screen's banner (CU §4.4): the customer was asked and the
/// phone does not allow notifications. Read with each order screen, and
/// again when the app comes back from the settings.
final notificationsOffProvider = FutureProvider.autoDispose<bool>((ref) async {
  if (await ref.read(deviceStoreProvider).read(_askedKey) == null) {
    return false;
  }
  return !await ref.read(notificationPermissionProvider).granted();
});
