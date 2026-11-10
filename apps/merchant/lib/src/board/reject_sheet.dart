import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';

import 'board.dart';
import 'commands.dart';
import 'items_picker.dart';
import 'texts.dart';

/// RA §8.6: «رفض» with one of the three reasons and its step: the order's
/// items for «صنف غير متوفر», each «حتى الغد» (the default) or «حتى أعيده»;
/// the note of «المطعم مغلق»; for «ضغط طلبات» optionally busy mode with one
/// of [busyOptions] or «إيقاف 30 د». [labels] are Content's active reasons
/// (null when they could not be read: the three built-in ones). Null when
/// closed without rejecting.
Future<Rejection?> showRejectSheet(
  BuildContext context,
  BoardOrder order,
  List<int> busyOptions,
  Map<String, String>? labels,
) => showModalBottomSheet<Rejection>(
  context: context,
  isScrollControlled: true,
  builder: (context) =>
      _RejectSheet(order: order, busyOptions: busyOptions, labels: labels),
);

class _RejectSheet extends StatefulWidget {
  const _RejectSheet({
    required this.order,
    required this.busyOptions,
    required this.labels,
  });

  final BoardOrder order;
  final List<int> busyOptions;
  final Map<String, String>? labels;

  @override
  State<_RejectSheet> createState() => _RejectSheetState();
}

class _RejectSheetState extends State<_RejectSheet> {
  RejectReason? _reason;
  // The picked items: true «حتى الغد», false «حتى أعيده».
  Map<String, bool> _items = const {};
  TooBusyStep _step = const RejectOnly();

  Rejection? get _rejection {
    final reason = _reason;
    if (reason == null) return null;
    final rejection = Rejection(
      reason,
      items: reason == RejectReason.itemUnavailable ? {..._items} : const {},
      step: reason == RejectReason.tooBusy ? _step : const RejectOnly(),
    );
    return rejection.complete ? rejection : null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final rejection = _rejection;
    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsetsDirectional.all(16),
        children: [
          Text(
            l10n.merchantRejectTitle(widget.order.number),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          RadioGroup<RejectReason>(
            groupValue: _reason,
            onChanged: (value) => setState(() => _reason = value),
            child: Column(
              children: [
                // A reason deactivated in Content is not offered.
                for (final reason in RejectReason.values)
                  if (widget.labels == null ||
                      widget.labels!.containsKey(reason.code))
                    RadioListTile<RejectReason>(
                      key: Key('reject-${reason.code}'),
                      value: reason,
                      title: Text(
                        rejectReasonText(l10n, reason.code, widget.labels),
                      ),
                    ),
              ],
            ),
          ),
          if (_reason == RejectReason.itemUnavailable)
            UnavailableItemsPicker(
              order: widget.order,
              picked: _items,
              onChanged: (items) => setState(() => _items = items),
              keyPrefix: 'reject',
            ),
          if (_reason == RejectReason.restaurantClosed)
            ListTile(title: Text(l10n.merchantRejectClosedNote)),
          if (_reason == RejectReason.tooBusy)
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  key: const Key('reject-only'),
                  label: Text(l10n.merchantRejectNothingElse),
                  selected: _step is RejectOnly,
                  onSelected: (_) => setState(() => _step = const RejectOnly()),
                ),
                for (final minutes in widget.busyOptions)
                  ChoiceChip(
                    key: Key('reject-busy-$minutes'),
                    label: Text(l10n.merchantRejectBusyMode(minutes)),
                    selected: switch (_step) {
                      BusyModeStep(:final extraMin) => extraMin == minutes,
                      _ => false,
                    },
                    onSelected: (_) =>
                        setState(() => _step = BusyModeStep(minutes)),
                  ),
                ChoiceChip(
                  key: const Key('reject-pause'),
                  label: Text(l10n.merchantRejectPause(tooBusyPauseMin)),
                  selected: _step is PauseStep,
                  onSelected: (_) => setState(() => _step = const PauseStep()),
                ),
              ],
            ),
          const SizedBox(height: 16),
          FilledButton(
            key: const Key('reject-confirm'),
            onPressed: rejection == null
                ? null
                : () => Navigator.of(context).pop(rejection),
            child: Text(l10n.merchantRejectConfirm),
          ),
        ],
      ),
    );
  }
}
