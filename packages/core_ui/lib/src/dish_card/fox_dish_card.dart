import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';

import '../card/fox_card.dart';
import '../icon/fox_icon.dart';
import '../internal/faded.dart';
import '../internal/interaction.dart';
import '../theme/fox_theme.dart';

/// The states every DishCard use case and golden shows (R3).
const dishCardStates = ['default', 'from', 'inCart', 'noPhoto', 'unavailable'];

/// A dish in a restaurant's menu (CU §9.3), the approved option A: the name,
/// description and price at the start, a 1:1 photo, and «+» in the thumb's
/// reach, which becomes the count once the dish is in the cart. A dish
/// without a photo is a text row with no image slot (brand expression §5);
/// an unavailable dish stays in place, faded, with its reason.
class FoxDishCard extends StatelessWidget {
  const FoxDishCard({
    super.key,
    required this.name,
    required this.price,
    required this.addLabel,
    required this.onAdd,
    this.description,
    this.photo,
    this.fromLabel,
    this.count = 0,
    this.unavailableLabel,
    this.onPressed,
  });

  final String name;

  /// A [FoxMoney].
  final Widget price;

  /// «أضف {الطبق}»: the «+» button's name.
  final String addLabel;
  final VoidCallback onAdd;
  final String? description;
  final ImageProvider? photo;

  /// «من» before the lowest price, when a required group changes it.
  final String? fromLabel;

  /// How many are in the cart; above zero it replaces «+».
  final int count;

  /// «يتوفر غداً», «غير متوفر حالياً»: the dish cannot be added.
  final String? unavailableLabel;

  /// Opens the item sheet.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final c = theme.colors;
    final photo = this.photo;
    final description = this.description;
    final fromLabel = this.fromLabel;
    final unavailable = unavailableLabel;
    final muted = theme.text.secondary.copyWith(color: c.onSurfaceMuted);
    final add = Interaction(
      onTap: onAdd,
      isButton: true,
      label: addLabel,
      value: count > 0 ? '$count' : null,
      builder: (context, s) => SizedBox.square(
        dimension: t.FoxSize.touchTarget,
        child: Center(
          child: AnimatedContainer(
            duration: MediaQuery.disableAnimationsOf(context)
                ? Duration.zero
                : t.FoxDuration.base,
            width: t.FoxSize.touchTarget - t.FoxSpace.xs,
            height: t.FoxSize.touchTarget - t.FoxSpace.xs,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: count > 0
                  ? c.accent
                  : s.pressed
                  ? c.primaryPressed
                  : s.hovered
                  ? c.primaryHover
                  : c.primary,
              shape: BoxShape.circle,
            ),
            child: count > 0
                ? Text(
                    '$count',
                    textDirection: TextDirection.ltr,
                    style: theme.text.body.copyWith(
                      color: c.onAccent,
                      fontWeight: FontWeight.w700,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  )
                : FoxIcon(t.FoxIcons.add, color: c.onPrimary),
          ),
        ),
      ),
    );
    // An unavailable dish fades (U7), but its reason keeps full contrast.
    Widget fade(Widget child) => Opacity(
      opacity: unavailable != null ? foxFadedOpacity : 1,
      child: child,
    );
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        fade(
          Text(
            name,
            style: theme.text.subtitle.copyWith(
              color: c.heading,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (description != null) fade(Text(description, style: muted)),
        const SizedBox(height: t.FoxSpace.xs),
        Wrap(
          spacing: t.FoxSpace.xs,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (fromLabel != null)
              fade(Text(fromLabel, style: muted.copyWith(color: c.onSurface))),
            fade(price),
            if (unavailable != null)
              Text(
                unavailable,
                style: muted.copyWith(fontWeight: FontWeight.w500),
              ),
          ],
        ),
      ],
    );
    return FoxCard(
      onPressed: unavailable != null ? null : onPressed,
      semanticLabel: name,
      keepsInnerSemantics: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: text),
          if (photo != null) ...[
            const SizedBox(width: t.FoxSpace.sm),
            fade(
              ClipRRect(
                borderRadius: BorderRadius.circular(t.FoxRadius.md),
                child: SizedBox.square(
                  dimension: t.FoxSize.touchTarget * 2,
                  child: Image(image: photo, fit: BoxFit.cover),
                ),
              ),
            ),
          ],
          if (unavailable == null) ...[
            const SizedBox(width: t.FoxSpace.xs),
            add,
          ],
        ],
      ),
    );
  }
}
