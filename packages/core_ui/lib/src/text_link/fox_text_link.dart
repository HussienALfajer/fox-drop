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
      final textLink = theme.components.textLink;
      final ink = Color(
        state.pressed
            ? textLink.colorTextPressed
            : (state.hovered ? textLink.colorTextHover : textLink.colorText),
      );
      // The keyboard ring goes round the 48 target, outside it, as the web
      // draws it (parity, D.W3a; it was a border tight on the words).
      return CustomPaint(
        foregroundPainter: state.focused
            ? FocusRing(
                ring: Color(textLink.colorFocusRing),
                gap: theme.colors.surface,
                radius: textLink.radius,
              )
            : null,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: textLink.target,
            minHeight: textLink.target,
          ),
          child: Align(
            widthFactor: 1,
            heightFactor: 1,
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
