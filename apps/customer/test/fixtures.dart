import 'package:core_auth/testing.dart';
import 'package:customer/src/location/position.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';
import 'support.dart';

const shamId = '00000000-0000-4000-8000-0000000000b1';
const nourId = '00000000-0000-4000-8000-0000000000b2';
const shawarmaId = '00000000-0000-4000-8000-0000000000c1';
const falafelId = '00000000-0000-4000-8000-0000000000c2';
const fulId = '00000000-0000-4000-8000-0000000000c3';
const sizeGroupId = '00000000-0000-4000-8000-0000000000d1';
const extrasGroupId = '00000000-0000-4000-8000-0000000000d2';
const normalId = '00000000-0000-4000-8000-0000000000e1';
const largeId = '00000000-0000-4000-8000-0000000000e2';
const cheeseId = '00000000-0000-4000-8000-0000000000e3';
const garlicId = '00000000-0000-4000-8000-0000000000e4';

Map<String, Object?> try_(int minor) => {'amount': '$minor', 'currency': 'TRY'};

Map<String, Object?> _state(String state, {String? opensAt, String? until}) => {
  'state': state,
  'busyMode': false,
  'until': until,
  'opensAt': opensAt,
  'message': null,
};

Map<String, Object?> card(
  String id,
  String name, {
  String state = 'open',
  String? opensAt,
}) => {
  'id': id,
  'nameAr': name,
  'nameEn': null,
  'category': 'شاورما',
  'logoKey': null,
  'coverKey': null,
  'rating': null,
  'ratingCount': null,
  'estimate': {'fromMin': 30, 'toMin': 40},
  'deliveryFee': {'fee': try_(1000), 'free': false},
  'state': _state(state, opensAt: opensAt),
};

Map<String, Object?> _option(
  String id,
  String name,
  int delta, {
  bool available = true,
}) => {
  'id': id,
  'name': name,
  'priceDelta': try_(delta),
  'available': available,
};

Map<String, Object?> _item(
  String id,
  String name,
  int price, {
  bool available = true,
  String? reason,
  List<Map<String, Object?>> groups = const [],
}) => {
  'id': id,
  'name': name,
  'description': null,
  'photoKey': null,
  'price': try_(price),
  'fromPrice': null,
  'available': available,
  'unavailableReason': reason,
  'optionGroups': groups,
};

/// «مطعم الشام»'s page: a shawarma with a required size and optional
/// extras, a falafel off until tomorrow, and a breakfast item outside its
/// window.
Map<String, Object?> shamPage({
  String state = 'open',
  bool deliversHere = true,
}) => {
  ...card(shamId, 'مطعم الشام', state: state),
  'description': null,
  'minimumOrder': try_(10000),
  'freeDeliveryFrom': try_(30000),
  'schedule': [
    {'weekday': 0, 'opensAt': 600, 'closesAt': 1380},
  ],
  'deliversHere': deliversHere,
  'menu': [
    {
      'id': '00000000-0000-4000-8000-0000000000f1',
      'name': 'شاورما',
      'window': null,
      'items': [
        _item(
          shawarmaId,
          'شاورما دجاج',
          5000,
          groups: [
            {
              'id': sizeGroupId,
              'name': 'الحجم',
              'minChoices': 1,
              'maxChoices': 1,
              'options': [
                _option(normalId, 'عادي', 0),
                _option(largeId, 'كبير', 1000),
              ],
            },
            {
              'id': extrasGroupId,
              'name': 'إضافات',
              'minChoices': 0,
              'maxChoices': 2,
              'options': [
                _option(cheeseId, 'جبنة', 500),
                _option(garlicId, 'ثوم', 0, available: false),
              ],
            },
          ],
        ),
        _item(falafelId, 'فلافل', 3000, available: false, reason: 'tomorrow'),
      ],
    },
    {
      'id': '00000000-0000-4000-8000-0000000000f2',
      'name': 'فطور',
      'window': {'startsAt': 360, 'endsAt': 720},
      'items': [_item(fulId, 'فول', 4000, available: false, reason: 'window')],
    },
  ],
};

/// A customer in Azaz with the restaurants answered, on home.
Future<TestApp> browsingApp(
  WidgetTester tester, {
  bool signedIn = false,
  Map<String, Object?>? page,
  void Function(TestApp app)? before,
}) async {
  final app = TestApp(
    signedIn: signedIn,
    overrides: [positionSourceProvider.overrideWithValue(FakePositionSource())],
  );
  app.server.on('/v1/customer/location', [
    const FakeAnswer(200, {
      'state': 'served',
      'zone': {
        'id': '00000000-0000-4000-8000-0000000000a1',
        'name': 'الحي الشمالي',
      },
    }),
  ]);
  app.server.on('/v1/customer/restaurants', [
    FakeAnswer(200, {
      'restaurants': [
        card(shamId, 'مطعم الشام'),
        card(
          nourId,
          'مطعم النور',
          state: 'closed',
          opensAt: DateTime(2026, 11, 8, 9).toUtc().toIso8601String(),
        ),
      ],
    }),
  ]);
  app.server.on('/v1/customer/restaurants/$shamId', [
    FakeAnswer(200, page ?? shamPage()),
  ]);
  before?.call(app);
  await app.pump(tester);
  await tester.tap(find.text('استخدم موقعي الحالي'));
  await tester.pumpAndSettle();
  return app;
}

Future<void> openSham(WidgetTester tester) async {
  await tester.tap(find.text('مطعم الشام'));
  await tester.pumpAndSettle();
}

/// Adds a large shawarma with cheese, twice, from the restaurant page.
Future<void> addShawarma(WidgetTester tester) async {
  await tester.tap(find.text('شاورما دجاج'));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('option-$largeId')));
  await tester.tap(find.byKey(const Key('option-$cheeseId')));
  await tester.tap(find.byKey(const Key('item-more')));
  await tester.pump();
  await tester.tap(find.byKey(const Key('item-add')));
  await tester.pumpAndSettle();
}
