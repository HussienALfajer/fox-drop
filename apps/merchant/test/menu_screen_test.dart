import 'dart:convert';

import 'package:core_auth/testing.dart';
import 'package:core_push/testing.dart';
import 'package:core_realtime/core_realtime.dart';
import 'package:core_storage/core_storage.dart';
import 'package:core_time/core_time.dart';
import 'package:dio/dio.dart';
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
import 'package:merchant/src/menu/menu.dart';

import 'board_fixtures.dart';
import 'status_fixtures.dart' hide now;

const _accountId = '00000000-0000-4000-8000-000000000001';
const _restaurantId = '00000000-0000-4000-8000-000000000002';
const _channel = 'merchant:$_restaurantId';

final _now = placedAt.add(const Duration(minutes: 1));

// «القائمة» (RA §9, slice 2.32a) against a fake server and channel.
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

const _meals = '10000000-0000-4000-8000-000000000001';
const _drinks = '10000000-0000-4000-8000-000000000002';
const _shawarma = '20000000-0000-4000-8000-000000000001';
const _falafel = '20000000-0000-4000-8000-000000000002';
const _ayran = '20000000-0000-4000-8000-000000000003';
const _large = '30000000-0000-4000-8000-000000000001';

Map<String, Object?> _money(String amount) => {
  'amount': amount,
  'currency': 'TRY',
};

Map<String, Object?> _item(
  String id,
  String name,
  String price, {
  Map<String, Object?>? switchedOff,
  bool hidden = false,
  List<Map<String, Object?>> groups = const [],
}) => {
  'id': id,
  'code': 'I-$name',
  'name': name,
  'description': null,
  'price': _money(price),
  'available': switchedOff == null,
  'switchedOff': switchedOff,
  'hidden': hidden,
  'optionGroups': groups,
};

Map<String, Object?> _menu({
  String shawarma = '10000',
  Map<String, Object?>? falafelOff,
  List<String> order = const [_meals, _drinks],
}) {
  final categories = {
    _meals: {
      'id': _meals,
      'name': 'وجبات',
      'hidden': false,
      'available': true,
      'switchedOff': null,
      'window': null,
      'items': [
        _item(
          _shawarma,
          'شاورما',
          shawarma,
          groups: [
            {
              'id': '40000000-0000-4000-8000-000000000001',
              'name': 'الحجم',
              'minChoices': 1,
              'maxChoices': 1,
              'options': [
                {
                  'id': _large,
                  'name': 'كبير',
                  'priceDelta': _money('2000'),
                  'available': true,
                  'switchedOff': null,
                },
              ],
            },
          ],
        ),
        _item(_falafel, 'فلافل', '5000', switchedOff: falafelOff),
      ],
    },
    _drinks: {
      'id': _drinks,
      'name': 'مشروبات',
      'hidden': false,
      'available': true,
      'switchedOff': null,
      'window': {'startsAt': 360, 'endsAt': 720},
      'items': [_item(_ayran, 'عيران', '2500')],
    },
  };
  return {
    'categories': [for (final id in order) categories[id]],
  };
}

Map<String, Object?> _status() =>
    statusJson(closesAt: _now.add(const Duration(hours: 10)));

Future<void> _open(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('open-menu')));
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, String key) async {
  final finder = find.byKey(Key(key));
  // The menu's list builds its rows lazily.
  if (finder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find.byType(Scrollable).last,
    );
  }
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Map<String, dynamic> _body(RequestOptions request) => request.data is String
    ? jsonDecode(request.data as String) as Map<String, dynamic>
    : Map<String, dynamic>.from(request.data as Map);

void main() {
  testWidgets(
    'a cashier switches an item off «حتى الغد» and sees no prices to edit',
    (tester) async {
      final app = _App();
      final tomorrow = {'until': '2026-11-08T03:00:00.000Z'};
      app.server
        ..on('/v1/merchant/menu', [
          FakeAnswer(200, _menu()),
          FakeAnswer(200, _menu(falafelOff: tomorrow)),
        ])
        ..on('/v1/merchant/menu/availability', [
          FakeAnswer(200, {'switchedOff': tomorrow}),
        ]);
      await app.pump(tester, [FakeAnswer(200, _status())]);
      await _open(tester);
      expect(find.text('شاورما'), findsOneWidget);
      expect(
        find.textContaining('متوفر من 6:00 ص إلى 12:00 م'),
        findsOneWidget,
      );
      // RA §6: availability only.
      expect(find.byKey(const Key('price-item-$_shawarma')), findsNothing);
      expect(find.byKey(const Key('hide-item-$_shawarma')), findsNothing);
      expect(find.byKey(const Key('menu-bulk')), findsNothing);

      await _tap(tester, 'switch-item-$_falafel');
      await _tap(tester, 'off-tomorrow');
      final sent = app.server.to('/v1/merchant/menu/availability');
      expect(sent, hasLength(1));
      expect(_body(sent.single), {
        'type': 'item',
        'id': _falafel,
        'available': false,
        'until': 'tomorrow',
      });
      expect(find.textContaining('متوقف حتى الغد'), findsOneWidget);
      await app.done(tester);
    },
  );

  testWidgets('an owner edits a price with the parity reminder', (
    tester,
  ) async {
    final app = _App(role: 'owner');
    app.server
      ..on('/v1/merchant/menu', [FakeAnswer(200, _menu())])
      ..on('/v1/merchant/menu/items/$_shawarma/price', [
        FakeAnswer(200, _menu(shawarma: '14000')),
      ]);
    await app.pump(tester, [FakeAnswer(200, _status())]);
    await _open(tester);
    await _tap(tester, 'price-item-$_shawarma');
    expect(
      find.text('تذكير: سعر التطبيق يجب ألا يزيد على سعر المحل'),
      findsOneWidget,
    );
    await tester.enterText(find.byKey(const Key('price-field')), '0');
    await _tap(tester, 'price-save');
    expect(find.text('أدخل سعراً صحيحاً'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('price-field')), '140');
    await _tap(tester, 'price-save');
    final sent = app.server.to('/v1/merchant/menu/items/$_shawarma/price');
    expect(_body(sent.single), {
      'price': {'amount': '14000', 'currency': 'TRY'},
    });
    expect(find.textContaining('140 ₺'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('an owner moves a category up and hides an item', (tester) async {
    final app = _App(role: 'owner');
    app.server
      ..on('/v1/merchant/menu', [FakeAnswer(200, _menu())])
      ..on('/v1/merchant/menu/category-order', [
        FakeAnswer(200, _menu(order: [_drinks, _meals])),
      ])
      ..on('/v1/merchant/menu/items/$_falafel/hidden', [
        FakeAnswer(200, _menu(order: [_drinks, _meals])),
      ]);
    await app.pump(tester, [FakeAnswer(200, _status())]);
    await _open(tester);
    await _tap(tester, 'up-category-$_drinks');
    expect(_body(app.server.to('/v1/merchant/menu/category-order').single), {
      'categoryIds': [_drinks, _meals],
    });
    await _tap(tester, 'hide-item-$_falafel');
    expect(
      _body(app.server.to('/v1/merchant/menu/items/$_falafel/hidden').single),
      {'hidden': true},
    );
    await app.done(tester);
  });

  testWidgets('an owner previews a bulk change and confirms it once', (
    tester,
  ) async {
    final app = _App(role: 'owner');
    app.server
      ..on('/v1/merchant/menu', [FakeAnswer(200, _menu())])
      ..on('/v1/merchant/menu/bulk-price/preview', [
        const FakeAnswer(200, {
          'currency': 'TRY',
          'roundingUnit': '100',
          'rows': [
            {
              'itemId': _shawarma,
              'code': 'I1',
              'name': 'شاورما',
              'categoryId': _meals,
              'before': '10000',
              'after': '11000',
            },
          ],
          'changed': 1,
          'unchanged': 0,
          'refused': 0,
        }),
      ])
      ..on('/v1/merchant/menu/bulk-price', [
        const FakeAnswer(200, {'changed': 1, 'unchanged': 0}),
      ]);
    await app.pump(tester, [FakeAnswer(200, _status())]);
    await _open(tester);
    await _tap(tester, 'menu-bulk');
    await tester.enterText(find.byKey(const Key('bulk-value')), '10');
    await _tap(tester, 'bulk-preview');
    expect(find.text('100 ₺ ← 110 ₺'), findsOneWidget);
    expect(
      _body(app.server.to('/v1/merchant/menu/bulk-price/preview').single),
      {
        'categoryId': null,
        'kind': 'percent',
        'direction': 'up',
        'value': '1000',
      },
    );
    await _tap(tester, 'bulk-confirm');
    final applied = app.server.to('/v1/merchant/menu/bulk-price');
    expect(applied, hasLength(1));
    expect(applied.single.headers['Idempotency-Key'], isNotEmpty);
    expect(find.text('عُدّلت أسعار 1 من الأصناف.'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets(
    'quick edit searches by name and the menu reads again on a change',
    (tester) async {
      final app = _App(role: 'owner');
      app.server.on('/v1/merchant/menu', [
        FakeAnswer(200, _menu()),
        FakeAnswer(200, _menu(shawarma: '12000')),
      ]);
      await app.pump(tester, [FakeAnswer(200, _status())]);
      await _open(tester);
      await _tap(tester, 'menu-quick-edit');
      expect(find.byKey(const Key('quick-$_large')), findsOneWidget);
      await tester.enterText(find.byKey(const Key('quick-search')), 'فلا');
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('quick-$_falafel')), findsOneWidget);
      expect(find.byKey(const Key('quick-$_shawarma')), findsNothing);
      await tester.enterText(find.byKey(const Key('quick-search')), '');
      app.transport.send(
        _channel,
        const RealtimePublication({
          'type': 'restaurant.state_changed',
          'kind': 'menu_changed',
          'values': <String, Object?>{},
        }),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('120 ₺'), findsOneWidget);
      await app.done(tester);
    },
  );

  testWidgets('the price log names the user or FOX DROP; the preview fades', (
    tester,
  ) async {
    final app = _App(role: 'owner');
    Map<String, Object?> entry(String id, String type, String? name) => {
      'id': id,
      'targetType': 'item',
      'targetId': _shawarma,
      'name': 'شاورما',
      'groupName': null,
      'oldPrice': _money('10000'),
      'newPrice': _money('14000'),
      'byType': type,
      'byName': name,
      'at': '2026-11-07T12:00:00.000Z',
    };
    app.server
      ..on('/v1/merchant/menu', [FakeAnswer(200, _menu())])
      ..on('/v1/merchant/menu/price-log', [
        FakeAnswer(200, {
          'entries': [
            entry('50000000-0000-4000-8000-000000000001', 'merchant', 'ليلى'),
            entry('50000000-0000-4000-8000-000000000002', 'admin', null),
          ],
        }),
      ])
      ..on('/v1/merchant/menu/customer-preview', [
        FakeAnswer(200, {
          'menu': [
            {
              'id': _meals,
              'name': 'وجبات',
              'window': null,
              'items': [
                {
                  'id': _falafel,
                  'name': 'فلافل',
                  'description': null,
                  'photoKey': null,
                  'price': _money('5000'),
                  'fromPrice': null,
                  'available': false,
                  'unavailableReason': 'tomorrow',
                  'optionGroups': <Object?>[],
                },
              ],
            },
          ],
        }),
      ]);
    await app.pump(tester, [FakeAnswer(200, _status())]);
    await _open(tester);
    await _tap(tester, 'menu-price-log');
    expect(find.textContaining('ليلى · 07/11/2026'), findsOneWidget);
    expect(find.textContaining('FOX DROP · '), findsOneWidget);
    expect(find.textContaining('100 ₺ ← 140 ₺'), findsNWidgets(2));
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await _tap(tester, 'menu-preview');
    expect(find.textContaining('يتوفر غداً'), findsOneWidget);
    await app.done(tester);
  });

  test('the menu rules (RA §9.2–9.6)', () {
    expect(moved(['a', 'b', 'c'], 'b', -1), ['b', 'a', 'c']);
    expect(moved(['a', 'b'], 'a', -1), isNull);
    expect(basisPointsOf('12.5'), '1250');
    expect(basisPointsOf('0'), isNull);
    expect(basisPointsOf('1001'), isNull);
    expect(deltaOfTyped('0', 'TRY'), '0');
    expect(deltaOfTyped('2.5', 'TRY'), '250');
    expect(
      changesMenu({'type': 'restaurant.state_changed', 'kind': 'price_change'}),
      isTrue,
    );
    expect(
      changesMenu({'type': 'restaurant.state_changed', 'kind': 'auto_paused'}),
      isFalse,
    );
  });
}
