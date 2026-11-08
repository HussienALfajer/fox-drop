import 'package:core_auth/testing.dart';
import 'package:core_realtime/core_realtime.dart';
import 'package:customer/src/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';
import 'support.dart';

const _orderId = '00000000-0000-4000-8000-0000000000e1';

Map<String, Object?> _order({
  String status = 'placed',
  int version = 1,
  Map<String, Object?>? captain,
  Map<String, Object?>? cancellation,
  String? promisedAt,
}) => {
  'id': _orderId,
  'number': '10423',
  'status': status,
  'version': version,
  'placedAt': '2026-11-07T12:00:00.000Z',
  'promisedAt': promisedAt,
  'cancellation': cancellation,
  'delivery': null,
  'restaurant': {'id': shamId, 'nameAr': 'مطعم الشام', 'nameEn': null},
  'captain': captain,
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

const _captain = {
  'firstName': 'سامر',
  'vehicle': 'motorbike',
  'atRestaurant': false,
};

String _status(WidgetTester tester) {
  final tile = tester.widget<ListTile>(find.byKey(const Key('order-status')));
  final title = (tile.title! as Text).data!;
  final subtitle = (tile.subtitle as Text?)?.data;
  return subtitle == null ? title : '$title — $subtitle';
}

// CU §11: the order screen follows the order live (CU §4.3).
void main() {
  Future<TestApp> open(WidgetTester tester, List<FakeAnswer> answers) async {
    final app = TestApp(signedIn: true);
    app.server.on('/v1/customer/orders/$_orderId', answers);
    app.server.on('/v1/customer/orders/active', [
      const FakeAnswer(200, {'orders': <Object>[]}),
    ]);
    await app.pump(tester);
    app.container.read(routerProvider).go('/orders/$_orderId');
    await tester.pumpAndSettle();
    return app;
  }

  testWidgets('each newer event fetches the order and shows its status', (
    tester,
  ) async {
    final app = await open(tester, [
      FakeAnswer(200, {'order': _order()}),
      FakeAnswer(200, {
        'order': _order(
          status: 'accepted',
          version: 3,
          captain: _captain,
          promisedAt: '2026-11-07T12:45:00.000Z',
        ),
      }),
      FakeAnswer(200, {
        'order': _order(
          status: 'ready',
          version: 5,
          captain: {..._captain, 'atRestaurant': true},
          promisedAt: '2026-11-07T12:45:00.000Z',
        ),
      }),
    ]);
    expect(
      _status(tester),
      'بانتظار تأكيد المطعم — أرسلنا طلبك إلى مطعم الشام',
    );
    expect(find.text('يصل خلال 30–40 د'), findsOneWidget);
    // The restaurant has not confirmed yet: its step is current, not done.
    Icon icon(String step) => tester.widget<Icon>(
      find.descendant(
        of: find.byKey(Key('step-$step')),
        matching: find.byType(Icon),
      ),
    );
    expect(icon('confirm').icon, Icons.radio_button_checked);
    expect(icon('preparing').icon, Icons.radio_button_unchecked);

    const channel = 'order:$_orderId';
    app.transport.send(channel, const RealtimeUp(recovered: true));
    app.transport.send(
      channel,
      const RealtimePublication({'orderId': _orderId, 'version': 3}),
    );
    await tester.pumpAndSettle();
    expect(
      _status(tester),
      'المطعم يحضّر طلبك — الكابتن سامر في طريقه إلى المطعم',
    );
    // 12:45 UTC is 3:45 م on Azaz's clock.
    expect(find.text('يصل حوالي 3:45 م'), findsOneWidget);
    expect(find.byKey(const Key('captain-card')), findsOneWidget);
    expect(find.text('دراجة نارية'), findsOneWidget);

    // An older or repeated event is ignored.
    app.transport.send(
      channel,
      const RealtimePublication({'orderId': _orderId, 'version': 3}),
    );
    await tester.pumpAndSettle();
    expect(app.server.to('/v1/customer/orders/$_orderId'), hasLength(2));

    app.transport.send(
      channel,
      const RealtimePublication({'orderId': _orderId, 'version': 5}),
    );
    await tester.pumpAndSettle();
    expect(_status(tester), 'طلبك جاهز — الكابتن يستلم طلبك الآن');
    await app.done(tester);
  });

  testWidgets('an order the restaurant did not answer says so (CU §11.9)', (
    tester,
  ) async {
    final app = await open(tester, [
      FakeAnswer(200, {
        'order': _order(
          status: 'cancelled',
          version: 2,
          cancellation: {
            'at': '2026-11-07T12:07:00.000Z',
            'reason': 'merchant_auto_cancel',
            'text': 'لم يرد المطعم على طلبك',
          },
        ),
      }),
    ]);
    expect(_status(tester), 'لم يرد المطعم على طلبك، نعتذر');
    expect(find.byKey(const Key('step-confirm')), findsNothing);
    await app.done(tester);
  });

  testWidgets('an order operations cancelled shows its reason (CU §11.9)', (
    tester,
  ) async {
    final app = await open(tester, [
      FakeAnswer(200, {
        'order': _order(
          status: 'cancelled',
          version: 3,
          cancellation: {
            'at': '2026-11-07T12:07:00.000Z',
            'reason': 'no_captain',
            'text': 'لم نجد كابتناً متاحاً لطلبك',
          },
        ),
      }),
    ]);
    // The customer-facing reason the order kept from Content (CU Appendix C).
    expect(_status(tester), 'أُلغي طلبك — لم نجد كابتناً متاحاً لطلبك');
    await app.done(tester);
  });

  testWidgets('home shows the active order and opens it (CU §6)', (
    tester,
  ) async {
    final app = TestApp(signedIn: true);
    app.server.on('/v1/customer/orders/active', [
      FakeAnswer(200, {
        'orders': [_order(status: 'accepted', version: 2)],
      }),
    ]);
    app.server.on('/v1/customer/orders/$_orderId', [
      FakeAnswer(200, {'order': _order(status: 'accepted', version: 2)}),
    ]);
    await app.pump(tester);
    expect(find.text('طلبك من مطعم الشام: المطعم يحضّر طلبك'), findsOneWidget);
    await tester.tap(find.byKey(const Key('active-order')));
    await tester.pumpAndSettle();
    expect(_status(tester), startsWith('المطعم يحضّر طلبك'));
    await app.done(tester);
  });

  testWidgets(
    'maintenance blocks every screen but the active order (CU §4.7)',
    (tester) async {
      final app = TestApp(signedIn: true);
      app.platform(maintenance: true, maintenanceMessage: 'صيانة حتى العاشرة');
      app.server.on('/v1/customer/orders/active', [
        FakeAnswer(200, {
          'orders': [_order(status: 'accepted', version: 2)],
        }),
      ]);
      app.server.on('/v1/customer/orders/$_orderId', [
        FakeAnswer(200, {'order': _order(status: 'accepted', version: 2)}),
      ]);
      await app.pump(tester);
      expect(find.text('التطبيق في صيانة'), findsOneWidget);
      expect(find.text('صيانة حتى العاشرة'), findsOneWidget);
      app.container.read(routerProvider).go('/cart');
      await tester.pumpAndSettle();
      expect(find.text('التطبيق في صيانة'), findsOneWidget);

      await tester.tap(find.byKey(const Key('active-order')));
      await tester.pumpAndSettle();
      expect(_status(tester), startsWith('المطعم يحضّر طلبك'));
      await app.done(tester);
    },
  );

  // CU §11.6, §4.7: the delay notice while the stop is on, read at the
  // order's address and again on the stop's broadcast on its channel.
  testWidgets('an emergency stop shows its delay notice until it ends', (
    tester,
  ) async {
    final app = TestApp(signedIn: true);
    app.emergencyStop(active: true, delayNotice: 'قد يتأخر طلبك بسبب عطل');
    app.server.on('/v1/customer/orders/$_orderId', [
      FakeAnswer(200, {'order': _order()}),
    ]);
    app.server.on('/v1/customer/orders/active', [
      const FakeAnswer(200, {'orders': <Object>[]}),
    ]);
    await app.pump(tester);
    app.container.read(routerProvider).go('/orders/$_orderId');
    await tester.pumpAndSettle();
    expect(find.text('قد يتأخر طلبك بسبب عطل'), findsOneWidget);
    expect(
      app.server.to('/v1/customer/emergency-stop').last.uri.queryParameters,
      {'latitude': '36.5862', 'longitude': '37.0463'},
    );

    app.emergencyStop();
    app.transport.send(
      'order:$_orderId',
      const RealtimePublication({
        'type': 'platform.emergency_stop',
        'active': false,
      }),
    );
    await tester.pumpAndSettle();
    expect(find.text('قد يتأخر طلبك بسبب عطل'), findsNothing);
    await app.done(tester);
  });
}
