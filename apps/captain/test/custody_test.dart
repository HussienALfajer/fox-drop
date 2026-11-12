import 'package:core_auth/testing.dart';
import 'package:captain/src/custody.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

// CA §10.2 «عهدتي», §10.4 the limit bar, §7.5 the office in the hand-in
// reminder (slice 2.17c).
const receiptId = '01900000-0000-7000-8000-0000000000d1';

Map<String, Object?> custodyJson({bool handedIn = false}) => {
  'usage': moneyJson(handedIn ? '0' : '1000'),
  'limit': moneyJson('500000'),
  'warn': false,
  'total': moneyJson(handedIn ? '0' : '41000'),
  'closedDue': moneyJson('0'),
  'lastCutoff': now.toIso8601String(),
  'handInGraceUntil': null,
  'currencies': [
    {
      'currency': 'TRY',
      'balance': handedIn ? '0' : '1000',
      'closedDue': '0',
      'today': handedIn ? '0' : '1000',
      'balanceInBase': handedIn ? '0' : '1000',
    },
    {
      'currency': 'USD',
      'balance': '1000',
      'closedDue': '1000',
      'today': '0',
      'balanceInBase': '40000',
    },
  ],
  'entries': [
    if (handedIn)
      {
        'kind': 'hand_in',
        'orderNumber': null,
        'receiptNumber': 'AZ-2026-000001',
        'amount': moneyJson('-1000'),
        'at': now.toIso8601String(),
      },
    {
      'kind': 'collect',
      'orderNumber': '10001',
      'receiptNumber': null,
      'amount': moneyJson('41000'),
      'at': now.toIso8601String(),
    },
    {
      'kind': 'pay_merchant',
      'orderNumber': '10001',
      'receiptNumber': null,
      'amount': moneyJson('-40000'),
      'at': now.toIso8601String(),
    },
  ],
  'receipts': [
    if (handedIn)
      {
        'id': receiptId,
        'number': 'AZ-2026-000001',
        'type': 'captain_hand_in',
        'at': now.toIso8601String(),
        'cashierName': 'سارة',
        'conversions': <Object?>[],
        'lines': [
          {'currency': 'TRY', 'amount': '1000'},
        ],
      },
  ],
};

void main() {
  test('the limit bar fills by the usage, never past the limit', () {
    expect(limitShare('0', '500000'), 0);
    expect(limitShare('-100', '500000'), 0);
    expect(limitShare('250000', '500000'), 0.5);
    expect(limitShare('900000', '500000'), 1);
  });

  testWidgets('«عهدتي» shows the custody, the office, and a receipt the '
      'moment the desk records it', (tester) async {
    final app = TestApp();
    app.work(
      availability: [availabilityJson(usage: '1000', office: officeJson())],
    );
    app.server.on('/v1/captain/custody', [FakeAnswer(200, custodyJson())]);
    await app.pump(tester);
    await app.live(tester);
    // CA §10.4: the limit's bar on home.
    expect(find.text('حد العهدة: 10 ₺ من 5000 ₺'), findsOneWidget);

    await tester.tap(find.text('عهدتي'));
    await app.settle(tester);
    expect(find.byKey(const Key('custody-sentence')), findsOneWidget);
    expect(find.text('عليك تسليم 410 ₺'), findsOneWidget);
    expect(find.text('10 \$ (بالعملة الأساسية 400 ₺)'), findsOneWidget);
    expect(find.text('من أيام سابقة: 10 \$'), findsOneWidget);
    expect(find.text('المكتب مفتوح حتى 11:00 م'), findsOneWidget);
    expect(find.text('السبت: من 9:00 ص إلى 11:00 م'), findsOneWidget);
    expect(find.text('الجمعة: مغلق'), findsOneWidget);
    expect(find.text('لا إيصالات بعد.'), findsOneWidget);
    final collected = find.text('تحصيل من الزبون — الطلب 10001: 410 ₺');
    await tester.scrollUntilVisible(collected, 200);
    expect(collected, findsOneWidget);

    await app.tapVisible(tester, find.byKey(const Key('office-map')));
    await app.settle(tester);
    expect(app.launched.last.queryParameters['destination'], '36.5862,37.0471');

    // AP §9.10.3: the desk's receipt reads the state and the custody again.
    app.server.on('/v1/captain/custody', [
      FakeAnswer(200, custodyJson(handedIn: true)),
    ]);
    app.work(availability: [availabilityJson(office: officeJson())]);
    app.transport.signal('captain.availability_changed');
    await app.settle(tester);
    expect(find.byKey(const Key('receipt-AZ-2026-000001')), findsOneWidget);
    expect(find.text('أمين الصندوق: سارة'), findsOneWidget);
    final handedIn = find.text('تسليم نقد — AZ-2026-000001: -10 ₺');
    await tester.scrollUntilVisible(handedIn, 200);
    expect(handedIn, findsOneWidget);
    await app.done(tester);
  });

  testWidgets('the hand-in reminder names the office closing time, or when '
      'it opens, with the map (CA §7.5)', (tester) async {
    final app = TestApp();
    app.work(
      availability: [
        availabilityJson(state: 'online_available', office: officeJson()),
      ],
    );
    await app.pump(tester);
    await app.live(tester);
    app.server.on('/v1/captain/availability/offline', [
      FakeAnswer(200, {
        'handIn': moneyJson('41000'),
        'office': officeJson(open: false),
      }),
    ]);
    app.work(
      availability: [
        availabilityJson(usage: '41000', office: officeJson(open: false)),
      ],
    );
    await tester.tap(find.byKey(const Key('online-switch')));
    await app.settle(tester);
    expect(
      find.text('عليك تسليم 410 ₺. المكتب مغلق الآن، يفتح الأحد 9:00 ص.'),
      findsOneWidget,
    );
    expect(find.byKey(const Key('office-map')), findsOneWidget);
    await tester.tap(find.text('حسناً'));
    await app.settle(tester);
    await app.done(tester);
  });
}
