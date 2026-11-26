import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';

import '../icon/fox_icon.dart';
import '../internal/interaction.dart';
import '../internal/large_text.dart';
import '../theme/fox_theme.dart';

/// The states every ListRow use case and golden shows (R3), as the web's.
const listRowStates = [
  'default',
  'value',
  'hover',
  'focus',
  'pressed',
  'danger',
  'disabled',
];

/// A destructive row is written in danger, without the chevron.
enum FoxListRowTone { normal, danger }

/// One row of a list: a lead icon in a tinted circle, a title, a second line
/// and an end slot (a value, a chip, a switch). With [onPressed] it is one
/// button with a chevron along the reading direction.
class FoxListRow extends StatelessWidget {
  const FoxListRow({
    super.key,
    required this.title,
    this.description,
    this.leading,
    this.end,
    this.onPressed,
    this.tone = FoxListRowTone.normal,
    this.enabled = true,
    this.endLabel,
  });

  final String title;
  final String? description;
  final t.FoxIconData? leading;

  /// A value or a chip. A pressable row is one button, so its end slot is
  /// read through [endLabel] and must hold no control of its own.
  final Widget? end;

  /// The end slot in words for screen readers («1,250 ₺», «تم التسليم»),
  /// the button's value when the row is pressable.
  final String? endLabel;
  final VoidCallback? onPressed;
  final FoxListRowTone tone;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (onPressed == null) return _row(context, null);
    return Interaction(
      onTap: enabled ? onPressed : null,
      enabled: enabled,
      isButton: true,
      label: title,
      value: endLabel,
      hint: description,
      builder: _row,
    );
  }

  Widget _row(BuildContext context, InteractionState? state) {
    final theme = FoxTheme.of(context);
    final listRow = theme.components.listRow;
    final danger = tone == FoxListRowTone.danger;
    final ink = Color(
      !enabled
          ? listRow.colorDisabled
          : danger
          ? listRow.dangerLabel
          : listRow.colorLabel,
    );
    final fill = Color(
      state?.pressed ?? false
          ? listRow.colorBackgroundPressed
          : state?.hovered ?? false
          ? listRow.colorBackgroundHover
          : listRow.colorBackground,
    );
    final leading = this.leading;
    final description = this.description;
    final end = this.end;
    // At large text the end slot moves under the text, as the approved
    // drawing at 130% wraps it, so the title keeps its width.
    final stacked = foxLargeText(context);
    return CustomPaint(
      foregroundPainter: FocusRing.of(
        theme,
        on: state?.focused ?? false,
        radius: t.FoxRadius.sm,
      ),
      child: AnimatedContainer(
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : t.FoxDuration.base,
        curve: theme.easing,
        constraints: BoxConstraints(minHeight: listRow.minHeight),
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: listRow.paddingInline,
          vertical: listRow.paddingBlock,
        ),
        color: fill,
        child: Row(
          children: [
            if (leading != null) ...[
              Container(
                width: listRow.leadSize,
                height: listRow.leadSize,
                decoration: BoxDecoration(
                  color: Color(danger ? listRow.dangerLead : listRow.colorLead),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: FoxIcon(leading, color: ink),
              ),
              SizedBox(width: listRow.gap),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: theme.text.body.copyWith(
                      color: ink,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (description != null)
                    Text(
                      description,
                      style: theme.text.secondary.copyWith(
                        color: enabled ? Color(listRow.colorDescription) : ink,
                      ),
                    ),
                  if (end != null && stacked) end,
                ],
              ),
            ),
            if (end != null && !stacked) ...[SizedBox(width: listRow.gap), end],
            if (onPressed != null && !danger) ...[
              // One gap before the chevron, as every other part (D.W3b).
              SizedBox(width: listRow.gap),
              // `back` mirrors under RTL; flipped once more it points along
              // the reading direction (to the left in Arabic).
              Transform.flip(
                flipX: true,
                child: FoxIcon(
                  t.FoxIcons.back,
                  size: FoxIconSize.sm,
                  color: Color(listRow.colorChevron),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
