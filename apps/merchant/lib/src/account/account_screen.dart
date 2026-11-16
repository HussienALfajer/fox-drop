import 'package:core_l10n/core_l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'account.dart';
import 'records.dart';

/// «الحساب», the owners' (RA §12.2, R10): the balance card with «موعد
/// التسوية», the commission, «قبضت اليوم من الكباتن» with today's pickups,
/// this week by day with the exceptions' labels (RA §12.5), and the links to
/// «الكشوف» and «الإيصالات». The overdue line comes with 2.19f. Unstyled
/// until the design.
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final account = ref.watch(accountProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.merchantAccount),
        actions: [
          IconButton(
            key: const Key('account-refresh'),
            tooltip: l10n.merchantRetry,
            onPressed: () => ref.invalidate(accountProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: switch (account) {
        AsyncData(:final value) => _AccountView(account: value),
        // A 403 (a cashier) would fail again.
        AsyncError(:final error)
            when error is DioException && error.response?.statusCode == 403 =>
          Center(child: Text(l10n.merchantAccountNotAllowed)),
        AsyncError() => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.merchantAccountFailed),
              TextButton(
                onPressed: () => ref.invalidate(accountProvider),
                child: Text(l10n.merchantRetry),
              ),
            ],
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _AccountView extends StatelessWidget {
  const _AccountView({required this.account});

  final Account account;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currency = account.currency;
    String money(String minor) =>
        currency == null ? minor : l10n.formatMoney(minor, currency);
    final today = account.pickups.fold(
      BigInt.zero,
      (sum, pickup) => sum + BigInt.parse(pickup.amount),
    );
    final next = account.nextCommission;
    return ListView(
      children: [
        ListTile(
          key: const Key('account-balance'),
          title: Text(l10n.balanceText(account)),
          subtitle: Text(l10n.settlementText(account.settlementDate)),
        ),
        if (account.commissionBp case final bp?)
          ListTile(
            key: const Key('account-commission'),
            title: Text(l10n.merchantAccountCommission(percentOf(bp))),
            subtitle: next == null
                ? null
                : Text(
                    l10n.merchantAccountCommissionChange(
                      percentOf(next.rateBp),
                      l10n.formatDate(next.from),
                    ),
                  ),
          ),
        // RA §12.2: the tabs «الكشوف» and «الإيصالات».
        ListTile(
          key: const Key('account-statements'),
          title: Text(l10n.merchantStatements),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/account/statements'),
        ),
        ListTile(
          key: const Key('account-receipts'),
          title: Text(l10n.merchantReceipts),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/account/receipts'),
        ),
        const Divider(),
        ListTile(
          key: const Key('account-today'),
          title: Text(
            l10n.merchantAccountToday(
              money(today.toString()),
              '${account.pickups.length}',
            ),
          ),
        ),
        for (final pickup in account.pickups)
          ListTile(
            title: Text(
              l10n.merchantAccountPickup(
                pickup.orderNumber,
                l10n.formatTime(pickup.at),
                pickup.captainName ?? '',
              ),
            ),
            subtitle: Text(
              pickup.lines
                  .map((line) => l10n.formatMoney(line.amount, line.currency))
                  .join(' + '),
            ),
            trailing: Text(money(pickup.amount)),
          ),
        const Divider(),
        ListTile(title: Text(l10n.merchantAccountWeek)),
        if (account.weekLines.isEmpty)
          ListTile(title: Text(l10n.merchantAccountWeekEmpty)),
        for (final day in daysOf(account.weekLines)) ...[
          ListTile(
            title: Text(
              '${l10n.weekdayOf(noonOf(day.day))} ${l10n.formatDate(noonOf(day.day))}',
            ),
          ),
          for (final line in day.lines) _WeekLine(line: line, money: money),
        ],
      ],
    );
  }
}

/// One entry of «هذا الأسبوع»: an order's commission and discount share, an
/// exception with its order and label (RA §12.5), or a payment.
class _WeekLine extends StatelessWidget {
  const _WeekLine({required this.line, required this.money});

  final AccountLine line;
  final String Function(String minor) money;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final number = line.orderNumber;
    if (line.kind == LineKind.order) {
      final discount = BigInt.parse(line.discountShare ?? '0');
      return ListTile(
        title: Text(
          l10n.merchantAccountOrder(
            number ?? '',
            money(line.commission ?? '0'),
          ),
        ),
        subtitle: discount == BigInt.zero
            ? null
            : Text(l10n.merchantAccountOrderDiscount(money('$discount'))),
      );
    }
    final amount = BigInt.parse(line.amount ?? '0');
    final shown = money(amount.abs().toString());
    if (line.kind == LineKind.payment) {
      return ListTile(
        title: Text(
          amount.isNegative
              ? l10n.merchantAccountPayment(shown)
              : l10n.merchantAccountPayout(shown),
        ),
      );
    }
    return ListTile(
      title: Text(
        l10n.merchantAccountException(
          l10n.causeLabel(line.cause, line.reason),
          shown,
        ),
      ),
      subtitle: Text(
        [
          if (number != null) l10n.merchantAccountExceptionOrder(number),
          amount.isNegative
              ? l10n.merchantAccountLowers
              : l10n.merchantAccountRaises,
          // RA §12.5: who decided it.
          ?l10n.deciderNameText(line.decidedBy?.name, line.decidedByName),
        ].join(' · '),
      ),
    );
  }
}
