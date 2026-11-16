import 'dart:ui' as ui;

import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'records.dart';

/// RA §12.3 «الكشوف»: the latest statements, newest first, with their
/// status. Unstyled until the design.
class StatementsScreen extends ConsumerWidget {
  const StatementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final statements = ref.watch(statementsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.merchantStatements)),
      body: switch (statements) {
        AsyncData(:final value) when value.isEmpty => Center(
          child: Text(l10n.merchantStatementsNone),
        ),
        AsyncData(:final value) => ListView(
          key: const Key('statements'),
          children: [
            for (final statement in value)
              ListTile(
                title: Text(l10n.statementSummary(statement)),
                subtitle: switch (statusOf(statement.status?.name)) {
                  final status? => Text(l10n.statusText(status)),
                  null => null,
                },
                onTap: () =>
                    context.push('/account/statements/${statement.id}'),
              ),
          ],
        ),
        AsyncError(:final error) => _Failed(
          failure: failureOf(error),
          notFound: l10n.merchantStatementNotFound,
          onRetry: () => ref.invalidate(statementsProvider),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

/// RA §12.3 «كشف الأسبوع»: each order with the currency lines the captain
/// paid, its commission and restaurant-funded discount, the exceptions with
/// their order, reason and «من قرّر» (RA §12.5), the payments, the totals
/// down to the total due and the status, and «مشاركة كصورة» (an image only;
/// PDF comes with the portal). A plain layout until the design.
class StatementScreen extends ConsumerStatefulWidget {
  const StatementScreen({super.key, required this.statementId});

  final String statementId;

  @override
  ConsumerState<StatementScreen> createState() => _StatementScreenState();
}

class _StatementScreenState extends ConsumerState<StatementScreen> {
  /// The statement as the image shows it.
  final _image = GlobalKey();
  bool _sharing = false;

  Future<void> _share() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final sharer = ref.read(imageSharerProvider);
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    setState(() => _sharing = true);
    try {
      final boundary =
          _image.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: pixelRatio);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      await sharer(
        bytes!.buffer.asUint8List(),
        'statement-${widget.statementId}.png',
      );
    } on Object catch (error) {
      debugPrint('Statement share: $error');
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.merchantStatementShareFailed)),
      );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final statement = ref.watch(statementProvider(widget.statementId));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.merchantStatementTitle)),
      body: switch (statement) {
        AsyncData(:final value) => SingleChildScrollView(
          key: const Key('statement'),
          padding: const EdgeInsetsDirectional.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RepaintBoundary(
                key: _image,
                // The image needs its own background: a PNG is otherwise
                // transparent.
                child: ColoredBox(
                  color: Theme.of(context).colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.all(8),
                    child: _StatementView(statement: value),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                key: const Key('statement-share'),
                onPressed: _sharing ? null : _share,
                child: Text(l10n.merchantStatementShare),
              ),
            ],
          ),
        ),
        AsyncError(:final error) => _Failed(
          failure: failureOf(error),
          notFound: l10n.merchantStatementNotFound,
          onRetry: () => ref.invalidate(statementProvider(widget.statementId)),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _StatementView extends StatelessWidget {
  const _StatementView({required this.statement});

  final Statement statement;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    String money(String minor) => l10n.formatMoney(minor, statement.currency);
    final lines = linesOf(statement.lines);
    final status = statusOf(statement.status?.name);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.merchantStatementTitle, style: textTheme.titleLarge),
        Text(statement.restaurantName),
        Text(l10n.statementPeriod(statement)),
        Text(l10n.merchantStatementOrders(statement.orders)),
        const SizedBox(height: 8),
        for (final line in lines.orders) ...[
          Text(
            l10n.merchantStatementOrderLine(
              line.orderNumber ?? '',
              money(line.commission ?? '0'),
            ),
          ),
          if (line.itemsValue case final value?)
            Text(
              l10n.merchantStatementPickup(
                money(value),
                line.pickupLines
                        ?.map(
                          (each) =>
                              l10n.formatMoney(each.amount, each.currency),
                        )
                        .join(' + ') ??
                    '',
              ),
            ),
          if (BigInt.parse(line.discountShare ?? '0') != BigInt.zero)
            Text(l10n.merchantAccountOrderDiscount(money(line.discountShare!))),
        ],
        const SizedBox(height: 8),
        Text(
          l10n.merchantStatementExceptionsTitle,
          style: textTheme.titleSmall,
        ),
        if (lines.exceptions.isEmpty) Text(l10n.merchantStatementNoExceptions),
        for (final line in lines.exceptions) ...[
          Text(
            l10n.merchantAccountException(
              exceptionLabel(l10n, line),
              money(BigInt.parse(line.amount ?? '0').abs().toString()),
            ),
          ),
          Text(
            [
              if (line.orderNumber case final number?)
                l10n.merchantAccountExceptionOrder(number),
              BigInt.parse(line.amount ?? '0').isNegative
                  ? l10n.merchantAccountLowers
                  : l10n.merchantAccountRaises,
              ?l10n.deciderText(line),
            ].join(' · '),
          ),
        ],
        if (lines.payments.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            l10n.merchantStatementPaymentsTitle,
            style: textTheme.titleSmall,
          ),
          for (final line in lines.payments)
            Text(
              BigInt.parse(line.amount ?? '0').isNegative
                  ? l10n.merchantAccountPayment(
                      money(BigInt.parse(line.amount!).abs().toString()),
                    )
                  : l10n.merchantAccountPayout(money(line.amount ?? '0')),
            ),
        ],
        const SizedBox(height: 8),
        for (final total in l10n.statementTotals(statement)) Text(total),
        if (status != null) ...[
          Text(l10n.merchantStatementStatus(l10n.statusText(status))),
          if (status != StatementStatus.paid)
            Text(l10n.merchantStatementUnpaidPart(money(statement.unpaid))),
        ],
      ],
    );
  }
}

/// RA §12.4 «الإيصالات»: every receipt the desk issued to the restaurant,
/// newest first, under the safety note.
class ReceiptsScreen extends ConsumerWidget {
  const ReceiptsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final receipts = ref.watch(receiptsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.merchantReceipts)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            key: const Key('receipts-safety'),
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.merchantReceiptsSafety),
          ),
          const Divider(),
          Expanded(
            child: switch (receipts) {
              AsyncData(:final value) when value.isEmpty => Center(
                child: Text(l10n.merchantReceiptsNone),
              ),
              AsyncData(:final value) => ListView(
                key: const Key('receipts'),
                children: [
                  for (final receipt in value)
                    ListTile(
                      title: Text(l10n.receiptSummary(receipt)),
                      subtitle: Text(
                        '${l10n.formatDate(receipt.createdAt)} '
                        '${l10n.formatTime(receipt.createdAt)} · '
                        '${l10n.methodText(receipt.method.name)}',
                      ),
                      onTap: () =>
                          context.push('/account/receipts/${receipt.id}'),
                    ),
                ],
              ),
              AsyncError(:final error) => _Failed(
                failure: failureOf(error),
                notFound: l10n.merchantReceiptNotFound,
                onRetry: () => ref.invalidate(receiptsProvider),
              ),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
        ],
      ),
    );
  }
}

/// RA §12.4: one receipt: the number, the amounts per currency, the method,
/// the staff member and the time, and what was owed before and after.
class ReceiptScreen extends ConsumerWidget {
  const ReceiptScreen({super.key, required this.receiptId});

  final String receiptId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final receipt = ref.watch(receiptProvider(receiptId));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.merchantReceiptTitle)),
      body: switch (receipt) {
        AsyncData(:final value) => ListView(
          key: const Key('receipt'),
          padding: const EdgeInsetsDirectional.all(16),
          children: [
            Text(
              l10n.merchantReceiptNumber(value.number),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              '${l10n.formatDate(value.createdAt)} '
              '${l10n.formatTime(value.createdAt)}',
            ),
            Text(
              l10n.merchantReceiptMethod(l10n.methodText(value.method.name)),
            ),
            if (value.staffName case final name?)
              Text(l10n.merchantReceiptStaff(name)),
            const SizedBox(height: 8),
            for (final line in value.lines)
              Text(
                l10n.receiptLine(
                  line.currency,
                  line.amount,
                  line.base_,
                  value.currency,
                ),
              ),
            Text(
              l10n.merchantReceiptTotal(
                l10n.formatMoney(value.total, value.currency),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.merchantReceiptDueBefore(
                l10n.dueText(value.dueBefore, value.currency),
              ),
            ),
            Text(
              l10n.merchantReceiptDueAfter(
                l10n.dueText(value.dueAfter, value.currency),
              ),
            ),
            const Divider(),
            Text(l10n.merchantReceiptsSafety),
          ],
        ),
        AsyncError(:final error) => _Failed(
          failure: failureOf(error),
          notFound: l10n.merchantReceiptNotFound,
          onRetry: () => ref.invalidate(receiptProvider(receiptId)),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

/// A read that failed: a cashier and an unknown record say so with no
/// retry, since it would fail again; anything else offers one.
class _Failed extends StatelessWidget {
  const _Failed({
    required this.failure,
    required this.notFound,
    required this.onRetry,
  });

  final RecordsFailure failure;
  final String notFound;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (failure) {
      RecordsFailure.ownersOnly => Center(
        child: Text(l10n.merchantRecordsNotAllowed),
      ),
      RecordsFailure.notFound => Center(child: Text(notFound)),
      RecordsFailure.other => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.merchantRecordsFailed),
            TextButton(onPressed: onRetry, child: Text(l10n.merchantRetry)),
          ],
        ),
      ),
    };
  }
}
