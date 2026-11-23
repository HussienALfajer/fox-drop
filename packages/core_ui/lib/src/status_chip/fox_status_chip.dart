import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';

import '../icon/fox_icon.dart';
import '../theme/fox_theme.dart';
import 'fox_tone.dart';

/// The states every StatusChip use case and golden shows (R3), as the web's.
const statusChipStates = [
  'placed',
  'accepted',
  'ready',
  'pickedUp',
  'arrived',
  'delivered',
  'rejected',
  'cancelled',
  'failed',
  'tone',
  'compact',
];

/// AP §8.1's order states, with the tone and icon the approved sheet gives
/// each (owner, 2026-11-24): waiting amber, preparing blue, ready and
/// delivered green, with the captain orange, refused and failed red,
/// cancelled grey.
enum FoxOrderStatus {
  placed(FoxTone.warning, t.FoxIcons.clock),
  accepted(FoxTone.info, t.FoxIcons.restaurant),
  ready(FoxTone.success, t.FoxIcons.plate),
  pickedUp(FoxTone.primary, t.FoxIcons.motorcycle),
  arrived(FoxTone.primary, t.FoxIcons.house),
  delivered(FoxTone.success, t.FoxIcons.success),
  rejected(FoxTone.danger, t.FoxIcons.close),
  cancelled(FoxTone.neutral, t.FoxIcons.close),
  failed(FoxTone.danger, t.FoxIcons.warning);

  const FoxOrderStatus(this.tone, this.icon);

  final FoxTone tone;
  final t.FoxIconData icon;
}

/// An order state, or another state (a restaurant's «مشغول»), as an icon and
/// a word on its tint: never colour alone (R4).
class FoxStatusChip extends StatelessWidget {
  const FoxStatusChip({
    super.key,
    required this.label,
    this.status,
    this.tone,
    this.icon,
    this.compact = false,
  }) : assert(status != null || tone != null, 'Give a status or a tone.');

  /// The words of the app: «مع الكابتن», «في الطريق إليك».
  final String label;
  final FoxOrderStatus? status;
  final FoxTone? tone;
  final t.FoxIconData? icon;

  /// The panel's smaller chip (the web only uses it today).
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final look = status?.tone ?? tone!;
    final glyph = status?.icon ?? icon;
    final fg = look.strong(theme.colors);
    final style = (compact ? theme.text.caption : theme.text.secondary)
        .copyWith(color: fg, fontWeight: FontWeight.w500);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: look.subtle(theme.colors),
        borderRadius: BorderRadius.circular(t.FoxRadius.full),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: compact ? t.FoxSpace.xs : t.FoxSpace.sm,
          vertical: t.FoxSpace.xxs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (glyph != null) ...[
              FoxIcon(glyph, size: FoxIconSize.sm, color: fg),
              const SizedBox(width: t.FoxSpace.xxs),
            ],
            Flexible(child: Text(label, style: style)),
          ],
        ),
      ),
    );
  }
}
