import 'dart:convert';

import 'package:captain/src/api.dart';
import 'package:captain/src/app.dart';
import 'package:captain/src/auth.dart';
import 'package:captain/src/router.dart';
import 'package:core_auth/core_auth.dart';
import 'package:core_auth/testing.dart';
import 'package:core_storage/core_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _accountId = '00000000-0000-4000-8000-000000000001';

/// The stored session of a signed-in captain.
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
  final server = FakeServer();
  final launched = <Uri>[];
  late final ProviderContainer container;

  Future<void> pump(
    WidgetTester tester, {
    Map<String, String> stored = const {},
  }) async {
    server.on('/v1/captain/status', [
      const FakeAnswer(200, {'status': 'ok', 'serverTime': 1}),
    ]);
    container = ProviderContainer(
      overrides: [
        authApiProvider.overrideWithValue(server.client()),
        coreApiProvider.overrideWith((ref) {
          final api = server.client();
          api.dio.interceptors.add(captainAuth.interceptor(ref, api.dio));
          return api;
        }),
        captainAuth.store.overrideWithValue(MemorySecureStore({...stored})),
        captainAuth.launch.overrideWithValue((uri) async {
          launched.add(uri);
          return true;
        }),
      ],
      retry: (retryCount, error) => null,
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const CaptainApp(),
      ),
    );
    await tester.pumpAndSettle();
  }
}

Map<String, Object?> _codeSent() => {
  'channel': 'whatsapp',
  'resendAfterSec': 60,
  'expiresAt': DateTime.now()
      .add(const Duration(minutes: 5))
      .toUtc()
      .toIso8601String(),
};

void main() {
  testWidgets('signs in with a WhatsApp code, right to left, and out again', (
    tester,
  ) async {
    final app = _App();
    await app.pump(tester);
    expect(find.text('تسجيل الدخول'), findsWidgets);
    expect(
      Directionality.of(tester.element(find.text('رقم الهاتف'))),
      TextDirection.rtl,
    );

    app.server.on('/v1/captain/auth/code', [FakeAnswer(200, _codeSent())]);
    app.server.on('/v1/captain/auth/sign-in', [
      FakeAnswer(200, {
        'accountId': _accountId,
        'captainId': '00000000-0000-4000-8000-000000000002',
        ...tokens('1', DateTime.now().add(const Duration(minutes: 15))),
      }),
    ]);
    await tester.enterText(
      find.byKey(const Key('sign-in-phone')),
      '0944123456',
    );
    await tester.tap(find.text('إرسال الرمز'));
    await tester.pumpAndSettle();
    expect(
      find.text('أرسلنا الرمز إلى واتساب على الرقم +963944123456'),
      findsOneWidget,
    );
    expect(find.text('إعادة الإرسال بعد 60 ث'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('sign-in-code')), '123456');
    await tester.pumpAndSettle();
    expect(find.text('تم تسجيل الدخول'), findsOneWidget);
    expect(find.text('الخادم يعمل'), findsOneWidget);
    expect(
      app.server.to('/v1/captain/status').single.headers['Authorization'],
      'Bearer access-1',
    );

    await tester.tap(find.text('تسجيل الخروج'));
    await tester.pumpAndSettle();
    expect(find.text('رقم الهاتف'), findsOneWidget);
    expect(app.server.to('/v1/captain/auth/sign-out'), hasLength(1));
  });

  testWidgets('offers «لديّ رمز من العمليات» when no code can be sent', (
    tester,
  ) async {
    final app = _App();
    await app.pump(tester);
    app.server.on('/v1/captain/auth/code', [
      const FakeAnswer(503, {'error': 'unavailable'}),
    ]);
    app.server.on('/v1/captain/contact', [
      const FakeAnswer(200, {'phone': '+963944000000'}),
    ]);
    await tester.enterText(find.byKey(const Key('sign-in-phone')), '944123456');
    await tester.tap(find.text('إرسال الرمز'));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'تعذّر إرسال الرمز الآن. اتصل بالعمليات ليعطوك رمز دخول، أو حاول بعد قليل.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('اتصال بالعمليات'));
    expect(app.launched.single.toString(), 'tel:+963944000000');

    await tester.tap(find.text('لديّ رمز من العمليات'));
    await tester.pumpAndSettle();
    expect(
      find.text('أدخل رمز الدخول الذي أعطتك إياه العمليات للرقم +963944123456'),
      findsOneWidget,
    );
    expect(find.textContaining('إعادة الإرسال'), findsNothing);
  });

  testWidgets('a sign-in on another device signs this one out', (tester) async {
    final app = _App();
    await app.pump(tester, stored: _signedIn());
    app.server.on('/v1/captain/status', [
      const FakeAnswer(401, {'statusCode': 401, 'error': 'other_device'}),
    ]);
    app.container.invalidate(statusProvider);
    await tester.pumpAndSettle();

    expect(find.text('سُجّل دخولك من جهاز آخر'), findsOneWidget);
    expect(find.text('رقم الهاتف'), findsOneWidget);
  });

  testWidgets('answers an unknown route with the not-found screen', (
    tester,
  ) async {
    final app = _App();
    await app.pump(tester, stored: _signedIn());
    app.container.read(routerProvider).go('/unknown');
    await tester.pumpAndSettle();

    expect(find.text('الصفحة غير موجودة'), findsOneWidget);
  });

  test('the account id survives in the session', () async {
    final container = ProviderContainer(
      overrides: [
        captainAuth.store.overrideWithValue(MemorySecureStore(_signedIn())),
      ],
    );
    addTearDown(container.dispose);
    final session = await container.read(captainAuth.session.future);
    expect((session as SignedIn).accountId, _accountId);
  });
}
