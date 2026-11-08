import 'package:core_auth/core_auth.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:core_platform/core_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'auth.dart';
import 'content.dart';
import 'home_screen.dart';
import 'not_found_screen.dart';
import 'platform.dart';
import 'starting_screen.dart';
import 'work/work.dart';

/// Signed out, every route leads to sign-in; signed in, sign-in leads home.
/// Maintenance or a required update leads to `/blocked`, unless the captain
/// may finish what they are doing (`captainBlocked`).
final routerProvider = Provider<GoRouter>((ref) {
  final session = ValueNotifier(ref.read(captainAuth.session));
  ref.listen(captainAuth.session, (previous, next) => session.value = next);
  final work = ValueNotifier<Work?>(null);
  ref.listen(
    workProvider,
    (previous, next) => work.value = next.value?.value,
    fireImmediately: true,
  );
  final platform = ref.watch(platformCheckProvider);
  final router = GoRouter(
    refreshListenable: Listenable.merge([session, work, platform]),
    redirect: (context, state) {
      final current = session.value;
      final at = state.matchedLocation;
      if (!current.hasValue) return at == '/starting' ? null : '/starting';
      // Signed in, nothing is decided before the first read of the work:
      // a current order is never left, even for a moment.
      final known = current.value is! SignedIn || work.value != null;
      if (known && captainBlocked(platform.status, work.value)) {
        return at == '/blocked' ? null : '/blocked';
      }
      if (known && at == '/blocked') return '/';
      final signedIn = current.value is SignedIn;
      if (!signedIn) return at == '/sign-in' ? null : '/sign-in';
      return at == '/sign-in' || at == '/starting' ? '/' : null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/work-rules',
        builder: (context, state) => const WorkRulesScreen(),
      ),
      GoRoute(path: '/faq', builder: (context, state) => const FaqScreen()),
      GoRoute(
        path: '/blocked',
        builder: (context, state) => ListenableBuilder(
          listenable: platform,
          builder: (context, _) =>
              PlatformBlockScreen(status: platform.status, url: updateUrl()),
        ),
      ),
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
    work.dispose();
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
