import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'history.dart';
import 'work/texts.dart';
import 'work/work.dart';

/// CA §9.13 «السجل»: the past orders by business day, every one or a range,
/// each with the restaurant and «الحي» (never the customer, K8), how it
/// ended, the pay and the custody effect; a tap opens the captain's own
/// steps. Unstyled until the design.
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final history = ref.watch(historyProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.captainHistory)),
      body: switch (history) {
        AsyncData(:final value) => _list(context, ref, l10n, value),
        AsyncError() => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.captainHistoryFailed),
              TextButton(
                onPressed: () => ref.invalidate(historyProvider),
                child: Text(l10n.captainRetry),
              ),
            ],
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _list(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    HistoryView view,
  ) {
    final notifier = ref.read(historyProvider.notifier);
    Future<void> pickRange() async {
      final today = ref.read(serverClockProvider).now();
      final picked = await showDateRangePicker(
        context: context,
        firstDate: today.subtract(const Duration(days: 365)),
        lastDate: today,
      );
      if (picked == null) return;
      notifier.show(HistoryRange(picked.start.toDate(), picked.end.toDate()));
    }

    final range = view.range;
    return ListView(
      children: [
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              key: const Key('history-all'),
              label: Text(l10n.captainHistoryAll),
              selected: range == null,
              onSelected: (_) => notifier.show(null),
            ),
            ActionChip(
              key: const Key('history-range'),
              label: Text(
                range == null
                    ? l10n.captainHistoryPickRange
                    : l10n.captainHistoryRange(
                        l10n.dayText(range.from),
                        l10n.dayText(range.to),
                      ),
              ),
              onPressed: pickRange,
            ),
          ],
        ),
        if (view.orders.isEmpty)
          ListTile(title: Text(l10n.captainHistoryEmpty))
        else
          for (final (day, orders) in daysOf(view.orders)) ...[
            ListTile(title: Text(l10n.dayText(day))),
            for (final order in orders)
              _OrderRow(order: order, currency: view.payCurrency),
          ],
        if (view.next != null)
          TextButton(
            key: const Key('history-more'),
            onPressed: view.loadingMore ? null : notifier.more,
            child: Text(
              view.moreFailed
                  ? l10n.captainHistoryMoreFailed
                  : l10n.captainHistoryMore,
            ),
          ),
      ],
    );
  }
}

class _OrderRow extends StatelessWidget {
  const _OrderRow({required this.order, required this.currency});

  final HistoryOrder order;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pay = order.pay;
    return ListTile(
      key: Key('history-order-${order.id}'),
      title: Text(
        [
          '#${order.number}',
          l10n.formatTime(order.placedAt),
          l10n.endText(order),
        ].join(' · '),
      ),
      subtitle: Text(
        [
          l10n.captainHistoryRestaurant(
            order.restaurantName,
            order.neighbourhood,
          ),
          pay == null
              ? l10n.captainHistoryNoPay
              : l10n.captainHistoryPay(l10n.formatMoney(pay, currency)),
        ].join('\n'),
      ),
      onTap: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (context) =>
            HistoryOrderSheet(order: order, currency: currency),
      ),
    );
  }
}

/// CA §9.13 detail: the captain's own steps and the amounts.
class HistoryOrderSheet extends StatelessWidget {
  const HistoryOrderSheet({
    super.key,
    required this.order,
    required this.currency,
  });

  final HistoryOrder order;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pay = order.pay;
    final outcome = order.outcome;
    return SafeArea(
      child: ListView(
        key: const Key('history-detail'),
        shrinkWrap: true,
        children: [
          ListTile(
            title: Text('#${order.number}'),
            subtitle: Text(
              l10n.captainHistoryRestaurant(
                order.restaurantName,
                order.neighbourhood,
              ),
            ),
          ),
          ListTile(
            title: Text(
              [
                l10n.endText(order),
                if (outcome != null &&
                    outcome !=
                        CaptainOrderHistoryDtoOutputOrdersInnerOutcomeEnum
                            .normal)
                  outcomeText(l10n, EndedOutcome.valueOf(outcome.name)),
              ].join(' · '),
            ),
          ),
          ListTile(
            title: Text(
              pay == null
                  ? l10n.captainHistoryNoPay
                  : l10n.captainHistoryPay(l10n.formatMoney(pay, currency)),
            ),
          ),
          if (order.paidToRestaurant.isNotEmpty)
            ListTile(
              title: Text(
                l10n.captainHistoryPaidToRestaurant(
                  l10n.linesText(order.paidToRestaurant),
                ),
              ),
            ),
          if (order.collected.isNotEmpty)
            ListTile(
              title: Text(
                l10n.captainHistoryCollected(l10n.linesText(order.collected)),
              ),
            ),
          if (order.change.isNotEmpty)
            ListTile(
              title: Text(
                l10n.captainHistoryChange(l10n.linesText(order.change)),
              ),
            ),
          ListTile(title: Text(l10n.captainHistorySteps)),
          for (final step in order.steps)
            ListTile(
              title: Text(l10n.stepText(step.step.name)),
              trailing: Text(
                '${l10n.formatDate(step.at)} ${l10n.formatTime(step.at)}',
              ),
            ),
        ],
      ),
    );
  }
}
