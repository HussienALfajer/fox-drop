import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../media_image.dart';
import 'my_orders.dart';
import 'order_again.dart';
import 'order_live.dart';

/// CU §11.9 under a rejected or unanswered order: «اطلب بدون الأصناف غير
/// المتوفرة» for «صنف غير متوفر» (Q22), and the similar restaurants.
/// Unstyled until the design.
class OrderAgainSection extends ConsumerWidget {
  const OrderAgainSection({super.key, required this.order});

  final CustomerOrder order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final similarTo = similarToOf(order);
    if (similarTo == null) return const SizedBox.shrink();
    final unavailable = order.rejection?.unavailableItemIds.toSet() ?? {};
    final similar = ref.watch(similarRestaurantsProvider(similarTo));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Offered while some item of the order is left to order.
        if (unavailable.isNotEmpty &&
            order.lines.any((line) => !unavailable.contains(line.itemId)))
          Padding(
            padding: const EdgeInsetsDirectional.all(16),
            child: FilledButton(
              key: const Key('order-without-unavailable'),
              onPressed: () => rebuildCart(context, ref, order, unavailable),
              child: Text(l10n.customerOrderWithoutUnavailable),
            ),
          ),
        if (similar.value case final cards? when cards.isNotEmpty) ...[
          ListTile(title: Text(l10n.customerSimilarRestaurants)),
          for (final card in cards)
            ListTile(
              key: Key('similar-${card.id}'),
              leading: switch (card.logoKey) {
                final logo? => MediaImage(
                  imageKey: logo,
                  width: 56,
                  height: 56,
                  label: card.nameAr,
                ),
                null => null,
              },
              title: Text(card.nameAr),
              subtitle: Text(
                l10n.customerEstimate(
                  card.estimate.fromMin,
                  card.estimate.toMin,
                ),
              ),
              onTap: () => context.push('/restaurants/${card.id}'),
            ),
        ],
      ],
    );
  }
}

/// «اطلب مرة أخرى» on a delivered, rejected or cancelled order (CU §12.3,
/// U18): the cart rebuilt from the restaurant's current menu at current
/// prices, the notes copied, the code not.
class OrderAgainButton extends ConsumerWidget {
  const OrderAgainButton({super.key, required this.order});

  final CustomerOrder order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!canOrderAgain(
      order.status.name,
      redelivery: order.redeliveryOf != null,
    )) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsetsDirectional.all(16),
      child: OutlinedButton(
        key: const Key('order-again'),
        onPressed: () => rebuildCart(context, ref, order, const {}),
        child: Text(AppLocalizations.of(context).customerOrderAgain),
      ),
    );
  }
}

/// Rebuilds the cart from [order] without the items in [without], after
/// asking when the cart is not empty (CU §11.9, §12.3), names the lines it
/// skipped, then opens the cart. A restaurant customers no longer see
/// builds nothing.
Future<void> rebuildCart(
  BuildContext context,
  WidgetRef ref,
  CustomerOrder order,
  Set<String> without,
) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final router = GoRouter.of(context);
  final again = ref.read(orderAgainProvider);
  final current = await again.cartToReplace();
  if (current != null) {
    if (!context.mounted) return;
    final replace = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.customerReplaceCart(current)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.customerCancel),
          ),
          FilledButton(
            key: const Key('replace-cart'),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.customerContinue),
          ),
        ],
      ),
    );
    if (replace != true) return;
  }
  final OrderAgainResult result;
  try {
    result = await again.run(order, without);
  } on Object {
    messenger.showSnackBar(SnackBar(content: Text(l10n.statusError)));
    return;
  }
  if (result is RestaurantGone) {
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.customerRestaurantUnavailable)),
    );
    return;
  }
  if (result.skipped.isNotEmpty) {
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.customerNotAdded(result.skipped.join('، ')))),
    );
  }
  if (result is CartRebuilt) router.push('/cart');
}
