import 'package:core_auth/core_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'auth.dart';
import 'device.dart';
import 'device_name_screen.dart';
import 'home_screen.dart';
import 'not_found_screen.dart';
import 'starting_screen.dart';

/// Signed out, every route leads to sign-in; signed in on a device without a
/// name, to «سمِّ هذا الجهاز» (RA §5.2 item 5); then home.
final routerProvider = Provider<GoRouter>((ref) {
  final changes = ValueNotifier(0);
  ref.listen(merchantAuth.session, (previous, next) => changes.value++);
  ref.listen(merchantSessionProvider, (previous, next) => changes.value++);
  final router = GoRouter(
    refreshListenable: changes,
    redirect: (context, state) {
      final at = state.matchedLocation;
      String? to(String path) => at == path ? null : path;
      final session = ref.read(merchantAuth.session);
      if (!session.hasValue) return to('/starting');
      if (session.value is! SignedIn) return to('/sign-in');
      final user = ref.read(merchantSessionProvider);
      // Until the session's details come, or when they fail, the home screen
      // shows the server status.
      if (user.value?.deviceNamed == false) return to('/device-name');
      return const {'/sign-in', '/starting', '/device-name'}.contains(at)
          ? '/'
          : null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/starting',
        builder: (context, state) => const StartingScreen(),
      ),
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => SignInScreen(scope: merchantAuth),
      ),
      GoRoute(
        path: '/device-name',
        builder: (context, state) => const DeviceNameScreen(),
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
