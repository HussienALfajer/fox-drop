import 'dart:convert';

import 'package:core_auth/testing.dart';
import 'package:core_api/core_api.dart';
import 'package:customer/src/cart/cart.dart';
import 'package:customer/src/cart/item_choice.dart';
import 'package:customer/src/cart/item_sheet.dart';
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

  // CU §9.x, CU-10: «أضف» with a required group missing scrolls to the first
  // such group, even when it is far above the button.
  testWidgets('adding with a required group missing scrolls to that group', (
    tester,
  ) async {
    final page = shamPage();
    final items = ((page['menu']! as List).first as Map)['items'] as List;
    (items.first as Map)['optionGroups'] = [
      {
        'id': sizeGroupId,
        'name': 'الحجم',
        'minChoices': 1,
        'maxChoices': 1,
        'options': [
          {
            'id': normalId,
            'name': 'عادي',
            'priceDelta': try_(0),
            'available': true,
          },
        ],
      },
      {
        'id': extrasGroupId,
        'name': 'إضافات كثيرة',
        'minChoices': 0,
        'maxChoices': 2,
        'options': [
          for (var i = 0; i < 20; i += 1)
            {
              'id':
                  '00000000-0000-4000-8000-00000000e0${i.toString().padLeft(2, '0')}',
              'name': 'إضافة $i',
              'priceDelta': try_(0),
              'available': true,
            },
        ],
      },
    ];
    await browsingApp(tester, page: page);
    // A short screen, so the sheet scrolls.
    tester.view.physicalSize = const Size(800, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpAndSettle();
    await openSham(tester);
    await tester.tap(find.text('شاورما دجاج'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const Key('item-add')),
      300,
      scrollable: find
          .descendant(
            of: find.byType(ItemSheet),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pumpAndSettle();
    final height =
        tester.view.physicalSize.height / tester.view.devicePixelRatio;
    final group = find.text('الحجم');
    expect(
      group.evaluate().isEmpty ||
          tester.getTopLeft(group).dy < 0 ||
          tester.getTopLeft(group).dy > height,
      isTrue,
      reason: 'the group starts off screen',
    );

    await tester.tap(find.byKey(const Key('item-add')));
    await tester.pumpAndSettle();
    expect(find.text('اختر 1 على الأقل'), findsOneWidget);
    final top = tester.getTopLeft(find.text('الحجم')).dy;
    expect(top, inInclusiveRange(0, height));
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

  testWidgets('the code stays with the cart until a new cart (CU §10.4)', (
    tester,
  ) async {
    final app = await browsingApp(tester);
    final carts = app.container.read(cartProvider.notifier);
    String? code() => app.container.read(cartProvider).value?.cart?.code;
    CartLine line(String note) => CartLine(
      itemId: shawarmaId,
      name: 'شاورما دجاج',
      optionIds: const [],
      optionNames: const [],
      quantity: 1,
      note: note,
      unitPrice: '6500',
      currency: 'TRY',
    );

    await carts.startNew(shamId, 'مطعم الشام', line('a'));
    await carts.setCode(' FOX٢٠ ');
    expect(code(), 'FOX20');
    await carts.add(shamId, 'مطعم الشام', line('b'));
    await carts.setQuantity(0, 3);
    await carts.acceptPrice(line('a').key, '7000');
    await carts.remove(1);
    expect(code(), 'FOX20');
    expect(jsonDecode(app.device.values['cart']!)['code'], 'FOX20');

    await carts.startNew(shamId, 'مطعم الشام', line('a'));
    expect(code(), isNull);
    await carts.setCode('FOX20');
    await carts.replaceWith(shamId, 'مطعم الشام', [line('a')]);
    expect(code(), isNull);
    await carts.setCode('FOX20');
    await carts.setCode('  ');
    expect(code(), isNull);
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
