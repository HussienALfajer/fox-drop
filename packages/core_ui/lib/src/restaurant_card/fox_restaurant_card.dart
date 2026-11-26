import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';

import '../card/fox_card.dart';
import '../icon/fox_icon.dart';
import '../internal/interaction.dart';
import '../order_card/fox_order_card.dart';
import '../theme/fox_theme.dart';

/// The states every RestaurantCard use case and golden shows (R3).
const restaurantCardStates = ['default', 'busy', 'closed', 'noCover'];

/// A restaurant in a customer list (CU §8.2): the cover 16:9 with the heart
/// and the state badge on it, the logo and name, the categories, the rating
/// or «جديد», the estimate and the fee. A closed restaurant fades (U6). No
/// cover shows the logo on a tint; no logo, the first letter (brand
/// expression §5).
class FoxRestaurantCard extends StatelessWidget {
  const FoxRestaurantCard({
    super.key,
    required this.name,
    required this.categories,
    required this.eta,
    required this.fee,
    required this.favourite,
    required this.favouriteLabel,
    required this.onFavourite,
    this.cover,
    this.logo,
    this.rating,
    this.newLabel,
    this.state,
    this.closed = false,
    this.onPressed,
  });

  final String name;
  final String categories;

  /// The estimate as a range: «20–30 د».
  final String eta;

  /// A [FoxMoney], or the words «توصيل مجاني».
  final Widget fee;
  final bool favourite;

  /// The heart's name: «المفضلة».
  final String favouriteLabel;
  final VoidCallback onFavourite;
  final ImageProvider? cover;
  final ImageProvider? logo;

  /// «4.5», or null for a new restaurant with [newLabel] («جديد»).
  final String? rating;
  final String? newLabel;

  /// «مشغول», «مغلق — يفتح السبت 10:00 ص»: a [FoxStatusChip].
  final Widget? state;
  final bool closed;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final c = theme.colors;
    final restaurantCard = theme.components.restaurantCard;
    final muted = theme.text.secondary.copyWith(color: c.onSurfaceMuted);
    final cover = this.cover;
    final state = this.state;
    final rating = this.rating;
    final newLabel = this.newLabel;
    final picture = ClipRRect(
      borderRadius: BorderRadius.circular(restaurantCard.coverRadius),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: cover != null
            ? Image(image: cover, fit: BoxFit.cover)
            : ColoredBox(
                color: Color(restaurantCard.colorCover),
                child: Center(
                  child: FoxLogo(
                    name: name,
                    image: logo,
                    size: restaurantCard.logoSize,
                  ),
                ),
              ),
      ),
    );
    final heart = Interaction(
      onTap: onFavourite,
      isButton: true,
      label: favouriteLabel,
      toggled: favourite,
      builder: (context, s) => SizedBox.square(
        dimension: t.FoxSize.touchTarget,
        child: Center(
          child: Container(
            width: restaurantCard.heartSize,
            height: restaurantCard.heartSize,
            decoration: BoxDecoration(
              color: Color(
                s.pressed
                    ? restaurantCard.colorHeartBackgroundPressed
                    : s.hovered
                    ? restaurantCard.colorHeartBackgroundHover
                    : restaurantCard.colorHeartBackground,
              ),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            // A favourite is a Bold red heart, not colour alone (R4; the
            // Madar sheet, §9.4).
            child: FoxIcon(
              t.FoxIcons.heart,
              color: Color(
                favourite
                    ? restaurantCard.colorHeartFavourite
                    : restaurantCard.colorHeart,
              ),
              style: favourite ? FoxIconStyle.bold : FoxIconStyle.linear,
            ),
          ),
        ),
      ),
    );
    final facts = Wrap(
      spacing: restaurantCard.factsGap,
      runSpacing: restaurantCard.factsRowGap,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (rating != null)
          _Fact(
            icon: t.FoxIcons.star,
            iconColor: Color(restaurantCard.colorRating),
            child: Text(rating, style: muted.copyWith(color: c.onSurface)),
          )
        else if (newLabel != null)
          Text(
            newLabel,
            style: muted.copyWith(
              color: Color(restaurantCard.colorNew),
              fontWeight: FontWeight.w500,
            ),
          ),
        _Fact(
          icon: t.FoxIcons.clock,
          iconColor: c.onSurfaceMuted,
          child: Text(eta, style: muted),
        ),
        _Fact(
          icon: t.FoxIcons.motorcycle,
          iconColor: c.onSurfaceMuted,
          child: fee,
        ),
      ],
    );
    // U6: a closed card fades, but its state chip and the heart keep their
    // full contrast, so «مغلق — يفتح …» still reads (owner, 2026-11-24).
    Widget fade(Widget child) => Opacity(
      opacity: closed ? restaurantCard.fadedOpacity : 1,
      child: child,
    );
    return FoxCard(
      elevation: FoxCardElevation.offset,
      onPressed: onPressed,
      semanticLabel: name,
      keepsInnerSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              fade(picture),
              PositionedDirectional(
                top: restaurantCard.heartInset,
                start: restaurantCard.heartInset,
                child: heart,
              ),
              if (state != null)
                PositionedDirectional(
                  top: restaurantCard.stateInset,
                  end: restaurantCard.stateInset,
                  start: t.FoxSize.touchTarget + restaurantCard.stateInset,
                  child: Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: state,
                  ),
                ),
            ],
          ),
          SizedBox(height: restaurantCard.gap),
          fade(
            Row(
              children: [
                if (cover != null) ...[
                  FoxLogo(name: name, image: logo),
                  SizedBox(width: restaurantCard.gap),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: theme.text.subtitle.copyWith(
                          color: c.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(categories, style: muted),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: restaurantCard.factsTop),
          fade(facts),
        ],
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({
    required this.icon,
    required this.iconColor,
    required this.child,
  });

  final t.FoxIconData icon;
  final Color iconColor;
  final Widget child;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      FoxIcon(icon, size: FoxIconSize.sm, color: iconColor),
      SizedBox(width: FoxTheme.of(context).components.restaurantCard.factGap),
      Flexible(child: child),
    ],
  );
}
