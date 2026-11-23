import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';

import '../icon/fox_icon.dart';
import '../internal/choice_row.dart';
import '../internal/interaction.dart';
import '../theme/fox_theme.dart';

/// The states every checkbox use case and golden shows (R3), crossed with
/// the three values: `unchecked`, `checked` and `mixed`. Hover, focus and
/// pressed are live.
const checkboxStates = [
  'default',
  'hover',
  'focus',
  'pressed',
  'disabled',
  'invalid',
];

/// The values a checkbox use case shows.
const checkboxValues = ['unchecked', 'checked', 'mixed'];

/// A checkbox with its label (D.8): 24, radius 8, in a 48 row that is the
/// whole target. [value] is true, false, or null for mixed (a parent of a
/// partly chosen list); a tap on mixed checks it. A null [onChanged]
/// disables it. Orange when checked; the keyboard ring is blue (R10).
class FoxCheckbox extends StatelessWidget {
  const FoxCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.invalid = false,
  });

  final bool? value;
  final ValueChanged<bool>? onChanged;
  final String label;

  /// Draws the `danger` border (the form says why, in its field wrapper).
  final bool invalid;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final i = theme.input;
    final enabled = onChanged != null;
    return Interaction(
      enabled: enabled,
      onTap: enabled ? () => onChanged!(value != true) : null,
      enterActivates: false,
      label: label,
      checked: value == true,
      mixed: value == null ? true : null,
      builder: (context, state) {
        final on = value != false;
        final Color fill;
        final Color border;
        if (!enabled) {
          fill = i.disabled;
          border = on ? i.disabled : i.onDisabled;
        } else if (on) {
          fill = state.pressed
              ? i.checkCheckedPressed
              : (state.hovered ? i.checkCheckedHover : i.checkChecked);
          border = fill;
        } else {
          fill = state.pressed
              ? i.checkBackgroundPressed
              : (state.hovered ? i.checkBackgroundHover : i.checkBackground);
          border = invalid
              ? i.borderInvalid
              : (state.hovered || state.pressed
                    ? i.checkBorderHover
                    : i.checkBorder);
        }
        final mark = !enabled ? i.onDisabled : i.checkMark;
        final box = CustomPaint(
          foregroundPainter: FocusRing.of(
            theme,
            on: state.focused,
            radius: i.checkRadius,
          ),
          child: AnimatedContainer(
            duration: t.FoxDuration.base,
            curve: theme.easing,
            width: i.checkSize,
            height: i.checkSize,
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(i.checkRadius),
              border: Border.all(color: border, width: i.checkBorderWidth),
            ),
            child: on
                ? Center(
                    child: FoxIcon(
                      value == null ? t.FoxIcons.remove : t.FoxIcons.confirm,
                      size: FoxIconSize.sm,
                      color: mark,
                    ),
                  )
                : null,
          ),
        );
        return ChoiceRow(
          box: box,
          label: label,
          color: enabled ? theme.colors.onSurface : i.onDisabled,
        );
      },
    );
  }
}
