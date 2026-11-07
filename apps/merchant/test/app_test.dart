import 'package:core_auth/testing.dart';
import 'package:core_storage/core_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:merchant/src/api.dart';
import 'package:merchant/src/app.dart';
import 'package:merchant/src/auth.dart';
import 'package:merchant/src/device.dart';
import 'package:merchant/src/router.dart';

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
  'session.access_token': 'access-0',
  'session.access_expires_at': DateTime.now()
      .add(const Duration(minutes: 10))
      .toUtc()
      .toIso8601String(),
  'session.refresh_token': 'refresh-0',
  'session.account_id': _accountId,
};

class _App {
  final server = FakeServer();
  final launched = <Uri>[];
  late final ProviderContainer container;

  Future<void> pump(
    WidgetTester tester, {
    Map<String, String> stored = const {},
  }) async {
    server.on('/v1/merchant/status', [
      const FakeAnswer(200, {'status': 'ok', 'serverTime': 1}),
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
      ],
      retry: (retryCount, error) => null,
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MerchantApp(),
      ),
    );
    await tester.pumpAndSettle();
  }
}

void main() {
  testWidgets('the first sign-in on a device names it (RA §5.2 item 5)', (
    tester,
  ) async {
    final app = _App();
    await app.pump(tester);
    app.server.on('/v1/merchant/auth/code', [
      FakeAnswer(200, {
        'channel': 'whatsapp',
        'resendAfterSec': 60,
        'expiresAt': DateTime.now().toUtc().toIso8601String(),
      }),
    ]);
    app.server.on('/v1/merchant/auth/sign-in', [
      FakeAnswer(200, {
        ..._session(deviceNamed: false)..remove('sessionId'),
        ...tokens('1', DateTime.now().add(const Duration(minutes: 15))),
      }),
    ]);
    app.server.on('/v1/merchant/auth/session', [
      FakeAnswer(200, _session(deviceNamed: false)),
      FakeAnswer(200, _session(deviceNamed: true)),
    ]);
    app.server.on('/v1/merchant/auth/device', [
      const FakeAnswer(200, {'status': 'saved'}),
    ]);

    await tester.enterText(
      find.byKey(const Key('sign-in-phone')),
      '0944123456',
    );
    await tester.tap(find.text('إرسال الرمز'));
    await tester.pumpAndSettle();
    expect(
      (app.server.to('/v1/merchant/auth/code').single.data as Map)['platform'],
      'android',
    );
    await tester.enterText(find.byKey(const Key('sign-in-code')), '123456');
    await tester.pumpAndSettle();

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
    expect(saved.headers['Authorization'], 'Bearer access-1');
    expect(find.text('تم تسجيل الدخول'), findsOneWidget);
  });

  testWidgets('a number of no restaurant offers to call or write the team', (
    tester,
  ) async {
    final app = _App();
    await app.pump(tester);
    app.server.on('/v1/merchant/auth/code', [
      const FakeAnswer(403, {'error': 'not_registered'}),
    ]);
    app.server.on('/v1/merchant/contact', [
      const FakeAnswer(200, {
        'phone': '+963944000000',
        'whatsapp': '+963955000000',
      }),
    ]);
    await tester.enterText(
      find.byKey(const Key('sign-in-phone')),
      '0944123456',
    );
    await tester.tap(find.text('إرسال الرمز'));
    await tester.pumpAndSettle();

    expect(
      find.text('هذا الرقم غير مسجّل لدى أي مطعم في FOX DROP'),
      findsOneWidget,
    );
    expect(find.text('لديّ رمز من العمليات'), findsNothing);
    await tester.tap(find.text('واتساب العمليات'));
    expect(app.launched.single.toString(), 'https://wa.me/963955000000');
  });

  testWidgets('a draft restaurant is told its account is being set up', (
    tester,
  ) async {
    final app = _App();
    await app.pump(tester);
    app.server.on('/v1/merchant/auth/code', [
      const FakeAnswer(403, {'error': 'restaurant_draft'}),
    ]);
    await tester.enterText(
      find.byKey(const Key('sign-in-phone')),
      '0944123456',
    );
    await tester.tap(find.text('إرسال الرمز'));
    await tester.pumpAndSettle();

    expect(
      find.text('حساب مطعمك قيد الإعداد. سنتواصل معك عند جاهزيته.'),
      findsOneWidget,
    );
  });

  testWidgets('answers an unknown route with the not-found screen', (
    tester,
  ) async {
    final app = _App();
    app.server.on('/v1/merchant/auth/session', [
      FakeAnswer(200, _session(deviceNamed: true)),
    ]);
    await app.pump(tester, stored: _signedIn());
    expect(find.text('تم تسجيل الدخول'), findsOneWidget);
    app.container.read(routerProvider).go('/unknown');
    await tester.pumpAndSettle();

    expect(find.text('الصفحة غير موجودة'), findsOneWidget);
  });
}
