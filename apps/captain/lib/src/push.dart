import 'dart:async';

import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:core_push/core_push.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api.dart';
import 'auth.dart';
import 'joining/application.dart';
import 'performance/performance.dart';
import 'profile/profile.dart';
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

/// The token kept registered while the captain, or an applicant, is signed
/// in (CA §14, §5.4: a push at every change of the application; architecture
/// §8.1).
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
/// which shows the open offer or the active order, a receipt «عهدتي» and a
/// weekly statement the statement over «أرباحي», an application's change its
/// status page, the activation home, a contract phase «العقد والعدة», a
/// document «المستندات».
String? pushTargetPath(Map<String, String> data) => switch (data['target']) {
  // CA §14 #23 (slice 2.16): home shows the peak window's line.
  'offer' || 'order' || 'peak_bonus' => '/',
  // CA §14 #19 (slice 2.17c): a desk receipt opens «عهدتي».
  'custody' => '/custody',
  // CA §14 #20 (slice 2.18c): «كشف الأسبوع جاهز: قبضت {المبلغ}».
  'statement' => switch (data['statementId']) {
    final id? when id.isNotEmpty => '/earnings/statements/$id',
    _ => '/earnings/statements',
  },
  // CA §14 #30 (slice 2.24c): «تم الرد على بلاغك T-{رقم}» opens «بلاغاتي».
  'ticket' => '/support',
  // CA §5.4 (slice 2.34b): a change of the application opens its page.
  'application' => '/application',
  // Slice 2.35a: «مرحباً بك في FOX DROP!» opens home (the session is read
  // again first), a contract phase «العقد والعدة», a document expiring or
  // rejected «المستندات».
  'home' => '/',
  'contract' => '/contract',
  'documents' => '/documents',
  // CA §14 #25 (slice 2.36b): a violation opens «أدائي».
  'performance' => '/performance',
  _ => null,
};

/// Opens the target of the push the captain tapped: the one that started
/// the app, and each one tapped while it ran in the background.
final pushTapsProvider = Provider<void>((ref) {
  final push = ref.watch(pushProvider);
  final router = ref.watch(routerProvider);
  // What a push changes is read again: the application, the session once
  // activated (slice 2.35a: the app moves home), the contract, the
  // documents.
  void refresh(Map<String, String> data) {
    switch (data['target']) {
      case 'application':
        ref.invalidate(applicationProvider);
      case 'home':
        ref.invalidate(applicationProvider);
        ref.invalidate(captainSessionProvider);
      case 'contract':
        ref.invalidate(contractProvider);
      case 'documents':
        ref.invalidate(captainDocumentsProvider);
      case 'performance':
        ref.invalidate(performanceProvider);
    }
  }

  void open(Map<String, String>? data) {
    final path = data == null ? null : pushTargetPath(data);
    if (path == null) return;
    // The page may already show the application: read it again.
    refresh(data!);
    router.go(path);
  }

  // CA §5.4: a change of the application while the app is open reads it
  // again, so the status page shows the new stage.
  final received = push.received.listen(refresh);
  ref.onDispose(received.cancel);
  final taps = push.taps.listen(open);
  unawaited(
    push.initialTap().then(
      open,
      onError: (Object error) => debugPrint('No initial push: $error'),
    ),
  );
  ref.onDispose(taps.cancel);
});
