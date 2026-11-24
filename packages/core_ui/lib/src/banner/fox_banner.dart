import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';

import '../icon/fox_icon.dart';
import '../internal/interaction.dart';
import '../theme/fox_theme.dart';

/// The states every Banner use case and golden shows (R3).
const bannerStates = [
  'danger',
  'caution',
  'warning',
  'info',
  'neutral',
  'action',
];

/// The states every BannerStack use case and golden shows (R3).
const bannerStackStates = ['one', 'two', 'more', 'expanded'];

/// The tones the specs name (RA §6.3, CA §6.3): red, yellow (caution), amber
/// (warning), blue (info) and grey (neutral).
enum FoxBannerTone { danger, caution, warning, info, neutral }

/// A full-width bar under the top bar (D.10): the tone's icon, the words and
/// an optional action at the end. Red is solid, the other tones tinted
/// (owner, 2026-11-24); every tone has its icon and words, never colour
/// alone. Read as a live region: an alert for red, a status otherwise.
class FoxBanner extends StatelessWidget {
  const FoxBanner({
    super.key,
    required this.tone,
    required this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  final FoxBannerTone tone;
  final String message;

  /// Another icon than the tone's (`offline` for no connection).
  final t.FoxIconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final c = theme.colors;
    final (fill, ink, toneIcon) = switch (tone) {
      FoxBannerTone.danger => (c.danger, c.onDanger, t.FoxIcons.error),
      FoxBannerTone.caution => (c.cautionSubtle, c.caution, t.FoxIcons.warning),
      FoxBannerTone.warning => (c.warningSubtle, c.warning, t.FoxIcons.warning),
      FoxBannerTone.info => (c.infoSubtle, c.info, t.FoxIcons.info),
      FoxBannerTone.neutral => (c.neutralSubtle, c.neutral, t.FoxIcons.info),
    };
    final actionLabel = this.actionLabel;
    final style = theme.text.secondary.copyWith(
      color: ink,
      fontWeight: FontWeight.w500,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: fill,
        border: tone == FoxBannerTone.danger
            ? null
            : Border(bottom: BorderSide(color: c.border)),
      ),
      child: Semantics(
        container: true,
        liveRegion: true,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: t.FoxSize.touchTarget),
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: t.FoxSpace.md,
              vertical: t.FoxSpace.xxs,
            ),
            child: Row(
              children: [
                FoxIcon(icon ?? toneIcon, color: ink),
                const SizedBox(width: t.FoxSpace.sm),
                Expanded(child: Text(message, style: style)),
                if (actionLabel != null)
                  Flexible(
                    child: _BannerAction(
                      label: actionLabel,
                      onTap: onAction,
                      style: style.copyWith(
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                        decorationColor: ink,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BannerAction extends StatelessWidget {
  const _BannerAction({
    required this.label,
    required this.onTap,
    required this.style,
  });

  final String label;
  final VoidCallback? onTap;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    return Interaction(
      onTap: onTap,
      label: label,
      isButton: true,
      builder: (context, state) => Container(
        constraints: const BoxConstraints(minHeight: t.FoxSize.touchTarget),
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: t.FoxSpace.xs,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(t.FoxRadius.sm),
          border: state.focused
              ? Border.all(
                  color: style.color ?? theme.colors.focusRing,
                  width: theme.input.focusWidth,
                )
              : null,
        ),
        child: Align(
          widthFactor: 1,
          heightFactor: 1,
          child: Text(label, style: style),
        ),
      ),
    );
  }
}

/// The banners of a screen in the app's priority order (RA §6.3, CA §6.3,
/// CU §6.2): the first two show, the rest wait behind a counter that opens
/// them in place; [lessLabel] folds them again.
class FoxBannerStack extends StatefulWidget {
  const FoxBannerStack({
    super.key,
    required this.banners,
    required this.moreLabel,
    required this.lessLabel,
    this.initiallyExpanded = false,
  });

  final List<FoxBanner> banners;

  /// «+3 تنبيهات أخرى» for the number hidden.
  final String Function(int hidden) moreLabel;
  final String lessLabel;
  final bool initiallyExpanded;

  @override
  State<FoxBannerStack> createState() => _FoxBannerStackState();
}

class _FoxBannerStackState extends State<FoxBannerStack> {
  late bool _expanded = widget.initiallyExpanded;

  static const _shown = 2;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final c = theme.colors;
    final banners = widget.banners;
    final hidden = banners.length - _shown;
    final visible = _expanded || hidden <= 0
        ? banners
        : banners.take(_shown).toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...visible,
        if (hidden > 0)
          ColoredBox(
            color: c.surface,
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: t.FoxSpace.sm,
                vertical: t.FoxSpace.xxs,
              ),
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: _Counter(
                  label: _expanded
                      ? widget.lessLabel
                      : widget.moreLabel(hidden),
                  expanded: _expanded,
                  onTap: () => setState(() => _expanded = !_expanded),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Counter extends StatelessWidget {
  const _Counter({
    required this.label,
    required this.expanded,
    required this.onTap,
  });

  final String label;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final c = theme.colors;
    return Interaction(
      onTap: onTap,
      label: label,
      isButton: true,
      expanded: expanded,
      builder: (context, state) => AnimatedContainer(
        duration: t.FoxDuration.base,
        curve: theme.easing,
        constraints: const BoxConstraints(minHeight: t.FoxSize.touchTarget),
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: t.FoxSpace.sm,
        ),
        decoration: BoxDecoration(
          color: state.pressed
              ? c.surfaceRaisedPressed
              : (state.hovered ? c.surfaceRaisedHover : c.surfaceRaised),
          borderRadius: BorderRadius.circular(t.FoxRadius.full),
          border: Border.all(
            color: state.focused ? c.focusRing : c.border,
            width: state.focused ? theme.input.focusWidth : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                label,
                style: theme.text.secondary.copyWith(
                  color: c.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: t.FoxSpace.xxs),
            RotatedBox(
              quarterTurns: expanded ? 2 : 0,
              child: FoxIcon(
                t.FoxIcons.chevronDown,
                size: FoxIconSize.sm,
                color: c.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
