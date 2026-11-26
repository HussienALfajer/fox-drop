import 'dart:math' as math;

import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../drop_loader/fox_drop_loader.dart';
import '../theme/fox_theme.dart';

/// The states of the PullToRefresh use case (R3).
const pullToRefreshStates = ['default'];

/// The states every RefreshDrop use case and golden shows (R3).
const refreshDropStates = ['empty', 'half', 'full', 'refreshing'];

/// How far a pull goes before it refreshes.
const double _threshold = t.FoxSpace.xxxl + t.FoxSpace.md;

/// Pull to refresh (D.10; owner, 2026-11-24: the logo's drop; D.11b: the
/// mark). Pulling the list down from its top fills the mark; past the
/// threshold, letting go runs [onRefresh] once and the mark cycles as the
/// drop loader until its future completes (still under reduced motion). Screen
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
                top: FoxTheme.of(context).components.pullToRefresh.inset,
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

/// The drop of pull to refresh: the brand mark on a raised circle, filled
/// from the bottom to [progress]; while [refreshing] it is the drop loader.
class FoxRefreshDrop extends StatelessWidget {
  const FoxRefreshDrop({
    super.key,
    required this.progress,
    this.refreshing = false,
  });

  final double progress;
  final bool refreshing;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final pullToRefresh = theme.components.pullToRefresh;
    return Container(
      width: pullToRefresh.dropSize,
      height: pullToRefresh.dropSize,
      decoration: BoxDecoration(
        color: Color(pullToRefresh.colorDrop),
        shape: BoxShape.circle,
        boxShadow: [theme.shadows.medium],
      ),
      alignment: Alignment.center,
      // The project's one loader (D.11b): it fills as you pull, and cycles
      // while the refresh runs (still, half full, under reduced motion).
      child: SizedBox.square(
        dimension: pullToRefresh.markSize,
        child: FittedBox(
          child: refreshing
              ? const FoxDropLoader(size: FoxDropLoaderSize.lg)
              : FoxDropLoader(
                  size: FoxDropLoaderSize.lg,
                  level: progress.clamp(0.0, 1.0),
                ),
        ),
      ),
    );
  }
}
