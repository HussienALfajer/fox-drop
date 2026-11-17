import 'package:core_auth/testing.dart';
import 'package:customer/src/browsing/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';
import 'support.dart';

Map<String, Object?> _code(
  String code, {
  String kind = 'percentage',
  int? percentBp = 2000,
  String? amount,
  String? maxDiscount = '5000',
  String? minOrder,
  List<Map<String, Object?>> restaurants = const [],
  List<String> zones = const [],
  Map<String, Object?>? hours,
  int? usesLeft,
  Map<String, Object?>? ended,
}) => {
  'code': code,
  'kind': kind,
  'percentBp': percentBp,
  'amount': amount,
  'maxDiscount': maxDiscount,
  'minOrder': minOrder,
  'restaurants': restaurants,
  'zones': zones,
  'hours': hours,
  'validTo': '2026-12-31T21:00:00.000Z',
  'usesLeft': usesLeft,
  'ended': ended,
};

Future<TestApp> _myCodes(WidgetTester tester) async {
  final app = await browsingApp(
    tester,
    signedIn: true,
    before: (app) => app.server.on('/v1/customer/promo-codes', [
      FakeAnswer(200, {
        'currency': 'TRY',
        'codes': [
          _code(
            'SHAM20',
            minOrder: '15000',
            restaurants: [
              {'id': shamId, 'name': 'مطعم الشام'},
            ],
            zones: ['الحي الشمالي'],
            hours: {'startMinute': 720, 'endMinute': 960},
            usesLeft: 2,
          ),
          _code(
            'SHIP',
            kind: 'free_delivery',
            percentBp: null,
            maxDiscount: null,
          ),
          _code(
            'ONCE',
            kind: 'fixed_amount',
            percentBp: null,
            maxDiscount: null,
            amount: '2500',
            usesLeft: 0,
            ended: {'reason': 'used', 'at': '2026-11-20T09:00:00.000Z'},
          ),
          _code(
            'OLD',
            ended: {'reason': 'expired', 'at': '2026-11-10T21:00:00.000Z'},
          ),
        ],
      }),
    ]),
  );
  await tester.tap(find.byKey(const Key('open-account')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('open-codes')));
  await tester.pumpAndSettle();
  return app;
}

// CU §12.4 «أكوادي»: «متاحة» and «منتهية», each code with its value, its
// conditions, its expiry and the uses left; «استخدم» opens the restaurant
// of a one-restaurant code, home otherwise.
void main() {
  testWidgets('lists «متاحة» with the conditions, then «منتهية»', (
    tester,
  ) async {
    final app = await _myCodes(tester);
    expect(app.server.to('/v1/customer/promo-codes'), hasLength(1));
    String subtitle(String code) =>
        (tester.widget<ListTile>(find.byKey(Key('my-code-$code'))).subtitle!
                as Text)
            .data!;
    expect(
      subtitle('SHAM20'),
      'خصم 20% بحد أقصى 50 ₺\n'
      'للطلبات من 150 ₺\n'
      'في: مطعم الشام\n'
      'في مناطق: الحي الشمالي\n'
      'من 12:00 م إلى 4:00 م\n'
      'ينتهي 01/01/2027\n'
      'متبقٍ لك: 2',
    );
    expect(subtitle('SHIP'), 'توصيل مجاني\nينتهي 01/01/2027');
    expect(find.byKey(const Key('my-code-ONCE')), findsNothing);

    await tester.tap(find.text('منتهية'));
    await tester.pumpAndSettle();
    expect(subtitle('ONCE'), 'خصم 25 ₺\nاستُخدم 20/11/2026');
    expect(subtitle('OLD'), 'خصم 20% بحد أقصى 50 ₺\nانتهى 11/11/2026');
    expect(find.byKey(const Key('use-code-OLD')), findsNothing);
    await app.done(tester);
  });

  testWidgets('«استخدم» opens the code\'s one restaurant', (tester) async {
    final app = await _myCodes(tester);
    await tester.tap(find.byKey(const Key('use-code-SHAM20')));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<RestaurantScreen>(find.byType(RestaurantScreen))
          .restaurantId,
      shamId,
    );
    await app.done(tester);
  });
}
