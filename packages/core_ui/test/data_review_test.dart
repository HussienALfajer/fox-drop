import 'package:core_ui/core_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'forms_harness.dart';

// The review of D.9: a pressable card keeps its content readable, a row's
// end slot is read, the favourite is not colour alone, a faded card keeps
// its reason readable, and every widget fits at 130% and 200%.

void main() {
  // D.W4b: the ring reads as the web's `timer`, and never counts below 0.
  testWidgets('the countdown ring reads its seconds with their words', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      formApp(
        const FoxCountdownRing(seconds: 38, total: 45, label: 'ثانية متبقية'),
      ),
    );
    expect(find.bySemanticsLabel('38 ثانية متبقية'), findsOneWidget);
    expect(find.bySemanticsLabel('38'), findsNothing);
    await tester.pumpWidget(
      formApp(const FoxCountdownRing(seconds: -3, total: 45)),
    );
    expect(find.text('0'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('a pressable order card keeps its content and button reachable', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    var opened = 0;
    var accepted = 0;
    await tester.pumpWidget(
      formApp(
        FoxOrderCard(
          number: '10423',
          since: 'منذ 1 د',
          items: '3 أصناف',
          captain: 'بانتظار كابتن',
          timer: const FoxTimer(
            seconds: 272,
            countsDown: true,
            minuteUnit: 'د',
          ),
          late: true,
          lateLabel: 'متأخر',
          action: FoxOrderAction('قبول', () => accepted++),
          onPressed: () => opened++,
        ),
      ),
    );
    // The card's node reads its texts; the button is a node of its own.
    expect(find.bySemanticsLabel(RegExp('3 أصناف')), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('متأخر')), findsWidgets);
    expect(find.bySemanticsLabel('قبول'), findsOneWidget);
    await tester.tap(find.text('قبول'));
    expect((accepted, opened), (1, 0));
    await tester.tap(find.text('3 أصناف'));
    expect(opened, 1);
    semantics.dispose();
  });

  testWidgets('a pressable order row keeps its status and total readable', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      formApp(
        FoxOrderRow(
          restaurant: 'برجر كبصو',
          date: 'اليوم',
          status: const FoxStatusChip(
            status: FoxOrderStatus.delivered,
            label: 'تم التسليم',
          ),
          total: const FoxMoney(amount: '47000', symbol: '₺'),
          onPressed: () {},
        ),
      ),
    );
    expect(find.bySemanticsLabel(RegExp('تم التسليم')), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('470 ₺')), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('a pressable row reads its end slot as its value', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      formApp(
        FoxListRow(
          title: 'رصيد العهدة',
          end: const FoxMoney(amount: '125000', symbol: '₺'),
          endLabel: '1,250 ₺',
          onPressed: () {},
        ),
      ),
    );
    expect(
      tester.getSemantics(find.byType(FoxListRow)),
      matchesSemantics(
        label: 'رصيد العهدة',
        value: '1,250 ₺',
        isButton: true,
        hasTapAction: true,
        hasFocusAction: true,
        isFocusable: true,
        hasEnabledState: true,
        isEnabled: true,
      ),
    );
    semantics.dispose();
  });

  testWidgets('a favourite is a filled heart, and a closed card keeps its '
      'state readable', (tester) async {
    await tester.pumpWidget(
      formApp(
        FoxRestaurantCard(
          name: 'كنافة أعزاز',
          categories: 'حلويات',
          eta: '30–40 د',
          fee: const Text('توصيل مجاني'),
          state: const FoxStatusChip(tone: FoxTone.neutral, label: 'مغلق'),
          closed: true,
          favourite: true,
          favouriteLabel: 'المفضلة',
          onFavourite: () {},
        ),
      ),
    );
    final heart = tester.widget<FoxIcon>(
      find.byWidgetPredicate((w) => w is FoxIcon && w.icon == FoxIcons.heart),
    );
    expect(heart.style, FoxIconStyle.bold);
    for (final text in ['مغلق']) {
      expect(
        find.ancestor(of: find.text(text), matching: find.byType(Opacity)),
        findsNothing,
        reason: '$text keeps its contrast',
      );
    }
    expect(
      find.ancestor(
        of: find.text('كنافة أعزاز'),
        matching: find.byType(Opacity),
      ),
      findsOneWidget,
    );
  });

  testWidgets('an unavailable dish keeps its reason readable', (tester) async {
    await tester.pumpWidget(
      formApp(
        FoxDishCard(
          name: 'فطور شامي',
          price: const FoxMoney(amount: '9000', symbol: '₺'),
          unavailableLabel: 'يتوفر غداً',
          addLabel: 'أضف',
          onAdd: () {},
        ),
      ),
    );
    expect(
      find.ancestor(
        of: find.text('يتوفر غداً'),
        matching: find.byType(Opacity),
      ),
      findsNothing,
    );
    expect(
      find.ancestor(of: find.text('فطور شامي'), matching: find.byType(Opacity)),
      findsOneWidget,
    );
  });

  testWidgets('a logo without a name draws an empty tint', (tester) async {
    await tester.pumpWidget(formApp(const FoxLogo(name: '')));
    expect(tester.takeException(), isNull);
  });

  testWidgets('the remaining widgets fit at 130% and 200% text', (
    tester,
  ) async {
    await expectNoOverflow(
      tester,
      () => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          FoxMoney(
            amount: '330000000',
            symbol: 'ل.س',
            role: FoxMoneyRole.number,
          ),
          FoxCountBadge(
            count: 120,
            semanticLabel: '120',
            child: FoxIcon(FoxIcons.bell),
          ),
          FoxCountBadge(count: 4, semanticLabel: '4'),
          FoxCard(child: Text('برجر كبصو · برجر، وجبات سريعة')),
          FoxTimer(
            seconds: 240,
            countsDown: false,
            prefix: 'ينتظر منذ',
            minuteUnit: 'د',
          ),
          FoxCountdownRing(seconds: 38, total: 45),
          FoxSkeleton(
            label: 'جارٍ التحميل',
            child: FoxSkeletonBlock(height: FoxSpace.md),
          ),
          FoxLogo(name: 'فطائر الريف'),
        ],
      ),
    );
  });
}
