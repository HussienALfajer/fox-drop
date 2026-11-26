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

/// The bottom navigation of the three apps (D.10; the Figma shape, D.11b):
/// an accent outline that swells round each tab, in a `color.nav-halo`
/// halo, an ivory circle per item and the current one a larger orange
/// circle. Large Linear icons only: the names are read by screen readers.
/// Each item is a 48 target; the bar floats above the home indicator (safe
/// area).
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

  /// The key of the outline's painter, for tests.
  static const outlineKey = ValueKey('FoxBottomNavigation.outline');

  @override
  Widget build(BuildContext context) {
    final bottomNavigation = FoxTheme.of(context).components.bottomNavigation;
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.all(bottomNavigation.margin),
        child: Center(
          heightFactor: 1,
          child: CustomPaint(
            key: outlineKey,
            painter: FoxNavOutlinePainter(
              count: items.length,
              fill: Color(bottomNavigation.colorFill),
              halo: Color(bottomNavigation.colorHalo),
              haloWidth: bottomNavigation.haloWidth,
            ),
            child: SizedBox(
              key: pillKey,
              height: bottomNavigation.height,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: bottomNavigation.paddingInline,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var n = 0; n < items.length; n++) ...[
                      if (n > 0) SizedBox(width: bottomNavigation.gap),
                      _BarItem(
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
      ),
    );
  }
}

/// The bar's outline in the owner's Figma shape (D.11 screen 6): one smooth
/// accent shape that swells round each tab and dips between them, ringed by
/// a halo in `color.nav-halo`. Its geometry follows the tabs: a 48 circle
/// every 56 (`size.touch-target` and `space.xs`), the ends half circles of
/// 32, a dip of `space.xs`. Exposed for tests.
class FoxNavOutlinePainter extends CustomPainter {
  FoxNavOutlinePainter({
    required this.count,
    required this.fill,
    required this.halo,
    this.haloWidth = t.FoxSpace.xs,
  });

  final int count;
  final Color fill;
  final Color halo;

  /// The halo's stroke: `bottom-navigation.halo-width`.
  final double haloWidth;

  /// The outline for [count] tabs in a box [size] high, from its start.
  static Path outline(int count, Size size) {
    const step = t.FoxSize.touchTarget + t.FoxSpace.xs;
    final radius = size.height / 2;
    const dip = t.FoxSpace.xs;
    final bottom = size.height;
    // The Figma curve between two tabs, as fractions of the step.
    const a = 14.4 / 56;
    const b = 15.4 / 56;
    final path = Path()
      ..moveTo(radius, bottom)
      ..arcToPoint(Offset(radius, 0), radius: Radius.circular(radius));
    for (var n = 0; n < count - 1; n++) {
      final x = radius + n * step;
      path
        ..cubicTo(x + a * step, 0, x + b * step, dip, x + step / 2, dip)
        ..cubicTo(
          x + step - b * step,
          dip,
          x + step - a * step,
          0,
          x + step,
          0,
        );
    }
    final last = radius + (count - 1) * step;
    path.arcToPoint(Offset(last, bottom), radius: Radius.circular(radius));
    for (var n = count - 1; n > 0; n--) {
      final x = radius + n * step;
      path
        ..cubicTo(
          x - a * step,
          bottom,
          x - b * step,
          bottom - dip,
          x - step / 2,
          bottom - dip,
        )
        ..cubicTo(
          x - step + b * step,
          bottom - dip,
          x - step + a * step,
          bottom,
          x - step,
          bottom,
        );
    }
    return path..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final path = outline(count, size);
    canvas
      ..drawPath(
        path,
        Paint()
          ..color = halo
          ..style = PaintingStyle.stroke
          ..strokeWidth = haloWidth
          ..strokeJoin = StrokeJoin.round,
      )
      ..drawPath(path, Paint()..color = fill);
  }

  @override
  bool shouldRepaint(FoxNavOutlinePainter old) =>
      old.count != count ||
      old.fill != fill ||
      old.halo != halo ||
      old.haloWidth != haloWidth;
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
    final bottomNavigation = theme.components.bottomNavigation;
    return Interaction(
      onTap: onTap,
      label: item.semanticLabel,
      isButton: true,
      inGroup: true,
      selected: selected,
      enabledState: false,
      builder: (context, state) {
        final fill = Color(
          selected
              ? (state.pressed
                    ? bottomNavigation.colorItemSelectedPressed
                    : bottomNavigation.colorItemSelected)
              : (state.pressed
                    ? bottomNavigation.colorItemPressed
                    : (state.hovered
                          ? bottomNavigation.colorItemHover
                          : bottomNavigation.colorItem)),
        );
        // The current tab is a larger orange circle, `space.xs` wider, that
        // reaches into its neighbours' gaps so the row keeps its width.
        final big = bottomNavigation.itemSizeSelected;
        final side = selected ? big : bottomNavigation.itemSize;
        return SizedBox.square(
          dimension: bottomNavigation.itemSize,
          child: OverflowBox(
            maxWidth: big,
            maxHeight: big,
            child: _Badged(
              item: item,
              child: AnimatedContainer(
                key: FoxBottomNavigation.itemKey,
                duration: t.FoxDuration.base,
                curve: theme.easing,
                width: side,
                height: side,
                decoration: BoxDecoration(
                  color: fill,
                  shape: BoxShape.circle,
                  border: state.focused
                      ? Border.all(
                          color: Color(bottomNavigation.colorFocus),
                          width: theme.input.focusWidth,
                        )
                      : null,
                ),
                alignment: Alignment.center,
                // Every tab Linear, the selected one too: the larger circle
                // alone marks it (owner, 2026-11-25).
                child: FoxIcon(
                  item.icon,
                  size: FoxIconSize.lg,
                  color: Color(
                    selected
                        ? bottomNavigation.colorIconSelected
                        : bottomNavigation.colorIcon,
                  ),
                ),
              ),
            ),
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
    final navigationRail = FoxTheme.of(context).components.navigationRail;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Color(navigationRail.colorBackground),
        border: BorderDirectional(
          end: BorderSide(
            color: Color(navigationRail.colorBorder),
            width: navigationRail.borderWidth,
          ),
        ),
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
              padding: EdgeInsets.symmetric(
                vertical: navigationRail.railPaddingBlock,
              ),
              child: Column(
                children: [
                  for (var n = 0; n < items.length; n++) ...[
                    if (n > 0) SizedBox(height: navigationRail.railItemGap),
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
    final navigationRail = theme.components.navigationRail;
    final ink = Color(
      selected
          ? navigationRail.colorOnItemSelected
          : navigationRail.colorRailInk,
    );
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
                height: navigationRail.railPillHeight,
                decoration: BoxDecoration(
                  color: Color(
                    selected
                        ? navigationRail.colorItemSelected
                        : (state.pressed
                              ? navigationRail.colorItemPressed
                              : (state.hovered
                                    ? navigationRail.colorItemHover
                                    : navigationRail.colorBackground)),
                  ),
                  borderRadius: BorderRadius.circular(t.FoxRadius.full),
                  border: state.focused
                      ? Border.all(
                          color: theme.colors.focusRing,
                          width: theme.input.focusWidth,
                        )
                      : null,
                ),
                alignment: Alignment.center,
                child: FoxIcon(item.icon, color: ink),
              ),
            ),
            SizedBox(height: navigationRail.railLabelGap),
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
