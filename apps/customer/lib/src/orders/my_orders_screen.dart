import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'my_orders.dart';

/// «طلباتي» (CU §12.3): the active orders first, then the past ones, newest
/// first, each with the restaurant, the date, the status and the total; a
/// tap opens the order. Unstyled until the design.
class MyOrdersScreen extends ConsumerWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final orders = ref.watch(myOrdersProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.customerMyOrdersTitle)),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(myOrdersProvider.future),
        child: switch (orders) {
          AsyncData(:final value) when value.orders.isEmpty => ListView(
            children: [ListTile(title: Text(l10n.customerNoOrders))],
          ),
          AsyncData(:final value) => ListView(
            children: [
              if (value.active.isNotEmpty) ...[
                ListTile(title: Text(l10n.customerActiveOrdersTitle)),
                for (final order in value.active) _OrderTile(order: order),
              ],
              if (value.past.isNotEmpty) ...[
                ListTile(title: Text(l10n.customerPastOrdersTitle)),
                for (final order in value.past) _OrderTile(order: order),
              ],
              if (value.next != null)
                value.loadingMore
                    ? const Center(child: CircularProgressIndicator())
                    : TextButton(
                        key: const Key('orders-more'),
                        onPressed: () async {
                          final messenger = ScaffoldMessenger.of(context);
                          final done = await ref
                              .read(myOrdersProvider.notifier)
                              .loadMore();
                          if (!done) {
                            messenger.showSnackBar(
                              SnackBar(content: Text(l10n.statusError)),
                            );
                          }
                        },
                        child: Text(l10n.customerShowMore),
                      ),
            ],
          ),
          AsyncError() => ListView(
            children: [
              ListTile(title: Text(l10n.statusError)),
              TextButton(
                onPressed: () => ref.invalidate(myOrdersProvider),
                child: Text(l10n.customerTryAgain),
              ),
            ],
          ),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  const _OrderTile({required this.order});

  final OrderSummary order;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListTile(
      key: Key('my-order-${order.id}'),
      title: Text(order.restaurant.nameAr),
      subtitle: Text(
        [
          l10n.customerOrderNumber(order.number),
          l10n.formatDate(order.placedAt),
          historyStatusText(l10n, order.status.name),
        ].join(' · '),
      ),
      trailing: Text(
        l10n.formatMoney(order.total!.amount, order.total!.currency),
      ),
      onTap: () => context.push('/orders/${order.id}'),
    );
  }
}
