import 'package:core_l10n/core_l10n.dart';
import 'package:customer/src/browsing/browsing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('ar'));
  final now = DateTime(2026, 11, 7, 12);

  RestaurantState state(
    String s, {
    bool busyMode = false,
    DateTime? until,
    DateTime? opensAt,
    String? message,
  }) => RestaurantState(
    state: s,
    busyMode: busyMode,
    until: until,
    opensAt: opensAt,
    message: message,
  );

  test('the state messages of CU §9.2', () {
    expect(restaurantStateText(l10n, state('open'), now), isNull);
    expect(
      restaurantStateText(l10n, state('open', busyMode: true), now),
      'قد يستغرق الطلب وقتاً أطول قليلاً',
    );
    expect(
      restaurantStateText(l10n, state('busy'), now),
      'المطعم مشغول حالياً، جرّب بعد قليل',
    );
    expect(
      restaurantStateText(
        l10n,
        state(
          'paused',
          until: now.add(const Duration(minutes: 29, seconds: 30)),
        ),
        now,
      ),
      'المطعم متوقف مؤقتاً، يعود خلال 30 د',
    );
    expect(
      restaurantStateText(l10n, state('paused', message: 'صيانة المطبخ'), now),
      'المطعم متوقف مؤقتاً، يعود قريباً\nصيانة المطبخ',
    );
    expect(
      restaurantStateText(
        l10n,
        state('closed', opensAt: DateTime.utc(2026, 11, 8, 6)),
        now,
      ),
      'مغلق — يفتح الأحد 9:00 ص',
    );
    expect(
      restaurantStateText(
        l10n,
        state(
          'holiday',
          until: DateTime.utc(2026, 11, 9, 21),
          message: 'عطلة العيد',
        ),
        now,
      ),
      'مغلق حتى 10/11/2026\nعطلة العيد',
    );
    expect(state('busy').takesOrders, isFalse);
    expect(state('open', busyMode: true).takesOrders, isTrue);
  });

  testWidgets('lists the restaurants that deliver to the point', (
    tester,
  ) async {
    final app = await browsingApp(tester);

    final list = app.server.to('/v1/customer/restaurants').single;
    expect(list.uri.queryParameters.keys, ['latitude', 'longitude']);
    expect(find.text('مطعم الشام'), findsOneWidget);
    expect(
      find.text('شاورما · جديد · 30–40 د · رسوم التوصيل 10 ₺'),
      findsOneWidget,
    );
    expect(
      find.text(
        'شاورما · جديد · 30–40 د · رسوم التوصيل 10 ₺ · مغلق — يفتح الأحد 9:00 ص',
      ),
      findsOneWidget,
    );
  });

  testWidgets('a restaurant page shows its menu and availability', (
    tester,
  ) async {
    await browsingApp(tester);
    await openSham(tester);

    expect(find.text('الحد الأدنى للطلب 100 ₺'), findsOneWidget);
    expect(find.text('توصيل مجاني للطلبات من 300 ₺ فأكثر'), findsOneWidget);
    expect(find.text('50 ₺'), findsOneWidget);
    expect(find.text('30 ₺\nيتوفر غداً'), findsOneWidget);
    expect(find.text('40 ₺\nمتوفر من 6:00 ص'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('menu-search')), 'فول');
    await tester.pumpAndSettle();
    expect(find.text('شاورما دجاج'), findsNothing);
    expect(find.byKey(const Key('item-$fulId')), findsOneWidget);

    await tester.tap(find.text('أوقات العمل'));
    await tester.pumpAndSettle();
    expect(find.text('10:00 ص – 11:00 م'), findsOneWidget);
  });

  testWidgets('a closed restaurant keeps its menu with the add button off', (
    tester,
  ) async {
    await browsingApp(tester, page: shamPage(state: 'busy'));
    await openSham(tester);
    expect(find.text('المطعم مشغول حالياً، جرّب بعد قليل'), findsOneWidget);

    await tester.tap(find.text('شاورما دجاج'));
    await tester.pumpAndSettle();
    final add = tester.widget<FilledButton>(find.byKey(const Key('item-add')));
    expect(add.onPressed, isNull);
  });
}
