import 'dart:math' as math;

import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';

import '../icon/fox_icon.dart';
import '../internal/interaction.dart';
import '../theme/fox_theme.dart';

/// The states every quantity stepper use case and golden shows (R3). `min`
/// is at the minimum («−» is the delete icon), `max` at the maximum («+» is
/// dimmed). Hover and pressed are live.
const quantityStepperStates = ['default', 'min', 'max', 'pressed', 'disabled'];

/// The ring around a circle that the bridge keeps clear (the web sheet's
/// 19 around a 16 radius).
const double _bridgeClearance = 3;

/// The cart's quantity stepper (D.8): «+» and «−» in two 32 circles inside
/// 48 targets, bridged by a concave strip holding the count. «+» is at the
/// start. At [min] the «−» becomes a delete icon that calls [onDelete]
/// (without an [onDelete] it is dimmed); at [max] the «+» is dimmed.
///
/// A screen reader hears [label] and the count («الكمية 2») and can
/// increase and decrease it; each button carries its own name.
class FoxQuantityStepper extends StatelessWidget {
  const FoxQuantityStepper({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    required this.increaseLabel,
    required this.decreaseLabel,
    required this.deleteLabel,
    this.onDelete,
    this.min = 1,
    this.max,
    this.enabled = true,
  });

  final int value;
  final ValueChanged<int> onChanged;

  /// The group's accessible name, for example «الكمية».
  final String label;
  final String increaseLabel;
  final String decreaseLabel;
  final String deleteLabel;

  /// Called by the delete button shown at [min].
  final VoidCallback? onDelete;
  final int min;
  final int? max;
  final bool enabled;

  bool get _canIncrease => enabled && (max == null || value < max!);
  bool get _atMin => value <= min;
  bool get _canDecrease => enabled && (_atMin ? onDelete != null : true);

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final i = theme.input;
    final decrease = _atMin
        ? () => onDelete?.call()
        : () => onChanged(value - 1);
    // As small as its content, at the start, even in a stretched column.
    return Align(
      alignment: AlignmentDirectional.centerStart,
      widthFactor: 1,
      heightFactor: 1,
      child: Semantics(
        container: true,
        label: label,
        value: '$value',
        increasedValue: '${value + 1}',
        decreasedValue: '${value - 1}',
        onIncrease: _canIncrease ? () => onChanged(value + 1) : null,
        onDecrease: _canDecrease && !_atMin ? () => onChanged(value - 1) : null,
        child: CustomPaint(
          painter: _BridgePainter(
            fill: i.stepperBackground,
            target: i.stepperTarget,
            circle: i.stepperSize,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StepButton(
                icon: t.FoxIcons.add,
                label: increaseLabel,
                onTap: _canIncrease ? () => onChanged(value + 1) : null,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: i.stepperTarget - t.FoxSpace.xxs,
                ),
                child: ExcludeSemantics(
                  child: Text(
                    '$value',
                    textAlign: TextAlign.center,
                    style: theme.text.number.copyWith(
                      fontWeight: FoxTextTheme.fontWeight(700),
                      color: enabled ? i.stepperValue : i.onDisabled,
                    ),
                  ),
                ),
              ),
              _StepButton(
                icon: _atMin && onDelete != null
                    ? t.FoxIcons.delete
                    : t.FoxIcons.remove,
                label: _atMin && onDelete != null ? deleteLabel : decreaseLabel,
                onTap: _canDecrease ? decrease : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final t.FoxIconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final i = theme.input;
    final enabled = onTap != null;
    return Interaction(
      enabled: enabled,
      onTap: onTap,
      isButton: true,
      label: label,
      builder: (context, state) {
        final colour = enabled ? i.stepperBorder : i.onDisabled;
        return SizedBox.square(
          dimension: i.stepperTarget,
          child: Center(
            child: CustomPaint(
              foregroundPainter: FocusRing.of(
                theme,
                on: state.focused,
                radius: i.stepperSize,
                circle: true,
              ),
              child: AnimatedContainer(
                duration: t.FoxDuration.base,
                curve: theme.easing,
                width: i.stepperSize,
                height: i.stepperSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: state.pressed
                      ? i.stepperBackgroundPressed
                      : (state.hovered
                            ? theme.colors.surfaceRaisedHover
                            : i.stepperBackground),
                  border: Border.all(color: colour, width: i.borderWidth * 1.5),
                ),
                child: Center(
                  child: FoxIcon(icon, size: FoxIconSize.sm, color: colour),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// The strip between the two circles, its ends cut by a ring
/// [_bridgeClearance] wider than each circle: the cart's concave bridge.
class _BridgePainter extends CustomPainter {
  _BridgePainter({
    required this.fill,
    required this.target,
    required this.circle,
  });

  final Color fill;
  final double target;
  final double circle;

  @override
  void paint(Canvas canvas, Size size) {
    final reach = circle / 2 + _bridgeClearance;
    final half = circle / 2;
    // Where the strip's top and bottom edges meet the clearance ring.
    final dx = math.sqrt(reach * reach - half * half);
    final centre = size.height / 2;
    final start = target / 2;
    final end = size.width - target / 2;
    final path = Path()
      ..moveTo(start + dx, centre - half)
      ..lineTo(end - dx, centre - half)
      ..arcToPoint(
        Offset(end - dx, centre + half),
        radius: Radius.circular(reach),
        clockwise: false,
      )
      ..lineTo(start + dx, centre + half)
      ..arcToPoint(
        Offset(start + dx, centre - half),
        radius: Radius.circular(reach),
        clockwise: false,
      )
      ..close();
    canvas.drawPath(path, Paint()..color = fill);
  }

  @override
  bool shouldRepaint(_BridgePainter old) =>
      old.fill != fill || old.target != target || old.circle != circle;
}
