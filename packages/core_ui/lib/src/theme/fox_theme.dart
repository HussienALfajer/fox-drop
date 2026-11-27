import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';

/// The semantic colours of one theme (architecture §9.2), as Flutter
/// [Color]s read from the generated tokens.
@immutable
final class FoxColorScheme {
  const FoxColorScheme(this._tokens);

  final t.ColorTokens _tokens;

  Color get surface => Color(_tokens.surface);
  Color get surfaceRaised => Color(_tokens.surfaceRaised);
  Color get surfaceHover => Color(_tokens.surfaceHover);
  Color get surfacePressed => Color(_tokens.surfacePressed);
  Color get surfaceRaisedHover => Color(_tokens.surfaceRaisedHover);
  Color get surfaceRaisedPressed => Color(_tokens.surfaceRaisedPressed);
  Color get onSurface => Color(_tokens.onSurface);
  Color get onSurfaceMuted => Color(_tokens.onSurfaceMuted);
  Color get brand => Color(_tokens.brand);
  Color get primary => Color(_tokens.primary);
  Color get primaryHover => Color(_tokens.primaryHover);
  Color get primaryPressed => Color(_tokens.primaryPressed);
  Color get onPrimary => Color(_tokens.onPrimary);
  Color get heading => Color(_tokens.heading);
  Color get accent => Color(_tokens.accent);
  Color get navHalo => Color(_tokens.navHalo);
  Color get onAccent => Color(_tokens.onAccent);
  Color get border => Color(_tokens.border);
  Color get borderStrong => Color(_tokens.borderStrong);
  Color get borderHover => Color(_tokens.borderHover);
  Color get focusRing => Color(_tokens.focusRing);
  Color get success => Color(_tokens.success);
  Color get onSuccess => Color(_tokens.onSuccess);
  Color get warning => Color(_tokens.warning);
  Color get onWarning => Color(_tokens.onWarning);
  Color get danger => Color(_tokens.danger);
  Color get dangerHover => Color(_tokens.dangerHover);
  Color get dangerPressed => Color(_tokens.dangerPressed);
  Color get onDanger => Color(_tokens.onDanger);
  Color get info => Color(_tokens.info);
  Color get onInfo => Color(_tokens.onInfo);
  Color get successSubtle => Color(_tokens.successSubtle);
  Color get warningSubtle => Color(_tokens.warningSubtle);
  Color get dangerSubtle => Color(_tokens.dangerSubtle);
  Color get infoSubtle => Color(_tokens.infoSubtle);
  Color get primarySubtle => Color(_tokens.primarySubtle);
  Color get onPrimarySubtle => Color(_tokens.onPrimarySubtle);
  Color get neutral => Color(_tokens.neutral);
  Color get neutralSubtle => Color(_tokens.neutralSubtle);
  Color get caution => Color(_tokens.caution);
  Color get cautionSubtle => Color(_tokens.cautionSubtle);
  Color get scrim => Color(_tokens.scrim);
  Color get alert => Color(_tokens.alert);
  Color get onAlert => Color(_tokens.onAlert);
  Color get disabled => Color(_tokens.disabled);
  Color get onDisabled => Color(_tokens.onDisabled);
  Color get chart1 => Color(_tokens.chart1);
  Color get chart2 => Color(_tokens.chart2);
  Color get chart3 => Color(_tokens.chart3);
  Color get chart4 => Color(_tokens.chart4);
  Color get chart5 => Color(_tokens.chart5);
  Color get chart6 => Color(_tokens.chart6);
}

/// The type scale of one surface as [TextStyle]s in CoFo (brand expression
/// §7). `number` uses tabular figures so money and timers do not jump (R5).
@immutable
final class FoxTextTheme {
  FoxTextTheme(t.TypeScale scale)
    : caption = _style(scale.caption),
      secondary = _style(scale.secondary),
      body = _style(scale.body),
      subtitle = _style(scale.subtitle),
      title = _style(scale.title),
      largeTitle = _style(scale.largeTitle),
      number = _style(
        scale.number,
      ).copyWith(fontFeatures: const [FontFeature.tabularFigures()]);

  final TextStyle caption;
  final TextStyle secondary;
  final TextStyle body;
  final TextStyle subtitle;
  final TextStyle title;
  final TextStyle largeTitle;
  final TextStyle number;

  /// Fox Lira, this package's font holding only the ₺ that CoFo lacks
  /// (`assets/fonts/fox-lira`, cut from Noto Sans under the SIL OFL).
  static const liraFallback = 'packages/core_ui/Fox Lira';

  static TextStyle _style(t.TypeRole role) => TextStyle(
    fontFamily: t.FoxFont.family,
    fontFamilyFallback: const [liraFallback],
    fontSize: role.size,
    height: role.lineHeight,
    // CSS spreads the extra line height evenly above and below the text.
    leadingDistribution: TextLeadingDistribution.even,
    fontWeight: fontWeight(role.weight),
  );

  /// The [FontWeight] of a CSS weight such as 500.
  static FontWeight fontWeight(int weight) =>
      FontWeight.values.firstWhere((w) => w.value == weight);
}

/// The elevation shadows as [BoxShadow]s.
@immutable
final class FoxShadows {
  FoxShadows()
    : low = _shadow(t.FoxElevation.low),
      medium = _shadow(t.FoxElevation.medium),
      high = _shadow(t.FoxElevation.high),
      offset = _shadow(t.FoxElevation.offset);

  final BoxShadow low;
  final BoxShadow medium;
  final BoxShadow high;

  /// The customer app's solid offset shadow (R7).
  final BoxShadow offset;

  static BoxShadow _shadow(t.ShadowToken s) => BoxShadow(
    color: Color(s.color),
    offset: Offset(s.offsetX, s.offsetY),
    blurRadius: s.blur,
    spreadRadius: s.spread,
  );
}

/// The FOX DROP theme of one surface. Light only: the dark tokens copy light
/// until dark mode is designed (§9.2). Lengths stay in `FoxSpace`,
/// `FoxRadius` and `FoxSize`, which are the same on every surface.
@immutable
final class FoxThemeData {
  FoxThemeData._(t.ColorTokens colors, t.TypeScale type, this.iconWeight)
    : colors = FoxColorScheme(colors),
      text = FoxTextTheme(type);

  /// The customer and restaurant apps.
  factory FoxThemeData.phone() =>
      FoxThemeData._(t.FoxColors.light, t.FoxType.phone, t.FoxIconWeight.phone);

  /// The captain app: sunlight contrast and a larger scale (R7).
  factory FoxThemeData.captain() => FoxThemeData._(
    t.FoxColors.captainLight,
    t.FoxType.captain,
    t.FoxIconWeight.captain,
  );

  // A component's tokens (`tokens/component/`) come back with the first
  // approved component, read here as `components.<name>` (none since D.R1,
  // 2026-11-27).

  final FoxColorScheme colors;
  final FoxTextTheme text;

  /// The icon stroke (architecture §9.4): 1.5 on the phone, 1.75 for the
  /// captain; Bold and Bold Duo use the fills baked at it.
  final t.FoxIconWeight iconWeight;
  final FoxShadows shadows = FoxShadows();

  /// The standard easing curve of every transition.
  Curve get easing => Cubic(
    t.FoxEasing.standard[0],
    t.FoxEasing.standard[1],
    t.FoxEasing.standard[2],
    t.FoxEasing.standard[3],
  );
}

/// Puts a [FoxThemeData] in the tree for every `core_ui` widget below.
class FoxTheme extends InheritedWidget {
  const FoxTheme({super.key, required this.data, required super.child});

  final FoxThemeData data;

  /// The nearest theme. Every `core_ui` widget needs one above it.
  static FoxThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<FoxTheme>();
    if (theme == null) {
      throw FlutterError('No FoxTheme above this widget: wrap the app in one.');
    }
    return theme.data;
  }

  @override
  bool updateShouldNotify(FoxTheme oldWidget) => data != oldWidget.data;
}
