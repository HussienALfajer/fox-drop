import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:material_ui/material_ui.dart' as m;

import '../theme/fox_theme.dart';
import 'fox_material_localizations.dart';

/// What `material_ui` needs above its widgets (the text entry and the pickers,
/// architecture §9.10): a [m.Theme] built wholly from the tokens, a
/// transparent [m.Material], the FOX DROP localizations, and no ripples.
/// Material never leaks past this scope: no component draws a Material look.
class MaterialScope extends StatelessWidget {
  const MaterialScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    // Localizations forces the locale's direction; the surrounding one wins.
    final direction = Directionality.of(context);
    final body = Directionality(
      textDirection: direction,
      child: m.Theme(
        data: materialData(theme),
        child: m.Material(type: m.MaterialType.transparency, child: child),
      ),
    );
    const locale = Locale('ar');
    final delegates = <LocalizationsDelegate<dynamic>>[
      GlobalWidgetsLocalizations.delegate,
      FoxMaterialLocalizations.delegate,
    ];
    // An app has localizations above (its other delegates stay); a bare test
    // or catalogue does not.
    return Localizations.maybeLocaleOf(context) == null
        ? Localizations(locale: locale, delegates: delegates, child: body)
        : Localizations.override(
            context: context,
            locale: locale,
            delegates: delegates,
            child: body,
          );
  }

  /// The minimal Material theme of [theme].
  static m.ThemeData materialData(FoxThemeData theme) {
    final c = theme.colors;
    final i = theme.input;
    final text = theme.text;
    final scheme = m.ColorScheme(
      brightness: Brightness.light,
      primary: i.accent,
      onPrimary: i.checkMark,
      secondary: i.accent,
      onSecondary: i.checkMark,
      error: i.error,
      onError: c.onDanger,
      surface: c.surfaceRaised,
      onSurface: i.text,
    );
    final none = c.surface.withValues(alpha: 0);
    final shape = m.RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(t.FoxRadius.lg),
    );
    return m.ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: t.FoxFont.family,
      splashFactory: m.NoSplash.splashFactory,
      highlightColor: none,
      hoverColor: none,
      scaffoldBackgroundColor: c.surface,
      textTheme: m.TextTheme(
        displayLarge: text.largeTitle,
        displayMedium: text.largeTitle,
        displaySmall: text.title,
        headlineLarge: text.title,
        headlineMedium: text.title,
        headlineSmall: text.title,
        titleLarge: text.title,
        titleMedium: text.subtitle,
        titleSmall: text.subtitle,
        bodyLarge: text.body,
        bodyMedium: text.body,
        bodySmall: text.caption,
        labelLarge: text.subtitle,
        labelMedium: text.secondary,
        labelSmall: text.caption,
      ).apply(bodyColor: i.text, displayColor: i.text),
      textSelectionTheme: m.TextSelectionThemeData(
        cursorColor: i.accent,
        selectionColor: c.surfaceRaisedPressed,
        selectionHandleColor: i.accent,
      ),
      datePickerTheme: m.DatePickerThemeData(
        backgroundColor: c.surfaceRaised,
        surfaceTintColor: none,
        shape: shape,
        headerBackgroundColor: c.surfaceRaised,
        headerForegroundColor: i.text,
        todayForegroundColor: m.WidgetStatePropertyAll(i.accent),
        todayBorder: BorderSide(color: i.accent),
        confirmButtonStyle: m.TextButton.styleFrom(foregroundColor: i.accent),
        cancelButtonStyle: m.TextButton.styleFrom(foregroundColor: i.text),
      ),
      timePickerTheme: m.TimePickerThemeData(
        backgroundColor: c.surfaceRaised,
        shape: shape,
        hourMinuteColor: c.surface,
        hourMinuteTextColor: i.text,
        dayPeriodColor: c.surface,
        dayPeriodTextColor: i.text,
        dialBackgroundColor: c.surface,
        dialHandColor: i.accent,
        entryModeIconColor: i.text,
        helpTextStyle: text.secondary,
        inputDecorationTheme: const m.InputDecorationTheme(
          border: m.InputBorder.none,
        ),
      ),
      textButtonTheme: m.TextButtonThemeData(
        style: m.TextButton.styleFrom(
          foregroundColor: i.accent,
          textStyle: text.subtitle,
        ),
      ),
    );
  }
}
