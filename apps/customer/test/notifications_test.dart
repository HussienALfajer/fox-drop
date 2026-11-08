import 'package:core_auth/testing.dart';
import 'package:customer/src/orders/order_screen.dart';
import 'package:customer/src/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support.dart';

const _orderId = '00000000-0000-4000-8000-0000000000e1';

String _location(TestApp app) => app.container
    .read(routerProvider)
    .routerDelegate
    .currentConfiguration
    .uri
    .toString();

Future<TestApp> _notifications(
  WidgetTester tester,
  List<Map<String, Object?>> list,
) async {
  final app = TestApp(signedIn: true);
  app.server.on('/v1/customer/notifications', [
    FakeAnswer(200, {'notifications': list}),
  ]);
  await app.pump(tester);
  await tester.tap(find.byKey(const Key('open-notifications')));
  await tester.pumpAndSettle();
  return app;
}

// CU §13 «الإشعارات»: the pushes of the last 30 days, newest first, as the
// server answers them; a tap opens its target (CU §14).
void main() {
  testWidgets('lists the pushes as the server orders them', (tester) async {
    await _notifications(tester, [
      {
        'id': 'n-2',
        'at': '2026-11-08T09:05:00.000Z',
        'body': 'طلبك في الطريق إليك مع سامر',
        'data': {'target': 'order', 'orderId': _orderId},
      },
      {
        'id': 'n-1',
        'at': '2026-11-08T08:40:00.000Z',
        'body': 'المطعم يحضّر طلبك. يصل حوالي 12:20 م',
        'data': {'target': 'order', 'orderId': _orderId},
      },
    ]);

    expect(find.text('الإشعارات'), findsWidgets);
    final tiles = tester.widgetList<ListTile>(find.byType(ListTile)).toList();
    expect((tiles[0].title! as Text).data, 'طلبك في الطريق إليك مع سامر');
    expect(
      (tiles[1].title! as Text).data,
      'المطعم يحضّر طلبك. يصل حوالي 12:20 م',
    );
    // On the city's clock (UTC+3).
    expect((tiles[0].subtitle! as Text).data, '08/11/2026 12:05 م');
  });

  testWidgets('a tap opens its order', (tester) async {
    final app = await _notifications(tester, [
      {
        'id': 'n-1',
        'at': '2026-11-08T08:40:00.000Z',
        'body': 'المطعم يحضّر طلبك. يصل حوالي 12:20 م',
        'data': {'target': 'order', 'orderId': _orderId},
      },
    ]);
    await tester.tap(find.byKey(const Key('notification-n-1')));
    await tester.pumpAndSettle();
    final screen = tester.widget<OrderScreen>(find.byType(OrderScreen));
    expect(screen.orderId, _orderId);
    await app.done(tester);
  });

  testWidgets('none in 30 days', (tester) async {
    await _notifications(tester, []);
    expect(find.text('لا توجد إشعارات'), findsOneWidget);
  });

  testWidgets('a failed read is read again', (tester) async {
    final app = TestApp(signedIn: true);
    app.server.on('/v1/customer/notifications', [
      const FakeAnswer(503, {'error': 'unavailable'}),
      const FakeAnswer(200, {'notifications': <Object>[]}),
    ]);
    await app.pump(tester);
    await tester.tap(find.byKey(const Key('open-notifications')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('حاول مجدداً'));
    await tester.pumpAndSettle();
    expect(find.text('لا توجد إشعارات'), findsOneWidget);
  });

  testWidgets('a guest signs in first', (tester) async {
    final app = TestApp();
    await app.pump(tester);
    app.container.read(routerProvider).go('/notifications');
    await tester.pumpAndSettle();
    expect(_location(app), '/sign-in?from=%2Fnotifications');
  });
}
