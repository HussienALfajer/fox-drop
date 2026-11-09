import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../content.dart';
import 'cancel_order.dart';

/// «إلغاء الطلب» while placed (CU §11.4): a reason from the self-cancel list
/// (AP Appendix B), the optional text of «سبب آخر», then «نعم، ألغِ الطلب».
/// Answers the outcome once the order is cancelled or the restaurant
/// accepted first; null when dismissed. Unstyled until the design.
Future<CancelOutcome?> showCancelOrder(BuildContext context, String orderId) =>
    showModalBottomSheet<CancelOutcome>(
      context: context,
      isScrollControlled: true,
      builder: (_) => CancelOrderSheet(orderId: orderId),
    );

class CancelOrderSheet extends ConsumerStatefulWidget {
  const CancelOrderSheet({super.key, required this.orderId});

  final String orderId;

  @override
  ConsumerState<CancelOrderSheet> createState() => _CancelOrderSheetState();
}

class _CancelOrderSheetState extends ConsumerState<CancelOrderSheet> {
  ReasonChoice? _chosen;
  final _note = TextEditingController();
  bool _sending = false;
  CancelOutcome? _problem;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  bool get _ready =>
      !_sending &&
      _chosen != null &&
      (!_chosen!.needsNote || _note.text.trim().isNotEmpty);

  Future<void> _send() async {
    final chosen = _chosen!;
    final note = _note.text.trim();
    setState(() {
      _sending = true;
      _problem = null;
    });
    final outcome = await ref
        .read(cancelOrderProvider(widget.orderId))
        .send(chosen.code, chosen.takesNote && note.isNotEmpty ? note : null);
    if (!mounted) return;
    switch (outcome) {
      case CancelOutcome.cancelled ||
          CancelOutcome.tooLate ||
          CancelOutcome.ended:
        Navigator.of(context).pop(outcome);
      case CancelOutcome.reasonChanged || CancelOutcome.failed:
        setState(() {
          _sending = false;
          _problem = outcome;
          if (outcome == CancelOutcome.reasonChanged) _chosen = null;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Keeps the command, and its key, while the sheet is open.
    ref.watch(cancelOrderProvider(widget.orderId));
    final content = ref.watch(contentProvider);
    final reasons = content.value?.cancelReasons ?? const <ReasonChoice>[];
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: 16,
        end: 16,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.customerCancelOrder),
          if (content.isLoading && !content.hasValue)
            const Center(child: CircularProgressIndicator()),
          // A failed read of Content is read again (AP §9.13).
          if (content.hasError && !content.hasValue)
            TextButton(
              key: const Key('cancel-reasons-retry'),
              onPressed: () => ref.invalidate(contentProvider),
              child: Text(l10n.contentFailed),
            ),
          RadioGroup<String>(
            groupValue: _chosen?.code,
            onChanged: (code) => setState(
              () => _chosen = reasons.firstWhere((r) => r.code == code),
            ),
            child: Column(
              children: [
                for (final reason in reasons)
                  RadioListTile<String>(
                    key: Key('cancel-reason-${reason.code}'),
                    value: reason.code,
                    title: Text(reason.label),
                  ),
              ],
            ),
          ),
          if (_chosen?.takesNote == true)
            TextField(
              key: const Key('cancel-note'),
              controller: _note,
              // The server's limit of a reason's text (Content's NOTE_MAX).
              maxLength: 300,
              decoration: InputDecoration(
                labelText: l10n.customerCancelReasonNote,
              ),
              onChanged: (_) => setState(() {}),
            ),
          if (_problem != null)
            Text(
              _problem == CancelOutcome.reasonChanged
                  ? l10n.customerCancelReasonsChanged
                  : l10n.customerCancelFailed,
              key: const Key('cancel-problem'),
            ),
          FilledButton(
            key: const Key('cancel-confirm'),
            onPressed: _ready ? _send : null,
            child: Text(l10n.customerCancelConfirm),
          ),
        ],
      ),
    );
  }
}
