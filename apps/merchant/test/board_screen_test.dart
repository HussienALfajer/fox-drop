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
import 'package:merchant/src/board/commands.dart';
import 'package:merchant/src/device.dart';
import 'package:merchant/src/push.dart';
import 'package:merchant/src/router.dart';

import 'board_fixtures.dart';

const _accountId = '00000000-0000-4000-8000-000000000001';
const _restaurantId = '00000000-0000-4000-8000-000000000002';
const _channel = 'merchant:$_restaurantId';
const _orderId = '00000000-0000-4000-8000-0000000000a1';

// The board on a phone (RA §4.3–4.7, §8.2–8.10), signed in, against a fake
// server and a fake real-time channel.
class _Board {
  final server = FakeServer();
  final transport = FakeTransport();
  final ringer = FakeRinger();
  late final ProviderContainer container;

  Future<void> pump(WidgetTester tester, List<FakeAnswer> boards) async {
    server.on('/v1/merchant/auth/session', [
      const FakeAnswer(200, {
        'accountId': _accountId,
        'restaurantId': _restaurantId,
        'role': 'cashier',
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
        keepScreenOnProvider.overrideWithValue((on) {}),
        notificationPermissionProvider.overrideWithValue(
          FakeNotificationPermission(allowed: true),
        ),
        deviceStoreProvider.overrideWithValue(MemoryDeviceStore()),
        // A minute after the fixtures' order was placed.
        serverClockProvider.overrideWithValue(
          ServerClock(
            deviceNow: () => placedAt.add(const Duration(minutes: 1)),
          ),
        ),
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
}
