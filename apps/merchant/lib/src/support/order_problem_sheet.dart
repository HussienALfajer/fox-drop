import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../content.dart';
import 'support.dart';
import 'support_screen.dart';

/// «مشكلة في الطلب» (RA §8.19) on every order: the call and WhatsApp to
/// operations, and a quick reason of Content's merchant_problem list, which
/// opens a ticket on the order, urgent while it is active. Unstyled until
/// the design.
Future<void> showOrderProblem(
  BuildContext context, {
  required String orderId,
  required String orderNumber,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  builder: (_) => OrderProblemSheet(orderId: orderId, orderNumber: orderNumber),
);

class OrderProblemSheet extends ConsumerStatefulWidget {
  const OrderProblemSheet({
    super.key,
    required this.orderId,
    required this.orderNumber,
  });

  final String orderId;
  final String orderNumber;

  @override
  ConsumerState<OrderProblemSheet> createState() => _OrderProblemSheetState();
}

class _OrderProblemSheetState extends ConsumerState<OrderProblemSheet> {
  bool _sending = false;

  Future<void> _report(String code) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _sending = true);
    final outcome = await ref
        .read(merchantReportsProvider)
        .orderProblem(orderId: widget.orderId, reasonCode: code);
    if (!mounted) return;
    setState(() => _sending = false);
    final messenger = ScaffoldMessenger.of(context);
    void say(String text) =>
        messenger.showSnackBar(SnackBar(content: Text(text)));
    switch (outcome) {
      case ReportSent(:final ticket):
        say(
          l10n.merchantReportSent(
            ticket.number,
            l10n.formatReplyWithin(ticket.replyWithinMinutes),
          ),
        );
        Navigator.of(context).pop();
      case ReportTypeChanged():
        say(l10n.merchantReportTypeChanged);
      case ReportOrderGone():
        say(l10n.merchantReportOrderGone);
        Navigator.of(context).pop();
      case ReportPhotoFailed() || ReportFailed():
        say(l10n.merchantReportFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final reasons = ref.watch(orderProblemsProvider);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(title: Text(l10n.merchantOrderProblem)),
          ...contactTiles(context, ref, widget.orderNumber),
          ListTile(title: Text(l10n.merchantOrderProblemHint)),
          ...switch (reasons) {
            AsyncData(:final value) => [
              for (final reason in value)
                ListTile(
                  key: Key('problem-${reason.code}'),
                  title: Text(reason.label),
                  enabled: !_sending,
                  onTap: () => _report(reason.code),
                ),
            ],
            AsyncError() => [
              ListTile(
                title: Text(l10n.merchantReportTypesFailed),
                trailing: TextButton(
                  onPressed: () => ref.invalidate(merchantContentProvider),
                  child: Text(l10n.merchantReportsRetry),
                ),
              ),
            ],
            _ => [const LinearProgressIndicator()],
          },
        ],
      ),
    );
  }
}
