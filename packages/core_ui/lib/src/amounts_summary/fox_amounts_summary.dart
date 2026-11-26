import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';

import '../money/fox_money.dart';
import '../status_chip/fox_tone.dart';
import '../theme/fox_theme.dart';

/// The states every AmountsSummary use case and golden shows (R3).
const amountsSummaryStates = ['default', 'prominent', 'free'];

/// `prominent` is the orange total bar of the Figma cart (the customer's cart
/// and checkout); `plain` a bold total under a rule everywhere else.
enum FoxAmountsVariant { plain, prominent }

/// One money line: a label and an amount in minor units, or [text] instead
/// («مجاني»).
@immutable
final class FoxAmountLine {
  const FoxAmountLine(this.label, this.amount, {this.text, this.tone});

  final String label;
  final String amount;
  final String? text;

  /// Success for a discount.
  final FoxTone? tone;
}

/// The money lines of an order and its total (CU §10.3 step 7, §12.3), with
/// one equivalent per accepted currency under it.
class FoxAmountsSummary extends StatelessWidget {
  const FoxAmountsSummary({
    super.key,
    required this.lines,
    required this.total,
    required this.symbol,
    this.decimals = 2,
    this.equivalents,
    this.variant = FoxAmountsVariant.plain,
  });

  final List<FoxAmountLine> lines;
  final FoxAmountLine total;
  final String symbol;
  final int decimals;
  final String? equivalents;
  final FoxAmountsVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final amountsSummary = theme.components.amountsSummary;
    final text = Color(amountsSummary.colorText);
    final body = theme.text.body.copyWith(color: text);
    final prominent = variant == FoxAmountsVariant.prominent;
    final onBar = Color(amountsSummary.prominentLabel);
    final equivalents = this.equivalents;
    final totalLabel = theme.text.subtitle.copyWith(
      color: prominent ? onBar : text,
      fontWeight: FontWeight.w700,
    );
    final totalAmount = FoxMoney(
      amount: total.amount,
      symbol: symbol,
      decimals: decimals,
      role: prominent ? FoxMoneyRole.subtitle : FoxMoneyRole.number,
      color: prominent ? onBar : null,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (i, line) in lines.indexed)
          CustomPaint(
            // The Figma cart parts its lines with dashed rules.
            foregroundPainter: i < lines.length - 1
                ? _DashedRule(
                    Color(amountsSummary.lineRule),
                    amountsSummary.lineRuleWidth,
                  )
                : null,
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(
                vertical: amountsSummary.linePaddingBlock,
              ),
              // A Wrap keeps the amount at the end, and puts it on its own
              // line when large text leaves no room beside the label.
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: amountsSummary.gap,
                children: [
                  Text(line.label, style: body),
                  line.text != null
                      ? Text(
                          line.text!,
                          style: body.copyWith(
                            color: Color(amountsSummary.lineFree),
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : FoxMoney(
                          amount: line.amount,
                          symbol: symbol,
                          decimals: decimals,
                          tone: line.tone,
                        ),
                ],
              ),
            ),
          ),
        SizedBox(height: amountsSummary.gap),
        Container(
          padding: prominent
              ? EdgeInsetsDirectional.symmetric(
                  horizontal: amountsSummary.prominentPaddingInline,
                  vertical: amountsSummary.prominentPaddingBlock,
                )
              : EdgeInsetsDirectional.only(top: amountsSummary.totalPaddingTop),
          decoration: prominent
              ? BoxDecoration(
                  color: Color(amountsSummary.prominentBackground),
                  borderRadius: BorderRadius.circular(
                    amountsSummary.prominentRadius,
                  ),
                )
              : BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color(amountsSummary.totalRule),
                      width: amountsSummary.totalRuleWidth,
                    ),
                  ),
                ),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: amountsSummary.gap,
            children: [
              Text(total.label, style: totalLabel),
              totalAmount,
            ],
          ),
        ),
        if (equivalents != null) ...[
          // One gap under the total, as the web's (D.W3b).
          SizedBox(height: amountsSummary.gap),
          Text(
            equivalents,
            style: theme.text.secondary.copyWith(
              color: Color(amountsSummary.colorEquivalents),
            ),
          ),
        ],
      ],
    );
  }
}

/// A dashed rule along the bottom edge.
class _DashedRule extends CustomPainter {
  _DashedRule(this.colour, this.width);

  final Color colour;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colour
      ..strokeWidth = width;
    final y = size.height - width / 2;
    const dash = t.FoxSpace.xxs;
    for (var x = 0.0; x < size.width; x += dash * 2) {
      canvas.drawLine(Offset(x, y), Offset(x + dash, y), paint);
    }
  }

  @override
  bool shouldRepaint(_DashedRule old) =>
      old.colour != colour || old.width != width;
}
