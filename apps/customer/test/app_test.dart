import 'package:core_auth/testing.dart';
import 'package:customer/src/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support.dart';

void main() {
  testWidgets('a guest starts at «أين نوصل طلبك؟», in Arabic, right to left', (
    tester,
  ) async {
    final app = TestApp();
    await app.pump(tester);

    expect(find.text('تطبيق الزبون'), findsOneWidget);
    final ask = find.text('أين نوصل طلبك؟');
    expect(ask, findsOneWidget);
    expect(Directionality.of(tester.element(ask)), TextDirection.rtl);
    expect(app.server.requests, isEmpty);
  });

  testWidgets('opens the customer FAQ from Content (CU §13)', (tester) async {
    final app = TestApp();
    await app.pump(tester);
    await tester.tap(find.text('الأسئلة الشائعة'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('كيف أدفع ثمن طلبي؟'));
    await tester.pumpAndSettle();
    expect(find.text('نقداً للكابتن عند الباب.'), findsOneWidget);
  });

  testWidgets('signs in from home and returns there', (tester) async {
    final app = TestApp();
    app.completedProfile();
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
        'accountId': accountId,
        'newAccount': false,
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
    final request = app.server.to('/v1/customer/auth/code').single;
    expect(
      request.uri.toString(),
      'https://api.example.test/v1/customer/auth/code',
    );
    expect((request.data as Map)['phone'], '+905321234567');
    await tester.enterText(find.byKey(const Key('sign-in-code')), '123456');
    await tester.pumpAndSettle();

    expect(find.text('أين نوصل طلبك؟'), findsOneWidget);
    expect(find.text('تسجيل الخروج'), findsOneWidget);
  });

  testWidgets('no operations code for customers when no code can be sent', (
    tester,
  ) async {
    final app = TestApp();
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
    final app = TestApp();
    await app.pump(tester);
    app.container.read(routerProvider).go('/unknown');
    await tester.pumpAndSettle();

    expect(find.text('الصفحة غير موجودة'), findsOneWidget);
  });
}
