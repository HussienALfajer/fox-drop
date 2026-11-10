import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';

import 'board.dart';
import 'commands.dart';
import 'items_picker.dart';
import 'texts.dart';

/// RA §8.12: «صنف غير متوفر — اتصلوا بالزبون» asks for the order's items,
/// each «حتى الغد» (the default) or «حتى أعيده», and an optional note from
/// [notes], Content's `item_unavailable_note` list (null when it could not
/// be read: the built-in ones). Null when closed without sending.
Future<ItemReport?> showItemReportSheet(
  BuildContext context,
  BoardOrder order,
  Map<String, String>? notes,
) => showModalBottomSheet<ItemReport>(
  context: context,
  isScrollControlled: true,
  builder: (context) => _ItemReportSheet(order: order, notes: notes),
);

class _ItemReportSheet extends StatefulWidget {
  const _ItemReportSheet({required this.order, required this.notes});

  final BoardOrder order;
  final Map<String, String>? notes;

  @override
  State<_ItemReportSheet> createState() => _ItemReportSheetState();
}

class _ItemReportSheetState extends State<_ItemReportSheet> {
  Map<String, bool> _items = const {};
  String? _note;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final report = ItemReport({..._items}, note: _note);
    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsetsDirectional.all(16),
        children: [
          Text(
            l10n.merchantItemReportTitle(widget.order.number),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          UnavailableItemsPicker(
            order: widget.order,
            picked: _items,
            onChanged: (items) => setState(() => _items = items),
            keyPrefix: 'report',
          ),
          ListTile(title: Text(l10n.merchantItemReportNote)),
          Wrap(
            spacing: 8,
            children: [
              // Optional: a second tap clears it.
              for (final MapEntry(key: code, value: label)
                  in itemReportNoteLabels(l10n, widget.notes).entries)
                ChoiceChip(
                  key: Key('report-note-$code'),
                  label: Text(label),
                  selected: _note == code,
                  onSelected: (on) => setState(() => _note = on ? code : null),
                ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton(
            key: const Key('report-confirm'),
            onPressed: report.complete
                ? () => Navigator.of(context).pop(report)
                : null,
            child: Text(l10n.merchantItemReportSend),
          ),
        ],
      ),
    );
  }
}
