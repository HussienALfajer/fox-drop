import 'dart:async';

import 'package:core_ui/core_ui.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'overlays_harness.dart';

// Findings of the D.10 review (reviewer agent, 2026-11-24), fixed at their
// root: pull to refresh on bouncing lists, the scrim's name, Android back
// with an open menu, a toast read twice, a badge that is colour alone.

/// Every semantics node under the root.
List<SemanticsNode> _nodes(WidgetTester tester) {
  var root = tester.getSemantics(find.byType(Directionality).first);
  while (root.parent != null) {
    root = root.parent!;
  }
  final all = <SemanticsNode>[];
  void visit(SemanticsNode node) {
    all.add(node);
    node.visitChildren((child) {
      visit(child);
      return true;
    });
  }

  visit(root);
  return all;
}

void main() {
  group('FoxPullToRefresh on every platform\'s physics', () {
    testWidgets(
      'a long pull refreshes once, bouncing (iOS) or clamping (Android)',
      (tester) async {
        var calls = 0;
        final done = Completer<void>();
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
          ),
        );
        await tester.drag(find.text('طلب 0'), const Offset(0, 300));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        expect(calls, 1);
        done.complete();
        await tester.pumpAndSettle();
        expect(calls, 1);
      },
      variant: const TargetPlatformVariant({
        TargetPlatform.iOS,
        TargetPlatform.android,
      }),
    );
  });

  group('the scrim is never an unnamed action', () {
    testWidgets('a dialog without a dismiss label leaves the scrim out', (
      tester,
    ) async {
      phoneScreen(tester);
      await tester.pumpWidget(
        overlayApp(
          Builder(
            builder: (context) => FoxButton(
              label: 'افتح',
              onPressed: () => showFoxDialog<void>(
                context,
                builder: (_) => FoxDialog(
                  title: 'تأكيد',
                  closeLabel: 'إغلاق',
                  primary: FoxDialogAction(label: 'نعم', onPressed: () {}),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('افتح'));
      await tester.pumpAndSettle();
      for (final node in _nodes(tester)) {
        final data = node.getSemanticsData();
        if (data.hasAction(SemanticsAction.tap)) {
          expect(data.label, isNotEmpty, reason: '$node');
        }
      }
    });

    testWidgets('a dismiss label names the scrim of a dialog and a sheet', (
      tester,
    ) async {
      phoneScreen(tester);
      for (final sheet in [false, true]) {
        await tester.pumpWidget(
          overlayApp(
            Builder(
              builder: (context) => FoxButton(
                label: 'افتح',
                onPressed: () => sheet
                    ? showFoxBottomSheet<void>(
                        context,
                        dismissLabel: 'إغلاق النافذة',
                        builder: (_) => FoxBottomSheet(
                          title: 'حالة المطعم',
                          closeLabel: 'إغلاق',
                          child: const Text('المحتوى'),
                        ),
                      )
                    : showFoxDialog<void>(
                        context,
                        dismissLabel: 'إغلاق النافذة',
                        builder: (_) => FoxDialog(
                          title: 'تأكيد',
                          closeLabel: 'إغلاق',
                          primary: FoxDialogAction(
                            label: 'نعم',
                            onPressed: () {},
                          ),
                        ),
                      ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('افتح'));
        await tester.pumpAndSettle();
        expect(
          _nodes(tester).where(
            (n) =>
                n.getSemanticsData().label == 'إغلاق النافذة' &&
                n.getSemanticsData().hasAction(SemanticsAction.tap),
          ),
          isNotEmpty,
          reason: sheet ? 'sheet' : 'dialog',
        );
      }
    });
  });

  group('Android back closes an open menu, not the page', () {
    testWidgets('FoxMenu', (tester) async {
      phoneScreen(tester);
      // The trigger of the pushed page opens the menu itself.
      await tester.pumpWidget(
        overlayApp(
          Builder(
            builder: (home) => FoxButton(
              label: 'افتح الصفحة',
              onPressed: () => Navigator.of(home).push(
                PageRouteBuilder<void>(
                  pageBuilder: (_, _, _) => Center(
                    child: FoxMenu(
                      label: 'قائمة',
                      items: [FoxMenuItem(label: 'بند', onSelected: () {})],
                      builder: (context, open) =>
                          FoxButton(label: 'المشغّل', onPressed: open),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('افتح الصفحة'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('المشغّل'));
      await tester.pumpAndSettle();
      expect(find.byKey(FoxMenu.panelKey), findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byKey(FoxMenu.panelKey), findsNothing);
      expect(find.text('المشغّل'), findsOneWidget, reason: 'the page stays');
      // With the menu closed, back pops the page as usual.
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('المشغّل'), findsNothing);
    });

    testWidgets('FoxSelect (D.8)', (tester) async {
      phoneScreen(tester);
      await tester.pumpWidget(
        overlayApp(
          Builder(
            builder: (home) => FoxButton(
              label: 'افتح الصفحة',
              onPressed: () => Navigator.of(home).push(
                PageRouteBuilder<void>(
                  pageBuilder: (_, _, _) => Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: FoxSpace.xxxl * 5,
                      child: FoxSelect<int>(
                        label: 'المدينة',
                        value: 1,
                        options: const [
                          FoxSelectOption(value: 1, label: 'أعزاز'),
                          FoxSelectOption(value: 2, label: 'مارع'),
                        ],
                        onChanged: (_) {},
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('افتح الصفحة'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('أعزاز'));
      await tester.pumpAndSettle();
      expect(find.text('مارع'), findsOneWidget, reason: 'the menu is open');
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('مارع'), findsNothing);
      expect(find.text('المدينة'), findsOneWidget, reason: 'the page stays');
    });
  });

  testWidgets('a toast is announced once, not also as a live region', (
    tester,
  ) async {
    late FoxToasterState toaster;
    phoneScreen(tester);
    await tester.pumpWidget(
      overlayApp(
        FoxToaster(
          child: Builder(
            builder: (context) {
              toaster = FoxToaster.of(context);
              return const SizedBox.expand();
            },
          ),
        ),
      ),
    );
    toaster.show(
      tone: FoxToastTone.info,
      message: 'نُسخ رقم الطلب',
      closeLabel: 'إغلاق',
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    expect(tester.takeAnnouncements(), hasLength(1));
    for (final node in _nodes(tester)) {
      expect(
        node.getSemanticsData().flagsCollection.isLiveRegion,
        isFalse,
        reason: '$node',
      );
    }
  });

  test('a badge on a destination always has its words', () {
    expect(
      () => FoxNavItem(icon: FoxIcons.cash, label: 'عهدتي', dot: true),
      throwsAssertionError,
    );
    expect(
      () => FoxNavItem(icon: FoxIcons.orders, label: 'طلباتي', badgeCount: 2),
      throwsAssertionError,
    );
    expect(
      FoxNavItem(
        icon: FoxIcons.cash,
        label: 'عهدتي',
        dot: true,
        badgeLabel: 'جديد',
      ).semanticLabel,
      'عهدتي، جديد',
    );
  });
}
