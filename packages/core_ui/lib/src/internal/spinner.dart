import 'dart:math' as math;

import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';

/// A three-quarter ring turning once a second, still when the platform asks
/// for no animations (as the Button's). Not exported.
class Spinner extends StatefulWidget {
  const Spinner({super.key, required this.color, this.size = t.FoxSize.iconMd});

  final Color color;
  final double size;

  @override
  State<Spinner> createState() => _SpinnerState();
}

class _SpinnerState extends State<Spinner> with SingleTickerProviderStateMixin {
  late final AnimationController _turn = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      _turn.stop();
    } else if (!_turn.isAnimating) {
      _turn.repeat();
    }
  }

  @override
  void dispose() {
    _turn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size.square(widget.size),
    painter: _SpinnerPainter(_turn, widget.color),
  );
}

class _SpinnerPainter extends CustomPainter {
  _SpinnerPainter(this.turn, this.color) : super(repaint: turn);

  final Animation<double> turn;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width / 12;
    final rect = (Offset.zero & size).deflate(stroke);
    canvas.drawArc(
      rect,
      turn.value * 2 * math.pi - math.pi / 2,
      1.5 * math.pi,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_SpinnerPainter old) =>
      old.color != color || old.turn != turn;
}
