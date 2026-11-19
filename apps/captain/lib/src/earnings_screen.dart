import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'earnings.dart';

/// CA §10.6 «أرباحي»: today and this week (earnings, orders, online
/// hours), the balance and the next payout with a negative balance
/// explained (CA §10.7), this week's orders with their pay by part, and the
/// other lines with their reason, order or receipt. Unstyled until the
/// design.
class EarningsScreen extends ConsumerWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final earnings = ref.watch(earningsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.captainEarningsTitle)),
      body: switch (earnings) {
        AsyncData(:final value) => _EarningsView(earnings: value),
        AsyncError() => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.signInError),
              TextButton(
                onPressed: () => ref.invalidate(earningsProvider),
                child: Text(l10n.captainRetry),
              ),
            ],
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _EarningsView extends StatelessWidget {
  const _EarningsView({required this.earnings});

  final Earnings earnings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = Theme.of(context).textTheme.titleMedium;
    final currency = earnings.currency;
    String money(String amount) => l10n.formatMoney(amount, currency);
    final negative = l10n.negativeText(earnings);
    return ListView(
      key: const Key('earnings'),
      padding: const EdgeInsetsDirectional.all(16),
      children: [
        Text(
          l10n.captainEarningsBalance(money(earnings.balance)),
          key: const Key('earnings-balance'),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(l10n.payoutText(earnings.nextPayout)),
        if (negative != null)
          Text(negative, key: const Key('earnings-negative')),
        // CA §10.7: the statements the desk issued.
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton(
            key: const Key('earnings-statements'),
            onPressed: () => context.push('/earnings/statements'),
            child: Text(l10n.captainStatementTitle),
          ),
        ),
        // CA §12.5, Appendix B: «احسب أجري» on «ملفي».
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton(
            key: const Key('earnings-calculator'),
            onPressed: () => context.push('/profile'),
            child: Text(l10n.captainPayCalculator),
          ),
        ),
        const SizedBox(height: 16),
        Text(l10n.captainEarningsToday, style: title),
        Text(l10n.captainEarningsSoFar(money(earnings.today.earnings))),
        Text(l10n.captainEarningsOrderCount(earnings.today.orders)),
        Text(l10n.onlineText(earnings.today.onlineMinutes)),
        const SizedBox(height: 16),
        Text(l10n.captainEarningsWeek, style: title),
        Text(l10n.captainEarningsSoFar(money(earnings.week.earnings))),
        Text(l10n.captainEarningsOrderCount(earnings.week.orders)),
        Text(l10n.onlineText(earnings.week.onlineMinutes)),
        const SizedBox(height: 16),
        if (earnings.orders.isEmpty && earnings.lines.isEmpty)
          Text(l10n.captainEarningsNothing),
        if (earnings.orders.isNotEmpty) ...[
          Text(l10n.captainEarningsOrders, style: title),
          for (final order in earnings.orders)
            ListTile(
              contentPadding: EdgeInsetsDirectional.zero,
              title: Text(l10n.orderText(order, currency)),
              subtitle: Text(
                [
                  l10n.momentText(order.at),
                  ...l10n.partTexts(order, currency),
                ].join('\n'),
              ),
            ),
        ],
        if (earnings.lines.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(l10n.captainEarningsOther, style: title),
          for (final line in earnings.lines)
            ListTile(
              contentPadding: EdgeInsetsDirectional.zero,
              title: Text(l10n.lineTexts(line, currency).first),
              subtitle: Text(
                [
                  l10n.momentText(line.at),
                  ...l10n.lineTexts(line, currency).skip(1),
                ].join('\n'),
              ),
            ),
        ],
      ],
    );
  }
}
