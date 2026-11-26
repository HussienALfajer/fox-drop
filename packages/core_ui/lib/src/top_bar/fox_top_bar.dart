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
    final topBar = theme.components.topBar;
    final backLabel = this.backLabel;
    final onBack = this.onBack;
    final end = this.end;
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: topBar.minHeight),
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: topBar.paddingInline,
          vertical: topBar.paddingBlock,
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
              SizedBox(width: topBar.titleGap),
            ],
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  title,
                  style: theme.text.title.copyWith(
                    color: Color(topBar.colorTitle),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            if (end != null) ...[SizedBox(width: topBar.titleGap), end],
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
    final restaurantBar = theme.components.restaurantBar;
    final dot = Color(
      connected ? restaurantBar.colorConnected : restaurantBar.colorOffline,
    );
    final gap = SizedBox(width: restaurantBar.gap);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Color(restaurantBar.colorBackground),
        border: Border(
          bottom: BorderSide(
            color: Color(restaurantBar.colorBorder),
            width: restaurantBar.borderWidth,
          ),
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: restaurantBar.minHeight),
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: restaurantBar.paddingInline,
            vertical: restaurantBar.paddingBlock,
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
                            color: Color(restaurantBar.colorName),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    gap,
                    status,
                    gap,
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: restaurantBar.dotSize,
                            height: restaurantBar.dotSize,
                            decoration: BoxDecoration(
                              color: dot,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: restaurantBar.dotGap),
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
              gap,
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
