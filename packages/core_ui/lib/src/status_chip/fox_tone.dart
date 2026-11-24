import 'dart:ui' show Color;

import '../theme/fox_theme.dart';

/// The tones of the data display (D.9): each one's text on its own tint
/// (`*-subtle`), at 4.5:1, and 7:1 in the captain app.
enum FoxTone {
  success,
  warning,
  danger,
  info,
  primary,
  neutral;

  /// The text and icon colour. The primary tone's text is
  /// `on-primary-subtle`: the deepest orange, blue for the captain.
  Color strong(FoxColorScheme c) => switch (this) {
    success => c.success,
    warning => c.warning,
    danger => c.danger,
    info => c.info,
    primary => c.onPrimarySubtle,
    neutral => c.neutral,
  };

  /// The tint behind it.
  Color subtle(FoxColorScheme c) => switch (this) {
    success => c.successSubtle,
    warning => c.warningSubtle,
    danger => c.dangerSubtle,
    info => c.infoSubtle,
    primary => c.primarySubtle,
    neutral => c.neutralSubtle,
  };
}
