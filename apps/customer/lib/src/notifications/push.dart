import 'dart:async';

import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:core_push/core_push.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../auth.dart';
import '../orders/order_live.dart';
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
              ..platform = defaultTargetPlatform == TargetPlatform.iOS
                  ? PushTokenDtoPlatformEnum.ios
                  : PushTokenDtoPlatformEnum.android,
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
/// The account (row 21) comes with its slice; until then such a tap only
/// opens the app.
String? pushTargetPath(Map<String, String> data) => switch (data) {
  {'target': 'order', 'orderId': final id} when id.isNotEmpty =>
    '/orders/${Uri.encodeComponent(id)}',
  // CU §14 #19: «الخدمة عادت»; #22: a mass push to the home.
  {'target': 'home'} => '/',
  // CU §14 #22 (AP §9.11.4): a mass push's restaurant, or «أكوادي» on its
  // code, as a banner opens them.
  {'target': 'restaurant', 'restaurantId': final id} when id.isNotEmpty =>
    '/restaurants/${Uri.encodeComponent(id)}',
  {'target': 'codes', 'code': final code} when code.isNotEmpty => Uri(
    path: '/codes',
    queryParameters: {'code': code},
  ).toString(),
  // CU §14 #23: «أُعيد الكود {الكود} إلى أكوادك».
  {'target': 'codes'} => '/codes',
  _ => null,
};

/// AP §9.11.4 «وصل»: the app acknowledges a mass push when it arrives
/// (`POST /v1/customer/push-receipts`, public: the background handler has
/// no session). A failed call is not tried again: the count is a measure.
Future<void> acknowledgePush(CoreApi api, PushData data) async {
  final messageId = data['messageId'];
  if (data['kind'] != 'mass_push' || messageId == null) return;
  try {
    await api.getCustomerApi().customerPushReceiptsReceive(
      customerPushReceiptDto: CustomerPushReceiptDto(
        (b) => b..messageId = messageId,
      ),
    );
  } catch (error) {
    debugPrint('Push receipt failed: $error');
  }
}

/// The mass pushes that arrive while the app is open.
final pushReceiptsProvider = Provider<void>((ref) {
  final push = ref.watch(pushProvider);
  final receipts = push.received.listen(
    (data) => unawaited(acknowledgePush(ref.read(authApiProvider), data)),
  );
  ref.onDispose(receipts.cancel);
});

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

/// CU §11.7 (slice 2.13d): the door ping that arrives while the app is open
/// opens its order over the screen the customer is on, whose screen rings
/// full screen. Any push of the order on screen reads the order now: its
/// socket may be down, and the late code (CU §11.6, slice 2.22c) changes the
/// order without an event. The system shows no notification in the
/// foreground.
final doorPingsProvider = Provider<void>((ref) {
  final push = ref.watch(pushProvider);
  final router = ref.watch(routerProvider);
  final pings = push.received.listen((data) {
    final orderId = data['orderId'];
    final path = pushTargetPath(data);
    if (orderId == null || path == null || data['target'] != 'order') return;
    final here = router.state.uri.toString();
    if (here == path) {
      unawaited(ref.read(orderFeedProvider(orderId)).refresh());
    } else if (data['kind'] == 'door_ping') {
      unawaited(router.push(path));
    }
  });
  ref.onDispose(pings.cancel);
});
