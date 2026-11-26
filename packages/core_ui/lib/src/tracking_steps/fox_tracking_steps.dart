import 'dart:ui' as ui;

import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';

import '../icon/fox_icon.dart';
import '../theme/fox_theme.dart';

/// The states every TrackingSteps use case and golden shows (R3).
const trackingStepsStates = ['first', 'middle', 'last', 'done'];

/// One step of an order's way: its icon and its name.
@immutable
final class FoxTrackingStep {
  const FoxTrackingStep({required this.icon, required this.label});

  final t.FoxIconData icon;
  final String label;
}

/// An order's way in four equal columns (D.11: the sign-in hero's «طلباتي»
/// origin and the blocking screen's order; later D.16): done steps in the
/// brand blue, the current step an orange circle with two soft rings on
/// `motion.pulse`, later steps dashed. Each step says in words whether it is
/// done or now ([doneLabel], [nowLabel]), never by colour alone. [current]
/// equal to the steps' count marks every step done.
class FoxTrackingSteps extends StatelessWidget {
  const FoxTrackingSteps({
    super.key,
    required this.steps,
    required this.current,
    required this.doneLabel,
    required this.nowLabel,
  }) : assert(current >= 0 && current <= steps.length);

  final List<FoxTrackingStep> steps;
  final int current;

  /// «تم», read after a done step's name.
  final String doneLabel;

  /// «الآن», read after the current step's name.
  final String nowLabel;

  /// The key of step [n]'s circle, for tests.
  static Key stepKey(int n) => ValueKey('FoxTrackingSteps.step.$n');

  /// The key of each pulsing ring, for tests.
  static const pulseKey = ValueKey('FoxTrackingSteps.pulse');

  @override
  Widget build(BuildContext context) {
    final trackingSteps = FoxTheme.of(context).components.trackingSteps;
    return CustomPaint(
      painter: _Links(
        count: steps.length,
        current: current,
        done: Color(trackingSteps.colorDone),
        later: Color(trackingSteps.colorLaterLine),
        width: trackingSteps.lineWidth,
        dash: trackingSteps.dash,
        centre: trackingSteps.circle / 2,
        direction: Directionality.of(context),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var n = 0; n < steps.length; n++)
            Expanded(
              child: _Step(
                n: n,
                step: steps[n],
                done: n < current,
                now: n == current,
                doneLabel: doneLabel,
                nowLabel: nowLabel,
              ),
            ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.n,
    required this.step,
    required this.done,
    required this.now,
    required this.doneLabel,
    required this.nowLabel,
  });

  final int n;
  final FoxTrackingStep step;
  final bool done;
  final bool now;
  final String doneLabel;
  final String nowLabel;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final trackingSteps = theme.components.trackingSteps;
    final (fill, ink, labelInk) = done
        ? (
            trackingSteps.colorDone,
            trackingSteps.colorOnDone,
            trackingSteps.colorDoneLabel,
          )
        : now
        ? (
            trackingSteps.colorCurrent,
            trackingSteps.colorOnCurrent,
            trackingSteps.colorCurrentLabel,
          )
        : (
            trackingSteps.colorLater,
            trackingSteps.colorOnLater,
            trackingSteps.colorLaterLabel,
          );
    final state = done ? doneLabel : (now ? nowLabel : null);
    Widget circle = DecoratedBox(
      key: FoxTrackingSteps.stepKey(n),
      decoration: BoxDecoration(color: Color(fill), shape: BoxShape.circle),
      child: SizedBox.square(
        dimension: trackingSteps.circle,
        child: Center(
          child: FoxIcon(
            step.icon,
            color: Color(ink),
            style: done || now ? FoxIconStyle.bold : FoxIconStyle.linear,
          ),
        ),
      ),
    );
    if (!done && !now) {
      circle = CustomPaint(
        foregroundPainter: _DashedCircle(
          colour: Color(trackingSteps.colorLaterLine),
          width: trackingSteps.lineWidth,
        ),
        child: circle,
      );
    }
    if (now) circle = _Pulse(child: circle);
    return Semantics(
      container: true,
      label: state == null ? step.label : '${step.label}، $state',
      child: ExcludeSemantics(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            circle,
            SizedBox(height: trackingSteps.labelGap),
            Text(
              step.label,
              textAlign: TextAlign.center,
              style: theme.text.caption.copyWith(
                color: Color(labelInk),
                fontWeight: now ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Two rings that grow and fade from the circle, half a cycle apart; one
/// still ring under reduced motion.
class _Pulse extends StatefulWidget {
  const _Pulse({required this.child});

  final Widget child;

  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _cycle = AnimationController(
    vsync: this,
    duration: t.FoxMotion.pulseDuration,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final still = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (still) {
      _cycle.stop();
    } else if (!_cycle.isAnimating) {
      _cycle.repeat();
    }
  }

  @override
  void dispose() {
    _cycle.dispose();
    super.dispose();
  }

  Widget _ring(
    Color colour,
    double width,
    double size,
    double scale,
    double opacity,
  ) => IgnorePointer(
    key: FoxTrackingSteps.pulseKey,
    child: Opacity(
      opacity: opacity,
      child: Transform.scale(
        scale: scale,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: colour, width: width),
          ),
          child: SizedBox.square(dimension: size),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final trackingSteps = theme.components.trackingSteps;
    final colour = Color(trackingSteps.colorPulse);
    final width = trackingSteps.lineWidth;
    final size = trackingSteps.circle;
    final still = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final easing = theme.easing;
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        if (still)
          _ring(
            colour,
            width,
            size,
            t.FoxMotion.pulseStillScale,
            t.FoxMotion.pulseStillOpacity,
          )
        else
          for (final offset in const [0.0, 0.5])
            AnimatedBuilder(
              animation: _cycle,
              builder: (context, _) {
                final at = easing.transform((_cycle.value + offset) % 1);
                return _ring(
                  colour,
                  width,
                  size,
                  ui.lerpDouble(
                    t.FoxMotion.pulseScaleFrom,
                    t.FoxMotion.pulseScaleTo,
                    at,
                  )!,
                  ui.lerpDouble(
                    t.FoxMotion.pulseOpacityFrom,
                    t.FoxMotion.pulseOpacityTo,
                    at,
                  )!,
                );
              },
            ),
        widget.child,
      ],
    );
  }
}

/// The links between the circles' centres, through the middle of each
/// circle: solid blue up to the current step, dashed after it.
class _Links extends CustomPainter {
  _Links({
    required this.count,
    required this.current,
    required this.done,
    required this.later,
    required this.width,
    required this.dash,
    required this.centre,
    required this.direction,
  });

  final int count;
  final int current;
  final Color done;
  final Color later;
  final double width;
  final double dash;

  /// The circles' centre line, half a circle down.
  final double centre;
  final TextDirection direction;

  @override
  void paint(Canvas canvas, Size size) {
    if (count < 2) return;
    final column = size.width / count;
    double x(int n) {
      final fromStart = (n + 0.5) * column;
      return direction == TextDirection.rtl
          ? size.width - fromStart
          : fromStart;
    }

    for (var n = 0; n < count - 1; n++) {
      final paint = Paint()
        ..strokeWidth = width
        ..color = n < current ? done : later;
      final from = Offset(x(n), centre);
      final to = Offset(x(n + 1), centre);
      if (n < current) {
        canvas.drawLine(from, to, paint);
      } else {
        _dashed(canvas, from, to, paint, dash);
      }
    }
  }

  @override
  bool shouldRepaint(_Links old) =>
      old.count != count ||
      old.current != current ||
      old.done != done ||
      old.later != later ||
      old.direction != direction ||
      old.width != width ||
      old.dash != dash ||
      old.centre != centre;
}

void _dashed(Canvas canvas, Offset from, Offset to, Paint paint, double dash) {
  final length = (to - from).distance;
  final step = (to - from) / length;
  for (var d = 0.0; d < length; d += dash * 2) {
    final end = d + dash > length ? length : d + dash;
    canvas.drawLine(from + step * d, from + step * end, paint);
  }
}

/// A later step's dashed outline.
class _DashedCircle extends CustomPainter {
  _DashedCircle({required this.colour, required this.width});

  final Color colour;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colour
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;
    final rect = (Offset.zero & size).deflate(width / 2);
    const dashes = 16;
    const sweep = 2 * 3.141592653589793 / dashes;
    for (var n = 0; n < dashes; n++) {
      canvas.drawArc(rect, n * sweep, sweep / 2, false, paint);
    }
  }

  @override
  bool shouldRepaint(_DashedCircle old) =>
      old.colour != colour || old.width != width;
}
