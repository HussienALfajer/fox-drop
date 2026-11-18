import 'package:core_auth/testing.dart';
import 'package:customer/src/orders/my_orders.dart';
import 'package:customer/src/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';
import 'support.dart';

String _id(int n) => '00000000-0000-4000-8000-${n.toString().padLeft(12, '0')}';

Map<String, Object?> _summary(
  int n, {
  String status = 'delivered',
  bool active = false,
  bool redelivery = false,
}) => {
  'id': _id(n),
  'number': '${10400 + n}',
  'restaurant': {'id': shamId, 'nameAr': 'مطعم الشام', 'nameEn': null},
  'placedAt': '2026-11-07T12:00:00.000Z',
  'status': status,
  'active': active,
  'total': try_(14000),
  'redelivery': redelivery,
};

// CU §12.3 (slice 2.28b): «طلباتي», active first, then past, in pages.
void main() {
  test('«اطلب مرة أخرى» follows a delivered, rejected or cancelled order', () {
    for (final status in ['delivered', 'rejected', 'cancelled']) {
      expect(canOrderAgain(status, redelivery: false), isTrue);
      expect(canOrderAgain(status, redelivery: true), isFalse);
    }
    for (final status in ['placed', 'accepted', 'arrived', 'failed']) {
      expect(canOrderAgain(status, redelivery: false), isFalse);
    }
  });

  Future<TestApp> open(WidgetTester tester, List<FakeAnswer> pages) async {
    final app = TestApp(signedIn: true);
    app.completedProfile();
    app.server.on('/v1/customer/orders', pages);
    app.server.on('/v1/customer/orders/active', [
      const FakeAnswer(200, {'orders': <Object>[]}),
    ]);
    await app.pump(tester);
    await tester.tap(find.byKey(const Key('open-my-orders')));
    await tester.pumpAndSettle();
    return app;
  }

  testWidgets('lists the active orders first, then the past ones, by page', (
    tester,
  ) async {
    final app = await open(tester, [
      FakeAnswer(200, {
        'orders': [
          _summary(1, status: 'accepted', active: true),
          _summary(2),
          _summary(3, status: 'cancelled'),
        ],
        'next': 'cursor-1',
      }),
      FakeAnswer(200, {
        'orders': [_summary(4, status: 'rejected')],
        'next': null,
      }),
    ]);
    expect(find.text('الطلبات الجارية'), findsOneWidget);
    expect(find.text('الطلبات السابقة'), findsOneWidget);
    final tiles = tester
        .widgetList<ListTile>(find.byType(ListTile))
        .map((tile) => tile.key)
        .whereType<ValueKey<String>>()
        .map((key) => key.value)
        .toList();
    expect(tiles, [
      'my-order-${_id(1)}',
      'my-order-${_id(2)}',
      'my-order-${_id(3)}',
    ]);
    expect(
      find.textContaining('#10401 · 07/11/2026 · المطعم يحضّر طلبك'),
      findsOneWidget,
    );
    expect(find.textContaining('أُلغي الطلب'), findsOneWidget);
    expect(find.text('140 ₺'), findsNWidgets(3));

    await tester.tap(find.byKey(const Key('orders-more')));
    await tester.pumpAndSettle();
    expect(
      app.server.to('/v1/customer/orders').last.uri.queryParameters['cursor'],
      'cursor-1',
    );
    expect(find.byKey(Key('my-order-${_id(4)}')), findsOneWidget);
    expect(find.textContaining('لم يقبل المطعم الطلب'), findsOneWidget);
    expect(find.byKey(const Key('orders-more')), findsNothing);

    app.server.on('/v1/customer/orders/${_id(2)}', [const FakeAnswer(500)]);
    await tester.tap(find.byKey(Key('my-order-${_id(2)}')));
    await tester.pumpAndSettle();
    expect(
      app.container.read(routerProvider).state.uri.path,
      '/orders/${_id(2)}',
    );
    await app.done(tester);
  });

  testWidgets('says so when there is no order yet', (tester) async {
    final app = await open(tester, [
      const FakeAnswer(200, {'orders': <Object>[], 'next': null}),
    ]);
    expect(find.text('لا توجد طلبات بعد'), findsOneWidget);
    await app.done(tester);
  });
}
