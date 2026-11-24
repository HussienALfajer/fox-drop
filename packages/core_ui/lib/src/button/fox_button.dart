import 'dart:math' as math;

import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../icon/fox_icon.dart';
import '../theme/fox_theme.dart';

/// The four looks of the approved Button sheet (D.6).
enum FoxButtonVariant { primary, secondary, danger, ghost }

/// The states every Button use case and golden shows (R3), named as the
/// web's `STATES` without its densities.
const buttonStates = [
  'default',
  'hover',
  'focus',
  'pressed',
  'disabled',
  'loading',
];

/// The variant names, for the R3 coverage test.
final buttonVariants = [for (final v in FoxButtonVariant.values) v.name];

/// The focus ring and the gap in `surface` between it and the button, as on
/// the web (`ring-2 ring-offset-2`).
const double _ringWidth = 2;
const double _ringGap = 2;

/// A button of the approved sheet (D.6, R10): primary, secondary, danger or
/// ghost, 50 high with an optional start or end icon, or an icon alone in a
/// circle ([FoxButton.icon]).
///
/// Hover (with a mouse) and pressed paint the variant's own hover and
/// pressed tokens, fading over `duration.base`; nothing moves. The focus
/// ring shows for keyboard focus only. A null [onPressed] disables the
/// button: it is skipped by focus and ignores presses. [loading] keeps the
/// width and the name, draws a spinner over the hidden label and ignores
/// presses while staying focusable.
class FoxButton extends StatefulWidget {
  const FoxButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = FoxButtonVariant.primary,
    this.icon,
    this.iconEnd,
    this.loading = false,
    this.autofocus = false,
  }) : iconOnly = false;

  /// An icon alone in a circle; [label] is its accessible name.
  const FoxButton.icon({
    super.key,
    required t.FoxIconData this.icon,
    required this.label,
    required this.onPressed,
    this.variant = FoxButtonVariant.primary,
    this.loading = false,
    this.autofocus = false,
  }) : iconOnly = true,
       iconEnd = null;

  final String label;
  final VoidCallback? onPressed;
  final FoxButtonVariant variant;
  final t.FoxIconData? icon;
  final t.FoxIconData? iconEnd;
  final bool loading;
  final bool iconOnly;

  /// Takes focus when it first builds: a dialog's safe action (D.10).
  final bool autofocus;

  @override
  State<FoxButton> createState() => _FoxButtonState();
}

class _FoxButtonState extends State<FoxButton> {
  bool _hovered = false;
  bool _focused = false;
  bool _pressed = false;

  bool get _disabled => widget.onPressed == null;
  bool get _interactive => !_disabled && !widget.loading;

  static const _shortcuts = <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
    SingleActivator(LogicalKeyboardKey.numpadEnter): ActivateIntent(),
    SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
  };

  late final Map<Type, Action<Intent>> _actions = {
    ActivateIntent: CallbackAction<ActivateIntent>(
      onInvoke: (_) {
        _activate();
        return null;
      },
    ),
  };

  void _activate() {
    if (_interactive) widget.onPressed!();
  }

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  final FocusNode _node = FocusNode(debugLabel: 'FoxButton');

  @override
  void didUpdateWidget(FoxButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_interactive) _pressed = false;
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final colors = _colors(theme.button);
    final ring = _focused && !_disabled;
    final shape = widget.iconOnly ? BoxShape.circle : BoxShape.rectangle;
    final radius = widget.iconOnly
        ? null
        : BorderRadius.circular(theme.button.radius);

    final content = _content(theme, colors.label);
    final body = widget.loading
        ? Stack(
            alignment: Alignment.center,
            children: [
              Opacity(opacity: 0, child: content),
              _Spinner(color: colors.label),
            ],
          )
        : content;

    // Only the colours fade (R10); the layout is never animated.
    final layout = ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: theme.button.height,
        minWidth: widget.iconOnly ? theme.button.height : t.FoxSize.touchTarget,
      ),
      child: Padding(
        padding: widget.iconOnly
            ? EdgeInsets.zero
            : EdgeInsetsDirectional.symmetric(
                horizontal: theme.button.paddingInline,
              ),
        // Centred, and as small as the content above the minimum size.
        child: Align(
          widthFactor: 1,
          heightFactor: 1,
          child: ExcludeSemantics(child: body),
        ),
      ),
    );

    final button = AnimatedContainer(
      duration: t.FoxDuration.base,
      curve: theme.easing,
      decoration: BoxDecoration(
        color: colors.background,
        shape: shape,
        borderRadius: radius,
      ),
      // The outline is drawn over the fill, so it takes no room (as the
      // web's inset border).
      foregroundDecoration: BoxDecoration(
        shape: shape,
        borderRadius: radius,
        border: Border.all(color: colors.border),
      ),
      child: layout,
    );

    // The ring is painted outside the button and never moves its layout.
    // Strokes, not shadows: a shadow also paints under a transparent fill
    // (ghost), which the web's clipped box-shadow never does.
    final framed = CustomPaint(
      foregroundPainter: ring
          ? _RingPainter(
              ring: theme.button.focusRing,
              gap: theme.colors.surface,
              circle: widget.iconOnly,
              radius: theme.button.radius,
            )
          : null,
      child: button,
    );

    // A loading button keeps focus but is not enabled, as the web's
    // `aria-disabled` while it is busy.
    return Semantics(
      container: true,
      button: true,
      enabled: _interactive,
      // Null, not false: a focus state, even false, marks the node as one
      // that can take focus.
      focusable: _disabled ? null : true,
      focused: _disabled ? null : _node.hasFocus,
      label: widget.label,
      onTap: _interactive ? _activate : null,
      onFocus: _disabled ? null : _node.requestFocus,
      child: FocusableActionDetector(
        focusNode: _node,
        enabled: !_disabled,
        autofocus: widget.autofocus,
        includeFocusSemantics: false,
        shortcuts: _shortcuts,
        actions: _actions,
        mouseCursor: _interactive
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onFocusChange: (_) => setState(() {}),
        onShowFocusHighlight: (value) => setState(() => _focused = value),
        // Hover is the pointer's, whatever the focus highlight mode.
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: _interactive ? (_) => _setPressed(true) : null,
            onTapUp: _interactive ? (_) => _setPressed(false) : null,
            onTapCancel: _interactive ? () => _setPressed(false) : null,
            onTap: _interactive ? _activate : null,
            child: framed,
          ),
        ),
      ),
    );
  }

  Widget _content(FoxThemeData theme, Color label) {
    final icon = widget.icon;
    if (widget.iconOnly) return FoxIcon(icon!, color: label);
    final iconEnd = widget.iconEnd;
    final gap = theme.button.gap;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          FoxIcon(icon, color: label),
          SizedBox(width: gap),
        ],
        Flexible(
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: theme.text.subtitle.copyWith(color: label),
          ),
        ),
        if (iconEnd != null) ...[
          SizedBox(width: gap),
          FoxIcon(iconEnd, color: label),
        ],
      ],
    );
  }

  _Colors _colors(FoxButtonTheme b) {
    if (_disabled) {
      return _Colors(
        b.disabledBackground,
        b.disabledLabel,
        b.disabledBackground,
      );
    }
    // A loading button shows neither hover nor pressed (as on the web).
    final hover = _hovered && _interactive;
    final pressed = _pressed && _interactive;
    Color pick(Color rest, Color hovered, Color down) =>
        pressed ? down : (hover ? hovered : rest);
    switch (widget.variant) {
      case FoxButtonVariant.primary:
        final fill = pick(
          b.primaryBackground,
          b.primaryBackgroundHover,
          b.primaryBackgroundPressed,
        );
        return _Colors(fill, b.primaryLabel, fill);
      case FoxButtonVariant.secondary:
        return _Colors(
          pick(
            b.secondaryBackground,
            b.secondaryBackgroundHover,
            b.secondaryBackgroundPressed,
          ),
          b.secondaryLabel,
          pick(
            b.secondaryBorder,
            b.secondaryBorderHover,
            b.secondaryBorderHover,
          ),
        );
      case FoxButtonVariant.danger:
        final fill = pick(
          b.dangerBackground,
          b.dangerBackgroundHover,
          b.dangerBackgroundPressed,
        );
        return _Colors(fill, b.dangerLabel, fill);
      case FoxButtonVariant.ghost:
        // Transparent hover colour, so the fade does not pass through black.
        final none = b.ghostBackgroundHover.withValues(alpha: 0);
        final fill = pick(
          none,
          b.ghostBackgroundHover,
          b.ghostBackgroundPressed,
        );
        return _Colors(fill, b.ghostLabel, fill);
    }
  }
}

/// The keyboard focus ring: [_ringGap] in [gap] around the button, then
/// [_ringWidth] in [ring], following its corners (the web's `ring-2
/// ring-offset-2`). The inside is left unpainted.
class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.ring,
    required this.gap,
    required this.circle,
    required this.radius,
  });

  final Color ring;
  final Color gap;
  final bool circle;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final shape = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(circle ? size.shortestSide / 2 : radius),
    );
    Paint stroke(Color color, double width) => Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    canvas
      ..drawRRect(shape.inflate(_ringGap / 2), stroke(gap, _ringGap))
      ..drawRRect(
        shape.inflate(_ringGap + _ringWidth / 2),
        stroke(ring, _ringWidth),
      );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.ring != ring ||
      old.gap != gap ||
      old.circle != circle ||
      old.radius != radius;
}

final class _Colors {
  const _Colors(this.background, this.label, this.border);

  final Color background;
  final Color label;
  final Color border;
}

/// A three-quarter ring turning once a second; still when the platform asks
/// for no animations.
class _Spinner extends StatefulWidget {
  const _Spinner({required this.color});

  final Color color;

  @override
  State<_Spinner> createState() => _SpinnerState();
}

class _SpinnerState extends State<_Spinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _turn = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      _turn.stop();
    } else if (!_turn.isAnimating) {
      _turn.repeat();
    }
  }

  @override
  void dispose() {
    _turn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size.square(t.FoxSize.iconMd),
    painter: _SpinnerPainter(_turn, widget.color),
  );
}

class _SpinnerPainter extends CustomPainter {
  _SpinnerPainter(this.turn, this.color) : super(repaint: turn);

  final Animation<double> turn;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    // Stroked like an icon: 2 on the 24 grid, round caps.
    final stroke = size.width / 12;
    final rect = (Offset.zero & size).deflate(stroke);
    canvas.drawArc(
      rect,
      turn.value * 2 * math.pi - math.pi / 2,
      1.5 * math.pi,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_SpinnerPainter old) =>
      old.color != color || old.turn != turn;
}
