import 'package:core_auth/testing.dart';
import 'package:customer/src/location/position.dart';
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
    'discount': '0',
    'rounding': '0',
    'total': '14000',
  },
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
        'itemId': shawarmaId,
        'name': 'شاورما دجاج',
        'quantity': 2,
        'note': null,
        'options': <Object>[],
        'unitPrice': '6500',
        'lineTotal': '13000',
      },
    ],
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
}
