import 'dart:math' as math;

import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';

import '../icon/fox_icon.dart';
import '../theme/fox_theme.dart';

/// The states every Timer use case and golden shows (R3), as the web's.
const timerStates = ['default', 'soon', 'minutes', 'late', 'waiting'];

/// The states of the captain's countdown ring.
const countdownRingStates = ['default', 'last'];

/// Calm, soon (the last minute of a countdown) and late (counting up, red).
enum FoxTimerTone { calm, soon, late }

/// A running duration as the approved sheet shows it (owner, 2026-11-24; AP
/// §4.7 gives «12 د» and «45 ث», backlog): «4:32» under ten minutes, «12 د» from ten
/// on (whole seconds, never negative); [minuteUnit] is the app's «د».
String foxFormatDuration(int seconds, String minuteUnit) {
  final whole = math.max(0, seconds);
  if (whole >= 600) return '${whole ~/ 60} $minuteUnit';
  return '${whole ~/ 60}:${(whole % 60).toString().padLeft(2, '0')}';
}

/// Soon in the last minute of a countdown; late when the app says so.
FoxTimerTone foxTimerTone({
  required int seconds,
  required bool countsDown,
  bool late = false,
}) {
  if (late) return FoxTimerTone.late;
  return countsDown && seconds <= 60 ? FoxTimerTone.soon : FoxTimerTone.calm;
}

/// A running time: the auto-cancel and prep countdowns, a late order, a
/// captain waiting. The app ticks [seconds]; screen readers are not told on
/// every tick.
class FoxTimer extends StatelessWidget {
  const FoxTimer({
    super.key,
    required this.seconds,
    required this.countsDown,
    required this.minuteUnit,
    this.late = false,
    this.tone,
    this.prefix,
    this.icon = t.FoxIcons.clock,
  });

  final int seconds;
  final bool countsDown;
  final String minuteUnit;
  final bool late;

  /// Overrides the computed tone: a captain waiting is soon.
  final FoxTimerTone? tone;

  /// Words before the time: «متأخر», «ينتظر منذ».
  final String? prefix;
  final t.FoxIconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final timer = theme.components.timer;
    final look =
        tone ??
        foxTimerTone(seconds: seconds, countsDown: countsDown, late: late);
    final (ink, fill) = switch (look) {
      FoxTimerTone.calm => (timer.calmText, timer.calmBackground),
      FoxTimerTone.soon => (timer.soonText, timer.soonBackground),
      FoxTimerTone.late => (timer.lateText, timer.lateBackground),
    };
    final colour = Color(ink);
    final time = foxFormatDuration(seconds, minuteUnit);
    final prefix = this.prefix;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Color(fill),
        borderRadius: BorderRadius.circular(t.FoxRadius.full),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: timer.minHeight),
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: timer.paddingInline,
            vertical: timer.paddingBlock,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FoxIcon(icon, size: FoxIconSize.sm, color: colour),
              SizedBox(width: timer.gap),
              Flexible(
                child: Text(
                  prefix == null ? time : '$prefix $time',
                  style: theme.text.subtitle.copyWith(
                    color: colour,
                    fontWeight: FontWeight.w700,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The captain's offer countdown (brand expression §3): a ring that empties
/// over [total] seconds, the seconds left inside, red in the last ten. The
/// arc eases from tick to tick over `FoxDuration.base`; under reduced motion
/// it jumps, and the number carries the time.
class FoxCountdownRing extends StatelessWidget {
  const FoxCountdownRing({
    super.key,
    required this.seconds,
    required this.total,
    this.diameter,
  });

  final int seconds;
  final int total;

  /// Defaults to the ring's token, two touch targets.
  final double? diameter;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final countdownRing = theme.components.countdownRing;
    final colour = Color(
      seconds <= 10 ? countdownRing.colorLast : countdownRing.colorProgress,
    );
    final still = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final clockwise = Directionality.of(context) == TextDirection.ltr;
    return SizedBox.square(
      dimension: diameter ?? countdownRing.size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: total <= 0 ? 0 : (seconds / total).clamp(0, 1)),
        duration: still ? Duration.zero : t.FoxDuration.base,
        curve: theme.easing,
        builder: (context, share, child) => CustomPaint(
          painter: _Ring(
            share: share,
            colour: colour,
            track: Color(countdownRing.colorTrack),
            width: countdownRing.strokeWidth,
            clockwise: clockwise,
          ),
          child: child,
        ),
        child: Center(
          child: Text(
            '$seconds',
            textDirection: TextDirection.ltr,
            style: theme.text.number.copyWith(color: colour),
          ),
        ),
      ),
    );
  }
}

class _Ring extends CustomPainter {
  _Ring({
    required this.share,
    required this.colour,
    required this.track,
    required this.width,
    required this.clockwise,
  });

  final double share;
  final Color colour;
  final Color track;
  final double width;
  final bool clockwise;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(width / 2);
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, math.pi * 2, false, stroke..color = track);
    final sweep = math.pi * 2 * share * (clockwise ? 1 : -1);
    canvas.drawArc(rect, -math.pi / 2, sweep, false, stroke..color = colour);
  }

  @override
  bool shouldRepaint(_Ring old) =>
      old.share != share || old.colour != colour || old.clockwise != clockwise;
}
