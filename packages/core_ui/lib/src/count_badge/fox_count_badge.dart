import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';

import '../theme/fox_theme.dart';

/// The states every CountBadge use case and golden shows (R3), as the web's.
const countBadgeStates = ['default', 'dot', 'capped', 'primary', 'inline'];

/// Red by default, orange for the cart (R4 exception), blue in a tab.
enum FoxBadgeTone { danger, primary, accent }

/// The count as the badge shows it: at most [max], then «max+».
String foxBadgeText(int count, int max) => count > max ? '$max+' : '$count';

/// A count or a dot on the corner of [child] (an icon), or inline without one.
/// The visible count is hidden; [semanticLabel] gives the full count in words.
class FoxCountBadge extends StatelessWidget {
  const FoxCountBadge({
    super.key,
    required this.semanticLabel,
    this.count,
    this.max = 99,
    this.tone = FoxBadgeTone.danger,
    this.child,
  });

  /// Null is a dot («something new»); zero shows nothing.
  final int? count;
  final int max;

  /// «3 إشعارات».
  final String semanticLabel;
  final FoxBadgeTone tone;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final countBadge = theme.components.countBadge;
    final count = this.count;
    final child = this.child;
    if (count == 0) return child ?? const SizedBox.shrink();
    final (fill, ink) = switch (tone) {
      FoxBadgeTone.danger => (
        countBadge.dangerBackground,
        countBadge.dangerLabel,
      ),
      FoxBadgeTone.primary => (
        countBadge.primaryBackground,
        countBadge.primaryLabel,
      ),
      FoxBadgeTone.accent => (
        countBadge.accentBackground,
        countBadge.accentLabel,
      ),
    };
    // A ring of the raised surface parts the badge from the icon under it;
    // the size holds it, as the D.9 sheet measures the badge.
    final ring = Border.all(
      color: Color(countBadge.ring),
      width: countBadge.ringWidth,
    );
    final mark = count == null
        ? Container(
            width: countBadge.dotSize,
            height: countBadge.dotSize,
            decoration: BoxDecoration(
              color: Color(fill),
              shape: BoxShape.circle,
              border: ring,
            ),
          )
        : Container(
            constraints: BoxConstraints(
              minWidth: countBadge.size,
              minHeight: countBadge.size,
            ),
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: countBadge.paddingInline,
            ),
            decoration: BoxDecoration(
              color: Color(fill),
              borderRadius: BorderRadius.circular(t.FoxRadius.full),
              border: ring,
            ),
            // Centred but as small as the count: an `alignment` would make
            // the badge fill a wide parent (a tab, a Wrap).
            child: Align(
              widthFactor: 1,
              heightFactor: 1,
              child: Text(
                foxBadgeText(count, max),
                textDirection: TextDirection.ltr,
                style: theme.text.caption.copyWith(
                  color: Color(ink),
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          );
    return Semantics(
      container: true,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: child == null
            ? mark
            : Stack(
                clipBehavior: Clip.none,
                children: [
                  child,
                  // A count is centred on the corner, the dot tucked on it.
                  PositionedDirectional(
                    top: -(count == null
                        ? countBadge.dotOffset
                        : countBadge.offset),
                    end: -(count == null
                        ? countBadge.dotOffset
                        : countBadge.offset),
                    child: mark,
                  ),
                ],
              ),
      ),
    );
  }
}
