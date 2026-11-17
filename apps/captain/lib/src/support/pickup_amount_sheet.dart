import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';

import '../work/door_payment.dart';
import '../work/work.dart';

/// What «مشكلة في مبلغ الاستلام» sends: the lines the captain handed over
/// and an optional note.
typedef PickupAmount = ({List<Money> lines, String? note});

/// Whether the order offers «مشكلة في مبلغ الاستلام» (CA §9.4 item 6, owner
/// decision 2026-11-17): after the pickup, while the order is active, to the
/// captain who paid, before anyone disputed it. The server checks the same.
bool offersPickupAmount(ActiveOrder order) =>
    order.pickup.pickedUpAt != null &&
    order.pickup.disputedAt == null &&
    order.pickup.request?.status == RequestStatus.confirmed &&
    receiving(order) == null;

/// The lines the captain handed the restaurant, one field per currency the
/// restaurant accepts, prefilled with those recorded at the pickup (owner
/// decision 2026-11-17), and a note; null when dismissed. Unstyled until the
/// design.
Future<PickupAmount?> askPickupAmount(
  BuildContext context,
  ActiveOrder order,
) => showModalBottomSheet<PickupAmount>(
  context: context,
  isScrollControlled: true,
  builder: (_) => _PickupAmountSheet(order: order),
);

class _PickupAmountSheet extends StatefulWidget {
  const _PickupAmountSheet({required this.order});

  final ActiveOrder order;

  @override
  State<_PickupAmountSheet> createState() => _PickupAmountSheetState();
}

class _PickupAmountSheetState extends State<_PickupAmountSheet> {
  late final Map<String, TextEditingController> _fields;
  final _note = TextEditingController();
  bool _invalid = false;

  List<Money> get _recorded => [
    for (final line in [...?widget.order.pickup.request?.lines])
      if (line != null) Money(line.amount, line.currency),
  ];

  @override
  void initState() {
    super.initState();
    final recorded = {for (final line in _recorded) line.currency: line.amount};
    final currencies = [
      for (final line in widget.order.pickup.currencies)
        if (line != null) line.currency,
      for (final currency in recorded.keys) currency,
    ];
    _fields = {
      for (final currency in currencies)
        currency: TextEditingController(
          text: switch (recorded[currency]) {
            final amount? => majorOf(amount),
            null => '',
          },
        ),
    };
  }

  @override
  void dispose() {
    for (final field in _fields.values) {
      field.dispose();
    }
    _note.dispose();
    super.dispose();
  }

  /// The typed lines, or null when one is not a positive amount or none is.
  List<Money>? _typed() {
    final lines = <Money>[];
    for (final MapEntry(key: currency, value: field) in _fields.entries) {
      if (field.text.trim().isEmpty) continue;
      final minor = minorOf(field.text);
      if (minor == null) return null;
      lines.add(Money(minor, currency));
    }
    return lines.isEmpty ? null : lines;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final recorded = _recorded
        .map((line) => l10n.formatMoney(line.amount, line.currency))
        .join(' + ');
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: 16,
        end: 16,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.captainPickupAmountTitle),
            Text(l10n.captainPickupAmountRecorded(recorded)),
            Text(l10n.captainPickupAmountHint),
            for (final MapEntry(key: currency, value: field) in _fields.entries)
              TextField(
                key: Key('paid-$currency'),
                controller: field,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(labelText: currency),
              ),
            if (_invalid) Text(l10n.captainPickupAmountInvalid),
            TextField(
              key: const Key('paid-note'),
              controller: _note,
              maxLength: 300,
              decoration: InputDecoration(labelText: l10n.captainReportNote),
            ),
            FilledButton(
              key: const Key('paid-send'),
              onPressed: () {
                final lines = _typed();
                if (lines == null) {
                  setState(() => _invalid = true);
                  return;
                }
                final note = _note.text.trim();
                Navigator.of(
                  context,
                ).pop((lines: lines, note: note.isEmpty ? null : note));
              },
              child: Text(l10n.captainReportSend),
            ),
          ],
        ),
      ),
    );
  }
}
