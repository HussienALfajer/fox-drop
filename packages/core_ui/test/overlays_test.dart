import 'package:core_ui/core_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'overlays_harness.dart';

// D.10 overlays, from the approved sheet «Overlays and navigation — batch 4»
// (owner, 2026-11-24): dialog and the AP §7.4 confirmation form, bottom
// sheet, toast, banner and the banner stack, menu.

/// A screen with a trigger that runs [onOpen] with its context.
Widget _trigger(void Function(BuildContext context) onOpen) => Builder(
  builder: (context) => Align(
    alignment: Alignment.topCenter,
    child: FoxButton(label: 'افتح', onPressed: () => onOpen(context)),
  ),
);

Future<void> _openDialog(
  WidgetTester tester,
  WidgetBuilder builder, {
  bool disableAnimations = false,
}) async {
  phoneScreen(tester);
  await tester.pumpWidget(
    overlayApp(
      _trigger((context) => showFoxDialog<void>(context, builder: builder)),
      disableAnimations: disableAnimations,
    ),
  );
  // Focus the trigger by keyboard, as a keyboard user opens it.
  await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  await tester.pump();
  await tester.sendKeyEvent(LogicalKeyboardKey.enter);
  await tester.pumpAndSettle();
}

FoxDialog _deleteDialog({VoidCallback? onDelete}) => FoxDialog(
  title: 'حذف هذا العنوان؟',
  body: 'يُحذف من عناوينك.',
  closeLabel: 'إغلاق',
  primary: FoxDialogAction(
    label: 'حذف',
    destructive: true,
    onPressed: onDelete ?? () {},
  ),
  secondary: FoxDialogAction(label: 'إلغاء', onPressed: () {}),
);

FoxConfirmDialog _confirm({ValueChanged<String>? onConfirm}) =>
    FoxConfirmDialog(
      title: 'إلغاء الطلب #10423',
      closeLabel: 'إغلاق',
      reasonLabel: 'السبب',
      reasonError: 'السبب مطلوب',
      effectTitle: 'أثره على الأرصدة',
      effect: const FoxAmountsSummary(
        lines: [FoxAmountLine('يُعاد للزبون', '47000')],
        total: FoxAmountLine('المجموع', '47000'),
        symbol: '₺',
      ),
      notifiedTitle: 'سيُبلَّغ',
      notified: const ['الزبون', 'المطعم', 'الكابتن'],
      confirmLabel: 'تأكيد الإلغاء',
      cancelLabel: 'تراجع',
      onConfirm: onConfirm ?? (_) {},
    );

void main() {
  group('FoxDialog', () {
    testWidgets('opens with focus inside, never on the destructive action', (
      tester,
    ) async {
      await _openDialog(tester, (_) => _deleteDialog());
      expect(find.byType(FoxDialog), findsOneWidget);
      final focusContext = focused?.context;
      expect(focusContext, isNotNull);
      expect(
        find.ancestor(
          of: find.byWidget(focusContext!.widget),
          matching: find.byType(FoxDialog),
        ),
        findsWidgets,
      );
      // The safe action, not «حذف», takes the first focus.
      final focusedButton = focusContext
          .findAncestorWidgetOfExactType<FoxButton>();
      expect(focusedButton?.label, 'إلغاء');
    });

    testWidgets('traps Tab inside', (tester) async {
      await _openDialog(tester, (_) => _deleteDialog());
      for (var n = 0; n < 6; n++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        final node = focused?.context;
        expect(node, isNotNull);
        expect(
          node!.findAncestorWidgetOfExactType<FoxDialog>(),
          isNotNull,
          reason: 'Tab $n left the dialog',
        );
      }
    });

    testWidgets('Escape closes it and focus returns to the trigger', (
      tester,
    ) async {
      await _openDialog(tester, (_) => _deleteDialog());
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(FoxDialog), findsNothing);
      expect(
        focused?.context?.findAncestorWidgetOfExactType<FoxButton>()?.label,
        'افتح',
      );
    });

    testWidgets('the system back button closes it', (tester) async {
      await _openDialog(tester, (_) => _deleteDialog());
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byType(FoxDialog), findsNothing);
    });

    testWidgets('a tap on the scrim closes it', (tester) async {
      await _openDialog(tester, (_) => _deleteDialog());
      await tester.tapAt(const Offset(4, 4));
      await tester.pumpAndSettle();
      expect(find.byType(FoxDialog), findsNothing);
    });

    testWidgets('fades only under reduced motion', (tester) async {
      await _openDialog(
        tester,
        (_) => _deleteDialog(),
        disableAnimations: true,
      );
      expect(find.byType(ScaleTransition), findsNothing);
    });

    testWidgets('fits in RTL and at 130% and 200% text', (tester) async {
      await expectNoOverflowInApp(tester, () => Center(child: _deleteDialog()));
    });
  });

  group('FoxConfirmDialog (AP §7.4)', () {
    testWidgets('will not confirm without a reason', (tester) async {
      String? reason;
      await _openDialog(tester, (_) => _confirm(onConfirm: (r) => reason = r));
      await tester.tap(find.text('تأكيد الإلغاء'));
      await tester.pump();
      expect(reason, isNull);
      await tester.enterText(find.byType(EditableText), 'الزبون طلب الإلغاء');
      await tester.pump();
      await tester.tap(find.text('تأكيد الإلغاء'));
      await tester.pump();
      expect(reason, 'الزبون طلب الإلغاء');
    });

    testWidgets('a blank reason is no reason, and its error shows', (
      tester,
    ) async {
      String? reason;
      await _openDialog(tester, (_) => _confirm(onConfirm: (r) => reason = r));
      await tester.enterText(find.byType(EditableText), '   ');
      await tester.pump();
      await tester.tap(find.text('تأكيد الإلغاء'));
      await tester.pump();
      expect(reason, isNull);
      expect(find.text('السبب مطلوب'), findsOneWidget);
    });

    testWidgets('shows the money effect and who is notified', (tester) async {
      await _openDialog(tester, (_) => _confirm());
      expect(find.text('أثره على الأرصدة'), findsOneWidget);
      expect(find.byType(FoxAmountsSummary), findsOneWidget);
      for (final who in ['الزبون', 'المطعم', 'الكابتن']) {
        expect(find.text(who), findsOneWidget);
      }
    });

    testWidgets('the reason field, not the action, takes the first focus', (
      tester,
    ) async {
      await _openDialog(tester, (_) => _confirm());
      expect(
        focused?.context?.findAncestorWidgetOfExactType<FoxButton>(),
        isNull,
      );
      expect(
        focused?.context?.findAncestorWidgetOfExactType<EditableText>() ??
            (focused?.context?.widget is EditableText ? true : null),
        isNotNull,
      );
    });

    testWidgets('fits in RTL and at 130% and 200% text', (tester) async {
      await expectNoOverflowInApp(
        tester,
        () => SingleChildScrollView(child: _confirm()),
      );
    });
  });

  group('FoxBottomSheet', () {
    Future<void> open(
      WidgetTester tester, {
      bool sCurve = false,
      EdgeInsets viewPadding = EdgeInsets.zero,
    }) async {
      phoneScreen(tester);
      await tester.pumpWidget(
        overlayApp(
          _trigger(
            (context) => showFoxBottomSheet<void>(
              context,
              builder: (_) => FoxBottomSheet(
                title: 'حالة المطعم',
                closeLabel: 'إغلاق',
                sCurve: sCurve,
                child: const SizedBox(
                  height: FoxSpace.xxxl * 3,
                  child: Text('المحتوى'),
                ),
              ),
            ),
          ),
          viewPadding: viewPadding,
        ),
      );
      await tester.tap(find.text('افتح'));
      await tester.pumpAndSettle();
    }

    testWidgets('opens within the safe area', (tester) async {
      await open(
        tester,
        viewPadding: const EdgeInsets.only(bottom: FoxSpace.xl),
      );
      final sheet = tester.getRect(find.byType(FoxBottomSheet));
      final content = tester.getRect(find.text('المحتوى'));
      expect(sheet.bottom, 844);
      expect(content.bottom, lessThanOrEqualTo(844 - FoxSpace.xl));
    });

    testWidgets('is named by its title', (tester) async {
      await open(tester);
      final handle = tester.ensureSemantics();
      expect(find.bySemanticsLabel(RegExp('حالة المطعم')), findsWidgets);
      handle.dispose();
    });

    testWidgets('drag down closes it', (tester) async {
      await open(tester);
      await tester.drag(find.text('المحتوى'), const Offset(0, 400));
      await tester.pumpAndSettle();
      expect(find.byType(FoxBottomSheet), findsNothing);
    });

    testWidgets('a short drag springs back', (tester) async {
      await open(tester);
      await tester.drag(find.text('المحتوى'), const Offset(0, 20));
      await tester.pumpAndSettle();
      expect(find.byType(FoxBottomSheet), findsOneWidget);
    });

    testWidgets('the scrim closes it', (tester) async {
      await open(tester);
      await tester.tapAt(const Offset(195, 20));
      await tester.pumpAndSettle();
      expect(find.byType(FoxBottomSheet), findsNothing);
    });

    testWidgets('Escape closes it', (tester) async {
      await open(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(FoxBottomSheet), findsNothing);
    });

    testWidgets('never grows past 90% of the screen', (tester) async {
      phoneScreen(tester);
      await tester.pumpWidget(
        overlayApp(
          _trigger(
            (context) => showFoxBottomSheet<void>(
              context,
              builder: (_) => FoxBottomSheet(
                title: 'طويلة',
                closeLabel: 'إغلاق',
                child: Column(
                  children: [
                    for (var n = 0; n < 40; n++)
                      SizedBox(height: FoxSpace.xxxl, child: Text('سطر $n')),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('افتح'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(
        tester.getRect(find.byType(FoxBottomSheet)).height,
        lessThanOrEqualTo(844 * 0.9 + 0.5),
      );
    });

    testWidgets('the S-curve tab holds the title', (tester) async {
      await open(tester, sCurve: true);
      final title = tester.getRect(find.text('حالة المطعم'));
      final sheet = tester.getRect(find.byType(FoxBottomSheet));
      // On the start side (right in RTL), in the raised tab at the top.
      expect(title.center.dx, greaterThan(sheet.center.dx));
      expect(title.top, lessThan(sheet.top + FoxSpace.xxl));
    });

    testWidgets('fits in RTL and at 130% and 200% text', (tester) async {
      await expectNoOverflowInApp(
        tester,
        () => Align(
          alignment: Alignment.bottomCenter,
          child: FoxBottomSheet(
            title: 'شاورما عربي',
            closeLabel: 'إغلاق',
            sCurve: true,
            child: const Text('لحم، بطاطا، مخلل وثوم'),
          ),
        ),
      );
    });
  });

  group('FoxToast', () {
    late FoxToasterState toaster;

    Future<void> host(
      WidgetTester tester, {
      bool disableAnimations = false,
    }) async {
      phoneScreen(tester);
      await tester.pumpWidget(
        overlayApp(
          FoxToaster(
            bottomInset: 96,
            child: Builder(
              builder: (context) {
                toaster = FoxToaster.of(context);
                return const SizedBox.expand();
              },
            ),
          ),
          disableAnimations: disableAnimations,
        ),
      );
    }

    testWidgets('is announced politely, and assertively for danger', (
      tester,
    ) async {
      await host(tester);
      toaster.show(
        tone: FoxToastTone.success,
        message: 'حُفظت التغييرات',
        closeLabel: 'إغلاق',
      );
      await tester.pump();
      var said = tester.takeAnnouncements();
      expect(said.single.message, 'حُفظت التغييرات');
      expect(said.single.assertiveness, Assertiveness.polite);
      toaster.show(
        tone: FoxToastTone.danger,
        message: 'تعذّر الحفظ',
        closeLabel: 'إغلاق',
      );
      await tester.pump();
      said = tester.takeAnnouncements();
      expect(said.single.assertiveness, Assertiveness.assertive);
    });

    testWidgets('shows one at a time, above the bottom navigation', (
      tester,
    ) async {
      await host(tester);
      toaster.show(tone: FoxToastTone.info, message: 'أ', closeLabel: 'x');
      toaster.show(tone: FoxToastTone.info, message: 'ب', closeLabel: 'x');
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
      expect(find.byType(FoxToast), findsOneWidget);
      expect(find.text('ب'), findsOneWidget);
      expect(
        tester.getRect(find.byType(FoxToast)).bottom,
        lessThanOrEqualTo(844 - 96),
      );
    });

    testWidgets('success leaves after 4 s, warning after 6 s', (tester) async {
      await host(tester);
      toaster.show(tone: FoxToastTone.success, message: 'أ', closeLabel: 'x');
      await tester.pump(const Duration(milliseconds: 3900));
      expect(find.byType(FoxToast), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();
      expect(find.byType(FoxToast), findsNothing);
      toaster.show(tone: FoxToastTone.warning, message: 'ب', closeLabel: 'x');
      await tester.pump(const Duration(milliseconds: 5900));
      expect(find.byType(FoxToast), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();
      expect(find.byType(FoxToast), findsNothing);
    });

    testWidgets('danger stays until closed', (tester) async {
      await host(tester);
      toaster.show(tone: FoxToastTone.danger, message: 'أ', closeLabel: 'x');
      await tester.pump(const Duration(seconds: 30));
      expect(find.byType(FoxToast), findsOneWidget);
      await tester.tap(find.bySemanticsLabel('x'));
      await tester.pumpAndSettle();
      expect(find.byType(FoxToast), findsNothing);
    });

    testWidgets('hover pauses the timer', (tester) async {
      await host(tester);
      toaster.show(tone: FoxToastTone.info, message: 'أ', closeLabel: 'x');
      await tester.pump();
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      addTearDown(mouse.removePointer);
      await mouse.moveTo(tester.getCenter(find.byType(FoxToast)));
      await tester.pump(const Duration(seconds: 10));
      expect(find.byType(FoxToast), findsOneWidget);
      await mouse.moveTo(Offset.zero);
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      expect(find.byType(FoxToast), findsNothing);
    });

    testWidgets('its action is reachable by keyboard', (tester) async {
      var undone = 0;
      await host(tester);
      toaster.show(
        tone: FoxToastTone.success,
        message: 'أُضيف إلى السلة',
        closeLabel: 'إغلاق',
        actionLabel: 'تراجع',
        onAction: () => undone++,
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
      bool onAction() => find
          .ancestor(
            of: find.text('تراجع'),
            matching: find.byWidgetPredicate(
              (w) =>
                  w is Focus && w.focusNode != null && w.focusNode == focused,
            ),
          )
          .evaluate()
          .isNotEmpty;
      var found = false;
      for (var n = 0; n < 4 && !found; n++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        found = onAction();
      }
      expect(found, isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(undone, 1);
    });

    testWidgets('nothing moves under reduced motion', (tester) async {
      await host(tester, disableAnimations: true);
      toaster.show(tone: FoxToastTone.info, message: 'أ', closeLabel: 'x');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 16));
      final first = tester.getRect(find.byType(FoxToast));
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
      expect(tester.getRect(find.byType(FoxToast)), first);
    });

    testWidgets('fits in RTL and at 130% and 200% text', (tester) async {
      await expectNoOverflowInApp(
        tester,
        () => Center(
          child: FoxToast(
            tone: FoxToastTone.danger,
            message: 'تعذّر الحفظ، تحقق من الاتصال',
            closeLabel: 'إغلاق',
            actionLabel: 'أعد المحاولة',
            onAction: () {},
            onClose: () {},
          ),
        ),
      );
    });
  });

  group('FoxBanner', () {
    testWidgets('every tone has an icon and its words, never colour alone', (
      tester,
    ) async {
      phoneScreen(tester);
      await tester.pumpWidget(
        overlayApp(
          Column(
            children: [
              for (final tone in FoxBannerTone.values)
                FoxBanner(tone: tone, message: tone.name),
            ],
          ),
        ),
      );
      for (final tone in FoxBannerTone.values) {
        final banner = find.widgetWithText(FoxBanner, tone.name);
        expect(banner, findsOneWidget);
        expect(
          find.descendant(of: banner, matching: find.byType(FoxIcon)),
          findsOneWidget,
          reason: tone.name,
        );
      }
    });

    testWidgets('red is solid, the rest tinted (owner, 2026-11-24)', (
      tester,
    ) async {
      final theme = FoxThemeData.phone();
      phoneScreen(tester);
      await tester.pumpWidget(
        overlayApp(
          const Column(
            children: [
              FoxBanner(tone: FoxBannerTone.danger, message: 'أحمر'),
              FoxBanner(tone: FoxBannerTone.caution, message: 'أصفر'),
            ],
          ),
          theme: theme,
        ),
      );
      Color? fill(String text) {
        final box = tester.widget<DecoratedBox>(
          find
              .descendant(
                of: find.widgetWithText(FoxBanner, text),
                matching: find.byType(DecoratedBox),
              )
              .first,
        );
        return (box.decoration as BoxDecoration).color;
      }

      expect(fill('أحمر'), theme.colors.danger);
      expect(fill('أصفر'), theme.colors.cautionSubtle);
    });

    testWidgets('fits in RTL and at 130% and 200% text', (tester) async {
      await expectNoOverflowInApp(
        tester,
        () => FoxBanner(
          tone: FoxBannerTone.danger,
          message: 'لا يوجد اتصال بالإنترنت — لن تصلك الطلبات الجديدة',
          actionLabel: 'أعد المحاولة',
          onAction: () {},
        ),
      );
    });
  });

  group('FoxBannerStack (RA §6.3)', () {
    List<FoxBanner> five() => [
      for (final (n, tone) in [
        (1, FoxBannerTone.danger),
        (2, FoxBannerTone.danger),
        (3, FoxBannerTone.caution),
        (4, FoxBannerTone.warning),
        (5, FoxBannerTone.neutral),
      ])
        FoxBanner(tone: tone, message: 'شريط $n'),
    ];

    testWidgets('shows the first two in the given order and counts the rest', (
      tester,
    ) async {
      phoneScreen(tester);
      await tester.pumpWidget(
        overlayApp(
          Align(
            alignment: Alignment.topCenter,
            child: FoxBannerStack(
              banners: five(),
              moreLabel: (n) => '+$n تنبيهات أخرى',
              lessLabel: 'إخفاء',
            ),
          ),
        ),
      );
      expect(find.text('شريط 1'), findsOneWidget);
      expect(find.text('شريط 2'), findsOneWidget);
      expect(find.text('شريط 3'), findsNothing);
      expect(
        tester.getRect(find.text('شريط 1')).top,
        lessThan(tester.getRect(find.text('شريط 2')).top),
      );
      expect(find.text('+3 تنبيهات أخرى'), findsOneWidget);
    });

    testWidgets('the counter opens the rest in place and folds them', (
      tester,
    ) async {
      phoneScreen(tester);
      await tester.pumpWidget(
        overlayApp(
          Align(
            alignment: Alignment.topCenter,
            child: FoxBannerStack(
              banners: five(),
              moreLabel: (n) => '+$n تنبيهات أخرى',
              lessLabel: 'إخفاء',
            ),
          ),
        ),
      );
      await tester.tap(find.text('+3 تنبيهات أخرى'));
      await tester.pumpAndSettle();
      for (var n = 1; n <= 5; n++) {
        expect(find.text('شريط $n'), findsOneWidget);
      }
      await tester.tap(find.text('إخفاء'));
      await tester.pumpAndSettle();
      expect(find.text('شريط 3'), findsNothing);
    });

    testWidgets('two or fewer have no counter', (tester) async {
      phoneScreen(tester);
      await tester.pumpWidget(
        overlayApp(
          FoxBannerStack(
            banners: five().take(2).toList(),
            moreLabel: (n) => '+$n',
            lessLabel: 'إخفاء',
          ),
        ),
      );
      expect(find.text('+0'), findsNothing);
      expect(find.text('إخفاء'), findsNothing);
    });
  });

  group('FoxMenu', () {
    late List<String> chosen;

    Widget menu() => Align(
      alignment: AlignmentDirectional.topStart,
      child: FoxMenu(
        label: 'قائمة المستخدم',
        items: [
          FoxMenuItem(
            label: 'الملف الشخصي',
            icon: FoxIcons.account,
            onSelected: () => chosen.add('profile'),
          ),
          FoxMenuItem(
            label: 'الجلسات',
            icon: FoxIcons.settings,
            onSelected: () => chosen.add('sessions'),
          ),
          const FoxMenuItem.separator(),
          FoxMenuItem(
            label: 'تسجيل الخروج',
            destructive: true,
            onSelected: () => chosen.add('out'),
          ),
        ],
        builder: (context, open) => FoxButton(label: 'سارة', onPressed: open),
      ),
    );

    Future<void> openByKeyboard(
      WidgetTester tester, {
      TextDirection direction = TextDirection.rtl,
    }) async {
      chosen = [];
      phoneScreen(tester);
      await tester.pumpWidget(overlayApp(menu(), direction: direction));
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
    }

    String? focusedLabel() {
      final context = focused?.context;
      if (context == null) return null;
      for (final label in ['الملف الشخصي', 'الجلسات', 'تسجيل الخروج']) {
        if (find
            .descendant(
              of: find.byWidget(context.widget),
              matching: find.text(label),
            )
            .evaluate()
            .isNotEmpty) {
          return label;
        }
      }
      return null;
    }

    testWidgets('arrows, Home and End move along the items', (tester) async {
      await openByKeyboard(tester);
      expect(focusedLabel(), 'الملف الشخصي');
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(focusedLabel(), 'الجلسات');
      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pump();
      expect(focusedLabel(), 'تسجيل الخروج');
      await tester.sendKeyEvent(LogicalKeyboardKey.home);
      await tester.pump();
      expect(focusedLabel(), 'الملف الشخصي');
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pump();
      expect(focusedLabel(), 'الملف الشخصي');
    });

    testWidgets('type-ahead moves to the item that starts so', (tester) async {
      await openByKeyboard(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyT, character: 'ت');
      await tester.pump();
      expect(focusedLabel(), 'تسجيل الخروج');
    });

    testWidgets('Enter picks, closes and returns focus', (tester) async {
      await openByKeyboard(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(chosen, ['sessions']);
      expect(find.text('الجلسات'), findsNothing);
      expect(
        focused?.context?.findAncestorWidgetOfExactType<FoxButton>()?.label,
        'سارة',
      );
    });

    testWidgets('Escape closes it and returns focus to the trigger', (
      tester,
    ) async {
      await openByKeyboard(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('الجلسات'), findsNothing);
      expect(chosen, isEmpty);
      expect(
        focused?.context?.findAncestorWidgetOfExactType<FoxButton>()?.label,
        'سارة',
      );
    });

    testWidgets('opens aligned to the start side in RTL and in LTR', (
      tester,
    ) async {
      for (final direction in TextDirection.values) {
        await openByKeyboard(tester, direction: direction);
        final trigger = tester.getRect(find.byType(FoxButton));
        final list = tester.getRect(find.byKey(FoxMenu.panelKey));
        if (direction == TextDirection.rtl) {
          expect(list.right, moreOrLessEquals(trigger.right));
        } else {
          expect(list.left, moreOrLessEquals(trigger.left));
        }
        expect(list.top, greaterThanOrEqualTo(trigger.bottom));
      }
    });

    testWidgets('the destructive item reads in danger', (tester) async {
      await openByKeyboard(tester);
      final text = tester.widget<Text>(find.text('تسجيل الخروج'));
      expect(text.style?.color, FoxThemeData.phone().colors.danger);
    });
  });

  // The parity gaps of D.W3c, each the web's or the D.10 sheet's look.
  group('parity with the web (D.W3c)', () {
    final tokens = FoxThemeData.phone().components;

    testWidgets('a dialog shares its row between its two actions', (
      tester,
    ) async {
      phoneScreen(tester);
      await tester.pumpWidget(overlayApp(Center(child: _deleteDialog())));
      final delete = tester.getRect(find.widgetWithText(FoxButton, 'حذف'));
      final cancel = tester.getRect(find.widgetWithText(FoxButton, 'إلغاء'));
      expect(delete.width, moreOrLessEquals(cancel.width));
      expect(
        (delete.left - cancel.right).abs(),
        moreOrLessEquals(tokens.dialog.actionsGap),
      );
    });

    testWidgets('a banner with two actions is as tall as its content', (
      tester,
    ) async {
      phoneScreen(tester);
      await tester.pumpWidget(
        overlayApp(
          Align(
            alignment: Alignment.topCenter,
            child: FoxBanner(
              tone: FoxBannerTone.danger,
              message: 'حسابك موقوف',
              actionLabel: 'اتصال',
              onAction: () {},
              secondaryActionLabel: 'واتساب',
              onSecondaryAction: () {},
            ),
          ),
        ),
      );
      expect(
        tester.getSize(find.byType(FoxBanner)).height,
        lessThan(FoxSize.touchTarget * 3),
      );
    });

    testWidgets('the menu is at least the sheet\'s 240 wide', (tester) async {
      phoneScreen(tester);
      await tester.pumpWidget(
        overlayApp(
          Align(
            alignment: AlignmentDirectional.topStart,
            child: FoxMenu(
              label: 'المزيد',
              initiallyOpen: true,
              items: [FoxMenuItem(label: 'تعديل', onSelected: () {})],
              builder: (context, open) =>
                  FoxButton(label: 'المزيد', onPressed: open),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester.getSize(find.byKey(FoxMenu.panelKey)).width,
        greaterThanOrEqualTo(tokens.menu.minWidth),
      );
    });

    testWidgets('a toast keeps sm between its icon and its words', (
      tester,
    ) async {
      phoneScreen(tester);
      await tester.pumpWidget(
        overlayApp(
          const Center(
            child: FoxToast(
              tone: FoxToastTone.info,
              message: 'نُسخ رقم الطلب',
              closeLabel: 'إغلاق',
            ),
          ),
        ),
      );
      final icon = tester.getRect(find.byType(FoxIcon).first);
      final words = tester.getRect(find.text('نُسخ رقم الطلب'));
      expect(icon.left - words.right, moreOrLessEquals(tokens.toast.gap));
    });
  });
}
