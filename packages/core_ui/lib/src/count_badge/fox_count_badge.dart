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
    final count = this.count;
    final child = this.child;
    if (count == 0) return child ?? const SizedBox.shrink();
    final (fill, ink) = switch (tone) {
      FoxBadgeTone.danger => (theme.colors.danger, theme.colors.onDanger),
      FoxBadgeTone.primary => (theme.colors.primary, theme.colors.onPrimary),
      FoxBadgeTone.accent => (theme.colors.accent, theme.colors.onAccent),
    };
    // A ring of the raised surface parts the badge from the icon under it.
    final ring = Border.all(
      color: theme.colors.surfaceRaised,
      width: theme.input.focusWidth,
    );
    final mark = count == null
        ? Container(
            width: t.FoxSpace.sm,
            height: t.FoxSpace.sm,
            decoration: BoxDecoration(
              color: fill,
              shape: BoxShape.circle,
              border: ring,
            ),
          )
        : Container(
            constraints: const BoxConstraints(
              minWidth: t.FoxSpace.lg,
              minHeight: t.FoxSpace.lg,
            ),
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: t.FoxSpace.xxs,
            ),
            decoration: BoxDecoration(
              color: fill,
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
                  color: ink,
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
                  PositionedDirectional(
                    top: -t.FoxSpace.xs,
                    end: -t.FoxSpace.xs,
                    child: mark,
                  ),
                ],
              ),
      ),
    );
  }
}
