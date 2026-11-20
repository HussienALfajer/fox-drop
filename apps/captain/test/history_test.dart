import 'package:core_auth/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

// CA §9.13 «السجل» (slice 2.40): the past orders by business day with the
// pay and the custody effect, never the customer (K8), and the captain's own
// steps.
const _orderId = '00000000-0000-4000-8000-0000000000b1';

Map<String, Object?> _row({
  String id = _orderId,
  String day = '2026-11-18',
  String? pay = '7500',
  bool handedOver = false,
}) => {
  'id': id,
  'number': '10023',
  'placedAt': '2026-11-18T10:00:00.000Z',
  'day': day,
  'restaurantName': 'مطعم الياسمين',
  'neighbourhood': 'الحي الشرقي',
  'status': 'delivered',
  'outcome': 'normal',
  'testOrder': false,
  'redelivery': false,
  'handedOver': handedOver,
  'pay': pay,
  'paidToRestaurant': [
    {'currency': 'TRY', 'amount': '24000'},
  ],
  'collected': [
    {'currency': 'USD', 'amount': '500'},
    {'currency': 'TRY', 'amount': '10000'},
  ],
  'change': [
    {'currency': 'TRY', 'amount': '2000'},
  ],
  'steps': [
    {'step': 'assigned', 'at': '2026-11-18T10:05:00.000Z'},
    {'step': 'picked_up', 'at': '2026-11-18T10:25:00.000Z'},
    {'step': 'delivered', 'at': '2026-11-18T10:45:00.000Z'},
  ],
};

Map<String, Object?> _page(List<Map<String, Object?>> orders, {String? next}) =>
    {'payCurrency': 'TRY', 'orders': orders, 'next': next};

Future<void> _open(WidgetTester tester, TestApp app) async {
  await app.pump(tester);
  await app.live(tester);
  await tester.tap(find.text('المزيد'));
  await app.settle(tester);
  await tester.tap(find.byKey(const Key('more-history')));
  await app.settle(tester);
}

void main() {
  testWidgets('lists the orders by day and opens the steps and amounts', (
    tester,
  ) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    app.server.on('/v1/captain/orders/history', [
      FakeAnswer(
        200,
        _page([
          _row(),
          _row(
            id: '00000000-0000-4000-8000-0000000000b2',
            day: '2026-11-17',
            pay: null,
            handedOver: true,
          ),
        ]),
      ),
    ]);
    await _open(tester, app);
    expect(find.text('18/11/2026'), findsOneWidget);
    expect(find.text('17/11/2026'), findsOneWidget);
    expect(
      find.text('مطعم الياسمين · الحي الشرقي\nأجرك: 75 ₺'),
      findsOneWidget,
    );
    expect(find.text('مطعم الياسمين · الحي الشرقي\nبلا أجر'), findsOneWidget);
    expect(find.textContaining('سلّمته لكابتن آخر'), findsOneWidget);

    await tester.tap(find.byKey(const Key('history-order-$_orderId')));
    await app.settle(tester);
    expect(find.byKey(const Key('history-detail')), findsOneWidget);
    expect(find.text('دفعت للمطعم: 240 ₺'), findsOneWidget);
    expect(find.text('قبضت من الزبون: 5 \$ + 100 ₺'), findsOneWidget);
    expect(find.text('أعدت الباقي: 20 ₺'), findsOneWidget);
    expect(find.text('أُسند إليك'), findsOneWidget);
    expect(find.text('استلمت الطلب'), findsOneWidget);
    expect(find.text('سلّمت الطلب'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('reads the next page and says when nothing was found', (
    tester,
  ) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    app.server.on('/v1/captain/orders/history', [
      FakeAnswer(200, _page([_row()], next: 'cursor-1')),
      FakeAnswer(200, _page([])),
    ]);
    await _open(tester, app);
    await tester.tap(find.byKey(const Key('history-more')));
    await app.settle(tester);
    final sent = app.server
        .to('/v1/captain/orders/history')
        .map((request) => request.queryParameters)
        .toList();
    expect(sent.last, {'cursor': 'cursor-1'});
    expect(find.byKey(const Key('history-more')), findsNothing);
    await app.done(tester);
  });

  testWidgets('an empty history says so', (tester) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    app.server.on('/v1/captain/orders/history', [FakeAnswer(200, _page([]))]);
    await _open(tester, app);
    expect(find.text('لا طلبات في هذه الفترة.'), findsOneWidget);
    await app.done(tester);
  });
}
