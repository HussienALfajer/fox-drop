import 'package:core_api/core_api.dart';
import 'package:core_auth/testing.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:core_maps/core_maps.dart';
import 'package:customer/src/checkout/checkout.dart' show CheckoutForm;
import 'package:customer/src/checkout/problems.dart';
import 'package:customer/src/location/pin.dart';
import 'package:customer/src/location/position.dart';
import 'package:customer/src/checkout/quote.dart';
import 'package:customer/src/profile/profile.dart';
import 'package:customer/src/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';
import 'fixtures.dart';
import 'support.dart';

const _orderId = '00000000-0000-4000-8000-000000000101';
const _addressId = '00000000-0000-4000-8000-000000000201';

Map<String, Object?> _quote({
  String version = 'v1',
  List<Map<String, Object?>> problems = const [],
  String unitPrice = '6500',
  bool minimumReached = true,
  String? payIn,
  Map<String, Object?>? promoCode,
  List<Map<String, Object?>> availableCodes = const [],
  Map<String, Object?>? suggestedCode,
  String discount = '0',
  String total = '14000',
}) => {
  'version': version,
  'restaurant': {
    'id': shamId,
    'state': 'open',
    'busyMode': false,
    'until': null,
    'opensAt': null,
    'message': null,
  },
  'lines': [
    {
      'itemId': shawarmaId,
      'name': 'شاورما دجاج',
      'quantity': 2,
      'note': null,
      'options': <Object>[],
      'unitPrice': unitPrice,
      'lineTotal': '${int.parse(unitPrice) * 2}',
    },
  ],
  'currency': 'TRY',
  'money': {
    'itemsValue': '13000',
    'deliveryFee': '1000',
    'deliveryFree': false,
    'discount': discount,
    'rounding': '0',
    'total': total,
  },
  'promoCode': promoCode,
  'availableCodes': availableCodes,
  'suggestedCode': suggestedCode,
  'equivalents': [
    {'amount': '350', 'currency': 'USD'},
  ],
  'payIn': payIn == null ? null : {'amount': '350', 'currency': payIn},
  'estimate': {'fromMin': 30, 'toMin': 40},
  'minimumOrder': {
    'amount': '10000',
    'currency': 'TRY',
    'reached': minimumReached,
    'missing': minimumReached ? '0' : '3000',
  },
  'freeDelivery': {'threshold': '30000', 'reached': false, 'missing': '17000'},
  'rates': [
    {'currency': 'USD', 'rateVersionId': null},
  ],
  'problems': problems,
};

// «الأكواد المتاحة لك» (CU §10.4): two that apply, one below its minimum.
final _available = [
  {
    'code': 'FOX20',
    'kind': 'percentage',
    'percentBp': 2000,
    'amount': null,
    'maxDiscount': '5000',
    'minOrder': null,
    'hours': {'startMinute': 720, 'endMinute': 1320},
    'validTo': '2026-12-31T21:00:00.000Z',
    'discount': '2600',
    'missing': null,
  },
  {
    'code': 'SHIP',
    'kind': 'free_delivery',
    'percentBp': null,
    'amount': null,
    'maxDiscount': null,
    'minOrder': null,
    'hours': null,
    'validTo': '2026-12-31T21:00:00.000Z',
    'discount': '1000',
    'missing': null,
  },
  {
    'code': 'BIG',
    'kind': 'fixed_amount',
    'percentBp': null,
    'amount': '4000',
    'maxDiscount': null,
    'minOrder': '20000',
    'hours': null,
    'validTo': '2026-12-31T21:00:00.000Z',
    'discount': null,
    'missing': '7000',
  },
];

Map<String, Object?> _order() => {
  'order': {
    'id': _orderId,
    'number': '10423',
    'status': 'placed',
    'version': 1,
    'placedAt': DateTime.now().toUtc().toIso8601String(),
    'promisedAt': null,
    'cancellation': null,
    'delivery': null,
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
      'location': {'latitude': azaz.latitude, 'longitude': azaz.longitude},
      'neighbourhood': 'الحي الشمالي',
      'label': null,
      'customLabel': null,
      'street': 'شارع القلعة، بناء 4',
      'floor': null,
      'landmark': 'قرب جامع النور',
      'recipientName': null,
      'directions': null,
    },
  },
};

/// A customer with two large shawarmas in the cart, on checkout.
Future<TestApp> _checkout(
  WidgetTester tester, {
  bool signedIn = true,
  List<FakeAnswer>? quotes,
  List<Map<String, Object?>> addresses = const [],
  void Function(TestApp app)? before,
  FakePositionSource? position,
}) async {
  final app = await browsingApp(
    tester,
    signedIn: signedIn,
    position: position,
    before: (app) {
      app.server.on(
        '/v1/customer/quote',
        quotes ?? [FakeAnswer(200, _quote())],
      );
      app.server.on('/v1/customer/addresses', [
        FakeAnswer(200, {'addresses': addresses}),
      ]);
      app.server.on('/v1/customer/orders/$_orderId', [
        FakeAnswer(200, _order()),
      ]);
      before?.call(app);
    },
  );
  await openSham(tester);
  await addShawarma(tester);
  app.container.read(routerProvider).go('/checkout');
  await tester.pumpAndSettle();
  return app;
}

Future<void> _fillAddress(WidgetTester tester) async {
  await tester.enterText(
    find.byKey(const Key('address-street')),
    'شارع القلعة، بناء 4',
  );
  await tester.enterText(
    find.byKey(const Key('address-landmark')),
    'قرب جامع النور',
  );
  await tester.pump();
}

Future<void> _confirm(WidgetTester tester) async {
  await tester.ensureVisible(find.byKey(const Key('confirm-order')));
  await tester.tap(find.byKey(const Key('confirm-order')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('checkout shows the quote of the cart at the point', (
    tester,
  ) async {
    final app = await _checkout(tester);

    final quote = app.bodyOf('/v1/customer/quote');
    expect(quote['restaurantId'], shamId);
    expect(quote['location'], {
      'latitude': azaz.latitude,
      'longitude': azaz.longitude,
    });
    expect(quote['lines'], [
      {
        'itemId': shawarmaId,
        'optionIds': [largeId, cheeseId],
        'quantity': 2,
        'note': null,
        'knownUnitPrice': '6500',
      },
    ]);
    expect(quote['payIn'], isNull);
    expect(quote['appVersion'], '0.1.0');

    expect(find.text('يصل خلال 30–40 د'), findsOneWidget);
    expect(find.text('130 ₺'), findsOneWidget);
    expect(find.text('10 ₺'), findsOneWidget);
    expect(find.text('أو 3.50 \$'), findsOneWidget);
    expect(find.text('أضف 170 ₺ لتحصل على توصيل مجاني'), findsOneWidget);
    expect(find.text('الخصم'), findsNothing);
    expect(find.text('تقريب'), findsNothing);
    expect(find.text('الحي الشمالي'), findsWidgets);
    expect(find.text('تأكيد الطلب — 140 ₺'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('places the order with an unsaved address and opens it', (
    tester,
  ) async {
    final app = await _checkout(
      tester,
      before: (app) =>
          app.server.on('/v1/customer/orders', [FakeAnswer(201, _order())]),
    );
    await _fillAddress(tester);
    await _confirm(tester);

    final request = app.server.to('/v1/customer/orders').single;
    expect(request.headers['Idempotency-Key'], isA<String>());
    final body = app.bodyOf('/v1/customer/orders');
    expect(body['quoteVersion'], 'v1');
    expect(body['addressId'], isNull);
    expect(body['unsavedAddress'], {
      'location': {'latitude': azaz.latitude, 'longitude': azaz.longitude},
      'street': 'شارع القلعة، بناء 4',
      'floor': null,
      'landmark': 'قرب جامع النور',
      'contactPhone': null,
      'recipientName': null,
      'directions': null,
    });
    expect(body['note'], isNull);
    expect(body['payIn'], isNull);
    expect(find.text('أرسلنا طلبك إلى مطعم الشام'), findsOneWidget);
    expect(find.text('#10423'), findsOneWidget);
    expect(find.text('بانتظار تأكيد المطعم'), findsOneWidget);
    expect(app.device.values['cart'], isNull);
    await app.done(tester);
  });

  testWidgets('a preset note from Content goes into the note (CU §10.3)', (
    tester,
  ) async {
    final app = await _checkout(
      tester,
      before: (app) =>
          app.server.on('/v1/customer/orders', [FakeAnswer(201, _order())]),
    );
    await _fillAddress(tester);
    await tester.ensureVisible(find.text('اتصل بي عند الوصول'));
    await tester.tap(find.text('اتصل بي عند الوصول'));
    await tester.pump();
    await _confirm(tester);
    expect(app.bodyOf('/v1/customer/orders')['note'], 'اتصل بي عند الوصول');
    await app.done(tester);
  });

  test('the contact number takes a mobile of any country (D.11b)', () {
    String? e164(String typed) => CheckoutForm(contactPhone: typed).contactE164;
    expect(e164('0944 123 456'), '+963944123456');
    expect(e164('+49 151 23456789'), '+4915123456789');
    expect(e164('0112345678'), isNull, reason: 'a landline');
  });

  testWidgets('checks the address and the note before sending', (tester) async {
    final app = await _checkout(tester);
    await tester.enterText(
      find.byKey(const Key('address-phone')),
      '0944123456',
    );
    await tester.enterText(
      find.byKey(const Key('order-note')),
      'اتصلوا على 0944123456',
    );
    await tester.pump();
    await _confirm(tester);

    expect(find.text('اكتب من 3 إلى 100 حرفاً'), findsNWidgets(2));
    expect(find.text('اكتب من 2 إلى 60 حرفاً'), findsOneWidget);
    expect(
      find.text(
        'لا تكتب أرقام هواتف في الملاحظة. رقم التواصل يصل إلى الكابتن تلقائياً.',
      ),
      findsOneWidget,
    );
    expect(app.server.to('/v1/customer/orders'), isEmpty);
    await app.done(tester);
  });

  testWidgets('a guest signs in at «تأكيد الطلب» and comes back', (
    tester,
  ) async {
    final app = await _checkout(tester, signedIn: false);
    await _fillAddress(tester);
    await _confirm(tester);

    expect(find.byKey(const Key('sign-in-phone')), findsOneWidget);
    expect(app.server.to('/v1/customer/orders'), isEmpty);
    await app.done(tester);
  });

  testWidgets('a new price is accepted before ordering', (tester) async {
    final app = await _checkout(
      tester,
      quotes: [
        FakeAnswer(
          200,
          _quote(
            version: 'v2',
            unitPrice: '7000',
            problems: [
              {'code': 'price_changed', 'line': 0, 'opensAt': null},
            ],
          ),
        ),
        FakeAnswer(200, _quote(version: 'v3', unitPrice: '7000')),
      ],
    );
    expect(find.text('تغيّر سعر شاورما دجاج من 65 ₺ إلى 70 ₺'), findsOneWidget);
    final confirm = tester.widget<FilledButton>(
      find.byKey(const Key('confirm-order')),
    );
    expect(confirm.onPressed, isNull);

    await tester.tap(find.text('موافق'));
    await tester.pumpAndSettle();
    final again = app.bodyOf('/v1/customer/quote', index: 1);
    expect((again['lines'] as List).single['knownUnitPrice'], '7000');
    expect(find.text('تغيّر سعر شاورما دجاج من 65 ₺ إلى 70 ₺'), findsNothing);
    await app.done(tester);
  });

  testWidgets('below the minimum order the order waits', (tester) async {
    await _checkout(
      tester,
      quotes: [
        FakeAnswer(
          200,
          _quote(
            minimumReached: false,
            problems: [
              {'code': 'below_minimum_order', 'line': null, 'opensAt': null},
            ],
          ),
        ),
      ],
    );

    expect(find.text('أضف 30 ₺ لتصل إلى الحد الأدنى'), findsOneWidget);
    expect(find.text('أضف 30 ₺ لتصل إلى الحد الأدنى (100 ₺)'), findsOneWidget);
    expect(find.text('أضف أصنافاً'), findsOneWidget);
  });

  testWidgets('«سأدفع بـ» is sent and remembered', (tester) async {
    final app = await _checkout(
      tester,
      quotes: [
        FakeAnswer(200, _quote()),
        FakeAnswer(200, _quote(payIn: 'USD')),
      ],
    );
    await tester.tap(find.byKey(const Key('pay-in-USD')));
    await tester.pumpAndSettle();

    expect(app.bodyOf('/v1/customer/quote', index: 1)['payIn'], 'USD');
    expect(app.device.values['checkout.pay_in'], 'USD');
    expect(find.text('ستدفع حوالي 3.50 \$'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('a changed quote is shown, then confirmed with a new key', (
    tester,
  ) async {
    final app = await _checkout(
      tester,
      quotes: [
        FakeAnswer(200, _quote()),
        FakeAnswer(200, _quote(version: 'v2')),
      ],
      before: (app) => app.server.on('/v1/customer/orders', [
        const FakeAnswer.none(),
        const FakeAnswer(409, {'error': 'quote_changed'}),
        FakeAnswer(201, _order()),
      ]),
    );
    await _fillAddress(tester);
    await _confirm(tester);
    expect(find.text('تعذّر إرسال طلبك، حاول مجدداً.'), findsOneWidget);
    await _confirm(tester);
    expect(
      find.text('تغيّر شيء في طلبك. راجع التفاصيل ثم أكّد مجدداً.'),
      findsOneWidget,
    );
    await _confirm(tester);

    final sends = app.server.to('/v1/customer/orders');
    final keys = [for (final s in sends) s.headers['Idempotency-Key']];
    // A lost answer is retried with the same key; a refused command is not.
    expect(keys[0], keys[1]);
    expect(keys[2], isNot(keys[1]));
    expect(app.bodyOf('/v1/customer/orders', index: 2)['quoteVersion'], 'v2');
    expect(find.text('أرسلنا طلبك إلى مطعم الشام'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('a position worse than 100 m is adjusted on the map (CU §7.4)', (
    tester,
  ) async {
    const adjusted = GeoPoint(36.5871, 37.0471);
    final app = await _checkout(
      tester,
      position: FakePositionSource((
        fix: const PositionFix(azaz, 250),
        failure: null,
      )),
    );
    expect(
      find.text(
        'دقة موقعك 250 م. عدّل الدبوس على الخريطة ليكون العنوان دقيقاً.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('adjust-pin')));
    await tester.pumpAndSettle();

    // The map opens on the phone's position, at street level.
    expect(app.pinMap.initial, const MapCamera(azaz, streetZoom));
    app.pinMap.move(const MapCamera(adjusted, 18));
    await tester.pump();
    await tester.tap(find.byKey(const Key('confirm-pin')));
    await tester.pumpAndSettle();

    expect(app.server.to('/v1/customer/location').last.uri.queryParameters, {
      'latitude': '${adjusted.latitude}',
      'longitude': '${adjusted.longitude}',
    });
    final quotes = app.server.to('/v1/customer/quote').length;
    expect(app.bodyOf('/v1/customer/quote', index: quotes - 1)['location'], {
      'latitude': adjusted.latitude,
      'longitude': adjusted.longitude,
    });
    expect(find.byKey(const Key('adjust-pin')), findsNothing);
    expect(find.byKey(const Key('address-street')), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('a pin far from the phone is confirmed first (CU §7.5)', (
    tester,
  ) async {
    final position = FakePositionSource();
    final app = await _checkout(
      tester,
      position: position,
      before: (app) =>
          app.server.on('/v1/customer/orders', [FakeAnswer(201, _order())]),
    );
    // The phone has moved 2 km north since the point was taken.
    position.result = (
      fix: const PositionFix(GeoPoint(36.6042, 37.0463), 20),
      failure: null,
    );
    await _fillAddress(tester);
    await _confirm(tester);

    expect(position.calls.last.ask, isFalse);
    expect(find.text('النقطة تبعد 2.0 كم عن موقعك الحالي.'), findsOneWidget);
    await tester.tap(find.text('تغيير العنوان'));
    await tester.pumpAndSettle();
    expect(app.server.to('/v1/customer/orders'), isEmpty);

    await _confirm(tester);
    await tester.tap(find.text('نعم، أرسل إلى هذا العنوان'));
    await tester.pumpAndSettle();
    expect(app.server.to('/v1/customer/orders'), hasLength(1));
    await app.done(tester);
  });

  testWidgets('an inaccurate phone position skips the check', (tester) async {
    final position = FakePositionSource();
    final app = await _checkout(
      tester,
      position: position,
      before: (app) =>
          app.server.on('/v1/customer/orders', [FakeAnswer(201, _order())]),
    );
    position.result = (
      fix: const PositionFix(GeoPoint(36.6042, 37.0463), 150),
      failure: null,
    );
    await _fillAddress(tester);
    await _confirm(tester);

    expect(find.text('هل أنت متأكد من العنوان؟'), findsNothing);
    expect(app.server.to('/v1/customer/orders'), hasLength(1));
    await app.done(tester);
  });

  testWidgets('a saved address near the point is preselected', (tester) async {
    final app = await _checkout(
      tester,
      addresses: [
        {
          'location': {'latitude': 36.5866, 'longitude': 37.0463},
          'label': 'home',
          'customLabel': null,
          'street': 'شارع القلعة، بناء 4',
          'floor': null,
          'landmark': 'قرب جامع النور',
          'contactPhone': null,
          'recipientName': null,
          'directions': null,
          'id': _addressId,
          'isDefault': true,
          'neighbourhood': 'الحي الشمالي',
        },
      ],
      before: (app) =>
          app.server.on('/v1/customer/orders', [FakeAnswer(201, _order())]),
    );
    expect(find.byKey(const Key('address-street')), findsNothing);
    await _confirm(tester);

    final body = app.bodyOf('/v1/customer/orders');
    expect(body['addressId'], _addressId);
    expect(body['unsavedAddress'], isNull);
    final quote = app.bodyOf('/v1/customer/quote', index: 1);
    expect(quote['location'], {'latitude': 36.5866, 'longitude': 37.0463});
    await app.done(tester);
  });

  testWidgets('the cart shows the minimum and keeps «متابعة» off below it', (
    tester,
  ) async {
    final app = await _checkout(
      tester,
      quotes: [
        FakeAnswer(
          200,
          _quote(
            minimumReached: false,
            problems: [
              {'code': 'below_minimum_order', 'line': null, 'opensAt': null},
            ],
          ),
        ),
      ],
    );
    app.container.read(routerProvider).go('/cart');
    await tester.pumpAndSettle();

    expect(find.text('أضف 30 ₺ لتصل إلى الحد الأدنى (100 ₺)'), findsOneWidget);
    final next = tester.widget<FilledButton>(
      find.byKey(const Key('cart-continue')),
    );
    expect(next.onPressed, isNull);
    await app.done(tester);
  });

  testWidgets('«احفظ هذا العنوان» saves it once, then orders with it', (
    tester,
  ) async {
    final app = await _checkout(
      tester,
      before: (app) {
        app.server.on('/v1/customer/addresses', [
          const FakeAnswer(200, {'addresses': <Object>[]}),
        ]);
        app.server.on('/v1/customer/orders', [
          const FakeAnswer.none(),
          FakeAnswer(201, _order()),
        ]);
      },
    );
    // POST /addresses answers with the saved address (same path as the list).
    app.server.on('/v1/customer/addresses', [
      FakeAnswer(201, {
        'location': {'latitude': azaz.latitude, 'longitude': azaz.longitude},
        'label': 'work',
        'customLabel': null,
        'street': 'شارع القلعة، بناء 4',
        'floor': null,
        'landmark': 'قرب جامع النور',
        'contactPhone': null,
        'recipientName': null,
        'directions': null,
        'id': _addressId,
        'isDefault': false,
        'neighbourhood': 'الحي الشمالي',
      }),
      const FakeAnswer(200, {'addresses': <Object>[]}),
    ]);
    await _fillAddress(tester);
    await tester.ensureVisible(find.byKey(const Key('address-save')));
    await tester.tap(find.byKey(const Key('address-save')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('العمل'));
    await tester.pump();
    await _confirm(tester);
    expect(find.text('تعذّر إرسال طلبك، حاول مجدداً.'), findsOneWidget);
    await _confirm(tester);

    final saves = app.server
        .to('/v1/customer/addresses')
        .where((r) => r.method == 'POST')
        .toList();
    expect(saves, hasLength(1));
    final saved = saves.single.data as Map;
    expect(saved['label'], 'work');
    expect(saved['isDefault'], false);
    final sends = app.server.to('/v1/customer/orders');
    expect(sends, hasLength(2));
    for (var i = 0; i < 2; i++) {
      final body = app.bodyOf('/v1/customer/orders', index: i);
      expect(body['addressId'], _addressId);
      expect(body['unsavedAddress'], isNull);
    }
    expect(find.text('أرسلنا طلبك إلى مطعم الشام'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('«احفظ هذا العنوان» retried after a lost answer sends the same '
      'key, so the server saves it once (CU §19 item 28)', (tester) async {
    final app = await _checkout(
      tester,
      before: (app) {
        app.server.on('/v1/customer/addresses', [
          const FakeAnswer(200, {'addresses': <Object>[]}),
        ]);
        app.server.on('/v1/customer/orders', [FakeAnswer(201, _order())]);
      },
    );
    app.server.on('/v1/customer/addresses', [
      const FakeAnswer.none(),
      FakeAnswer(201, {
        'location': {'latitude': azaz.latitude, 'longitude': azaz.longitude},
        'label': 'home',
        'customLabel': null,
        'street': 'شارع القلعة، بناء 4',
        'floor': null,
        'landmark': 'قرب جامع النور',
        'contactPhone': null,
        'recipientName': null,
        'directions': null,
        'id': _addressId,
        'isDefault': false,
        'neighbourhood': 'الحي الشمالي',
      }),
      const FakeAnswer(200, {'addresses': <Object>[]}),
    ]);
    await _fillAddress(tester);
    await tester.ensureVisible(find.byKey(const Key('address-save')));
    await tester.tap(find.byKey(const Key('address-save')));
    await tester.pumpAndSettle();
    await _confirm(tester);
    expect(app.server.to('/v1/customer/orders'), isEmpty);
    await _confirm(tester);

    final saves = app.server
        .to('/v1/customer/addresses')
        .where((r) => r.method == 'POST')
        .toList();
    expect(saves, hasLength(2));
    final key = saves[0].headers['Idempotency-Key'];
    expect(key, isA<String>());
    expect(saves[1].headers['Idempotency-Key'], key);
    expect(app.bodyOf('/v1/customer/orders')['addressId'], _addressId);
    expect(find.text('أرسلنا طلبك إلى مطعم الشام'), findsOneWidget);
    await app.done(tester);
  });

  // CU §4.7, Appendix C «Terms pending»: a version published while the app
  // stayed open is shown with «أوافق», then checkout quotes again.
  testWidgets('a pending version of the terms opens from checkout', (
    tester,
  ) async {
    final app = await _checkout(
      tester,
      quotes: [
        FakeAnswer(
          200,
          _quote(
            version: 'v2',
            problems: [
              {'code': 'terms_pending', 'line': null, 'opensAt': null},
            ],
          ),
        ),
        FakeAnswer(200, _quote()),
      ],
    );
    expect(find.text('وافق على الشروط الجديدة لتتمكن من الطلب'), findsOne);
    app.terms(version: 2, body: 'الشروط الجديدة', pending: true);
    app.server.on('/v1/customer/terms/accept', [
      const FakeAnswer(200, {'status': 'accepted'}),
    ]);
    await tester.tap(find.text('عرض الشروط'));
    await tester.pumpAndSettle();
    expect(find.text('الشروط الجديدة'), findsOneWidget);

    app.terms(version: 2, body: 'الشروط الجديدة');
    await tester.tap(find.byKey(const Key('terms-accept')));
    await tester.pumpAndSettle();
    expect(app.bodyOf('/v1/customer/terms/accept'), {'version': 2});
    expect(find.text('وافق على الشروط الجديدة لتتمكن من الطلب'), findsNothing);
    expect(find.byKey(const Key('confirm-order')), findsOneWidget);
    await app.done(tester);
  });

  // docs/domain/08, owner decision 2026-11-09: late cancellations stopped
  // ordering until support reviews the account; nothing to do in the app.
  testWidgets('a review stop refuses the order with no action', (tester) async {
    final app = await _checkout(
      tester,
      quotes: [
        FakeAnswer(
          200,
          _quote(
            problems: [
              {'code': 'review_stop', 'line': null, 'opensAt': null},
            ],
          ),
        ),
      ],
    );
    expect(find.text('حسابك موقوف حتى مراجعة فريق الدعم'), findsOneWidget);
    expect(find.text('عرض الشروط'), findsNothing);
    expect(find.text('إعادة المحاولة'), findsNothing);
    final confirm = tester.widget<FilledButton>(
      find.byKey(const Key('confirm-order')),
    );
    expect(confirm.onPressed, isNull);
    await app.done(tester);
  });

  // CU §5.5, AP §8.8 (slice 2.11a): a fake order's dues block ordering until
  // paid at the office; nothing to do in the app.
  testWidgets('unpaid dues refuse the order with the amount', (tester) async {
    final app = await _checkout(
      tester,
      quotes: [
        FakeAnswer(
          200,
          _quote(
            problems: [
              {
                'code': 'dues_unpaid',
                'line': null,
                'opensAt': null,
                'amount': {'amount': '24400', 'currency': 'TRY'},
              },
            ],
          ),
        ),
      ],
    );
    expect(
      find.text(
        'عليك 244 ₺ لـ FOX DROP. ادفعه في المكتب ليُفك الحظر تلقائياً.',
      ),
      findsOneWidget,
    );
    final confirm = tester.widget<FilledButton>(
      find.byKey(const Key('confirm-order')),
    );
    expect(confirm.onPressed, isNull);
    await app.done(tester);
  });

  // CU §5.5, AP §9.8 (slice 2.25a): a block from the panel refuses the order
  // with its reason and end.
  testWidgets('a block refuses the order with its reason and end', (
    tester,
  ) async {
    final app = await _checkout(
      tester,
      quotes: [
        FakeAnswer(
          200,
          _quote(
            problems: [
              {
                'code': 'account_blocked',
                'line': null,
                'opensAt': null,
                'message': 'مخالفة شروط الاستخدام',
                'until': '2026-11-20T15:30:00.000Z',
              },
            ],
          ),
        ),
      ],
      before: (app) => app.server.on('/v1/customer/contact', [
        const FakeAnswer(200, {
          'phone': '+963944000000',
          'whatsapp': '+963944000001',
        }),
      ]),
    );
    expect(
      find.text('حسابك محظور حتى 20/11/2026 6:30 م: مخالفة شروط الاستخدام'),
      findsOneWidget,
    );
    // CU Appendix C «Pre-order problems»: «تواصل مع الدعم».
    await tester.tap(find.text('تواصل مع الدعم'));
    await tester.pumpAndSettle();
    expect(app.launched.last.host, 'wa.me');
    final confirm = tester.widget<FilledButton>(
      find.byKey(const Key('confirm-order')),
    );
    expect(confirm.onPressed, isNull);
    await app.done(tester);
  });

  testWidgets('a blocked order keeps the cart and shows the new quote', (
    tester,
  ) async {
    final app = await _checkout(
      tester,
      quotes: [
        FakeAnswer(200, _quote()),
        FakeAnswer(
          200,
          _quote(
            version: 'v2',
            problems: [
              {'code': 'no_captain_nearby', 'line': null, 'opensAt': null},
            ],
          ),
        ),
      ],
      before: (app) => app.server.on('/v1/customer/orders', [
        const FakeAnswer(409, {'error': 'order_blocked'}),
      ]),
    );
    await _fillAddress(tester);
    await _confirm(tester);

    expect(find.text('لم نتمكن من إرسال طلبك. راجع المشكلة أعلاه.'), findsOne);
    expect(find.text('الضغط عالٍ الآن، جرّب بعد دقائق'), findsOneWidget);
    expect(find.text('إعادة المحاولة'), findsOneWidget);
    expect(app.device.values['cart'], isNotNull);
    await app.done(tester);
  });

  testWidgets('an address outside the zones is refused with its text', (
    tester,
  ) async {
    await _checkout(
      tester,
      before: (app) => app.server.on('/v1/customer/orders', [
        const FakeAnswer(409, {'error': 'outside_zones'}),
      ]),
    );
    await _fillAddress(tester);
    await _confirm(tester);

    expect(find.text('العنوان خارج منطقة التوصيل'), findsOneWidget);
  });

  testWidgets('a guest signs in at checkout and gets the account\'s quote', (
    tester,
  ) async {
    final app = await _checkout(tester, signedIn: false);
    await _fillAddress(tester);
    await _confirm(tester);
    app.completedProfile();
    app.server.on('/v1/customer/auth/code', [
      FakeAnswer(200, {
        'channel': 'whatsapp',
        'resendAfterSec': 60,
        'expiresAt': DateTime.now().toUtc().toIso8601String(),
      }),
    ]);
    app.server.on('/v1/customer/auth/sign-in', [
      FakeAnswer(200, {
        'accountId': accountId,
        'newAccount': false,
        ...tokens('1', DateTime.now().add(const Duration(minutes: 15))),
      }),
    ]);
    await tester.enterText(
      find.byKey(const Key('sign-in-phone')),
      '0944123456',
    );
    await tester.tap(find.text('إرسال الرمز'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('sign-in-code')), '123456');
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('confirm-order')), findsOneWidget);
    final quotes = app.server.to('/v1/customer/quote');
    expect(quotes.first.headers['Authorization'], isNull);
    expect(quotes.last.headers['Authorization'], 'Bearer access-1');
    // What the guest typed is still there.
    expect(find.text('قرب جامع النور'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('no order before the profile can be read', (tester) async {
    final app = await _checkout(
      tester,
      before: (app) =>
          app.server.on('/v1/customer/orders', [FakeAnswer(201, _order())]),
    );
    app.server.on('/v1/customer/profile', [
      const FakeAnswer(503, {'error': 'unavailable'}),
    ]);
    app.container.invalidate(profileProvider);
    await _fillAddress(tester);
    await _confirm(tester);

    expect(app.server.to('/v1/customer/orders'), isEmpty);
    expect(find.text('تعذّر الاتصال بالخادم'), findsOneWidget);
    await app.done(tester);
  });

  // CU §4.4, §10.7 item 4 (Q11): the first order asks for notifications.
  Future<TestApp> notAllowed(WidgetTester tester) => _checkout(
    tester,
    before: (app) {
      app.permission.allowed = false;
      app.server.on('/v1/customer/orders', [FakeAnswer(201, _order())]);
    },
  );

  testWidgets('the first order asks for notifications, then places it', (
    tester,
  ) async {
    final app = await notAllowed(tester);
    await _fillAddress(tester);
    await _confirm(tester);

    expect(find.text('اسمح بالإشعارات لتعرف متى يصل طلبك'), findsOneWidget);
    expect(app.server.to('/v1/customer/orders'), isEmpty);
    await tester.tap(find.text('سماح'));
    await tester.pumpAndSettle();

    expect(app.permission.requests, 1);
    expect(app.server.to('/v1/customer/orders'), hasLength(1));
    expect(find.text('#10423'), findsOneWidget);
    expect(find.byKey(const Key('notifications-off')), findsNothing);
    await app.done(tester);
  });

  testWidgets('refused, the order goes and its screen links to the settings', (
    tester,
  ) async {
    final app = await notAllowed(tester);
    await _fillAddress(tester);
    await _confirm(tester);
    await tester.tap(find.text('ليس الآن'));
    await tester.pumpAndSettle();

    expect(app.permission.requests, 0);
    expect(app.server.to('/v1/customer/orders'), hasLength(1));
    expect(find.byKey(const Key('notifications-off')), findsOneWidget);
    await tester.tap(find.text('الإعدادات'));
    expect(app.permission.settingsOpened, 1);

    // Allowed in the settings, the banner goes when the app comes back.
    app.permission.allowed = true;
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('notifications-off')), findsNothing);
    await app.done(tester);
  });

  testWidgets('a later order never asks again', (tester) async {
    final app = await notAllowed(tester);
    app.device.values['notifications_asked'] = '1';
    await _fillAddress(tester);
    await _confirm(tester);

    expect(find.text('اسمح بالإشعارات لتعرف متى يصل طلبك'), findsNothing);
    expect(app.permission.requests, 0);
    expect(app.server.to('/v1/customer/orders'), hasLength(1));
    await app.done(tester);
  });

  testWidgets('a phone that allows notifications is not asked', (tester) async {
    final app = await _checkout(
      tester,
      before: (app) =>
          app.server.on('/v1/customer/orders', [FakeAnswer(201, _order())]),
    );
    await _fillAddress(tester);
    await _confirm(tester);

    expect(find.text('اسمح بالإشعارات لتعرف متى يصل طلبك'), findsNothing);
    expect(app.server.to('/v1/customer/orders'), hasLength(1));
    expect(app.device.values['notifications_asked'], '1');
    await app.done(tester);
  });

  // CU §4.7, Appendix C «Emergency stop»: checkout's first quote says it
  // opened checkout; the stop's problem shows the browsing message and
  // keeps «تأكيد الطلب» off.
  testWidgets('during an emergency stop checkout counts and refuses', (
    tester,
  ) async {
    final app = await _checkout(
      tester,
      quotes: [
        FakeAnswer(
          200,
          _quote(
            problems: [
              {'code': 'emergency_stop', 'message': 'نتوقف قليلاً ونعود'},
            ],
          ),
        ),
      ],
    );
    expect(app.bodyOf('/v1/customer/quote')['openedCheckout'], isTrue);
    expect(find.text('نتوقف قليلاً ونعود'), findsOneWidget);
    final confirm = tester.widget<FilledButton>(
      find.byKey(const Key('confirm-order')),
    );
    expect(confirm.onPressed, isNull);

    // A later quote of the same checkout is not the opening one.
    app.container.invalidate(quoteProvider);
    await tester.pumpAndSettle();
    final quotes = app.server.to('/v1/customer/quote');
    expect(quotes.length, greaterThan(1));
    expect(
      app.bodyOf(
        '/v1/customer/quote',
        index: quotes.length - 1,
      )['openedCheckout'],
      isFalse,
    );
    await app.done(tester);
  });

  testWidgets('checkout opened from the cart asks its own quote', (
    tester,
  ) async {
    final app = await browsingApp(
      tester,
      signedIn: true,
      before: (app) {
        app.server.on('/v1/customer/quote', [FakeAnswer(200, _quote())]);
        app.server.on('/v1/customer/addresses', [
          const FakeAnswer(200, {'addresses': <Object>[]}),
        ]);
      },
    );
    await openSham(tester);
    await addShawarma(tester);
    app.container.read(routerProvider).push('/cart');
    await tester.pumpAndSettle();
    final before = app.server.to('/v1/customer/quote').length;
    expect(
      app.bodyOf('/v1/customer/quote', index: before - 1)['openedCheckout'],
      isFalse,
    );
    await tester.tap(find.byKey(const Key('cart-continue')));
    await tester.pumpAndSettle();
    final quotes = app.server.to('/v1/customer/quote');
    expect(quotes, hasLength(before + 1));
    expect(
      app.bodyOf('/v1/customer/quote', index: before)['openedCheckout'],
      isTrue,
    );
    await app.done(tester);
  });

  // A saved address near the point moves the point on opening (CU §10.3):
  // the opening quote is the first one sent, never lost to that move.
  testWidgets('the opening quote survives the preselected address', (
    tester,
  ) async {
    final app = await _checkout(
      tester,
      addresses: [
        {
          'id': _addressId,
          'label': 'home',
          'customLabel': null,
          // 44 m from the phone's point: preselected, so the point moves.
          'location': {'latitude': 36.5866, 'longitude': 37.0463},
          'neighbourhood': 'الحي الشمالي',
          'street': 'شارع القلعة، بناء 4',
          'floor': null,
          'landmark': 'قرب جامع النور',
          'contactPhone': null,
          'recipientName': null,
          'directions': null,
          'isDefault': true,
        },
      ],
    );
    expect(find.byKey(const Key('address-street')), findsNothing);
    final quotes = app.server.to('/v1/customer/quote');
    final opened = [
      for (var i = 0; i < quotes.length; i++)
        app.bodyOf('/v1/customer/quote', index: i)['openedCheckout'],
    ];
    expect(opened.where((o) => o == true), hasLength(1));
    expect(opened.first, isTrue);
    await app.done(tester);
  });

  group('the code (CU §10.4)', () {
    Future<void> apply(WidgetTester tester, String code) async {
      await tester.ensureVisible(find.byKey(const Key('code-field')));
      await tester.enterText(find.byKey(const Key('code-field')), code);
      await tester.pump();
      await tester.tap(find.byKey(const Key('code-apply')));
      await tester.pumpAndSettle();
    }

    testWidgets('a code is applied, shown with «الخصم» and sent', (
      tester,
    ) async {
      final app = await _checkout(
        tester,
        quotes: [
          FakeAnswer(200, _quote()),
          FakeAnswer(
            200,
            _quote(
              version: 'v2',
              discount: '3000',
              total: '11000',
              promoCode: {
                'code': 'FOX10',
                'kind': 'percentage',
                'discount': '3000',
                'fixedAmountAboveItems': false,
              },
            ),
          ),
        ],
        before: (app) =>
            app.server.on('/v1/customer/orders', [FakeAnswer(201, _order())]),
      );
      expect(app.bodyOf('/v1/customer/quote')['code'], isNull);
      expect(find.text('أدخل الكود'), findsOneWidget);
      await apply(tester, ' fox10 ');

      final quotes = app.server.to('/v1/customer/quote').length;
      expect(
        app.bodyOf('/v1/customer/quote', index: quotes - 1)['code'],
        'fox10',
      );
      // The applied code in the server's form.
      expect(find.text('FOX10'), findsOneWidget);
      expect(find.text('إزالة'), findsOneWidget);
      expect(find.text('الخصم (FOX10)'), findsOneWidget);
      expect(find.text('30 ₺'), findsOneWidget);
      expect(find.text('تأكيد الطلب — 110 ₺'), findsOneWidget);
      expect(find.text(l10nCodeAboveItems), findsNothing);
      // Kept with the cart on the device.
      expect(app.device.values['cart'], contains('"code":"fox10"'));

      await _fillAddress(tester);
      await _confirm(tester);
      final body = app.bodyOf('/v1/customer/orders');
      expect(body['code'], 'fox10');
      expect(body['quoteVersion'], 'v2');
      await app.done(tester);
    });

    testWidgets('the suggestion and «الأكواد المتاحة لك» apply only on «تطبيق»', (
      tester,
    ) async {
      final listed = _quote(
        availableCodes: _available,
        suggestedCode: {'code': 'FOX20', 'discount': '2600'},
      );
      final app = await _checkout(
        tester,
        quotes: [FakeAnswer(200, listed), FakeAnswer(200, listed)],
      );
      // U11: suggested, never applied by itself.
      expect(app.bodyOf('/v1/customer/quote')['code'], isNull);
      expect(find.text('لديك كود يوفر عليك 26 ₺: FOX20'), findsOneWidget);
      expect(find.text('الأكواد المتاحة لك'), findsOneWidget);
      expect(
        find.text(
          'خصم 20% بحد أقصى 50 ₺ · من 12:00 م إلى 10:00 م · ينتهي 01/01/2027 · يوفر عليك 26 ₺',
        ),
        findsOneWidget,
      );
      expect(
        find.text('توصيل مجاني · ينتهي 01/01/2027 · يوفر عليك 10 ₺'),
        findsOneWidget,
      );
      // Below its minimum: no «تطبيق».
      expect(
        find.text(
          'خصم 40 ₺ · للطلبات من 200 ₺ · ينتهي 01/01/2027 · أضف 70 ₺ لاستخدام هذا الكود',
        ),
        findsOneWidget,
      );
      expect(find.byKey(const Key('code-apply-BIG')), findsNothing);

      await tester.ensureVisible(
        find.byKey(const Key('code-suggestion-apply')),
      );
      await tester.tap(find.byKey(const Key('code-suggestion-apply')));
      await tester.pumpAndSettle();
      final quotes = app.server.to('/v1/customer/quote').length;
      expect(
        app.bodyOf('/v1/customer/quote', index: quotes - 1)['code'],
        'FOX20',
      );
      await app.done(tester);
    });

    testWidgets('another code replaces the applied one after a confirmation', (
      tester,
    ) async {
      final applied = _quote(
        discount: '1000',
        total: '13000',
        promoCode: {
          'code': 'SHIP',
          'kind': 'free_delivery',
          'discount': '1000',
          'fixedAmountAboveItems': false,
        },
        availableCodes: _available,
        suggestedCode: {'code': 'FOX20', 'discount': '2600'},
      );
      final app = await _checkout(
        tester,
        quotes: [
          FakeAnswer(200, _quote()),
          FakeAnswer(200, applied),
          FakeAnswer(200, applied),
        ],
      );
      await apply(tester, 'ship');
      // The applied code has no «تطبيق» of its own.
      expect(find.byKey(const Key('code-apply-SHIP')), findsNothing);
      Future<void> pick() async {
        await tester.ensureVisible(find.byKey(const Key('code-apply-FOX20')));
        await tester.tap(find.byKey(const Key('code-apply-FOX20')));
        await tester.pumpAndSettle();
      }

      await pick();
      expect(
        find.text('طلبك يحمل الكود SHIP. هل تستبدله بالكود FOX20؟'),
        findsOneWidget,
      );
      await tester.tap(find.text('إلغاء'));
      await tester.pumpAndSettle();
      expect(app.device.values['cart'], contains('"code":"ship"'));

      await pick();
      await tester.tap(find.byKey(const Key('code-replace')));
      await tester.pumpAndSettle();
      final quotes = app.server.to('/v1/customer/quote').length;
      expect(
        app.bodyOf('/v1/customer/quote', index: quotes - 1)['code'],
        'FOX20',
      );
      expect(app.device.values['cart'], contains('"code":"FOX20"'));
      await app.done(tester);
    });

    testWidgets('«إزالة» removes the code and quotes without it', (
      tester,
    ) async {
      final app = await _checkout(tester);
      await apply(tester, 'FOX10');
      await tester.tap(find.byKey(const Key('code-remove')));
      await tester.pumpAndSettle();

      final quotes = app.server.to('/v1/customer/quote').length;
      expect(
        app.bodyOf('/v1/customer/quote', index: quotes - 1)['code'],
        isNull,
      );
      expect(find.text('أدخل الكود'), findsOneWidget);
      expect(app.device.values['cart'], isNot(contains('FOX10')));
      await app.done(tester);
    });

    testWidgets('a fixed code above the items value warns before confirming', (
      tester,
    ) async {
      final app = await _checkout(
        tester,
        quotes: [
          FakeAnswer(200, _quote()),
          FakeAnswer(
            200,
            _quote(
              version: 'v2',
              discount: '13000',
              total: '1000',
              promoCode: {
                'code': 'BIG200',
                'kind': 'fixed_amount',
                'discount': '13000',
                'fixedAmountAboveItems': true,
              },
            ),
          ),
        ],
      );
      await apply(tester, 'BIG200');

      expect(find.text('الخصم (BIG200)'), findsOneWidget);
      expect(find.text(l10nCodeAboveItems), findsOneWidget);
      expect(find.text('تأكيد الطلب — 10 ₺'), findsOneWidget);
      await app.done(tester);
    });

    testWidgets('a refused code blocks the order until «إزالة»', (
      tester,
    ) async {
      final app = await _checkout(
        tester,
        quotes: [
          FakeAnswer(200, _quote()),
          FakeAnswer(
            200,
            _quote(
              version: 'v2',
              problems: [
                {
                  'code': 'promo_code',
                  'line': null,
                  'opensAt': null,
                  'refusal': 'below_minimum',
                  'amount': {'amount': '2000', 'currency': 'TRY'},
                },
              ],
            ),
          ),
          FakeAnswer(200, _quote(version: 'v3')),
        ],
      );
      await apply(tester, 'FOX20');

      expect(find.text('أضف 20 ₺ لاستخدام هذا الكود'), findsOneWidget);
      final confirm = tester.widget<FilledButton>(
        find.byKey(const Key('confirm-order')),
      );
      expect(confirm.onPressed, isNull);
      expect(find.text('الخصم (FOX20)'), findsNothing);

      await tester.tap(find.text('إزالة').first);
      await tester.pumpAndSettle();
      final quotes = app.server.to('/v1/customer/quote').length;
      expect(
        app.bodyOf('/v1/customer/quote', index: quotes - 1)['code'],
        isNull,
      );
      expect(find.text('أضف 20 ₺ لاستخدام هذا الكود'), findsNothing);
      expect(find.text('أدخل الكود'), findsOneWidget);
      await app.done(tester);
    });

    testWidgets('a code that stopped working at confirmation shows why', (
      tester,
    ) async {
      final app = await _checkout(
        tester,
        quotes: [
          FakeAnswer(200, _quote()),
          FakeAnswer(
            200,
            _quote(
              version: 'v2',
              discount: '3000',
              total: '11000',
              promoCode: {
                'code': 'FOX10',
                'kind': 'percentage',
                'discount': '3000',
                'fixedAmountAboveItems': false,
              },
            ),
          ),
          FakeAnswer(
            200,
            _quote(
              version: 'v3',
              problems: [
                {
                  'code': 'promo_code',
                  'line': null,
                  'opensAt': null,
                  'refusal': 'budget_reached',
                },
              ],
            ),
          ),
        ],
        before: (app) => app.server.on('/v1/customer/orders', [
          const FakeAnswer(409, {'error': 'order_blocked'}),
        ]),
      );
      await apply(tester, 'FOX10');
      await _fillAddress(tester);
      await _confirm(tester);

      expect(
        find.text('لم نتمكن من إرسال طلبك. راجع المشكلة أعلاه.'),
        findsOne,
      );
      expect(find.text('الكود غير متاح اليوم'), findsOneWidget);
      expect(find.text('الخصم (FOX10)'), findsNothing);
      expect(find.text('تأكيد الطلب — 140 ₺'), findsOneWidget);
      expect(app.device.values['cart'], contains('FOX10'));
      await app.done(tester);
    });
  });

  test('every code refusal has its text (CU Appendix C)', () {
    final l10n = lookupAppLocalizations(const Locale('ar'));
    String text(String refusal, [Map<String, Object?>? amount]) =>
        codeRefusalText(
          l10n,
          standardSerializers.deserializeWith(QuoteProblem.serializer, {
            'code': 'promo_code',
            'refusal': refusal,
            'amount': amount,
          })!,
        );
    expect(text('unknown_code'), 'الكود غير صحيح');
    expect(text('not_valid_now'), 'الكود غير صالح الآن');
    expect(
      text('below_minimum', {'amount': '2050', 'currency': 'TRY'}),
      'أضف 20.50 ₺ لاستخدام هذا الكود',
    );
    expect(text('not_for_restaurant'), 'هذا الكود لا يعمل مع هذا المطعم');
    expect(text('first_order_only'), 'هذا الكود للطلب الأول فقط');
    expect(text('used_before'), 'استخدمت هذا الكود من قبل');
    expect(text('uses_ended'), 'انتهت استخدامات هذا الكود');
    expect(text('budget_reached'), 'الكود غير متاح اليوم');
  });
}

const l10nCodeAboveItems = 'قيمة الكود أكبر من قيمة الأصناف، ولا يُستعاد الفرق';
