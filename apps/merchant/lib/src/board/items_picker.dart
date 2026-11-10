import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';

import 'board.dart';

/// The order's items to switch off, each «حتى الغد» (true, the default) or
/// «حتى أعيده» (false): the «صنف غير متوفر» part of the reject sheet (RA
/// §8.6) and the item-unavailable report (RA §8.12). [picked] is the
/// caller's state; [onChanged] gives the new one. [keyPrefix] names the
/// widgets for tests.
class UnavailableItemsPicker extends StatelessWidget {
  const UnavailableItemsPicker({
    super.key,
    required this.order,
    required this.picked,
    required this.onChanged,
    required this.keyPrefix,
  });

  final BoardOrder order;
  final Map<String, bool> picked;
  final ValueChanged<Map<String, bool>> onChanged;
  final String keyPrefix;

  void _set(String itemId, bool? until) {
    final next = {...picked};
    if (until == null) {
      next.remove(itemId);
    } else {
      next[itemId] = until;
    }
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // The order's items, each once, by the line that names it first.
    final items = <String, String>{
      for (final line in order.lines.reversed) line.itemId: line.name,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(title: Text(l10n.merchantRejectPickItems)),
        for (final MapEntry(key: itemId, value: name) in items.entries) ...[
          CheckboxListTile(
            key: Key('$keyPrefix-item-$itemId'),
            value: picked.containsKey(itemId),
            onChanged: (on) => _set(itemId, (on ?? false) ? true : null),
            title: Text(name),
          ),
          if (picked.containsKey(itemId))
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 32),
              child: Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    key: Key('$keyPrefix-tomorrow-$itemId'),
                    label: Text(l10n.merchantRejectUntilTomorrow),
                    selected: picked[itemId]!,
                    onSelected: (_) => _set(itemId, true),
                  ),
                  ChoiceChip(
                    key: Key('$keyPrefix-back-on-$itemId'),
                    label: Text(l10n.merchantRejectUntilTurnedBackOn),
                    selected: !picked[itemId]!,
                    onSelected: (_) => _set(itemId, false),
                  ),
                ],
              ),
            ),
        ],
      ],
    );
  }
}
