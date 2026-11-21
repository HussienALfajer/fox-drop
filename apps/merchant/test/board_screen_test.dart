import 'package:core_commands/core_commands.dart';
import 'package:core_alerts/core_alerts.dart';
import 'package:core_alerts/testing.dart';
import 'dart:convert';

import 'package:core_auth/testing.dart';
import 'package:core_push/testing.dart';
import 'package:core_realtime/core_realtime.dart';
import 'package:core_storage/core_storage.dart';
import 'package:core_time/core_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:merchant/src/account/records.dart';
import 'package:merchant/src/api.dart';
import 'package:merchant/src/app.dart';
import 'package:merchant/src/auth.dart';
import 'package:merchant/src/board/alerts.dart';
import 'package:merchant/src/board/board_screen.dart';
import 'package:merchant/src/board/commands.dart';
import 'package:merchant/src/device.dart';
import 'package:merchant/src/push.dart';
import 'package:merchant/src/router.dart';

import 'board_fixtures.dart';

const _accountId = '00000000-0000-4000-8000-000000000001';
const _restaurantId = '00000000-0000-4000-8000-000000000002';
const _channel = 'merchant:$_restaurantId';
const _orderId = '00000000-0000-4000-8000-0000000000a1';
const _statementId = '00000000-0000-4000-8000-0000000000b1';
const _receiptId = '00000000-0000-4000-8000-0000000000c1';

Map<String, Object?> _accountJson() => {
  'currency': 'TRY',
  'balance': '7700',
  'settlementDate': '2026-11-14',
  'commissionBp': 1500,
  'nextCommission': null,
  'todayFrom': '2026-11-07T03:00:00.000Z',
  'pickups': <Object>[],
  'weekFrom': '2026-11-14T03:00:00.000Z',
  'weekLines': <Object>[],
};

Map<String, Object?> _statementLine(String kind, Map<String, Object?> fields) =>
    {
      'kind': kind,
      'at': '2026-11-10T09:00:00.000Z',
      'orderId': null,
      'orderNumber': null,
      'itemsValue': null,
      'pickupLines': null,
      'commission': null,
      'discountShare': null,
      'cause': null,
      'amount': null,
      'reason': null,
      'decidedBy': null,
      'decidedByName': null,
      ...fields,
    };

Map<String, Object?> _statementJson() => {
  'id': _statementId,
  'restaurantName': 'مطعم الاختبار',
  'cutoff': '2026-11-14T03:00:00.000Z',
  'periodFrom': '2026-11-07T03:00:00.000Z',
  'currency': 'TRY',
  'orders': 1,
  'itemsValue': '40000',
  'commission': '5700',
  'discountShare': '2000',
  'exceptions': '-500',
  'weekTotal': '7200',
  'previousDue': '1000',
  'paid': '500',
  'earlierUnpaid': '500',
  'totalDue': '7700',
  'status': 'partly_paid',
  'unpaid': '5000',
  'lines': [
    _statementLine('order', {
      'orderId': _orderId,
      'orderNumber': '10001',
      'itemsValue': '40000',
      'pickupLines': [
        {'currency': 'TRY', 'amount': '30000'},
        {'currency': 'USD', 'amount': '250'},
      ],
      'commission': '5700',
      'discountShare': '2000',
    }),
    _statementLine('exception', {
      'orderNumber': '10000',
      'cause': 'adjustment',
      'amount': '1000',
      'reason': 'فرق جرد',
      'decidedBy': 'admin',
      'decidedByName': 'سارة',
    }),
    _statementLine('exception', {
      'orderNumber': '9999',
      'cause': 'food_credit',
      'amount': '-1500',
      'reason': 'تعويض عن طلب أُلغي بعد التحضير',
      'decidedBy': 'system',
    }),
    _statementLine('payment', {'amount': '-500'}),
  ],
};

// The board on a phone (RA §4.3–4.7, §8.2–8.10), signed in, against a fake
// server and a fake real-time channel.
class _Board {
  _Board({this.role = 'cashier'});

  final String role;
  final server = FakeServer();
  final transport = FakeTransport();
  final ringer = FakeRinger();
  final alerts = FakeAlerts();
  late final ProviderContainer container;

  Future<void> pump(
    WidgetTester tester,
    List<FakeAnswer> boards, {
    List<Override> overrides = const [],
    ServerClock? clock,
  }) async {
    server.on('/v1/merchant/auth/session', [
      FakeAnswer(200, {
        'accountId': _accountId,
        'restaurantId': _restaurantId,
        'role': role,
        'name': 'ليلى',
        'deviceNamed': true,
        'sessionId': '00000000-0000-4000-8000-000000000003',
      }),
    ]);
    server.on('/v1/merchant/orders', boards);
    if (!server.routes.containsKey('/v1/merchant/terms')) {
      server.on('/v1/merchant/terms', [
        const FakeAnswer(200, {
          'version': 1,
          'body': 'شروط الشراكة',
          'publishedAt': '2026-11-08T09:00:00.000Z',
          'pending': false,
        }),
      ]);
    }
    if (!server.routes.containsKey('/v1/merchant/emergency-stop')) {
      server.on('/v1/merchant/emergency-stop', [
        const FakeAnswer(200, {'active': false, 'startedAt': null}),
      ]);
    }
    if (!server.routes.containsKey('/v1/merchant/platform')) {
      server.on('/v1/merchant/platform', [
        const FakeAnswer(200, {'updateNeed': 'none', 'maintenance': false}),
      ]);
    }
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
        alertsProvider.overrideWithValue(alerts),
        keepScreenOnProvider.overrideWithValue((on) {}),
        notificationPermissionProvider.overrideWithValue(
          FakeNotificationPermission(allowed: true),
        ),
        deviceStoreProvider.overrideWithValue(MemoryDeviceStore()),
        // A minute after the fixtures' order was placed.
        serverClockProvider.overrideWithValue(
          clock ??
              ServerClock(
                deviceNow: () => placedAt.add(const Duration(minutes: 1)),
              ),
        ),
        ...overrides,
      ],
      retry: (retryCount, error) => null,
    );
    container.read(boardCommandsProvider.notifier).backoff = (_) =>
        Duration.zero;
    await tester.binding.setSurfaceSize(const Size(400, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MerchantApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Ends the board inside the test, so its timers stop before the test's
  /// check for pending timers.
  Future<void> done(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    container.dispose();
  }

  Future<void> up(WidgetTester tester) async {
    transport.send(_channel, const RealtimeUp(recovered: true));
    await tester.pumpAndSettle();
  }
}

void main() {
  testWidgets('a new order rings with its prompt; «قبول» stops the ring', (
    tester,
  ) async {
    final app = _Board();
    final accepted = orderJson(
      status: 'accepted',
      version: 2,
      acceptedAfter: const Duration(minutes: 1),
    );
    await app.pump(tester, [
      FakeAnswer(200, boardJson([orderJson()])),
      FakeAnswer(200, boardJson([accepted])),
    ]);
    await app.up(tester);

    expect(find.text('طلب جديد #10001'), findsOneWidget);
    expect(find.text('يُلغى تلقائياً خلال 6:00'), findsWidgets);
    expect(app.ringer.ringing, isTrue);
    // RA §4.4 (slice 2.42): the new order's bundled sound, and its prompt's
    // text over the lock screen; the service receives while signed in.
    expect(app.ringer.sound, RingSound.newOrder);
    expect(app.ringer.text, 'طلب جديد #10001');
    expect(app.alerts.receiving, isTrue);
    // RA §8.5: the default prep time, then «+» by the step.
    expect(find.text('قبول — 20 د'), findsWidgets);
    await tester.tap(find.byKey(const Key('prep-plus')));
    await tester.pump();
    app.server.on('/v1/merchant/orders/$_orderId/accept', [
      FakeAnswer(200, {'order': accepted}),
    ]);
    await tester.tap(find.byKey(const Key('accept')));
    await tester.pumpAndSettle();

    final sent = app.server.to('/v1/merchant/orders/$_orderId/accept').single;
    expect(sent.data, {'prepMin': 25});
    expect(sent.headers['Idempotency-Key'], isNotEmpty);
    expect(find.byKey(const Key('ringing-prompt')), findsNothing);
    expect(app.ringer.ringing, isFalse);
    expect(find.text('قيد التحضير (1)'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('another device accepting first is explained (RA §4.7)', (
    tester,
  ) async {
    final app = _Board();
    final accepted = orderJson(
      status: 'accepted',
      version: 2,
      acceptedAfter: Duration.zero,
    );
    await app.pump(tester, [
      FakeAnswer(200, boardJson([orderJson()])),
      FakeAnswer(200, boardJson([accepted])),
    ]);
    await app.up(tester);
    app.server.on('/v1/merchant/orders/$_orderId/accept', [
      FakeAnswer(409, {'error': 'order_state_changed', 'order': accepted}),
    ]);
    await tester.tap(find.byKey(const Key('accept')));
    await tester.pumpAndSettle();

    expect(find.text('قُبل الطلب من جهاز كاشير 1'), findsOneWidget);
    expect(app.ringer.ringing, isFalse);
    await app.done(tester);
  });

  testWidgets('a lost answer is sent again with the same key', (tester) async {
    final app = _Board();
    final accepted = orderJson(
      status: 'accepted',
      version: 2,
      acceptedAfter: Duration.zero,
    );
    await app.pump(tester, [
      FakeAnswer(200, boardJson([orderJson()])),
      FakeAnswer(200, boardJson([accepted])),
    ]);
    await app.up(tester);
    app.server.on('/v1/merchant/orders/$_orderId/accept', [
      const FakeAnswer.none(),
      FakeAnswer(200, {'order': accepted}),
    ]);
    await tester.tap(find.byKey(const Key('accept')));
    await tester.pumpAndSettle();

    final sent = app.server.to('/v1/merchant/orders/$_orderId/accept');
    expect(sent, hasLength(2));
    expect(
      sent.last.headers['Idempotency-Key'],
      sent.first.headers['Idempotency-Key'],
    );
    await app.done(tester);
  });

  testWidgets('a new event fetches the board; the offline bar while down', (
    tester,
  ) async {
    final app = _Board();
    await app.pump(tester, [
      FakeAnswer(200, boardJson([])),
      FakeAnswer(200, boardJson([orderJson()])),
    ]);
    expect(
      find.text(
        'لا يوجد اتصال بالإنترنت — لن تصلك الطلبات الجديدة حتى يعود الاتصال',
      ),
      findsOneWidget,
    );
    await app.up(tester);
    expect(find.byKey(const Key('offline')), findsNothing);
    expect(app.ringer.ringing, isFalse);

    app.transport.send(
      _channel,
      const RealtimePublication({
        'type': 'order.placed',
        'orderId': _orderId,
        'number': '10001',
        'version': 1,
      }),
    );
    await tester.pumpAndSettle();
    expect(app.server.to('/v1/merchant/orders'), hasLength(2));
    expect(app.ringer.ringing, isTrue);
    await app.done(tester);
  });

  testWidgets('the pickup prompt confirms, or disputes with the lines', (
    tester,
  ) async {
    final app = _Board();
    final waiting = orderJson(
      status: 'ready',
      captainTrack: 'pickup_pending',
      captainName: 'سامر',
      arrivedAt: placedAt,
      request: requestJson(),
    );
    await app.pump(tester, [
      FakeAnswer(200, boardJson([waiting])),
    ]);
    await app.up(tester);

    expect(
      find.text('الكابتن سامر يؤكد أنه دفع لك 240 ₺ واستلم الطلب #10001'),
      findsOneWidget,
    );
    expect(app.ringer.ringing, isTrue);
    app.server.on('/v1/merchant/orders/$_orderId/pickup/dispute', [
      FakeAnswer(200, {'order': waiting}),
    ]);
    await tester.tap(find.byKey(const Key('amount-incorrect')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('dispute-0')), '200');
    await tester.tap(find.byKey(const Key('dispute-send')));
    await tester.pumpAndSettle();

    final sent = app.server
        .to('/v1/merchant/orders/$_orderId/pickup/dispute')
        .single;
    expect(sent.data, {
      'receivedLines': [
        {'amount': '20000', 'currency': 'TRY'},
      ],
    });
    await app.done(tester);
  });

  testWidgets('an automatic cancellation closes the prompt with its chime', (
    tester,
  ) async {
    final app = _Board();
    await app.pump(tester, [
      FakeAnswer(200, boardJson([orderJson()])),
      FakeAnswer(200, boardJson([])),
    ]);
    await app.up(tester);
    expect(app.ringer.ringing, isTrue);
    app.transport.send(
      _channel,
      const RealtimePublication({
        'type': 'order.cancelled',
        'orderId': _orderId,
        'number': '10001',
        'version': 2,
        'reason': 'merchant_auto_cancel',
      }),
    );
    await tester.pumpAndSettle();
    expect(app.ringer.ringing, isFalse);
    expect(app.ringer.chimes, greaterThan(0));
    expect(find.text('أُلغي الطلب #10001 لعدم الرد'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets("operations' cancellation after acceptance rings until "
      '«حسناً» (RA §8.14, §18)', (tester) async {
    final app = _Board();
    final cancelled = orderJson(
      status: 'cancelled',
      version: 3,
      acceptedAfter: Duration.zero,
      cancellation: cancellationJson(),
    );
    final acknowledged = {...cancelled, 'version': 4, 'cancellation': null};
    await app.pump(tester, [
      FakeAnswer(200, boardJson([cancelled])),
      FakeAnswer(200, boardJson([])),
    ]);
    await app.up(tester);

    expect(
      find.text('أوقف التحضير — أُلغي الطلب #10001: تعذر الوصول إلى الزبون'),
      findsOneWidget,
    );
    expect(app.ringer.ringing, isTrue);
    app.server.on('/v1/merchant/orders/$_orderId/acknowledge-cancellation', [
      FakeAnswer(200, {'order': acknowledged}),
    ]);
    await tester.tap(find.byKey(const Key('acknowledge-cancellation')));
    await tester.pumpAndSettle();

    final sent = app.server
        .to('/v1/merchant/orders/$_orderId/acknowledge-cancellation')
        .single;
    expect(sent.headers['Idempotency-Key'], isNotEmpty);
    expect(find.byKey(const Key('ringing-prompt')), findsNothing);
    expect(app.ringer.ringing, isFalse);
    await app.done(tester);
  });

  testWidgets('an edit that added items rings until «اطلعت على التعديل», '
      'listing its changes (RA §8.13, §16 #16)', (tester) async {
    final app = _Board();
    final edited = orderJson(
      status: 'accepted',
      version: 4,
      acceptedAfter: Duration.zero,
      edits: [editJson(extraPrepMin: 10)],
    );
    final acknowledged = {...edited, 'version': 5, 'edits': <Object?>[]};
    await app.pump(tester, [
      FakeAnswer(200, boardJson([edited])),
      FakeAnswer(200, boardJson([acknowledged])),
    ]);
    await app.up(tester);

    expect(find.text('تم تعديل الطلب #10001 — أُضيفت أصناف'), findsOneWidget);
    expect(find.text('شاورما: 2 ← 3'), findsOneWidget);
    expect(find.text('أُضيف: 1 × بطاطا'), findsOneWidget);
    expect(
      find.text('عاد الطلب إلى «قيد التحضير»: 10 د إضافية'),
      findsOneWidget,
    );
    expect(find.text('قيمة الأصناف الجديدة: 433 ₺'), findsOneWidget);
    expect(app.ringer.ringing, isTrue);
    app.server.on('/v1/merchant/orders/$_orderId/acknowledge-edit', [
      FakeAnswer(200, {'order': acknowledged}),
    ]);
    await tester.tap(find.byKey(const Key('acknowledge-edit')));
    await tester.pumpAndSettle();

    final sent = app.server
        .to('/v1/merchant/orders/$_orderId/acknowledge-edit')
        .single;
    expect(sent.headers['Idempotency-Key'], isNotEmpty);
    // The edits the prompt showed, through the newest one.
    expect(sent.data, {'through': editJson()['at']});
    expect(find.byKey(const Key('ringing-prompt')), findsNothing);
    expect(app.ringer.ringing, isFalse);
    await app.done(tester);
  });

  testWidgets("«حسناً» on another device stops this one's ring", (
    tester,
  ) async {
    final app = _Board();
    await app.pump(tester, [
      FakeAnswer(
        200,
        boardJson([
          orderJson(
            status: 'cancelled',
            version: 3,
            acceptedAfter: Duration.zero,
            cancellation: cancellationJson(),
          ),
        ]),
      ),
      FakeAnswer(200, boardJson([])),
    ]);
    await app.up(tester);
    expect(app.ringer.ringing, isTrue);
    final chimes = app.ringer.chimes;
    app.transport.send(
      _channel,
      const RealtimePublication({
        'type': 'order.cancellation_acknowledged',
        'orderId': _orderId,
        'number': '10001',
        'version': 4,
        'reason': null,
        'byOperations': false,
        'byCustomer': false,
      }),
    );
    await tester.pumpAndSettle();
    expect(app.ringer.ringing, isFalse);
    expect(app.ringer.chimes, chimes);
    expect(find.byKey(const Key('ringing-prompt')), findsNothing);
    await app.done(tester);
  });

  testWidgets('a ringing order past its deadline fetches the board again', (
    tester,
  ) async {
    final app = _Board();
    // Placed 10 minutes ago: its automatic cancellation is past, and the
    // event that ends it never came.
    final stale = orderJson(
      placed: placedAt.subtract(const Duration(minutes: 9)),
    );
    await app.pump(tester, [
      FakeAnswer(200, boardJson([stale])),
      FakeAnswer(200, boardJson([])),
    ]);
    await app.up(tester);
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(app.server.to('/v1/merchant/orders'), hasLength(2));
    expect(app.ringer.ringing, isFalse);
    await app.done(tester);
  });

  testWidgets('the detail shows the ringing prompt and the offline bar', (
    tester,
  ) async {
    final app = _Board();
    await app.pump(tester, [
      FakeAnswer(200, boardJson([orderJson()])),
    ]);
    app.container.read(routerProvider).push('/orders/$_orderId');
    await tester.pumpAndSettle();
    expect(find.text('#10001'), findsWidgets);
    expect(find.byKey(const Key('ringing-prompt')), findsWidgets);
    expect(find.byKey(const Key('offline')), findsWidgets);
    await app.done(tester);
  });

  // RA §8.4, R10 (slice 2.19d): an owner's detail shows the commission and
  // the net, a test order «طلب تجريبي — لا عمولة»; a cashier neither.
  testWidgets('the detail shows the owners their money lines', (tester) async {
    final app = _Board(role: 'owner');
    await app.pump(tester, [
      FakeAnswer(
        200,
        boardJson([
          orderJson(
            owner: {
              'testOrder': false,
              'commissionBp': 1500,
              'commission': '3600',
              'discountShare': '0',
              'discountOnDelivery': false,
              'merchantNet': '20400',
            },
          ),
        ]),
      ),
    ]);
    app.container.read(routerProvider).push('/orders/$_orderId');
    await tester.pumpAndSettle();
    expect(find.text('العمولة 15% — تُسدَّد يوم السبت: 36 ₺'), findsOneWidget);
    expect(find.text('صافيك من الطلب: 204 ₺'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('a test order shows «لا عمولة» to the owners', (tester) async {
    final app = _Board(role: 'owner');
    await app.pump(tester, [
      FakeAnswer(
        200,
        boardJson([
          orderJson(
            owner: {
              'testOrder': true,
              'commissionBp': null,
              'commission': null,
              'discountShare': null,
              'discountOnDelivery': false,
              'merchantNet': null,
            },
          ),
        ]),
      ),
    ]);
    app.container.read(routerProvider).push('/orders/$_orderId');
    await tester.pumpAndSettle();
    expect(find.text('طلب تجريبي — لا عمولة'), findsOneWidget);
    expect(find.byKey(const Key('owner-commission')), findsNothing);
    await app.done(tester);
  });

  // RA §8.16 (slice 2.30b): every user sees «طلب تجريبي» on the card and
  // the detail; a cashier has no money lines.
  testWidgets('a test order shows «طلب تجريبي» to a cashier', (tester) async {
    final app = _Board();
    await app.pump(tester, [
      FakeAnswer(
        200,
        boardJson([
          orderJson(
            status: 'accepted',
            acceptedAfter: const Duration(minutes: 1),
            testOrder: true,
          ),
        ]),
      ),
    ]);
    await tester.tap(find.byKey(const Key('tab-preparing')));
    await tester.pumpAndSettle();
    expect(find.textContaining('طلب تجريبي'), findsOneWidget);
    app.container.read(routerProvider).push('/orders/$_orderId');
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('test-order')), findsOneWidget);
    expect(find.text('طلب تجريبي — لا عمولة'), findsNothing);
    await app.done(tester);
  });

  // RA §6.3 item 7, §12.2, §12.6 (slice 2.19f): the owners' amber banner
  // and the red line on «الحساب».
  testWidgets(
    'an owner with an overdue statement sees the banner and the line',
    (tester) async {
      final app = _Board(role: 'owner');
      app.server.on('/v1/merchant/account/overdue', [
        const FakeAnswer(200, {
          'overdue': {
            'currency': 'TRY',
            'amount': '5000',
            'statementDate': '2026-11-07',
          },
        }),
      ]);
      app.server.on('/v1/merchant/account', [
        FakeAnswer(200, {
          ..._accountJson(),
          'overdue': {'amount': '5000', 'statementDate': '2026-11-07'},
        }),
      ]);
      await app.pump(tester, [FakeAnswer(200, boardJson([]))]);
      expect(
        find.text('لديك مبلغ متأخر: 50 ₺. يرجى التسوية في أقرب وقت.'),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const Key('open-account')));
      await tester.pumpAndSettle();
      expect(find.text('متأخر: 50 ₺ من كشف 07/11/2026'), findsOneWidget);
      await app.done(tester);
    },
  );

  testWidgets('nothing overdue shows no banner and no line', (tester) async {
    final app = _Board(role: 'owner');
    app.server.on('/v1/merchant/account/overdue', [
      const FakeAnswer(200, {'overdue': null}),
    ]);
    app.server.on('/v1/merchant/account', [FakeAnswer(200, _accountJson())]);
    await app.pump(tester, [FakeAnswer(200, boardJson([]))]);
    expect(find.byKey(const Key('overdue-banner')), findsNothing);
    await tester.tap(find.byKey(const Key('open-account')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('account-overdue')), findsNothing);
    await app.done(tester);
  });

  testWidgets('a cashier sees no money lines and no «الحساب»', (tester) async {
    final app = _Board();
    await app.pump(tester, [
      FakeAnswer(200, boardJson([orderJson()])),
    ]);
    expect(find.byKey(const Key('open-account')), findsNothing);
    // RA §6.3 item 7: the banner is the owners'; a cashier never reads it.
    expect(find.byKey(const Key('overdue-banner')), findsNothing);
    expect(
      app.server.requests.where(
        (request) => request.uri.path == '/v1/merchant/account/overdue',
      ),
      isEmpty,
    );
    app.container.read(routerProvider).push('/orders/$_orderId');
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('owner-commission')), findsNothing);
    expect(find.byKey(const Key('owner-net')), findsNothing);
    await app.done(tester);
  });

  // RA §12.2, §12.5 (slice 2.19d): «الحساب» from the owners' button.
  testWidgets('an owner opens «الحساب»: balance, today and the week', (
    tester,
  ) async {
    final app = _Board(role: 'owner');
    app.server.on('/v1/merchant/account', [
      const FakeAnswer(200, {
        'currency': 'TRY',
        'balance': '7700',
        'settlementDate': '2026-11-14',
        'commissionBp': 1500,
        'nextCommission': {'rateBp': 1250, 'from': '2026-12-01T03:00:00.000Z'},
        'todayFrom': '2026-11-07T03:00:00.000Z',
        'pickups': [
          {
            'orderId': _orderId,
            'orderNumber': '10001',
            'at': '2026-11-07T12:20:00.000Z',
            'captainName': 'سامر',
            'amount': '40000',
            'lines': [
              {'currency': 'TRY', 'amount': '40000'},
            ],
          },
        ],
        'weekFrom': '2026-10-31T03:00:00.000Z',
        'weekLines': [
          {
            'day': '2026-11-07',
            'kind': 'order',
            'at': '2026-11-07T12:40:00.000Z',
            'orderId': _orderId,
            'orderNumber': '10001',
            'itemsValue': '40000',
            'commission': '5700',
            'discountShare': '2000',
            'cause': null,
            'amount': null,
            'reason': null,
          },
          {
            'day': '2026-11-06',
            'kind': 'exception',
            'at': '2026-11-06T10:00:00.000Z',
            'orderId': null,
            'orderNumber': '10000',
            'itemsValue': null,
            'commission': null,
            'discountShare': null,
            'cause': 'food_credit',
            'amount': '-1500',
            'reason': 'تعويض عن طلب أُلغي بعد التحضير',
            'decidedBy': 'admin',
            'decidedByName': 'سارة',
          },
        ],
      }),
    ]);
    await app.pump(tester, [FakeAnswer(200, boardJson([]))]);
    await tester.tap(find.byKey(const Key('open-account')));
    await tester.pumpAndSettle();
    expect(find.text('المستحق عليك حتى الآن: 77 ₺'), findsOneWidget);
    expect(find.text('موعد التسوية: السبت 14/11/2026'), findsOneWidget);
    expect(find.text('عمولتك الحالية: 15%'), findsOneWidget);
    expect(
      find.text('تتغيّر عمولتك إلى 12.5% اعتباراً من 01/12/2026'),
      findsOneWidget,
    );
    expect(find.text('قبضت اليوم من الكباتن: 400 ₺ (1 طلباً)'), findsOneWidget);
    expect(find.text('#10001 · 3:20 م · سامر'), findsOneWidget);
    expect(find.text('#10001: العمولة 57 ₺'), findsOneWidget);
    expect(find.text('خصم يموّله المطعم: 20 ₺'), findsOneWidget);
    expect(find.text('تعويض عن طلب أُلغي بعد التحضير: 15 ₺'), findsOneWidget);
    expect(
      find.text('الطلب #10000 · يُنقص المستحق عليك · من قرّر: سارة'),
      findsOneWidget,
    );
    await app.done(tester);
  });

  // RA §12.3–12.5 (slice 2.19e): «الكشوف» from «الحساب», the statement with
  // «من قرّر» and «مشاركة كصورة».
  testWidgets('an owner opens a statement from «الكشوف» and shares it', (
    tester,
  ) async {
    final app = _Board(role: 'owner');
    final shared = <String, List<int>>{};
    app.server.on('/v1/merchant/account', [FakeAnswer(200, _accountJson())]);
    app.server.on('/v1/merchant/statements', [
      const FakeAnswer(200, {
        'statements': [
          {
            'id': _statementId,
            'cutoff': '2026-11-14T03:00:00.000Z',
            'periodFrom': '2026-11-07T03:00:00.000Z',
            'currency': 'TRY',
            'weekTotal': '7200',
            'totalDue': '7700',
            'status': 'partly_paid',
            'unpaid': '5000',
          },
        ],
      }),
    ]);
    app.server.on('/v1/merchant/statements/$_statementId', [
      FakeAnswer(200, _statementJson()),
    ]);
    await app.pump(
      tester,
      [FakeAnswer(200, boardJson([]))],
      overrides: [
        imageSharerProvider.overrideWithValue(
          (png, name) async => shared[name] = png,
        ),
      ],
    );
    await tester.tap(find.byKey(const Key('open-account')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('account-statements')));
    await tester.pumpAndSettle();
    expect(find.text('كشف 14/11/2026: المستحق 77 ₺'), findsOneWidget);
    expect(find.text('مسدّد جزئياً'), findsOneWidget);

    await tester.tap(find.text('كشف 14/11/2026: المستحق 77 ₺'));
    await tester.pumpAndSettle();
    for (final line in [
      'مطعم الاختبار',
      'من 07/11/2026 6:00 ص إلى 14/11/2026 6:00 ص',
      'الطلبات: 1',
      '#10001: العمولة 57 ₺',
      'قيمة الأصناف 400 ₺ (300 ₺ + 2.50 \$)',
      'تسوية يدوية: فرق جرد: 10 ₺',
      'الطلب #10000 · يزيد المستحق عليك · من قرّر: سارة',
      'تعويض عن طلب أُلغي بعد التحضير: 15 ₺',
      'الطلب #9999 · يُنقص المستحق عليك · من قرّر: تلقائياً',
      'دفعة مسدّدة: 5 ₺',
      'مستحق هذا الأسبوع: 72 ₺',
      'الرصيد السابق غير المسدّد: 5 ₺',
      'المجموع المستحق: 77 ₺',
      'الحالة: مسدّد جزئياً',
      'غير المسدّد منه: 50 ₺',
    ]) {
      expect(find.text(line), findsOneWidget, reason: line);
    }
    // The order's discount and the statement's total.
    expect(find.text('خصم يموّله المطعم: 20 ₺'), findsNWidgets(2));
    await tester.ensureVisible(find.byKey(const Key('statement-share')));
    // Rendering the image runs outside the test's fake clock.
    await tester.runAsync(() async {
      await tester.tap(find.byKey(const Key('statement-share')));
      for (var i = 0; i < 40 && shared.isEmpty; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
      }
    });
    await tester.pumpAndSettle();
    final png = shared['statement-$_statementId.png'];
    expect(png, isNotNull);
    // The PNG signature.
    expect(png!.sublist(0, 4), [0x89, 0x50, 0x4E, 0x47]);

    // Back returns to «الكشوف», then to «الحساب».
    app.container.read(routerProvider).pop();
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('statements')), findsOneWidget);
    app.container.read(routerProvider).pop();
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('account-balance')), findsOneWidget);
    await app.done(tester);
  });

  // RA §12.4 (slice 2.19e): «الإيصالات» with the safety note, and a receipt.
  testWidgets('an owner reads the receipts and opens one', (tester) async {
    final app = _Board(role: 'owner');
    final receipt = {
      'id': _receiptId,
      'number': 'AZ-2026-000042',
      'type': 'merchant_settlement',
      'method': 'field',
      'staffName': 'سارة',
      'currency': 'TRY',
      'total': '22000',
      'createdAt': '2026-11-14T09:30:00.000Z',
      'lines': [
        {'currency': 'TRY', 'amount': '12000', 'base': '12000'},
        {'currency': 'USD', 'amount': '250', 'base': '10000'},
      ],
    };
    app.server.on('/v1/merchant/receipts', [
      FakeAnswer(200, {
        'receipts': [receipt],
      }),
    ]);
    app.server.on('/v1/merchant/receipts/$_receiptId', [
      FakeAnswer(200, {...receipt, 'dueBefore': '30000', 'dueAfter': '8000'}),
    ]);
    await app.pump(tester, [FakeAnswer(200, boardJson([]))]);
    app.container.read(routerProvider).go('/account/receipts');
    await tester.pumpAndSettle();
    expect(
      find.text(
        'لا تسلّم المبلغ إلا لموظف FOX DROP معروف لديك، وتأكد من وصول الإيصال إلى التطبيق.',
      ),
      findsOneWidget,
    );
    expect(
      find.text('إيصال AZ-2026-000042: استلمنا منك 220 ₺'),
      findsOneWidget,
    );
    expect(find.text('14/11/2026 12:30 م · زيارة ميدانية'), findsOneWidget);
    await tester.tap(find.text('إيصال AZ-2026-000042: استلمنا منك 220 ₺'));
    await tester.pumpAndSettle();
    for (final line in [
      'إيصال AZ-2026-000042',
      'طريقة التسوية: زيارة ميدانية',
      'الموظف: سارة',
      '120 ₺',
      '2.50 \$ (القيمة بالعملة الأساسية 100 ₺)',
      'المجموع: 220 ₺',
      'الرصيد قبل: عليك 300 ₺',
      'الرصيد بعد: عليك 80 ₺',
    ]) {
      expect(find.text(line), findsOneWidget, reason: line);
    }
    await app.done(tester);
  });

  testWidgets('a statement of another restaurant says so, and a cashier is '
      'told the records are the owners\'', (tester) async {
    final app = _Board(role: 'owner');
    app.server.on('/v1/merchant/statements/$_statementId', [
      const FakeAnswer(404, {'statusCode': 404, 'error': 'unknown_statement'}),
    ]);
    app.server.on('/v1/merchant/receipts', [
      const FakeAnswer(403, {'statusCode': 403, 'error': 'owner_only'}),
    ]);
    await app.pump(tester, [FakeAnswer(200, boardJson([]))]);
    app.container.read(routerProvider).go('/account/statements/$_statementId');
    await tester.pumpAndSettle();
    expect(find.text('لم يُعثر على هذا الكشف.'), findsOneWidget);
    expect(find.text('إعادة المحاولة'), findsNothing);
    app.container.read(routerProvider).go('/account/receipts');
    await tester.pumpAndSettle();
    expect(find.text('الكشوف والإيصالات للمالكين فقط.'), findsOneWidget);
    await app.done(tester);
  });

  // RA §8.17, §16 #34, §18: the stop's banner on every screen, a chime when
  // it starts or ends, read again on each broadcast.
  testWidgets('the emergency stop shows its banner and chimes on and off', (
    tester,
  ) async {
    final app = _Board();
    app.server.on('/v1/merchant/emergency-stop', [
      const FakeAnswer(200, {
        'active': true,
        'startedAt': '2026-11-09T09:00:00.000Z',
      }),
    ]);
    await app.pump(tester, [FakeAnswer(200, boardJson([]))]);
    const text =
        'المنصة متوقفة مؤقتاً عن استقبال طلبات جديدة. أكملوا الطلبات الحالية.';
    expect(find.text(text), findsOneWidget);
    // The state the app opened in is no switch.
    expect(app.ringer.chimes, 0);

    app.server.on('/v1/merchant/emergency-stop', [
      const FakeAnswer(200, {'active': false, 'startedAt': null}),
    ]);
    final reads = app.server.to('/v1/merchant/emergency-stop').length;
    app.transport.send(
      _channel,
      const RealtimePublication({
        'type': 'platform.emergency_stop',
        'active': false,
        'at': '2026-11-09T10:00:00.000Z',
      }),
    );
    await tester.pumpAndSettle();
    expect(app.server.to('/v1/merchant/emergency-stop'), hasLength(reads + 1));
    expect(find.text(text), findsNothing);
    expect(app.ringer.chimes, 1);

    // Started again: the banner comes back with a chime.
    app.server.on('/v1/merchant/emergency-stop', [
      const FakeAnswer(200, {
        'active': true,
        'startedAt': '2026-11-09T11:00:00.000Z',
      }),
    ]);
    app.transport.send(
      _channel,
      const RealtimePublication({'type': 'platform.emergency_stop'}),
    );
    await tester.pumpAndSettle();
    expect(find.text(text), findsOneWidget);
    expect(app.ringer.chimes, 2);
    await app.done(tester);
  });

  // RA §18, §4.2: «التطبيقات» changed, or the channel reconnected.
  testWidgets('reads the platform again on app_changed and on reconnecting', (
    tester,
  ) async {
    final app = _Board();
    await app.pump(tester, [FakeAnswer(200, boardJson([]))]);
    final reads = app.server.to('/v1/merchant/platform').length;
    app.transport.send(
      _channel,
      const RealtimePublication({
        'type': 'platform.app_changed',
        'app': 'merchant',
      }),
    );
    await tester.pumpAndSettle();
    expect(app.server.to('/v1/merchant/platform'), hasLength(reads + 1));
    await app.up(tester);
    expect(app.server.to('/v1/merchant/platform'), hasLength(reads + 2));
    await app.done(tester);
  });

  testWidgets('«رفض» with «صنف غير متوفر» sends the items and stops the ring '
      '(RA §8.6)', (tester) async {
    final app = _Board();
    await app.pump(tester, [
      FakeAnswer(200, boardJson([orderJson()])),
      FakeAnswer(200, boardJson([])),
    ]);
    await app.up(tester);
    expect(app.ringer.ringing, isTrue);

    await tester.tap(find.byKey(const Key('reject')));
    await tester.pumpAndSettle();
    expect(find.text('رفض الطلب #10001'), findsOneWidget);
    // No reason, or no item, sends nothing.
    final confirm = find.byKey(const Key('reject-confirm'));
    expect(tester.widget<FilledButton>(confirm).onPressed, isNull);
    await tester.tap(find.byKey(const Key('reject-item_unavailable')));
    await tester.pumpAndSettle();
    expect(tester.widget<FilledButton>(confirm).onPressed, isNull);
    await tester.tap(find.byKey(const Key('reject-item-$falafelId')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('reject-back-on-$falafelId')));
    await tester.pumpAndSettle();
    app.server.on('/v1/merchant/orders/$_orderId/reject', [
      FakeAnswer(200, {'order': orderJson(status: 'rejected', version: 2)}),
    ]);
    await tester.tap(confirm);
    await tester.pumpAndSettle();

    final sent = app.server.to('/v1/merchant/orders/$_orderId/reject').single;
    expect(sent.data, {
      'reason': 'item_unavailable',
      'items': [
        {'itemId': falafelId, 'until': 'turned_back_on'},
      ],
      'busyExtraMin': null,
      'pauseMin': null,
    });
    expect(sent.headers['Idempotency-Key'], isNotEmpty);
    expect(find.byKey(const Key('ringing-prompt')), findsNothing);
    expect(app.ringer.ringing, isFalse);
    await app.done(tester);
  });

  testWidgets('«ضغط طلبات» may add «إيقاف 30 د» (RA §8.6)', (tester) async {
    final app = _Board();
    await app.pump(tester, [
      FakeAnswer(200, boardJson([orderJson()])),
      FakeAnswer(200, boardJson([])),
    ]);
    await app.up(tester);
    await tester.tap(find.byKey(const Key('reject')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('reject-too_busy')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('reject-pause')));
    await tester.pumpAndSettle();
    app.server.on('/v1/merchant/orders/$_orderId/reject', [
      FakeAnswer(200, {'order': orderJson(status: 'rejected', version: 2)}),
    ]);
    await tester.tap(find.byKey(const Key('reject-confirm')));
    await tester.pumpAndSettle();
    expect(app.server.to('/v1/merchant/orders/$_orderId/reject').single.data, {
      'reason': 'too_busy',
      'items': <Object?>[],
      'busyExtraMin': null,
      'pauseMin': 30,
    });
    await app.done(tester);
  });

  testWidgets('operations rejecting for the restaurant chime with the reason '
      '(RA §8.15, §16 #6)', (tester) async {
    final app = _Board();
    await app.pump(tester, [
      FakeAnswer(200, boardJson([orderJson()])),
      FakeAnswer(200, boardJson([])),
    ]);
    await app.up(tester);
    expect(app.ringer.ringing, isTrue);
    app.transport.send(
      _channel,
      const RealtimePublication({
        'type': 'order.rejected',
        'orderId': _orderId,
        'number': '10001',
        'version': 2,
        'reason': 'restaurant_closed',
        'byOperations': true,
      }),
    );
    await tester.pumpAndSettle();
    expect(app.ringer.ringing, isFalse);
    expect(app.ringer.chimes, greaterThan(0));
    expect(
      find.text('رفضت العمليات الطلب #10001: المطعم مغلق'),
      findsOneWidget,
    );
    await app.done(tester);
  });

  testWidgets('an order operations accepted shows «قبلته العمليات» '
      '(RA §8.15)', (tester) async {
    final app = _Board();
    await app.pump(tester, [
      FakeAnswer(
        200,
        boardJson([
          orderJson(
            status: 'accepted',
            version: 2,
            acceptedAfter: Duration.zero,
            byOperations: true,
          ),
        ]),
      ),
    ]);
    await app.up(tester);
    await tester.tap(find.byKey(const Key('tab-preparing')));
    await tester.pumpAndSettle();
    expect(find.textContaining('قبلته العمليات'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets("the sheet offers Content's active reasons with their labels "
      '(RA Appendix C)', (tester) async {
    final app = _Board();
    app.server.on('/v1/merchant/content', [
      const FakeAnswer(200, {
        'reasons': {
          'merchant_rejection': [
            {'code': 'item_unavailable', 'label': 'صنف نفد', 'note': 'none'},
            {
              'code': 'restaurant_closed',
              'label': 'المطعم مغلق',
              'note': 'none',
            },
          ],
          'merchant_problem': <Object?>[],
          'item_unavailable_note': <Object?>[],
          'merchant_ticket_type': <Object?>[],
        },
        'faq': <Object?>[],
      }),
    ]);
    await app.pump(tester, [
      FakeAnswer(200, boardJson([orderJson()])),
    ]);
    await app.up(tester);
    await tester.tap(find.byKey(const Key('reject')));
    await tester.pumpAndSettle();
    expect(find.text('صنف نفد'), findsOneWidget);
    expect(find.byKey(const Key('reject-too_busy')), findsNothing);
    await app.done(tester);
  });

  group('the item-unavailable report (RA §8.12)', () {
    final accepted = orderJson(
      status: 'accepted',
      version: 2,
      acceptedAfter: Duration.zero,
    );
    final reported = orderJson(
      status: 'accepted',
      version: 3,
      acceptedAfter: Duration.zero,
      itemReport: itemReportJson(),
    );

    Future<void> openDetail(WidgetTester tester, _Board app) async {
      app.container.read(routerProvider).push('/orders/$_orderId');
      await tester.pumpAndSettle();
    }

    testWidgets('the detail sends the report with a note of Content, shows '
        'the badge, and withdraws it', (tester) async {
      final app = _Board();
      app.server.on('/v1/merchant/content', [
        const FakeAnswer(200, {
          'reasons': {
            'merchant_rejection': <Object?>[],
            'merchant_problem': <Object?>[],
            'item_unavailable_note': [
              {
                'code': 'similar_alternative',
                'label': 'لدينا بديل مشابه',
                'note': 'none',
              },
            ],
            'merchant_ticket_type': <Object?>[],
          },
          'faq': <Object?>[],
        }),
      ]);
      await app.pump(tester, [
        FakeAnswer(200, boardJson([accepted])),
        FakeAnswer(200, boardJson([reported])),
        FakeAnswer(
          200,
          boardJson([
            {...accepted, 'version': 4},
          ]),
        ),
      ]);
      await app.up(tester);
      await openDetail(tester, app);
      expect(find.byKey(const Key('withdraw-item-report')), findsNothing);

      await tester.tap(find.text('صنف غير متوفر — اتصلوا بالزبون'));
      await tester.pumpAndSettle();
      expect(find.text('صنف غير متوفر في الطلب #10001'), findsOneWidget);
      // No item, nothing to send.
      final confirm = find.byKey(const Key('report-confirm'));
      expect(tester.widget<FilledButton>(confirm).onPressed, isNull);
      await tester.tap(find.byKey(const Key('report-item-$falafelId')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('report-back-on-$falafelId')));
      // Content's list only, with its label.
      expect(
        find.byKey(const Key('report-note-insufficient_quantity')),
        findsNothing,
      );
      await tester.tap(find.text('لدينا بديل مشابه'));
      await tester.pumpAndSettle();
      app.server.on('/v1/merchant/orders/$_orderId/item-report', [
        FakeAnswer(200, {'order': reported}),
      ]);
      await tester.tap(confirm);
      await tester.pumpAndSettle();

      final sent = app.server
          .to('/v1/merchant/orders/$_orderId/item-report')
          .single;
      expect(sent.data, {
        'items': [
          {'itemId': falafelId, 'until': 'turned_back_on'},
        ],
        'note': 'similar_alternative',
      });
      expect(sent.headers['Idempotency-Key'], isNotEmpty);
      expect(find.text('صنف نفد — بانتظار العمليات'), findsOneWidget);
      expect(find.textContaining('العمليات تتواصل مع الزبون'), findsOneWidget);
      // The note's label as the server kept it.
      expect(find.textContaining('يوجد بديل مشابه'), findsOneWidget);
      expect(find.byKey(const Key('report-items')), findsNothing);

      app.server.on('/v1/merchant/orders/$_orderId/item-report/withdraw', [
        FakeAnswer(200, {
          'order': {...accepted, 'version': 4},
        }),
      ]);
      await tester.tap(find.text('تراجع — الصنف متوفر'));
      await tester.pumpAndSettle();
      expect(
        app.server
            .to('/v1/merchant/orders/$_orderId/item-report/withdraw')
            .single
            .headers['Idempotency-Key'],
        isNotEmpty,
      );
      expect(find.text('صنف نفد — بانتظار العمليات'), findsNothing);
      expect(find.byKey(const Key('report-items')), findsOneWidget);
      await app.done(tester);
    });

    testWidgets('without Content the built-in notes are offered; a note '
        'Content removed is explained', (tester) async {
      final app = _Board();
      await app.pump(tester, [
        FakeAnswer(200, boardJson([accepted])),
      ]);
      await app.up(tester);
      await openDetail(tester, app);
      await tester.tap(find.byKey(const Key('report-items')));
      await tester.pumpAndSettle();
      expect(find.text('يوجد بديل مشابه'), findsOneWidget);
      await tester.tap(find.byKey(const Key('report-item-$shawarmaId')));
      await tester.tap(find.text('الكمية غير كافية'));
      await tester.pumpAndSettle();
      app.server.on('/v1/merchant/orders/$_orderId/item-report', [
        const FakeAnswer(400, {'error': 'unknown_reason'}),
      ]);
      await tester.tap(find.byKey(const Key('report-confirm')));
      await tester.pumpAndSettle();
      expect(
        app.server.to('/v1/merchant/orders/$_orderId/item-report').single.data,
        {
          'items': [
            {'itemId': shawarmaId, 'until': 'tomorrow'},
          ],
          'note': 'insufficient_quantity',
        },
      );
      expect(
        find.text('تعذّر إرسال البلاغ بهذه الاختيارات، راجعها ثم أعد المحاولة'),
        findsOneWidget,
      );
      await app.done(tester);
    });

    testWidgets('the card shows the badge and the line', (tester) async {
      final app = _Board();
      await app.pump(tester, [
        FakeAnswer(200, boardJson([reported])),
      ]);
      await app.up(tester);
      await tester.tap(find.byKey(const Key('tab-preparing')));
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'صنف نفد — بانتظار العمليات\nالعمليات تتواصل مع الزبون',
        ),
        findsOneWidget,
      );
      await app.done(tester);
    });

    testWidgets('a report refused while the pickup request opened is '
        'explained', (tester) async {
      final app = _Board();
      final pending = orderJson(
        status: 'accepted',
        version: 3,
        acceptedAfter: Duration.zero,
        captainTrack: 'pickup_pending',
        captainName: 'سامر',
        arrivedAt: placedAt,
        request: requestJson(),
      );
      await app.pump(tester, [
        FakeAnswer(200, boardJson([accepted])),
        FakeAnswer(200, boardJson([pending])),
      ]);
      await app.up(tester);
      await openDetail(tester, app);
      await tester.tap(find.byKey(const Key('report-items')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('report-item-$shawarmaId')));
      await tester.pumpAndSettle();
      app.server.on('/v1/merchant/orders/$_orderId/item-report', [
        FakeAnswer(409, {'error': 'order_state_changed', 'order': pending}),
      ]);
      await tester.tap(find.byKey(const Key('report-confirm')));
      await tester.pumpAndSettle();
      expect(
        find.text('الكابتن يطلب تأكيد الاستلام، أجب على طلبه أولاً'),
        findsOneWidget,
      );
      await app.done(tester);
    });

    testWidgets('a withdrawal after operations closed the report is '
        'explained', (tester) async {
      final app = _Board();
      await app.pump(tester, [
        FakeAnswer(200, boardJson([reported])),
        FakeAnswer(
          200,
          boardJson([
            {...accepted, 'version': 4},
          ]),
        ),
      ]);
      await app.up(tester);
      await openDetail(tester, app);
      app.server.on('/v1/merchant/orders/$_orderId/item-report/withdraw', [
        FakeAnswer(409, {
          'error': 'order_state_changed',
          'order': {...accepted, 'version': 4},
        }),
      ]);
      await tester.tap(find.byKey(const Key('withdraw-item-report')));
      await tester.pumpAndSettle();
      expect(find.text('أُغلق بلاغ الصنف قبل وصول تراجعك'), findsOneWidget);
      await app.done(tester);
    });

    testWidgets("operations' prep time change chimes with the new time "
        '(RA §16 #12)', (tester) async {
      final app = _Board();
      await app.pump(tester, [
        FakeAnswer(200, boardJson([reported])),
        FakeAnswer(
          200,
          boardJson([
            orderJson(
              status: 'accepted',
              version: 4,
              acceptedAfter: Duration.zero,
              prepMin: 30,
              itemReport: itemReportJson(),
            ),
          ]),
        ),
      ]);
      await app.up(tester);
      app.transport.send(
        _channel,
        const RealtimePublication({
          'type': 'order.time_changed',
          'orderId': _orderId,
          'number': '10001',
          'version': 4,
          'reason': 'prep_time_changed',
          'byOperations': true,
        }),
      );
      await tester.pumpAndSettle();
      expect(find.text('عدّلت العمليات وقت تحضير #10001 إلى 30 د'), findsOne);
      expect(app.ringer.chimes, greaterThan(0));
      await app.done(tester);
    });

    testWidgets("operations closing the report chime with their reason "
        '(RA §16 #37)', (tester) async {
      final app = _Board();
      await app.pump(tester, [
        FakeAnswer(200, boardJson([reported])),
        FakeAnswer(
          200,
          boardJson([
            {...accepted, 'version': 5},
          ]),
        ),
      ]);
      await app.up(tester);
      final chimes = app.ringer.chimes;
      app.transport.send(
        _channel,
        const RealtimePublication({
          'type': 'order.item_report_closed',
          'orderId': _orderId,
          'number': '10001',
          'version': 5,
          'reason': 'الزبون يقبل الطلب بدون الصنف',
          'byOperations': true,
        }),
      );
      await tester.pumpAndSettle();
      expect(
        find.text(
          'أغلقت العمليات بلاغ الصنف في الطلب #10001: '
          'الزبون يقبل الطلب بدون الصنف',
        ),
        findsOneWidget,
      );
      expect(app.ringer.chimes, chimes + 1);
      await app.done(tester);
    });
  });

  // RA §15, §8.19, §16 #29 (slice 2.24b): «الدعم» and «مشكلة في الطلب».
  group('support', () {
    Map<String, Object?> ticketJson(Map<String, Object?> fields) => {
      'id': '00000000-0000-4000-8000-0000000000d1',
      'number': '17',
      'typeLabel': 'استفسار مالي',
      'subject': null,
      'orderId': null,
      'orderNumber': null,
      'description': '',
      'status': 'new',
      'openedAt': '2026-11-07T12:00:00.000Z',
      'openedBy': 'me',
      'replyWithinMinutes': 1440,
      'message': null,
      'resolvedAt': null,
      ...fields,
    };
    final content = FakeAnswer(200, {
      'reasons': {
        'merchant_rejection': <Object?>[],
        'merchant_problem': [
          {'code': 'captain_late', 'label': 'الكابتن تأخر', 'note': 'none'},
          {'code': 'other', 'label': 'أخرى', 'note': 'required'},
        ],
        'item_unavailable_note': <Object?>[],
        'merchant_ticket_type': [
          {'code': 'finance_inquiry', 'label': 'استفسار مالي', 'note': 'none'},
          {'code': 'data_change', 'label': 'طلب تعديل بيانات', 'note': 'none'},
        ],
      },
      'faq': [
        {'question': 'متى تُدفع المستحقات؟', 'answer': 'يوم السبت.'},
      ],
    });

    testWidgets('«بلاغاتي» shows the status and the reply; a data change '
        'asks its subject and is sent with the order', (tester) async {
      final app = _Board();
      app.server.on('/v1/merchant/content', [content]);
      app.server.on('/v1/merchant/contact', [
        const FakeAnswer(200, {'phone': '+963900000001'}),
      ]);
      app.server.on('/v1/merchant/reports', [
        FakeAnswer(200, {
          'tickets': [
            ticketJson({
              'status': 'resolved',
              'message': 'الكشف يصل السبت.',
              'openedBy': 'restaurant',
            }),
          ],
        }),
      ]);
      final accepted = orderJson(
        status: 'accepted',
        version: 2,
        acceptedAfter: Duration.zero,
      );
      await app.pump(tester, [
        FakeAnswer(200, boardJson([accepted])),
      ]);
      await app.up(tester);

      await tester.tap(find.byKey(const Key('open-support')));
      await tester.pumpAndSettle();
      expect(find.text('اتصال بالعمليات'), findsOneWidget);
      expect(find.text('واتساب العمليات'), findsNothing);
      expect(find.text('T-17 · استفسار مالي'), findsOneWidget);
      expect(find.text('محلولة'), findsOneWidget);
      expect(find.textContaining('الرد: الكشف يصل السبت.'), findsOneWidget);
      expect(find.textContaining('من مستخدم آخر'), findsOneWidget);
      expect(find.text('متى تُدفع المستحقات؟'), findsOneWidget);

      await tester.tap(find.byKey(const Key('report-problem')));
      await tester.pumpAndSettle();
      final send = find.byKey(const Key('report-send'));
      await tester.tap(find.byKey(const Key('type-data_change')));
      await tester.pumpAndSettle();
      expect(tester.widget<FilledButton>(send).onPressed, isNull);
      await tester.tap(find.byKey(const Key('subject-minOrder')));
      await tester.tap(find.byKey(const Key('order-$_orderId')));
      await tester.enterText(
        find.byKey(const Key('report-note')),
        'نريد الحد الأدنى 50',
      );
      await tester.pumpAndSettle();
      app.server.on('/v1/merchant/reports', [
        FakeAnswer(200, {
          'ticket': ticketJson({
            'number': '18',
            'typeLabel': 'طلب تعديل بيانات',
            'subject': 'min_order',
          }),
        }),
      ]);
      await tester.ensureVisible(send);
      await tester.tap(send);
      await tester.pumpAndSettle();
      final sent = app.server.requests
          .where(
            (r) => r.uri.path == '/v1/merchant/reports' && r.method == 'POST',
          )
          .single;
      expect(sent.data, {
        'typeCode': 'data_change',
        'orderId': _orderId,
        'note': 'نريد الحد الأدنى 50',
        'subject': 'min_order',
        'photoUploadId': null,
      });
      expect(sent.headers['Idempotency-Key'], isNotEmpty);
      expect(
        find.text('استلمنا بلاغك T-18. سنرد عليك خلال 24 ساعة.'),
        findsOneWidget,
      );
      await app.done(tester);
    });

    testWidgets('«مشكلة في الطلب» sends a quick reason on the order', (
      tester,
    ) async {
      final app = _Board();
      app.server.on('/v1/merchant/content', [content]);
      app.server.on('/v1/merchant/contact', [
        const FakeAnswer(200, {'whatsapp': '+963900000002'}),
      ]);
      final accepted = orderJson(
        status: 'accepted',
        version: 2,
        acceptedAfter: Duration.zero,
      );
      await app.pump(tester, [
        FakeAnswer(200, boardJson([accepted])),
      ]);
      await app.up(tester);
      app.container.read(routerProvider).push('/orders/$_orderId');
      await tester.pumpAndSettle();

      final button = find.byKey(const Key('order-problem'));
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(find.text('واتساب العمليات'), findsOneWidget);
      app.server.on('/v1/merchant/orders/$_orderId/problem', [
        FakeAnswer(200, {
          'ticket': ticketJson({
            'typeLabel': 'الكابتن تأخر',
            'orderId': _orderId,
            'orderNumber': '10001',
            'replyWithinMinutes': 15,
          }),
        }),
      ]);
      await tester.tap(find.byKey(const Key('problem-captain_late')));
      await tester.pumpAndSettle();
      final sent = app.server
          .to('/v1/merchant/orders/$_orderId/problem')
          .single;
      expect(sent.data, {'reasonCode': 'captain_late', 'note': null});
      expect(
        find.text('استلمنا بلاغك T-17. سنرد عليك خلال 15 دقيقة.'),
        findsOneWidget,
      );
      await app.done(tester);
    });
    testWidgets('a reason whose text is required asks for it first', (
      tester,
    ) async {
      final app = _Board();
      app.server.on('/v1/merchant/content', [content]);
      final accepted = orderJson(
        status: 'accepted',
        version: 2,
        acceptedAfter: Duration.zero,
      );
      await app.pump(tester, [
        FakeAnswer(200, boardJson([accepted])),
      ]);
      await app.up(tester);
      app.container.read(routerProvider).push('/orders/$_orderId');
      await tester.pumpAndSettle();
      final button = find.byKey(const Key('order-problem'));
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();
      app.server.on('/v1/merchant/orders/$_orderId/problem', [
        FakeAnswer(200, {
          'ticket': ticketJson({'typeLabel': 'أخرى'}),
        }),
      ]);
      await tester.tap(find.byKey(const Key('problem-other')));
      await tester.pumpAndSettle();
      final send = find.byKey(const Key('problem-note-send'));
      expect(tester.widget<TextButton>(send).onPressed, isNull);
      await tester.enterText(
        find.byKey(const Key('problem-note')),
        'الكيس ممزق',
      );
      await tester.pumpAndSettle();
      await tester.tap(send);
      await tester.pumpAndSettle();
      final sent = app.server
          .to('/v1/merchant/orders/$_orderId/problem')
          .single;
      expect(sent.data, {'reasonCode': 'other', 'note': 'الكيس ممزق'});
      await app.done(tester);
    });
  });

  // RA §4.4 (slice 2.42): an owner's device with ringing off shows the
  // prompt without the ring.
  testWidgets('an owner’s device with ringing off shows a new order silently', (
    tester,
  ) async {
    final app = _Board(role: 'owner');
    app.server.on('/v1/merchant/device', [
      const FakeAnswer(200, {'ringing': false, 'check': null}),
    ]);
    await app.pump(tester, [
      FakeAnswer(200, boardJson([orderJson()])),
    ]);
    await app.up(tester);
    expect(find.text('طلب جديد #10001'), findsOneWidget);
    expect(app.ringer.ringing, isFalse);
    await app.done(tester);
  });

  // RA §4.5 (slice 2.42): the device check opens at the first sign-in,
  // opens each failing check's settings, plays the test ring and sends the
  // result; the banner shows while a check fails.
  testWidgets(
    'the device check runs at the first sign-in and sends its result',
    (tester) async {
      final app = _Board();
      app.alerts.deviceReadings = const AndroidReadings(
        notificationsAllowed: true,
        batteryOptimizationOff: false,
        fullScreenAllowed: true,
        alarmVolumePercent: 80,
        doNotDisturbBlocks: false,
        autostartPage: false,
      );
      app.server
        ..on('/v1/merchant/device', [
          const FakeAnswer(200, {'ringing': true, 'check': null}),
        ])
        ..on('/v1/merchant/device/check', [
          const FakeAnswer(200, {
            'ringing': true,
            'check': {
              'at': '2026-11-20T09:00:00.000Z',
              'passed': false,
              'failed': ['battery'],
              'delayMs': 0,
            },
          }),
        ]);
      await app.pump(tester, [FakeAnswer(200, boardJson([]))]);
      expect(find.text('فحص الجهاز'), findsWidgets);
      final battery = find.byKey(const Key('check-battery'));
      expect(
        find.descendant(of: battery, matching: find.text('لم يكتمل')),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const Key('open-battery')));
      expect(app.alerts.opened, [DeviceSetting.battery]);

      await tester.ensureVisible(find.byKey(const Key('test-ring')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('test-ring')));
      await tester.pumpAndSettle();
      expect(app.ringer.sound, RingSound.newOrder);
      await tester.tap(find.byKey(const Key('test-ring-heard')));
      await tester.pumpAndSettle();
      expect(app.ringer.ringing, isFalse);

      await tester.ensureVisible(find.byKey(const Key('save-check')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('save-check')));
      await tester.pumpAndSettle();
      final sent = app.server.to('/v1/merchant/device/check').single;
      expect((sent.data as Map)['failed'], ['battery']);
      expect(find.text('حُفظت نتيجة الفحص.'), findsOneWidget);

      // Back on the board, the banner says a check still fails.
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('device-check-banner')), findsOneWidget);
      await app.done(tester);
    },
  );

  // RA §4.5: each other Android condition fails on its own, shows «لم يكتمل»
  // with its settings page, and the result sent names it.
  final failingChecks = <(String, String, AndroidReadings, DeviceSetting)>[
    (
      'notifications',
      'notifications',
      const AndroidReadings(
        notificationsAllowed: false,
        batteryOptimizationOff: true,
        fullScreenAllowed: true,
        alarmVolumePercent: 80,
        doNotDisturbBlocks: false,
        autostartPage: false,
      ),
      DeviceSetting.notifications,
    ),
    (
      'autostart',
      'autostart',
      const AndroidReadings(
        notificationsAllowed: true,
        batteryOptimizationOff: true,
        fullScreenAllowed: true,
        alarmVolumePercent: 80,
        doNotDisturbBlocks: false,
        autostartPage: true,
      ),
      DeviceSetting.autostart,
    ),
    (
      'fullScreen',
      'full_screen',
      const AndroidReadings(
        notificationsAllowed: true,
        batteryOptimizationOff: true,
        fullScreenAllowed: false,
        alarmVolumePercent: 80,
        doNotDisturbBlocks: false,
        autostartPage: false,
      ),
      DeviceSetting.fullScreen,
    ),
    (
      'alarmVolume',
      'alarm_volume',
      const AndroidReadings(
        notificationsAllowed: true,
        batteryOptimizationOff: true,
        fullScreenAllowed: true,
        alarmVolumePercent: 40,
        doNotDisturbBlocks: false,
        autostartPage: false,
      ),
      DeviceSetting.alarmVolume,
    ),
    (
      'alarmVolume',
      'alarm_volume',
      const AndroidReadings(
        notificationsAllowed: true,
        batteryOptimizationOff: true,
        fullScreenAllowed: true,
        alarmVolumePercent: 80,
        doNotDisturbBlocks: true,
        autostartPage: false,
      ),
      DeviceSetting.doNotDisturb,
    ),
  ];
  for (final (key, wire, readings, setting) in failingChecks) {
    testWidgets(
      'the device check fails and sends $key when ${setting.name} is not right',
      (tester) async {
        final app = _Board();
        app.alerts.deviceReadings = readings;
        app.server
          ..on('/v1/merchant/device', [
            const FakeAnswer(200, {'ringing': true, 'check': null}),
          ])
          ..on('/v1/merchant/device/check', [
            FakeAnswer(200, {
              'ringing': true,
              'check': {
                'at': '2026-11-20T09:00:00.000Z',
                'passed': false,
                'failed': [wire],
                'delayMs': 0,
              },
            }),
          ]);
        await app.pump(tester, [FakeAnswer(200, boardJson([]))]);
        final card = find.byKey(Key('check-$key'));
        expect(
          find.descendant(of: card, matching: find.text('لم يكتمل')),
          findsOneWidget,
        );
        await tester.ensureVisible(find.byKey(Key('open-$key')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(Key('open-$key')));
        expect(app.alerts.opened, [setting]);

        await tester.ensureVisible(find.byKey(const Key('test-ring')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('test-ring')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('test-ring-heard')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('save-check')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('save-check')));
        await tester.pumpAndSettle();
        final sent = app.server.to('/v1/merchant/device/check').single;
        expect((sent.data as Map)['failed'], [wire]);
        await app.done(tester);
      },
    );
  }

  // RA §8.7, R7 and §8.5: the prep countdown runs down to «متأخر», and an
  // accepted order offers no prep-time change, only the call to operations.
  testWidgets('an accepted order counts its prep down, then shows it late, '
      'and offers no prep-time change', (tester) async {
    final app = _Board();
    var deviceNow = placedAt.add(const Duration(minutes: 1));
    await app.pump(tester, [
      FakeAnswer(
        200,
        boardJson([
          orderJson(
            status: 'accepted',
            acceptedAfter: const Duration(minutes: 1),
          ),
        ]),
      ),
    ], clock: ServerClock(deviceNow: () => deviceNow));
    app.container.read(routerProvider).push('/orders/$_orderId');
    await tester.pumpAndSettle();
    expect(find.text('متبقٍ 20:00'), findsOneWidget);
    deviceNow = placedAt.add(const Duration(minutes: 6));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('متبقٍ 15:00'), findsOneWidget);
    deviceNow = placedAt.add(const Duration(minutes: 24));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('متأخر 3 د'), findsOneWidget);
    expect(find.byKey(const Key('accept')), findsNothing);
    expect(find.byIcon(Icons.add), findsNothing);
    expect(find.byIcon(Icons.remove), findsNothing);
    final labels = tester
        .widgetList<ButtonStyleButton>(
          find.byWidgetPredicate((w) => w is ButtonStyleButton),
        )
        .expand(
          (b) => tester
              .widgetList<Text>(
                find.descendant(
                  of: find.byWidget(b),
                  matching: find.byType(Text),
                ),
              )
              .map((text) => text.data)
              .take(1),
        )
        .toList();
    expect(labels, [
      'الطلب جاهز',
      'تحتاج وقتاً أطول؟ اتصل بالعمليات',
      'صنف غير متوفر — اتصلوا بالزبون',
      'مشكلة في الطلب',
    ]);
    expect(find.text('تحتاج وقتاً أطول؟ اتصل بالعمليات'), findsOneWidget);
    await app.done(tester);
  });

  // RA §4.7: the countdowns run on the server's clock, so a device clock hours
  // ahead or days behind changes nothing.
  for (final wrong in [const Duration(hours: 5), const Duration(days: -2)]) {
    testWidgets('the auto-cancel and prep countdowns ignore a device clock '
        '${wrong.inHours} hours off', (tester) async {
      final app = _Board();
      final deviceNow = placedAt.add(wrong);
      final clock = ServerClock(deviceNow: () => deviceNow)
        ..observe(
          placedAt
              .add(const Duration(minutes: 1))
              .millisecondsSinceEpoch
              .toString(),
        );
      await app.pump(tester, [
        FakeAnswer(
          200,
          boardJson([
            orderJson(),
            orderJson(
              id: '00000000-0000-4000-8000-0000000000a2',
              number: '10002',
              status: 'accepted',
              acceptedAfter: const Duration(minutes: 1),
            ),
          ]),
        ),
      ], clock: clock);
      expect(find.text('يُلغى تلقائياً خلال 6:00'), findsWidgets);
      app.container
          .read(routerProvider)
          .push('/orders/00000000-0000-4000-8000-0000000000a2');
      await tester.pumpAndSettle();
      expect(find.text('متبقٍ 20:00'), findsOneWidget);
      await app.done(tester);
    });
  }

  // RA §8.4, RA-23: the customer's delivery fee and total never reach the
  // order detail. The guarantee is the server's read
  // (apps/server/src/modules/ordering/merchant-reads.test.ts); this checks
  // that the screen has no such line.
  testWidgets('the order detail shows no delivery fee and no customer total', (
    tester,
  ) async {
    final app = _Board(role: 'owner');
    await app.pump(tester, [
      FakeAnswer(200, boardJson([orderJson()])),
    ]);
    app.container.read(routerProvider).push('/orders/$_orderId');
    await tester.pumpAndSettle();
    expect(find.text('#10001'), findsWidgets);
    expect(find.textContaining('التوصيل'), findsNothing);
    expect(find.textContaining('الإجمالي'), findsNothing);
    await app.done(tester);
  });

  // RA §15, RA-26: the support screen's two tiles open the team's phone and
  // WhatsApp.
  testWidgets('the support call and WhatsApp tiles open the team’s phone and '
      'WhatsApp links', (tester) async {
    final app = _Board();
    final launched = <Uri>[];
    app.server.on('/v1/merchant/contact', [
      const FakeAnswer(200, {
        'phone': '+963944000000',
        'whatsapp': '+963955000000',
      }),
    ]);
    await app.pump(
      tester,
      [FakeAnswer(200, boardJson([]))],
      overrides: [
        merchantAuth.launch.overrideWithValue((uri) async {
          launched.add(uri);
          return true;
        }),
      ],
    );
    await app.up(tester);
    await tester.tap(find.byKey(const Key('open-support')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('call-operations')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('whatsapp-operations')));
    await tester.pump();
    expect(launched.map((u) => u.toString()), [
      'tel:+963944000000',
      'https://wa.me/963955000000',
    ]);
    await app.done(tester);
  });

  // RA §15, RA-26: on an order the WhatsApp text names the order.
  testWidgets('the order problem sheet’s WhatsApp tile names the order', (
    tester,
  ) async {
    final app = _Board();
    final launched = <Uri>[];
    app.server.on('/v1/merchant/contact', [
      const FakeAnswer(200, {'whatsapp': '+963955000000'}),
    ]);
    await app.pump(
      tester,
      [
        FakeAnswer(
          200,
          boardJson([
            orderJson(
              status: 'accepted',
              version: 2,
              acceptedAfter: Duration.zero,
            ),
          ]),
        ),
      ],
      overrides: [
        merchantAuth.launch.overrideWithValue((uri) async {
          launched.add(uri);
          return true;
        }),
      ],
    );
    await app.up(tester);
    app.container.read(routerProvider).push('/orders/$_orderId');
    await tester.pumpAndSettle();
    final button = find.byKey(const Key('order-problem'));
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('whatsapp-operations')));
    await tester.pump();
    expect(
      launched.single.toString(),
      'https://wa.me/963955000000?text=${Uri.encodeQueryComponent('بخصوص الطلب #10001')}',
    );
    await app.done(tester);
  });

  // RA §4.7, architecture §11.2 (slice 2.42): a command a restart
  // interrupted is sent again with its key, shows «جارٍ الإرسال…» meanwhile,
  // and leaves the queue once answered.
  testWidgets('a command a restart interrupted goes again with its key', (
    tester,
  ) async {
    final store = MemoryDeviceStore();
    final queue = CommandQueue(store);
    await queue.put(
      QueuedCommand(
        key: 'key-before-restart',
        kind: 'accept',
        subject: _orderId,
        accountId: _accountId,
        args: const {'prepMin': 25},
        queuedAt: DateTime.now().toUtc(),
      ),
    );
    final app = _Board();
    final accepted = orderJson(
      status: 'accepted',
      version: 2,
      acceptedAfter: const Duration(minutes: 1),
    );
    app.server.on('/v1/merchant/orders/$_orderId/accept', [
      FakeAnswer(200, {'order': accepted}),
    ]);
    await app.pump(
      tester,
      [
        FakeAnswer(200, boardJson([orderJson()])),
        FakeAnswer(200, boardJson([accepted])),
      ],
      overrides: [commandQueueProvider.overrideWithValue(queue)],
    );
    await app.up(tester);
    final sent = app.server.to('/v1/merchant/orders/$_orderId/accept').single;
    expect(sent.headers['Idempotency-Key'], 'key-before-restart');
    expect(sent.data, {'prepMin': 25});
    expect(await queue.pending(DateTime.now().toUtc()), isEmpty);
    await app.done(tester);
  });
}
