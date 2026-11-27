import 'package:core_alerts/testing.dart';
import 'dart:async';
import 'dart:convert';

import 'package:core_auth/testing.dart';
import 'package:core_push/testing.dart';
import 'package:core_storage/core_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:merchant/src/api.dart';
import 'package:merchant/src/app.dart';
import 'package:merchant/src/auth.dart';
import 'package:merchant/src/device.dart';
import 'package:merchant/src/platform.dart';
import 'package:merchant/src/push.dart';
import 'package:merchant/src/board/alerts.dart';
import 'package:merchant/src/board/board_screen.dart';
import 'package:merchant/src/router.dart';
import 'package:merchant/src/starting_screen.dart';

import 'board_fixtures.dart';

const _accountId = '00000000-0000-4000-8000-000000000001';

Map<String, Object?> _session({required bool deviceNamed}) => {
  'accountId': _accountId,
  'restaurantId': '00000000-0000-4000-8000-000000000002',
  'role': 'owner',
  'name': 'سامر',
  'deviceNamed': deviceNamed,
  'sessionId': '00000000-0000-4000-8000-000000000003',
};

Map<String, String> _signedIn() => {
  'session': jsonEncode({
    'accessToken': 'access-0',
    'accessTokenExpiresAt': DateTime.now()
        .add(const Duration(minutes: 10))
        .toUtc()
        .toIso8601String(),
    'refreshToken': 'refresh-0',
    'accountId': _accountId,
  }),
};

class _App {
  /// Ends the app inside the test, so the board's timers stop first.
  Future<void> done(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    container.dispose();
  }

  final server = FakeServer();
  final launched = <Uri>[];
  final push = FakePush();
  final device = MemoryDeviceStore();
  // The phone allows notifications unless a test says otherwise.
  FakeNotificationPermission permission = FakeNotificationPermission(
    allowed: true,
  );
  late final ProviderContainer container;

  /// [settle] is false for a signed-out start: the device then waits on the
  /// starting screen's spinner, since the sign-in screen left in D.R1.
  Future<void> pump(
    WidgetTester tester, {
    Map<String, String> stored = const {},
    bool settle = true,
  }) async {
    server.on('/v1/merchant/orders', [FakeAnswer(200, boardJson([]))]);
    if (!server.routes.containsKey('/v1/merchant/terms')) {
      server.on('/v1/merchant/terms', [
        const FakeAnswer(200, {
          'version': 1,
          'body': 'شروط الشراكة',
          'publishedAt': '2026-11-08T09:00:00.000Z',
          'pending': false,
        }),
      ]);
    }
    if (!server.routes.containsKey('/v1/merchant/emergency-stop')) {
      server.on('/v1/merchant/emergency-stop', [
        const FakeAnswer(200, {'active': false, 'startedAt': null}),
      ]);
    }
    if (!server.routes.containsKey('/v1/merchant/platform')) {
      server.on('/v1/merchant/platform', [
        const FakeAnswer(200, {'updateNeed': 'none', 'maintenance': false}),
      ]);
    }
    server.on('/v1/merchant/push-token', [
      const FakeAnswer(200, {'status': 'registered'}),
    ]);
    container = ProviderContainer(
      overrides: [
        authApiProvider.overrideWithValue(server.client()),
        coreApiProvider.overrideWith((ref) {
          final api = server.client();
          api.dio.interceptors.add(merchantAuth.interceptor(ref, api.dio));
          return api;
        }),
        merchantAuth.store.overrideWithValue(MemorySecureStore({...stored})),
        merchantAuth.launch.overrideWithValue((uri) async {
          launched.add(uri);
          return true;
        }),
        appVersionProvider.overrideWith((ref) async => '0.1.0'),
        realtimeTransportProvider.overrideWithValue(FakeTransport()),
        ringerProvider.overrideWithValue(FakeRinger()),
        alertsProvider.overrideWithValue(FakeAlerts()),
        keepScreenOnProvider.overrideWithValue((on) {}),
        pushProvider.overrideWithValue(push),
        notificationPermissionProvider.overrideWithValue(permission),
        deviceStoreProvider.overrideWithValue(device),
      ],
      retry: (retryCount, error) => null,
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MerchantApp(),
      ),
    );
    if (settle) {
      await tester.pumpAndSettle();
    } else {
      await tester.pump(const Duration(seconds: 1));
    }
  }
}

Map<String, Object?> _terms({required int version, required bool pending}) => {
  'version': version,
  'body': 'شروط الشراكة $version',
  'publishedAt': '2026-11-08T09:00:00.000Z',
  'pending': pending,
};

void main() {
  testWidgets(
    'an owner with a pending version sees Orders and the terms (S13)',
    (tester) async {
      final app = _App();
      app.server.on('/v1/merchant/auth/session', [
        FakeAnswer(200, _session(deviceNamed: true)),
      ]);
      app.server.on('/v1/merchant/terms', [
        FakeAnswer(200, _terms(version: 2, pending: true)),
      ]);
      app.server.on('/v1/merchant/terms/accept', [
        const FakeAnswer(200, {'status': 'accepted'}),
      ]);
      await app.pump(tester, stored: _signedIn());

      // Asked on the next open, over the board.
      expect(find.text('شروط الشراكة 2'), findsOneWidget);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.byType(BoardScreen), findsOneWidget);
      expect(find.byKey(const Key('terms-pending')), findsOneWidget);
      // Any screen other than Orders leads to the terms.
      app.container.read(routerProvider).go('/elsewhere');
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('terms-accept')), findsOneWidget);

      app.server.on('/v1/merchant/terms', [
        FakeAnswer(200, _terms(version: 2, pending: false)),
      ]);
      await tester.tap(find.byKey(const Key('terms-accept')));
      await tester.pumpAndSettle();
      expect(app.server.to('/v1/merchant/terms/accept'), hasLength(1));
      expect(find.byType(BoardScreen), findsOneWidget);
      expect(find.byKey(const Key('terms-pending')), findsNothing);
      await app.done(tester);
    },
  );

  // The sign-in itself left with its screen in D.R1 (2026-11-27): the device
  // starts signed in, not named yet.
  testWidgets('the first sign-in on a device names it (RA §5.2 item 5)', (
    tester,
  ) async {
    final app = _App();
    app.server.on('/v1/merchant/auth/session', [
      FakeAnswer(200, _session(deviceNamed: false)),
      FakeAnswer(200, _session(deviceNamed: true)),
    ]);
    app.server.on('/v1/merchant/auth/device', [
      const FakeAnswer(200, {'status': 'saved'}),
    ]);
    await app.pump(tester, stored: _signedIn());

    expect(find.text('سمِّ هذا الجهاز'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('device-name')), 'كاشير 1');
    await tester.tap(find.text('حفظ'));
    await tester.pumpAndSettle();

    final saved = app.server.to('/v1/merchant/auth/device').single;
    expect(saved.data, {
      'name': 'كاشير 1',
      'platform': 'android',
      'appVersion': '0.1.0',
    });
    expect(saved.headers['Authorization'], 'Bearer access-0');
    expect(find.text('جديدة (0)'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('answers an unknown route with the not-found screen', (
    tester,
  ) async {
    final app = _App();
    app.server.on('/v1/merchant/auth/session', [
      FakeAnswer(200, _session(deviceNamed: true)),
    ]);
    await app.pump(tester, stored: _signedIn());
    expect(find.text('جديدة (0)'), findsOneWidget);
    app.container.read(routerProvider).go('/unknown');
    await tester.pumpAndSettle();

    expect(find.text('الصفحة غير موجودة'), findsOneWidget);
    await app.done(tester);
  });

  // Push (RA §16, architecture §8.1; owner decision 2026-11-08): the token
  // while signed in, the permission once at the first sign-in, a tapped push
  // opening its order.
  group('push', () {
    const orderId = '00000000-0000-4000-8000-0000000000a1';

    _App signedIn() => _App()
      ..server.on('/v1/merchant/auth/session', [
        FakeAnswer(200, _session(deviceNamed: true)),
      ]);

    String location(_App app) => app.container
        .read(routerProvider)
        .routerDelegate
        .currentConfiguration
        .uri
        .toString();

    testWidgets('a signed-in start registers the token', (tester) async {
      final app = signedIn();
      await app.pump(tester, stored: _signedIn());
      expect(app.server.to('/v1/merchant/push-token').single.data, {
        'token': 'push-token-0',
        'platform': 'android',
      });
      await app.done(tester);
    });

    testWidgets('signed out, nothing is registered or asked', (tester) async {
      final app = _App()
        ..permission = FakeNotificationPermission(allowed: false);
      await app.pump(tester, settle: false);
      app.push.renew('push-token-1');
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(StartingScreen), findsOneWidget);
      expect(app.server.to('/v1/merchant/push-token'), isEmpty);
      expect(app.permission.requests, 0);
      await app.done(tester);
    });

    testWidgets('the first sign-in asks once per installation', (tester) async {
      final app = signedIn()
        ..permission = FakeNotificationPermission(
          allowed: false,
          answer: false,
        );
      await app.pump(tester, stored: _signedIn());
      expect(app.permission.requests, 1);
      expect(await app.device.read('notifications_asked'), isNotNull);
      await app.done(tester);

      // The next start, still not allowed, does not ask again.
      final again = signedIn()
        ..permission = app.permission
        ..device.write('notifications_asked', '1');
      await again.pump(tester, stored: _signedIn());
      expect(app.permission.requests, 1);
      await again.done(tester);
    });

    testWidgets('a phone that allows notifications is not asked', (
      tester,
    ) async {
      final app = signedIn();
      await app.pump(tester, stored: _signedIn());
      expect(app.permission.requests, 0);
      await app.done(tester);
    });

    testWidgets('a push tapped in the background opens its order', (
      tester,
    ) async {
      final app = signedIn();
      await app.pump(tester, stored: _signedIn());
      app.push.tap({'target': 'order', 'orderId': orderId, 'messageId': 'm'});
      await tester.pumpAndSettle();
      expect(location(app), '/orders/$orderId');
      await app.done(tester);
    });

    testWidgets('the push that started the app opens its order', (
      tester,
    ) async {
      final app = signedIn()
        ..push.initial = {'target': 'order', 'orderId': orderId};
      await app.pump(tester, stored: _signedIn());
      expect(location(app), '/orders/$orderId');
      await app.done(tester);
    });

    test('each target opens its screen', () {
      expect(
        pushTargetPath({'target': 'order', 'orderId': 'a b'}),
        '/orders/a%20b',
      );
      expect(pushTargetPath({'target': 'order'}), isNull);
      expect(pushTargetPath({'target': 'statement'}), isNull);
      // RA §16 #29 (slice 2.24b): «تم حل بلاغك» opens «الدعم».
      expect(
        pushTargetPath({'target': 'ticket', 'ticketId': 't1'}),
        '/support',
      );
      // RA §16 #27 (slice 2.42): no receiving device opens «الأجهزة».
      expect(pushTargetPath({'target': 'devices'}), '/settings/devices');
      // RA §16 #30–#31 (slice 2.19e).
      expect(
        pushTargetPath({'target': 'statement', 'statementId': 's1'}),
        '/account/statements/s1',
      );
      expect(
        pushTargetPath({'target': 'receipt', 'receiptId': 'r1'}),
        '/account/receipts/r1',
      );
      expect(pushTargetPath({'target': 'receipt', 'receiptId': ''}), isNull);
      // RA §16 #32 (slice 2.19f).
      expect(pushTargetPath({'target': 'account'}), '/account');
    });
  });

  // RA §4.2, §4.10: every device, signed in or not, owner or cashier.
  testWidgets('maintenance blocks the device until it is lifted', (
    tester,
  ) async {
    final app = _App();
    app.server.on('/v1/merchant/platform', [
      const FakeAnswer(200, {
        'updateNeed': 'none',
        'maintenance': true,
        'maintenanceMessage': 'نعود بعد ساعة',
      }),
    ]);
    app.server.on('/v1/merchant/auth/session', [
      FakeAnswer(200, _session(deviceNamed: true)),
    ]);
    await app.pump(tester, stored: _signedIn());
    expect(find.text('التطبيق في صيانة'), findsOneWidget);
    expect(find.text('نعود بعد ساعة'), findsOneWidget);
    expect(find.byType(BoardScreen), findsNothing);

    app.server.on('/v1/merchant/platform', [
      const FakeAnswer(200, {'updateNeed': 'none', 'maintenance': false}),
    ]);
    unawaited(app.container.read(platformCheckProvider).check());
    await tester.pumpAndSettle();
    expect(find.text('التطبيق في صيانة'), findsNothing);
    expect(find.byType(BoardScreen), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('a version below the minimum blocks with the update screen', (
    tester,
  ) async {
    final app = _App();
    app.server.on('/v1/merchant/platform', [
      const FakeAnswer(200, {'updateNeed': 'required', 'maintenance': false}),
    ]);
    await app.pump(tester);
    expect(find.text('يلزم تحديث التطبيق'), findsOneWidget);
    expect(app.server.to('/v1/merchant/platform').single.uri.queryParameters, {
      'version': '0.1.0',
    });
    await app.done(tester);
  });
}
