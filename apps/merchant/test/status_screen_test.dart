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

// The status pill, sheet, banners and chimes (RA §6.2–6.3, §7.1–7.3, §16)
// and «الحالة والأوقات» (RA §10), against a fake server and channel.
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

Map<String, Object?> _open({int? busyMode}) => statusJson(
  closesAt: _now.add(const Duration(hours: 10)),
  busyMode: busyMode,
);

void main() {
  testWidgets('a cashier pauses for 30 minutes from the pill, then resumes', (
    tester,
  ) async {
    final app = _App();
    final paused = statusJson(
      state: 'paused',
      pauseSource: 'restaurant',
      stateUntil: _now.add(const Duration(minutes: 30)),
      closesAt: _now.add(const Duration(hours: 10)),
    );
    await app.pump(tester, [FakeAnswer(200, _open())]);
    expect(find.text('مفتوح'), findsOneWidget);

    await tester.tap(find.byKey(const Key('status-pill')));
    await tester.pumpAndSettle();
    // Noon UTC is 3:01 م in Azaz; the period closes 10 hours later.
    expect(find.text('يغلق اليوم 1:01 ص'), findsNothing);
    expect(find.byKey(const Key('status-next')), findsOneWidget);
    expect(find.byKey(const Key('resume')), findsNothing);

    app.server.on('/v1/merchant/restaurant/status/pause', [
      FakeAnswer(200, paused),
    ]);
    await tester.tap(find.byKey(const Key('pause-30')));
    await tester.pumpAndSettle();
    expect(app.server.to('/v1/merchant/restaurant/status/pause').single.data, {
      'minutes': 30,
    });
    expect(find.text('موقوف مؤقتاً'), findsWidgets);
    expect(find.text('ينتهي الإيقاف اليوم 3:31 م'), findsOneWidget);

    app.server.on('/v1/merchant/restaurant/status/resume', [
      FakeAnswer(200, _open()),
    ]);
    await tester.tap(find.byKey(const Key('resume')));
    await tester.pumpAndSettle();
    expect(find.text('مفتوح'), findsWidgets);
    await app.done(tester);
  });

  testWidgets('operations’ pause locks the sheet and shows the red banner', (
    tester,
  ) async {
    final app = _App();
    await app.pump(tester, [
      FakeAnswer(200, statusJson(state: 'paused', pauseSource: 'ops')),
    ]);
    expect(
      find.byKey(const Key('status-banner-pausedByOperations')),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('status-pill')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('status-locked')), findsOneWidget);
    final pause = tester.widget<OutlinedButton>(
      find.byKey(const Key('pause-15')),
    );
    expect(pause.onPressed, isNull);
    await app.done(tester);
  });

  testWidgets('the limit and busy mode show their amber banners', (
    tester,
  ) async {
    final app = _App();
    await app.pump(tester, [
      FakeAnswer(
        200,
        statusJson(
          state: 'busy',
          busyMode: 20,
          activeOrders: 3,
          maxActiveOrders: 3,
        ),
      ),
    ]);
    expect(
      find.text(
        'وصلت إلى الحد الأقصى (3 طلبات جارية). لن تصلك طلبات جديدة حتى يُستلم أحدها.',
      ),
      findsOneWidget,
    );
    expect(find.byKey(const Key('status-banner-busyMode')), findsOneWidget);
    expect(find.text('مشغول'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('a state change reads the status again; the reminder chimes', (
    tester,
  ) async {
    final app = _App();
    await app.pump(tester, [FakeAnswer(200, _open(busyMode: 10))]);
    expect(find.text('وضع الضغط +10 د'), findsOneWidget);
    final reads = app.server.to('/v1/merchant/restaurant/status').length;
    app.transport.send(
      _channel,
      const RealtimePublication({
        'type': 'restaurant.state_changed',
        'kind': 'busy_reminder',
        'values': {'extraMin': 10},
      }),
    );
    await tester.pumpAndSettle();
    expect(app.server.to('/v1/merchant/restaurant/status').length, reads + 1);
    expect(app.ringer.chimes, 1);
    expect(find.text('وضع الضغط ما زال مفعّلاً (+10 د)'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('an owner adds a second period and saves the week', (
    tester,
  ) async {
    final app = _App(role: 'owner');
    final hours = {
      'periods': [
        {'weekday': 5, 'opensAt': 720, 'closesAt': 900},
      ],
      'holiday': null,
      'defaultPrepMin': 20,
      'prepFloorMin': 5,
      'prepCeilingMin': 90,
      'maxActiveOrders': null,
      'minimumOrder': {'amount': '10000', 'currency': 'TRY'},
      'coverage': {'kind': 'radius', 'radiusMetres': 3000, 'zoneCount': null},
      'commissionBp': 1500,
      'settlementWeekday': 'saturday',
    };
    app.server.on('/v1/merchant/restaurant/hours', [FakeAnswer(200, hours)]);
    await app.pump(tester, [FakeAnswer(200, _open())]);
    await tester.tap(find.byKey(const Key('open-status-and-hours')));
    await tester.pumpAndSettle();
    expect(find.text('الحالة والأوقات'), findsOneWidget);
    expect(find.text('مغلق طوال اليوم'), findsNWidgets(6));

    // Friday: a second period after the first, 15:00 to 16:00.
    await tester.tap(find.byKey(const Key('add-period-5')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('save-schedule')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-schedule')));
    await tester.pumpAndSettle();
    final sent = app.server
        .to('/v1/merchant/restaurant/hours')
        .where((r) => r.method == 'PUT')
        .single;
    expect(sent.data, {
      'periods': [
        {'weekday': 5, 'opensAt': 720, 'closesAt': 900},
        {'weekday': 5, 'opensAt': 900, 'closesAt': 960},
      ],
    });
    expect(find.text('حُفظ التعديل'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('a cashier sees the status only on «الحالة والأوقات»', (
    tester,
  ) async {
    final app = _App();
    await app.pump(tester, [FakeAnswer(200, _open())]);
    await tester.tap(find.byKey(const Key('open-status-and-hours')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('hours-status')), findsOneWidget);
    expect(find.byKey(const Key('save-schedule')), findsNothing);
    expect(app.server.to('/v1/merchant/restaurant/hours'), isEmpty);
    await app.done(tester);
  });

  test('the board screen still builds without a status', () {
    expect(const BoardScreen(), isNotNull);
  });
}
