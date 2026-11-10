import 'package:core_auth/testing.dart';
import 'package:core_realtime/core_realtime.dart';
import 'package:customer/src/cart/cart.dart';
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
  Map<String, Object?>? rejection,
  List<Map<String, Object?>>? lines,
  String? promisedAt,
  Map<String, Object?>? itemReport,
  List<Map<String, Object?>> removedLines = const [],
}) => {
  'id': _orderId,
  'number': '10423',
  'status': status,
  'version': version,
  'placedAt': '2026-11-07T12:00:00.000Z',
  'promisedAt': promisedAt,
  'cancellation': cancellation,
  'rejection': rejection,
  'delivery': null,
  'itemReport': itemReport,
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
  'lines':
      lines ??
      [
        {
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
  'removedLines': removedLines,
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
  Future<TestApp> open(
    WidgetTester tester,
    List<FakeAnswer> answers, {
    void Function(TestApp app)? before,
  }) async {
    final app = TestApp(signedIn: true);
    app.server.on('/v1/customer/orders/$_orderId', answers);
    before?.call(app);
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

  testWidgets('the item-unavailable banner and a moved time follow the '
      "order's events (CU §11.6)", (tester) async {
    final app = await open(tester, [
      FakeAnswer(200, {
        'order': _order(
          status: 'accepted',
          version: 2,
          promisedAt: '2026-11-07T12:45:00.000Z',
        ),
      }),
      FakeAnswer(200, {
        'order': _order(
          status: 'accepted',
          version: 3,
          promisedAt: '2026-11-07T12:45:00.000Z',
          itemReport: {'at': '2026-11-07T12:20:00.000Z'},
        ),
      }),
      FakeAnswer(200, {
        'order': _order(
          status: 'accepted',
          version: 4,
          promisedAt: '2026-11-07T13:00:00.000Z',
        ),
      }),
    ]);
    const banner =
        'المطعم أبلغ أن صنفاً في طلبك غير متوفر. سيتصل بك فريق '
        'FOX DROP الآن.';
    expect(find.text(banner), findsNothing);
    // The title's subtitle and the time line (CU §11.2).
    expect(find.text('يصل حوالي 3:45 م'), findsNWidgets(2));

    const channel = 'order:$_orderId';
    app.transport.send(channel, const RealtimeUp(recovered: true));
    app.transport.send(
      channel,
      const RealtimePublication({
        'type': 'order.item_reported',
        'orderId': _orderId,
        'version': 3,
      }),
    );
    await tester.pumpAndSettle();
    expect(find.text(banner), findsOneWidget);

    // Operations edited the time; the report closed meanwhile.
    app.transport.send(
      channel,
      const RealtimePublication({
        'type': 'order.time_changed',
        'orderId': _orderId,
        'version': 4,
        'reason': 'promised_time_changed',
      }),
    );
    await tester.pumpAndSettle();
    expect(find.text(banner), findsNothing);
    expect(find.text('يصل حوالي 3:45 م'), findsNothing);
    expect(find.text('يصل حوالي 4:00 م'), findsNWidgets(2));
    await app.done(tester);
  });

  testWidgets('an order the restaurant did not answer says so (CU §11.9)', (
    tester,
  ) async {
    final app = await open(
      tester,
      [
        FakeAnswer(200, {
          'order': _order(
            status: 'cancelled',
            version: 2,
            cancellation: {
              'at': '2026-11-07T12:07:00.000Z',
              'reason': 'merchant_auto_cancel',
              'text': 'لم يرد المطعم على طلبك',
              'byCustomer': false,
            },
          ),
        }),
      ],
      before: (app) => app.server.on('/v1/customer/restaurants', [
        FakeAnswer(200, {
          'restaurants': [card(nourId, 'مطعم النور')],
        }),
      ]),
    );
    expect(_status(tester), 'لم يرد المطعم على طلبك، نعتذر');
    expect(find.byKey(const Key('step-confirm')), findsNothing);
    // CU §11.9: with similar restaurants at its pin, and no rebuild.
    expect(find.byKey(const Key('similar-$nourId')), findsOneWidget);
    expect(
      app.server.to('/v1/customer/restaurants').single.uri.queryParameters,
      {'latitude': '36.5862', 'longitude': '37.0463', 'similarTo': shamId},
    );
    expect(find.byKey(const Key('order-without-unavailable')), findsNothing);
    await app.done(tester);
  });

  group('a rejected order (CU §11.9, Q22)', () {
    Map<String, Object?> line(
      String itemId,
      String name, {
      List<String> options = const [],
      String? note,
      int quantity = 1,
    }) => {
      'itemId': itemId,
      'name': name,
      'quantity': quantity,
      'note': note,
      'options': [
        for (final id in options) {'id': id, 'name': 'خيار', 'priceDelta': '0'},
      ],
      'unitPrice': '5000',
      'lineTotal': '5000',
      'added': false,
      'quantityBefore': null,
    };

    final rejected = _order(
      status: 'rejected',
      version: 2,
      rejection: {
        'at': '2026-11-07T12:03:00.000Z',
        'reason': 'item_unavailable',
        'text': 'بعض الأصناف غير متوفرة: فلافل',
        'unavailableItemIds': [falafelId],
      },
      lines: [
        line(
          shawarmaId,
          'شاورما دجاج',
          options: [largeId, cheeseId],
          note: 'بدون بصل',
          quantity: 2,
        ),
        line(falafelId, 'فلافل'),
        line(fulId, 'فول'),
      ],
    );

    void answers(TestApp app) {
      app.server.on('/v1/customer/restaurants', [
        FakeAnswer(200, {
          'restaurants': [card(nourId, 'مطعم النور')],
        }),
      ]);
      app.server.on('/v1/customer/restaurants/$shamId', [
        FakeAnswer(200, shamPage()),
      ]);
    }

    testWidgets('shows the reason and the similar restaurants at its pin', (
      tester,
    ) async {
      final app = await open(tester, [
        FakeAnswer(200, {'order': rejected}),
      ], before: answers);
      expect(
        _status(tester),
        'نعتذر، لم يقبل المطعم طلبك — بعض الأصناف غير متوفرة: فلافل',
      );
      expect(find.text('مطاعم مشابهة'), findsOneWidget);
      expect(find.byKey(const Key('similar-$nourId')), findsOneWidget);
      final asked = app.server.to('/v1/customer/restaurants').single;
      expect(asked.uri.queryParameters, {
        'latitude': '36.5862',
        'longitude': '37.0463',
        'similarTo': shamId,
      });
      await app.done(tester);
    });

    testWidgets(
      '«اطلب بدون الأصناف غير المتوفرة» rebuilds the cart at current prices',
      (tester) async {
        final app = await open(tester, [
          FakeAnswer(200, {'order': rejected}),
        ], before: answers);
        await tester.tap(find.byKey(const Key('order-without-unavailable')));
        await tester.pumpAndSettle();

        final cart = app.container.read(cartProvider).value!.cart!;
        expect(cart.restaurantId, shamId);
        // The falafel is left out; the breakfast item is out of its window
        // now, so it is skipped and named.
        expect(cart.lines, hasLength(1));
        final shawarma = cart.lines.single;
        expect(shawarma.optionIds, [largeId, cheeseId]);
        expect(shawarma.quantity, 2);
        expect(shawarma.note, 'بدون بصل');
        // 5000 + 1000 large + 500 cheese, from today's menu.
        expect(shawarma.unitPrice, '6500');
        expect(find.text('لم نضف: فول لأنها غير متوفرة'), findsOneWidget);
        expect(app.container.read(routerProvider).state.uri.path, '/cart');
        await app.done(tester);
      },
    );

    testWidgets('asks before it replaces a cart that is not empty', (
      tester,
    ) async {
      final app = await open(tester, [
        FakeAnswer(200, {'order': rejected}),
      ], before: answers);
      const kept = CartLine(
        itemId: falafelId,
        name: 'فلافل',
        optionIds: [],
        optionNames: [],
        quantity: 1,
        note: null,
        unitPrice: '3000',
        currency: 'TRY',
      );
      await app.container
          .read(cartProvider.notifier)
          .startNew(nourId, 'مطعم النور', kept);
      await tester.tap(find.byKey(const Key('order-without-unavailable')));
      await tester.pumpAndSettle();
      expect(
        find.text('ستُستبدل سلتك الحالية من مطعم النور. هل تتابع؟'),
        findsOneWidget,
      );
      await tester.tap(find.text('إلغاء'));
      await tester.pumpAndSettle();
      expect(
        app.container.read(cartProvider).value!.cart!.restaurantId,
        nourId,
      );

      await tester.tap(find.byKey(const Key('order-without-unavailable')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('متابعة'));
      await tester.pumpAndSettle();
      expect(
        app.container.read(cartProvider).value!.cart!.restaurantId,
        shamId,
      );
      await app.done(tester);
    });

    testWidgets('offers no rebuild for another reason', (tester) async {
      final app = await open(tester, [
        FakeAnswer(200, {
          'order': _order(
            status: 'rejected',
            version: 2,
            rejection: {
              'at': '2026-11-07T12:03:00.000Z',
              'reason': 'restaurant_closed',
              'text': 'المطعم مغلق حالياً',
              'unavailableItemIds': <String>[],
            },
          ),
        }),
      ], before: answers);
      expect(
        _status(tester),
        'نعتذر، لم يقبل المطعم طلبك — المطعم مغلق حالياً',
      );
      expect(find.byKey(const Key('order-without-unavailable')), findsNothing);
      expect(find.byKey(const Key('similar-$nourId')), findsOneWidget);
      await app.done(tester);
    });
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
            'byCustomer': false,
          },
        ),
      }),
    ]);
    // The customer-facing reason the order kept from Content (CU Appendix C).
    expect(_status(tester), 'أُلغي طلبك — لم نجد كابتناً متاحاً لطلبك');
    await app.done(tester);
  });

  group('«مساعدة» and «إلغاء الطلب» (CU §11.4–11.5)', () {
    void reasons(TestApp app) {
      app.server.on('/v1/customer/content', [
        const FakeAnswer(200, {
          'reasons': {
            'customer_cancel': [
              {'code': 'changed_mind', 'label': 'غيّرت رأيي', 'note': 'none'},
              {'code': 'other', 'label': 'سبب آخر', 'note': 'optional'},
            ],
            'customer_problem': <Object?>[],
            'order_note': <Object?>[],
            'restaurant_rating_low': <Object?>[],
            'restaurant_rating_mid': <Object?>[],
            'restaurant_rating_high': <Object?>[],
            'captain_rating_low': <Object?>[],
            'captain_rating_mid': <Object?>[],
            'captain_rating_high': <Object?>[],
          },
          'faq': <Object?>[],
        }),
      ]);
      app.server.on('/v1/customer/contact', [
        const FakeAnswer(200, {
          'phone': '+963944000000',
          'whatsapp': '+963944000001',
        }),
      ]);
    }

    const cancelPath = '/v1/customer/orders/$_orderId/cancel';

    Future<void> openCancel(WidgetTester tester) async {
      await tester.tap(find.byKey(const Key('order-help')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('help-cancel')));
      await tester.pumpAndSettle();
    }

    testWidgets(
      'cancels a placed order with a reason, then shows «ألغيت طلبك»',
      (tester) async {
        final app = await open(
          tester,
          [
            FakeAnswer(200, {'order': _order()}),
            FakeAnswer(200, {
              'order': _order(
                status: 'cancelled',
                version: 2,
                cancellation: {
                  'at': '2026-11-07T12:02:00.000Z',
                  'reason': 'other',
                  'text': 'نعتذر، لم نتمكن من إكمال طلبك',
                  'byCustomer': true,
                },
              ),
            }),
          ],
          before: (app) {
            reasons(app);
            app.server.on(cancelPath, [
              FakeAnswer(200, {
                'order': _order(
                  status: 'cancelled',
                  version: 2,
                  cancellation: {
                    'at': '2026-11-07T12:02:00.000Z',
                    'reason': 'other',
                    'text': 'نعتذر، لم نتمكن من إكمال طلبك',
                    'byCustomer': true,
                  },
                ),
              }),
            ]);
          },
        );
        await openCancel(tester);
        final confirm = find.byKey(const Key('cancel-confirm'));
        expect(tester.widget<FilledButton>(confirm).onPressed, isNull);
        await tester.tap(find.byKey(const Key('cancel-reason-other')));
        await tester.pumpAndSettle();
        // «سبب آخر» takes an optional text.
        await tester.enterText(find.byKey(const Key('cancel-note')), 'تأخرت');
        await tester.tap(confirm);
        await tester.pumpAndSettle();

        final sent = app.server.to(cancelPath).single;
        expect(sent.data, {'reason': 'other', 'note': 'تأخرت'});
        expect(sent.headers['Idempotency-Key'], isNotEmpty);
        expect(_status(tester), 'ألغيت طلبك');
        expect(find.byKey(const Key('order-help')), findsNothing);
        await app.done(tester);
      },
    );

    testWidgets(
      '«إلغاء الطلب» is on the screen while placed, and a failed read of the reasons offers a retry',
      (tester) async {
        final app = await open(
          tester,
          [
            FakeAnswer(200, {'order': _order()}),
          ],
          before: (app) => app.server.on('/v1/customer/content', [
            const FakeAnswer(500, {'statusCode': 500}),
          ]),
        );
        await tester.tap(find.byKey(const Key('order-cancel')));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('cancel-reasons-retry')), findsOneWidget);
        reasons(app);
        await tester.tap(find.byKey(const Key('cancel-reasons-retry')));
        await tester.pumpAndSettle();
        expect(
          find.byKey(const Key('cancel-reason-changed_mind')),
          findsOneWidget,
        );
        await app.done(tester);
      },
    );

    testWidgets('the race with acceptance shows its message', (tester) async {
      final accepted = _order(status: 'accepted', version: 2);
      final app = await open(
        tester,
        [
          FakeAnswer(200, {'order': _order()}),
          FakeAnswer(200, {'order': accepted}),
        ],
        before: (app) {
          reasons(app);
          app.server.on(cancelPath, [
            FakeAnswer(409, {
              'statusCode': 409,
              'error': 'order_state_changed',
              'order': accepted,
            }),
          ]);
        },
      );
      await openCancel(tester);
      await tester.tap(find.byKey(const Key('cancel-reason-changed_mind')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('cancel-confirm')));
      await tester.pumpAndSettle();
      expect(
        find.text('قبل المطعم طلبك قبل لحظات. لإلغائه تواصل مع الدعم.'),
        findsOneWidget,
      );
      expect(_status(tester), startsWith('المطعم يحضّر طلبك'));
      await app.done(tester);
    });

    testWidgets(
      'after acceptance «مساعدة» explains and warns, and opens support with the order',
      (tester) async {
        final app = await open(tester, [
          FakeAnswer(200, {'order': _order(status: 'accepted', version: 2)}),
        ], before: reasons);
        expect(find.byKey(const Key('order-cancel')), findsNothing);
        await tester.tap(find.byKey(const Key('order-help')));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('help-cancel')), findsNothing);
        expect(find.text('لإلغاء الطلب تواصل مع الدعم'), findsOneWidget);
        expect(
          find.text(
            'الإلغاء بعد قبول المطعم يُحتسب عليك، وتكراره قد يوقف حسابك مؤقتاً.',
          ),
          findsOneWidget,
        );
        await tester.tap(find.byKey(const Key('help-call')));
        await tester.tap(find.byKey(const Key('help-whatsapp')));
        expect(app.launched.first.toString(), 'tel:+963944000000');
        expect(
          app.launched.last.toString(),
          Uri.https('wa.me', '/963944000001', {
            'text': 'بخصوص الطلب #10423',
          }).toString(),
        );
        await app.done(tester);
      },
    );
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

  testWidgets(
    "an edit by FOX DROP shows the new total, «أُضيف», the quantity change "
    'and «حُذف» (CU §11.6)',
    (tester) async {
      final app = await open(tester, [
        FakeAnswer(200, {
          'order': _order(
            status: 'accepted',
            version: 3,
            promisedAt: '2026-11-07T12:45:00.000Z',
            lines: [
              {
                'itemId': shawarmaId,
                'name': 'شاورما دجاج',
                'quantity': 3,
                'note': null,
                'options': <Object>[],
                'unitPrice': '6500',
                'lineTotal': '19500',
                'added': false,
                'quantityBefore': 2,
              },
              {
                'itemId': shawarmaId,
                'name': 'بطاطا',
                'quantity': 1,
                'note': null,
                'options': <Object>[],
                'unitPrice': '3000',
                'lineTotal': '3000',
                'added': true,
                'quantityBefore': null,
              },
            ],
            removedLines: [
              {'name': 'كولا', 'quantity': 1, 'options': <Object>[]},
            ],
          ),
        }),
      ]);
      expect(
        find.text('عدّلت FOX DROP طلبك. المجموع الجديد: 140 ₺'),
        findsOneWidget,
      );
      expect(find.textContaining('شاورما دجاج: 2 ← 3'), findsOneWidget);
      expect(find.text('أُضيف'), findsOneWidget);
      expect(find.text('1 × كولا'), findsOneWidget);
      expect(find.text('حُذف'), findsOneWidget);
      await app.done(tester);
    },
  );
}
