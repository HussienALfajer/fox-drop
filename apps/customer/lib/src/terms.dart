import 'dart:async';

import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:core_platform/core_platform.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api.dart';
import 'auth.dart';
import 'router.dart';

/// The customer terms (AP §9.13, CU §4.7), kept for the app's life and read
/// only while signed in (`packages/core_platform/CLAUDE.md` «Terms»): read
/// at each sign-in, forgotten at sign-out, so `pending` is the signed-in
/// account's. A guest has nothing to accept: the screen reads the text when
/// it opens.
final termsCheckProvider = Provider<TermsCheck>((ref) {
  final api = ref.watch(coreApiProvider).getCustomerApi();
  final check = TermsCheck(
    read: () async => termsOf((await api.customerTermsGet()).data!),
    accept: (version) => api.customerTermsAccept(
      termsAcceptDto: TermsAcceptDto((b) => b..version = version),
    ),
  );
  ref.onDispose(check.dispose);
  ref.listen(
    customerAuth.session.select((state) => state.value is SignedIn),
    (_, signedIn) => signedIn ? check.start() : check.clear(),
    fireImmediately: true,
  );
  return check;
});

/// Whether the signed-in customer has a version to accept, for the home
/// banner (CU §6.2 item 5).
final termsPendingProvider = Provider<bool>((ref) {
  final check = ref.watch(termsCheckProvider);
  void changed() => ref.invalidateSelf();
  check.addListener(changed);
  ref.onDispose(() => check.removeListener(changed));
  return check.pending;
});

// Where a pending version waits: the screens before home, the blocking one,
// the terms themselves and an order's screen (an active order is never
// hidden, CU §19 #27).
bool _promptWaits(String path) =>
    const {
      '/starting',
      '/sign-in',
      '/complete-profile',
      '/blocked',
      '/terms',
    }.contains(path) ||
    path.startsWith('/orders/');

/// CU §4.7: a new version is shown on the next open (or when the app
/// resumes), once per version; the customer may go back and keep browsing,
/// while ordering waits for it. Watched by `CustomerApp`.
final termsPromptProvider = Provider<void>((ref) {
  final check = ref.watch(termsCheckProvider);
  final router = ref.watch(routerProvider);
  int? prompted;
  void prompt() {
    final version = check.terms?.version;
    if (!check.pending || version == null || version == prompted) return;
    // The screen on top: a pushed one is not in the configuration's uri.
    final top = router.routerDelegate.currentConfiguration;
    if (top.isEmpty || _promptWaits(top.last.matchedLocation)) {
      return;
    }
    prompted = version;
    scheduleMicrotask(() => unawaited(router.push('/terms')));
  }

  check.addListener(prompt);
  router.routerDelegate.addListener(prompt);
  ref.onDispose(() {
    check.removeListener(prompt);
    router.routerDelegate.removeListener(prompt);
  });
  prompt();
});
