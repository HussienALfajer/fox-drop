import 'package:core_auth/testing.dart';
import 'package:core_storage/core_storage.dart';
import 'package:customer/src/api.dart';
import 'package:customer/src/app.dart';
import 'package:customer/src/auth.dart';
import 'package:customer/src/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _App {
  _App({int status = 200}) {
    server.on('/v1/customer/status', [
      FakeAnswer(status, {'status': 'ok', 'serverTime': 1}),
    ]);
  }

  final server = FakeServer();
  late final ProviderContainer container;

  Future<void> pump(WidgetTester tester) async {
    container = ProviderContainer(
      overrides: [
        authApiProvider.overrideWithValue(server.client()),
        coreApiProvider.overrideWith((ref) {
          final api = server.client();
          api.dio.interceptors.add(customerAuth.interceptor(ref, api.dio));
          return api;
        }),
        customerAuth.store.overrideWithValue(MemorySecureStore()),
      ],
      retry: (retryCount, error) => null,
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const CustomerApp(),
      ),
    );
    await tester.pumpAndSettle();
  }
}

void main() {
  testWidgets('a guest sees the server status in Arabic, right to left', (
    tester,
  ) async {
    final app = _App();
    await app.pump(tester);

    expect(find.text('تطبيق الزبون'), findsOneWidget);
    final status = find.text('الخادم يعمل');
    expect(status, findsOneWidget);
    expect(Directionality.of(tester.element(status)), TextDirection.rtl);
    final request = app.server.to('/v1/customer/status').single;
    expect(
      request.uri.toString(),
      'https://api.example.test/v1/customer/status',
    );
    expect(request.headers['Authorization'], isNull);
  });

  testWidgets('says when the server cannot be reached', (tester) async {
    await _App(status: 503).pump(tester);

    expect(find.text('تعذّر الاتصال بالخادم'), findsOneWidget);
  });

  testWidgets('signs in from home and returns there', (tester) async {
    final app = _App();
    await app.pump(tester);
    app.server.on('/v1/customer/auth/code', [
      FakeAnswer(200, {
        'channel': 'whatsapp',
        'resendAfterSec': 60,
        'expiresAt': DateTime.now().toUtc().toIso8601String(),
      }),
    ]);
    app.server.on('/v1/customer/auth/sign-in', [
      FakeAnswer(200, {
        'accountId': '00000000-0000-4000-8000-000000000001',
        'newAccount': true,
        ...tokens('1', DateTime.now().add(const Duration(minutes: 15))),
      }),
    ]);

    await tester.tap(find.text('تسجيل الدخول'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('سوريا +963'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('تركيا +90').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('sign-in-phone')),
      '05321234567',
    );
    await tester.tap(find.text('إرسال الرمز'));
    await tester.pumpAndSettle();
    expect(
      (app.server.to('/v1/customer/auth/code').single.data as Map)['phone'],
      '+905321234567',
    );
    await tester.enterText(find.byKey(const Key('sign-in-code')), '123456');
    await tester.pumpAndSettle();

    expect(find.text('تم تسجيل الدخول'), findsOneWidget);
  });

  testWidgets('no operations code for customers when no code can be sent', (
    tester,
  ) async {
    final app = _App();
    await app.pump(tester);
    app.server.on('/v1/customer/auth/code', [
      const FakeAnswer(503, {'error': 'unavailable'}),
    ]);
    await tester.tap(find.text('تسجيل الدخول'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('sign-in-phone')),
      '0944123456',
    );
    await tester.tap(find.text('إرسال الرمز'));
    await tester.pumpAndSettle();

    expect(find.text('تعذّر إرسال الرمز الآن، حاول بعد قليل.'), findsOneWidget);
    expect(find.text('لديّ رمز من العمليات'), findsNothing);
  });

  testWidgets('answers an unknown route with the not-found screen', (
    tester,
  ) async {
    final app = _App();
    await app.pump(tester);
    app.container.read(routerProvider).go('/unknown');
    await tester.pumpAndSettle();

    expect(find.text('الصفحة غير موجودة'), findsOneWidget);
  });
}
