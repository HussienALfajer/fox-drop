import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';

import '../theme/fox_theme.dart';

/// The states every Skeleton use case and golden shows (R3), as the web's.
const skeletonStates = ['default', 'listRows', 'orderCard'];

/// The shapes of one block.
const skeletonBlockStates = ['line', 'circle'];

/// The loading state of R6: grey blocks in the shape of the content to come,
/// read once by [label]. The approved calm pulse (owner, 2026-11-24): opacity
/// 1 → 0.55 → 1 over `duration.moment`; still under reduced motion.
class FoxSkeleton extends StatefulWidget {
  const FoxSkeleton({super.key, required this.label, required this.child});

  /// «جارٍ التحميل».
  final String label;

  /// [FoxSkeletonBlock]s laid out like the content.
  final Widget child;

  @override
  State<FoxSkeleton> createState() => _FoxSkeletonState();
}

class _FoxSkeletonState extends State<FoxSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: t.FoxDuration.moment,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _pulse
        ..stop()
        ..value = 0;
    } else if (!_pulse.isAnimating) {
      _pulse.repeat();
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curve = FoxTheme.of(context).easing;
    return Semantics(
      container: true,
      liveRegion: true,
      label: widget.label,
      child: ExcludeSemantics(
        child: AnimatedBuilder(
          animation: _pulse,
          builder: (context, child) {
            // Down to 0.55 at the middle of each beat and back.
            final beat = curve.transform(
              _pulse.value < 0.5 ? _pulse.value * 2 : (1 - _pulse.value) * 2,
            );
            return Opacity(opacity: 1 - 0.45 * beat, child: child);
          },
          child: widget.child,
        ),
      ),
    );
  }
}

/// One grey block of a [FoxSkeleton]: a line of [height] across its width, or
/// a circle.
class FoxSkeletonBlock extends StatelessWidget {
  const FoxSkeletonBlock({super.key, this.height = t.FoxSpace.sm, this.width})
    : circle = false;

  const FoxSkeletonBlock.circle(double size, {super.key})
    : height = size,
      width = size,
      circle = true;

  final double height;
  final double? width;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    final colors = FoxTheme.of(context).colors;
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: colors.neutralSubtle,
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circle ? null : BorderRadius.circular(t.FoxRadius.xs),
      ),
    );
  }
}
