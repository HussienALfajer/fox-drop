import 'package:core_alerts/testing.dart';
import 'dart:convert';
import 'dart:typed_data';

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
import 'package:merchant/src/support/report_photo.dart';

import 'board_fixtures.dart';
import 'status_fixtures.dart' hide now;

const _accountId = '00000000-0000-4000-8000-000000000001';
const _restaurantId = '00000000-0000-4000-8000-000000000002';
const _channel = 'merchant:$_restaurantId';

final _now = placedAt.add(const Duration(minutes: 1));

// «القائمة» (RA §9, slice 2.32a) against a fake server and channel.
class _App {
  _App({this.role = 'cashier', this.ids = const []});

  /// The ids the app names its new rows with, in order (RA §9.2).
  final List<String> ids;
  final puts = <String>[];

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
        newMenuIdProvider.overrideWithValue(() => ids.removeAt(0)),
        photoPickerProvider.overrideWithValue(
          (source) async => PickedPhoto(
            Uint8List.fromList([0xff, 0xd8, 0xff, 0xe0, 1, 2, 3]),
            'image/jpeg',
          ),
        ),
        photoPutProvider.overrideWithValue((url, photo) async => puts.add(url)),
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
    'optionGroups': [
      {
        'id': _size,
        'name': 'الحجم',
        'minChoices': 1,
        'maxChoices': 1,
        'itemIds': [_shawarma],
        'options': [
          {
            'id': _large,
            'name': 'كبير',
            'priceDelta': _money('2000'),
            'switchedOff': null,
            'pending': <Object?>[],
          },
        ],
        'pending': <Object?>[],
      },
    ],
  };
}

const _size = '40000000-0000-4000-8000-000000000001';

// RA §9.5: a pending request as the server sends it beside its row.
Map<String, Object?> _pending(
  String id,
  String field, {
  String? name,
  String? description,
  String? photoKey,
}) => {
  'requestId': id,
  'field': field,
  'createdAt': '2026-11-07T09:00:00.000Z',
  'name': name,
  'description': description,
  'photoKey': photoKey,
  'price': null,
  'categoryId': null,
  'groupId': null,
  'minChoices': null,
  'maxChoices': null,
  'itemIds': null,
  'options': null,
};

// The menu with a change: `change` edits the JSON (a pending request, a new
// row waiting for review).
Map<String, Object?> _changed(void Function(Map<String, dynamic> menu) change) {
  final menu = jsonDecode(jsonEncode(_menu())) as Map<String, dynamic>;
  change(menu);
  return menu;
}

Map<String, dynamic> _category(Map<String, dynamic> menu, String id) =>
    (menu['categories'] as List).cast<Map<String, dynamic>>().firstWhere(
      (c) => c['id'] == id,
    );

Map<String, dynamic> _row(Map<String, dynamic> menu, String id) =>
    (menu['categories'] as List)
        .cast<Map<String, dynamic>>()
        .expand((c) => (c['items'] as List).cast<Map<String, dynamic>>())
        .firstWhere((i) => i['id'] == id);

Map<String, Object?> _status() =>
    statusJson(closesAt: _now.add(const Duration(hours: 10)));

Future<void> _open(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('open-menu')));
  await tester.pumpAndSettle();
}

// Scrolls the menu's lazy list to a row.
Future<void> _show(WidgetTester tester, String key) async {
  await tester.scrollUntilVisible(
    find.byKey(Key(key)),
    200,
    scrollable: find.byType(Scrollable).last,
  );
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
  await tester.pumpAndSettle();
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

  testWidgets(
    'an owner asks a new category and a new item with a photo (RA §9.2)',
    (tester) async {
      const desserts = '10000000-0000-4000-8000-000000000009';
      const kunafa = '20000000-0000-4000-8000-000000000009';
      final app = _App(role: 'owner', ids: [desserts, kunafa]);
      final withCategory = _changed(
        (menu) => (menu['categories'] as List).add({
          'id': desserts,
          'name': 'حلويات',
          'hidden': false,
          'available': false,
          'switchedOff': null,
          'window': null,
          'items': <Object?>[],
          'pending': [_pending('r1', 'created', name: 'حلويات')],
        }),
      );
      final withItem =
          jsonDecode(jsonEncode(withCategory)) as Map<String, dynamic>;
      (_category(withItem, desserts)['items'] as List).add({
        ..._item(kunafa, 'كنافة', '7500'),
        'available': false,
        'pending': [_pending('r2', 'created', name: 'كنافة')],
      });
      app.server
        ..on('/v1/merchant/menu', [FakeAnswer(200, _menu())])
        ..on('/v1/merchant/menu/requests/categories/$desserts', [
          FakeAnswer(200, withCategory),
        ])
        ..on('/v1/merchant/uploads/item-photo', [
          const FakeAnswer(201, {
            'uploadId': '50000000-0000-4000-8000-000000000001',
            'url': 'http://storage.test/public-media/incoming/a.jpg',
            'expiresAt': '2026-11-07T09:10:00.000Z',
          }),
        ])
        ..on('/v1/merchant/menu/requests/items/$kunafa', [
          FakeAnswer(200, withItem),
        ]);
      await app.pump(tester, [FakeAnswer(200, _status())]);
      await _open(tester);
      await _tap(tester, 'menu-add-category');
      await tester.enterText(find.byKey(const Key('request-name')), 'حلويات');
      await _tap(tester, 'request-send');
      expect(
        _body(
          app.server
              .to('/v1/merchant/menu/requests/categories/$desserts')
              .single,
        ),
        {'name': 'حلويات'},
      );
      await _show(tester, 'category-$desserts');
      expect(find.text('بانتظار المراجعة'), findsWidgets);
      // A new category has no switch, order or window until approved.
      expect(find.byKey(const Key('switch-category-$desserts')), findsNothing);
      expect(find.byKey(const Key('up-category-$desserts')), findsNothing);

      await _tap(tester, 'add-item-$desserts');
      await tester.enterText(find.byKey(const Key('item-name')), 'كنافة');
      await tester.enterText(find.byKey(const Key('item-price')), '75');
      await _tap(tester, 'item-photo');
      await _tap(tester, 'photo-gallery');
      expect(find.text('تم اختيار صورة'), findsOneWidget);
      await _tap(tester, 'item-send');
      expect(app.puts, ['http://storage.test/public-media/incoming/a.jpg']);
      expect(
        _body(app.server.to('/v1/merchant/menu/requests/items/$kunafa').single),
        {
          'categoryId': desserts,
          'name': 'كنافة',
          'description': null,
          'price': {'amount': '7500', 'currency': 'TRY'},
          'uploadId': '50000000-0000-4000-8000-000000000001',
        },
      );
      await _show(tester, 'item-$kunafa');
      expect(
        find.text('جديد — لا يراه الزبائن قبل الموافقة'),
        findsNWidgets(2),
      );
      expect(find.byKey(const Key('switch-item-$kunafa')), findsNothing);
      expect(find.byKey(const Key('edit-new-item-$kunafa')), findsOneWidget);
      await app.done(tester);
    },
  );

  testWidgets(
    'a pending name shows beside the old one; the owner withdraws it (RA §9.5)',
    (tester) async {
      final app = _App(role: 'owner');
      final renamed = _changed(
        (menu) => _row(menu, _shawarma)['pending'] = [
          _pending('r1', 'rename', name: 'شاورما دجاج'),
        ],
      );
      app.server
        ..on('/v1/merchant/menu', [FakeAnswer(200, _menu())])
        ..on('/v1/merchant/menu/requests/items/$_shawarma/text', [
          FakeAnswer(200, renamed),
        ])
        ..on('/v1/merchant/menu/requests/r1/withdraw', [
          FakeAnswer(200, _menu()),
        ]);
      await app.pump(tester, [FakeAnswer(200, _status())]);
      await _open(tester);
      await _tap(tester, 'text-item-$_shawarma');
      await tester.enterText(find.byKey(const Key('item-name')), 'شاورما دجاج');
      await _tap(tester, 'item-send');
      expect(
        _body(
          app.server
              .to('/v1/merchant/menu/requests/items/$_shawarma/text')
              .single,
        ),
        {'name': 'شاورما دجاج', 'description': null},
      );
      // The old name stays until approval, with the pending value.
      expect(find.text('شاورما'), findsOneWidget);
      expect(find.text('الاسم المطلوب: شاورما دجاج'), findsOneWidget);
      await _tap(tester, 'withdraw-r1');
      expect(
        app.server.to('/v1/merchant/menu/requests/r1/withdraw'),
        hasLength(1),
      );
      expect(find.text('الاسم المطلوب: شاورما دجاج'), findsNothing);
      await app.done(tester);
    },
  );

  testWidgets(
    'the form starts from the pending name, so a new description keeps it',
    (tester) async {
      final app = _App(role: 'owner');
      final renamed = _changed(
        (menu) => _row(menu, _shawarma)['pending'] = [
          _pending('r1', 'rename', name: 'شاورما دجاج'),
        ],
      );
      app.server
        ..on('/v1/merchant/menu', [FakeAnswer(200, renamed)])
        ..on('/v1/merchant/menu/requests/items/$_shawarma/text', [
          FakeAnswer(200, renamed),
        ]);
      await app.pump(tester, [FakeAnswer(200, _status())]);
      await _open(tester);
      await _tap(tester, 'text-item-$_shawarma');
      await tester.enterText(
        find.byKey(const Key('item-description')),
        'مع ثوم',
      );
      await _tap(tester, 'item-send');
      expect(
        _body(
          app.server
              .to('/v1/merchant/menu/requests/items/$_shawarma/text')
              .single,
        ),
        {'name': 'شاورما دجاج', 'description': 'مع ثوم'},
      );
      await app.done(tester);
    },
  );

  testWidgets(
    'a cashier sees the badge but neither the forms nor «سحب الطلب»',
    (tester) async {
      final app = _App();
      app.server.on('/v1/merchant/menu', [
        FakeAnswer(
          200,
          _changed(
            (menu) => _row(menu, _falafel)['pending'] = [
              _pending('r1', 'photo', photoKey: 'menu/items/b.jpg'),
            ],
          ),
        ),
      ]);
      await app.pump(tester, [FakeAnswer(200, _status())]);
      await _open(tester);
      expect(
        find.text(
          'صورة جديدة بانتظار المراجعة؛ تبقى الصورة الحالية حتى الموافقة',
        ),
        findsOneWidget,
      );
      expect(find.byKey(const Key('withdraw-r1')), findsNothing);
      expect(find.byKey(const Key('menu-add-category')), findsNothing);
      expect(find.byKey(const Key('text-item-$_falafel')), findsNothing);
      await app.done(tester);
    },
  );

  testWidgets(
    "an owner asks a group's new option, keeping the published deltas",
    (tester) async {
      const family = '30000000-0000-4000-8000-000000000009';
      final app = _App(role: 'owner', ids: [family]);
      app.server
        ..on('/v1/merchant/menu', [FakeAnswer(200, _menu())])
        ..on('/v1/merchant/menu/requests/option-groups/$_size', [
          FakeAnswer(200, _menu()),
        ]);
      await app.pump(tester, [FakeAnswer(200, _status())]);
      await _open(tester);
      await _tap(tester, 'edit-group-$_size');
      final delta = tester.widget<TextField>(
        find.byKey(const Key('option-delta-0')),
      );
      expect(delta.enabled, isFalse);
      await _tap(tester, 'group-add-option');
      await tester.enterText(find.byKey(const Key('option-name-1')), 'عائلي');
      await tester.enterText(find.byKey(const Key('option-delta-1')), '50');
      await _tap(tester, 'group-send');
      expect(
        _body(
          app.server
              .to('/v1/merchant/menu/requests/option-groups/$_size')
              .single,
        ),
        {
          'name': 'الحجم',
          'minChoices': 1,
          'maxChoices': 1,
          'itemIds': [_shawarma],
          'options': [
            {
              'id': _large,
              'name': 'كبير',
              'priceDelta': {'amount': '2000', 'currency': 'TRY'},
            },
            {
              'id': family,
              'name': 'عائلي',
              'priceDelta': {'amount': '5000', 'currency': 'TRY'},
            },
          ],
        },
      );
      await app.done(tester);
    },
  );

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
    // RA §18: a review's decision changes the menu (slice 2.32b).
    expect(
      changesMenu({
        'type': 'restaurant.state_changed',
        'kind': 'menu_change_rejected',
      }),
      isTrue,
    );
    expect(publishedIds([(id: 'a', isNew: false), (id: 'b', isNew: true)]), [
      'a',
    ]);
  });
}
