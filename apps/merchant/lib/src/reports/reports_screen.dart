import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'reports.dart';

/// «التقارير», the owners' (RA §11): a period's figures, each with the
/// arrow against the previous period of the same length and its definition
/// behind the info icon, the rejections, the top items, the delivered
/// orders by hour and the pause minutes, as tables until the design (owner
/// decision 2026-11-20). Unstyled until the design.
class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  ReportsPeriod _period = ReportsPeriod.today;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final figures = ref.watch(reportsProvider(_period));
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.merchantReports),
        actions: [
          IconButton(
            key: const Key('reports-refresh'),
            tooltip: l10n.merchantRetry,
            onPressed: () => ref.invalidate(reportsProvider(_period)),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsetsDirectional.all(16),
        children: [
          Wrap(
            spacing: 8,
            children: [
              for (final period in ReportsPeriod.values)
                ChoiceChip(
                  key: Key('reports-period-${period.name}'),
                  label: Text(l10n.reportsPeriodLabel(period)),
                  selected: _period == period,
                  onSelected: (_) => setState(() => _period = period),
                ),
            ],
          ),
          Text(l10n.merchantReportsCompared),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton(
              key: const Key('open-summary'),
              onPressed: () => context.push('/reports/summary'),
              child: Text(l10n.merchantReportsOpenSummary),
            ),
          ),
          const Divider(),
          ...switch (figures) {
            AsyncData(:final value) => _figures(context, value),
            // A 403 (a cashier, a terminated restaurant) would fail again.
            AsyncError(:final error) when refusalOf(error) != null => [
              Text(
                refusalOf(error) == ReportsRefusal.terminated
                    ? l10n.merchantReportsTerminated
                    : l10n.merchantReportsNotAllowed,
              ),
            ],
            AsyncError() => [
              Text(l10n.merchantReportsFailed),
              TextButton(
                key: const Key('reports-retry'),
                onPressed: () => ref.invalidate(reportsProvider(_period)),
                child: Text(l10n.merchantRetry),
              ),
            ],
            _ => [const Center(child: CircularProgressIndicator())],
          },
        ],
      ),
    );
  }

  List<Widget> _figures(BuildContext context, FiguresAnswer answer) {
    final l10n = AppLocalizations.of(context);
    final current = answer.current;
    return [
      for (final metric in Metric.values)
        MetricTile(metric: metric, answer: answer),
      const Divider(),
      _Heading(l10n.merchantReportsRejections),
      if (current.rejections.isEmpty) Text(l10n.merchantReportsEmpty),
      for (final row in current.rejections)
        Text(
          row.byOperations
              ? l10n.merchantReportsRejectionByOperations(row.label, row.count)
              : l10n.merchantReportsRejectionRow(row.label, row.count),
        ),
      _Heading(l10n.merchantReportsTopByQuantity),
      ..._items(context, current.topByQuantity, answer.currency),
      _Heading(l10n.merchantReportsTopBySales),
      ..._items(context, current.topBySales, answer.currency),
      _Heading(l10n.merchantReportsHours),
      for (final row in current.hours)
        Text(
          key: Key('reports-hour-${row.hour}'),
          l10n.merchantReportsHourRow(
            row.hour.toString().padLeft(2, '0'),
            row.delivered,
          ),
        ),
      _Heading(l10n.merchantReportsPauses),
      Text(
        l10n.merchantReportsPauseRestaurant(current.pauseMinutes.restaurant),
      ),
      Text(l10n.merchantReportsPauseOps(current.pauseMinutes.ops)),
      Text(l10n.merchantReportsPauseAuto(current.pauseMinutes.auto)),
      Text(l10n.merchantReportsBusyNotYet),
    ];
  }

  List<Widget> _items(
    BuildContext context,
    Iterable<MerchantFiguresItemOutput> items,
    String currency,
  ) {
    final l10n = AppLocalizations.of(context);
    if (items.isEmpty) return [Text(l10n.merchantReportsEmpty)];
    return [
      for (final item in items)
        Text(
          l10n.merchantReportsItemRow(
            item.name,
            item.quantity,
            l10n.formatMoney(item.sales, currency),
          ),
        ),
    ];
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(top: 16, bottom: 4),
    child: Text(text, style: Theme.of(context).textTheme.titleMedium),
  );
}

/// One figure: its label, its value, the arrow against the previous period
/// with the previous value, and the info icon with its definition (RA §11
/// «Definitions»).
class MetricTile extends StatelessWidget {
  const MetricTile({super.key, required this.metric, required this.answer});

  final Metric metric;
  final FiguresAnswer answer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final label = l10n.metricLabel(metric);
    final change = changeOf(
      metric.of(answer.current),
      metric.of(answer.previous),
    );
    return ListTile(
      key: Key('metric-${metric.name}'),
      contentPadding: EdgeInsetsDirectional.zero,
      title: Text(label),
      subtitle: Text(
        '${l10n.changeText(change)} · '
        '${l10n.merchantReportsPrevious(l10n.metricValue(metric, answer.previous, answer.currency))}',
      ),
      leading: IconButton(
        key: Key('metric-info-${metric.name}'),
        tooltip: l10n.merchantReportsInfo(label),
        icon: const Icon(Icons.info_outline),
        onPressed: () => showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(label),
            content: Text(l10n.metricInfo(metric)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.merchantReportsInfoClose),
              ),
            ],
          ),
        ),
      ),
      trailing: Text(
        key: Key('metric-value-${metric.name}'),
        l10n.metricValue(metric, answer.current, answer.currency),
      ),
    );
  }
}
