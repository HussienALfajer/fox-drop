import 'history_screen.dart';
import 'dart:async';

import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:core_platform/core_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'api.dart';
import 'auth.dart';
import 'content.dart';
import 'custody_screen.dart';
import 'earnings_screen.dart';
import 'home_screen.dart';
import 'joining/application_screen.dart';
import 'profile/contract_screen.dart';
import 'profile/documents_screen.dart';
import 'profile/my_profile_screen.dart';
import 'profile/tour_screen.dart';
import 'joining/welcome_screen.dart';
import 'not_found_screen.dart';
import 'peak_bonus.dart';
import 'platform.dart';
import 'performance/appeal_screen.dart';
import 'performance/performance_screen.dart';
import 'settings/settings_screen.dart';
import 'shell.dart';
import 'starting_screen.dart';
import 'statements_screen.dart';
import 'support/report_screen.dart';
import 'device_check/device_check_screen.dart';
import 'support/support_screen.dart';
import 'terms.dart';
import 'work/work.dart';

/// Signed out, every route leads to the entry screen (CA §5.1: «انضم ككابتن»
/// or «تسجيل الدخول»); signed in, they lead home, or an applicant to the
/// application (slice 2.34a).
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
  // CA §5.1: the session's read tells an applicant (no captain yet). Until
  // it first answers, a signed-in app waits on `/starting` (a read again
  // keeps the last answer meanwhile), and a failed read is tried again.
  final read = ValueNotifier<CaptainSessionDtoOutput?>(null);
  Timer? again;
  ref.listen(captainSessionProvider, (previous, next) {
    if (next.hasValue) read.value = next.value;
    again?.cancel();
    if (next.hasError && !next.isLoading) {
      again = Timer(
        const Duration(seconds: 5),
        () => ref.invalidate(captainSessionProvider),
      );
    }
  }, fireImmediately: true);
  final platform = ref.watch(platformCheckProvider);
  // The root navigator, which shows a tab's screens above the tabs.
  final root = GlobalKey<NavigatorState>();
  final router = GoRouter(
    navigatorKey: root,
    refreshListenable: Listenable.merge([session, work, read, platform]),
    redirect: (context, state) {
      final current = session.value;
      final at = state.matchedLocation;
      if (!current.hasValue) return at == '/starting' ? null : '/starting';
      final signedIn = current.value is SignedIn;
      final captainSession = read.value;
      if (signedIn && captainSession == null) {
        return at == '/starting' ? null : '/starting';
      }
      // An applicant reaches the application, the terms and the work rules
      // (CA §5.2 step 4); maintenance or a required update blocks it.
      if (signedIn && captainSession?.captainId == null) {
        if (platform.status.blocks) return at == '/blocked' ? null : '/blocked';
        return _applicantRoutes.contains(at) ? null : '/application';
      }
      // Signed in, nothing is decided before the first read of the work:
      // a current order is never left, even for a moment.
      final known = current.value is! SignedIn || work.value != null;
      if (known && captainBlocked(platform.status, work.value)) {
        return at == '/blocked' ? null : '/blocked';
      }
      if (known && at == '/blocked') return '/';
      // No sign-in or join screen yet; CA §4.9's «سُجّل دخولك من جهاز آخر»
      // comes with them.
      if (!signedIn) return _signedOutRoutes.contains(at) ? null : '/welcome';
      return _signedOutRoutes.contains(at) ||
              at == '/starting' ||
              at == '/application'
          ? '/'
          : null;
    },
    routes: [
      // CA §6.2: the bottom navigation's tabs.
      ShellRoute(
        builder: (context, state, child) =>
            CaptainShell(location: state.matchedLocation, child: child),
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          // CA §10.6 «أرباحي» (slice 2.18b).
          GoRoute(
            path: '/earnings',
            builder: (context, state) => const EarningsScreen(),
            // CA §10.7 «كشف الأسبوع» (slice 2.18c), above the tabs: a
            // statement its push opens sits over the list and «أرباحي», so
            // back returns through them.
            routes: [
              GoRoute(
                path: 'statements',
                parentNavigatorKey: root,
                builder: (context, state) => const StatementsScreen(),
                routes: [
                  GoRoute(
                    path: ':statementId',
                    parentNavigatorKey: root,
                    builder: (context, state) => StatementScreen(
                      statementId: state.pathParameters['statementId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // CA §10.2 «عهدتي» (slice 2.17c).
          GoRoute(
            path: '/custody',
            builder: (context, state) => const CustodyScreen(),
          ),
          GoRoute(
            path: '/more',
            builder: (context, state) => const MoreScreen(),
          ),
        ],
      ),
      // CA §9.13 «السجل» (slice 2.40), from «المزيد».
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/work-rules',
        builder: (context, state) => const WorkRulesScreen(),
      ),
      GoRoute(path: '/faq', builder: (context, state) => const FaqScreen()),
      // CA §13 (slice 2.24c): «الدعم» and «إبلاغ عن مشكلة».
      GoRoute(
        path: '/support',
        builder: (context, state) => const SupportScreen(),
        routes: [
          GoRoute(
            path: 'report',
            // «طلب تعديل» of «ملفي» opens it with its type chosen (CA §12.1).
            builder: (context, state) =>
                ReportScreen(type: state.uri.queryParameters['type']),
          ),
        ],
      ),
      // CA §12.5 (slice 2.16): the peak windows, from home and «ملفي».
      GoRoute(
        path: '/peak-bonus',
        builder: (context, state) => const PeakWindowsScreen(),
      ),
      // CA §11 «أدائي» (slice 2.36b), the rating of 2.26c inside it.
      GoRoute(
        path: '/performance',
        builder: (context, state) => const PerformanceScreen(),
        routes: [
          // CA §11.3 «اعتراض» on one violation.
          GoRoute(
            path: 'appeal/:violationId',
            builder: (context, state) =>
                AppealScreen(violationId: state.pathParameters['violationId']!),
          ),
        ],
      ),
      // «الإعدادات» (owner decision 2026-11-11): «العملات التي أحملها».
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      // CA §4.5 (slice 2.43): «فحص الجهاز», from «الإعدادات», the banner and
      // the first «متصل» on this phone.
      GoRoute(
        path: '/device-check',
        builder: (context, state) => const DeviceCheckScreen(),
      ),
      // CA §12 (slice 2.36c): «ملفي», which opens the documents, the contract
      // and the peak windows.
      GoRoute(
        path: '/profile',
        builder: (context, state) => const MyProfileScreen(),
      ),
      // CA §12.2–12.4, §5.5 (slice 2.35a): «المستندات», «العقد والعدة» and
      // the welcome tour after the activation.
      GoRoute(
        path: '/documents',
        builder: (context, state) => const DocumentsScreen(),
      ),
      GoRoute(
        path: '/contract',
        builder: (context, state) => const ContractScreen(),
      ),
      GoRoute(path: '/tour', builder: (context, state) => const TourScreen()),
      // AP §9.13, K7: the captain terms, accepted before going online.
      GoRoute(
        path: '/terms',
        builder: (context, state) => TermsScreen(
          check: ref.read(termsCheckProvider),
          onAccepted: () => context.canPop() ? context.pop() : context.go('/'),
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
      // CA §5.1–5.4 (slice 2.34a): the entry, «انضم ككابتن» and the
      // applicant's application.
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/application',
        builder: (context, state) => const ApplicationScreen(),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
  ref.onDispose(() {
    router.dispose();
    session.dispose();
    work.dispose();
    read.dispose();
    again?.cancel();
  });
  return router;
});

const _signedOutRoutes = {'/welcome'};
const _applicantRoutes = {'/application', '/terms', '/work-rules'};
