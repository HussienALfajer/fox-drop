import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth.dart';
import 'custody.dart';
import 'work/order_view.dart' show navigationTo;
import 'work/work.dart';

/// CA §10.2 «عهدتي»: the sentence, each currency with its base equivalent
/// and its two parts, the cash limit and its bar, every entry, every receipt
/// as the desk records it, and the office with its hours and the map.
/// Unstyled until the design.
class CustodyScreen extends ConsumerWidget {
  const CustodyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final custody = ref.watch(custodyProvider);
    final office = ref.watch(
      workProvider.select((live) => live.value?.value?.availability.office),
    );
    return Scaffold(
      appBar: AppBar(title: Text(l10n.captainCustodyTitle)),
      body: switch (custody) {
        AsyncData(:final value) => _CustodyView(custody: value, office: office),
        AsyncError() => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.signInError),
              TextButton(
                onPressed: () => ref.invalidate(custodyProvider),
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

class _CustodyView extends ConsumerWidget {
  const _CustodyView({required this.custody, required this.office});

  final Custody custody;
  final Office? office;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final title = Theme.of(context).textTheme.titleMedium;
    String money(String amount, String currency) =>
        l10n.formatMoney(amount, currency);
    return ListView(
      key: const Key('custody'),
      padding: const EdgeInsetsDirectional.all(16),
      children: [
        Text(
          l10n.custodySentence(custody),
          key: const Key('custody-sentence'),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        for (final each in custody.currencies) ...[
          Text(
            l10n.captainCustodyCurrency(
              money(each.balance, each.currency),
              money(each.balanceInBase, custody.total.currency),
            ),
          ),
          Text(
            l10n.captainCustodyPrevious(money(each.closedDue, each.currency)),
          ),
          Text(l10n.captainCustodyToday(money(each.today, each.currency))),
        ],
        const SizedBox(height: 16),
        CustodyLimitBar(
          usage: custody.usage.amount,
          limit: custody.limit.amount,
          currency: custody.limit.currency,
        ),
        const SizedBox(height: 16),
        Text(l10n.captainOffice, style: title),
        _OfficeSection(office: office),
        const SizedBox(height: 16),
        Text(l10n.captainCustodyReceipts, style: title),
        if (custody.receipts.isEmpty) Text(l10n.captainCustodyNoReceipts),
        for (final receipt in custody.receipts)
          ListTile(
            key: Key('receipt-${receipt.number}'),
            title: Text(
              l10n.captainCustodyReceipt(
                receipt.number,
                l10n.receiptTypeText(receipt.type) ??
                    l10n.captainCustodyEntryOther,
                l10n.formatDate(receipt.at),
                l10n.formatTime(receipt.at),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final conversion in receipt.conversions)
                  Text(
                    l10n.captainCustodyReceiptConversion(
                      money(conversion.amount, conversion.from),
                      money(conversion.converted, conversion.to),
                    ),
                  ),
                Text(
                  receipt.lines
                      .map((line) => money(line.amount, line.currency))
                      .join(' + '),
                ),
                if (receipt.cashierName case final name?)
                  Text(l10n.captainCustodyReceiptCashier(name)),
              ],
            ),
          ),
        const SizedBox(height: 16),
        Text(l10n.captainCustodyEntries, style: title),
        if (custody.entries.isEmpty) Text(l10n.captainCustodyNoEntries),
        for (final entry in custody.entries)
          ListTile(
            title: Text(l10n.entryText(entry)),
            subtitle: Text(
              '${l10n.formatDate(entry.at)} ${l10n.formatTime(entry.at)}',
            ),
          ),
      ],
    );
  }
}

/// CA §10.4: the cash limit and its usage as a bar, on «عهدتي» and home.
class CustodyLimitBar extends StatelessWidget {
  const CustodyLimitBar({
    required this.usage,
    required this.limit,
    required this.currency,
    super.key,
  });

  final String usage;
  final String limit;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final shown = BigInt.parse(usage) < BigInt.zero ? '0' : usage;
    return Column(
      key: const Key('custody-limit'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.captainCustodyLimit(
            l10n.formatMoney(shown, currency),
            l10n.formatMoney(limit, currency),
          ),
        ),
        LinearProgressIndicator(value: limitShare(usage, limit)),
      ],
    );
  }
}

/// CA §10.2, C13: the desk now, its hours per weekday and the map.
class _OfficeSection extends ConsumerWidget {
  const _OfficeSection({required this.office});

  final Office? office;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final office = this.office;
    if (office == null) return Text(l10n.captainOfficeUnset);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.officeNowText(office), key: const Key('office-now')),
        for (final weekday in officeWeek)
          Text(l10n.officeDayText(office, weekday)),
        OfficeMapButton(office: office),
      ],
    );
  }
}

/// CA §7.5, C13: opens the office on the map.
class OfficeMapButton extends ConsumerWidget {
  const OfficeMapButton({required this.office, super.key});

  final Office office;

  @override
  Widget build(BuildContext context, WidgetRef ref) => TextButton(
    key: const Key('office-map'),
    onPressed: () => ref.read(captainAuth.launch)(
      navigationTo(office.latitude, office.longitude),
    ),
    child: Text(AppLocalizations.of(context).captainOfficeMap),
  );
}
