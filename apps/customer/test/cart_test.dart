import 'dart:convert';

import 'package:core_auth/testing.dart';
import 'package:core_api/core_api.dart';
import 'package:customer/src/cart/item_choice.dart';
import 'package:customer/src/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

MenuItem _shawarma() {
  final api = CoreApi();
  final page = api.serializers.deserializeWith(
    CustomerRestaurantPageDtoOutput.serializer,
    shamPage(),
  )!;
  return page.menu.first.items.first;
}

void main() {
  test('the item sheet\'s choice and price (CU §9.4)', () {
    final group = _shawarma().optionGroups;
    final choice = ItemChoice(_shawarma());
    expect(choice.incompleteGroups.map((g) => g.id), [sizeGroupId]);

    choice.toggle(group[0], normalId);
    choice.toggle(group[0], largeId);
    expect(choice.chosen[sizeGroupId], {largeId});
    choice.toggle(group[1], cheeseId);
    choice.toggle(group[1], garlicId);
    expect(choice.chosen[extrasGroupId], {cheeseId});
    expect(choice.incompleteGroups, isEmpty);

    choice.quantity = 2;
    expect(choice.unitPrice, '6500');
    expect(choice.linePrice, '13000');
    expect(choice.toLine().optionNames, ['كبير', 'جبنة']);
  });

  test('a note cannot carry a phone number (Q25)', () {
    expect(hasPhoneNumber('بدون بصل'), isFalse);
    expect(hasPhoneNumber('اتصل 0944123'), isTrue);
    expect(hasPhoneNumber('رقمي ٠٩٤٤١٢٣٤'), isTrue);
    expect(hasPhoneNumber('طابق 123456'), isFalse);
  });

  testWidgets('a required group must be chosen before adding', (tester) async {
    await browsingApp(tester);
    await openSham(tester);
    await tester.tap(find.text('شاورما دجاج'));
    await tester.pumpAndSettle();
    expect(find.text('إجباري · اختر 1'), findsOneWidget);
    expect(find.text('اختر حتى 2'), findsOneWidget);
    await tester.tap(find.byKey(const Key('item-add')));
    await tester.pumpAndSettle();

    expect(find.text('اختر 1 على الأقل'), findsOneWidget);
    expect(find.byKey(const Key('open-cart')), findsNothing);
  });

  testWidgets('adds a line with its live price and keeps the cart', (
    tester,
  ) async {
    final app = await browsingApp(tester);
    await openSham(tester);
    await tester.tap(find.text('شاورما دجاج'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('option-$largeId')));
    await tester.tap(find.byKey(const Key('option-$cheeseId')));
    await tester.tap(find.byKey(const Key('item-more')));
    await tester.pump();
    expect(find.text('أضف — 130 ₺'), findsOneWidget);
    await tester.tap(find.byKey(const Key('item-add')));
    await tester.pumpAndSettle();

    final stored = jsonDecode(app.device.values['cart']!) as Map;
    expect(stored['restaurantId'], shamId);
    expect(stored['lines'], [
      {
        'itemId': shawarmaId,
        'name': 'شاورما دجاج',
        'optionIds': [largeId, cheeseId],
        'optionNames': ['كبير', 'جبنة'],
        'quantity': 2,
        'note': null,
        'unitPrice': '6500',
        'currency': 'TRY',
      },
    ]);

    // The same choice again is the same line.
    await addShawarma(tester);
    await tester.tap(find.byKey(const Key('open-cart')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('cart-line-0')), findsOneWidget);
    expect(find.byKey(const Key('cart-line-1')), findsNothing);
    expect(find.text('4'), findsOneWidget);

    await tester.tap(find.byKey(const Key('cart-less-0')));
    await tester.pumpAndSettle();
    expect(find.text('3'), findsOneWidget);
    await tester.tap(find.byKey(const Key('cart-remove-0')));
    await tester.pumpAndSettle();
    expect(find.text('سلتك فارغة'), findsOneWidget);
    expect(app.device.values['cart'], isNull);
  });

  testWidgets('a cart holds one restaurant', (tester) async {
    final app = await browsingApp(
      tester,
      before: (app) => app.server.on('/v1/customer/restaurants/$nourId', [
        FakeAnswer(200, {...shamPage(), 'id': nourId, 'nameAr': 'مطعم النور'}),
      ]),
    );
    await openSham(tester);
    await addShawarma(tester);
    app.container.read(routerProvider).go('/restaurants/$nourId');
    await tester.pumpAndSettle();
    await addShawarma(tester);

    expect(
      find.text(
        'سلتك فيها أصناف من مطعم الشام. هل تفرغها وتبدأ سلة جديدة من مطعم النور؟',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('سلة جديدة'));
    await tester.pumpAndSettle();
    final stored = jsonDecode(app.device.values['cart']!) as Map;
    expect(stored['restaurantId'], nourId);
  });

  testWidgets('a cart older than 24 hours empties', (tester) async {
    final app = await browsingApp(
      tester,
      before: (app) => app.device.values['cart'] = jsonEncode({
        'restaurantId': shamId,
        'restaurantName': 'مطعم الشام',
        'lines': <Object>[],
        'changedAt': DateTime.now()
            .subtract(const Duration(hours: 25))
            .toUtc()
            .toIso8601String(),
      }),
    );
    app.container.read(routerProvider).go('/cart');
    await tester.pumpAndSettle();

    expect(find.text('انتهت صلاحية سلتك'), findsOneWidget);
    expect(app.device.values['cart'], isNull);
  });
}
