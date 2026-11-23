import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';

import '../internal/interaction.dart';
import '../theme/fox_theme.dart';

/// The states every switch use case and golden shows (R3), crossed with
/// `off` and `on`. Hover, focus and pressed are live.
const switchStates = ['default', 'hover', 'focus', 'pressed', 'disabled'];

/// The values a switch use case shows.
const switchValues = ['off', 'on'];

/// A switch (D.8): the classic 52 by 32 track in a 48 high target. Off, the
/// thumb rests at the start; on, it slides to the end and the track turns
/// orange. [label] is its accessible name (the row's visible text belongs to
/// the screen). A null [onChanged] disables it.
class FoxSwitch extends StatelessWidget {
  const FoxSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final i = theme.input;
    final enabled = onChanged != null;
    final slide = (MediaQuery.maybeDisableAnimationsOf(context) ?? false)
        ? Duration.zero
        : t.FoxDuration.base;
    return Interaction(
      enabled: enabled,
      onTap: enabled ? () => onChanged!(!value) : null,
      enterActivates: false,
      label: label,
      toggled: value,
      builder: (context, state) {
        final Color track;
        if (!enabled) {
          track = i.disabled;
        } else if (value) {
          track = state.pressed
              ? i.switchTrackOnPressed
              : (state.hovered ? i.switchTrackOnHover : i.switchTrackOn);
        } else {
          track = state.hovered || state.pressed
              ? i.switchTrackHover
              : i.switchTrack;
        }
        final radius = i.switchHeight / 2;
        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: t.FoxSize.touchTarget,
            minWidth: i.switchWidth,
          ),
          child: Center(
            widthFactor: 1,
            heightFactor: 1,
            child: CustomPaint(
              foregroundPainter: FocusRing.of(
                theme,
                on: state.focused,
                radius: radius,
              ),
              child: AnimatedContainer(
                duration: t.FoxDuration.base,
                curve: theme.easing,
                width: i.switchWidth,
                height: i.switchHeight,
                padding: const EdgeInsets.all(t.FoxSpace.xxs),
                decoration: BoxDecoration(
                  color: track,
                  borderRadius: BorderRadius.circular(radius),
                ),
                child: AnimatedAlign(
                  duration: slide,
                  curve: theme.easing,
                  alignment: value
                      ? AlignmentDirectional.centerEnd
                      : AlignmentDirectional.centerStart,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: enabled ? i.switchThumb : i.onDisabled,
                    ),
                    child: SizedBox.square(
                      dimension: i.switchHeight - 2 * t.FoxSpace.xxs,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
