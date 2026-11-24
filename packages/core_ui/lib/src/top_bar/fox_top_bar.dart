import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';

import '../button/fox_button.dart';
import '../theme/fox_theme.dart';

/// The states every TopBar use case and golden shows (R3).
const topBarStates = ['default', 'end-action', 'no-back'];

/// The states every RestaurantBar use case and golden shows (R3).
const restaurantBarStates = ['connected', 'offline'];

/// The phone apps' bar (D.10): the Figma file's round back button, the
/// title in the heading colour (a header for screen readers) and an
/// optional action at the end. 64 high, on the screen's ground.
class FoxTopBar extends StatelessWidget {
  const FoxTopBar({
    super.key,
    required this.title,
    this.backLabel,
    this.onBack,
    this.end,
  });

  final String title;

  /// The back button's name; with [onBack] it shows the button.
  final String? backLabel;
  final VoidCallback? onBack;
  final Widget? end;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final backLabel = this.backLabel;
    final onBack = this.onBack;
    final end = this.end;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: t.FoxSize.bar),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: t.FoxSpace.md,
          vertical: t.FoxSpace.xs,
        ),
        child: Row(
          children: [
            if (backLabel != null && onBack != null) ...[
              FoxButton.icon(
                icon: t.FoxIcons.back,
                label: backLabel,
                variant: FoxButtonVariant.secondary,
                onPressed: onBack,
              ),
              const SizedBox(width: t.FoxSpace.sm),
            ],
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  title,
                  style: theme.text.title.copyWith(
                    color: theme.colors.heading,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            if (end != null) ...[const SizedBox(width: t.FoxSpace.sm), end],
          ],
        ),
      ),
    );
  }
}

/// The restaurant app's bar on every screen (RA §6.2): the restaurant's
/// name, its status pill (the app opens the status sheet from it), the
/// connection dot with its words beside it, and the support button.
class FoxRestaurantBar extends StatelessWidget {
  const FoxRestaurantBar({
    super.key,
    required this.name,
    required this.status,
    required this.connected,
    required this.connectionLabel,
    required this.supportLabel,
    required this.onSupport,
  });

  final String name;

  /// The status pill, pressable, given by the app.
  final Widget status;
  final bool connected;

  /// «متصل» or «غير متصل»: shown beside the dot, never colour alone.
  final String connectionLabel;
  final String supportLabel;
  final VoidCallback? onSupport;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final c = theme.colors;
    final dot = connected ? c.success : c.danger;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surfaceRaised,
        border: Border(bottom: BorderSide(color: c.border)),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: t.FoxSize.bar),
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: t.FoxSpace.md,
            vertical: t.FoxSpace.xxs,
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Semantics(
                        header: true,
                        child: Text(
                          name,
                          style: theme.text.subtitle.copyWith(
                            color: c.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: t.FoxSpace.sm),
                    status,
                    const SizedBox(width: t.FoxSpace.sm),
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: t.FoxSpace.sm,
                            height: t.FoxSpace.sm,
                            decoration: BoxDecoration(
                              color: dot,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: t.FoxSpace.xxs),
                          Flexible(
                            child: Text(
                              connectionLabel,
                              style: theme.text.caption.copyWith(
                                color: dot,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: t.FoxSpace.sm),
              FoxButton.icon(
                icon: t.FoxIcons.chat,
                label: supportLabel,
                variant: FoxButtonVariant.secondary,
                onPressed: onSupport,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
