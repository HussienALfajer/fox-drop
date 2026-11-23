import 'package:core_tokens/core_tokens.dart' as t;
import 'package:core_ui/core_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FoxThemeData', () {
    for (final (name, theme, colors, button, type) in [
      (
        'phone',
        FoxThemeData.phone(),
        t.FoxColors.light,
        t.FoxButton.light,
        t.FoxType.phone,
      ),
      (
        'captain',
        FoxThemeData.captain(),
        t.FoxColors.captainLight,
        t.FoxButton.captainLight,
        t.FoxType.captain,
      ),
    ]) {
      test('$name: every colour equals its token', () {
        final c = theme.colors;
        final pairs = <(Color, int)>[
          (c.surface, colors.surface),
          (c.surfaceRaised, colors.surfaceRaised),
          (c.surfaceHover, colors.surfaceHover),
          (c.surfacePressed, colors.surfacePressed),
          (c.surfaceRaisedHover, colors.surfaceRaisedHover),
          (c.surfaceRaisedPressed, colors.surfaceRaisedPressed),
          (c.onSurface, colors.onSurface),
          (c.onSurfaceMuted, colors.onSurfaceMuted),
          (c.brand, colors.brand),
          (c.primary, colors.primary),
          (c.primaryHover, colors.primaryHover),
          (c.primaryPressed, colors.primaryPressed),
          (c.onPrimary, colors.onPrimary),
          (c.heading, colors.heading),
          (c.accent, colors.accent),
          (c.onAccent, colors.onAccent),
          (c.border, colors.border),
          (c.borderStrong, colors.borderStrong),
          (c.borderHover, colors.borderHover),
          (c.focusRing, colors.focusRing),
          (c.success, colors.success),
          (c.onSuccess, colors.onSuccess),
          (c.warning, colors.warning),
          (c.onWarning, colors.onWarning),
          (c.danger, colors.danger),
          (c.dangerHover, colors.dangerHover),
          (c.dangerPressed, colors.dangerPressed),
          (c.onDanger, colors.onDanger),
          (c.info, colors.info),
          (c.onInfo, colors.onInfo),
          (c.alert, colors.alert),
          (c.onAlert, colors.onAlert),
          (c.disabled, colors.disabled),
          (c.onDisabled, colors.onDisabled),
          (c.chart1, colors.chart1),
          (c.chart2, colors.chart2),
          (c.chart3, colors.chart3),
          (c.chart4, colors.chart4),
          (c.chart5, colors.chart5),
          (c.chart6, colors.chart6),
        ];
        for (final (i, (color, token)) in pairs.indexed) {
          expect(color.toARGB32(), token, reason: 'colour $i');
        }
      });

      test('$name: every button token is carried over', () {
        final b = theme.button;
        expect(
          [b.height, b.paddingInline, b.gap, b.radius],
          [button.height, button.paddingInline, button.gap, button.radius],
        );
        final pairs = <(Color, int)>[
          (b.focusRing, button.focusRing),
          (b.primaryBackground, button.primaryBackground),
          (b.primaryBackgroundHover, button.primaryBackgroundHover),
          (b.primaryBackgroundPressed, button.primaryBackgroundPressed),
          (b.primaryLabel, button.primaryLabel),
          (b.secondaryBackground, button.secondaryBackground),
          (b.secondaryBackgroundHover, button.secondaryBackgroundHover),
          (b.secondaryBackgroundPressed, button.secondaryBackgroundPressed),
          (b.secondaryBorder, button.secondaryBorder),
          (b.secondaryBorderHover, button.secondaryBorderHover),
          (b.secondaryLabel, button.secondaryLabel),
          (b.dangerBackground, button.dangerBackground),
          (b.dangerBackgroundHover, button.dangerBackgroundHover),
          (b.dangerBackgroundPressed, button.dangerBackgroundPressed),
          (b.dangerLabel, button.dangerLabel),
          (b.ghostBackgroundHover, button.ghostBackgroundHover),
          (b.ghostBackgroundPressed, button.ghostBackgroundPressed),
          (b.ghostLabel, button.ghostLabel),
          (b.disabledBackground, button.disabledBackground),
          (b.disabledLabel, button.disabledLabel),
        ];
        for (final (i, (color, token)) in pairs.indexed) {
          expect(color.toARGB32(), token, reason: 'button colour $i');
        }
      });

      test('$name: every text role is CoFo at its size, height and weight', () {
        final x = theme.text;
        final pairs = <(TextStyle, t.TypeRole)>[
          (x.caption, type.caption),
          (x.secondary, type.secondary),
          (x.body, type.body),
          (x.subtitle, type.subtitle),
          (x.title, type.title),
          (x.largeTitle, type.largeTitle),
          (x.number, type.number),
        ];
        for (final (style, role) in pairs) {
          expect(style.fontFamily, t.FoxFont.family);
          expect(style.fontSize, role.size);
          expect(style.height, role.lineHeight);
          expect(style.fontWeight!.value, role.weight);
        }
        expect(x.number.fontFeatures, [const FontFeature.tabularFigures()]);
        expect(x.body.fontFeatures, isNull);
      });
    }

    test('shadows and easing come from the tokens', () {
      final theme = FoxThemeData.phone();
      final low = t.FoxElevation.low;
      expect(theme.shadows.low.color.toARGB32(), low.color);
      expect(theme.shadows.low.offset, Offset(low.offsetX, low.offsetY));
      expect(theme.shadows.low.blurRadius, low.blur);
      expect(
        theme.shadows.offset.color.toARGB32(),
        t.FoxElevation.offset.color,
      );
      final easing = theme.easing as Cubic;
      expect([easing.a, easing.b, easing.c, easing.d], t.FoxEasing.standard);
    });
  });

  testWidgets('FoxTheme.of finds the theme and fails without one', (
    tester,
  ) async {
    final data = FoxThemeData.captain();
    late FoxThemeData found;
    await tester.pumpWidget(
      FoxTheme(
        data: data,
        child: Builder(
          builder: (context) {
            found = FoxTheme.of(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    expect(found, same(data));

    await tester.pumpWidget(
      Builder(
        builder: (context) {
          FoxTheme.of(context);
          return const SizedBox.shrink();
        },
      ),
    );
    expect(tester.takeException(), isA<FlutterError>());
  });
}
