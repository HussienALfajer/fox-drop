import 'package:captain/src/router.dart';
import 'package:core_auth/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'earnings_test.dart' show earningsJson;
import 'fixtures.dart';

// CA §10.7 the weekly statement, §14 #20 its push (slice 2.18c).
const statementId = '0190e0d8-0000-7000-8000-000000000001';
const firstId = '0190e0d8-0000-7000-8000-000000000002';

Map<String, Object?> statementJson() => {
  'id': statementId,
  'captainName': 'كابتن التصفية',
  'periodFrom': '2026-11-05T09:00:00.000Z',
  'createdAt': '2026-11-12T09:00:00.000Z',
  'currency': 'TRY',
  'orders': 3,
  'basePay': '7500',
  'distancePay': '3000',
  'waitingPay': '500',
  'peakBonus': '1000',
  'bonuses': '1000',
  'charges': '700',
  'instalments': '0',
  'adjustments': '0',
  'carriedIn': '-1200',
  'balance': '11100',
  'paid': '11100',
  'payout': {'currency': 'TRY', 'amount': '11100'},
  'collected': '0',
  'carriedOut': '0',
};

Map<String, Object?> listJson() => {
  'statements': [
    {
      'id': statementId,
      'createdAt': '2026-11-12T09:00:00.000Z',
      'periodFrom': '2026-11-05T09:00:00.000Z',
      'currency': 'TRY',
      'orders': 3,
      'paid': '11100',
      'payout': {'currency': 'TRY', 'amount': '11100'},
      'collected': '0',
      'carriedOut': '0',
    },
    {
      'id': firstId,
      'createdAt': '2026-11-05T09:00:00.000Z',
      'periodFrom': null,
      'currency': 'TRY',
      'orders': 0,
      'paid': '0',
      'payout': null,
      'collected': '0',
      'carriedOut': '-1200',
    },
    {
      'id': '0190e0d8-0000-7000-8000-000000000003',
      'createdAt': '2026-10-29T09:00:00.000Z',
      'periodFrom': null,
      'currency': 'TRY',
      'orders': 0,
      'paid': '0',
      'payout': null,
      'collected': '500',
      'carriedOut': '0',
    },
  ],
};

String _location(TestApp app) => app.container
    .read(routerProvider)
    .routerDelegate
    .currentConfiguration
    .uri
    .toString();

void main() {
  testWidgets('«أرباحي» lists the statements and opens one with its lines', (
    tester,
  ) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    app.server.on('/v1/captain/earnings', [FakeAnswer(200, earningsJson())]);
    app.server.on('/v1/captain/statements', [FakeAnswer(200, listJson())]);
    app.server.on('/v1/captain/statements/$statementId', [
      FakeAnswer(200, statementJson()),
    ]);
    await app.pump(tester);
    await app.live(tester);
    await tester.tap(find.text('أرباحي'));
    await app.settle(tester);

    await tester.tap(find.byKey(const Key('earnings-statements')));
    await app.settle(tester);
    expect(find.text('كشوف الأسبوع'), findsOneWidget);
    expect(find.text('12/11/2026: قبضت 111 ₺'), findsOneWidget);
    expect(
      find.text('05/11/2026: لم تقبض شيئاً، يُرحَّل -12 ₺'),
      findsOneWidget,
    );
    expect(find.text('29/10/2026: سدّدت 5 ₺ من رصيد سالب'), findsOneWidget);
    expect(find.text('عدد الطلبات: 3'), findsOneWidget);

    await tester.tap(find.text('12/11/2026: قبضت 111 ₺'));
    await app.settle(tester);
    expect(find.text('الكابتن: كابتن التصفية'), findsOneWidget);
    expect(
      find.text('من 05/11/2026 12:00 م إلى 12/11/2026 12:00 م'),
      findsOneWidget,
    );
    for (final line in [
      'رصيد مُرحَّل: -12 ₺',
      'الأجر الأساسي: 75 ₺',
      'أجر المسافة: 30 ₺',
      'أجر الانتظار: 5 ₺',
      'مكافأة الذروة: 10 ₺',
      'المكافآت: 10 ₺',
      'الخصومات: 7 ₺',
      'أقساط التأمين: 0 ₺',
      'الرصيد قبل الصرف: 111 ₺',
      'المبلغ المصروف: 111 ₺',
      'يُرحَّل إلى الأسبوع التالي: 0 ₺',
    ]) {
      expect(find.text(line), findsOneWidget, reason: line);
    }

    // Back returns to the list, then to «أرباحي».
    app.container.read(routerProvider).pop();
    await app.settle(tester);
    expect(find.text('كشوف الأسبوع'), findsOneWidget);
    app.container.read(routerProvider).pop();
    await app.settle(tester);
    expect(find.byKey(const Key('earnings')), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('a payout in another currency shows its base value, and an '
      'unknown statement says so', (tester) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    app.server.on('/v1/captain/earnings', [FakeAnswer(200, earningsJson())]);
    app.server.on('/v1/captain/statements/$statementId', [
      FakeAnswer(200, {
        ...statementJson(),
        'payout': {'currency': 'USD', 'amount': '277'},
      }),
    ]);
    app.server.on('/v1/captain/statements/$firstId', [
      FakeAnswer(404, {'statusCode': 404, 'error': 'unknown_statement'}),
    ]);
    await app.pump(tester);
    await app.live(tester);
    app.container.read(routerProvider).go('/earnings/statements/$statementId');
    await app.settle(tester);
    expect(
      find.text('المبلغ المصروف: 2.77 \$ (بالعملة الأساسية 111 ₺)'),
      findsOneWidget,
    );
    app.container.read(routerProvider).go('/earnings/statements/$firstId');
    await app.settle(tester);
    expect(find.text('لم يُعثر على هذا الكشف.'), findsOneWidget);
    expect(find.text('إعادة المحاولة'), findsNothing);
    await app.done(tester);
  });

  testWidgets('no statement yet', (tester) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    app.server.on('/v1/captain/earnings', [FakeAnswer(200, earningsJson())]);
    app.server.on('/v1/captain/statements', [
      FakeAnswer(200, {'statements': <Object>[]}),
    ]);
    await app.pump(tester);
    await app.live(tester);
    app.container.read(routerProvider).go('/earnings/statements');
    await app.settle(tester);
    expect(find.text('لا كشوف بعد.'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('the push opens the statement over «أرباحي», and «مشاركة '
      'كصورة» shares it as an image', (tester) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    app.server.on('/v1/captain/earnings', [FakeAnswer(200, earningsJson())]);
    app.server.on('/v1/captain/statements/$statementId', [
      FakeAnswer(200, statementJson()),
    ]);
    await app.pump(tester);
    await app.live(tester);
    app.push.tap({
      'target': 'statement',
      'statementId': statementId,
      'messageId': 'm',
    });
    await app.settle(tester);
    expect(_location(app), '/earnings/statements/$statementId');
    expect(find.text('المبلغ المصروف: 111 ₺'), findsOneWidget);

    // Rendering the image runs outside the test's fake clock.
    await tester.runAsync(() async {
      await tester.tap(find.byKey(const Key('statement-share')));
      for (var i = 0; i < 40 && app.shared.isEmpty; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
      }
    });
    await app.settle(tester);
    final png = app.shared['statement-$statementId.png'];
    expect(png, isNotNull);
    // The PNG signature.
    expect(png!.sublist(0, 4), [0x89, 0x50, 0x4E, 0x47]);

    // Back returns to the list, then «أرباحي».
    app.container.read(routerProvider).pop();
    await app.settle(tester);
    expect(find.text('كشوف الأسبوع'), findsOneWidget);
    app.container.read(routerProvider).pop();
    await app.settle(tester);
    expect(find.byKey(const Key('earnings')), findsOneWidget);
    await app.done(tester);
  });
}
