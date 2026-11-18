import 'dart:async';

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
import 'package:merchant/src/ratings/ratings.dart';

import 'board_fixtures.dart';
import 'status_fixtures.dart' hide now;

const _accountId = '00000000-0000-4000-8000-000000000001';
const _restaurantId = '00000000-0000-4000-8000-000000000002';
const _channel = 'merchant:$_restaurantId';

final _now = placedAt.add(const Duration(minutes: 1));

// «التقييمات» (RA §13) against a fake server and channel.
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

Map<String, Object?> _rating(
  int stars, {
  String? comment,
  List<String> reasons = const [],
}) => {
  'stars': stars,
  'reasons': [
    for (final label in reasons) {'code': 'code-$label', 'label': label},
  ],
  'comment': comment,
  'day': '2026-11-09',
};

const _asOf = '2026-11-09T09:01:00.000Z';

Map<String, Object?> _page(
  List<Map<String, Object?>> ratings, {
  bool more = false,
  int count = 3,
  num? average = 3.7,
}) => {
  'asOf': _asOf,
  'count': count,
  'average': average,
  'distribution': [
    {'stars': 5, 'count': 1},
    {'stars': 4, 'count': 1},
    {'stars': 3, 'count': 0},
    {'stars': 2, 'count': 1},
    {'stars': 1, 'count': 0},
  ],
  'ratings': ratings,
  'more': more,
};

Future<void> _open(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('open-ratings')));
  await tester.pumpAndSettle();
}

Future<void> _tapMore(WidgetTester tester) async {
  await tester.ensureVisible(find.byKey(const Key('ratings-more')));
  await tester.tap(find.byKey(const Key('ratings-more')));
  await tester.pump();
}

List<Map<String, dynamic>> _sent(_App app) => app.server
    .to('/v1/merchant/ratings')
    .map((r) => r.queryParameters)
    .toList();

Map<String, Object?> _status() =>
    statusJson(closesAt: _now.add(const Duration(hours: 10)));

void main() {
  test('the average drops a needless «.0»', () {
    expect(averageText(3.7), '3.7');
    expect(averageText(4), '4');
    expect(averageText(4.0), '4');
    expect(averageText(2.25), '2.3');
  });

  testWidgets('an owner reads the ratings, filters them and reads more', (
    tester,
  ) async {
    final app = _App(role: 'owner');
    app.server.on('/v1/merchant/ratings', [
      FakeAnswer(
        200,
        _page([
          _rating(5),
          _rating(2, comment: 'بارد', reasons: ['الطعام بارد', 'التغليف سيئ']),
        ], more: true),
      ),
      FakeAnswer(200, _page([_rating(4)])),
      FakeAnswer(200, _page([], count: 0, average: null)),
      FakeAnswer(200, _page([_rating(2)])),
    ]);
    await app.pump(tester, [FakeAnswer(200, _status())]);
    await _open(tester);
    expect(find.text('3.7 من 5'), findsOneWidget);
    expect(find.text('عدد التقييمات: 3'), findsOneWidget);
    expect(find.text('الطعام بارد، التغليف سيئ'), findsOneWidget);
    expect(find.text('«بارد»'), findsOneWidget);
    // The day only, never the time (RA §13).
    expect(find.text('09/11/2026'), findsNWidgets(2));
    expect(find.byKey(const Key('rating-2')), findsNothing);

    await _tapMore(tester);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('rating-2')), findsOneWidget);
    expect(find.byKey(const Key('ratings-more')), findsNothing);

    await tester.scrollUntilVisible(
      find.byKey(const Key('ratings-period-yesterday')),
      -200,
    );
    await tester.tap(find.byKey(const Key('ratings-period-yesterday')));
    await tester.pumpAndSettle();
    expect(find.text('لا تقييم بعد'), findsOneWidget);
    expect(find.text('لا تقييمات في هذه الفترة.'), findsOneWidget);

    await tester.tap(find.byKey(const Key('ratings-filter-2')));
    await tester.pumpAndSettle();
    expect(_sent(app), [
      {'period': 'all', 'page': 0},
      {'period': 'all', 'page': 1, 'asOf': _asOf},
      {'period': 'yesterday', 'page': 0},
      {'period': 'yesterday', 'stars': 2, 'page': 0},
    ]);
    expect(find.byKey(const Key('rating-0')), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('a next page answered after another filter is dropped', (
    tester,
  ) async {
    final app = _App(role: 'owner');
    app.server.on('/v1/merchant/ratings', [
      FakeAnswer(200, _page([_rating(5), _rating(4)], more: true)),
      // The gated next page takes its answer last, after the new first page.
      FakeAnswer(200, _page([_rating(3)], count: 1, average: 3)),
      FakeAnswer(200, _page([_rating(1), _rating(1), _rating(1)])),
    ]);
    await app.pump(tester, [FakeAnswer(200, _status())]);
    await _open(tester);
    final gate = app.server.gate = Completer<void>();
    await _tapMore(tester);
    // Held once it reaches the server; the first page after it is not.
    for (var tick = 0; tick < 50 && _sent(app).length < 2; tick += 1) {
      await tester.pump(const Duration(milliseconds: 10));
    }
    expect(_sent(app), hasLength(2));
    app.server.gate = null;
    await tester.scrollUntilVisible(
      find.byKey(const Key('ratings-period-today')),
      -200,
    );
    await tester.tap(find.byKey(const Key('ratings-period-today')));
    await tester.pumpAndSettle();
    expect(find.text('3 من 5'), findsWidgets);
    gate.complete();
    await tester.pumpAndSettle();
    expect(find.text('3 من 5'), findsWidgets);
    expect(find.byKey(const Key('rating-0')), findsOneWidget);
    expect(find.byKey(const Key('rating-1')), findsNothing);
    expect(find.text('1 من 5'), findsNothing);
    await app.done(tester);
  });

  testWidgets('a failed next page is tried again from its button', (
    tester,
  ) async {
    final app = _App(role: 'owner');
    app.server.on('/v1/merchant/ratings', [
      FakeAnswer(200, _page([_rating(5)], more: true)),
      const FakeAnswer(500, {'statusCode': 500}),
      FakeAnswer(200, _page([_rating(4)])),
      FakeAnswer(200, _page([_rating(2)])),
    ]);
    await app.pump(tester, [FakeAnswer(200, _status())]);
    await _open(tester);
    await _tapMore(tester);
    await tester.pumpAndSettle();
    expect(find.text('تعذّر التحميل، حاول مرة أخرى'), findsOneWidget);
    await _tapMore(tester);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('rating-1')), findsOneWidget);
    // «تحديث» reads the first page again.
    await tester.tap(find.byKey(const Key('ratings-refresh')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('rating-1')), findsNothing);
    expect(find.text('2 من 5'), findsOneWidget);
    expect(_sent(app).last, {'period': 'all', 'page': 0});
    await app.done(tester);
  });

  testWidgets('a cashier has no «التقييمات»', (tester) async {
    final app = _App();
    await app.pump(tester, [FakeAnswer(200, _status())]);
    expect(find.byKey(const Key('open-ratings')), findsNothing);
    await app.done(tester);
  });

  testWidgets('a terminated restaurant is told why it cannot read them', (
    tester,
  ) async {
    final app = _App(role: 'owner');
    app.server.on('/v1/merchant/ratings', [
      const FakeAnswer(403, {
        'statusCode': 403,
        'error': 'restaurant_terminated',
      }),
    ]);
    await app.pump(tester, [FakeAnswer(200, _status())]);
    await _open(tester);
    expect(
      find.text('انتهى حساب مطعمك، والتقييمات لم تعد متاحة.'),
      findsOneWidget,
    );
    await app.done(tester);
  });
}
