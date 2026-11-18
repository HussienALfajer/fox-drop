import 'package:core_auth/testing.dart';
import 'package:customer/src/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';
import 'support.dart';

const _orderId = '00000000-0000-4000-8000-0000000000e2';

// A delivered order of two shawarma, with its rating.
Map<String, Object?> _order({Map<String, Object?>? rating}) => {
  'id': _orderId,
  'number': '10423',
  'redeliveryOf': null,
  'status': 'delivered',
  'version': 9,
  'placedAt': '2026-11-07T12:00:00.000Z',
  'report': null,
  'reportUntil': null,
  'redeliveries': <Object>[],
  'rating': rating,
  'promisedAt': '2026-11-07T12:45:00.000Z',
  'cancellation': null,
  'rejection': null,
  'outcome': null,
  'delivery': null,
  'itemReport': null,
  'doorPing': null,
  'restaurant': {'id': shamId, 'nameAr': 'مطعم الشام', 'nameEn': null},
  'captain': null,
  'currency': 'TRY',
  'money': {
    'itemsValue': '13000',
    'deliveryFee': '1000',
    'deliveryFree': false,
    'discount': '0',
    'rounding': '0',
    'total': '14000',
  },
  'promoCode': null,
  'equivalents': <Object>[],
  'lines': [
    {
      'position': 0,
      'itemId': shawarmaId,
      'name': 'شاورما دجاج',
      'quantity': 2,
      'note': null,
      'options': <Object>[],
      'unitPrice': '6500',
      'lineTotal': '13000',
      'added': false,
      'quantityBefore': null,
    },
  ],
  'removedLines': <Object>[],
  'timeline': <Object>[],
  'orderAgain': false,
  'edited': false,
  'payIn': null,
  'note': null,
  'estimate': {'fromMin': 30, 'toMin': 40},
  'address': {
    'location': {'latitude': 36.5862, 'longitude': 37.0463},
    'neighbourhood': 'الحي الشمالي',
    'label': null,
    'customLabel': null,
    'street': 'شارع القلعة، بناء 4',
    'floor': null,
    'landmark': 'قرب جامع النور',
    'recipientName': null,
    'directions': null,
  },
};

Map<String, Object?> _rating({
  String? until,
  bool captainRatable = true,
  Map<String, Object?>? restaurant,
  Map<String, Object?>? captain,
}) => {
  'until': until,
  'captainRatable': captainRatable,
  'restaurant': restaurant,
  'captain': captain,
};

const _sentRestaurant = {
  'stars': 2,
  'reasons': [
    {'code': 'cold_food', 'label': 'الطعام بارد'},
  ],
  'comment': 'وصل بارداً',
  'at': '2026-11-07T13:00:00.000Z',
};

const _content = {
  'reasons': {
    'customer_cancel': <Object?>[],
    'customer_problem': <Object?>[],
    'order_note': <Object?>[],
    'restaurant_rating_low': [
      {'code': 'cold_food', 'label': 'الطعام بارد', 'note': 'none'},
      {'code': 'bad_taste', 'label': 'الطعم غير جيد', 'note': 'none'},
    ],
    'restaurant_rating_mid': <Object?>[],
    'restaurant_rating_high': [
      {'code': 'great_taste', 'label': 'طعم رائع', 'note': 'none'},
    ],
    'captain_rating_low': <Object?>[],
    'captain_rating_mid': <Object?>[],
    'captain_rating_high': [
      {'code': 'kind', 'label': 'لطيف', 'note': 'none'},
    ],
  },
  'faq': <Object?>[],
};

void main() {
  final later = DateTime.now()
      .toUtc()
      .add(const Duration(days: 2))
      .toIso8601String();

  Future<TestApp> open(WidgetTester tester, List<FakeAnswer> answers) async {
    final app = TestApp(signedIn: true);
    app.server.on('/v1/customer/content', [const FakeAnswer(200, _content)]);
    app.server.on('/v1/customer/contact', [const FakeAnswer(200, {})]);
    app.server.on('/v1/customer/orders/$_orderId', answers);
    app.server.on('/v1/customer/orders/active', [
      const FakeAnswer(200, {'orders': <Object>[]}),
    ]);
    await app.pump(tester);
    app.container.read(routerProvider).go('/orders/$_orderId');
    await tester.pumpAndSettle();
    return app;
  }

  // CU §12.1, U15, Q16 (slice 2.26a).
  testWidgets(
    'opens the sheet once, sends the restaurant part and shows it as sent',
    (tester) async {
      final rated = _order(
        rating: _rating(until: later, restaurant: _sentRestaurant),
      );
      final app = await open(tester, [
        FakeAnswer(200, {'order': _order(rating: _rating(until: later))}),
        FakeAnswer(200, {'order': rated}),
      ]);
      app.server.on('/v1/customer/orders/$_orderId/rating', [
        FakeAnswer(200, {'order': rated}),
      ]);

      // The sheet opened by itself, with both parts.
      expect(find.byKey(const Key('rating-restaurant')), findsOneWidget);
      expect(find.byKey(const Key('rating-captain')), findsOneWidget);
      final send = find.byKey(const Key('rating-send'));
      expect(tester.widget<FilledButton>(send).onPressed, isNull);

      // A star tapped again clears the part, which is then skipped.
      await tester.tap(find.byKey(const Key('rating-captain-star-3')));
      await tester.pumpAndSettle();
      expect(tester.widget<FilledButton>(send).onPressed, isNotNull);
      await tester.tap(find.byKey(const Key('rating-captain-star-3')));
      await tester.pumpAndSettle();
      expect(tester.widget<FilledButton>(send).onPressed, isNull);

      await tester.tap(find.byKey(const Key('rating-restaurant-star-5')));
      await tester.pumpAndSettle();
      expect(find.text('طعم رائع'), findsOneWidget);
      // Other stars, other chips (AP Appendix B).
      await tester.tap(find.byKey(const Key('rating-restaurant-star-2')));
      await tester.pumpAndSettle();
      expect(find.text('طعم رائع'), findsNothing);
      await tester.tap(
        find.byKey(const Key('rating-restaurant-reason-cold_food')),
      );
      await tester.enterText(
        find.byKey(const Key('rating-restaurant-comment')),
        ' وصل بارداً ',
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(send);
      await tester.tap(send);
      await tester.pumpAndSettle();

      // The captain's part had no stars: skipped.
      expect(app.bodyOf('/v1/customer/orders/$_orderId/rating'), {
        'restaurant': {
          'stars': 2,
          'reasons': ['cold_food'],
          'comment': 'وصل بارداً',
        },
        'captain': null,
      });
      expect(find.text('شكراً لتقييمك'), findsOneWidget);
      expect(find.text('تقييمك للمطعم: 2 من 5'), findsOneWidget);
      expect(find.text('الطعام بارد\nوصل بارداً'), findsOneWidget);

      // The captain's part is left: «قيّم طلبك» offers it alone, and the
      // sheet does not open by itself again on this phone.
      app.container.read(routerProvider).go('/');
      await tester.pumpAndSettle();
      app.container.read(routerProvider).go('/orders/$_orderId');
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('rating-send')), findsNothing);
      await tester.tap(find.byKey(const Key('order-rate')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('rating-restaurant')), findsNothing);
      expect(find.byKey(const Key('rating-captain')), findsOneWidget);
      await app.done(tester);
    },
  );

  testWidgets('offers nothing once the window closed', (tester) async {
    final app = await open(tester, [
      FakeAnswer(200, {
        'order': _order(
          rating: _rating(captainRatable: false, restaurant: _sentRestaurant),
        ),
      }),
    ]);
    expect(find.byKey(const Key('rating-send')), findsNothing);
    expect(find.byKey(const Key('order-rate')), findsNothing);
    expect(find.text('تقييمك للمطعم: 2 من 5'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets(
    'takes a part sent from another phone, or before a lost answer, as sent',
    (tester) async {
      final app = await open(tester, [
        FakeAnswer(200, {
          'order': _order(rating: _rating(until: later, captainRatable: false)),
        }),
        FakeAnswer(200, {
          'order': _order(
            rating: _rating(captainRatable: false, restaurant: _sentRestaurant),
          ),
        }),
      ]);
      app.server.on('/v1/customer/orders/$_orderId/rating', [
        const FakeAnswer(409, {'statusCode': 409, 'error': 'already_rated'}),
      ]);
      expect(find.byKey(const Key('rating-captain')), findsNothing);
      await tester.tap(find.byKey(const Key('rating-restaurant-star-4')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('rating-send')));
      await tester.pumpAndSettle();
      // The part is in the order now: nothing is left to resend.
      expect(find.text('شكراً لتقييمك'), findsOneWidget);
      expect(find.text('تقييمك للمطعم: 2 من 5'), findsOneWidget);
      expect(find.byKey(const Key('order-rate')), findsNothing);
      await app.done(tester);
    },
  );
}
