import 'package:core_auth/core_auth.dart';
import 'package:core_platform/core_platform.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'account/delete_account_screen.dart';
import 'account/my_account_screen.dart';
import 'auth.dart';
import 'blocked_screen.dart';
import 'browsing/banner_list_screen.dart';
import 'browsing/category_screen.dart';
import 'browsing/price_report_screen.dart';
import 'browsing/restaurant_screen.dart';
import 'cart/cart_screen.dart';
import 'checkout/checkout_screen.dart';
import 'codes/my_codes_screen.dart';
import 'content.dart';
import 'home_screen.dart';
import 'not_found_screen.dart';
import 'notifications/notifications_screen.dart';
import 'orders/order_screen.dart';
import 'orders/report_problem_screen.dart';
import 'platform.dart';
import 'profile/profile.dart';
import 'profile/profile_screen.dart';
import 'starting_screen.dart';
import 'terms.dart';

/// Where a screen that needs sign-in sends a guest: the sign-in screen, then
/// back to [from] (CU §5.1).
String signInFrom(String from) =>
    Uri(path: '/sign-in', queryParameters: {'from': from}).toString();

// Only a path of this app, never another address.
String _safeFrom(String? from) =>
    from != null && from.startsWith('/') && !from.startsWith('//') ? from : '/';

/// Guests browse (CU §5.1); a signed-in customer leaves the sign-in screen
/// for where they were, through «أكمل بياناتك» while the profile is not
/// completed (CU §5.3). A required update or maintenance leads to
/// `/blocked`, except an order's screen (CU §4.2, §4.7). A new version of
/// the terms is pushed by `termsPromptProvider` (`terms.dart`).
final routerProvider = Provider<GoRouter>((ref) {
  final changes = ValueNotifier(0);
  void changed(Object? previous, Object? next) => changes.value++;
  ref.listen(customerAuth.session, changed);
  ref.listen(profileProvider, changed);
  final platform = ref.watch(platformCheckProvider);
  final router = GoRouter(
    refreshListenable: Listenable.merge([changes, platform]),
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
      if (platform.status.blocks) {
        return at == '/blocked' || at.startsWith('/orders/')
            ? null
            : '/blocked';
      }
      if (at == '/blocked') return '/';
      final signedIn = session.value is SignedIn;
      final profile = ref.read(profileProvider).value;
      final completing = signedIn && profile != null && !profile.completed;
      if (completing && at != '/complete-profile' && at != '/terms') {
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
        path: '/restaurants/:id',
        builder: (context, state) =>
            RestaurantScreen(restaurantId: state.pathParameters['id']!),
      ),
      // A banner's list of restaurants (AP §9.11.2, slice 2.27c).
      GoRoute(
        path: '/banners/:id',
        builder: (context, state) =>
            BannerListScreen(bannerId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/categories/:id',
        builder: (context, state) =>
            CategoryScreen(categoryId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/blocked',
        builder: (context, state) => const BlockedScreen(),
      ),
      GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
      GoRoute(path: '/faq', builder: (context, state) => const FaqScreen()),
      // CU §13 «الشروط والخصوصية», and the pending version (CU §4.7).
      GoRoute(
        path: '/terms',
        builder: (context, state) => TermsScreen(
          check: ref.read(termsCheckProvider),
          onAccepted: () => context.canPop() ? context.pop() : context.go('/'),
        ),
      ),
      // CU §13 «الإشعارات»: the account's, so a guest signs in first.
      GoRoute(
        path: '/notifications',
        redirect: (context, state) =>
            ref.read(customerAuth.session).value is SignedIn
            ? null
            : signInFrom('/notifications'),
        builder: (context, state) => const NotificationsScreen(),
      ),
      // CU §13 «حسابي» and its «بياناتي»: signed-in customers only.
      GoRoute(
        path: '/account',
        redirect: (context, state) =>
            ref.read(customerAuth.session).value is SignedIn
            ? null
            : signInFrom('/account'),
        builder: (context, state) => const MyAccountScreen(),
        routes: [
          GoRoute(
            path: 'profile',
            builder: (context, state) =>
                const ProfileScreen(from: '/account', editing: true),
          ),
          // CU §5.6 «حذف الحساب» (slice 2.25c).
          GoRoute(
            path: 'delete',
            builder: (context, state) => const DeleteAccountScreen(),
          ),
        ],
      ),
      // CU §12.4 «أكوادي»: the account's, so a guest signs in first. A
      // banner's code opens it on that code (`?code=`, CU §8.1).
      GoRoute(
        path: '/codes',
        redirect: (context, state) =>
            ref.read(customerAuth.session).value is SignedIn
            ? null
            : signInFrom(state.uri.toString()),
        builder: (context, state) =>
            MyCodesScreen(shown: state.uri.queryParameters['code']),
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/orders/:id',
        builder: (context, state) =>
            OrderScreen(orderId: state.pathParameters['id']!),
      ),
      // CU §9.5 «أبلغ عن سعر مختلف»: signed-in customers only.
      GoRoute(
        path: '/restaurants/:id/price-report',
        redirect: (context, state) =>
            ref.read(customerAuth.session).value is SignedIn
            ? null
            : signInFrom(state.uri.path),
        builder: (context, state) =>
            PriceReportScreen(restaurantId: state.pathParameters['id']!),
      ),
      // CU §12.2 «الإبلاغ عن مشكلة»: reached from a signed-in order screen.
      GoRoute(
        path: '/orders/:id/report',
        builder: (context, state) =>
            ReportProblemScreen(orderId: state.pathParameters['id']!),
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
