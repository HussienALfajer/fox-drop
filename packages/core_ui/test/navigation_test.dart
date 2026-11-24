import 'dart:async';

import 'package:core_ui/core_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'overlays_harness.dart';

// D.10 navigation, from the approved sheet «Overlays and navigation — batch
// 4» (owner, 2026-11-24): tabs, top bars, the bottom navigation (the Figma
// file's floating bar, icons only, in all three apps), the restaurant's rail
// and pull to refresh (the logo's drop).

const _customerItems = [
  FoxNavItem(icon: FoxIcons.home, label: 'الرئيسية'),
  FoxNavItem(icon: FoxIcons.search, label: 'البحث'),
  FoxNavItem(
    icon: FoxIcons.orders,
    label: 'طلباتي',
    badgeCount: 1,
    badgeLabel: '1 جديد',
  ),
  FoxNavItem(icon: FoxIcons.account, label: 'حسابي'),
];

/// Tabs that keep their own selection, as a screen does.
class _Tabs extends StatefulWidget {
  const _Tabs({this.tabs, this.style = FoxTabsStyle.underline});

  final List<FoxTab>? tabs;
  final FoxTabsStyle style;

  @override
  State<_Tabs> createState() => _TabsState();
}

class _TabsState extends State<_Tabs> {
  int selected = 0;

  @override
  Widget build(BuildContext context) => FoxTabs(
    style: widget.style,
    tabs:
        widget.tabs ??
        const [
          FoxTab(label: 'جديدة', count: 3, countLabel: '3 طلبات'),
          FoxTab(label: 'قيد التحضير'),
          FoxTab(label: 'جاهزة'),
        ],
    selected: selected,
    onChanged: (int n) => setState(() => selected = n),
  );
}

void main() {
  group('FoxTabs', () {
    Future<void> pumpTabs(
      WidgetTester tester, {
      TextDirection direction = TextDirection.rtl,
      Widget child = const _Tabs(),
    }) async {
      phoneScreen(tester);
      await tester.pumpWidget(
        overlayApp(
          Align(alignment: Alignment.topCenter, child: child),
          direction: direction,
        ),
      );
    }

    int selectedIndex(WidgetTester tester) =>
        tester.state<_TabsState>(find.byType(_Tabs)).selected;

    testWidgets('one tab stop: Tab leaves the row after the selected tab', (
      tester,
    ) async {
      await pumpTabs(
        tester,
        child: Column(
          children: [
            const _Tabs(),
            FoxButton(label: 'بعد', onPressed: () {}),
          ],
        ),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(
        focused?.context?.findAncestorWidgetOfExactType<FoxTabs>(),
        isNotNull,
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(
        focused?.context?.findAncestorWidgetOfExactType<FoxButton>()?.label,
        'بعد',
      );
    });

    testWidgets('arrows follow reading order: ← is next in RTL', (
      tester,
    ) async {
      await pumpTabs(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pump();
      expect(selectedIndex(tester), 1);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(selectedIndex(tester), 0);
      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pump();
      expect(selectedIndex(tester), 2);
      await tester.sendKeyEvent(LogicalKeyboardKey.home);
      await tester.pump();
      expect(selectedIndex(tester), 0);
    });

    testWidgets('→ is next in LTR', (tester) async {
      await pumpTabs(tester, direction: TextDirection.ltr);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(selectedIndex(tester), 1);
    });

    testWidgets('the selected tab is announced as selected, with its count', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpTabs(tester);
      expect(
        tester.getSemantics(find.bySemanticsLabel(RegExp('^جديدة'))),
        matchesSemantics(
          label: 'جديدة، 3 طلبات',
          isSelected: true,
          isInMutuallyExclusiveGroup: true,
          isButton: true,
          hasTapAction: true,
          isFocusable: true,
          hasSelectedState: true,
          hasFocusAction: true,
        ),
      );
      handle.dispose();
    });

    testWidgets('overflow scrolls the selected tab into view', (tester) async {
      final tabs = [for (var n = 0; n < 12; n++) FoxTab(label: 'قسم رقم $n')];
      await pumpTabs(tester, child: _Tabs(tabs: tabs));
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pumpAndSettle();
      final last = tester.getRect(find.text('قسم رقم 11'));
      expect(last.left, greaterThanOrEqualTo(0));
      expect(last.right, lessThanOrEqualTo(390));
    });

    testWidgets('fits in RTL and at 130% and 200% text', (tester) async {
      await expectNoOverflowInApp(tester, () => const _Tabs());
      await expectNoOverflowInApp(
        tester,
        () => const _Tabs(style: FoxTabsStyle.pill),
      );
    });
  });

  group('FoxTopBar', () {
    testWidgets('every slot has a name; back goes back', (tester) async {
      var back = 0;
      final handle = tester.ensureSemantics();
      phoneScreen(tester);
      await tester.pumpWidget(
        overlayApp(
          FoxTopBar(
            title: 'سلة المشتريات',
            backLabel: 'رجوع',
            onBack: () => back++,
            end: FoxButton.icon(
              icon: FoxIcons.delete,
              label: 'إفراغ السلة',
              onPressed: () {},
            ),
          ),
        ),
      );
      expect(find.bySemanticsLabel('رجوع'), findsOneWidget);
      expect(find.bySemanticsLabel('إفراغ السلة'), findsOneWidget);
      expect(find.bySemanticsLabel('سلة المشتريات'), findsOneWidget);
      await tester.tap(find.bySemanticsLabel('رجوع'));
      expect(back, 1);
      handle.dispose();
    });

    testWidgets('the title is a header in the heading colour', (tester) async {
      final handle = tester.ensureSemantics();
      phoneScreen(tester);
      await tester.pumpWidget(overlayApp(const FoxTopBar(title: 'عهدتي')));
      expect(
        tester.getSemantics(find.bySemanticsLabel('عهدتي')),
        matchesSemantics(label: 'عهدتي', isHeader: true),
      );
      expect(
        tester.widget<Text>(find.text('عهدتي')).style?.color,
        FoxThemeData.phone().colors.heading,
      );
      handle.dispose();
    });

    testWidgets('the restaurant bar: the connection dot has its words', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      phoneScreen(tester, size: const Size(1024, 768));
      await tester.pumpWidget(
        overlayApp(
          FoxRestaurantBar(
            name: 'برجر كبصو',
            status: const FoxStatusChip(
              status: FoxOrderStatus.ready,
              label: 'مفتوح',
            ),
            connected: false,
            connectionLabel: 'غير متصل',
            supportLabel: 'الدعم',
            onSupport: () {},
          ),
        ),
      );
      expect(find.text('غير متصل'), findsOneWidget);
      expect(find.bySemanticsLabel('الدعم'), findsOneWidget);
      expect(find.bySemanticsLabel('برجر كبصو'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('fits in RTL and at 130% and 200% text', (tester) async {
      await expectNoOverflowInApp(
        tester,
        () => FoxTopBar(
          title: 'سلة المشتريات الطويلة جداً',
          backLabel: 'رجوع',
          onBack: () {},
          end: FoxButton.icon(
            icon: FoxIcons.delete,
            label: 'إفراغ',
            onPressed: () {},
          ),
        ),
      );
      await expectNoOverflowInApp(
        tester,
        () => FoxRestaurantBar(
          name: 'برجر كبصو',
          status: const FoxStatusChip(
            status: FoxOrderStatus.ready,
            label: 'مفتوح',
          ),
          connected: true,
          connectionLabel: 'متصل',
          supportLabel: 'الدعم',
          onSupport: () {},
        ),
        size: const Size(1024, 768),
      );
    });
  });

  group('FoxBottomNavigation', () {
    late int selected;

    Future<void> pumpBar(
      WidgetTester tester, {
      EdgeInsets viewPadding = EdgeInsets.zero,
      FoxThemeData? theme,
    }) async {
      selected = 0;
      phoneScreen(tester);
      await tester.pumpWidget(
        overlayApp(
          Align(
            alignment: Alignment.bottomCenter,
            child: StatefulBuilder(
              builder: (context, setState) => FoxBottomNavigation(
                items: _customerItems,
                selected: selected,
                onSelected: (int n) => setState(() => selected = n),
              ),
            ),
          ),
          viewPadding: viewPadding,
          theme: theme,
        ),
      );
    }

    testWidgets('four items, icons only, each a 48 dp target', (tester) async {
      await pumpBar(tester);
      for (final item in _customerItems) {
        expect(find.text(item.label), findsNothing, reason: 'icons only');
      }
      final targets = find.byKey(FoxBottomNavigation.itemKey);
      expect(targets, findsNWidgets(4));
      for (final element in targets.evaluate()) {
        final size = (element.renderObject! as RenderBox).size;
        expect(size.width, greaterThanOrEqualTo(48));
        expect(size.height, greaterThanOrEqualTo(48));
      }
    });

    testWidgets('the selected item is announced as selected; a tap selects', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpBar(tester);
      expect(
        tester.getSemantics(find.bySemanticsLabel('الرئيسية')),
        matchesSemantics(
          label: 'الرئيسية',
          isSelected: true,
          hasSelectedState: true,
          isButton: true,
          isInMutuallyExclusiveGroup: true,
          hasTapAction: true,
          isFocusable: true,
          hasFocusAction: true,
        ),
      );
      await tester.tap(find.bySemanticsLabel('البحث'));
      await tester.pump();
      expect(selected, 1);
      handle.dispose();
    });

    testWidgets('a badge is read with its item', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpBar(tester);
      expect(find.bySemanticsLabel('طلباتي، 1 جديد'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('keeps the safe area', (tester) async {
      await pumpBar(
        tester,
        viewPadding: const EdgeInsets.only(bottom: FoxSpace.xl),
      );
      final bar = tester.getRect(find.byKey(FoxBottomNavigation.pillKey));
      expect(bar.bottom, lessThanOrEqualTo(844 - FoxSpace.xl));
    });

    testWidgets('the active circle is the primary colour on both themes', (
      tester,
    ) async {
      for (final theme in [FoxThemeData.phone(), FoxThemeData.captain()]) {
        await pumpBar(tester, theme: theme);
        final active = tester.widget<DecoratedBox>(
          find
              .descendant(
                of: find.byKey(FoxBottomNavigation.itemKey).first,
                matching: find.byType(DecoratedBox),
              )
              .first,
        );
        expect(
          (active.decoration as BoxDecoration).color,
          theme.colors.primary,
        );
      }
    });

    testWidgets('fits in RTL and at 130% and 200% text', (tester) async {
      await expectNoOverflowInApp(
        tester,
        () => Align(
          alignment: Alignment.bottomCenter,
          child: FoxBottomNavigation(
            items: _customerItems,
            selected: 2,
            onSelected: (_) {},
          ),
        ),
      );
    });
  });

  group('FoxNavigationRail (RA §6.2)', () {
    testWidgets('the same items, on the start side, arrows move along it', (
      tester,
    ) async {
      var selected = 0;
      phoneScreen(tester, size: const Size(1024, 768));
      await tester.pumpWidget(
        overlayApp(
          Row(
            children: [
              StatefulBuilder(
                builder: (context, setState) => FoxNavigationRail(
                  items: _customerItems,
                  selected: selected,
                  onSelected: (int n) => setState(() => selected = n),
                ),
              ),
              const Expanded(child: SizedBox.expand()),
            ],
          ),
        ),
      );
      final rail = tester.getRect(find.byType(FoxNavigationRail));
      expect(rail.right, 1024, reason: 'the start side in RTL');
      for (final item in _customerItems) {
        expect(find.text(item.label), findsOneWidget);
      }
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(selected, 1);
    });

    testWidgets('fits at 130% and 200% text', (tester) async {
      await expectNoOverflowInApp(
        tester,
        () => Row(
          children: [
            FoxNavigationRail(
              items: _customerItems,
              selected: 0,
              onSelected: (_) {},
            ),
          ],
        ),
        size: const Size(1024, 768),
      );
    });
  });

  group('FoxPullToRefresh', () {
    late int calls;
    late Completer<void> done;

    Future<void> pumpList(
      WidgetTester tester, {
      bool disableAnimations = false,
    }) async {
      calls = 0;
      done = Completer<void>();
      phoneScreen(tester);
      await tester.pumpWidget(
        overlayApp(
          FoxPullToRefresh(
            refreshLabel: 'تحديث',
            onRefresh: () {
              calls++;
              return done.future;
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                for (var n = 0; n < 5; n++)
                  SizedBox(height: FoxSpace.xxxl, child: Text('طلب $n')),
              ],
            ),
          ),
          disableAnimations: disableAnimations,
        ),
      );
    }

    bool refreshing(WidgetTester tester) => tester
        .widgetList<FoxRefreshDrop>(find.byType(FoxRefreshDrop))
        .any((drop) => drop.refreshing);

    testWidgets('one pull runs the callback once and holds until it ends', (
      tester,
    ) async {
      await pumpList(tester);
      await tester.drag(find.text('طلب 0'), const Offset(0, 300));
      await tester.pump();
      expect(calls, 1);
      expect(refreshing(tester), isTrue);
      await tester.pump(const Duration(seconds: 3));
      expect(refreshing(tester), isTrue, reason: 'holds while it loads');
      // A second pull while it loads starts nothing new.
      await tester.drag(find.text('طلب 0'), const Offset(0, 300));
      await tester.pump();
      expect(calls, 1);
      done.complete();
      await tester.pumpAndSettle();
      expect(refreshing(tester), isFalse);
    });

    testWidgets('a short pull does nothing', (tester) async {
      await pumpList(tester);
      await tester.drag(find.text('طلب 0'), const Offset(0, 20));
      await tester.pumpAndSettle();
      expect(calls, 0);
    });

    testWidgets('a semantics action refreshes without the gesture', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpList(tester);
      final node = tester.getSemantics(find.byType(FoxPullToRefresh));
      final action = node.getSemanticsData().customSemanticsActionIds!.single;
      node.owner!.performAction(node.id, SemanticsAction.customAction, action);
      await tester.pump();
      expect(calls, 1);
      done.complete();
      await tester.pumpAndSettle();
      handle.dispose();
    });

    testWidgets('still under reduced motion: the drop does not pulse', (
      tester,
    ) async {
      await pumpList(tester, disableAnimations: true);
      await tester.drag(find.text('طلب 0'), const Offset(0, 300));
      await tester.pump();
      expect(refreshing(tester), isTrue);
      expect(tester.hasRunningAnimations, isFalse);
      done.complete();
      await tester.pumpAndSettle();
    });
  });
}
