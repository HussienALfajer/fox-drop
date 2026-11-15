import 'package:core_auth/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

// CA §10.6 «أرباحي», §10.7 the negative balance, §6.2 the bottom
// navigation (slice 2.18b).
Map<String, Object?> earningsJson({bool paid = false, String? balance}) => {
  'currency': 'TRY',
  'today': {
    'from': now.toIso8601String(),
    'earnings': '4300',
    'orders': 1,
    'onlineMinutes': 95,
  },
  'week': {
    'from': now.toIso8601String(),
    'earnings': '4300',
    'orders': 1,
    'onlineMinutes': 125,
  },
  'orders': [
    {
      'orderNumber': '10001',
      'at': now.toIso8601String(),
      'parts': {
        'base': '2500',
        'distance': '1000',
        'topUp': '0',
        'waiting': '0',
        'peak': '500',
      },
      'total': '4000',
    },
  ],
  'lines': [
    if (paid)
      {
        'kind': 'payout',
        'amount': '-4300',
        'reason': null,
        'orderNumber': null,
        'receiptNumber': 'AZ-2026-000002',
        'at': now.toIso8601String(),
      },
    {
      'kind': 'bonus',
      'amount': '1000',
      'reason': 'مساعدة في الذروة',
      'orderNumber': null,
      'receiptNumber': null,
      'at': now.toIso8601String(),
    },
    {
      'kind': 'charge',
      'amount': '-700',
      'reason': 'تالف',
      'orderNumber': '10001',
      'receiptNumber': null,
      'at': now.toIso8601String(),
    },
  ],
  'balance': balance ?? (paid ? '0' : '4300'),
  'payoutWeekday': 'thursday',
  'nextPayout': '2026-11-12',
  'negativePolicy': 'carry_forward',
};

void main() {
  testWidgets('«أرباحي» shows today, the week, each order by part and the '
      'other lines, and the payout once the desk settles', (tester) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    app.server.on('/v1/captain/earnings', [FakeAnswer(200, earningsJson())]);
    await app.pump(tester);
    await app.live(tester);

    await tester.tap(find.text('أرباحي'));
    await app.settle(tester);
    expect(find.text('رصيدك المستحق: 43 ₺'), findsOneWidget);
    expect(find.text('موعد القبض: الخميس 12/11/2026'), findsOneWidget);
    expect(find.byKey(const Key('earnings-negative')), findsNothing);
    expect(find.text('ساعات الاتصال: 1 س 35 د'), findsOneWidget);
    expect(find.text('ساعات الاتصال: 2 س 5 د'), findsOneWidget);
    final order = find.text('الطلب #10001: 40 ₺');
    await tester.scrollUntilVisible(order, 200);
    expect(
      find.textContaining('الأجر الأساسي: 25 ₺\nأجر المسافة: 10 ₺'),
      findsOneWidget,
    );
    expect(find.textContaining('مكافأة الذروة: 5 ₺'), findsOneWidget);
    final charge = find.text('خصم: -7 ₺');
    await tester.scrollUntilVisible(charge, 200);
    expect(find.textContaining('تالف\nالطلب #10001'), findsOneWidget);
    expect(find.text('مكافأة: 10 ₺'), findsOneWidget);

    // AP §9.10.3: the desk's receipt reads the state and the earnings again.
    app.server.on('/v1/captain/earnings', [
      FakeAnswer(200, earningsJson(paid: true)),
    ]);
    app.work(
      availability: [availabilityJson(usage: '0', closedDue: '1')],
    );
    app.transport.signal('captain.availability_changed');
    await app.settle(tester);
    await tester.scrollUntilVisible(find.text('صرف المستحقات: -43 ₺'), -200);
    expect(find.textContaining('إيصال AZ-2026-000002'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('رصيدك المستحق: 0 ₺'), -200);
    await app.done(tester);
  });

  testWidgets('a negative balance is explained by the policy (CA §10.7)', (
    tester,
  ) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    app.server.on('/v1/captain/earnings', [
      FakeAnswer(200, earningsJson(balance: '-1200')),
    ]);
    await app.pump(tester);
    await app.live(tester);
    await tester.tap(find.text('أرباحي'));
    await app.settle(tester);
    expect(find.text('رصيدك المستحق: -12 ₺'), findsOneWidget);
    expect(
      find.text('رصيدك سالب، ويُخصم من أرباحك في الأسبوع القادم.'),
      findsOneWidget,
    );
    await app.done(tester);
  });

  testWidgets('«المزيد» holds the other screens, and home stays a tab '
      '(CA §6.2)', (tester) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    await app.pump(tester);
    await app.live(tester);
    await tester.tap(find.text('المزيد'));
    await app.settle(tester);
    expect(find.text('الإعدادات'), findsOneWidget);
    expect(find.text('قواعد العمل'), findsOneWidget);
    await tester.tap(find.text('الرئيسية'));
    await app.settle(tester);
    expect(find.byKey(const Key('online-switch')), findsOneWidget);
    await app.done(tester);
  });
}
