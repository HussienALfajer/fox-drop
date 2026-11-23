import 'package:core_tokens/core_tokens.dart' as t;
import 'package:core_ui/core_ui.dart';
import 'package:core_ui/src/icon/path_data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// The bounds of the drawn outline, sampled along it: `Path.getBounds`
/// includes the control points of curves.
Rect _bounds(String d) {
  Rect? bounds;
  for (final metric in parseSvgPath(d).computeMetrics()) {
    for (var i = 0; i <= 1000; i++) {
      final point = metric
          .getTangentForOffset(metric.length * i / 1000)!
          .position;
      final dot = Rect.fromLTRB(point.dx, point.dy, point.dx, point.dy);
      bounds = bounds?.expandToInclude(dot) ?? dot;
    }
  }
  return bounds!;
}

void _expectRect(Rect actual, Rect expected) {
  for (final (a, e) in [
    (actual.left, expected.left),
    (actual.top, expected.top),
    (actual.right, expected.right),
    (actual.bottom, expected.bottom),
  ]) {
    expect(a, moreOrLessEquals(e, epsilon: 0.05), reason: '$actual');
  }
}

Widget _app(Widget child, {TextDirection direction = TextDirection.rtl}) =>
    FoxTheme(
      data: FoxThemeData.phone(),
      child: Directionality(textDirection: direction, child: child),
    );

void main() {
  group('parseSvgPath', () {
    test('parses every icon of the set inside the safe area 2..22', () {
      for (final MapEntry(:key, :value) in t.FoxIcons.all.entries) {
        for (final d in value.paths) {
          final b = _bounds(d);
          expect(b.isFinite, isTrue, reason: key);
          for (final edge in [b.left, b.top, b.right, b.bottom]) {
            expect(edge, inInclusiveRange(1.99, 22.01), reason: '$key $b');
          }
        }
      }
    });

    test('M, L, H, V and Z, absolute and relative', () {
      _expectRect(
        _bounds('M2 3L10 3H12V20Z'),
        const Rect.fromLTRB(2, 3, 12, 20),
      );
      _expectRect(_bounds('m2 3l8 0h2v17z'), const Rect.fromLTRB(2, 3, 12, 20));
      // Pairs after a moveto are lines.
      _expectRect(_bounds('M2 2 6 9'), const Rect.fromLTRB(2, 2, 6, 9));
      // Z returns to the subpath start, so a relative move goes from there.
      _expectRect(_bounds('M4 4h4z m1 1h1'), const Rect.fromLTRB(4, 4, 8, 5));
    });

    test('numbers touch without separators', () {
      // A repeated command needs no letter: H6-2 is H6 then H-2.
      _expectRect(_bounds('M9.5 21H6-2'), const Rect.fromLTRB(-2, 21, 9.5, 21));
      _expectRect(_bounds('M0 0L1-2-3 4'), const Rect.fromLTRB(-3, -2, 1, 4));
      _expectRect(_bounds('M.5.5l1.5.5'), const Rect.fromLTRB(0.5, 0.5, 2, 1));
    });

    test('C and S: S reflects the last control point', () {
      // A symmetric hump from 0 to 8 and back down to 16.
      final c = _bounds('M0 0C0 6 8 6 8 0');
      expect(c.bottom, moreOrLessEquals(4.5, epsilon: 0.01));
      final s = _bounds('M0 0C0 6 8 6 8 0S16 -6 16 0');
      expect(s.top, moreOrLessEquals(-4.5, epsilon: 0.01));
      expect(s.right, 16);
      final relative = _bounds('m0 0c0 6 8 6 8 0s8-6 8 0');
      _expectRect(relative, s);
    });

    test('Q and T: T reflects the last control point', () {
      final q = _bounds('M0 0Q4 8 8 0');
      expect(q.bottom, moreOrLessEquals(4, epsilon: 0.01));
      final tPath = _bounds('M0 0Q4 8 8 0T16 0');
      expect(tPath.top, moreOrLessEquals(-4, epsilon: 0.01));
      _expectRect(_bounds('m0 0q4 8 8 0t8 0'), tPath);
    });

    test('A: arcs, both sweeps, and flags that touch the next number', () {
      // A half circle of radius 4 from (2,6) to (10,6); sweep 1 bulges up
      // on a y-down canvas, sweep 0 down.
      final up = _bounds('M2 6A4 4 0 0 1 10 6');
      _expectRect(up, const Rect.fromLTRB(2, 2, 10, 6));
      final down = _bounds('M2 6A4 4 0 0 0 10 6');
      _expectRect(down, const Rect.fromLTRB(2, 6, 10, 10));
      _expectRect(_bounds('M2 6a4 4 0 0 1 8 0'), up);
      _expectRect(_bounds('M2 6a4 4 0 018 0'), up);
    });

    test('rejects unknown commands and data without a command', () {
      expect(() => parseSvgPath('M0 0X1 1'), throwsFormatException);
      expect(() => parseSvgPath('1 1'), throwsFormatException);
      // Z takes no numbers: a reader that never advanced would loop forever.
      expect(() => parseSvgPath('M0 0 Z 5'), throwsFormatException);
    });
  });

  group('FoxIcon', () {
    testWidgets('is as large as its size', (tester) async {
      for (final size in FoxIconSize.values) {
        await tester.pumpWidget(
          _app(Center(child: FoxIcon(t.FoxIcons.home, size: size))),
        );
        expect(tester.getSize(find.byType(FoxIcon)), Size.square(size.pixels));
      }
      expect(FoxIconSize.values.map((s) => s.pixels), [16, 24, 32]);
    });

    testWidgets('flips only back, car and motorcycle in RTL', (tester) async {
      for (final MapEntry(:key, :value) in t.FoxIcons.all.entries) {
        for (final direction in TextDirection.values) {
          await tester.pumpWidget(_app(FoxIcon(value), direction: direction));
          final painter = tester
              .widget<CustomPaint>(
                find.descendant(
                  of: find.byType(FoxIcon),
                  matching: find.byType(CustomPaint),
                ),
              )
              .painter!;
          final expected =
              direction == TextDirection.rtl &&
              ['back', 'car', 'motorcycle'].contains(key);
          expect(
            (painter as dynamic).mirrored,
            expected,
            reason: '$key $direction',
          );
        }
      }
    });

    testWidgets('hides a decorative icon and names a labelled one', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(_app(Row(children: [FoxIcon(t.FoxIcons.home)])));
      expect(find.bySemanticsLabel('الرئيسية'), findsNothing);
      await tester.pumpWidget(
        _app(Row(children: [FoxIcon(t.FoxIcons.home, label: 'الرئيسية')])),
      );
      expect(
        tester.getSemantics(find.byType(FoxIcon)),
        matchesSemantics(label: 'الرئيسية', isImage: true),
      );
      semantics.dispose();
    });
  });
}
