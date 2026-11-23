import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';

import '../theme/fox_theme.dart';

/// The row of a checkbox or radio (D.8): the 24 [box] at the start with the
/// label beside it, the whole row at least 48 high and the target. Not
/// exported.
class ChoiceRow extends StatelessWidget {
  const ChoiceRow({
    super.key,
    required this.box,
    required this.label,
    required this.color,
  });

  final Widget box;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final i = theme.input;
    // The 24 box sits in a 48 slot whose empty start half is pulled out, so
    // the box lines up with the form's edge while the target stays 48.
    final inset = (i.checkTarget - i.checkSize) / 2;
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: i.checkTarget),
      child: Row(
        children: [
          SizedBox(
            width: i.checkSize + inset,
            height: i.checkTarget,
            child: OverflowBox(
              alignment: AlignmentDirectional.centerEnd,
              minWidth: i.checkTarget,
              maxWidth: i.checkTarget,
              child: Center(child: box),
            ),
          ),
          const SizedBox(width: t.FoxSpace.md),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                vertical: t.FoxSpace.sm,
              ),
              child: Text(label, style: theme.text.body.copyWith(color: color)),
            ),
          ),
        ],
      ),
    );
  }
}
