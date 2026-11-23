import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../theme/fox_theme.dart';

/// What a control's builder is told: a mouse over it, a finger or key down,
/// and keyboard focus (the focus ring shows for the keyboard only, R10).
@immutable
final class InteractionState {
  const InteractionState({
    required this.hovered,
    required this.pressed,
    required this.focused,
  });

  final bool hovered;
  final bool pressed;

  /// Keyboard focus highlight.
  final bool focused;
}

/// Hover, press, keyboard focus and semantics shared by the checkbox, radio,
/// switch, stepper's buttons, select and the fields that act like a button.
/// Not exported: the components use it, apps never do.
class Interaction extends StatefulWidget {
  const Interaction({
    super.key,
    required this.builder,
    required this.onTap,
    this.enabled = true,
    this.focusNode,
    this.label,
    this.value,
    this.hint,
    this.isButton = false,
    this.checked,
    this.mixed,
    this.toggled,
    this.inGroup = false,
    this.enterActivates = true,
    this.excludeBody = true,
    this.expanded,
  });

  final Widget Function(BuildContext context, InteractionState state) builder;

  /// Null makes it inert (a disabled control is not focusable).
  final VoidCallback? onTap;
  final bool enabled;
  final FocusNode? focusNode;
  final String? label;
  final String? value;
  final String? hint;
  final bool isButton;
  final bool? checked;
  final bool? mixed;
  final bool? toggled;
  final bool inGroup;
  final bool enterActivates;
  final bool excludeBody;
  final bool? expanded;

  @override
  State<Interaction> createState() => _InteractionState();
}

class _InteractionState extends State<Interaction> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;
  FocusNode? _own;

  FocusNode get _node =>
      widget.focusNode ?? (_own ??= FocusNode(debugLabel: 'Interaction'));

  bool get _active => widget.enabled && widget.onTap != null;

  Map<ShortcutActivator, Intent> get _shortcuts => {
    const SingleActivator(LogicalKeyboardKey.space): const ActivateIntent(),
    if (widget.enterActivates) ...{
      const SingleActivator(LogicalKeyboardKey.enter): const ActivateIntent(),
      const SingleActivator(LogicalKeyboardKey.numpadEnter):
          const ActivateIntent(),
    },
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
    if (_active) widget.onTap!();
  }

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  void didUpdateWidget(Interaction oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_active) _pressed = false;
  }

  @override
  void dispose() {
    _own?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = InteractionState(
      hovered: _hovered && _active,
      pressed: _pressed && _active,
      focused: _focused && widget.enabled,
    );
    final body = widget.builder(context, state);
    return Semantics(
      container: true,
      button: widget.isButton ? true : null,
      enabled: widget.enabled,
      focusable: widget.enabled ? true : null,
      focused: widget.enabled ? _node.hasFocus : null,
      label: widget.label,
      value: widget.value,
      hint: widget.hint,
      checked: widget.checked,
      mixed: widget.mixed,
      toggled: widget.toggled,
      inMutuallyExclusiveGroup: widget.inGroup ? true : null,
      expanded: widget.expanded,
      onTap: _active ? _activate : null,
      onFocus: widget.enabled ? _node.requestFocus : null,
      child: FocusableActionDetector(
        focusNode: _node,
        enabled: widget.enabled,
        includeFocusSemantics: false,
        shortcuts: _shortcuts,
        actions: _actions,
        mouseCursor: _active
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onFocusChange: (_) => setState(() {}),
        onShowFocusHighlight: (value) => setState(() => _focused = value),
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            excludeFromSemantics: true,
            onTapDown: _active ? (_) => _setPressed(true) : null,
            onTapUp: _active ? (_) => _setPressed(false) : null,
            onTapCancel: _active ? () => _setPressed(false) : null,
            onTap: _active ? _activate : null,
            child: widget.excludeBody ? ExcludeSemantics(child: body) : body,
          ),
        ),
      ),
    );
  }
}

/// The keyboard focus ring (R10): a [gap] in `surface`, then 2 in the ring
/// colour, following a rounded rectangle (or a circle) and leaving the inside
/// unpainted.
class FocusRing extends CustomPainter {
  FocusRing({
    required this.ring,
    required this.gap,
    required this.radius,
    this.circle = false,
  });

  final Color ring;
  final Color gap;
  final double radius;
  final bool circle;

  static const double width = 2;
  static const double spacing = 2;

  /// A painter for [theme]'s focus ring, or null when [on] is false.
  static FocusRing? of(
    FoxThemeData theme, {
    required bool on,
    required double radius,
    bool circle = false,
  }) => on
      ? FocusRing(
          ring: theme.input.focusRing,
          gap: theme.colors.surface,
          radius: radius,
          circle: circle,
        )
      : null;

  @override
  void paint(Canvas canvas, Size size) {
    final shape = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(circle ? size.shortestSide / 2 : radius),
    );
    Paint stroke(Color color, double strokeWidth) => Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas
      ..drawRRect(shape.inflate(spacing / 2), stroke(gap, spacing))
      ..drawRRect(shape.inflate(spacing + width / 2), stroke(ring, width));
  }

  @override
  bool shouldRepaint(FocusRing old) =>
      old.ring != ring ||
      old.gap != gap ||
      old.circle != circle ||
      old.radius != radius;
}
