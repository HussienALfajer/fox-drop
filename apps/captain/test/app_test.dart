import 'package:captain/src/api.dart';
import 'package:captain/src/auth.dart';
import 'package:captain/src/router.dart';
import 'package:core_auth/core_auth.dart';
import 'package:core_auth/testing.dart';
import 'package:core_storage/core_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

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
    final app = TestApp();
    await app.pump(tester, stored: {});
    expect(find.text('تسجيل الدخول'), findsWidgets);
    expect(
      Directionality.of(tester.element(find.text('رقم الهاتف'))),
      TextDirection.rtl,
    );

    app.server.on('/v1/captain/auth/code', [FakeAnswer(200, _codeSent())]);
    app.server.on('/v1/captain/auth/sign-in', [
      FakeAnswer(200, {
        'accountId': accountId,
        'captainId': captainId,
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

    app.work(availability: [availabilityJson()]);
    await tester.enterText(find.byKey(const Key('sign-in-code')), '123456');
    await app.settle(tester);
    await app.live(tester);
    expect(find.text('غير متصل'), findsOneWidget);
    expect(
      app.server.to('/v1/captain/auth/session').single.headers['Authorization'],
      'Bearer access-1',
    );

    await tester.tap(find.text('تسجيل الخروج'));
    await app.settle(tester);
    expect(find.text('رقم الهاتف'), findsOneWidget);
    expect(app.server.to('/v1/captain/auth/sign-out'), hasLength(1));
    await app.done(tester);
  });

  testWidgets('offers «لديّ رمز من العمليات» when no code can be sent', (
    tester,
  ) async {
    final app = TestApp();
    await app.pump(tester, stored: {});
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

  testWidgets('a second device is refused during an active order (CA §4.9)', (
    tester,
  ) async {
    final app = TestApp();
    await app.pump(tester, stored: {});
    app.server.on('/v1/captain/auth/code', [FakeAnswer(200, _codeSent())]);
    app.server.on('/v1/captain/auth/sign-in', [
      const FakeAnswer(403, {'error': 'active_order_elsewhere'}),
    ]);
    await tester.enterText(
      find.byKey(const Key('sign-in-phone')),
      '0944123456',
    );
    await tester.tap(find.text('إرسال الرمز'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('sign-in-code')), '123456');
    await tester.pumpAndSettle();

    expect(
      find.text(
        'لديك طلب نشط على جهاز آخر. اتصل بالعمليات لتحرير جهازك القديم.',
      ),
      findsOneWidget,
    );
    await app.done(tester);
  });

  testWidgets('a sign-in on another device signs this one out', (tester) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    await app.pump(tester);
    app.server.on('/v1/captain/auth/session', [
      const FakeAnswer(401, {'statusCode': 401, 'error': 'other_device'}),
    ]);
    app.container.invalidate(captainSessionProvider);
    await app.settle(tester);

    expect(find.text('سُجّل دخولك من جهاز آخر'), findsOneWidget);
    expect(find.text('رقم الهاتف'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('answers an unknown route with the not-found screen', (
    tester,
  ) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    await app.pump(tester);
    app.container.read(routerProvider).go('/unknown');
    await app.settle(tester);

    expect(find.text('الصفحة غير موجودة'), findsOneWidget);
    await app.done(tester);
  });

  test('the account id survives in the session', () async {
    final container = ProviderContainer(
      overrides: [
        captainAuth.store.overrideWithValue(MemorySecureStore(signedIn())),
      ],
    );
    addTearDown(container.dispose);
    final session = await container.read(captainAuth.session.future);
    expect((session as SignedIn).accountId, accountId);
  });
}
