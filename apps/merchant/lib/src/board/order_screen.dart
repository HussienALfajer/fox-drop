import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth.dart';
import 'board.dart';
import 'board_screen.dart';
import 'commands.dart';
import 'dispute_sheet.dart';
import 'texts.dart';

/// The order detail (RA §8.4) from the board's state: header, customer,
/// items, the money line everyone sees, the captain, the pickup and the
/// actions. The owner-only money lines, the badges and the timeline come
/// with their server fields. Unstyled until the design.
class OrderScreen extends ConsumerWidget {
  const OrderScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final board = ref.watch(boardProvider).value?.value;
    final now = ref.watch(tickProvider).value ?? DateTime.now().toUtc();
    final order = board?.orders.where((o) => o.id == orderId).firstOrNull;
    if (board == null || order == null) {
      // The order left the board: delivered, ended, or not this restaurant's.
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.merchantBoardEmpty)),
      );
    }
    final column = columnOf(order);
    final line = captainLine(order);
    final timer = columnTimer(l10n, order, now);
    final captain = order.captain;
    final pickup = order.pickup;
    final disputeOpen =
        pickup.pickedUpAt != null &&
        pickup.disputeUntil != null &&
        now.isBefore(pickup.disputeUntil!);
    final sending = ref.watch(boardCommandsProvider).contains(order.id);
    Future<void> show(CommandNotice? notice) async {
      if (notice != null && context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(commandText(l10n, notice))));
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('#${order.number}')),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              [
                l10n.formatTime(order.placedAt),
                if (column != null) columnTitle(l10n, column),
              ].join(' · '),
            ),
            subtitle: timer == null ? null : Text(timer),
          ),
          ListTile(
            title: Text(
              l10n.merchantCustomer(
                order.customer.firstName ?? '',
                order.customer.neighbourhood,
              ),
            ),
            subtitle: order.note == null
                ? null
                : Text(l10n.merchantCustomerNote(order.note!)),
          ),
          for (final item in order.lines)
            ListTile(
              title: Text('${item.quantity} × ${item.name}'),
              subtitle: item.options.isEmpty && item.note == null
                  ? null
                  : Text(
                      [
                        if (item.options.isNotEmpty)
                          item.options.map((o) => o.name).join('، '),
                        ?item.note,
                      ].join('\n'),
                    ),
              trailing: Text(l10n.formatMoney(item.lineTotal, order.currency)),
            ),
          ListTile(
            title: Text(
              l10n.merchantItemsValue(
                l10n.formatMoney(order.itemsValue, order.currency),
              ),
            ),
          ),
          if (line != null)
            ListTile(
              title: Text(captainLineText(l10n, line, now)),
              subtitle: captain == null
                  ? null
                  : Text(vehicleText(l10n, captain.vehicle.name)),
            ),
          if (pickup.pickedUpAt != null)
            ListTile(
              title: Text(l10n.merchantPickedUp),
              subtitle: pickup.readyNotPressed
                  ? Text(l10n.merchantReadyNotPressed)
                  : null,
            ),
          Padding(
            padding: const EdgeInsetsDirectional.all(16),
            child: MainAction(order: order, board: board),
          ),
          if (order.status == OrderStatus.accepted) ...[
            ListTile(
              title: Text(l10n.merchantWhyReady),
              subtitle: Text(l10n.merchantWhyReadyText),
            ),
            // RA §8.7, R7: no extension; the link calls operations.
            TextButton(
              onPressed: () async {
                final contact = await ref.read(merchantAuth.contact.future);
                final phone = contact.phone;
                if (phone == null) return;
                await ref.read(merchantAuth.launch)(
                  Uri(scheme: 'tel', path: phone),
                );
              },
              child: Text(l10n.merchantNeedMoreTime),
            ),
          ],
          // RA §8.10 item 8: «المبلغ غير صحيح» after the pickup, within the
          // dispute window.
          if (disputeOpen && pickup.request != null)
            OutlinedButton(
              key: const Key('dispute-after-pickup'),
              onPressed: sending
                  ? null
                  : () async {
                      final received = await showDisputeSheet(
                        context,
                        requestLines(pickup.request!),
                      );
                      if (received == null) return;
                      await show(
                        await ref
                            .read(boardCommandsProvider.notifier)
                            .disputePickup(order.id, null, received),
                      );
                    },
              child: Text(l10n.merchantAmountIncorrect),
            ),
        ],
      ),
    );
  }
}

String vehicleText(AppLocalizations l10n, String vehicle) => switch (vehicle) {
  'walking' => l10n.vehicleWalking,
  'bicycle' => l10n.vehicleBicycle,
  'car' => l10n.vehicleCar,
  _ => l10n.vehicleMotorbike,
};
