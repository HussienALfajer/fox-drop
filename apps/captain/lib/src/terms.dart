import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:core_platform/core_platform.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api.dart';
import 'auth.dart';

/// The captain terms (AP §9.13, CA §4.8, K7), kept for the app's life and
/// read only while signed in (`packages/core_platform/CLAUDE.md` «Terms»):
/// read at each sign-in, forgotten at sign-out. A pending version blocks
/// going online, never a current order or an online captain (CA §7.2).
final termsCheckProvider = Provider<TermsCheck>((ref) {
  final api = ref.watch(coreApiProvider).getCaptainApi();
  final check = TermsCheck(
    read: () async => termsOf((await api.captainTermsGet()).data!),
    accept: (version) => api.captainTermsAccept(
      termsAcceptDto: TermsAcceptDto((b) => b..version = version),
    ),
  );
  ref.onDispose(check.dispose);
  ref.listen(
    captainAuth.session.select((state) => state.value is SignedIn),
    (_, signedIn) => signedIn ? check.start() : check.clear(),
    fireImmediately: true,
  );
  return check;
});

/// Whether the signed-in captain has a version to accept, for home.
final termsPendingProvider = Provider<bool>((ref) {
  final check = ref.watch(termsCheckProvider);
  void changed() => ref.invalidateSelf();
  check.addListener(changed);
  ref.onDispose(() => check.removeListener(changed));
  return check.pending;
});
