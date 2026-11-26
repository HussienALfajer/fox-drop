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
    final input = theme.components.input;
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
        final int track;
        if (!enabled) {
          track = input.colorDisabled;
        } else if (value) {
          track = state.pressed
              ? input.switchColorTrackOnPressed
              : (state.hovered
                    ? input.switchColorTrackOnHover
                    : input.switchColorTrackOn);
        } else {
          track = state.pressed
              ? input.switchColorTrackPressed
              : (state.hovered
                    ? input.switchColorTrackHover
                    : input.switchColorTrack);
        }
        final radius = input.switchHeight / 2;
        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: input.checkTarget,
            minWidth: input.switchWidth,
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
                width: input.switchWidth,
                height: input.switchHeight,
                padding: EdgeInsets.all(input.switchPadding),
                decoration: BoxDecoration(
                  color: Color(track),
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
                      color: Color(
                        enabled
                            ? input.switchColorThumb
                            : input.colorOnDisabled,
                      ),
                    ),
                    child: SizedBox.square(
                      dimension: input.switchHeight - 2 * input.switchPadding,
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
