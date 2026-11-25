import 'dart:io';

import 'package:core_ui/core_ui.dart';
import 'package:core_ui/src/drop_loader/fox_drop_loader.dart'
    show MarkPainter, markFillAt;
import 'package:core_ui/src/drop_loader/mark_geometry.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget child, {bool still = false}) => MediaQuery(
  data: MediaQueryData(size: const Size(360, 640), disableAnimations: still),
  child: FoxTheme(
    data: FoxThemeData.phone(),
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: Center(child: child),
    ),
  ),
);

void main() {
  test('draws the brand mark from the brand file, never redrawn by hand', () {
    final svg = File(
      '../../docs/brand/logo/mark/mark-orange-on-ivory-drop.svg',
    ).readAsStringSync();
    final paths = RegExp(
      r'<path d="([^"]*)"',
    ).allMatches(svg).map((m) => m.group(1)).toList();
    expect(paths, [markDrop, ...markPieces]);
  });

  testWidgets('names itself by its label in a live region', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(_app(const FoxDropLoader(label: 'جارٍ التحميل')));
    expect(
      tester.getSemantics(find.byType(FoxDropLoader)),
      matchesSemantics(label: 'جارٍ التحميل', isLiveRegion: true),
    );
    semantics.dispose();
  });

  testWidgets('is silent without a label (inside a busy control)', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(_app(const FoxDropLoader()));
    expect(find.bySemanticsLabel(RegExp('.')), findsNothing);
    semantics.dispose();
  });

  testWidgets('takes its size: sm 16, md 24, lg 48', (tester) async {
    for (final (size, side) in [
      (FoxDropLoaderSize.sm, FoxSize.iconSm),
      (FoxDropLoaderSize.md, FoxSize.iconMd),
      (FoxDropLoaderSize.lg, FoxSize.touchTarget),
    ]) {
      await tester.pumpWidget(_app(FoxDropLoader(size: size)));
      expect(tester.getSize(find.byType(FoxDropLoader)), Size.square(side));
    }
  });

  testWidgets('size sm draws the drop alone with a flat surface', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(const FoxDropLoader(size: FoxDropLoaderSize.sm)),
    );
    final painter = tester
        .widget<CustomPaint>(
          find.descendant(
            of: find.byType(FoxDropLoader),
            matching: find.byType(CustomPaint),
          ),
        )
        .painter!;
    expect(painter, isA<MarkPainter>());
    expect((painter as MarkPainter).dropOnly, isTrue);
    expect(painter.wave, 0);
  });

  testWidgets('moves, and stands still half full under reduced motion', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const FoxDropLoader()));
    expect(tester.hasRunningAnimations, isTrue);
    await tester.pumpWidget(_app(const FoxDropLoader(), still: true));
    expect(tester.hasRunningAnimations, isFalse);
    final painter =
        tester
                .widget<CustomPaint>(
                  find.descendant(
                    of: find.byType(FoxDropLoader),
                    matching: find.byType(CustomPaint),
                  ),
                )
                .painter!
            as MarkPainter;
    expect(painter.level, FoxMotion.markFillStillLevel);
    expect(painter.opacity, 1);
  });

  test('follows the motion tokens over one cycle', () {
    // Empty at the start, full at `rise`, fading over the last `fade`.
    expect(markFillAt(0).level, 0);
    expect(markFillAt(FoxMotion.markFillRise).level, 1);
    expect(markFillAt(0.8).level, 1);
    expect(markFillAt(0.8).opacity, 1);
    expect(markFillAt(1 - FoxMotion.markFillFade).opacity, 1);
    expect(markFillAt(1).opacity, closeTo(0, 1e-9));
    final mid = markFillAt(FoxMotion.markFillRise / 2).level;
    expect(mid, greaterThan(0));
    expect(mid, lessThan(1));
  });

  testWidgets('a fixed phase draws that point of the cycle and never ticks', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const FoxDropLoader(phase: 0.45)));
    expect(tester.hasRunningAnimations, isFalse);
  });

  group('its users', () {
    testWidgets('the loading button draws it, with its loading label', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        _app(
          FoxButton(
            label: 'أرسل الرمز',
            loadingLabel: 'جارٍ إرسال الرمز…',
            loading: true,
            onPressed: () {},
          ),
        ),
      );
      expect(find.byType(FoxDropLoader), findsOneWidget);
      expect(find.text('جارٍ إرسال الرمز…'), findsOneWidget);
      expect(find.bySemanticsLabel('جارٍ إرسال الرمز…'), findsOneWidget);
      expect(
        tester.widget<FoxDropLoader>(find.byType(FoxDropLoader)).onPrimary,
        isTrue,
      );
      semantics.dispose();
    });

    testWidgets('a secondary button draws it orange on the light ground', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          FoxButton(
            label: 'اطلب',
            variant: FoxButtonVariant.secondary,
            loading: true,
            onPressed: () {},
          ),
        ),
      );
      expect(
        tester.widget<FoxDropLoader>(find.byType(FoxDropLoader)).onPrimary,
        isFalse,
      );
    });

    testWidgets('pull to refresh draws the mark while refreshing', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(const FoxRefreshDrop(progress: 1, refreshing: true)),
      );
      expect(find.byType(FoxDropLoader), findsOneWidget);
      await tester.pumpWidget(_app(const FoxRefreshDrop(progress: 0.5)));
      expect(find.byType(FoxDropLoader), findsOneWidget);
      expect(
        tester.widget<FoxDropLoader>(find.byType(FoxDropLoader)).level,
        0.5,
      );
    });
  });
}
