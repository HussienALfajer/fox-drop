import 'dart:async';

import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:core_platform/core_platform.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api.dart';
import 'auth.dart';
import 'router.dart';

/// The restaurant terms (AP §9.13, RA §4.10, S13), kept for the app's life
/// and read only while signed in (`packages/core_platform/CLAUDE.md`
/// «Terms»): read at each sign-in, forgotten at sign-out. Only owners accept
/// them: the server answers `pending: false` to a cashier.
final termsCheckProvider = Provider<TermsCheck>((ref) {
  final api = ref.watch(coreApiProvider).getMerchantApi();
  final check = TermsCheck(
    read: () async => termsOf((await api.merchantTermsGet()).data!),
    accept: (version) => api.merchantTermsAccept(
      termsAcceptDto: TermsAcceptDto((b) => b..version = version),
    ),
  );
  ref.onDispose(check.dispose);
  ref.listen(
    merchantAuth.session.select((state) => state.value is SignedIn),
    (_, signedIn) => signedIn ? check.start() : check.clear(),
    fireImmediately: true,
  );
  return check;
});

/// Whether this owner has a version to accept, for the board's banner.
final termsPendingProvider = Provider<bool>((ref) {
  final check = ref.watch(termsCheckProvider);
  void changed() => ref.invalidateSelf();
  check.addListener(changed);
  ref.onDispose(() => check.removeListener(changed));
  return check.pending;
});

/// S13: while a version is pending, an owner reaches only Orders and the
/// terms. Orders keep arriving and ringing (RA §4.10).
bool ownerScreenWaits(String path) =>
    path != '/' && path != '/terms' && !path.startsWith('/orders/');

/// RA §4.10, §5.2 item 3: an owner is asked for a new version on the next
/// open (or when the app resumes), once per version, over the board; the
/// owner may go back to Orders. Watched by `MerchantApp`.
final termsPromptProvider = Provider<void>((ref) {
  final check = ref.watch(termsCheckProvider);
  final router = ref.watch(routerProvider);
  int? prompted;
  void prompt() {
    final version = check.terms?.version;
    // Nothing pending (accepted, or signed out): the next account or version
    // is asked again.
    if (!check.pending || version == null) {
      prompted = null;
      return;
    }
    if (version == prompted) return;
    // The screen on top: a pushed one is not in the configuration's uri.
    final top = router.routerDelegate.currentConfiguration;
    if (top.isEmpty || top.last.matchedLocation != '/') return;
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
