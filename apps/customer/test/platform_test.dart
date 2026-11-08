import 'dart:async';

import 'package:customer/src/platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support.dart';

// CU §4.2: the version check at launch and when the app resumes.
void main() {
  testWidgets('sends the app version and blocks below the minimum', (
    tester,
  ) async {
    final app = TestApp();
    app.platform(updateNeed: 'required', updateMessage: 'حدّث من المتجر');
    await app.pump(tester);
    expect(find.text('يلزم تحديث التطبيق'), findsOneWidget);
    expect(find.text('حدّث من المتجر'), findsOneWidget);
    final request = app.server.to('/v1/customer/platform').single;
    expect(request.uri.queryParameters['version'], '0.1.0');
  });

  testWidgets('lifts the block when a later check answers no update', (
    tester,
  ) async {
    final app = TestApp();
    app.platform(updateNeed: 'required');
    await app.pump(tester);
    expect(find.text('يلزم تحديث التطبيق'), findsOneWidget);
    app.platform();
    unawaited(app.container.read(platformCheckProvider).check());
    await tester.pumpAndSettle();
    expect(find.text('يلزم تحديث التطبيق'), findsNothing);
  });

  testWidgets('offers a newer version in a banner the customer dismisses', (
    tester,
  ) async {
    final app = TestApp();
    app.platform(updateNeed: 'suggested');
    await app.pump(tester);
    expect(find.text('يتوفر إصدار أحدث من التطبيق.'), findsOneWidget);
    await tester.tap(find.text('لاحقاً'));
    await tester.pumpAndSettle();
    expect(find.text('يتوفر إصدار أحدث من التطبيق.'), findsNothing);
    expect(find.byType(MaterialBanner), findsNothing);
  });
}
