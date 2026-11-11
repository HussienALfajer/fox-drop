import 'dart:async';

import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:core_push/core_push.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api.dart';
import 'auth.dart';
import 'router.dart';

/// The installation's push (`packages/core_push`): `main` gives the one
/// `startPush` started; tests give a `FakePush`.
final pushProvider = Provider<Push>((ref) => const NoPush());

/// The phone's notification permission; tests give a fake.
final notificationPermissionProvider = Provider<NotificationPermission>(
  (ref) => const SystemNotificationPermission(),
);

/// Asks for the notification permission at «متصل» while the phone does not
/// allow it (owner decision 2026-11-08: check 1 of the device check, CA
/// §4.5, until it exists). The answer never blocks going online, since the
/// check only warns; Android itself stops asking after the second refusal.
Future<void> askNotifications(Ref ref) async {
  if (defaultTargetPlatform != TargetPlatform.android) return;
  final permission = ref.read(notificationPermissionProvider);
  try {
    if (!await permission.granted()) await permission.request();
  } on Object catch (error) {
    debugPrint('Notification permission: $error');
  }
}

/// The token kept registered while the captain is signed in (CA §14,
/// architecture §8.1).
final pushTokensProvider = Provider<PushTokens>((ref) {
  final tokens = PushTokens(ref.watch(pushProvider), (token) async {
    await ref
        .read(coreApiProvider)
        .getCaptainApi()
        .captainPushTokenRegister(
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
    captainAuth.session,
    (previous, next) => follow(next.value),
    fireImmediately: true,
  );
  ref.onDispose(tokens.dispose);
  return tokens;
});

/// The route a push's data opens (CA §14): an offer or an order opens home,
/// which shows the open offer or the active order. The others (statements,
/// receipts, documents) come with their slices; until then such a tap only
/// opens the app.
String? pushTargetPath(Map<String, String> data) => switch (data['target']) {
  // CA §14 #23 (slice 2.16): home shows the peak window's line.
  'offer' || 'order' || 'peak_bonus' => '/',
  _ => null,
};

/// Opens the target of the push the captain tapped: the one that started
/// the app, and each one tapped while it ran in the background.
final pushTapsProvider = Provider<void>((ref) {
  final push = ref.watch(pushProvider);
  final router = ref.watch(routerProvider);
  void open(Map<String, String>? data) {
    final path = data == null ? null : pushTargetPath(data);
    if (path != null) router.go(path);
  }

  final taps = push.taps.listen(open);
  unawaited(
    push.initialTap().then(
      open,
      onError: (Object error) => debugPrint('No initial push: $error'),
    ),
  );
  ref.onDispose(taps.cancel);
});
