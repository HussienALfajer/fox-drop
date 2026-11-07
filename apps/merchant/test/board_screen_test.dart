import 'dart:convert';

import 'package:core_auth/testing.dart';
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
}
