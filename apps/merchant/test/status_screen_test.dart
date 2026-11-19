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

  // RA §12.7, §14.3: the owners' «العملات التي تقبلها من الكابتن».
  testWidgets('an owner switches USD on in «الإعدادات», the base fixed', (
    tester,
  ) async {
    final app = _App(role: 'owner');
    Map<String, Object?> currencies(List<String> accepted) => {
      'baseCurrency': {'currency': 'TRY', 'name': 'ليرة تركية'},
      'accepted': accepted,
      'choices': [
        {'currency': 'USD', 'name': 'دولار أمريكي'},
      ],
    };
    app.server.on('/v1/merchant/settings/pickup-currencies', [
      FakeAnswer(200, currencies([])),
      FakeAnswer(200, currencies(['USD'])),
    ]);
    await app.pump(tester, [FakeAnswer(200, _open())]);
    await tester.tap(find.byKey(const Key('open-settings')));
    await tester.pumpAndSettle();
    expect(find.text('العملات التي تقبلها من الكابتن'), findsOneWidget);
    expect(find.text('العملة الأساسية، مقبولة دائماً'), findsOneWidget);
    final base = tester.widget<SwitchListTile>(
      find.byKey(const Key('pickup-currency-TRY')),
    );
    expect((base.value, base.onChanged), (true, null));
    expect(
      tester
          .widget<SwitchListTile>(find.byKey(const Key('pickup-currency-USD')))
          .value,
      isFalse,
    );

    await tester.tap(find.byKey(const Key('pickup-currency-USD')));
    await tester.pumpAndSettle();
    final sent = app.server
        .to('/v1/merchant/settings/pickup-currencies')
        .where((r) => r.method == 'PUT')
        .single;
    expect(sent.data, {
      'currencies': ['USD'],
    });
    expect(
      tester
          .widget<SwitchListTile>(find.byKey(const Key('pickup-currency-USD')))
          .value,
      isTrue,
    );
    await app.done(tester);
  });

  testWidgets('a refused change says so and reads the switches again', (
    tester,
  ) async {
    final app = _App(role: 'owner');
    const read = {
      'baseCurrency': {'currency': 'TRY', 'name': 'ليرة تركية'},
      'accepted': <String>[],
      'choices': [
        {'currency': 'USD', 'name': 'دولار أمريكي'},
      ],
    };
    app.server.on('/v1/merchant/settings/pickup-currencies', [
      const FakeAnswer(200, read),
      const FakeAnswer(400, {'error': 'invalid_pickup_currencies'}),
      const FakeAnswer(200, read),
    ]);
    await app.pump(tester, [FakeAnswer(200, _open())]);
    await tester.tap(find.byKey(const Key('open-settings')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('pickup-currency-USD')));
    await tester.pumpAndSettle();
    expect(find.text('لم يُحفظ التغيير، حاول مرة أخرى'), findsOneWidget);
    expect(
      app.server
          .to('/v1/merchant/settings/pickup-currencies')
          .map((r) => r.method),
      ['GET', 'PUT', 'GET'],
    );
    expect(
      tester
          .widget<SwitchListTile>(find.byKey(const Key('pickup-currency-USD')))
          .value,
      isFalse,
    );
    await app.done(tester);
  });

  testWidgets('the switches wait for a save’s answer', (tester) async {
    final app = _App(role: 'owner');
    Map<String, Object?> currencies(List<String> accepted) => {
      'baseCurrency': {'currency': 'TRY', 'name': 'ليرة تركية'},
      'accepted': accepted,
      'choices': [
        {'currency': 'USD', 'name': 'دولار أمريكي'},
        {'currency': 'SYP', 'name': 'ليرة سورية'},
      ],
    };
    app.server.on('/v1/merchant/settings/pickup-currencies', [
      FakeAnswer(200, currencies([])),
      FakeAnswer(200, currencies(['USD'])),
    ]);
    await app.pump(tester, [FakeAnswer(200, _open())]);
    await tester.tap(find.byKey(const Key('open-settings')));
    await tester.pumpAndSettle();
    final gate = app.server.gate = Completer<void>();
    await tester.tap(find.byKey(const Key('pickup-currency-USD')));
    await tester.pump();
    SwitchListTile tile(String code) =>
        tester.widget<SwitchListTile>(find.byKey(Key('pickup-currency-$code')));
    expect(tile('SYP').onChanged, isNull);
    app.server.gate = null;
    gate.complete();
    await tester.pumpAndSettle();
    expect((tile('USD').value, tile('SYP').onChanged != null), (true, true));
    await app.done(tester);
  });

  testWidgets('a refused read says the settings are the owners’', (
    tester,
  ) async {
    final app = _App(role: 'owner');
    app.server.on('/v1/merchant/settings/pickup-currencies', [
      const FakeAnswer(403, {'error': 'restaurant_terminated'}),
    ]);
    await app.pump(tester, [FakeAnswer(200, _open())]);
    await tester.tap(find.byKey(const Key('open-settings')));
    await tester.pumpAndSettle();
    expect(find.text('هذه الإعدادات لمالكي المطعم فقط.'), findsOneWidget);
    expect(find.text('إعادة المحاولة'), findsNothing);
    await app.done(tester);
  });

  // RA §14.1: the owners' «الموظفون» (owner decision 2026-11-19).
  testWidgets('an owner adds a cashier and removes them after confirming', (
    tester,
  ) async {
    final app = _App(role: 'owner');
    Map<String, Object?> member(String id, String role, String name) => {
      'accountId': id,
      'role': role,
      'name': name,
      'phone': '+963900000$id',
      'devices': role == 'owner' ? 1 : 0,
      'lastActiveAt': role == 'owner' ? '2026-11-19T09:00:00.000Z' : null,
    };
    final owner = member('001', 'owner', 'ليلى');
    final cashier = member('002', 'cashier', 'سامر');
    app.server
      ..on('/v1/merchant/settings/pickup-currencies', [
        const FakeAnswer(200, {
          'baseCurrency': null,
          'accepted': <String>[],
          'choices': <Object>[],
        }),
      ])
      ..on('/v1/merchant/staff', [
        FakeAnswer(200, {
          'staff': [owner],
        }),
        const FakeAnswer(409, {'error': 'phone_taken'}),
        FakeAnswer(200, {
          'staff': [owner, cashier],
        }),
      ])
      ..on('/v1/merchant/staff/002/remove', [
        FakeAnswer(200, {
          'staff': [owner],
        }),
      ]);
    await app.pump(tester, [FakeAnswer(200, _open())]);
    await tester.tap(find.byKey(const Key('open-settings')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('open-staff')));
    await tester.pumpAndSettle();
    expect(
      find.text('لإضافة مالك أو إزالته تواصل مع FOX DROP'),
      findsOneWidget,
    );
    expect(find.text('ليلى'), findsOneWidget);
    expect(find.textContaining('\u2066+963900000001\u2069'), findsOneWidget);
    // Owners are read-only (RA §5.1).
    expect(find.byKey(const Key('remove-001')), findsNothing);

    await tester.tap(find.byKey(const Key('add-cashier')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('cashier-name')), 'سامر');
    await tester.enterText(find.byKey(const Key('cashier-phone')), '123');
    await tester.tap(find.byKey(const Key('cashier-add')));
    await tester.pumpAndSettle();
    expect(find.text('رقم الهاتف غير صحيح'), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('cashier-phone')),
      '0912 345 678',
    );
    await tester.tap(find.byKey(const Key('cashier-add')));
    await tester.pumpAndSettle();
    expect(
      find.text('هذا الرقم مسجّل لدى مطعم آخر أو موظف آخر'),
      findsOneWidget,
    );
    final sent = app.server
        .to('/v1/merchant/staff')
        .where((r) => r.method == 'POST')
        .first;
    expect(sent.data, {'name': 'سامر', 'phone': '+963912345678'});
    // A refused number changes nothing; another one is added.
    expect(find.text('سامر'), findsNothing);
    await tester.tap(find.byKey(const Key('add-cashier')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('cashier-name')), 'سامر');
    await tester.enterText(
      find.byKey(const Key('cashier-phone')),
      '0912345679',
    );
    await tester.tap(find.byKey(const Key('cashier-add')));
    await tester.pumpAndSettle();
    expect(find.text('سامر'), findsOneWidget);

    await tester.tap(find.byKey(const Key('remove-002')));
    await tester.pumpAndSettle();
    expect(
      find.text('حذف سامر؟ سيُسجَّل خروجه من كل أجهزته فوراً.'),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('confirm')));
    await tester.pumpAndSettle();
    expect(app.server.to('/v1/merchant/staff/002/remove'), hasLength(1));
    expect(find.text('سامر'), findsNothing);
    await app.done(tester);
  });

  // RA §14.2: the owners' «الأجهزة».
  testWidgets('an owner renames a device and signs it out', (tester) async {
    final app = _App(role: 'owner');
    Map<String, Object?> device(String name, {required bool signedIn}) => {
      'deviceId': 'kitchen',
      'name': name,
      'platform': 'android',
      'appVersion': '1.2.0',
      'user': {'name': 'سامر', 'role': 'cashier'},
      'signedIn': signedIn,
      'lastSeenAt': '2026-11-19T09:00:00.000Z',
      'ringing': null,
      'deviceCheck': null,
      'thisDevice': false,
    };
    app.server
      ..on('/v1/merchant/settings/pickup-currencies', [
        const FakeAnswer(200, {
          'baseCurrency': null,
          'accepted': <String>[],
          'choices': <Object>[],
        }),
      ])
      ..on('/v1/merchant/devices', [
        FakeAnswer(200, {
          'devices': [device('كاشير 1', signedIn: true)],
        }),
      ])
      ..on('/v1/merchant/devices/kitchen/name', [
        FakeAnswer(200, {
          'devices': [device('تابلت المطبخ', signedIn: true)],
        }),
      ])
      ..on('/v1/merchant/devices/kitchen/sign-out', [
        FakeAnswer(200, {
          'devices': [device('تابلت المطبخ', signedIn: false)],
        }),
      ]);
    await app.pump(tester, [FakeAnswer(200, _open())]);
    await tester.tap(find.byKey(const Key('open-settings')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('open-devices')));
    await tester.pumpAndSettle();
    expect(find.text('كاشير 1'), findsOneWidget);
    expect(find.textContaining('سامر (كاشير)'), findsOneWidget);
    expect(find.textContaining('أندرويد · الإصدار 1.2.0'), findsOneWidget);

    await tester.tap(find.byKey(const Key('rename-kitchen')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('device-name')),
      'تابلت المطبخ',
    );
    await tester.tap(find.byKey(const Key('device-name-save')));
    await tester.pumpAndSettle();
    expect(app.server.to('/v1/merchant/devices/kitchen/name').single.data, {
      'name': 'تابلت المطبخ',
    });
    expect(find.text('تابلت المطبخ'), findsOneWidget);

    await tester.tap(find.byKey(const Key('sign-out-kitchen')));
    await tester.pumpAndSettle();
    expect(
      find.text('تسجيل خروج «تابلت المطبخ»؟ يبقى المستخدم في الموظفين.'),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('confirm')));
    await tester.pumpAndSettle();
    expect(
      app.server.to('/v1/merchant/devices/kitchen/sign-out'),
      hasLength(1),
    );
    expect(find.textContaining('غير مسجّل الدخول'), findsOneWidget);
    expect(find.byKey(const Key('sign-out-kitchen')), findsNothing);
    await app.done(tester);
  });

  testWidgets('a cashier has no «الإعدادات»', (tester) async {
    final app = _App();
    await app.pump(tester, [FakeAnswer(200, _open())]);
    expect(find.byKey(const Key('open-settings')), findsNothing);
    await app.done(tester);
  });

  test('the board screen still builds without a status', () {
    expect(const BoardScreen(), isNotNull);
  });
}
