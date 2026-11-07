import 'package:core_auth/core_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'auth.dart';
import 'home_screen.dart';
import 'not_found_screen.dart';
import 'starting_screen.dart';

/// Guests browse (CU §5.1); a signed-in customer leaves the sign-in screen
/// for home. Returning to where the guest was (CU §5.1) comes with the
/// screens that ask for sign-in (slice 1.14d).
final routerProvider = Provider<GoRouter>((ref) {
  final session = ValueNotifier(ref.read(customerAuth.session));
  ref.listen(customerAuth.session, (previous, next) => session.value = next);
  final router = GoRouter(
    refreshListenable: session,
    redirect: (context, state) {
      final current = session.value;
      final at = state.matchedLocation;
      if (!current.hasValue) return at == '/starting' ? null : '/starting';
      final signedIn = current.value is SignedIn;
      if (at == '/starting' || (signedIn && at == '/sign-in')) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/starting',
        builder: (context, state) => const StartingScreen(),
      ),
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => SignInScreen(scope: customerAuth),
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
