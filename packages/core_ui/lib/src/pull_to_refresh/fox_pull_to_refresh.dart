import 'dart:math' as math;

import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../icon/path_data.dart';
import '../theme/fox_theme.dart';

/// The states of the PullToRefresh use case (R3).
const pullToRefreshStates = ['default'];

/// The states every RefreshDrop use case and golden shows (R3).
const refreshDropStates = ['empty', 'half', 'full', 'refreshing'];

/// How far a pull goes before it refreshes.
const double _threshold = t.FoxSpace.xxxl + t.FoxSpace.md;

/// The logo's drop (brand expression §2), outline 24 × 24.
const _dropPath = 'M12 23s9-8.4 9-14.5a9 9 0 0 0-18 0C3 14.6 12 23 12 23Z';

/// Pull to refresh (D.10; owner, 2026-11-24: the logo's drop). Pulling the
/// list down from its top fills the drop with the primary colour; past the
/// threshold, letting go runs [onRefresh] once and the drop pulses until its
/// future completes. Under reduced motion the drop stays still. Screen
/// readers get the [refreshLabel] action, which refreshes without a
/// gesture. [child] is the scrollable (give it `AlwaysScrollableScrollPhysics`
/// so a short list can be pulled).
class FoxPullToRefresh extends StatefulWidget {
  const FoxPullToRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
    required this.refreshLabel,
  });

  final Widget child;
  final Future<void> Function() onRefresh;
  final String refreshLabel;

  @override
  State<FoxPullToRefresh> createState() => _FoxPullToRefreshState();
}

class _FoxPullToRefreshState extends State<FoxPullToRefresh> {
  double _pulled = 0;
  bool _refreshing = false;
  bool _dragging = false;

  Future<void> _refresh() async {
    if (_refreshing) return;
    setState(() {
      _refreshing = true;
      _pulled = 0;
    });
    try {
      await widget.onRefresh();
    } finally {
      if (mounted) setState(() => _refreshing = false);
    }
  }

  /// The pull is measured while the finger is down and judged when it
  /// lets go: a bouncing list (iOS) springs back before its scroll ends, so
  /// waiting for the end would see no pull at all.
  bool _onScroll(ScrollNotification n) {
    if (n.metrics.axis != Axis.vertical || n.depth != 0) return false;
    if (n is ScrollStartNotification) {
      _dragging = n.dragDetails != null;
    } else if (n is OverscrollNotification) {
      if (_dragging && n.overscroll < 0 && n.dragDetails != null) {
        setState(() => _pulled -= n.overscroll);
      }
    } else if (n is ScrollUpdateNotification) {
      if (n.dragDetails == null) {
        // The finger is up: the list now moves on its own.
        if (_dragging) _release();
        return false;
      }
      final before = n.metrics.pixels - n.metrics.minScrollExtent;
      if (before < 0) {
        // A bouncing list: the pull is how far it went past the top.
        setState(() => _pulled = -before);
      } else if (_pulled > 0 && (n.scrollDelta ?? 0) > 0) {
        setState(() => _pulled = math.max(0, _pulled - n.scrollDelta!));
      }
    } else if (n is ScrollEndNotification) {
      if (_dragging) _release();
    }
    return false;
  }

  void _release() {
    _dragging = false;
    final go = _pulled >= _threshold;
    if (_pulled != 0) setState(() => _pulled = 0);
    if (go) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_pulled / _threshold).clamp(0.0, 1.0);
    final showing = _refreshing || progress > 0;
    return Semantics(
      container: true,
      customSemanticsActions: {
        CustomSemanticsAction(label: widget.refreshLabel): _refresh,
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: _onScroll,
        child: Stack(
          children: [
            // The drop replaces the platform's glow at the top.
            NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (n) {
                if (n.leading) n.disallowIndicator();
                return false;
              },
              child: widget.child,
            ),
            if (showing)
              PositionedDirectional(
                top: t.FoxSpace.md,
                start: 0,
                end: 0,
                child: Center(
                  child: FoxRefreshDrop(
                    progress: _refreshing ? 1 : progress,
                    refreshing: _refreshing,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// The drop of pull to refresh: on a raised circle, filled from the bottom
/// to [progress]; while [refreshing] it is full and pulses (still under
/// reduced motion).
class FoxRefreshDrop extends StatefulWidget {
  const FoxRefreshDrop({
    super.key,
    required this.progress,
    this.refreshing = false,
  });

  final double progress;
  final bool refreshing;

  @override
  State<FoxRefreshDrop> createState() => _FoxRefreshDropState();
}

class _FoxRefreshDropState extends State<FoxRefreshDrop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: t.FoxDuration.moment,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(FoxRefreshDrop old) {
    super.didUpdateWidget(old);
    _sync();
  }

  void _sync() {
    final still = MediaQuery.disableAnimationsOf(context);
    if (widget.refreshing && !still) {
      if (!_pulse.isAnimating) _pulse.repeat(reverse: true);
    } else {
      _pulse
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final c = theme.colors;
    return Container(
      width: t.FoxSize.touchTarget,
      height: t.FoxSize.touchTarget,
      decoration: BoxDecoration(
        color: c.surfaceRaised,
        shape: BoxShape.circle,
        boxShadow: [theme.shadows.medium],
      ),
      alignment: Alignment.center,
      child: FadeTransition(
        opacity: Tween<double>(begin: 1, end: 0.45).animate(_pulse),
        child: CustomPaint(
          size: const Size.square(t.FoxSize.iconLg),
          painter: _DropPainter(
            progress: widget.progress.clamp(0.0, 1.0),
            fill: c.primary,
            empty: c.primarySubtle,
          ),
        ),
      ),
    );
  }
}

class _DropPainter extends CustomPainter {
  _DropPainter({
    required this.progress,
    required this.fill,
    required this.empty,
  });

  final double progress;
  final Color fill;
  final Color empty;

  static final Path _drop = parseSvgPath(_dropPath);

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24;
    canvas.scale(scale);
    final level = 2 + 21 * (1 - progress);
    canvas
      ..save()
      ..clipPath(_drop)
      ..drawRect(const Rect.fromLTRB(0, 0, 24, 24), Paint()..color = empty)
      ..drawRect(Rect.fromLTRB(0, level, 24, 24), Paint()..color = fill)
      ..restore()
      ..drawPath(
        _drop,
        Paint()
          ..color = fill
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2,
      );
  }

  @override
  bool shouldRepaint(_DropPainter old) =>
      old.progress != progress || old.fill != fill || old.empty != empty;
}
