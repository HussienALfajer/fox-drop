import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import 'commands.dart';
import 'order_view.dart';
import 'texts.dart';
import 'work.dart';

/// CA §9.9 (slice 2.13d; owner decisions 2026-11-11): at the door,
/// «تنبيه الزبون» while allowed with the pings left and the next allowed
/// time, the customer's latest answer, «الزبون لا يستجيب» once the server's
/// `reportableAt` passed (the time it appears before), then «العمليات تراجع
/// الطلب — انتظر تعليماتهم» until operations' «انتظر» with its message.
/// The times are the server's; the screen ticks so the buttons enable on
/// time. The payment stays below: the customer may appear meanwhile.
class DoorPanel extends ConsumerWidget {
  const DoorPanel({super.key, required this.order});

  final ActiveOrder order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final door = order.noAnswer;
    if (door == null) return const SizedBox.shrink();
    ref.watch(tickProvider);
    final l10n = AppLocalizations.of(context);
    final now = ref.watch(serverClockProvider).now();
    final sending = ref.watch(commandsProvider).contains(order.id);
    final commands = ref.read(commandsProvider.notifier);
    final next = door.nextPingAt;
    final pingNow = next != null && !now.isBefore(next);
    final reportableAt = door.reportableAt;
    final report = door.report;
    final answer = door.answer;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton(
          key: const Key('ping-customer'),
          onPressed: pingNow && !sending
              ? () async {
                  final notice = await commands.pingCustomer(order.id);
                  if (context.mounted) showNotice(context, notice);
                }
              : null,
          child: Text(l10n.captainPingCustomer),
        ),
        Text(l10n.captainPingsLeft('${door.pingsLeft}')),
        if (next != null && !pingNow)
          Text(l10n.captainNextPingAt(l10n.formatTime(next))),
        if (answer != null)
          Text(
            key: const Key('customer-answer'),
            l10n.pingAnswerText(answer.answer),
          ),
        if (report != null && report.waitedAt == null)
          Text(
            key: const Key('operations-reviewing'),
            l10n.captainOperationsReviewing,
          )
        else if (report?.waitMessage case final message?)
          Card(
            key: const Key('operations-wait'),
            child: Padding(
              padding: const EdgeInsetsDirectional.all(12),
              child: Text(l10n.captainOperationsWait(message)),
            ),
          ),
        if (reportableAt != null)
          if (now.isBefore(reportableAt))
            Text(l10n.captainNoAnswerAt(l10n.formatTime(reportableAt)))
          else
            OutlinedButton(
              key: const Key('customer-not-answering'),
              onPressed: sending
                  ? null
                  : () async {
                      final notice = await commands.reportNoAnswer(order.id);
                      if (context.mounted) showNotice(context, notice);
                    },
              child: Text(l10n.captainCustomerNotAnswering),
            ),
      ],
    );
  }
}
