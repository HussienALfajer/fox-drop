import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../field/fox_field.dart';
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

/// The states of a radio group's use cases: `default`, `invalid` (an error
/// under the group, nothing chosen) and `disabled` (every radio of it without
/// a callback).
const radioGroupStates = ['default', 'invalid', 'disabled'];

/// What a [FoxRadioGroup] needs of each radio inside it. Not exported.
abstract interface class RadioEntry {
  BuildContext get context;
  FocusNode get node;
  bool get enabled;
  bool get selected;

  /// Reports this radio's value as chosen.
  void select();
}

class _GroupScope extends InheritedWidget {
  const _GroupScope({required this.group, required super.child});

  final _FoxRadioGroupState group;

  @override
  bool updateShouldNotify(_GroupScope old) => false;
}

/// A group of [FoxRadio]s (D.8), as the web's RadioGroup. Its [label] names
/// the group for a screen reader, with the [error] (else the [hint]) as its
/// description; both are drawn as a field's are.
///
/// The keyboard: Tab reaches the selected radio only (the first enabled one
/// when none is selected); inside, Down and the arrow pointing to the end of
/// reading (Right in LTR, Left in RTL) move to the next enabled radio, Up and
/// the arrow pointing to the start move to the previous one, both wrapping
/// round, and the selection follows the focus. Without the group a radio
/// still works by tap and Space.
class FoxRadioGroup extends StatefulWidget {
  const FoxRadioGroup({
    super.key,
    required this.child,
    this.label,
    this.hint,
    this.error,
  });

  final Widget child;
  final String? label;
  final String? hint;
  final String? error;

  @override
  State<FoxRadioGroup> createState() => _FoxRadioGroupState();
}

class _FoxRadioGroupState extends State<FoxRadioGroup> {
  final List<RadioEntry> entries = [];
  bool _scheduled = false;

  /// Once the frame is built (every radio has its new value), only the radio
  /// that is the group's one tab stop stays in the Tab order.
  void refresh() {
    if (_scheduled) return;
    _scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      if (!mounted) return;
      final enabled = entries.where((e) => e.enabled).toList();
      final stop =
          enabled.where((e) => e.selected).firstOrNull ?? enabled.firstOrNull;
      for (final entry in entries) {
        entry.node.skipTraversal = entry != stop;
      }
    });
  }

  @override
  Widget build(BuildContext context) => _GroupScope(
    group: this,
    child: Semantics(
      container: true,
      role: SemanticsRole.radioGroup,
      label: widget.label,
      hint: widget.error ?? widget.hint,
      child: FoxField(
        label: widget.label,
        hint: widget.hint,
        error: widget.error,
        namesControl: false,
        child: widget.child,
      ),
    ),
  );
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

  @override
  State<FoxRadio<T>> createState() => _FoxRadioState<T>();
}

class _FoxRadioState<T> extends State<FoxRadio<T>> implements RadioEntry {
  final FocusNode _node = FocusNode(debugLabel: 'FoxRadio');
  _FoxRadioGroupState? _group;

  @override
  FocusNode get node => _node;

  @override
  bool get enabled => widget.onChanged != null;

  @override
  bool get selected => widget.value == widget.groupValue;

  @override
  void select() {
    if (enabled && widget.value != widget.groupValue) {
      widget.onChanged!(widget.value);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final group = context.getInheritedWidgetOfExactType<_GroupScope>()?.group;
    if (group != _group) {
      _group?.entries.remove(this);
      _group?.refresh();
      _group = group?..entries.add(this);
    }
    _group?.refresh();
  }

  @override
  void didUpdateWidget(FoxRadio<T> old) {
    super.didUpdateWidget(old);
    _group?.refresh();
  }

  @override
  void dispose() {
    _group?.entries.remove(this);
    _group?.refresh();
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
    final group = _group?.entries;
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
    final input = theme.components.input;
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
            accent = Color(input.colorOnDisabled);
            fill = Color(input.colorDisabled);
            border = Color(input.colorOnDisabled);
          } else {
            accent = state.pressed
                ? Color(input.checkColorCheckedPressed)
                : (state.hovered
                      ? Color(input.checkColorCheckedHover)
                      : Color(input.checkColorChecked));
            fill = state.pressed
                ? Color(input.checkColorBackgroundPressed)
                : (state.hovered
                      ? Color(input.checkColorBackgroundHover)
                      : Color(input.checkColorBackground));
            if (selected) {
              border = accent;
            } else if (widget.invalid) {
              border = Color(input.colorBorderInvalid);
            } else {
              border = state.hovered || state.pressed
                  ? Color(input.checkColorBorderHover)
                  : Color(input.checkColorBorder);
            }
          }
          final box = CustomPaint(
            foregroundPainter: FocusRing.of(
              theme,
              on: state.focused,
              radius: input.checkSize,
              circle: true,
            ),
            child: AnimatedContainer(
              duration: t.FoxDuration.base,
              curve: theme.easing,
              width: input.checkSize,
              height: input.checkSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: fill,
                border: Border.all(
                  color: border,
                  width: input.checkBorderWidth,
                ),
              ),
              child: selected
                  ? Center(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accent,
                        ),
                        child: SizedBox.square(dimension: input.checkDot),
                      ),
                    )
                  : null,
            ),
          );
          return ChoiceRow(
            box: box,
            label: widget.label,
            color: enabled
                ? Color(input.colorText)
                : Color(input.colorOnDisabled),
          );
        },
      ),
    );
  }
}
