import 'package:captain/src/api.dart';
import 'package:captain/src/auth.dart';
import 'package:captain/src/joining/welcome_screen.dart';
import 'package:captain/src/router.dart';
import 'package:core_auth/core_auth.dart';
import 'package:core_auth/testing.dart';
import 'package:core_storage/core_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

void main() {
  // The sign-in and join screens left in D.R1 (2026-11-27): signed out, the
  // captain sees the entry screen, right to left.
  testWidgets('signs out to the entry screen, right to left', (tester) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    await app.pump(tester);
    await app.live(tester);
    expect(find.text('غير متصل'), findsOneWidget);

    await tester.tap(find.text('تسجيل الخروج'));
    await app.settle(tester);
    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.byType(WelcomeScreen))),
      TextDirection.rtl,
    );
    expect(app.server.to('/v1/captain/auth/sign-out'), hasLength(1));
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

    expect(find.byType(WelcomeScreen), findsOneWidget);
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
