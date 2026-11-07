import 'dart:convert';

import 'package:captain/src/work/location.dart';
import 'package:core_auth/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

Map<String, Object?> bodyOf(TestApp app, String path) {
  final data = app.server.to(path).last.data;
  return (data is String ? jsonDecode(data) : data) as Map<String, Object?>;
}

void main() {
  testWidgets('goes online with the location and offline with the hand-in '
      'reminder (CA §7.2, §7.5, §4.3)', (tester) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    await app.pump(tester);
    await app.live(tester);
    expect(find.text('غير متصل'), findsOneWidget);
    expect(app.location.tracking, 0);

    app.server.on('/v1/captain/availability/online', [
      FakeAnswer(200, availabilityJson(state: 'online_available')),
    ]);
    app.work(availability: [availabilityJson(state: 'online_available')]);
    await tester.tap(find.byKey(const Key('online-switch')));
    await app.settle(tester);
    expect(bodyOf(app, '/v1/captain/availability/online'), {
      'appVersion': '0.1.0',
      'simulatedLocation': false,
    });
    expect(find.text('متصل متاح'), findsOneWidget);
    expect(app.location.tracking, 1);

    app.server.on('/v1/captain/availability/offline', [
      FakeAnswer(200, {'handIn': moneyJson('41000')}),
    ]);
    app.work(availability: [availabilityJson(usage: '41000')]);
    await tester.tap(find.byKey(const Key('online-switch')));
    await app.settle(tester);
    expect(find.text('عليك تسليم 410 ₺'), findsWidgets);
    await tester.tap(find.text('حسناً'));
    await app.settle(tester);
    expect(find.text('غير متصل'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('shows every block of going online (CA §7.2)', (tester) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    await app.pump(tester);
    await app.live(tester);
    app.server.on('/v1/captain/availability/online', [
      const FakeAnswer(409, {
        'error': 'online_blocked',
        'blocks': [
          {'kind': 'cash_limit', 'limit': '500000'},
          {'kind': 'simulated_location'},
        ],
      }),
    ]);
    await tester.tap(find.byKey(const Key('online-switch')));
    await app.settle(tester);
    expect(
      find.text(
        'بلغت حد العهدة (5000 ₺). سلّم النقد في المكتب لتصلك العروض.\n'
        'أوقف تطبيقات تغيير الموقع لتتمكن من الاتصال.',
      ),
      findsOneWidget,
    );
    await app.done(tester);
  });

  testWidgets('a refused location permission keeps the captain offline', (
    tester,
  ) async {
    final app = TestApp();
    app.work(availability: [availabilityJson()]);
    await app.pump(tester);
    await app.live(tester);
    app.location.problem = LocationProblem.denied;
    await tester.tap(find.byKey(const Key('online-switch')));
    await app.settle(tester);
    expect(
      find.text('اسمح لتطبيق الكابتن بالوصول إلى موقعك لتتمكن من الاتصال.'),
      findsOneWidget,
    );
    expect(app.server.to('/v1/captain/availability/online'), isEmpty);
    await app.done(tester);
  });

  testWidgets('rings the offer until it expires (CA §8.2–8.3)', (tester) async {
    final app = TestApp();
    app.work(
      availability: [availabilityJson(state: 'online_available')],
      offers: [offerJson(left: const Duration(milliseconds: 1500))],
    );
    await app.pump(tester);
    await app.live(tester);
    expect(find.text('عرض جديد'), findsOneWidget);
    expect(find.text('تعيين من العمليات'), findsOneWidget);
    expect(find.text('35 ₺'), findsOneWidget);
    expect(find.text('مطعم الشام · 1.2 كم'), findsOneWidget);
    expect(find.text('تدفع للمطعم: 400 ₺'), findsOneWidget);
    expect(find.text('تقبض من الزبون: 410 ₺'), findsOneWidget);
    // C2: nothing of the customer's but the neighbourhood.
    expect(find.textContaining('أحمد'), findsNothing);
    await app.advance(tester, const Duration(seconds: 1));
    expect(app.ringer.ringing, isTrue);

    app.work(availability: [availabilityJson(state: 'online_available')]);
    await app.advance(tester, const Duration(seconds: 1));
    await app.settle(tester);
    expect(app.ringer.ringing, isFalse);
    expect(find.text('عرض جديد'), findsNothing);
    await app.done(tester);
  });

  testWidgets('a refused acceptance says the offer is gone (CA §8.3)', (
    tester,
  ) async {
    final app = TestApp();
    app.work(
      availability: [availabilityJson(state: 'online_available')],
      offers: [offerJson()],
    );
    await app.pump(tester);
    await app.live(tester);
    app.server.on('/v1/captain/offers/$offerId/accept', [
      const FakeAnswer(409, {'error': 'offer_unavailable'}),
    ]);
    app.work(availability: [availabilityJson(state: 'online_available')]);
    await tester.tap(find.text('قبول'));
    await app.settle(tester);
    expect(find.text('لم يعد العرض متاحاً'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('takes an order from the offer to delivery (CA §8.3, §9.1–9.8)', (
    tester,
  ) async {
    final app = TestApp();
    app.work(
      availability: [availabilityJson(state: 'online_available')],
      offers: [offerJson()],
    );
    await app.pump(tester);
    await app.live(tester);

    // Accept: the order becomes the active one, step 1.
    app.server.on('/v1/captain/offers/$offerId/accept', [
      FakeAnswer(200, {'offer': offerJson()}),
    ]);
    app.work(
      availability: [availabilityJson(state: 'busy')],
      orders: [orderJson()],
    );
    await tester.tap(find.text('قبول'));
    await app.settle(tester);
    final accept = app.server.to('/v1/captain/offers/$offerId/accept').single;
    expect(accept.headers['Idempotency-Key'], isNotEmpty);
    expect(find.text('عرض جديد'), findsNothing);
    expect(app.ringer.ringing, isFalse);
    expect(find.text('الخطوة 1 من 4: إلى المطعم'), findsOneWidget);
    expect(find.text('الطلب #10423 · الأصناف: 2'), findsOneWidget);
    // Accepted here: no «عيّنتك العمليات».
    expect(find.textContaining('عيّنتك'), findsNothing);

    // Far from the restaurant the arrival is disabled (C6).
    app.location.move(pin);
    await app.settle(tester);
    expect(find.text('اقترب من المطعم لتأكيد الوصول'), findsOneWidget);
    app.location.move(restaurant);
    await app.settle(tester);
    expect(find.text('هل وصلت إلى المطعم؟'), findsOneWidget);

    await tester.tap(find.text('ابدأ الملاحة'));
    expect(
      app.launched.last.toString(),
      'https://www.google.com/maps/dir/?api=1&destination=36.586%2C37.044',
    );

    app.server.on('/v1/captain/orders/$orderId/arrive', [
      FakeAnswer(200, {'order': orderJson(track: 'at_merchant', version: 4)}),
    ]);
    app.work(
      availability: [availabilityJson(state: 'busy')],
      orders: [orderJson(track: 'at_merchant', version: 4)],
    );
    await tester.tap(find.text('وصلت إلى المطعم'));
    await app.settle(tester);
    expect(bodyOf(app, '/v1/captain/orders/$orderId/arrive'), {
      'location': {
        'latitude': restaurant.latitude,
        'longitude': restaurant.longitude,
        'accuracyMetres': 8,
        'recordedAt': now.toIso8601String(),
        'simulated': false,
      },
    });

    // Step 2: the payment shows once every item is ticked (C7).
    expect(find.text('الخطوة 2 من 4: عند المطعم'), findsOneWidget);
    expect(find.text('تنتظر منذ 3 د'), findsOneWidget);
    expect(find.text('دفعت للمطعم واستلمت الطلب'), findsNothing);
    await tester.tap(find.text('2 × شاورما'));
    await tester.pump();
    expect(find.text('ادفع للمطعم: 400 ₺'), findsOneWidget);

    final pending = orderJson(
      track: 'pickup_pending',
      version: 5,
      request: requestJson(),
    );
    app.server.on('/v1/captain/orders/$orderId/pickup-request', [
      FakeAnswer(200, {'order': pending}),
    ]);
    app.work(
      availability: [availabilityJson(state: 'busy')],
      orders: [pending],
    );
    await app.tapVisible(tester, find.text('دفعت للمطعم واستلمت الطلب'));
    await app.settle(tester);
    expect(bodyOf(app, '/v1/captain/orders/$orderId/pickup-request')['lines'], [
      moneyJson('40000'),
    ]);
    expect(find.text('بانتظار تأكيد المطعم'), findsOneWidget);
    expect(find.text('1:00'), findsOneWidget);

    // The restaurant confirms: a chime, then step 3.
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
    app.transport.event('order.picked_up', 6);
    await app.settle(tester);
    expect(app.ringer.chimes, 1);
    expect(find.text('الخطوة 3 من 4: إلى الزبون'), findsOneWidget);
    expect(find.text('تم الاستلام — توجّه إلى الزبون'), findsWidgets);
    expect(find.text('أحمد'), findsOneWidget);
    expect(find.text('تقبض من الزبون: 410 ₺ · 10 \$'), findsOneWidget);
    expect(find.text('الزبون سيدفع بـ \$'), findsOneWidget);
    // C10: the number goes to the dialer only.
    expect(find.textContaining('944222222'), findsNothing);
    await app.tapVisible(tester, find.text('اتصال بالزبون'));
    expect(app.launched.last.toString(), 'tel:+963944222222');
    await tester.tap(find.text('واتساب الزبون'));
    expect(app.launched.last.toString(), 'https://wa.me/963944222222');

    // Away from the pin «وصلت» asks for a reason first (K4).
    final atCustomer = orderJson(
      status: 'arrived',
      track: 'at_customer',
      version: 7,
      awayReason: 'pin_inaccurate',
    );
    app.server.on('/v1/captain/orders/$orderId/arrive-at-customer', [
      FakeAnswer(200, {'order': atCustomer}),
    ]);
    app.work(
      availability: [availabilityJson(state: 'busy')],
      orders: [atCustomer],
    );
    await app.tapVisible(tester, find.text('وصلت'));
    await app.settle(tester);
    await tester.tap(find.text('موقع الزبون على الخريطة غير دقيق'));
    await tester.pump();
    await tester.tap(find.text('إرسال'));
    await app.settle(tester);
    expect(
      bodyOf(app, '/v1/captain/orders/$orderId/arrive-at-customer')['away'],
      {'reason': 'pin_inaccurate', 'note': null},
    );

    // Step 4: the exact amount in dollars, then «تم التسليم».
    expect(find.text('الخطوة 4 من 4: عند الزبون'), findsOneWidget);
    expect(find.text('المبلغ المطلوب'), findsOneWidget);
    await app.tapVisible(tester, find.byKey(const Key('exact-USD')));
    await tester.pump();
    app.server.on('/v1/captain/orders/$orderId/deliver', [
      FakeAnswer(200, summaryJson()),
    ]);
    app.work(availability: [availabilityJson(state: 'online_available')]);
    await app.tapVisible(tester, find.text('تم التسليم'));
    await app.settle(tester);
    final deliver = bodyOf(app, '/v1/captain/orders/$orderId/deliver');
    expect(deliver['received'], [moneyJson('1000', 'USD')]);
    expect(deliver['change'], isEmpty);
    expect(deliver['amountDue'], moneyJson('41000'));
    expect(deliver['shortfall'], isNull);
    // The arrival's reason covers the delivery (K4).
    expect(deliver['away'], isNull);

    // The summary (CA §9.8), then «إنهاء العمل».
    expect(find.text('ربحت من هذا الطلب: 35 ₺'), findsOneWidget);
    expect(find.text('تغيّرت عهدتك: +10 ₺'), findsOneWidget);
    expect(find.text('عليك تسليم اليوم: 410 ₺'), findsOneWidget);
    app.server.on('/v1/captain/availability/offline', [
      const FakeAnswer(200, {'handIn': null}),
    ]);
    app.work(availability: [availabilityJson()]);
    await tester.tap(find.text('إنهاء العمل'));
    await app.settle(tester);
    expect(app.server.to('/v1/captain/availability/offline'), hasLength(1));
    expect(find.text('غير متصل'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('asks the shortfall reason the server requires (K16)', (
    tester,
  ) async {
    final app = TestApp();
    final atCustomer = orderJson(status: 'arrived', track: 'at_customer');
    app.work(
      availability: [availabilityJson(state: 'busy')],
      orders: [atCustomer],
    );
    app.location.fix = fixAt(pin);
    await app.pump(tester);
    await app.live(tester);
    await tester.enterText(find.byKey(const Key('received-TRY')), '400');
    await tester.pump();
    // One currency: the app sees the shortfall itself.
    expect(find.text('المبلغ المقبوض أقل من المطلوب بـ 10 ₺'), findsOneWidget);
    await app.tapVisible(tester, find.text('خطأ في العد'));
    await tester.pump();
    app.server.on('/v1/captain/orders/$orderId/deliver', [
      FakeAnswer(200, summaryJson()),
    ]);
    await app.tapVisible(tester, find.text('تم التسليم'));
    await app.settle(tester);
    final deliver = bodyOf(app, '/v1/captain/orders/$orderId/deliver');
    expect(deliver['received'], [moneyJson('40000')]);
    expect(deliver['shortfall'], {'reason': 'counting_error', 'note': null});
    await app.done(tester);
  });

  testWidgets('computes the change in the currency received (CA §9.7)', (
    tester,
  ) async {
    final app = TestApp();
    app.work(
      availability: [availabilityJson(state: 'busy')],
      orders: [orderJson(status: 'arrived', track: 'at_customer')],
    );
    app.location.fix = fixAt(pin);
    await app.pump(tester);
    await app.live(tester);
    await tester.enterText(find.byKey(const Key('received-TRY')), '500');
    await tester.pump();
    expect(find.text('الباقي: 90 ₺'), findsOneWidget);
    app.server.on('/v1/captain/orders/$orderId/deliver', [
      const FakeAnswer(409, {'error': 'overpaid'}),
    ]);
    await tester.enterText(find.byKey(const Key('change-TRY')), '80');
    await tester.pump();
    await app.tapVisible(tester, find.text('تم التسليم'));
    await app.settle(tester);
    expect(bodyOf(app, '/v1/captain/orders/$orderId/deliver')['change'], [
      moneyJson('8000'),
    ]);
    expect(find.text('سجّل الباقي الذي أعدته للزبون'), findsOneWidget);
    await app.done(tester);
  });
}
