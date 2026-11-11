import 'dart:convert';

import 'package:core_auth/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

Map<String, Object?> bodyOf(TestApp app, String path) {
  final data = app.server.to(path).last.data;
  return (data is String ? jsonDecode(data) : data) as Map<String, Object?>;
}

Map<String, Object?> carriedJson(List<String> carried) => {
  'baseCurrency': 'TRY',
  'carried': carried,
  'choices': [
    {'currency': 'TRY', 'name': 'ليرة تركية'},
    {'currency': 'USD', 'name': 'دولار أمريكي'},
  ],
};

void main() {
  testWidgets('switches the carried currencies on «الإعدادات», never the '
      'last one off (CA §10.5)', (tester) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    app.server.on('/v1/captain/settings/carried-currencies', [
      FakeAnswer(200, carriedJson(['TRY'])),
      FakeAnswer(200, carriedJson(['TRY', 'USD'])),
    ]);
    await app.pump(tester);
    await app.live(tester);
    await tester.tap(find.text('الإعدادات'));
    await app.settle(tester);
    expect(find.text('العملات التي أحملها'), findsOneWidget);
    expect(find.text('العملة الأساسية'), findsOneWidget);
    // The only one carried cannot be switched off.
    final lira = find.widgetWithText(SwitchListTile, 'ليرة تركية');
    expect(tester.widget<SwitchListTile>(lira).onChanged, isNull);

    await tester.tap(find.widgetWithText(SwitchListTile, 'دولار أمريكي'));
    await app.settle(tester);
    expect(bodyOf(app, '/v1/captain/settings/carried-currencies'), {
      'currencies': ['TRY', 'USD'],
    });
    expect(
      tester
          .widget<SwitchListTile>(
            find.widgetWithText(SwitchListTile, 'دولار أمريكي'),
          )
          .value,
      isTrue,
    );
    expect(tester.widget<SwitchListTile>(lira).onChanged, isNotNull);

    // Refused: the switches read again, with the reason on a snack bar.
    app.server.on('/v1/captain/settings/carried-currencies', [
      const FakeAnswer(400, {'error': 'invalid_carried_currencies'}),
      FakeAnswer(200, carriedJson(['TRY', 'USD'])),
    ]);
    await tester.tap(find.widgetWithText(SwitchListTile, 'ليرة تركية'));
    await app.settle(tester);
    expect(find.text('لم يُحفظ التغيير، حاول مرة أخرى'), findsOneWidget);
    expect(find.text('دولار أمريكي'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('pays the proposed dollars, or splits them across the '
      'restaurant\'s currencies (CA §10.5, C8)', (tester) async {
    final app = TestApp();
    final atRestaurant = orderJson(
      track: 'at_merchant',
      version: 4,
      quantity: 1,
      proposedLines: [moneyJson('1000', 'USD')],
      pickupCurrencies: [moneyJson('40000'), moneyJson('1000', 'USD')],
    );
    app.work(
      availability: [availabilityJson(state: 'busy')],
      orders: [atRestaurant],
    );
    await app.pump(tester);
    await app.live(tester);
    await tester.tap(find.text('1 × شاورما'));
    await tester.pump();
    expect(find.text('ادفع للمطعم: 10 \$'), findsOneWidget);

    await app.tapVisible(tester, find.text('تقسيم المبلغ أو تعديله'));
    await tester.pump();
    expect(find.text('بـ ₺ (المطلوب كاملاً 400 ₺)'), findsOneWidget);
    // The proposal fills its currency's field.
    final dollars = find.widgetWithText(
      TextField,
      'بـ \$ (المطلوب كاملاً 10 \$)',
    );
    expect(tester.widget<TextField>(dollars).controller!.text, '10');
    await tester.enterText(dollars, '5');
    await tester.enterText(
      find.widgetWithText(TextField, 'بـ ₺ (المطلوب كاملاً 400 ₺)'),
      'x',
    );
    await app.tapVisible(tester, find.text('دفعت للمطعم واستلمت الطلب'));
    await tester.pump();
    expect(find.text('أدخل مبلغاً صحيحاً'), findsOneWidget);
    expect(
      app.server.to('/v1/captain/orders/$orderId/pickup-request'),
      isEmpty,
    );

    await tester.enterText(
      find.widgetWithText(TextField, 'بـ ₺ (المطلوب كاملاً 400 ₺)'),
      '200',
    );
    app.server.on('/v1/captain/orders/$orderId/pickup-request', [
      FakeAnswer(200, {
        'order': orderJson(
          track: 'pickup_pending',
          version: 5,
          request: requestJson(),
        ),
      }),
    ]);
    await app.tapVisible(tester, find.text('دفعت للمطعم واستلمت الطلب'));
    await app.settle(tester);
    expect(bodyOf(app, '/v1/captain/orders/$orderId/pickup-request')['lines'], [
      moneyJson('20000'),
      moneyJson('500', 'USD'),
    ]);
    await app.done(tester);
  });
}
