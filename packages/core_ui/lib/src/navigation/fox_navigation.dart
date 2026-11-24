import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../count_badge/fox_count_badge.dart';
import '../icon/fox_icon.dart';
import '../internal/interaction.dart';
import '../theme/fox_theme.dart';

/// The states every BottomNavigation use case and golden shows (R3).
const bottomNavigationStates = ['default', 'badge', 'dot'];

/// The states every NavigationRail use case and golden shows (R3).
const navigationRailStates = ['default', 'badge'];

/// One destination of the bottom navigation or the rail.
@immutable
final class FoxNavItem {
  const FoxNavItem({
    required this.icon,
    required this.label,
    this.badgeCount,
    this.badgeLabel,
    this.dot = false,
  }) : assert(
         (badgeCount == null && !dot) || badgeLabel != null,
         'A badge needs its words (badgeLabel): never colour alone.',
       );

  final t.FoxIconData icon;

  /// The name: read by screen readers (the bar shows icons only) and shown
  /// under the rail's icon.
  final String label;

  /// A count on the icon; [badgeLabel] says it («1 جديد») with the name.
  final int? badgeCount;
  final String? badgeLabel;

  /// A dot instead of a count: something new, no number.
  final bool dot;

  String get semanticLabel {
    final badge = badgeLabel;
    return badge == null ? label : '$label، $badge';
  }
}

/// The bottom navigation of the three apps (D.10; owner, 2026-11-24): the
/// Figma file's floating bar exactly, a pill in the accent colour holding a
/// circle per item, the selected circle primary on its pressed edge. Icons
/// only: the names are read by screen readers. Each item is a 48 target;
/// the bar floats above the home indicator (safe area).
class FoxBottomNavigation extends StatelessWidget {
  const FoxBottomNavigation({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelected,
  });

  final List<FoxNavItem> items;
  final int selected;
  final ValueChanged<int> onSelected;

  /// The key of each item's circle, for tests.
  static const itemKey = ValueKey('FoxBottomNavigation.item');

  /// The key of the pill, for tests.
  static const pillKey = ValueKey('FoxBottomNavigation.pill');

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final c = theme.colors;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(t.FoxSpace.sm),
        child: DecoratedBox(
          key: pillKey,
          decoration: BoxDecoration(
            color: c.accent,
            borderRadius: BorderRadius.circular(t.FoxRadius.full),
            boxShadow: [theme.shadows.medium],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: t.FoxSpace.sm,
              vertical: t.FoxSpace.xs,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var n = 0; n < items.length; n++)
                  _BarItem(
                    item: items[n],
                    selected: n == selected,
                    onTap: () => onSelected(n),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  const _BarItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final FoxNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final c = theme.colors;
    return Interaction(
      onTap: onTap,
      label: item.semanticLabel,
      isButton: true,
      inGroup: true,
      selected: selected,
      enabledState: false,
      builder: (context, state) {
        final fill = selected
            ? (state.pressed ? c.primaryPressed : c.primary)
            : (state.pressed
                  ? c.surfacePressed
                  : (state.hovered ? c.surfaceHover : c.surface));
        return _Badged(
          item: item,
          child: AnimatedContainer(
            key: FoxBottomNavigation.itemKey,
            duration: t.FoxDuration.base,
            curve: theme.easing,
            width: t.FoxSize.touchTarget,
            height: t.FoxSize.touchTarget,
            decoration: BoxDecoration(
              color: fill,
              shape: BoxShape.circle,
              border: state.focused
                  ? Border.all(color: c.onAccent, width: theme.input.focusWidth)
                  : null,
              // The Figma file's pressed edge under the active circle.
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: c.primaryPressed,
                        offset: const Offset(0, t.FoxSpace.xxs),
                      ),
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: FoxIcon(item.icon, color: selected ? c.onPrimary : c.accent),
          ),
        );
      },
    );
  }
}

/// [child] with the item's count or dot on its end corner.
class _Badged extends StatelessWidget {
  const _Badged({required this.item, required this.child});

  final FoxNavItem item;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final count = item.badgeCount;
    if (count == null && !item.dot) return child;
    return FoxCountBadge(
      count: item.dot ? null : count,
      semanticLabel: item.badgeLabel ?? '',
      child: child,
    );
  }
}

/// The restaurant's navigation rail on a tablet (840 dp or wider) and on
/// Windows (RA §6.2): the items in a column on the start side, the icon in
/// a tinted pill when selected, the name under it. Tab reaches it, the
/// arrows move along it, Enter or Space picks.
class FoxNavigationRail extends StatelessWidget {
  const FoxNavigationRail({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelected,
  });

  final List<FoxNavItem> items;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final c = theme.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surfaceRaised,
        border: BorderDirectional(end: BorderSide(color: c.border)),
      ),
      child: SizedBox(
        width: t.FoxSize.touchTarget + t.FoxSpace.xl + t.FoxSpace.xs,
        child: Shortcuts(
          shortcuts: const {
            SingleActivator(LogicalKeyboardKey.arrowDown): NextFocusIntent(),
            SingleActivator(LogicalKeyboardKey.arrowUp): PreviousFocusIntent(),
          },
          child: FocusTraversalGroup(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: t.FoxSpace.md),
              child: Column(
                children: [
                  for (var n = 0; n < items.length; n++) ...[
                    if (n > 0) const SizedBox(height: t.FoxSpace.sm),
                    _RailItem(
                      item: items[n],
                      selected: n == selected,
                      onTap: () => onSelected(n),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RailItem extends StatelessWidget {
  const _RailItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final FoxNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final c = theme.colors;
    final ink = selected ? c.onPrimarySubtle : c.onSurfaceMuted;
    return Interaction(
      onTap: onTap,
      label: item.semanticLabel,
      isButton: true,
      inGroup: true,
      selected: selected,
      enabledState: false,
      builder: (context, state) => ConstrainedBox(
        constraints: const BoxConstraints(minHeight: t.FoxSize.touchTarget),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Badged(
              item: item,
              child: AnimatedContainer(
                duration: t.FoxDuration.base,
                curve: theme.easing,
                width: t.FoxSpace.xxxl - t.FoxSpace.xs,
                height: t.FoxSpace.xl,
                decoration: BoxDecoration(
                  color: selected
                      ? c.primarySubtle
                      : (state.pressed
                            ? c.surfaceRaisedPressed
                            : (state.hovered
                                  ? c.surfaceRaisedHover
                                  : c.surfaceRaised)),
                  borderRadius: BorderRadius.circular(t.FoxRadius.full),
                  border: state.focused
                      ? Border.all(
                          color: c.focusRing,
                          width: theme.input.focusWidth,
                        )
                      : null,
                ),
                alignment: Alignment.center,
                child: FoxIcon(item.icon, color: ink),
              ),
            ),
            const SizedBox(height: t.FoxSpace.xxs),
            Text(
              item.label,
              textAlign: TextAlign.center,
              style: theme.text.caption.copyWith(
                color: ink,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
