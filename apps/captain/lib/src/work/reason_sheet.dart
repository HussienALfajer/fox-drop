import 'package:flutter/material.dart';
import 'package:core_l10n/core_l10n.dart';

import '../content.dart';
import 'door_payment.dart';

/// Picks a reason from a Content list (AP §9.13, CA Appendix C), with the
/// text of a reason that needs one («أخرى»); null when dismissed. Unstyled
/// until the design.
Future<Reason?> pickReason(
  BuildContext context, {
  required String title,
  required List<ReasonChoice> reasons,
}) {
  return showModalBottomSheet<Reason>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _ReasonSheet(title: title, reasons: reasons),
  );
}

class _ReasonSheet extends StatefulWidget {
  const _ReasonSheet({required this.title, required this.reasons});

  final String title;
  final List<ReasonChoice> reasons;

  @override
  State<_ReasonSheet> createState() => _ReasonSheetState();
}

class _ReasonSheetState extends State<_ReasonSheet> {
  ReasonChoice? _chosen;
  final _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  bool get _ready =>
      _chosen != null && (!_chosen!.needsText || _note.text.trim().isNotEmpty);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
          Text(widget.title),
          RadioGroup<String>(
            groupValue: _chosen?.code,
            onChanged: (code) => setState(
              () => _chosen = widget.reasons.firstWhere((r) => r.code == code),
            ),
            child: Column(
              children: [
                for (final reason in widget.reasons)
                  RadioListTile<String>(
                    value: reason.code,
                    title: Text(reason.label),
                  ),
              ],
            ),
          ),
          if (_chosen?.needsText == true)
            TextField(
              key: const Key('reason-note'),
              controller: _note,
              maxLength: 200,
              decoration: InputDecoration(labelText: l10n.captainOtherHint),
              onChanged: (_) => setState(() {}),
            ),
          FilledButton(
            onPressed: _ready
                ? () => Navigator.of(context).pop(
                    Reason(
                      _chosen!.code,
                      _chosen!.needsText ? _note.text.trim() : null,
                    ),
                  )
                : null,
            child: Text(l10n.captainSend),
          ),
        ],
      ),
    );
  }
}
