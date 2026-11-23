import 'package:flutter/widgets.dart';

/// The text scale from which a row's end slot (an amount, a chip) moves under
/// its text instead of beside it, so the text keeps its width (D.9; the
/// approved sheet wraps them at 130%, the rows still fit side by side there).
const _stackFrom = 1.5;

/// Whether the system text is large enough to stack a row's parts.
bool foxLargeText(BuildContext context) =>
    MediaQuery.textScalerOf(context).scale(1) >= _stackFrom;
