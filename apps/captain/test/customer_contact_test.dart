import 'dart:convert';

import 'package:core_auth/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

Map<String, Object?> bodyOf(TestApp app, String path) {
  final data = app.server.to(path).last.data;
  return (data is String ? jsonDecode(data) : data) as Map<String, Object?>;
}

const _contact = '/v1/captain/orders/$orderId/customer-contact';

Future<TestApp> _toCustomer(WidgetTester tester) async {
  final app = TestApp();
  app.work(
    availability: [availabilityJson(state: 'busy')],
    orders: [
      orderJson(
        status: 'picked_up',
        track: 'picked_up',
        version: 6,
        request: requestJson(status: 'confirmed', outcome: 'restaurant'),
      ),
    ],
  );
  await app.pump(tester);
  await app.live(tester);
  return app;
}

void main() {
  testWidgets('call and WhatsApp reveal the number with their channel and '
      'open it (CA §9.5, §15)', (tester) async {
    final app = await _toCustomer(tester);
    // The number is never on the order, so never on screen.
    expect(find.textContaining('944222222'), findsNothing);
    app.server.on(_contact, [
      const FakeAnswer(200, {'phone': '+963944222222'}),
      const FakeAnswer(200, {'phone': '+963944222222'}),
    ]);

    await app.tapVisible(tester, find.text('اتصال بالزبون'));
    await app.settle(tester);
    expect(bodyOf(app, _contact), {'channel': 'call'});
    expect(app.launched.last.toString(), 'tel:+963944222222');

    await app.tapVisible(tester, find.text('واتساب الزبون'));
    await app.settle(tester);
    expect(bodyOf(app, _contact), {'channel': 'whatsapp'});
    expect(app.launched.last.toString(), 'https://wa.me/963944222222');
    expect(app.launched, hasLength(2));
    await app.done(tester);
  });

  testWidgets('a refusal opens nothing and says the order changed', (
    tester,
  ) async {
    final app = await _toCustomer(tester);
    app.server.on(_contact, [
      const FakeAnswer(409, {'error': 'order_state_changed'}),
    ]);

    await app.tapVisible(tester, find.text('اتصال بالزبون'));
    await app.settle(tester);
    expect(app.launched, isEmpty);
    expect(find.byType(SnackBar), findsOneWidget);
    await app.done(tester);
  });

  Future<TestApp> atRestaurant(WidgetTester tester, DateTime? from) async {
    final app = TestApp();
    app.work(
      availability: [availabilityJson(state: 'busy')],
      orders: [orderJson(track: 'at_merchant', waitingPayFrom: from)],
    );
    await app.pump(tester);
    await app.live(tester);
    return app;
  }

  final line = find.byKey(const Key('waiting-pay-started'));

  testWidgets('the waiting-pay line shows once waitingPayFrom passes, while '
      'the screen is open (CA §9.3)', (tester) async {
    final app = await atRestaurant(tester, now.add(const Duration(minutes: 2)));
    expect(line, findsNothing);
    await app.advance(tester, const Duration(minutes: 3));
    expect(line, findsOneWidget);
    expect(find.text('بدأ احتساب أجر الانتظار'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('the waiting-pay line shows when it already started', (
    tester,
  ) async {
    final app = await atRestaurant(
      tester,
      now.subtract(const Duration(minutes: 1)),
    );
    expect(line, findsOneWidget);
    await app.done(tester);
  });

  testWidgets('no waiting-pay line without waitingPayFrom', (tester) async {
    final app = await atRestaurant(tester, null);
    await app.advance(tester, const Duration(minutes: 30));
    expect(line, findsNothing);
    await app.done(tester);
  });
}
