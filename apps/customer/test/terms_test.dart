import 'package:core_auth/testing.dart';
import 'package:customer/src/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support.dart';

// The screen on top, a pushed one included.
String _location(TestApp app) => app.container
    .read(routerProvider)
    .routerDelegate
    .currentConfiguration
    .last
    .matchedLocation;

// CU §4.7: a new version of the terms is shown on the next open; the customer
// may keep browsing, and accepts it with «أوافق» (CU §15).
void main() {
  testWidgets('opens a pending version, which the customer may close', (
    tester,
  ) async {
    final app = TestApp(signedIn: true);
    app.terms(version: 2, body: 'الشروط الجديدة', pending: true);
    await app.pump(tester);

    expect(_location(app), startsWith('/terms'));
    expect(find.text('الشروط الجديدة'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    // Browsing continues, with the banner of CU §6.2 item 5.
    expect(_location(app), '/');
    expect(find.byKey(const Key('terms-pending')), findsOneWidget);
    // Once per version: home stays home.
    expect(find.byKey(const Key('terms-accept')), findsNothing);
  });

  testWidgets('accepts the version shown, and the banner goes', (tester) async {
    final app = TestApp(signedIn: true);
    app.terms(version: 2, pending: true);
    app.server.on('/v1/customer/terms/accept', [
      const FakeAnswer(200, {'status': 'accepted'}),
    ]);
    await app.pump(tester);
    app.terms(version: 2);

    await tester.tap(find.byKey(const Key('terms-accept')));
    await tester.pumpAndSettle();

    expect(app.bodyOf('/v1/customer/terms/accept'), {'version': 2});
    expect(_location(app), '/');
    expect(find.byKey(const Key('terms-pending')), findsNothing);
  });

  testWidgets('shows a newer version published while reading', (tester) async {
    final app = TestApp(signedIn: true);
    app.terms(version: 2, body: 'النسخة 2', pending: true);
    app.server.on('/v1/customer/terms/accept', [
      const FakeAnswer(409, {'error': 'terms_outdated'}),
    ]);
    await app.pump(tester);
    app.terms(version: 3, body: 'النسخة 3', pending: true);

    await tester.tap(find.byKey(const Key('terms-accept')));
    await tester.pumpAndSettle();

    expect(find.text('النسخة 3'), findsOneWidget);
    expect(find.byKey(const Key('terms-message')), findsOneWidget);
    expect(_location(app), startsWith('/terms'));
  });

  testWidgets('a guest reads the terms without accepting them', (tester) async {
    final app = TestApp();
    await app.pump(tester);
    expect(_location(app), '/');
    await tester.tap(find.byKey(const Key('open-terms')));
    await tester.pumpAndSettle();
    expect(find.text('شروط FOX DROP'), findsOneWidget);
    expect(find.byKey(const Key('terms-accept')), findsNothing);
  });
}
