import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';

/// One of the customer's orders (`GET /v1/customer/orders/{orderId}`).
final orderProvider = FutureProvider.autoDispose
    .family<CustomerOrderDtoOutputOrder, String>((ref, id) async {
      final response = await ref
          .watch(coreApiProvider)
          .getCustomerApi()
          .customerOrdersOrder(orderId: id);
      return response.data!.order;
    });

/// The order screen after placing (CU §10.7 item 6): «أرسلنا طلبك إلى
/// {المطعم}», the number, the status, the lines and the total. It refreshes
/// on demand; the live updates come with slice 1.14e (CU §11).
class OrderScreen extends ConsumerWidget {
  const OrderScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final order = ref.watch(orderProvider(orderId));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          order.value == null
              ? ''
              : l10n.customerOrderNumber(order.value!.number),
        ),
      ),
      body: switch (order) {
        AsyncData(:final value) => RefreshIndicator(
          onRefresh: () => ref.refresh(orderProvider(orderId).future),
          child: ListView(
            children: [
              if (value.status.name == 'placed')
                ListTile(
                  title: Text(l10n.customerOrderSent(value.restaurant.nameAr)),
                ),
              ListTile(
                key: const Key('order-status'),
                title: Text(switch (value.status.name) {
                  'placed' => l10n.customerStatusPlaced,
                  'accepted' => l10n.customerStatusAccepted,
                  'ready' => l10n.customerStatusReady,
                  'pickedUp' => l10n.customerStatusPickedUp,
                  'arrived' => l10n.customerStatusArrived,
                  'delivered' => l10n.customerStatusDelivered,
                  _ => l10n.customerStatusCancelled,
                }),
                subtitle: Text(
                  value.promisedAt == null
                      ? l10n.customerEstimate(
                          value.estimate.fromMin,
                          value.estimate.toMin,
                        )
                      : l10n.customerArrivesAbout(
                          l10n.formatTime(value.promisedAt!),
                        ),
                ),
              ),
              for (final line in value.lines)
                ListTile(
                  title: Text('${line.quantity} × ${line.name}'),
                  subtitle: line.options.isEmpty && line.note == null
                      ? null
                      : Text(
                          [
                            if (line.options.isNotEmpty)
                              line.options.map((o) => o.name).join('، '),
                            ?line.note,
                          ].join('\n'),
                        ),
                  trailing: Text(
                    l10n.formatMoney(line.lineTotal, value.currency),
                  ),
                ),
              ListTile(
                title: Text(l10n.customerTotal),
                trailing: Text(
                  l10n.formatMoney(value.money.total, value.currency),
                ),
              ),
            ],
          ),
        ),
        AsyncError() => Center(
          child: TextButton(
            onPressed: () => ref.invalidate(orderProvider(orderId)),
            child: Text(l10n.customerTryAgain),
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
