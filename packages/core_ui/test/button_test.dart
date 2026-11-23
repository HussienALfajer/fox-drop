import 'package:core_ui/core_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

final _theme = FoxThemeData.phone();

Widget _app(
  Widget child, {
  TextDirection direction = TextDirection.rtl,
  double textScale = 1,
}) => MediaQuery(
  data: MediaQueryData(
    size: const Size(360, 640),
    textScaler: TextScaler.linear(textScale),
  ),
  child: FoxTheme(
    data: _theme,
    child: Directionality(
      textDirection: direction,
      child: Center(child: child),
    ),
  ),
);

BoxDecoration _decoration(WidgetTester tester) =>
    tester.widget<AnimatedContainer>(find.byType(AnimatedContainer)).decoration!
        as BoxDecoration;

BoxDecoration _outline(WidgetTester tester) =>
    tester
            .widget<AnimatedContainer>(find.byType(AnimatedContainer))
            .foregroundDecoration!
        as BoxDecoration;

FocusNode _focus(WidgetTester tester) =>
    Focus.of(tester.element(find.byType(GestureDetector)));

void main() {
  tearDown(() {
    FocusManager.instance.highlightStrategy = FocusHighlightStrategy.automatic;
  });

  testWidgets('is a named button at least 48 by 48', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(_app(FoxButton(label: 'اطلب', onPressed: () {})));
    expect(
      tester.getSemantics(find.byType(FoxButton)),
      matchesSemantics(
        label: 'اطلب',
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        isFocusable: true,
        hasTapAction: true,
        hasFocusAction: true,
      ),
    );
    expect(tester.getSize(find.byType(FoxButton)).height, 50);

    await tester.pumpWidget(
      _app(
        FoxButton.icon(icon: FoxIcons.close, label: 'إغلاق', onPressed: () {}),
      ),
    );
    expect(tester.getSize(find.byType(FoxButton)), const Size(50, 50));
    expect(find.bySemanticsLabel('إغلاق'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('Enter and Space activate it; taps call onPressed', (
    tester,
  ) async {
    var presses = 0;
    await tester.pumpWidget(
      _app(FoxButton(label: 'اطلب', onPressed: () => presses++)),
    );
    await tester.tap(find.byType(FoxButton));
    _focus(tester).requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    expect(presses, 3);
  });

  testWidgets('disabled: not focusable, ignores taps and keys', (tester) async {
    await tester.pumpWidget(
      _app(const FoxButton(label: 'اطلب', onPressed: null)),
    );
    expect(_focus(tester).canRequestFocus, isFalse);
    await tester.tap(find.byType(FoxButton), warnIfMissed: false);
    expect(tester.takeException(), isNull);
  });

  testWidgets('loading: focusable, keeps width and name, ignores presses', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    var presses = 0;
    Widget button(bool loading) => _app(
      FoxButton(
        label: 'اطلب الآن',
        loading: loading,
        onPressed: () => presses++,
      ),
    );
    await tester.pumpWidget(button(false));
    final width = tester.getSize(find.byType(FoxButton)).width;
    await tester.pumpWidget(button(true));
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.getSize(find.byType(FoxButton)).width, width);
    expect(find.bySemanticsLabel('اطلب الآن'), findsOneWidget);
    expect(_focus(tester).canRequestFocus, isTrue);
    await tester.tap(find.byType(FoxButton));
    _focus(tester).requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(presses, 0);
    semantics.dispose();
  });

  testWidgets('the start icon sits right of the label in RTL', (tester) async {
    for (final direction in TextDirection.values) {
      await tester.pumpWidget(
        _app(
          FoxButton(
            label: 'رجوع',
            icon: FoxIcons.add,
            iconEnd: FoxIcons.close,
            onPressed: () {},
          ),
          direction: direction,
        ),
      );
      final label = tester.getCenter(find.text('رجوع')).dx;
      final start = tester.getCenter(find.byType(FoxIcon).first).dx;
      final end = tester.getCenter(find.byType(FoxIcon).last).dx;
      if (direction == TextDirection.rtl) {
        expect(start, greaterThan(label));
        expect(end, lessThan(label));
      } else {
        expect(start, lessThan(label));
        expect(end, greaterThan(label));
      }
    }
  });

  testWidgets('no overflow and no clipped label at 130% and 200% text', (
    tester,
  ) async {
    for (final scale in [1.3, 2.0]) {
      await tester.pumpWidget(
        _app(
          FoxButton(
            label: 'تأكيد الطلب والدفع عند الاستلام',
            icon: FoxIcons.confirm,
            onPressed: () {},
          ),
          textScale: scale,
        ),
      );
      expect(tester.takeException(), isNull, reason: '$scale');
      final button = tester.getRect(find.byType(FoxButton));
      final label = tester.getRect(
        find.text('تأكيد الطلب والدفع عند الاستلام'),
      );
      expect(button.contains(label.topLeft), isTrue, reason: '$scale');
      expect(
        button.contains(label.bottomRight - const Offset(0.01, 0.01)),
        isTrue,
      );
    }
  });

  group('each state paints its token (R10)', () {
    final b = _theme.button;
    final variants = {
      FoxButtonVariant.primary: (
        b.primaryBackground,
        b.primaryBackgroundHover,
        b.primaryBackgroundPressed,
      ),
      FoxButtonVariant.secondary: (
        b.secondaryBackground,
        b.secondaryBackgroundHover,
        b.secondaryBackgroundPressed,
      ),
      FoxButtonVariant.danger: (
        b.dangerBackground,
        b.dangerBackgroundHover,
        b.dangerBackgroundPressed,
      ),
      FoxButtonVariant.ghost: (
        b.ghostBackgroundHover.withValues(alpha: 0),
        b.ghostBackgroundHover,
        b.ghostBackgroundPressed,
      ),
    };

    for (final MapEntry(key: variant, value: (rest, hover, pressed))
        in variants.entries) {
      testWidgets(variant.name, (tester) async {
        await tester.pumpWidget(
          _app(FoxButton(label: 'اطلب', variant: variant, onPressed: () {})),
        );
        expect(_decoration(tester).color, rest);
        expect(_decoration(tester).boxShadow, isEmpty);

        final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
        await mouse.addPointer(location: Offset.zero);
        await mouse.moveTo(tester.getCenter(find.byType(FoxButton)));
        await tester.pumpAndSettle();
        expect(_decoration(tester).color, hover);
        if (variant == FoxButtonVariant.secondary) {
          expect(_outline(tester).border!.top.color, b.secondaryBorderHover);
        }

        final touch = await tester.startGesture(
          tester.getCenter(find.byType(FoxButton)),
        );
        await tester.pumpAndSettle();
        expect(_decoration(tester).color, pressed);
        await touch.up();
        await mouse.moveTo(Offset.zero);
        await tester.pumpAndSettle();
        expect(_decoration(tester).color, rest);

        FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.alwaysTraditional;
        _focus(tester).requestFocus();
        await tester.pumpAndSettle();
        expect(_decoration(tester).boxShadow!.map((s) => s.color), [
          b.focusRing,
          _theme.colors.surface,
        ]);
        await mouse.removePointer();
      });
    }

    testWidgets('disabled and loading', (tester) async {
      await tester.pumpWidget(
        _app(const FoxButton(label: 'اطلب', onPressed: null)),
      );
      expect(_decoration(tester).color, b.disabledBackground);
      expect(
        tester.widget<Text>(find.text('اطلب')).style!.color,
        b.disabledLabel,
      );

      await tester.pumpWidget(
        _app(FoxButton(label: 'اطلب', loading: true, onPressed: () {})),
      );
      final touch = await tester.startGesture(
        tester.getCenter(find.byType(FoxButton)),
      );
      await tester.pump(const Duration(milliseconds: 300));
      expect(_decoration(tester).color, b.primaryBackground);
      await touch.up();
    });
  });
}
