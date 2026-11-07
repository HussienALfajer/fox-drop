import 'package:core_auth/core_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'auth.dart';
import 'home_screen.dart';
import 'not_found_screen.dart';
import 'profile/profile.dart';
import 'profile/profile_screen.dart';
import 'starting_screen.dart';

/// Where a screen that needs sign-in sends a guest: the sign-in screen, then
/// back to [from] (CU §5.1).
String signInFrom(String from) =>
    Uri(path: '/sign-in', queryParameters: {'from': from}).toString();

// Only a path of this app, never another address.
String _safeFrom(String? from) =>
    from != null && from.startsWith('/') && !from.startsWith('//') ? from : '/';

/// Guests browse (CU §5.1); a signed-in customer leaves the sign-in screen
/// for where they were, through «أكمل بياناتك» while the profile is not
/// completed (CU §5.3).
final routerProvider = Provider<GoRouter>((ref) {
  final changes = ValueNotifier(0);
  void changed(Object? previous, Object? next) => changes.value++;
  ref.listen(customerAuth.session, changed);
  ref.listen(profileProvider, changed);
  final router = GoRouter(
    refreshListenable: changes,
    redirect: (context, state) {
      final session = ref.read(customerAuth.session);
      final at = state.matchedLocation;
      final from = _safeFrom(state.uri.queryParameters['from']);
      if (!session.hasValue) {
        return at == '/starting'
            ? null
            : Uri(
                path: '/starting',
                queryParameters: {'from': state.uri.toString()},
              ).toString();
      }
      final signedIn = session.value is SignedIn;
      final profile = ref.read(profileProvider).value;
      final completing = signedIn && profile != null && !profile.completed;
      if (completing && at != '/complete-profile') {
        final next = at == '/sign-in' || at == '/starting'
            ? from
            : state.uri.toString();
        return Uri(
          path: '/complete-profile',
          queryParameters: {'from': next},
        ).toString();
      }
      if (at == '/starting' || (signedIn && at == '/sign-in')) return from;
      if (at == '/complete-profile' && !completing) return from;
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
      GoRoute(
        path: '/complete-profile',
        builder: (context, state) =>
            ProfileScreen(from: _safeFrom(state.uri.queryParameters['from'])),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
  ref.onDispose(() {
    router.dispose();
    changes.dispose();
  });
  return router;
});
