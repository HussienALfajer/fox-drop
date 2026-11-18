import 'package:core_api/core_api.dart' show standardSerializers;
import 'package:core_auth/testing.dart';
import 'package:customer/src/browsing/browsing.dart';
import 'package:customer/src/browsing/category_screen.dart';
import 'package:customer/src/browsing/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';
import 'support.dart';

const _grills = '00000000-0000-4000-8000-0000000000c2';
const _list = '00000000-0000-4000-8000-0000000000b2';

Map<String, Object?> _banner(
  String id,
  String title,
  String target, {
  List<String> restaurantIds = const [],
  String? categoryId,
  String? code,
}) => {
  'id': id,
  'title': title,
  'imageKey': 'marketing/banners/$id.jpg',
  'target': target,
  'restaurantIds': restaurantIds,
  'categoryId': categoryId,
  'code': code,
};

Future<TestApp> _home(
  WidgetTester tester,
  List<Map<String, Object?>> banners,
) => browsingApp(
  tester,
  signedIn: true,
  before: (app) {
    app.server.on('/v1/customer/restaurants', [
      FakeAnswer(200, {
        'restaurants': [
          card(shamId, 'مطعم الشام'),
          card(nourId, 'مطعم النور', state: 'closed'),
        ],
        'sections': [
          {'kind': 'banners', 'title': null, 'restaurantIds': <Object?>[]},
          {'kind': 'categories', 'title': null, 'restaurantIds': <Object?>[]},
        ],
        'banners': banners,
      }),
    ]);
    app.server.on('/v1/customer/promo-codes', [
      const FakeAnswer(200, {
        'currency': 'TRY',
        'codes': [
          {
            'code': 'OTHER',
            'kind': 'free_delivery',
            'percentBp': null,
            'amount': null,
            'maxDiscount': null,
            'minOrder': null,
            'restaurants': <Object?>[],
            'zones': <Object?>[],
            'hours': null,
            'validTo': '2026-12-31T21:00:00.000Z',
            'usesLeft': null,
            'ended': null,
          },
          {
            'code': 'SHITA',
            'kind': 'percentage',
            'percentBp': 1000,
            'amount': null,
            'maxDiscount': null,
            'minOrder': null,
            'restaurants': <Object?>[],
            'zones': <Object?>[],
            'hours': null,
            'validTo': '2026-12-31T21:00:00.000Z',
            'usesLeft': null,
            'ended': null,
          },
        ],
      }),
    ]);
  },
);

// CU §8.1, AP §9.11.2 (slice 2.27c): the home's banners in the panel's
// order, swiped across, each opening its target.
void main() {
  test('each target has its path', () {
    HomeBanner banner(Map<String, Object?> json) =>
        standardSerializers.deserializeWith(HomeBanner.serializer, json)!;
    expect(
      bannerPath(
        banner(_banner('b1', 't', 'restaurant', restaurantIds: [shamId])),
      ),
      '/restaurants/$shamId',
    );
    expect(
      bannerPath(banner(_banner('b2', 't', 'category', categoryId: _grills))),
      '/categories/$_grills',
    );
    expect(
      bannerPath(
        banner(_banner(_list, 't', 'restaurants', restaurantIds: [shamId])),
      ),
      '/banners/$_list',
    );
    expect(
      bannerPath(banner(_banner('b4', 't', 'code', code: 'SHITA'))),
      '/codes?code=SHITA',
    );
  });

  testWidgets('a restaurant banner opens its page', (tester) async {
    final app = await _home(tester, [
      _banner('b1', 'شاورما الشتاء', 'restaurant', restaurantIds: [shamId]),
      _banner('b2', 'مشاوي', 'category', categoryId: _grills),
    ]);
    expect(find.byKey(const Key('banners')), findsOneWidget);
    expect(find.bySemanticsLabel('شاورما الشتاء'), findsOneWidget);
    await tester.tap(find.byKey(const Key('banner-b1')));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<RestaurantScreen>(find.byType(RestaurantScreen))
          .restaurantId,
      shamId,
    );
    await app.done(tester);
  });

  testWidgets('swipes to the next banner, which opens its category', (
    tester,
  ) async {
    final app = await _home(tester, [
      _banner('b1', 'شاورما الشتاء', 'restaurant', restaurantIds: [shamId]),
      _banner('b2', 'مشاوي', 'category', categoryId: _grills),
    ]);
    // Right to left: the next banner comes from the start's side.
    await tester.fling(
      find.byKey(const Key('banners')),
      const Offset(500, 0),
      1500,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('banner-b2')));
    await tester.pumpAndSettle();
    expect(
      tester.widget<CategoryScreen>(find.byType(CategoryScreen)).categoryId,
      _grills,
    );
    await app.done(tester);
  });

  testWidgets('a list banner opens its restaurants under its title', (
    tester,
  ) async {
    final app = await _home(tester, [
      _banner(
        _list,
        'أطباق الشتاء',
        'restaurants',
        restaurantIds: [shamId, nourId],
      ),
    ]);
    await tester.tap(find.byKey(const Key('banner-$_list')));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'أطباق الشتاء'), findsOneWidget);
    expect(find.text('مطعم الشام'), findsOneWidget);
    expect(find.text('مطعم النور'), findsOneWidget);
    double top(String text) => tester.getTopLeft(find.text(text)).dy;
    expect(top('مطعم الشام') < top('مطعم النور'), isTrue);
    await app.done(tester);
  });

  testWidgets('a code banner opens «أكوادي» with that code first', (
    tester,
  ) async {
    final app = await _home(tester, [
      _banner('b4', 'كود الشتاء', 'code', code: 'SHITA'),
    ]);
    await tester.tap(find.byKey(const Key('banner-b4')));
    await tester.pumpAndSettle();
    final shown = tester.widget<ListTile>(
      find.byKey(const Key('my-code-SHITA')),
    );
    expect(shown.selected, isTrue);
    double top(String key) => tester.getTopLeft(find.byKey(Key(key))).dy;
    expect(top('my-code-SHITA') < top('my-code-OTHER'), isTrue);
    await app.done(tester);
  });

  testWidgets('says a banner\'s code the customer cannot use now', (
    tester,
  ) async {
    final app = await _home(tester, [
      _banner('b5', 'كود قديم', 'code', code: 'GONE'),
    ]);
    await tester.tap(find.byKey(const Key('banner-b5')));
    await tester.pumpAndSettle();
    expect(find.text('الكود GONE غير متاح لك الآن'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('keeps a code banner when no restaurant delivers here', (
    tester,
  ) async {
    final app = await browsingApp(
      tester,
      signedIn: true,
      before: (app) => app.server.on('/v1/customer/restaurants', [
        FakeAnswer(200, {
          'restaurants': <Object?>[],
          'sections': [
            {'kind': 'banners', 'title': null, 'restaurantIds': <Object?>[]},
          ],
          'banners': [_banner('b6', 'كود الشتاء', 'code', code: 'SHITA')],
        }),
      ]),
    );
    expect(find.byKey(const Key('banner-b6')), findsOneWidget);
    expect(find.text('لا توجد مطاعم توصل إلى موقعك حالياً'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('a list banner\'s screen offers a retry when the home fails', (
    tester,
  ) async {
    final app = await _home(tester, [
      _banner(_list, 'أطباق الشتاء', 'restaurants', restaurantIds: [shamId]),
    ]);
    app.server.on('/v1/customer/restaurants', [
      const FakeAnswer(500, {'statusCode': 500}),
    ]);
    await tester.tap(find.byKey(const Key('banner-$_list')));
    await tester.pumpAndSettle();
    expect(find.text('مطعم الشام'), findsOneWidget);
    // A failed read, as after a pull to refresh: the retry, not a spinner.
    app.container.invalidate(homeProvider);
    await tester.pumpAndSettle();
    expect(find.text('حاول مجدداً'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('home has no strip without a banner', (tester) async {
    final app = await _home(tester, []);
    expect(find.byKey(const Key('banners')), findsNothing);
    await app.done(tester);
  });
}
