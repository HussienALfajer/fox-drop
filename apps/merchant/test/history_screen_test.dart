import 'package:core_alerts/testing.dart';
import 'dart:convert';

import 'package:core_auth/testing.dart';
import 'package:core_push/testing.dart';
import 'package:core_realtime/core_realtime.dart';
import 'package:core_storage/core_storage.dart';
import 'package:core_time/core_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:merchant/src/api.dart';
import 'package:merchant/src/app.dart';
import 'package:merchant/src/auth.dart';
import 'package:merchant/src/board/alerts.dart';
import 'package:merchant/src/board/board_screen.dart';
import 'package:merchant/src/device.dart';
import 'package:merchant/src/push.dart';

import 'board_fixtures.dart';
import 'status_fixtures.dart' hide now;

const _accountId = '00000000-0000-4000-8000-000000000001';
const _restaurantId = '00000000-0000-4000-8000-000000000002';
const _channel = 'merchant:$_restaurantId';

final _now = placedAt.add(const Duration(minutes: 1));

// «السجل» (RA §8.18) against a fake server and channel.
class _App {
  _App({this.role = 'cashier'});

  final String role;
  final server = FakeServer();
  final transport = FakeTransport();
  final ringer = FakeRinger();
  late final ProviderContainer container;

  Future<void> pump(WidgetTester tester, List<FakeAnswer> statuses) async {
    server
      ..on('/v1/merchant/auth/session', [
        FakeAnswer(200, {
          'accountId': _accountId,
          'restaurantId': _restaurantId,
          'role': role,
          'name': 'ليلى',
          'deviceNamed': true,
          'sessionId': '00000000-0000-4000-8000-000000000003',
        }),
      ])
      ..on('/v1/merchant/orders', [FakeAnswer(200, boardJson([]))])
      ..on('/v1/merchant/restaurant/status', statuses)
      ..on('/v1/merchant/terms', [
        const FakeAnswer(200, {
          'version': 1,
          'body': 'شروط الشراكة',
          'publishedAt': '2026-11-08T09:00:00.000Z',
          'pending': false,
        }),
      ])
      ..on('/v1/merchant/emergency-stop', [
        const FakeAnswer(200, {'active': false, 'startedAt': null}),
      ])
      ..on('/v1/merchant/platform', [
        const FakeAnswer(200, {'updateNeed': 'none', 'maintenance': false}),
      ]);
    container = ProviderContainer(
      overrides: [
        authApiProvider.overrideWithValue(server.client()),
        coreApiProvider.overrideWith((ref) {
          final api = server.client();
          api.dio.interceptors.add(merchantAuth.interceptor(ref, api.dio));
          return api;
        }),
        merchantAuth.store.overrideWithValue(
          MemorySecureStore({
            'session': jsonEncode({
              'accessToken': 'access-0',
              'accessTokenExpiresAt': DateTime.now()
                  .add(const Duration(minutes: 10))
                  .toUtc()
                  .toIso8601String(),
              'refreshToken': 'refresh-0',
              'accountId': _accountId,
            }),
          }),
        ),
        appVersionProvider.overrideWith((ref) async => '0.1.0'),
        realtimeTransportProvider.overrideWithValue(transport),
        ringerProvider.overrideWithValue(ringer),
        alertsProvider.overrideWithValue(FakeAlerts()),
        keepScreenOnProvider.overrideWithValue((on) {}),
        notificationPermissionProvider.overrideWithValue(
          FakeNotificationPermission(allowed: true),
        ),
        deviceStoreProvider.overrideWithValue(MemoryDeviceStore()),
        serverClockProvider.overrideWithValue(
          ServerClock(deviceNow: () => _now),
        ),
      ],
      retry: (retryCount, error) => null,
    );
    await tester.binding.setSurfaceSize(const Size(400, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MerchantApp(),
      ),
    );
    await tester.pumpAndSettle();
    transport.send(_channel, const RealtimeUp(recovered: true));
    await tester.pumpAndSettle();
  }

  Future<void> done(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    container.dispose();
  }
}

const _orderId = '00000000-0000-4000-8000-0000000000a1';

Map<String, Object?> _row({Map<String, Object?>? owner}) => {
  'id': _orderId,
  'number': '10423',
  'placedAt': '2026-11-07T12:00:00.000Z',
  'day': '2026-11-07',
  'status': 'delivered',
  'testOrder': false,
  'redelivery': false,
  'itemCount': 3,
  'currency': 'TRY',
  'itemsValue': '36000',
  'owner': owner,
};

Map<String, Object?> _page(
  List<Map<String, Object?>> orders, {
  bool owner = false,
  String? next,
}) => {
  'owner': owner,
  'fromDay': '2026-10-31',
  'toDay': '2026-11-07',
  'orders': orders,
  'next': next,
};

const _ownerMoney = {
  'testOrder': false,
  'commissionBp': 1500,
  'commission': '5400',
  'discountShare': '0',
  'discountOnDelivery': false,
  'merchantNet': '30600',
};

List<Map<String, dynamic>> _sent(_App app) => app.server
    .to('/v1/merchant/orders/history')
    .map((r) => r.queryParameters)
    .toList();

Map<String, Object?> _status() =>
    statusJson(closesAt: _now.add(const Duration(hours: 10)));

Future<void> _open(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('open-history')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('a cashier sees the fixed range and no money but the items '
      'value, and opens an order with its timeline', (tester) async {
    final app = _App();
    app.server
      ..on('/v1/merchant/orders/history', [
        FakeAnswer(200, _page([_row()])),
      ])
      ..on('/v1/merchant/orders/$_orderId', [
        FakeAnswer(200, {
          'order': orderJson(
            id: _orderId,
            number: '10423',
            status: 'delivered',
          ),
          'timeline': [
            {'step': 'placed', 'at': '2026-11-07T12:00:00.000Z'},
            {'step': 'delivered', 'at': '2026-11-07T12:40:00.000Z'},
          ],
        }),
      ]);
    await app.pump(tester, [FakeAnswer(200, _status())]);
    await _open(tester);
    expect(find.text('اليوم وآخر 7 أيام'), findsOneWidget);
    expect(find.byKey(const Key('history-custom')), findsNothing);
    expect(find.text('من 31/10/2026 إلى 07/11/2026'), findsOneWidget);
    expect(find.text('3 أصناف · 360 ₺'), findsOneWidget);
    expect(find.textContaining('العمولة'), findsNothing);

    await tester.tap(find.byKey(const Key('history-order-$_orderId')));
    await tester.pumpAndSettle();
    expect(find.text('#10423'), findsOneWidget);
    expect(find.text('مراحل الطلب'), findsOneWidget);
    expect(find.text('وصل الطلب'), findsOneWidget);
    expect(find.byKey(const Key('history-commission')), findsNothing);
    await app.done(tester);
  });

  testWidgets('an owner sees the commission and the net, and filters by a '
      'preset and the number', (tester) async {
    final app = _App(role: 'owner');
    app.server.on('/v1/merchant/orders/history', [
      FakeAnswer(200, _page([_row(owner: _ownerMoney)], owner: true)),
    ]);
    await app.pump(tester, [FakeAnswer(200, _status())]);
    await _open(tester);
    expect(
      find.text('3 أصناف · 360 ₺\nالعمولة 54 ₺ · الصافي 306 ₺'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('history-30')));
    await tester.pumpAndSettle();
    expect(_sent(app).last, {'from': '2026-10-09', 'to': '2026-11-07'});

    await tester.enterText(find.byKey(const Key('history-number')), '10423');
    await tester.tap(find.byKey(const Key('history-search')));
    await tester.pumpAndSettle();
    expect(_sent(app).last, {
      'from': '2026-10-09',
      'to': '2026-11-07',
      'number': '10423',
    });

    await tester.tap(find.byKey(const Key('history-default')));
    await tester.pumpAndSettle();
    expect(_sent(app).last, {'number': '10423'});
    await app.done(tester);
  });

  // RA-23: the customer's delivery fee and total never reach the history or
  // an order's detail there. The guarantee is the server's read
  // (apps/server/src/modules/ordering/merchant-reads.test.ts); this checks
  // that the screen has no such line.
  testWidgets('the history and an order there show no delivery fee and no '
      'customer total', (tester) async {
    final app = _App(role: 'owner');
    app.server
      ..on('/v1/merchant/orders/history', [
        FakeAnswer(200, _page([_row(owner: _ownerMoney)], owner: true)),
      ])
      ..on('/v1/merchant/orders/$_orderId', [
        FakeAnswer(200, {
          'order': orderJson(
            id: _orderId,
            number: '10423',
            status: 'delivered',
          ),
          'timeline': [
            {'step': 'placed', 'at': '2026-11-07T12:00:00.000Z'},
          ],
        }),
      ]);
    await app.pump(tester, [FakeAnswer(200, _status())]);
    await _open(tester);
    void expectNone() {
      expect(find.textContaining('التوصيل'), findsNothing);
      expect(find.textContaining('الإجمالي'), findsNothing);
    }

    expect(find.textContaining('360 ₺'), findsOneWidget);
    expectNone();
    await tester.tap(find.byKey(const Key('history-order-$_orderId')));
    await tester.pumpAndSettle();
    expect(find.text('#10423'), findsOneWidget);
    expectNone();
    await app.done(tester);
  });

  testWidgets('reads the next page after the cursor', (tester) async {
    final app = _App(role: 'owner');
    app.server.on('/v1/merchant/orders/history', [
      FakeAnswer(200, _page([_row()], owner: true, next: 'cursor-1')),
      FakeAnswer(200, _page([], owner: true)),
    ]);
    await app.pump(tester, [FakeAnswer(200, _status())]);
    await _open(tester);
    await tester.ensureVisible(find.byKey(const Key('history-more')));
    await tester.tap(find.byKey(const Key('history-more')));
    await tester.pumpAndSettle();
    expect(_sent(app).last, {'cursor': 'cursor-1'});
    expect(find.byKey(const Key('history-more')), findsNothing);
    await app.done(tester);
  });
}
