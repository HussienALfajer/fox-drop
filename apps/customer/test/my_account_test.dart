import 'package:core_auth/testing.dart';
import 'package:customer/src/account/my_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support.dart';

Future<TestApp> _account(WidgetTester tester) async {
  final app = TestApp(signedIn: true);
  app.completedProfile();
  app.server.on('/v1/customer/contact', [
    const FakeAnswer(200, {
      'phone': '+963944000000',
      'whatsapp': '+963944000001',
    }),
  ]);
  await app.pump(tester);
  await tester.tap(find.byKey(const Key('open-account')));
  await tester.pumpAndSettle();
  return app;
}

// CU §13 «حسابي» (slice 2.25b): the details with the phone read-only, the
// help, joining us, the version and signing out of every device.
void main() {
  testWidgets('edits the details, the phone read-only, without the terms', (
    tester,
  ) async {
    final app = await _account(tester);
    await tester.tap(find.byKey(const Key('open-profile')));
    await tester.pumpAndSettle();
    expect(find.text('سارة'), findsOneWidget);
    expect(find.textContaining('+963944123456'), findsOneWidget);
    expect(find.textContaining('لتغيير رقمك تواصل مع الدعم'), findsOneWidget);
    expect(find.byKey(const Key('profile-terms')), findsNothing);

    app.server.on('/v1/customer/profile', [
      const FakeAnswer(200, {
        'completed': true,
        'phone': '+963944123456',
        'profile': {
          'firstName': 'سلمى',
          'lastName': null,
          'gender': 'female',
          'birthday': null,
        },
      }),
    ]);
    await tester.enterText(find.byKey(const Key('profile-first-name')), 'سلمى');
    await tester.tap(find.text('حفظ'));
    await tester.pumpAndSettle();
    final saved = app.server
        .to('/v1/customer/profile')
        .where((request) => request.method == 'PUT')
        .single;
    expect((saved.data as Map)['firstName'], 'سلمى');
    expect((saved.data as Map)['acceptTerms'], false);
    expect(find.text('حسابي'), findsOneWidget);
  });

  testWidgets('joins as a captain or adds a restaurant through WhatsApp', (
    tester,
  ) async {
    final app = await _account(tester);
    await tester.tap(find.byKey(const Key('join-as-captain')));
    await tester.pumpAndSettle();
    expect(app.launched.last, captainStorePage);
    await tester.tap(find.byKey(const Key('add-restaurant')));
    await tester.pumpAndSettle();
    expect(app.launched.last.host, 'wa.me');
    expect(app.launched.last.path, '/963944000001');
    expect(
      app.launched.last.queryParameters['text'],
      'أريد إضافة مطعمي إلى FOX DROP',
    );
    expect(find.text('الإصدار 0.1.0'), findsOneWidget);
  });

  testWidgets('signs every device out after a confirmation', (tester) async {
    final app = await _account(tester);
    app.server.on('/v1/customer/auth/sign-out-everywhere', [
      const FakeAnswer(200, {'status': 'signed_out'}),
    ]);
    await tester.tap(find.byKey(const Key('sign-out-everywhere')));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'سيُسجَّل خروجك من كل الأجهزة، ومنها هذا الجهاز. لا تتأثر طلباتك الجارية.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('confirm-sign-out-everywhere')));
    await tester.pumpAndSettle();
    expect(
      app.server.to('/v1/customer/auth/sign-out-everywhere'),
      hasLength(1),
    );
    expect(find.text('تسجيل الدخول'), findsWidgets);
  });
}
