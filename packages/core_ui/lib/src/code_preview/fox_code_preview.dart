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
    final codePreview = theme.components.codePreview;
    return Semantics(
      container: true,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Color(codePreview.colorAvatar),
                shape: BoxShape.circle,
              ),
              child: SizedBox.square(
                dimension: codePreview.avatarSize,
                child: Center(
                  // The mark's share of the circle, as drawn.
                  child: BrandMark(
                    size: codePreview.avatarSize * codePreview.markScale,
                    onPrimary: true,
                  ),
                ),
              ),
            ),
            SizedBox(width: codePreview.gap),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(codePreview.colorBubble),
                  borderRadius: BorderRadiusDirectional.only(
                    topStart: Radius.circular(codePreview.bubbleRadius),
                    topEnd: Radius.circular(codePreview.bubbleRadius),
                    bottomEnd: Radius.circular(codePreview.bubbleRadius),
                    bottomStart: Radius.circular(codePreview.bubbleRadiusTail),
                  ).resolve(Directionality.of(context)),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: codePreview.bubblePaddingInline,
                    vertical: codePreview.bubblePaddingBlock,
                  ),
                  // As tall as its lines: in a bounded parent it filled it
                  // (the parity sheet, D.W4a).
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!compact) ...[
                        Text(
                          sender,
                          style: theme.text.caption.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: codePreview.lineGap),
                      ],
                      Text.rich(
                        TextSpan(
                          text: '$message ',
                          children: [
                            TextSpan(
                              text: mask,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(codePreview.colorCode),
                              ),
                            ),
                          ],
                        ),
                        style: theme.text.secondary,
                      ),
                      SizedBox(height: codePreview.lineGap),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Text(
                          time,
                          style: theme.text.caption.copyWith(
                            color: Color(codePreview.colorTime),
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
