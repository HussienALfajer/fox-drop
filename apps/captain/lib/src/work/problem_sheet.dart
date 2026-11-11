import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth.dart';
import '../content.dart';
import 'commands.dart';
import 'order_view.dart';
import 'reason_sheet.dart';
import 'work.dart';

/// CA §9.11 (slice 2.13b): above every step of the active order, «مشكلة»
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
enum _Problem { cannotComplete }

Future<void> _openProblem(
  BuildContext context,
  WidgetRef ref,
  ActiveOrder order,
) async {
  final chosen = await showModalBottomSheet<_Problem>(
    context: context,
    // The second captain of a handover does not have the order yet: only the
    // order's own captain can ask (CA §15).
    builder: (context) => _ProblemSheet(
      canAsk: order.cannotComplete == null && receiving(order) == null,
    ),
  );
  if (chosen != _Problem.cannotComplete || !context.mounted) return;
  final l10n = AppLocalizations.of(context);
  final content = await readContent(context, ref);
  if (content == null || !context.mounted) return;
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

/// «مشكلة»: call or WhatsApp operations (the support numbers, AP §9.13; a
/// missing one hides its button), and «لا أستطيع إكمال الطلب» for the
/// order's own captain while no request is open. The report with a quick reason waits for slice 2.24.
class _ProblemSheet extends ConsumerWidget {
  const _ProblemSheet({required this.canAsk});

  final bool canAsk;

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
