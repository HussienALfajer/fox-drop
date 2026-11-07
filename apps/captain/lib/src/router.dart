import 'package:core_auth/core_auth.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'auth.dart';
import 'home_screen.dart';
import 'not_found_screen.dart';
import 'starting_screen.dart';

/// Signed out, every route leads to sign-in; signed in, sign-in leads home.
final routerProvider = Provider<GoRouter>((ref) {
  final session = ValueNotifier(ref.read(captainAuth.session));
  ref.listen(captainAuth.session, (previous, next) => session.value = next);
  final router = GoRouter(
    refreshListenable: session,
    redirect: (context, state) {
      final current = session.value;
      final at = state.matchedLocation;
      if (!current.hasValue) return at == '/starting' ? null : '/starting';
      final signedIn = current.value is SignedIn;
      if (!signedIn) return at == '/sign-in' ? null : '/sign-in';
      return at == '/sign-in' || at == '/starting' ? '/' : null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/starting',
        builder: (context, state) => const StartingScreen(),
      ),
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const _CaptainSignInScreen(),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
  ref.onDispose(() {
    router.dispose();
    session.dispose();
  });
  return router;
});

/// CA §4.9: after a sign-in on another device, «سُجّل دخولك من جهاز آخر».
class _CaptainSignInScreen extends ConsumerWidget {
  const _CaptainSignInScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(captainAuth.session).value;
    final elsewhere =
        session is SignedOut && session.reason == SessionEndReason.otherDevice;
    return SignInScreen(
      scope: captainAuth,
      notice: elsewhere
          ? AppLocalizations.of(context).captainSignedInElsewhere
          : null,
    );
  }
}
