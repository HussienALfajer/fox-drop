import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../media_image.dart';
import 'cart.dart';
import 'item_choice.dart';

/// Opens the item sheet (CU §9.4). With [line] and [lineIndex] it edits that
/// cart line («تعديل», CU §10.1). [blocked] is the message that keeps the
/// add button off (CU §9.2), or null.
Future<void> showItemSheet(
  BuildContext context, {
  required String restaurantId,
  required String restaurantName,
  required MenuItem item,
  String? blocked,
  CartLine? line,
  int? lineIndex,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  builder: (context) => ItemSheet(
    restaurantId: restaurantId,
    restaurantName: restaurantName,
    item: item,
    blocked: blocked,
    line: line,
    lineIndex: lineIndex,
  ),
);

class ItemSheet extends ConsumerStatefulWidget {
  const ItemSheet({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
    required this.item,
    this.blocked,
    this.line,
    this.lineIndex,
  });

  final String restaurantId;
  final String restaurantName;
  final MenuItem item;
  final String? blocked;
  final CartLine? line;
  final int? lineIndex;

  @override
  ConsumerState<ItemSheet> createState() => _ItemSheetState();
}

class _ItemSheetState extends ConsumerState<ItemSheet> {
  late final ItemChoice _choice = widget.line == null
      ? ItemChoice(widget.item)
      : ItemChoice.ofLine(widget.item, widget.line!);
  late final _note = TextEditingController(text: _choice.note);
  final _groupKeys = <String, GlobalKey>{};
  final _highlighted = <String>{};

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  /// «اختر {العدد}», «اختر حتى {العدد}» or «اختر من {أ} إلى {ب}», after
  /// «إجباري» for a required group.
  String _rule(AppLocalizations l10n, OptionGroup group) {
    final count = group.minChoices == group.maxChoices
        ? l10n.customerChoose(group.maxChoices)
        : group.minChoices == 0
        ? l10n.customerChooseUpTo(group.maxChoices)
        : l10n.customerChooseBetween(group.minChoices, group.maxChoices);
    return group.minChoices > 0 ? '${l10n.customerRequired} · $count' : count;
  }

  Future<void> _add() async {
    final incomplete = _choice.incompleteGroups;
    if (incomplete.isNotEmpty) {
      setState(() {
        _highlighted
          ..clear()
          ..addAll(incomplete.map((group) => group.id));
      });
      final target = _groupKeys[incomplete.first.id]?.currentContext;
      if (target != null) await Scrollable.ensureVisible(target);
      return;
    }
    if (_choice.noteTooLong || _choice.noteHasPhone) return;
    final cart = ref.read(cartProvider.notifier);
    final line = _choice.toLine();
    final index = widget.lineIndex;
    if (index != null) {
      await cart.replace(index, line);
    } else {
      final added = await cart.add(
        widget.restaurantId,
        widget.restaurantName,
        line,
      );
      if (added == CartAdd.otherRestaurant) {
        if (!mounted) return;
        final current = ref.read(cartProvider).value?.cart;
        final startNew = await showDialog<bool>(
          context: context,
          builder: (context) {
            final l10n = AppLocalizations.of(context);
            return AlertDialog(
              content: Text(
                l10n.customerCartOtherRestaurant(
                  current?.restaurantName ?? '',
                  widget.restaurantName,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(l10n.customerCancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(l10n.customerNewCart),
                ),
              ],
            );
          },
        );
        if (startNew != true) return;
        await cart.startNew(widget.restaurantId, widget.restaurantName, line);
      }
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final item = widget.item;
    final currency = item.price!.currency;
    final noteError = _choice.noteHasPhone
        ? l10n.customerNoPhoneInNote
        : _choice.noteTooLong
        ? l10n.customerNoteTooLong(maxItemNote)
        : null;
    return SafeArea(
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            if (item.photoKey case final photo?)
              MediaImage(
                imageKey: photo,
                width: MediaQuery.sizeOf(context).width,
                height: 200,
                label: item.name,
              ),
            ListTile(
              title: Text(item.name),
              subtitle: Text(
                [
                  ?item.description,
                  l10n.formatMoney(item.price!.amount, currency),
                ].join('\n'),
              ),
            ),
            for (final group in item.optionGroups) ...[
              ListTile(
                key: _groupKeys.putIfAbsent(group.id, GlobalKey.new),
                title: Text(group.name),
                subtitle: Text(
                  _highlighted.contains(group.id) &&
                          _choice.chosen[group.id]!.length < group.minChoices
                      ? l10n.customerChooseAtLeast(group.minChoices)
                      : _rule(l10n, group),
                ),
              ),
              for (final option in group.options)
                CheckboxListTile(
                  key: Key('option-${option.id}'),
                  value: _choice.chosen[group.id]!.contains(option.id),
                  onChanged: option.available
                      ? (_) => setState(() => _choice.toggle(group, option.id))
                      : null,
                  title: Text(option.name),
                  subtitle: Text(
                    [
                      if (BigInt.parse(option.priceDelta!.amount) !=
                          BigInt.zero)
                        '+${l10n.formatMoney(option.priceDelta!.amount, option.priceDelta!.currency)}',
                      if (!option.available) l10n.customerUnavailable,
                    ].join(' · '),
                  ),
                ),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  key: const Key('item-less'),
                  onPressed: _choice.quantity > 1
                      ? () => setState(() => _choice.quantity--)
                      : null,
                  icon: const Icon(Icons.remove),
                ),
                Text('${_choice.quantity}'),
                IconButton(
                  key: const Key('item-more'),
                  onPressed: _choice.quantity < maxQuantity
                      ? () => setState(() => _choice.quantity++)
                      : null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
              child: TextField(
                key: const Key('item-note'),
                controller: _note,
                maxLength: maxItemNote,
                decoration: InputDecoration(
                  hintText: l10n.customerItemNoteHint,
                  errorText: noteError,
                ),
                onChanged: (value) => setState(() => _choice.note = value),
              ),
            ),
            if (widget.blocked case final message?)
              ListTile(title: Text(message)),
            Padding(
              padding: const EdgeInsetsDirectional.all(16),
              child: FilledButton(
                key: const Key('item-add'),
                onPressed: widget.blocked == null ? _add : null,
                child: Text(
                  l10n.customerAddFor(
                    l10n.formatMoney(_choice.linePrice, currency),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
