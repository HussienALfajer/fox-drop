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
    // A guest's start reads only the version and maintenance (CU §4.2).
    expect(app.server.requests.map((request) => request.uri.path), [
      '/v1/customer/platform',
    ]);
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
