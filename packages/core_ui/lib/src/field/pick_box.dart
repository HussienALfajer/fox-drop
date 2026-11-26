import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';

import '../icon/fox_icon.dart';
import '../internal/interaction.dart';
import '../theme/fox_theme.dart';
import 'fox_field.dart';

/// The closed face of a field that opens something instead of taking typed
/// text (the select, the date and time fields): the pill with its text, an
/// optional start icon and an optional end icon, one button for a screen
/// reader whose name is the field's label, whose value is [shown] and whose
/// description is the hint or the error. Not exported.
class PickBox extends StatelessWidget {
  const PickBox({
    super.key,
    required this.onTap,
    this.shown,
    this.placeholder,
    this.label,
    this.description,
    this.start,
    this.end,
    this.enabled = true,
    this.invalid = false,
    this.expanded,
    this.focusNode,
    this.ltrValue = false,
  });

  final VoidCallback? onTap;
  final String? shown;
  final String? placeholder;
  final String? label;
  final String? description;
  final t.FoxIconData? start;
  final t.FoxIconData? end;
  final bool enabled;
  final bool invalid;
  final bool? expanded;
  final FocusNode? focusNode;

  /// A date: digits and slashes keep their order in Arabic. A time is not,
  /// it reads right to left.
  final bool ltrValue;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final input = theme.components.input;
    return Interaction(
      enabled: enabled,
      onTap: enabled ? onTap : null,
      focusNode: focusNode,
      isButton: true,
      label: label ?? placeholder,
      value: shown,
      hint: description,
      expanded: expanded,
      builder: (context, state) {
        final colour = !enabled
            ? Color(input.colorOnDisabled)
            : Color(input.colorText);
        final text = Text(
          shown ?? placeholder ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.text.body.copyWith(
            color: !enabled
                ? Color(input.colorOnDisabled)
                : (shown == null
                      ? Color(input.colorPlaceholder)
                      : Color(input.colorText)),
          ),
        );
        return FieldBox(
          focused: state.focused || expanded == true,
          invalid: invalid,
          enabled: enabled,
          child: Row(
            children: [
              if (start != null) ...[
                FoxIcon(start!, color: colour),
                SizedBox(width: input.gap),
              ],
              Expanded(
                child: ltrValue
                    ? Directionality(
                        textDirection: TextDirection.ltr,
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: text,
                        ),
                      )
                    : text,
              ),
              if (end != null) ...[
                SizedBox(width: input.gap),
                // Turned up while its menu is open, as on the web (parity,
                // D.W3a); at once under reduced motion.
                AnimatedRotation(
                  turns: expanded == true ? 0.5 : 0,
                  duration:
                      (MediaQuery.maybeDisableAnimationsOf(context) ?? false)
                      ? Duration.zero
                      : t.FoxDuration.base,
                  curve: theme.easing,
                  child: FoxIcon(end!, color: colour),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
