import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';

import '../button/fox_button.dart';
import '../card/fox_card.dart';
import '../icon/fox_icon.dart';
import '../internal/large_text.dart';
import '../theme/fox_theme.dart';

/// The states every OrderCard use case and golden shows (R3), as the web's.
const orderCardStates = ['default', 'preparing', 'late', 'readOnly'];

/// The states of the customer's order row.
const orderRowStates = ['active', 'past', 'cancelled'];

/// The states of a restaurant's logo: its image is the app's, so the
/// catalogue shows the letter that stands in for a missing one.
const logoStates = ['letter'];

/// The one main button of a board card: «قبول», «الطلب جاهز», «تأكيد الاستلام».
@immutable
final class FoxOrderAction {
  const FoxOrderAction(this.label, this.onPressed);

  final String label;
  final VoidCallback onPressed;
}

/// The compact card of the restaurant's orders board (RA §8.2): the number
/// and time since placed, the column's timer, the items, the captain line,
/// badges and one main button; red when late.
class FoxOrderCard extends StatelessWidget {
  const FoxOrderCard({
    super.key,
    required this.number,
    required this.since,
    required this.items,
    required this.captain,
    required this.timer,
    this.badges = const [],
    this.action,
    this.late = false,
    this.lateLabel,
    this.onPressed,
  });

  /// Without its «#»: «10423».
  final String number;
  final String since;
  final String items;

  /// The captain line of RA §8.1.
  final String captain;

  /// A [FoxTimer].
  final Widget timer;

  /// RA §8.4's badges, such as a [FoxStatusChip].
  final List<Widget> badges;
  final FoxOrderAction? action;
  final bool late;

  /// «متأخر», said to screen readers when [late].
  final String? lateLabel;

  /// Opens the order detail.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final muted = theme.text.secondary.copyWith(
      color: theme.colors.onSurfaceMuted,
    );
    final action = this.action;
    final lateLabel = this.lateLabel;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: t.FoxSpace.xs,
          runSpacing: t.FoxSpace.xs,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.spaceBetween,
          children: [
            Wrap(
              spacing: t.FoxSpace.xs,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                Text(
                  '#$number',
                  style: theme.text.title.copyWith(
                    color: theme.colors.onSurface,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                Text(since, style: muted),
              ],
            ),
            timer,
          ],
        ),
        const SizedBox(height: t.FoxSpace.xs),
        Text(
          items,
          style: theme.text.body.copyWith(color: theme.colors.onSurface),
        ),
        const SizedBox(height: t.FoxSpace.xxs),
        Row(
          children: [
            FoxIcon(
              t.FoxIcons.motorcycle,
              size: FoxIconSize.sm,
              color: theme.colors.onSurfaceMuted,
            ),
            const SizedBox(width: t.FoxSpace.xxs),
            Expanded(child: Text(captain, style: muted)),
          ],
        ),
        if (badges.isNotEmpty) ...[
          const SizedBox(height: t.FoxSpace.xs),
          Wrap(
            spacing: t.FoxSpace.xs,
            runSpacing: t.FoxSpace.xs,
            children: badges,
          ),
        ],
        if (action != null) ...[
          const SizedBox(height: t.FoxSpace.sm),
          FoxButton(label: action.label, onPressed: action.onPressed),
        ],
      ],
    );
    return FoxCard(
      tone: late ? FoxCardTone.danger : FoxCardTone.normal,
      onPressed: onPressed,
      semanticLabel: '#$number',
      // The items, timer, badges and the main button stay readable and
      // reachable inside the pressable card (review of D.9).
      keepsInnerSemantics: true,
      child: Semantics(
        container: true,
        label: late && lateLabel != null ? lateLabel : null,
        child: content,
      ),
    );
  }
}

/// One order in the customer's «طلباتي» (CU §12.3): the restaurant, the date,
/// the status and the total, on the customer's offset card.
class FoxOrderRow extends StatelessWidget {
  const FoxOrderRow({
    super.key,
    required this.restaurant,
    required this.date,
    required this.status,
    required this.total,
    this.logo,
    this.trailing,
    this.onPressed,
  });

  final String restaurant;
  final String date;

  /// A [FoxStatusChip] with the customer's wording.
  final Widget status;

  /// A [FoxMoney].
  final Widget total;

  /// The restaurant's logo; without it, its first letter.
  final ImageProvider? logo;

  /// «اطلب مرة أخرى» on a past order.
  final Widget? trailing;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final trailing = this.trailing;
    final stacked = foxLargeText(context);
    return FoxCard(
      elevation: FoxCardElevation.offset,
      onPressed: onPressed,
      semanticLabel: '$restaurant، $date',
      keepsInnerSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              FoxLogo(name: restaurant, image: logo),
              const SizedBox(width: t.FoxSpace.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant,
                      style: theme.text.subtitle.copyWith(
                        color: theme.colors.onSurface,
                      ),
                    ),
                    Text(
                      date,
                      style: theme.text.secondary.copyWith(
                        color: theme.colors.onSurfaceMuted,
                      ),
                    ),
                    if (stacked) total,
                  ],
                ),
              ),
              if (!stacked) ...[const SizedBox(width: t.FoxSpace.xs), total],
            ],
          ),
          const SizedBox(height: t.FoxSpace.sm),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: t.FoxSpace.xs,
            runSpacing: t.FoxSpace.xs,
            children: [status, ?trailing],
          ),
        ],
      ),
    );
  }
}

/// A restaurant's logo in a rounded square, or the first letter of its name
/// on a tint when it has none (brand expression §5: never a drop, never a
/// fake image).
class FoxLogo extends StatelessWidget {
  const FoxLogo({
    super.key,
    required this.name,
    this.image,
    this.size = t.FoxSize.touchTarget,
  });

  final String name;
  final ImageProvider? image;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final image = this.image;
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        clipBehavior: Clip.antiAlias,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: theme.colors.primarySubtle,
          borderRadius: BorderRadius.circular(t.FoxRadius.md),
        ),
        child: image != null
            ? Image(image: image, fit: BoxFit.cover, width: size, height: size)
            : Text(
                name.isEmpty ? '' : name.characters.first,
                style: theme.text.title.copyWith(
                  color: theme.colors.onPrimarySubtle,
                ),
              ),
      ),
    );
  }
}
