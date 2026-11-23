import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../internal/choice_row.dart';
import '../internal/interaction.dart';
import '../theme/fox_theme.dart';

/// The states every radio use case and golden shows (R3), crossed with
/// `unselected` and `selected`. Hover, focus and pressed are live.
const radioStates = [
  'default',
  'hover',
  'focus',
  'pressed',
  'disabled',
  'invalid',
];

/// The values a radio use case shows.
const radioValues = ['unselected', 'selected'];

/// The states of a radio group's use cases: `default` and `disabled` (every
/// radio of it without a callback).
const radioGroupStates = ['default', 'disabled'];

/// What a [FoxRadioGroup] needs of each radio inside it. Not exported.
abstract interface class RadioEntry {
  BuildContext get context;
  FocusNode get node;
  bool get enabled;

  /// Reports this radio's value as chosen.
  void select();
}

class _GroupScope extends InheritedWidget {
  const _GroupScope({required this.entries, required super.child});

  final List<RadioEntry> entries;

  @override
  bool updateShouldNotify(_GroupScope old) => false;
}

/// The keyboard of a group of [FoxRadio]s (D.8), as the web's RadioGroup:
/// Down and the arrow pointing to the end of reading (Right in LTR, Left in
/// RTL) move to the next enabled radio, Up and the arrow pointing to the
/// start move to the previous one, both wrapping round, and the selection
/// follows the focus. Without the group a radio still works by tap and Space.
class FoxRadioGroup extends StatefulWidget {
  const FoxRadioGroup({super.key, required this.child});

  final Widget child;

  @override
  State<FoxRadioGroup> createState() => _FoxRadioGroupState();
}

class _FoxRadioGroupState extends State<FoxRadioGroup> {
  final List<RadioEntry> _entries = [];

  @override
  Widget build(BuildContext context) =>
      _GroupScope(entries: _entries, child: widget.child);
}

/// One radio of a group (D.8): a 24 circle in a 48 row that is the whole
/// target; selected, it holds an orange dot. The group is the radios that
/// share a [groupValue]; a null [onChanged] disables this one. A tap on the
/// selected radio changes nothing. Put the radios in a [FoxRadioGroup] for
/// arrow-key movement.
class FoxRadio<T> extends StatefulWidget {
  const FoxRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.label,
    this.invalid = false,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final String label;
  final bool invalid;

  /// The dot's diameter inside the 24 circle.
  static const double _dot = t.FoxSpace.sm;

  @override
  State<FoxRadio<T>> createState() => _FoxRadioState<T>();
}

class _FoxRadioState<T> extends State<FoxRadio<T>> implements RadioEntry {
  final FocusNode _node = FocusNode(debugLabel: 'FoxRadio');
  List<RadioEntry>? _group;

  @override
  FocusNode get node => _node;

  @override
  bool get enabled => widget.onChanged != null;

  @override
  void select() {
    if (enabled && widget.value != widget.groupValue) {
      widget.onChanged!(widget.value);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final group = context.getInheritedWidgetOfExactType<_GroupScope>()?.entries;
    if (group != _group) {
      _group?.remove(this);
      _group = group?..add(this);
    }
  }

  @override
  void dispose() {
    _group?.remove(this);
    _node.dispose();
    super.dispose();
  }

  Offset _position(RadioEntry entry) {
    final box = entry.context.findRenderObject() as RenderBox?;
    return box == null || !box.attached
        ? Offset.zero
        : box.localToGlobal(Offset.zero);
  }

  KeyEventResult _key(FocusNode _, KeyEvent event) {
    final group = _group;
    if (group == null || event is KeyUpEvent) return KeyEventResult.ignored;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final key = event.logicalKey;
    final int step;
    if (key == LogicalKeyboardKey.arrowDown) {
      step = 1;
    } else if (key == LogicalKeyboardKey.arrowUp) {
      step = -1;
    } else if (key == LogicalKeyboardKey.arrowRight) {
      step = rtl ? -1 : 1;
    } else if (key == LogicalKeyboardKey.arrowLeft) {
      step = rtl ? 1 : -1;
    } else {
      return KeyEventResult.ignored;
    }
    // Reading order: top to bottom, then along the line.
    final ordered = [...group]
      ..sort((a, b) {
        final pa = _position(a);
        final pb = _position(b);
        final byRow = pa.dy.compareTo(pb.dy);
        if (byRow != 0) return byRow;
        return rtl ? pb.dx.compareTo(pa.dx) : pa.dx.compareTo(pb.dx);
      });
    final from = ordered.indexOf(this);
    for (var n = 1; n < ordered.length; n++) {
      final next = ordered[(from + step * n) % ordered.length];
      if (!next.enabled) continue;
      next.node.requestFocus();
      next.select();
      break;
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final i = theme.input;
    final selected = widget.value == widget.groupValue;
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      includeSemantics: false,
      onKeyEvent: _key,
      child: Interaction(
        focusNode: _node,
        enabled: enabled,
        onTap: enabled ? select : null,
        enterActivates: false,
        label: widget.label,
        checked: selected,
        inGroup: true,
        builder: (context, state) {
          final Color accent;
          final Color fill;
          Color border;
          if (!enabled) {
            accent = i.onDisabled;
            fill = i.disabled;
            border = i.onDisabled;
          } else {
            accent = state.pressed
                ? i.checkCheckedPressed
                : (state.hovered ? i.checkCheckedHover : i.checkChecked);
            fill = state.pressed
                ? i.checkBackgroundPressed
                : (state.hovered ? i.checkBackgroundHover : i.checkBackground);
            if (selected) {
              border = accent;
            } else if (widget.invalid) {
              border = i.borderInvalid;
            } else {
              border = state.hovered || state.pressed
                  ? i.checkBorderHover
                  : i.checkBorder;
            }
          }
          final box = CustomPaint(
            foregroundPainter: FocusRing.of(
              theme,
              on: state.focused,
              radius: i.checkSize,
              circle: true,
            ),
            child: AnimatedContainer(
              duration: t.FoxDuration.base,
              curve: theme.easing,
              width: i.checkSize,
              height: i.checkSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: fill,
                border: Border.all(color: border, width: i.checkBorderWidth),
              ),
              child: selected
                  ? Center(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accent,
                        ),
                        child: const SizedBox.square(dimension: FoxRadio._dot),
                      ),
                    )
                  : null,
            ),
          );
          return ChoiceRow(
            box: box,
            label: widget.label,
            color: enabled ? theme.colors.onSurface : i.onDisabled,
          );
        },
      ),
    );
  }
}
