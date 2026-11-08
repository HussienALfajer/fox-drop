import 'dart:async';

import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:core_push/core_push.dart';
import 'package:core_storage/core_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api.dart';
import 'auth.dart';
import 'device.dart';
import 'router.dart';

/// The installation's push (`packages/core_push`): `main` gives the one
/// `startPush` started (none on Windows); tests give a `FakePush`.
final pushProvider = Provider<Push>((ref) => const NoPush());

/// The phone's notification permission; tests give a fake.
final notificationPermissionProvider = Provider<NotificationPermission>(
  (ref) => const SystemNotificationPermission(),
);

/// The device's values that are not secret; tests give a `MemoryDeviceStore`.
final deviceStoreProvider = Provider<DeviceStore>(
  (ref) => PreferencesDeviceStore(),
);

/// The token kept registered while the restaurant's user is signed in (RA
/// §16, architecture §8.1).
final pushTokensProvider = Provider<PushTokens>((ref) {
  final tokens = PushTokens(ref.watch(pushProvider), (token) async {
    await ref
        .read(coreApiProvider)
        .getMerchantApi()
        .merchantPushTokenRegister(
          pushTokenDto: PushTokenDto(
            (b) => b
              ..token = token
              ..platform = PushTokenDtoPlatformEnum.android,
          ),
        );
  });
  void follow(SessionState? session) =>
      session is SignedIn ? tokens.signedIn() : tokens.signedOut();
  ref.listen(
    merchantAuth.session,
    (previous, next) => follow(next.value),
    fireImmediately: true,
  );
  ref.onDispose(tokens.dispose);
  return tokens;
});

/// The device remembers that it asked, so only the first sign-in asks.
const _askedKey = 'notifications_asked';

/// The notification permission, asked once per installation at the first
/// sign-in on Android (owner decision 2026-11-08: check 1 of the device
/// check, RA §4.5, until the device check exists). The system's own dialog
/// asks; a phone that already allows notifications is not asked.
final notificationAskProvider = Provider<void>((ref) {
  if (defaultTargetPlatform != TargetPlatform.android) return;
  var asking = false;
  Future<void> ask() async {
    if (asking) return;
    asking = true;
    try {
      final device = ref.read(deviceStoreProvider);
      if (await device.read(_askedKey) != null) return;
      final permission = ref.read(notificationPermissionProvider);
      if (!await permission.granted()) await permission.request();
      await device.write(_askedKey, '1');
    } finally {
      asking = false;
    }
  }

  ref.listen(merchantAuth.session, (previous, next) {
    if (next.value is SignedIn) {
      unawaited(
        ask().catchError(
          (Object error) => debugPrint('Notification permission: $error'),
        ),
      );
    }
  }, fireImmediately: true);
});

/// The route a push's data opens (RA §16): an order's push opens its
/// detail. The others (statements, tickets, the menu) come with their
/// slices; until then such a tap only opens the app.
String? pushTargetPath(Map<String, String> data) => switch (data) {
  {'target': 'order', 'orderId': final id} when id.isNotEmpty =>
    '/orders/${Uri.encodeComponent(id)}',
  _ => null,
};

/// Opens the target of the push the user tapped: the one that started the
/// app, and each one tapped while it ran in the background. The target
/// waits until the session's details say the board can show (signed in, the
/// device named), or the router's start would send it to the board.
final pushTapsProvider = Provider<void>((ref) {
  final push = ref.watch(pushProvider);
  final router = ref.watch(routerProvider);
  String? pending;
  void flush() {
    final ready = ref.read(merchantSessionProvider).value?.deviceNamed == true;
    final path = pending;
    if (path == null || !ready) return;
    pending = null;
    router.go(path);
  }

  void open(Map<String, String>? data) {
    final path = data == null ? null : pushTargetPath(data);
    if (path == null) return;
    pending = path;
    flush();
  }

  ref.listen(merchantSessionProvider, (previous, next) => flush());
  final taps = push.taps.listen(open);
  unawaited(
    push.initialTap().then(
      open,
      onError: (Object error) => debugPrint('No initial push: $error'),
    ),
  );
  ref.onDispose(taps.cancel);
});
