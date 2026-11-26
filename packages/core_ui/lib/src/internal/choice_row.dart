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
    final input = theme.components.input;
    // The 24 box sits in a 48 slot whose empty start half is pulled out, so
    // the box lines up with the form's edge while the target stays 48.
    final inset = (input.checkTarget - input.checkSize) / 2;
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: input.checkTarget),
      child: Row(
        children: [
          SizedBox(
            width: input.checkSize + inset,
            height: input.checkTarget,
            child: OverflowBox(
              alignment: AlignmentDirectional.centerEnd,
              minWidth: input.checkTarget,
              maxWidth: input.checkTarget,
              child: Center(child: box),
            ),
          ),
          // The slot ends where the 48 target ends: the label sits 4 after
          // it, as on the D.8 sheet and the web (parity, D.W3a; it was 16).
          SizedBox(width: input.checkGap),
          Expanded(
            child: Text(label, style: theme.text.body.copyWith(color: color)),
          ),
        ],
      ),
    );
  }
}
