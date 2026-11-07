import 'package:flutter/material.dart';
import 'package:core_l10n/core_l10n.dart';

import 'door_payment.dart';

/// Picks a reason from a list of CA Appendix C, with the text of «أخرى»;
/// null when dismissed. Unstyled until the design.
Future<Reason?> pickReason(
  BuildContext context, {
  required String title,
  required List<String> reasons,
  required String Function(String reason) label,
}) {
  return showModalBottomSheet<Reason>(
    context: context,
    isScrollControlled: true,
    builder: (context) =>
        _ReasonSheet(title: title, reasons: reasons, label: label),
  );
}

class _ReasonSheet extends StatefulWidget {
  const _ReasonSheet({
    required this.title,
    required this.reasons,
    required this.label,
  });

  final String title;
  final List<String> reasons;
  final String Function(String reason) label;

  @override
  State<_ReasonSheet> createState() => _ReasonSheetState();
}

class _ReasonSheetState extends State<_ReasonSheet> {
  String? _chosen;
  final _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  bool get _ready =>
      _chosen != null && (_chosen != 'other' || _note.text.trim().isNotEmpty);

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
            groupValue: _chosen,
            onChanged: (value) => setState(() => _chosen = value),
            child: Column(
              children: [
                for (final reason in widget.reasons)
                  RadioListTile<String>(
                    value: reason,
                    title: Text(widget.label(reason)),
                  ),
              ],
            ),
          ),
          if (_chosen == 'other')
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
                      _chosen!,
                      _chosen == 'other' ? _note.text.trim() : null,
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
