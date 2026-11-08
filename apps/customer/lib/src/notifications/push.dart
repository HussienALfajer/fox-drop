import 'dart:async';

import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:core_push/core_push.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../auth.dart';
import '../router.dart';

/// The installation's push (`packages/core_push`): `main` gives the one
/// `startPush` started; tests give a `FakePush`.
final pushProvider = Provider<Push>((ref) => const NoPush());

/// The token kept registered while the customer is signed in (CU §14,
/// architecture §8.1). Guests get no push.
final pushTokensProvider = Provider<PushTokens>((ref) {
  final tokens = PushTokens(ref.watch(pushProvider), (token) async {
    await ref
        .read(coreApiProvider)
        .getCustomerApi()
        .customerPushTokenRegister(
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
    customerAuth.session,
    (previous, next) => follow(next.value),
    fireImmediately: true,
  );
  ref.onDispose(tokens.dispose);
  return tokens;
});

/// The route a push's data opens (CU §14): rows 1 to 15 open their order.
/// The codes and the account («أكوادي», rows 16 and 21) come with their
/// slices; until then such a tap only opens the app.
String? pushTargetPath(Map<String, String> data) => switch (data) {
  {'target': 'order', 'orderId': final id} when id.isNotEmpty =>
    '/orders/${Uri.encodeComponent(id)}',
  // CU §14 #19: «الخدمة عادت».
  {'target': 'home'} => '/',
  _ => null,
};

/// Opens the target of the push the customer tapped: the one that started
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
