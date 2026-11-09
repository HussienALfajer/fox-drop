import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../media_image.dart';
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
              onPressed: () => _orderWithout(context, ref, unavailable),
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

  /// Rebuilds the cart without the unavailable items, after asking when the
  /// cart is not empty (CU §11.9, §12.3), then opens it.
  Future<void> _orderWithout(
    BuildContext context,
    WidgetRef ref,
    Set<String> unavailable,
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
      result = await again.run(order, unavailable);
    } on Object {
      messenger.showSnackBar(SnackBar(content: Text(l10n.statusError)));
      return;
    }
    if (result is RestaurantGone) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.statusError)));
      return;
    }
    if (result.skipped.isNotEmpty) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.customerNotAdded(result.skipped.join('، '))),
        ),
      );
    }
    if (result is CartRebuilt) router.push('/cart');
  }
}
