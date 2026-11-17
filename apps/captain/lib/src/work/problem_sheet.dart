import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth.dart';
import '../content.dart';
import '../support/pickup_amount_sheet.dart';
import '../support/support.dart';
import 'commands.dart';
import 'order_view.dart';
import 'reason_sheet.dart';
import 'work.dart';

/// CA §9.11 (slices 2.13b, 2.24c): above every step of the active order, «مشكلة»
/// and, while the captain's «لا أستطيع إكمال الطلب» is open, «بانتظار
/// العمليات» with its reason and «تراجع». Every step stays open (owner
/// decision 2026-11-11). Unstyled until the design.
class ProblemBar extends ConsumerWidget {
  const ProblemBar({super.key, required this.order});

  final ActiveOrder order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final asked = order.cannotComplete;
    final sending = ref.watch(commandsProvider).contains(order.id);
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (asked != null) ...[
            Text(l10n.captainAwaitingOperations),
            Text(l10n.captainCannotCompleteSent(asked.reason)),
            OutlinedButton(
              onPressed: sending
                  ? null
                  : () async {
                      final notice = await ref
                          .read(commandsProvider.notifier)
                          .withdrawCannotComplete(order.id);
                      if (context.mounted) showNotice(context, notice);
                    },
              child: Text(l10n.captainWithdrawRequest),
            ),
          ],
          OutlinedButton(
            onPressed: () => _openProblem(context, ref, order),
            child: Text(l10n.captainProblem),
          ),
        ],
      ),
    );
  }
}

/// What the captain chose in «مشكلة».
enum _Problem { cannotComplete, report }

Future<void> _openProblem(
  BuildContext context,
  WidgetRef ref,
  ActiveOrder order,
) async {
  final chosen = await showModalBottomSheet<_Problem>(
    context: context,
    // The second captain of a handover does not have the order yet: only the
    // order's own captain can ask or report (CA §15).
    builder: (context) => _ProblemSheet(
      canAsk: order.cannotComplete == null && receiving(order) == null,
      canReport: receiving(order) == null,
    ),
  );
  if (chosen == null || !context.mounted) return;
  final l10n = AppLocalizations.of(context);
  final content = await readContent(context, ref);
  if (content == null || !context.mounted) return;
  if (chosen == _Problem.report) {
    await _report(context, ref, order, content);
    return;
  }
  final reason = await pickReason(
    context,
    title: l10n.captainCannotCompleteTitle,
    reasons: content.cannotComplete,
  );
  if (reason == null || !context.mounted) return;
  final notice = await ref
      .read(commandsProvider.notifier)
      .cannotComplete(order.id, reason);
  if (context.mounted) showNotice(context, notice);
}

/// CA §9.11 (slice 2.24c): a quick reason of Content's captain_problem list
/// opens a ticket on the order, urgent while it is active; «مشكلة في مبلغ
/// الاستلام» asks first for the lines the captain handed over and opens the
/// pickup dispute (CA §9.4 item 6), offered only while it can be.
Future<void> _report(
  BuildContext context,
  WidgetRef ref,
  ActiveOrder order,
  CaptainContent content,
) async {
  final l10n = AppLocalizations.of(context);
  final reason = await pickReason(
    context,
    title: l10n.captainProblemQuickReason,
    reasons: [
      for (final choice in content.problems)
        if (choice.code != pickupAmountReason || offersPickupAmount(order))
          choice,
    ],
  );
  if (reason == null || !context.mounted) return;
  final reports = ref.read(captainReportsProvider);
  final ReportOutcome outcome;
  if (reason.reason == pickupAmountReason) {
    final amount = await askPickupAmount(context, order);
    if (amount == null || !context.mounted) return;
    outcome = await reports.problem(
      orderId: order.id,
      reasonCode: reason.reason,
      note: amount.note,
      paidLines: amount.lines,
    );
  } else {
    outcome = await reports.problem(
      orderId: order.id,
      reasonCode: reason.reason,
      note: reason.note,
    );
  }
  if (!context.mounted) return;
  final text = switch (outcome) {
    ReportSent(:final ticket) => l10n.captainReportSent(
      ticket.number,
      l10n.formatReplyWithin(ticket.replyWithinMinutes),
    ),
    ReportTypeChanged() => l10n.captainReportTypeChanged,
    ReportOrderGone() => l10n.captainReportOrderGone,
    ReportClosed() => l10n.captainProblemClosed,
    PickupAlreadyDisputed() => l10n.captainPickupAmountDisputed,
    PickupAmountSame() => l10n.captainPickupAmountSame,
    ReportPhotoFailed() || ReportFailed() => l10n.captainReportFailed,
  };
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

/// «مشكلة»: call or WhatsApp operations (the support numbers, AP §9.13; a
/// missing one hides its button), and «لا أستطيع إكمال الطلب» for the
/// order's own captain while no request is open, and the report with a
/// quick reason for the order's own captain (slice 2.24c).
class _ProblemSheet extends ConsumerWidget {
  const _ProblemSheet({required this.canAsk, required this.canReport});

  final bool canAsk;
  final bool canReport;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final contact = ref.watch(captainAuth.contact).value;
    final launch = ref.read(captainAuth.launch);
    final phone = contact?.phone;
    final whatsapp = contact?.whatsapp;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.captainProblem),
            if (phone != null)
              OutlinedButton(
                onPressed: () => launch(Uri(scheme: 'tel', path: phone)),
                child: Text(l10n.signInCallOperations),
              ),
            if (whatsapp != null)
              OutlinedButton(
                onPressed: () => launch(
                  Uri.https(
                    'wa.me',
                    '/${whatsapp.replaceAll(RegExp(r'\D'), '')}',
                  ),
                ),
                child: Text(l10n.signInWhatsappOperations),
              ),
            if (canReport)
              OutlinedButton(
                key: const Key('problem-report'),
                onPressed: () => Navigator.of(context).pop(_Problem.report),
                child: Text(l10n.captainProblemQuickReason),
              ),
            if (canAsk)
              FilledButton(
                onPressed: () =>
                    Navigator.of(context).pop(_Problem.cannotComplete),
                child: Text(l10n.captainCannotComplete),
              ),
          ],
        ),
      ),
    );
  }
}
