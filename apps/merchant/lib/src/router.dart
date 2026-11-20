import 'package:core_auth/core_auth.dart';
import 'package:core_platform/core_platform.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'account/account_screen.dart';
import 'account/records_screen.dart';
import 'auth.dart';
import 'board/board_screen.dart';
import 'board/order_screen.dart';
import 'device.dart';
import 'device_name_screen.dart';
import 'history/history_screen.dart';
import 'menu/bulk_price_screen.dart';
import 'menu/menu_screen.dart';
import 'menu/preview_screen.dart';
import 'menu/price_log_screen.dart';
import 'menu/quick_edit_screen.dart';
import 'not_found_screen.dart';
import 'platform.dart';
import 'ratings/ratings_screen.dart';
import 'settings/devices_screen.dart';
import 'settings/settings_screen.dart';
import 'settings/staff_screen.dart';
import 'starting_screen.dart';
import 'status/hours_screen.dart';
import 'support/report_screen.dart';
import 'support/support_screen.dart';
import 'terms.dart';

/// Signed out, every route leads to sign-in; signed in on a device without a
/// name, to «سمِّ هذا الجهاز» (RA §5.2 item 5); then home. Maintenance or
/// a required update leads every device to `/blocked` (RA §4.2, §4.10). An
/// owner with a pending version of the terms reaches only Orders and the
/// terms (S13).
final routerProvider = Provider<GoRouter>((ref) {
  final changes = ValueNotifier(0);
  ref.listen(merchantAuth.session, (previous, next) => changes.value++);
  ref.listen(merchantSessionProvider, (previous, next) => changes.value++);
  final platform = ref.watch(platformCheckProvider);
  final terms = ref.watch(termsCheckProvider);
  final router = GoRouter(
    refreshListenable: Listenable.merge([changes, platform, terms]),
    redirect: (context, state) {
      final at = state.matchedLocation;
      String? to(String path) => at == path ? null : path;
      final session = ref.read(merchantAuth.session);
      if (!session.hasValue) return to('/starting');
      if (platform.status.blocks) return to('/blocked');
      if (at == '/blocked') return '/';
      if (session.value is! SignedIn) return to('/sign-in');
      final user = ref.read(merchantSessionProvider);
      // Until the session's details come, or when they fail, the board waits
      // for them.
      if (user.value?.deviceNamed == false) return to('/device-name');
      if (const {'/sign-in', '/starting', '/device-name'}.contains(at)) {
        return '/';
      }
      return terms.pending && ownerScreenWaits(at) ? '/terms' : null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const BoardScreen()),
      GoRoute(
        path: '/orders/:id',
        builder: (context, state) =>
            OrderScreen(orderId: state.pathParameters['id']!),
      ),
      // RA §8.18 (slice 2.40): «السجل» for owners and cashiers (a cashier's
      // range is fixed by the server); an order's detail over it.
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) =>
                HistoryOrderScreen(orderId: state.pathParameters['id']!),
          ),
        ],
      ),
      // RA §6.1 #4, §10: the status for everyone, the hours for owners.
      GoRoute(
        path: '/status-and-hours',
        builder: (context, state) => const HoursScreen(),
      ),
      // RA §6.1 #3, §9 (slice 2.32a): «القائمة» for owners and cashiers
      // (availability only); the bulk change, the price log and the preview
      // are the owners' (a cashier's call is 403 owner_only).
      GoRoute(
        path: '/menu',
        builder: (context, state) => const MenuScreen(),
        routes: [
          GoRoute(
            path: 'quick-edit',
            builder: (context, state) => const QuickEditScreen(),
          ),
          GoRoute(
            path: 'bulk-price',
            builder: (context, state) => const BulkPriceScreen(),
          ),
          GoRoute(
            path: 'price-log',
            builder: (context, state) => const PriceLogScreen(),
          ),
          GoRoute(
            path: 'preview',
            builder: (context, state) => const PreviewScreen(),
          ),
        ],
      ),
      // RA §15: «الدعم», for owners and cashiers; «إبلاغ عن مشكلة» over it.
      GoRoute(
        path: '/support',
        builder: (context, state) => const SupportScreen(),
        routes: [
          GoRoute(
            path: 'report',
            builder: (context, state) => const ReportScreen(),
          ),
        ],
      ),
      // RA §14.3: the owners' settings (a cashier's read is 403 owner_only),
      // with «الموظفون» and «الأجهزة» under them (RA §14.1–14.2; owner
      // decision 2026-11-19).
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'staff',
            builder: (context, state) => const StaffScreen(),
          ),
          GoRoute(
            path: 'devices',
            builder: (context, state) => const DevicesScreen(),
          ),
        ],
      ),
      // RA §13, §6.1 row 7: «التقييمات», the owners' (a cashier's read is
      // 403 owner_only).
      GoRoute(
        path: '/ratings',
        builder: (context, state) => const RatingsScreen(),
      ),
      // RA §12.2, R10: «الحساب», the owners' (a cashier's read is 403
      // owner_only).
      GoRoute(
        path: '/account',
        builder: (context, state) => const AccountScreen(),
        routes: [
          // RA §12.3, §16 #30: the statements; a statement over them.
          GoRoute(
            path: 'statements',
            builder: (context, state) => const StatementsScreen(),
            routes: [
              GoRoute(
                path: ':statementId',
                builder: (context, state) => StatementScreen(
                  statementId: state.pathParameters['statementId']!,
                ),
              ),
            ],
          ),
          // RA §12.4, §16 #31: the receipts; a receipt over them.
          GoRoute(
            path: 'receipts',
            builder: (context, state) => const ReceiptsScreen(),
            routes: [
              GoRoute(
                path: ':receiptId',
                builder: (context, state) => ReceiptScreen(
                  receiptId: state.pathParameters['receiptId']!,
                ),
              ),
            ],
          ),
        ],
      ),
      // AP §9.13, RA §4.10: the restaurant terms, which owners accept.
      GoRoute(
        path: '/terms',
        builder: (context, state) => WithStopBanner(
          child: TermsScreen(
            check: terms,
            onAccepted: () =>
                context.canPop() ? context.pop() : context.go('/'),
          ),
        ),
      ),
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
        builder: (context, state) => SignInScreen(scope: merchantAuth),
      ),
      GoRoute(
        path: '/device-name',
        builder: (context, state) =>
            const WithStopBanner(child: DeviceNameScreen()),
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
