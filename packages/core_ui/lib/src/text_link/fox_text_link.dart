import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';

import '../internal/interaction.dart';
import '../theme/fox_theme.dart';

/// The states every TextLink use case and golden shows (R3).
const textLinkStates = ['default', 'hover', 'pressed', 'focus'];

/// Underlined words that act: «ليس الآن», «تعديل الرقم», «الشروط» (D.11's
/// screens). Primary ink, its hover and pressed tokens (R10), read as a
/// link. The 48 target is around the words: they keep their place and size.
class FoxTextLink extends StatelessWidget {
  const FoxTextLink({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Interaction(
    onTap: onPressed,
    label: label,
    isLink: true,
    // Never disabled: read as the web's link.
    enabledState: false,
    builder: (context, state) {
      final theme = FoxTheme.of(context);
      final c = theme.colors;
      final hovered = state.hovered;
      final pressed = state.pressed;
      final focused = state.focused;
      final ink = pressed
          ? c.primaryPressed
          : (hovered ? c.primaryHover : c.primary);
      return ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: t.FoxSize.touchTarget,
          minHeight: t.FoxSize.touchTarget,
        ),
        child: Align(
          widthFactor: 1,
          heightFactor: 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(t.FoxRadius.xs),
              border: focused
                  ? Border.all(
                      color: c.focusRing,
                      width: theme.input.focusWidth,
                    )
                  : null,
            ),
            child: Text(
              label,
              style: theme.text.secondary.copyWith(
                color: ink,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
                decorationColor: ink,
              ),
            ),
          ),
        ),
      );
    },
  );
}
