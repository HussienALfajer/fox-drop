import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../browsing/browsing.dart';
import '../checkout/problems.dart';
import '../checkout/quote.dart';
import '../checkout/quote_widgets.dart';
import '../device.dart';
import 'cart.dart';
import 'item_sheet.dart';

/// The cart (CU §10.1, §10.2): each line with «−» and «+», «تعديل» and
/// «حذف», the changes since adding and the thresholds from the quote, then
/// «متابعة» to checkout, off below the minimum order (U9). Unstyled until
/// the design.
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(cartProvider).value;
    final cart = state?.cart;
    final quote = ref.watch(quoteProvider).value;
    final now = ref.watch(clockProvider)();
    final belowMinimum = quote != null && !quote.minimumOrder.reached;
    return Scaffold(
      appBar: AppBar(title: Text(cart?.restaurantName ?? l10n.customerCart)),
      body: state == null
          ? const Center(child: CircularProgressIndicator())
          : cart == null
          ? Center(
              child: Text(
                state.expired
                    ? l10n.customerCartExpired
                    : l10n.customerCartEmpty,
              ),
            )
          : ListView(
              children: [
                for (final (index, line) in cart.lines.indexed)
                  _LineTile(index: index, line: line, cart: cart),
                if (quote != null) ...[
                  for (final problem in problemViews(l10n, quote, cart, now))
                    ProblemTile(
                      problem: problem,
                      enabled: !ref.watch(quoteProvider).isLoading,
                    ),
                  Thresholds(quote: quote),
                ],
                Padding(
                  padding: const EdgeInsetsDirectional.all(16),
                  child: FilledButton(
                    key: const Key('cart-continue'),
                    onPressed: belowMinimum
                        ? null
                        : () => context.push('/checkout'),
                    child: Text(l10n.customerContinue),
                  ),
                ),
              ],
            ),
    );
  }
}

class _LineTile extends ConsumerWidget {
  const _LineTile({
    required this.index,
    required this.line,
    required this.cart,
  });

  final int index;
  final CartLine line;
  final Cart cart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(cartProvider.notifier);
    final page = ref.watch(restaurantPageProvider(cart.restaurantId)).value;
    final item = page?.menu
        .expand((category) => category.items)
        .where((item) => item.id == line.itemId)
        .firstOrNull;
    return Column(
      key: Key('cart-line-$index'),
      children: [
        ListTile(
          title: Text(line.name),
          subtitle: Text(
            [
              if (line.optionNames.isNotEmpty) line.optionNames.join('، '),
              ?line.note,
              l10n.formatMoney(line.lineTotal, line.currency),
            ].join('\n'),
          ),
        ),
        Row(
          children: [
            IconButton(
              key: Key('cart-less-$index'),
              onPressed: () => controller.setQuantity(index, line.quantity - 1),
              icon: const Icon(Icons.remove),
            ),
            Text('${line.quantity}'),
            IconButton(
              key: Key('cart-more-$index'),
              onPressed: line.quantity < maxQuantity
                  ? () => controller.setQuantity(index, line.quantity + 1)
                  : null,
              icon: const Icon(Icons.add),
            ),
            TextButton(
              onPressed: item == null || !item.available
                  ? null
                  : () => showItemSheet(
                      context,
                      restaurantId: cart.restaurantId,
                      restaurantName: cart.restaurantName,
                      item: item,
                      line: line,
                      lineIndex: index,
                    ),
              child: Text(l10n.customerEdit),
            ),
            TextButton(
              key: Key('cart-remove-$index'),
              onPressed: () => controller.remove(index),
              child: Text(l10n.customerRemove),
            ),
          ],
        ),
      ],
    );
  }
}
