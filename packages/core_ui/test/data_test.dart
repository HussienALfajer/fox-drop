import 'package:core_ui/core_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'forms_harness.dart';

// D.9 data display, from the approved sheet «Data display — batch 3»
// (owner, 2026-11-24). The same rules as the web components in ui-web.

final _phone = FoxThemeData.phone();

/// The colour of the box that paints [finder]'s nearest DecoratedBox.
Color? _fill(WidgetTester tester, Finder finder) {
  final box = tester.widget<DecoratedBox>(
    find.ancestor(of: finder, matching: find.byType(DecoratedBox)).first,
  );
  return (box.decoration as BoxDecoration).color;
}

void main() {
  group('foxFormatAmount (AP §4.7)', () {
    const cases = {
      ('41000', 2): '410',
      ('1050', 2): '10.50',
      ('5', 2): '0.05',
      ('0', 2): '0',
      ('125000', 2): '1,250',
      ('330000000', 2): '3,300,000',
      ('1248050', 2): '12,480.50',
      ('2500000', 0): '2,500,000',
      ('-2500', 2): '−25',
      ('-30005', 2): '−300.05',
    };
    for (final MapEntry(key: (minor, decimals), value: text) in cases.entries) {
      test('$minor with $decimals decimals is $text', () {
        expect(foxFormatAmount(minor, decimals), text);
      });
    }

    test('puts a plus on a gain only when asked', () {
      expect(foxFormatAmount('20000', 2, signed: true), '+200');
      expect(foxFormatAmount('-20000', 2, signed: true), '−200');
      expect(foxFormatAmount('0', 2, signed: true), '0');
    });

    test('never passes through a double', () {
      expect(
        foxFormatAmount('900719925474099312', 2),
        '9,007,199,254,740,993.12',
      );
    });

    test('refuses a value that is not an integer of minor units', () {
      expect(() => foxFormatAmount('10.5', 2), throwsFormatException);
    });
  });

  group('FoxMoney', () {
    testWidgets('is one RTL run with tabular digits and the lira fallback', (
      tester,
    ) async {
      await tester.pumpWidget(
        formApp(const FoxMoney(amount: '41000', symbol: '₺')),
      );
      final text = tester.widget<Text>(find.text('410 ₺'));
      expect(text.textDirection, TextDirection.rtl);
      expect(
        text.style!.fontFeatures,
        contains(const FontFeature.tabularFigures()),
      );
      expect(
        text.style!.fontFamilyFallback,
        contains('packages/core_ui/Fox Lira'),
      );
    });

    testWidgets('colours its tone', (tester) async {
      await tester.pumpWidget(
        formApp(
          const FoxMoney(amount: '-2500', symbol: '₺', tone: FoxTone.success),
        ),
      );
      expect(
        tester.widget<Text>(find.text('−25 ₺')).style!.color,
        _phone.colors.success,
      );
    });
  });

  group('FoxStatusChip', () {
    test('gives each of the nine states its approved tone and icon', () {
      expect(FoxOrderStatus.values.map((s) => s.name), [
        'placed',
        'accepted',
        'ready',
        'pickedUp',
        'arrived',
        'delivered',
        'rejected',
        'cancelled',
        'failed',
      ]);
      expect(
        {for (final s in FoxOrderStatus.values) s: s.tone},
        {
          FoxOrderStatus.placed: FoxTone.warning,
          FoxOrderStatus.accepted: FoxTone.info,
          FoxOrderStatus.ready: FoxTone.success,
          FoxOrderStatus.pickedUp: FoxTone.primary,
          FoxOrderStatus.arrived: FoxTone.primary,
          FoxOrderStatus.delivered: FoxTone.success,
          FoxOrderStatus.rejected: FoxTone.danger,
          FoxOrderStatus.cancelled: FoxTone.neutral,
          FoxOrderStatus.failed: FoxTone.danger,
        },
      );
      expect(FoxOrderStatus.pickedUp.icon, FoxIcons.motorcycle);
      expect(FoxOrderStatus.placed.icon, FoxIcons.clock);
    });

    testWidgets('draws its tone on the tint, in words and an icon', (
      tester,
    ) async {
      await tester.pumpWidget(
        formApp(
          const FoxStatusChip(
            status: FoxOrderStatus.delivered,
            label: 'تم التسليم',
          ),
        ),
      );
      expect(
        _fill(tester, find.text('تم التسليم')),
        _phone.colors.successSubtle,
      );
      expect(
        tester.widget<Text>(find.text('تم التسليم')).style!.color,
        _phone.colors.success,
      );
      expect(find.byType(FoxIcon), findsOneWidget);
    });

    testWidgets('the captain reads the orange status in blue', (tester) async {
      await tester.pumpWidget(
        formApp(
          const FoxStatusChip(
            status: FoxOrderStatus.pickedUp,
            label: 'مع الكابتن',
          ),
          theme: FoxThemeData.captain(),
        ),
      );
      expect(
        tester.widget<Text>(find.text('مع الكابتن')).style!.color,
        FoxThemeData.captain().colors.onPrimarySubtle,
      );
    });

    testWidgets('fits at 130% and 200% text', (tester) async {
      await expectNoOverflow(
        tester,
        () => const Wrap(
          children: [
            FoxStatusChip(
              status: FoxOrderStatus.placed,
              label: 'بانتظار تأكيد المطعم',
            ),
            FoxStatusChip(
              tone: FoxTone.warning,
              icon: FoxIcons.clock,
              label: 'مشغول',
            ),
          ],
        ),
      );
    });
  });

  group('FoxCountBadge', () {
    test('caps the count', () {
      expect(foxBadgeText(1, 99), '1');
      expect(foxBadgeText(100, 99), '99+');
      expect(foxBadgeText(12, 9), '9+');
    });

    testWidgets('is named by its label and shows 99+ left to right', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        formApp(
          const FoxCountBadge(
            count: 120,
            semanticLabel: '120 إشعاراً',
            child: FoxIcon(FoxIcons.bell),
          ),
        ),
      );
      expect(find.bySemanticsLabel('120 إشعاراً'), findsOneWidget);
      final text = tester.widget<Text>(find.text('99+'));
      expect(text.textDirection, TextDirection.ltr);
      semantics.dispose();
    });

    testWidgets('shows nothing at zero', (tester) async {
      await tester.pumpWidget(
        formApp(
          const FoxCountBadge(
            count: 0,
            semanticLabel: 'لا شيء',
            child: FoxIcon(FoxIcons.bell),
          ),
        ),
      );
      expect(find.text('0'), findsNothing);
    });
  });

  group('FoxCard', () {
    testWidgets('a pressable card is one button and takes the pressed colour', (
      tester,
    ) async {
      var pressed = 0;
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        formApp(
          FoxCard(
            semanticLabel: 'طلب 10423',
            onPressed: () => pressed++,
            child: const Text('محتوى'),
          ),
        ),
      );
      expect(
        tester.getSemantics(find.byType(FoxCard)),
        matchesSemantics(
          label: 'طلب 10423',
          isButton: true,
          hasTapAction: true,
          hasFocusAction: true,
          isFocusable: true,
          hasEnabledState: true,
          isEnabled: true,
        ),
      );
      await tester.tap(find.byType(FoxCard));
      expect(pressed, 1);
      semantics.dispose();
    });

    testWidgets('the customer card carries the offset shadow', (tester) async {
      await tester.pumpWidget(
        formApp(
          const FoxCard(
            elevation: FoxCardElevation.offset,
            child: Text('محتوى'),
          ),
        ),
      );
      final box = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byType(FoxCard),
          matching: find.byType(AnimatedContainer),
        ),
      );
      expect((box.decoration! as BoxDecoration).boxShadow, [
        _phone.shadows.offset,
      ]);
    });

    testWidgets('a late card is tinted red', (tester) async {
      await tester.pumpWidget(
        formApp(const FoxCard(tone: FoxCardTone.danger, child: Text('محتوى'))),
      );
      final box = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byType(FoxCard),
          matching: find.byType(AnimatedContainer),
        ),
      );
      expect(
        (box.decoration! as BoxDecoration).color,
        _phone.colors.dangerSubtle,
      );
    });
  });

  group('FoxListRow', () {
    testWidgets('is one button named by its title, with a mirrored chevron', (
      tester,
    ) async {
      var pressed = 0;
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        formApp(
          FoxListRow(
            title: 'المنزل',
            description: 'أعزاز — دوار الكفين',
            leading: FoxIcons.house,
            onPressed: () => pressed++,
          ),
        ),
      );
      expect(find.bySemanticsLabel(RegExp('^المنزل')), findsOneWidget);
      expect(
        find.byWidgetPredicate((w) => w is FoxIcon && w.icon == FoxIcons.back),
        findsOneWidget,
      );
      await tester.tap(find.byType(FoxListRow));
      expect(pressed, 1);
      expect(
        tester.getSize(find.byType(FoxListRow)).height,
        greaterThanOrEqualTo(56),
      );
      semantics.dispose();
    });

    testWidgets('a disabled row ignores taps', (tester) async {
      var pressed = 0;
      await tester.pumpWidget(
        formApp(
          FoxListRow(
            title: 'أكوادي',
            enabled: false,
            onPressed: () => pressed++,
          ),
        ),
      );
      await tester.tap(find.byType(FoxListRow));
      expect(pressed, 0);
    });

    testWidgets('fits at 130% and 200% text', (tester) async {
      await expectNoOverflow(
        tester,
        () => FoxListRow(
          title: 'رصيد العهدة لدى الكابتن',
          description: 'آخر تحديث اليوم 9:45 م',
          leading: FoxIcons.wallet,
          end: const FoxMoney(amount: '125000', symbol: '₺'),
          onPressed: () {},
        ),
      );
    });
  });

  group('FoxTimer', () {
    test('formats under ten minutes as m:ss and above in minutes', () {
      expect(foxFormatDuration(0, 'د'), '0:00');
      expect(foxFormatDuration(48, 'د'), '0:48');
      expect(foxFormatDuration(272, 'د'), '4:32');
      expect(foxFormatDuration(599, 'د'), '9:59');
      expect(foxFormatDuration(600, 'د'), '10 د');
      expect(foxFormatDuration(725, 'د'), '12 د');
      expect(foxFormatDuration(-5, 'د'), '0:00');
    });

    test('is soon in the last minute and late when the app says', () {
      expect(foxTimerTone(seconds: 61, countsDown: true), FoxTimerTone.calm);
      expect(foxTimerTone(seconds: 60, countsDown: true), FoxTimerTone.soon);
      expect(
        foxTimerTone(seconds: 10, countsDown: false, late: true),
        FoxTimerTone.late,
      );
      expect(foxTimerTone(seconds: 900, countsDown: false), FoxTimerTone.calm);
    });

    testWidgets('shows its prefix, in danger when late', (tester) async {
      await tester.pumpWidget(
        formApp(
          const FoxTimer(
            seconds: 180,
            countsDown: false,
            late: true,
            prefix: 'متأخر',
            minuteUnit: 'د',
          ),
        ),
      );
      final text = tester.widget<Text>(find.text('متأخر 3:00'));
      expect(text.style!.color, _phone.colors.danger);
      expect(
        text.style!.fontFeatures,
        contains(const FontFeature.tabularFigures()),
      );
    });

    testWidgets(
      'the countdown ring shows the seconds left, red in the last 10',
      (tester) async {
        await tester.pumpWidget(
          formApp(const FoxCountdownRing(seconds: 8, total: 45)),
        );
        expect(
          tester.widget<Text>(find.text('8')).style!.color,
          _phone.colors.danger,
        );
      },
    );
  });

  group('FoxOrderCard (RA §8.2)', () {
    Widget card({bool late = false, VoidCallback? onAction}) => FoxOrderCard(
      number: '10423',
      since: 'منذ 1 د',
      items: '3 أصناف · وجبة كريسبي، لفة شاورما…',
      captain: 'بانتظار كابتن',
      timer: const FoxTimer(seconds: 272, countsDown: true, minuteUnit: 'د'),
      late: late,
      lateLabel: 'متأخر',
      action: onAction == null ? null : FoxOrderAction('قبول', onAction),
    );

    testWidgets('shows the number, items, captain line, timer and action', (
      tester,
    ) async {
      var accepted = 0;
      await tester.pumpWidget(formApp(card(onAction: () => accepted++)));
      expect(find.text('#10423'), findsOneWidget);
      expect(find.text('بانتظار كابتن'), findsOneWidget);
      expect(find.text('4:32'), findsOneWidget);
      await tester.tap(find.text('قبول'));
      expect(accepted, 1);
    });

    testWidgets('a late card is red and says so to screen readers', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(formApp(card(late: true)));
      expect(find.bySemanticsLabel(RegExp('متأخر')), findsWidgets);
      final box = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byType(FoxCard),
          matching: find.byType(AnimatedContainer),
        ),
      );
      expect(
        (box.decoration! as BoxDecoration).color,
        _phone.colors.dangerSubtle,
      );
      semantics.dispose();
    });

    testWidgets('fits at 130% and 200% text', (tester) async {
      await expectNoOverflow(tester, () => card(onAction: () {}));
    });
  });

  group('FoxOrderRow (CU §12.3)', () {
    testWidgets('shows the restaurant, date, status and total', (tester) async {
      await expectNoOverflow(
        tester,
        () => FoxOrderRow(
          restaurant: 'برجر كبصو',
          date: 'اليوم · 9:45 م',
          status: const FoxStatusChip(
            status: FoxOrderStatus.pickedUp,
            label: 'في الطريق إليك',
          ),
          total: const FoxMoney(amount: '47000', symbol: '₺'),
          onPressed: () {},
        ),
      );
      expect(find.text('برجر كبصو'), findsOneWidget);
      expect(find.text('470 ₺'), findsOneWidget);
    });
  });

  group('FoxAmountsSummary (CU §10.2)', () {
    const lines = [
      FoxAmountLine('قيمة الأصناف', '45200'),
      FoxAmountLine('رسوم التوصيل', '0', text: 'مجاني'),
      FoxAmountLine('الخصم (FOX25)', '-2500', tone: FoxTone.success),
    ];

    testWidgets('lists the lines and the total; a free fee in words', (
      tester,
    ) async {
      await tester.pumpWidget(
        formApp(
          const FoxAmountsSummary(
            lines: lines,
            total: FoxAmountLine('المجموع', '42700'),
            symbol: '₺',
            equivalents: 'أو 11.50 \$',
          ),
        ),
      );
      expect(find.text('452 ₺'), findsOneWidget);
      expect(find.text('مجاني'), findsOneWidget);
      expect(find.text('−25 ₺'), findsOneWidget);
      expect(find.text('427 ₺'), findsOneWidget);
      expect(find.text('أو 11.50 \$'), findsOneWidget);
    });

    testWidgets('the prominent total sits on the orange bar', (tester) async {
      await tester.pumpWidget(
        formApp(
          const FoxAmountsSummary(
            variant: FoxAmountsVariant.prominent,
            lines: lines,
            total: FoxAmountLine('المجموع', '42700'),
            symbol: '₺',
          ),
        ),
      );
      expect(_fill(tester, find.text('427 ₺')), _phone.colors.primary);
    });

    testWidgets('fits at 130% and 200% text', (tester) async {
      await expectNoOverflow(
        tester,
        () => const FoxAmountsSummary(
          variant: FoxAmountsVariant.prominent,
          lines: lines,
          total: FoxAmountLine('المجموع', '42700'),
          symbol: '₺',
        ),
      );
    });
  });

  group('FoxRestaurantCard (CU §8.2)', () {
    Widget restaurant({bool closed = false}) => FoxRestaurantCard(
      name: 'كنافة أعزاز',
      categories: 'حلويات',
      rating: '4.8',
      eta: '30–40 د',
      fee: const FoxMoney(
        amount: '1000',
        symbol: '₺',
        role: FoxMoneyRole.secondary,
      ),
      state: closed
          ? const FoxStatusChip(
              tone: FoxTone.neutral,
              label: 'مغلق — يفتح السبت 10:00 ص',
            )
          : null,
      closed: closed,
      favourite: false,
      favouriteLabel: 'المفضلة',
      onFavourite: () {},
      onPressed: () {},
    );

    testWidgets('without a cover shows the first letter, never a fake photo', (
      tester,
    ) async {
      await tester.pumpWidget(formApp(restaurant()));
      expect(find.text('ك'), findsWidgets);
      expect(find.text('4.8'), findsOneWidget);
      expect(find.text('10 ₺'), findsOneWidget);
    });

    testWidgets('a closed restaurant fades', (tester) async {
      await tester.pumpWidget(formApp(restaurant(closed: true)));
      expect(
        tester
            .widget<Opacity>(
              find
                  .descendant(
                    of: find.byType(FoxRestaurantCard),
                    matching: find.byType(Opacity),
                  )
                  .first,
            )
            .opacity,
        lessThan(1),
      );
    });

    testWidgets('the heart is its own 48 button', (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(formApp(restaurant()));
      expect(find.bySemanticsLabel('المفضلة'), findsOneWidget);
      expect(
        tester.getSize(find.bySemanticsLabel('المفضلة')).width,
        greaterThanOrEqualTo(48),
      );
      semantics.dispose();
    });

    testWidgets('fits at 130% and 200% text', (tester) async {
      await expectNoOverflow(tester, () => restaurant(closed: true));
    });
  });

  group('FoxDishCard (CU §9.3)', () {
    testWidgets('a dish without a photo is a text row; «+» adds it', (
      tester,
    ) async {
      var added = 0;
      await tester.pumpWidget(
        formApp(
          FoxDishCard(
            name: 'كوب عيران',
            description: 'مقاس كبير',
            price: const FoxMoney(amount: '2500', symbol: '₺'),
            addLabel: 'أضف كوب عيران',
            onAdd: () => added++,
          ),
        ),
      );
      expect(find.byType(Image), findsNothing);
      await tester.tap(find.bySemanticsLabel('أضف كوب عيران'));
      expect(added, 1);
    });

    testWidgets('shows the count in the cart instead of «+»', (tester) async {
      await tester.pumpWidget(
        formApp(
          FoxDishCard(
            name: 'وجبة كريسبي',
            price: const FoxMoney(amount: '12000', symbol: '₺'),
            fromLabel: 'من',
            count: 2,
            addLabel: 'أضف وجبة كريسبي',
            onAdd: () {},
          ),
        ),
      );
      expect(find.text('2'), findsOneWidget);
      expect(find.text('من'), findsOneWidget);
    });

    testWidgets('an unavailable dish fades, says why and cannot be added', (
      tester,
    ) async {
      await tester.pumpWidget(
        formApp(
          FoxDishCard(
            name: 'فطور شامي',
            price: const FoxMoney(amount: '9000', symbol: '₺'),
            unavailableLabel: 'يتوفر غداً',
            addLabel: 'أضف فطور شامي',
            onAdd: () {},
          ),
        ),
      );
      expect(find.text('يتوفر غداً'), findsOneWidget);
      expect(find.bySemanticsLabel('أضف فطور شامي'), findsNothing);
    });

    testWidgets('fits at 130% and 200% text', (tester) async {
      await expectNoOverflow(
        tester,
        () => FoxDishCard(
          name: 'برجر كبصو',
          description: 'لحم بقري مشوي، جبن شيدر، خس، طماطم',
          price: const FoxMoney(amount: '18000', symbol: '₺'),
          addLabel: 'أضف برجر كبصو',
          onAdd: () {},
        ),
      );
    });
  });

  group('FoxSkeleton', () {
    testWidgets(
      'is one busy label with hidden blocks; still under reduced motion',
      (tester) async {
        final semantics = tester.ensureSemantics();
        await tester.pumpWidget(
          formApp(
            const FoxSkeleton(
              label: 'جارٍ التحميل',
              child: Column(
                children: [
                  FoxSkeletonBlock(height: 16),
                  FoxSkeletonBlock.circle(40),
                ],
              ),
            ),
            disableAnimations: true,
          ),
        );
        expect(find.bySemanticsLabel('جارٍ التحميل'), findsOneWidget);
        expect(tester.hasRunningAnimations, isFalse);
        semantics.dispose();
      },
    );

    testWidgets('pulses otherwise', (tester) async {
      await tester.pumpWidget(
        formApp(
          const FoxSkeleton(
            label: 'جارٍ التحميل',
            child: FoxSkeletonBlock(height: 16),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.hasRunningAnimations, isTrue);
    });
  });

  group('FoxEmptyState', () {
    testWidgets('a heading, a line and one action, the icon in the drop', (
      tester,
    ) async {
      var retried = 0;
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        formApp(
          FoxEmptyState(
            icon: FoxIcons.error,
            title: 'حدث خطأ',
            description: 'لم نتمكن من تحميل الطلبات',
            tone: FoxEmptyTone.error,
            action: FoxEmptyAction('أعد المحاولة', () => retried++),
          ),
        ),
      );
      expect(
        tester.getSemantics(find.text('حدث خطأ')),
        matchesSemantics(label: 'حدث خطأ', isHeader: true),
      );
      expect(
        tester.widget<Text>(find.text('حدث خطأ')).style!.color,
        _phone.colors.danger,
      );
      await tester.tap(find.text('أعد المحاولة'));
      expect(retried, 1);
      semantics.dispose();
    });

    testWidgets('fits at 130% and 200% text', (tester) async {
      await expectNoOverflow(
        tester,
        () => const FoxEmptyState(
          icon: FoxIcons.cart,
          title: 'سلتك فارغة',
          description: 'أضف أطباقك المفضلة وستجدها هنا',
        ),
      );
    });
  });

  // The parity gaps of slice D.W3b, each as the web or the D.9 sheet has it.
  group('parity with the web (D.W3b)', () {
    final tokens = _phone.components;

    testWidgets('a count badge is its size, ring included, centred on the '
        'corner; the dot is tucked on it', (tester) async {
      Future<(Rect, Rect)> badge(int? count) async {
        await tester.pumpWidget(
          formApp(
            Center(
              child: FoxCountBadge(
                count: count,
                semanticLabel: 'إشعارات',
                child: const FoxIcon(FoxIcons.bell),
              ),
            ),
          ),
        );
        final icon = tester.getRect(find.byType(FoxIcon));
        final mark = tester.getRect(
          find
              .descendant(
                of: find.byType(Stack),
                matching: find.byType(Container),
              )
              .first,
        );
        return (icon, mark);
      }

      final (icon, count) = await badge(3);
      expect(count.height, tokens.countBadge.size);
      expect(count.width, tokens.countBadge.size);
      // RTL: the end corner is the icon's left.
      expect(icon.top - count.top, tokens.countBadge.offset);
      expect(icon.left - count.left, tokens.countBadge.offset);

      final (_, dot) = await badge(null);
      expect(dot.size, Size.square(tokens.countBadge.dotSize));
      expect(icon.top - dot.top, tokens.countBadge.dotOffset);
    });

    testWidgets('a status chip is at least min-height tall', (tester) async {
      await tester.pumpWidget(
        formApp(
          const Align(
            alignment: AlignmentDirectional.topStart,
            child: FoxStatusChip(
              status: FoxOrderStatus.placed,
              label: 'بانتظار المطعم',
            ),
          ),
        ),
      );
      expect(
        tester.getSize(find.byType(FoxStatusChip)).height,
        tokens.statusChip.minHeight,
      );
    });

    testWidgets('a list row keeps one gap before its chevron', (tester) async {
      await tester.pumpWidget(
        formApp(FoxListRow(title: 'المنزل', onPressed: () {})),
      );
      final text = tester.getRect(find.byType(Expanded));
      final chevron = tester.getRect(find.byType(FoxIcon));
      // RTL: the chevron sits at the end, to the text's left.
      expect(text.left - chevron.right, tokens.listRow.gap);
    });

    testWidgets('the equivalents sit one gap under the total', (tester) async {
      await tester.pumpWidget(
        formApp(
          const FoxAmountsSummary(
            lines: [FoxAmountLine('قيمة الأصناف', '45200')],
            total: FoxAmountLine('المجموع', '45200'),
            symbol: '₺',
            equivalents: r'أو 11.50 $',
          ),
        ),
      );
      final total = tester.getRect(
        find
            .ancestor(
              of: find.text('المجموع'),
              matching: find.byType(Container),
            )
            .first,
      );
      final equivalents = tester.getRect(find.text(r'أو 11.50 $'));
      expect(equivalents.top - total.bottom, tokens.amountsSummary.gap);
    });

    testWidgets('an empty state frames its icon in the sheet\'s drop and '
        'keeps one gap between its parts', (tester) async {
      await tester.pumpWidget(
        formApp(
          FoxEmptyState(
            icon: FoxIcons.orders,
            title: 'لا طلبات',
            description: 'غيّر الفترة',
            action: FoxEmptyAction('مسح الفلاتر', () {}),
          ),
        ),
      );
      final drop = tester.getRect(
        find
            .ancestor(
              of: find.byType(FoxIcon),
              matching: find.byType(CustomPaint),
            )
            .first,
      );
      expect(drop.size, Size.square(tokens.emptyState.artSize));
      final title = tester.getRect(find.text('لا طلبات'));
      final line = tester.getRect(find.text('غيّر الفترة'));
      final action = tester.getRect(find.byType(FoxButton));
      final gap = tokens.emptyState.gap;
      expect(title.top - drop.bottom, gap);
      expect(line.top - title.bottom, gap);
      expect(action.top - line.bottom, gap);
    });
  });
}
