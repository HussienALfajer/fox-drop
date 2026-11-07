import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../browsing/browsing.dart';
import 'cart.dart';
import 'item_sheet.dart';

/// The cart (CU §10.1): each line with «−» and «+», «تعديل» and «حذف», then
/// «متابعة» to checkout. Unstyled until the design.
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(cartProvider).value;
    final cart = state?.cart;
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
                Padding(
                  padding: const EdgeInsetsDirectional.all(16),
                  child: FilledButton(
                    key: const Key('cart-continue'),
                    onPressed: () => context.push('/checkout'),
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
