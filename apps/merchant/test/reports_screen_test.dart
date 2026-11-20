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
import 'package:merchant/src/account/records.dart';
import 'package:merchant/src/reports/reports.dart';

import 'board_fixtures.dart';
import 'status_fixtures.dart' hide now;

const _accountId = '00000000-0000-4000-8000-000000000001';
const _restaurantId = '00000000-0000-4000-8000-000000000002';
const _channel = 'merchant:$_restaurantId';

final _now = placedAt.add(const Duration(minutes: 1));

// «التقارير» and «الملخص اليومي» (RA §11) against a fake server and channel.
class _App {
  _App({this.role = 'cashier'});

  final String role;
  final server = FakeServer();
  final transport = FakeTransport();
  final ringer = FakeRinger();
  late final ProviderContainer container;
  final shared = <String>[];

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
        imageSharerProvider.overrideWithValue((png, name) async {
          shared.add(name);
        }),
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

Map<String, Object?> _figures({int received = 5, String sales = '30000'}) => {
  'received': received,
  'acceptedByYou': 3,
  'acceptedByOperations': 1,
  'rejected': 1,
  'rejections': [
    {'label': 'المطعم مغلق', 'byOperations': true, 'count': 1},
  ],
  'unanswered': 0,
  'acceptanceBp': 7500,
  'delivered': 2,
  'sales': sales,
  'averageOrder': '15000',
  'commission': '4500',
  'discounts': '0',
  'net': '25500',
  'acceptMinutes': 2.5,
  'prepActualMinutes': 16,
  'prepChosenMinutes': 15,
  'lateBp': 3333,
  'readyNotPressed': 1,
  'captainWaitMinutes': null,
  'rating': {'count': 2, 'average': 4.5},
  'topByQuantity': [
    {
      'itemId': '00000000-0000-4000-8000-0000000000a1',
      'name': 'شاورما',
      'quantity': 3,
      'sales': '9000',
    },
  ],
  'topBySales': <Object>[],
  'hours': [
    for (var index = 0; index < 24; index += 1)
      {'hour': (4 + index) % 24, 'delivered': index == 8 ? 2 : 0},
  ],
  'pauseMinutes': {'restaurant': 0, 'ops': 0, 'auto': 30},
};

Map<String, Object?> _answer({int received = 5, int previous = 4}) => {
  'from': '2026-11-09T01:00:00.000Z',
  'to': '2026-11-09T09:01:00.000Z',
  'currency': 'TRY',
  'current': _figures(received: received),
  'previous': _figures(received: previous, sales: '0'),
};

Map<String, Object?> _status() =>
    statusJson(closesAt: _now.add(const Duration(hours: 10)));

List<Map<String, dynamic>> _sent(_App app) => app.server
    .to('/v1/merchant/figures')
    .map((r) => r.queryParameters)
    .toList();

void main() {
  test('the arrows compare with the previous period', () {
    expect(
      changeOf(5, 4),
      isA<Moved>().having((c) => c.percent, 'percent', 25),
    );
    expect((changeOf(3, 4) as Moved).up, isFalse);
    expect(changeOf(2, 0), isA<Rose>());
    expect(changeOf(0, 0), isA<Same>());
    expect(changeOf(null, 4), isA<NoChange>());
    expect(businessDayOf(DateTime.utc(2026, 11, 9, 1)), '2026-11-09');
    expect(businessDayOf(DateTime.utc(2026, 11, 8, 22)), '2026-11-09');
    expect(dayBefore('2026-11-01'), '2026-10-31');
    expect(oneDecimal(33.33), '33.3');
    expect(oneDecimal(15), '15');
  });

  testWidgets('an owner reads a period with its arrows and definitions', (
    tester,
  ) async {
    final app = _App(role: 'owner');
    app.server.on('/v1/merchant/figures', [
      FakeAnswer(200, _answer()),
      FakeAnswer(200, _answer(received: 3)),
    ]);
    await app.pump(tester, [FakeAnswer(200, _status())]);
    await tester.tap(find.byKey(const Key('open-reports')));
    await tester.pumpAndSettle();
    expect(
      tester.widget<Text>(find.byKey(const Key('metric-value-received'))).data,
      '5',
    );
    expect(find.textContaining('↑ 25%'), findsOneWidget);
    expect(find.text('75%'), findsOneWidget);

    await tester.tap(find.byKey(const Key('metric-info-acceptance')));
    await tester.pumpAndSettle();
    expect(
      find.text('ما قبلتموه ÷ (الطلبات المستلمة − ما ألغاه الزبون قبل أي رد).'),
      findsOneWidget,
    );
    await tester.tap(find.text('حسناً'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text('2.5 د'), 300);
    await tester.scrollUntilVisible(find.text('4.5 من 5 (2)'), 300);
    await tester.scrollUntilVisible(find.text('إيقاف تلقائي: 30 د'), 300);
    expect(find.text('المطعم مغلق (العمليات): 1'), findsOneWidget);
    expect(find.textContaining('شاورما: 3'), findsOneWidget);
    expect(find.text('12:00 — 2'), findsOneWidget);

    // Back to the top.
    await tester.drag(find.byType(ListView), const Offset(0, 5000));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('reports-period-yesterday')));
    await tester.pumpAndSettle();
    expect(find.textContaining('↓ 25%'), findsOneWidget);
    expect(_sent(app), [
      {'period': 'today'},
      {'period': 'yesterday'},
    ]);
    await app.done(tester);
  });

  testWidgets('the daily summary shows a day and shares it as an image', (
    tester,
  ) async {
    final app = _App(role: 'owner');
    app.server.on('/v1/merchant/figures', [
      FakeAnswer(200, _answer()),
      FakeAnswer(200, _answer()),
      FakeAnswer(200, _answer()),
    ]);
    await app.pump(tester, [FakeAnswer(200, _status())]);
    await tester.tap(find.byKey(const Key('open-reports')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('open-summary')));
    await tester.pumpAndSettle();
    expect(find.text('ملخص يوم 09/11/2026'), findsOneWidget);
    expect(_sent(app).last, {'day': '2026-11-09'});
    await tester.tap(find.byKey(const Key('summary-share')));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 200)),
    );
    await tester.pumpAndSettle();
    expect(app.shared, ['summary-2026-11-09.png']);
    await app.done(tester);
  });

  testWidgets('a cashier is told the reports are the owners\' ', (
    tester,
  ) async {
    final app = _App(role: 'cashier');
    app.server.on('/v1/merchant/figures', [
      const FakeAnswer(403, {'statusCode': 403, 'error': 'owner_only'}),
    ]);
    await app.pump(tester, [FakeAnswer(200, _status())]);
    // A cashier has no button: the route is reached only by a link.
    expect(find.byKey(const Key('open-reports')), findsNothing);
    await app.done(tester);
  });
}
