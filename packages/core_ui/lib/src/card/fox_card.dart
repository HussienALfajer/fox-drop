import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';

import '../internal/interaction.dart';
import '../theme/fox_theme.dart';

/// The states every Card use case and golden shows (R3), as the web's.
const cardStates = ['default', 'offset', 'hover', 'focus', 'pressed', 'danger'];

/// The approved sheet (owner, 2026-11-24): the customer app's cards carry the
/// Figma file's offset shadow, every other surface a thin outline.
enum FoxCardElevation { outline, offset }

/// `danger` is a late order (RA §8.2): a red tint and outline.
enum FoxCardTone { normal, danger }

/// The container of every card: raised white on the ground, radius 15. With
/// [onPressed] the whole card is one button and takes the raised surface's
/// hover and pressed colours (R10).
class FoxCard extends StatelessWidget {
  const FoxCard({
    super.key,
    required this.child,
    this.elevation = FoxCardElevation.outline,
    this.tone = FoxCardTone.normal,
    this.onPressed,
    this.semanticLabel,
    this.keepsInnerSemantics = false,
  });

  final Widget child;
  final FoxCardElevation elevation;
  final FoxCardTone tone;
  final VoidCallback? onPressed;

  /// The button's name when the card is pressable.
  final String? semanticLabel;

  /// A pressable card is read as its [semanticLabel] alone, unless it holds
  /// its own controls (the restaurant card's heart), which stay reachable.
  final bool keepsInnerSemantics;

  @override
  Widget build(BuildContext context) {
    final onPressed = this.onPressed;
    if (onPressed == null) return _box(context, null);
    return Interaction(
      onTap: onPressed,
      isButton: true,
      label: semanticLabel,
      excludeBody: !keepsInnerSemantics,
      builder: _box,
    );
  }

  Widget _box(BuildContext context, InteractionState? state) {
    final theme = FoxTheme.of(context);
    final card = theme.components.card;
    final late = tone == FoxCardTone.danger;
    final fill = Color(
      late
          ? card.dangerBackground
          : state?.pressed ?? false
          ? card.colorBackgroundPressed
          : state?.hovered ?? false
          ? card.colorBackgroundHover
          : card.colorBackground,
    );
    final border = late
        ? Border.all(
            color: Color(card.dangerBorder),
            width: card.dangerBorderWidth,
          )
        : elevation == FoxCardElevation.outline
        ? Border.all(color: Color(card.colorBorder), width: card.borderWidth)
        : null;
    final ring = FocusRing.of(
      theme,
      on: state?.focused ?? false,
      radius: card.radius,
    );
    return CustomPaint(
      foregroundPainter: ring,
      child: AnimatedContainer(
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : t.FoxDuration.base,
        curve: theme.easing,
        padding: EdgeInsetsDirectional.all(card.padding),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(card.radius),
          border: border,
          boxShadow: elevation == FoxCardElevation.offset && !late
              ? [theme.shadows.offset]
              : null,
        ),
        child: child,
      ),
    );
  }
}
