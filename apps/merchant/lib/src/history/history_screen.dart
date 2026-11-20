import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../account/account.dart';
import 'history.dart';

/// RA §8.18 «السجل»: the range, the status and the number search, then the
/// orders newest first, each opening its detail. A cashier's range is fixed
/// to today and the 7 business days before (S12); an owner picks presets or
/// any range. Unstyled until the design.
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final _number = TextEditingController();

  @override
  void dispose() {
    _number.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final history = ref.watch(historyProvider);
    final notifier = ref.read(historyProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.merchantHistory)),
      body: switch (history) {
        AsyncData(:final value) => _list(context, l10n, value, notifier),
        AsyncError() => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.merchantHistoryFailed),
              TextButton(
                onPressed: () => ref.invalidate(historyProvider),
                child: Text(l10n.merchantRetry),
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
    AppLocalizations l10n,
    HistoryView view,
    HistoryNotifier notifier,
  ) {
    final filter = view.filter;
    final owner = view.first.owner;
    Future<void> pickRange() async {
      final today = view.today.toDateTime(utc: true);
      final picked = await showDateRangePicker(
        context: context,
        firstDate: today.subtract(const Duration(days: 365)),
        lastDate: today,
      );
      if (picked == null) return;
      notifier.show(
        filter.withRange(picked.start.toDate(), picked.end.toDate()),
      );
    }

    return ListView(
      children: [
        if (owner)
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                key: const Key('history-default'),
                label: Text(l10n.merchantHistoryCashierWindow),
                selected: filter.from == null,
                onSelected: (_) => notifier.show(filter.withRange(null, null)),
              ),
              ChoiceChip(
                key: const Key('history-today'),
                label: Text(l10n.merchantHistoryPresetToday),
                selected: filter.from == view.today && filter.to == view.today,
                onSelected: (_) {
                  final (from, to) = todayRange(view.today);
                  notifier.show(filter.withRange(from, to));
                },
              ),
              ChoiceChip(
                key: const Key('history-30'),
                label: Text(l10n.merchantHistoryPreset30),
                selected: false,
                onSelected: (_) {
                  final (from, to) = last30Range(view.today);
                  notifier.show(filter.withRange(from, to));
                },
              ),
              ActionChip(
                key: const Key('history-custom'),
                label: Text(l10n.merchantHistoryPresetCustom),
                onPressed: pickRange,
              ),
            ],
          )
        else
          ListTile(title: Text(l10n.merchantHistoryCashierWindow)),
        ListTile(
          key: const Key('history-range'),
          title: Text(
            l10n.merchantHistoryRange(
              l10n.dayText(view.first.fromDay),
              l10n.dayText(view.first.toDay),
            ),
          ),
        ),
        DropdownButton<HistoryStatus?>(
          key: const Key('history-status'),
          value: filter.status,
          items: [
            DropdownMenuItem(child: Text(l10n.merchantHistoryAllStatuses)),
            for (final status in historyStatuses)
              DropdownMenuItem(
                value: status,
                child: Text(l10n.historyStatusText(status.name)),
              ),
          ],
          onChanged: (status) => notifier.show(filter.withStatus(status)),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                key: const Key('history-number'),
                controller: _number,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.merchantHistoryNumber,
                ),
                onSubmitted: (text) =>
                    notifier.show(filter.withNumber(text.trim())),
              ),
            ),
            TextButton(
              key: const Key('history-search'),
              onPressed: () =>
                  notifier.show(filter.withNumber(_number.text.trim())),
              child: Text(l10n.merchantHistorySearch),
            ),
          ],
        ),
        if (view.orders.isEmpty)
          ListTile(title: Text(l10n.merchantHistoryEmpty))
        else
          for (final order in view.orders) _OrderRow(order: order),
        if (view.next != null)
          TextButton(
            key: const Key('history-more'),
            onPressed: view.loadingMore ? null : notifier.more,
            child: Text(
              view.moreFailed
                  ? l10n.merchantHistoryMoreFailed
                  : l10n.merchantHistoryMore,
            ),
          ),
      ],
    );
  }
}

class _OrderRow extends StatelessWidget {
  const _OrderRow({required this.order});

  final HistoryOrder order;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final owner = order.owner;
    return ListTile(
      key: Key('history-order-${order.id}'),
      title: Text(
        [
          '#${order.number}',
          '${l10n.formatDate(order.placedAt)} ${l10n.formatTime(order.placedAt)}',
          l10n.historyStatusText(order.status.name),
        ].join(' · '),
      ),
      subtitle: Text(
        [
          [
            l10n.merchantHistoryItemCount(order.itemCount),
            l10n.formatMoney(order.itemsValue, order.currency),
            if (order.testOrder) l10n.merchantBadgeTestOrder,
          ].join(' · '),
          if (owner != null)
            owner.testOrder
                ? l10n.merchantOrderTestNoCommission
                : l10n.merchantHistoryOwnerLine(
                    l10n.formatMoney(owner.commission ?? '0', order.currency),
                    l10n.formatMoney(owner.merchantNet ?? '0', order.currency),
                  ),
        ].join('\n'),
      ),
      onTap: () => context.push('/history/${order.id}'),
    );
  }
}

/// RA §8.18 «التفاصيل»: the order as the board shows it (RA §8.4), read
/// only, with its timeline.
class HistoryOrderScreen extends ConsumerWidget {
  const HistoryOrderScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final detail = ref.watch(historyOrderProvider(orderId));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          detail.value == null
              ? l10n.merchantHistory
              : '#${detail.value!.order.number}',
        ),
      ),
      body: switch (detail) {
        AsyncData(:final value) => _detail(l10n, value),
        AsyncError(:final error) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                orderMissing(error)
                    ? l10n.merchantHistoryOrderMissing
                    : l10n.merchantHistoryOrderFailed,
              ),
              if (!orderMissing(error))
                TextButton(
                  onPressed: () =>
                      ref.invalidate(historyOrderProvider(orderId)),
                  child: Text(l10n.merchantRetry),
                ),
            ],
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _detail(AppLocalizations l10n, HistoryDetail detail) {
    final order = detail.order;
    final owner = order.owner;
    final captain = order.captain;
    return ListView(
      children: [
        ListTile(
          title: Text(
            [
              '${l10n.formatDate(order.placedAt)} ${l10n.formatTime(order.placedAt)}',
              l10n.historyStatusText(order.status.name),
            ].join(' · '),
          ),
        ),
        if (order.testOrder) ListTile(title: Text(l10n.merchantBadgeTestOrder)),
        if (order.redeliveryOf case final of?)
          ListTile(title: Text(l10n.redeliveryOf(of.number))),
        if (order.acceptance?.byOperations ?? false)
          ListTile(title: Text(l10n.merchantBadgeByOperations)),
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
        // RA §8.4, R10: the owners' lines (the server gives them to owners
        // only).
        if (owner != null)
          if (owner.testOrder)
            ListTile(title: Text(l10n.merchantOrderTestNoCommission))
          else ...[
            ListTile(
              key: const Key('history-commission'),
              title: Text(
                l10n.merchantOrderCommission(
                  percentOf(owner.commissionBp ?? 0),
                  l10n.formatMoney(owner.commission ?? '0', order.currency),
                ),
              ),
            ),
            ListTile(
              key: const Key('history-net'),
              title: Text(
                l10n.merchantOrderNet(
                  l10n.formatMoney(owner.merchantNet ?? '0', order.currency),
                ),
              ),
            ),
          ],
        if (captain != null)
          ListTile(
            title: Text(l10n.merchantHistoryCaptain(captain.firstName)),
            subtitle: Text(l10n.vehicleName(captain.vehicle.name)),
          ),
        ListTile(title: Text(l10n.merchantHistoryTimeline)),
        for (final step in detail.timeline)
          ListTile(
            title: Text(l10n.timelineText(step.step.name)),
            trailing: Text(
              '${l10n.formatDate(step.at)} ${l10n.formatTime(step.at)}',
            ),
          ),
      ],
    );
  }
}
