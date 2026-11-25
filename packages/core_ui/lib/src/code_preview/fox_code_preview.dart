import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';

import '../internal/brand_mark.dart';
import '../theme/fox_theme.dart';

/// The states every CodePreview use case and golden shows (R3).
const codePreviewStates = ['full', 'compact'];

/// What the WhatsApp message with the code will look like (D.11 screen 2):
/// the brand's round mark, a bubble with the sender, the real words with
/// the code masked, and the time. No WhatsApp logo or green: our tokens
/// only. Read once, as [semanticLabel]; [compact] (the keyboard up) drops
/// the sender line.
class FoxCodePreview extends StatelessWidget {
  const FoxCodePreview({
    super.key,
    required this.sender,
    required this.message,
    required this.time,
    required this.semanticLabel,
    this.compact = false,
  });

  /// «FOX DROP».
  final String sender;

  /// The words before the code: «رمز الدخول إلى FOX DROP:».
  final String message;

  /// «الآن · واتساب».
  final String time;
  final String semanticLabel;
  final bool compact;

  /// The code is never shown here: six dots in its place.
  static const mask = '••••••';

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final c = theme.colors;
    return Semantics(
      container: true,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: c.primary,
                shape: BoxShape.circle,
              ),
              child: const SizedBox.square(
                dimension: t.FoxSize.iconLg,
                child: Center(
                  // The mark at 62% of the circle, as drawn.
                  child: BrandMark(
                    size: t.FoxSize.iconLg * 0.62,
                    onPrimary: true,
                  ),
                ),
              ),
            ),
            const SizedBox(width: t.FoxSpace.xs),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: c.infoSubtle,
                  borderRadius: const BorderRadiusDirectional.only(
                    topStart: Radius.circular(t.FoxRadius.lg),
                    topEnd: Radius.circular(t.FoxRadius.lg),
                    bottomEnd: Radius.circular(t.FoxRadius.lg),
                    bottomStart: Radius.circular(t.FoxRadius.xs),
                  ).resolve(Directionality.of(context)),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: t.FoxSpace.sm,
                    vertical: t.FoxSpace.xs,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!compact) ...[
                        Text(
                          sender,
                          style: theme.text.caption.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: t.FoxSpace.xxs),
                      ],
                      Text.rich(
                        TextSpan(
                          text: '$message ',
                          children: [
                            TextSpan(
                              text: mask,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: c.primaryPressed,
                              ),
                            ),
                          ],
                        ),
                        style: theme.text.secondary,
                      ),
                      const SizedBox(height: t.FoxSpace.xxs),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Text(
                          time,
                          style: theme.text.caption.copyWith(
                            color: c.onSurfaceMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
