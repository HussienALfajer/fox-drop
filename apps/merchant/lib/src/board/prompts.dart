import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'board.dart';
import 'commands.dart';
import 'dispute_sheet.dart';
import 'texts.dart';

/// The stacked prompts of what rings, oldest first, with a counter (RA
/// §4.4). Only a decision closes one; opening the detail does not.
class RingingPrompt extends StatelessWidget {
  const RingingPrompt({
    super.key,
    required this.items,
    required this.board,
    required this.now,
  });

  final List<Ringing> items;
  final Board board;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final first = items.first;
    return Material(
      key: const Key('ringing-prompt'),
      child: ListView(
        padding: const EdgeInsetsDirectional.all(16),
        children: [
          if (items.length > 1) Text(l10n.merchantPromptCount(1, items.length)),
          switch (first) {
            NewOrderRinging(:final order) => NewOrderPrompt(
              key: ValueKey('new-${order.id}'),
              order: order,
              board: board,
              now: now,
            ),
            PickupRinging(:final order, :final request) => PickupPrompt(
              key: ValueKey('pickup-${request.id}'),
              order: order,
              request: request,
              now: now,
            ),
          },
        ],
      ),
    );
  }
}

/// RA §8.3: «طلب جديد #{رقم}», the items with their options and notes, the
/// customer note, the items value, the auto-cancel countdown and the
/// prep-time chooser with «قبول — {د} د». «رفض» comes with reject (RA §8.6).
class NewOrderPrompt extends ConsumerStatefulWidget {
  const NewOrderPrompt({
    super.key,
    required this.order,
    required this.board,
    required this.now,
  });

  final BoardOrder order;
  final Board board;
  final DateTime now;

  @override
  ConsumerState<NewOrderPrompt> createState() => _NewOrderPromptState();
}

class _NewOrderPromptState extends ConsumerState<NewOrderPrompt> {
  late int _prep = clampPrep(
    widget.board.prepTime,
    widget.board.prepTime.defaultMin,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final order = widget.order;
    final prep = widget.board.prepTime;
    final sending = ref.watch(boardCommandsProvider).contains(order.id);
    final timer = columnTimer(l10n, order, widget.now);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.merchantNewOrder(order.number),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        for (final line in order.lines)
          ListTile(
            title: Text('${line.quantity} × ${line.name}'),
            subtitle: line.options.isEmpty && line.note == null
                ? null
                : Text(
                    [
                      if (line.options.isNotEmpty)
                        line.options.map((o) => o.name).join('، '),
                      ?line.note,
                    ].join('\n'),
                  ),
          ),
        if (order.note != null)
          ListTile(title: Text(l10n.merchantCustomerNote(order.note!))),
        ListTile(
          title: Text(
            l10n.merchantItemsValueOnPickup(
              l10n.formatMoney(order.itemsValue, order.currency),
            ),
          ),
        ),
        ?timer == null ? null : ListTile(title: Text(timer)),
        if (isLate(order, widget.now))
          ListTile(title: Text(l10n.merchantLateReply)),
        // RA §8.5: chips, «−» and «+» in steps, within the floor and ceiling.
        Wrap(
          spacing: 8,
          children: [
            for (final minutes in prep.options)
              ChoiceChip(
                label: Text(l10n.durationMinutes(minutes)),
                selected: _prep == minutes,
                onSelected: sending
                    ? null
                    : (_) => setState(() => _prep = clampPrep(prep, minutes)),
              ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              key: const Key('prep-minus'),
              icon: const Icon(Icons.remove),
              onPressed: sending || _prep <= prep.floorMin
                  ? null
                  : () => setState(
                      () => _prep = clampPrep(prep, _prep - prep.stepMin),
                    ),
            ),
            Text(l10n.durationMinutes(_prep)),
            IconButton(
              key: const Key('prep-plus'),
              icon: const Icon(Icons.add),
              onPressed: sending || _prep >= prep.ceilingMin
                  ? null
                  : () => setState(
                      () => _prep = clampPrep(prep, _prep + prep.stepMin),
                    ),
            ),
          ],
        ),
        FilledButton(
          key: const Key('accept'),
          onPressed: sending
              ? null
              : () => _run(
                  ref
                      .read(boardCommandsProvider.notifier)
                      .accept(order.id, _prep),
                ),
          child: Text(
            sending ? l10n.merchantSending : l10n.merchantAccept(_prep),
          ),
        ),
      ],
    );
  }

  Future<void> _run(Future<CommandNotice?> command) async {
    final notice = await command;
    if (notice != null && mounted) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(commandText(l10n, notice))));
    }
  }
}

/// RA §8.10 item 3: «الكابتن {الاسم} يؤكد أنه دفع لك {المبلغ} واستلم الطلب
/// #{رقم}», the payment lines with their base equivalent, «تأكيد الاستلام»,
/// «المبلغ غير صحيح», «الطلب غير مكتمل» and the automatic confirmation's
/// countdown. The captain's photo comes with the object storage.
class PickupPrompt extends ConsumerWidget {
  const PickupPrompt({
    super.key,
    required this.order,
    required this.request,
    required this.now,
  });

  final BoardOrder order;
  final PickupRequest request;
  final DateTime now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final sending = ref.watch(boardCommandsProvider).contains(order.id);
    final commands = ref.read(boardCommandsProvider.notifier);
    final lines = requestLines(request);
    final amount = request.amount;
    Future<void> run(Future<CommandNotice?> command) async {
      final notice = await command;
      if (notice != null && context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(commandText(l10n, notice))));
      }
    }

    final left = request.confirmBy.difference(now);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.merchantPickupPrompt(
            order.captain?.firstName ?? '',
            amount == null
                ? paymentLinesText(l10n, lines)
                : l10n.formatMoney(amount.amount, amount.currency),
            order.number,
          ),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        ListTile(
          title: Text(paymentLinesText(l10n, lines)),
          subtitle: Text(
            l10n.merchantBaseEquivalent(
              l10n.formatMoney(request.baseEquivalent, order.currency),
            ),
          ),
        ),
        ListTile(
          title: Text(
            l10n.merchantAutoConfirmIn(left.isNegative ? 0 : left.inSeconds),
          ),
        ),
        FilledButton(
          key: const Key('confirm-pickup'),
          onPressed: sending
              ? null
              : () => run(commands.confirmPickup(order.id, request.id)),
          child: Text(
            sending ? l10n.merchantSending : l10n.merchantConfirmPickup,
          ),
        ),
        OutlinedButton(
          key: const Key('amount-incorrect'),
          onPressed: sending
              ? null
              : () async {
                  final received = await showDisputeSheet(context, lines);
                  if (received == null) return;
                  await run(
                    commands.disputePickup(order.id, request.id, received),
                  );
                },
          child: Text(l10n.merchantAmountIncorrect),
        ),
        TextButton(
          key: const Key('order-incomplete'),
          onPressed: sending
              ? null
              : () => run(commands.incomplete(order.id, request.id)),
          child: Text(l10n.merchantOrderIncomplete),
        ),
      ],
    );
  }
}
