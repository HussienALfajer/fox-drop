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

  Future<void> _report(Reason reason) async {
    final l10n = AppLocalizations.of(context);
    String? note;
    if (reason.noteRequired) {
      note = await _askNote(reason.label);
      if (note == null || !mounted) return;
    }
    setState(() => _sending = true);
    final outcome = await ref
        .read(merchantReportsProvider)
        .orderProblem(
          orderId: widget.orderId,
          reasonCode: reason.code,
          note: note,
        );
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

  /// A reason whose text Content requires (AP §9.13) asks for it first.
  Future<String?> _askNote(String label) => showDialog<String>(
    context: context,
    builder: (context) => _NoteDialog(label: label),
  );

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
                  onTap: () => _report(reason),
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

class _NoteDialog extends StatefulWidget {
  const _NoteDialog({required this.label});

  final String label;

  @override
  State<_NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<_NoteDialog> {
  final _text = TextEditingController();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final note = _text.text.trim();
    return AlertDialog(
      title: Text(widget.label),
      content: TextField(
        key: const Key('problem-note'),
        controller: _text,
        maxLength: 300,
        decoration: InputDecoration(labelText: l10n.merchantReportNote),
        onChanged: (_) => setState(() {}),
      ),
      actions: [
        TextButton(
          key: const Key('problem-note-send'),
          onPressed: note.isEmpty
              ? null
              : () => Navigator.of(context).pop(note),
          child: Text(l10n.merchantReportSend),
        ),
      ],
    );
  }
}
