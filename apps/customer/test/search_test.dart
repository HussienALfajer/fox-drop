import 'dart:convert';

import 'package:core_auth/testing.dart';
import 'package:customer/src/browsing/restaurant_screen.dart';
import 'package:customer/src/search/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';
import 'support.dart';

const _itemId = '00000000-0000-4000-8000-0000000000e1';

Map<String, Object?> _item(String name, String restaurantId, String state) => {
  'id': _itemId,
  'name': name,
  'description': null,
  'photoKey': null,
  'price': try_(12000),
  'fromPrice': null,
  'available': true,
  'unavailableReason': null,
  'optionGroups': <Object?>[],
  'restaurantId': restaurantId,
  'restaurantName': 'مطعم النور',
  'restaurantState': {
    'state': state,
    'busyMode': false,
    'until': null,
    'opensAt': null,
    'message': null,
  },
};

Future<TestApp> _search(
  WidgetTester tester,
  Map<String, Object?> answer, {
  Map<String, String>? stored,
}) async {
  final app = await browsingApp(
    tester,
    before: (app) {
      app.server.on('/v1/customer/search', [FakeAnswer(200, answer)]);
      if (stored != null) app.device.values.addAll(stored);
    },
  );
  await tester.tap(find.byKey(const Key('open-search')));
  await tester.pumpAndSettle();
  return app;
}

Future<void> _type(WidgetTester tester, String text) async {
  await tester.enterText(find.byKey(const Key('search-box')), text);
  await tester.pump(searchDelay);
  await tester.pumpAndSettle();
}

// CU §8.3 (slice 2.28a): «البحث», the 10 recent searches on the phone with
// «مسح», and «لم تجده؟ أخبرنا».
void main() {
  test('a search is the trimmed text of 2 characters or more', () {
    expect(searchQuery(' ش '), isNull);
    expect(searchQuery('  شاورما '), 'شاورما');
  });

  test('the recent searches put the latest first, once, 10 at most', () {
    final ten = [for (var i = 0; i < 10; i++) 'بحث $i'];
    expect(withRecent(ten, 'بحث 3'), [
      'بحث 3',
      ...ten.where((each) => each != 'بحث 3'),
    ]);
    final next = withRecent(ten, 'جديد');
    expect(next, hasLength(recentSearchesMax));
    expect(next.first, 'جديد');
    expect(next, isNot(contains('بحث 9')));
  });

  testWidgets('searches once typing stops and shows restaurants and items', (
    tester,
  ) async {
    final app = await _search(tester, {
      'restaurants': [card(shamId, 'مطعم الشام')],
      'items': [_item('سندويش شاورما', nourId, 'closed')],
    });
    await tester.enterText(find.byKey(const Key('search-box')), 'شاو');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.enterText(find.byKey(const Key('search-box')), 'شاورما');
    await tester.pump(searchDelay);
    await tester.pumpAndSettle();
    // One search, for the text as it stood when typing stopped.
    final asked = app.server.to('/v1/customer/search');
    expect(asked, hasLength(1));
    expect(asked.single.uri.queryParameters['q'], 'شاورما');
    expect(find.text('مطعم الشام'), findsOneWidget);

    await tester.tap(find.text('الأصناف'));
    await tester.pumpAndSettle();
    expect(find.text('سندويش شاورما'), findsOneWidget);
    expect(find.textContaining('مطعم النور · 120 ₺'), findsOneWidget);
    await tester.tap(find.byKey(const Key('item-$_itemId')));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<RestaurantScreen>(find.byType(RestaurantScreen))
          .restaurantId,
      nourId,
    );
    expect(jsonDecode(app.device.values['recent_searches']!), ['شاورما']);
    await app.done(tester);
  });

  testWidgets(
    'lists the recent searches, searches one again, and clears them',
    (tester) async {
      final app = await _search(
        tester,
        {
          'restaurants': [card(shamId, 'مطعم الشام')],
          'items': <Object?>[],
        },
        stored: {
          'recent_searches': jsonEncode(['بروستد', 'شاورما']),
        },
      );
      expect(find.text('عمليات البحث الأخيرة'), findsOneWidget);
      await tester.tap(find.byKey(const Key('recent-شاورما')));
      await tester.pumpAndSettle();
      expect(
        app.server.to('/v1/customer/search').single.uri.queryParameters['q'],
        'شاورما',
      );
      expect(jsonDecode(app.device.values['recent_searches']!), [
        'شاورما',
        'بروستد',
      ]);

      await tester.enterText(find.byKey(const Key('search-box')), '');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('clear-recent')));
      await tester.pumpAndSettle();
      expect(find.text('بروستد'), findsNothing);
      expect(app.device.values['recent_searches'], isNull);
      await app.done(tester);
    },
  );

  testWidgets('no result offers «لم تجده؟ أخبرنا», which thanks the customer', (
    tester,
  ) async {
    final app = await _search(tester, {
      'restaurants': <Object?>[],
      'items': <Object?>[],
    });
    app.server.on('/v1/customer/restaurant-suggestions', [
      const FakeAnswer(200, {'status': 'received'}),
    ]);
    await _type(tester, 'سوشي');
    expect(find.text('لا توجد نتائج لـ «سوشي»'), findsOneWidget);
    await tester.tap(find.byKey(const Key('suggest-restaurant')));
    await tester.pumpAndSettle();

    final send = find.byKey(const Key('suggest-send'));
    expect(tester.widget<FilledButton>(send).onPressed, isNull);
    await tester.enterText(
      find.byKey(const Key('suggest-name')),
      'مطعم السوشي',
    );
    await tester.pump();
    await tester.tap(send);
    await tester.pumpAndSettle();
    expect(find.text('شكراً، سنحاول إضافته'), findsOneWidget);

    final sent = app.server.to('/v1/customer/restaurant-suggestions').single;
    expect(sent.headers['Idempotency-Key'], isNotNull);
    expect(sent.data, containsPair('restaurantName', 'مطعم السوشي'));
    expect(sent.data, containsPair('query', 'سوشي'));
    expect(sent.data, containsPair('note', null));
    await app.done(tester);
  });

  testWidgets('a retry after a server error sends the same key', (
    tester,
  ) async {
    final app = await _search(tester, {
      'restaurants': <Object?>[],
      'items': <Object?>[],
    });
    app.server.on('/v1/customer/restaurant-suggestions', [
      const FakeAnswer(503, {'error': 'unavailable'}),
      const FakeAnswer(200, {'status': 'received'}),
    ]);
    await _type(tester, 'سوشي');
    await tester.tap(find.byKey(const Key('suggest-restaurant')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('suggest-name')), 'مطعم');
    await tester.pump();
    await tester.tap(find.byKey(const Key('suggest-send')));
    await tester.pumpAndSettle();
    expect(find.text('شكراً، سنحاول إضافته'), findsNothing);
    await tester.tap(find.byKey(const Key('suggest-send')));
    await tester.pumpAndSettle();
    expect(find.text('شكراً، سنحاول إضافته'), findsOneWidget);
    final keys = [
      for (final sent in app.server.to('/v1/customer/restaurant-suggestions'))
        sent.headers['Idempotency-Key'],
    ];
    expect(keys, hasLength(2));
    expect(keys.toSet(), hasLength(1));
    await app.done(tester);
  });

  test('the suggestion fits what the server takes', () {
    expect(suggestionFits('  ', ''), isFalse);
    expect(suggestionFits('مطعم', ''), isTrue);
    expect(suggestionFits('م' * 61, ''), isFalse);
    // Diacritics count, as the server counts them.
    expect(suggestionFits('مَ' * 31, ''), isFalse);
    expect(suggestionFits('مطعم', 'ن' * 201), isFalse);
    expect(searchQuery('شَ' * 26), isNull);
  });
}
