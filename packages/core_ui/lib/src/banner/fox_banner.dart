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
  'dismissible',
  'paired',
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
    this.actionIcon,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.secondaryActionIcon,
    this.dismissLabel,
    this.onDismiss,
  }) : assert(
         (dismissLabel == null) == (onDismiss == null),
         'A close control needs its name and its callback.',
       );

  final FoxBannerTone tone;
  final String message;

  /// Another icon than the tone's (`offline` for no connection).
  final t.FoxIconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  /// An icon before the action's words when it names a channel (`phone`).
  final t.FoxIconData? actionIcon;

  /// A second way out, such as WhatsApp beside a call: with two actions both
  /// take their own line under the words, as on the web.
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;
  final t.FoxIconData? secondaryActionIcon;

  /// A banner the user may put away for now (an update on offer): its close
  /// control's name («إغلاق») and what closing does.
  final String? dismissLabel;
  final VoidCallback? onDismiss;

  /// The key of the close control, for tests.
  static const dismissKey = ValueKey('FoxBanner.dismiss');

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final banner = theme.components.banner;
    final (fillValue, inkValue, toneIcon) = switch (tone) {
      FoxBannerTone.danger => (
        banner.colorDangerBackground,
        banner.colorDangerText,
        t.FoxIcons.error,
      ),
      FoxBannerTone.caution => (
        banner.colorCautionBackground,
        banner.colorCautionText,
        t.FoxIcons.warning,
      ),
      FoxBannerTone.warning => (
        banner.colorWarningBackground,
        banner.colorWarningText,
        t.FoxIcons.warning,
      ),
      FoxBannerTone.info => (
        banner.colorInfoBackground,
        banner.colorInfoText,
        t.FoxIcons.info,
      ),
      FoxBannerTone.neutral => (
        banner.colorNeutralBackground,
        banner.colorNeutralText,
        t.FoxIcons.info,
      ),
    };
    final fill = Color(fillValue);
    final ink = Color(inkValue);
    final style = theme.text.secondary.copyWith(
      color: ink,
      fontWeight: FontWeight.w500,
    );
    final actionStyle = style.copyWith(
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
      decorationColor: ink,
    );
    final actions = [
      if (actionLabel case final label?)
        _BannerAction(
          label: label,
          icon: actionIcon,
          onTap: onAction,
          style: actionStyle,
        ),
      if (secondaryActionLabel case final label?)
        _BannerAction(
          label: label,
          icon: secondaryActionIcon,
          onTap: onSecondaryAction,
          style: actionStyle,
        ),
    ];
    final stacked = actions.length > 1;
    final dismissLabel = this.dismissLabel;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: fill,
        border: tone == FoxBannerTone.danger
            ? null
            : Border(
                bottom: BorderSide(
                  color: Color(banner.colorBorder),
                  width: banner.borderWidth,
                ),
              ),
      ),
      child: Semantics(
        container: true,
        liveRegion: true,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: banner.minHeight),
          child: Padding(
            // xs above and below, the web's (parity, D.W3c; it was 2xs).
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: banner.paddingInline,
              vertical: banner.paddingBlock,
            ),
            child: Row(
              crossAxisAlignment: stacked
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                FoxIcon(icon ?? toneIcon, color: ink),
                SizedBox(width: banner.gap),
                if (stacked)
                  Expanded(
                    // As tall as its words and actions: it filled a tall
                    // parent before (parity, D.W3c).
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(message, style: style),
                        Wrap(spacing: banner.actionsGap, children: actions),
                      ],
                    ),
                  )
                else ...[
                  Expanded(child: Text(message, style: style)),
                  for (final action in actions) Flexible(child: action),
                ],
                if (dismissLabel != null)
                  _Dismiss(label: dismissLabel, ink: ink, onTap: onDismiss!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The close control: a 48 target with no fill of its own, so it reads as
/// part of the bar in every tone.
class _Dismiss extends StatelessWidget {
  const _Dismiss({required this.label, required this.ink, required this.onTap});

  final String label;
  final Color ink;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    return Interaction(
      onTap: onTap,
      label: label,
      isButton: true,
      builder: (context, state) => Container(
        key: FoxBanner.dismissKey,
        width: t.FoxSize.touchTarget,
        height: t.FoxSize.touchTarget,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: state.focused
              ? Border.all(color: ink, width: theme.input.focusWidth)
              : null,
        ),
        alignment: Alignment.center,
        child: FoxIcon(t.FoxIcons.close, color: ink),
      ),
    );
  }
}

class _BannerAction extends StatelessWidget {
  const _BannerAction({
    required this.label,
    required this.onTap,
    required this.style,
    this.icon,
  });

  final String label;
  final VoidCallback? onTap;
  final TextStyle style;
  final t.FoxIconData? icon;

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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon case final icon?) ...[
                FoxIcon(icon, size: FoxIconSize.sm, color: style.color),
                const SizedBox(width: t.FoxSpace.xxs),
              ],
              Flexible(child: Text(label, style: style)),
            ],
          ),
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
    final banner = theme.components.banner;
    // Folded: a raised pill with its outline; opened: words alone, a tint on
    // hover (the web's, parity D.W3c). The pill is drawn 32 high inside its
    // 48 target.
    return Interaction(
      onTap: onTap,
      label: label,
      isButton: true,
      expanded: expanded,
      builder: (context, state) => ConstrainedBox(
        constraints: const BoxConstraints(minHeight: t.FoxSize.touchTarget),
        child: Align(
          widthFactor: 1,
          heightFactor: 1,
          child: AnimatedContainer(
            duration: t.FoxDuration.base,
            curve: theme.easing,
            constraints: BoxConstraints(minHeight: banner.stackToggleHeight),
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: banner.stackTogglePaddingInline,
            ),
            decoration: BoxDecoration(
              color: expanded
                  ? (state.hovered || state.pressed
                        ? c.surfaceHover
                        : c.surface.withValues(alpha: 0))
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
                  : (expanded
                        ? null
                        : Border.all(
                            color: c.border,
                            width: banner.borderWidth,
                          )),
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
        ),
      ),
    );
  }
}
