import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../support/report_photo.dart';
import 'menu.dart';
import 'texts.dart';

/// RA §9.5: a row's pending requests: «بانتظار المراجعة», what each asks,
/// and for owners «سحب الطلب». Unstyled until the design.
class PendingLines extends ConsumerWidget {
  const PendingLines({
    required this.menu,
    required this.pending,
    required this.owner,
    super.key,
  });

  final Menu menu;
  final Iterable<Pending> pending;
  final bool owner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (pending.isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final commands = ref.read(menuCommandsProvider);
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 16, end: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.merchantMenuPendingReview),
          for (final each in pending)
            Row(
              children: [
                Expanded(
                  child: Text(
                    pendingText(l10n, each, (id) => itemNameOf(menu, id)),
                  ),
                ),
                if (owner)
                  TextButton(
                    key: Key('withdraw-${each.requestId}'),
                    onPressed: () => reportRequest(
                      context,
                      commands.withdraw(each.requestId),
                    ),
                    child: Text(l10n.merchantMenuWithdraw),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

/// An item's name by its id, new items included.
String itemNameOf(Menu menu, String id) {
  for (final category in menu.categories) {
    for (final item in category.items) {
      if (item.id == id) return item.name;
    }
  }
  return '';
}

/// Shows a request's refusal once the command answered.
Future<void> reportRequest(
  BuildContext context,
  Future<MenuRefusal?> command,
) async {
  final messenger = ScaffoldMessenger.of(context);
  final l10n = AppLocalizations.of(context);
  final refusal = await command;
  if (refusal == null) return;
  messenger.showSnackBar(
    SnackBar(content: Text(refusalText(l10n, refusal, request: true))),
  );
}

/// A new category or a name (RA §9.2): the name typed, null when cancelled.
Future<String?> askName(
  BuildContext context, {
  required String title,
  String initial = '',
}) => showDialog<String>(
  context: context,
  builder: (context) => _TextDialog(title: title, initial: initial),
);

class _TextDialog extends StatefulWidget {
  const _TextDialog({required this.title, required this.initial});

  final String title;
  final String initial;

  @override
  State<_TextDialog> createState() => _TextDialogState();
}

class _TextDialogState extends State<_TextDialog> {
  late final _name = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            key: const Key('request-name'),
            controller: _name,
            maxLength: 80,
            decoration: InputDecoration(labelText: l10n.merchantMenuName),
          ),
          Text(l10n.merchantMenuReviewNote),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.merchantMenuCancel),
        ),
        TextButton(
          key: const Key('request-send'),
          onPressed: () {
            final name = _name.text.trim();
            if (name.isNotEmpty) Navigator.of(context).pop(name);
          },
          child: Text(l10n.merchantMenuSendForReview),
        ),
      ],
    );
  }
}

/// Picks an item's photo: the camera or the gallery on Android, a file on
/// Windows.
Future<ItemPhoto?> pickItemPhoto(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  var source = PhotoSource.gallery;
  if (cameraAvailable) {
    final chosen = await showModalBottomSheet<PhotoSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              key: const Key('photo-camera'),
              title: Text(l10n.merchantMenuPhotoCamera),
              onTap: () => Navigator.of(context).pop(PhotoSource.camera),
            ),
            ListTile(
              key: const Key('photo-gallery'),
              title: Text(l10n.merchantMenuPhotoGallery),
              onTap: () => Navigator.of(context).pop(PhotoSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (chosen == null) return null;
    source = chosen;
  }
  final picked = await ref.read(photoPickerProvider)(source);
  return picked == null ? null : ItemPhoto(picked);
}

/// A new item, or the one waiting for review (`item`), as a request (RA
/// §9.2: its price is part of it).
Future<void> editNewItem(
  BuildContext context,
  WidgetRef ref, {
  required MenuCategory category,
  required String currency,
  MenuItem? item,
}) async {
  final asked = await showDialog<NewItem>(
    context: context,
    builder: (context) =>
        _ItemDialog(categoryId: category.id, currency: currency, item: item),
  );
  if (asked == null || !context.mounted) return;
  await reportRequest(
    context,
    ref
        .read(menuCommandsProvider)
        .requestNewItem(item?.id ?? ref.read(newMenuIdProvider)(), asked),
  );
}

class _ItemDialog extends ConsumerStatefulWidget {
  const _ItemDialog({
    required this.categoryId,
    required this.currency,
    this.item,
  });

  final String categoryId;
  final String currency;
  final MenuItem? item;

  @override
  ConsumerState<_ItemDialog> createState() => _ItemDialogState();
}

class _ItemDialogState extends ConsumerState<_ItemDialog> {
  late final _name = TextEditingController(text: widget.item?.name ?? '');
  late final _description = TextEditingController(
    text: widget.item?.description ?? '',
  );
  late final _price = TextEditingController();
  ItemPhoto? _photo;
  bool _invalid = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final item = widget.item;
    if (item != null && _price.text.isEmpty) {
      _price.text = typedOf(
        item.price.amount,
        item.price.currency,
        AppLocalizations.of(context),
      );
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(
        widget.item == null
            ? l10n.merchantMenuAddItem
            : l10n.merchantMenuEditRequest,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              key: const Key('item-name'),
              controller: _name,
              maxLength: 80,
              decoration: InputDecoration(labelText: l10n.merchantMenuName),
            ),
            TextField(
              key: const Key('item-description'),
              controller: _description,
              maxLength: 300,
              decoration: InputDecoration(
                labelText: l10n.merchantMenuDescription,
              ),
            ),
            // RA §9.4: price parity.
            Text(l10n.merchantMenuParityReminder),
            TextField(
              key: const Key('item-price'),
              controller: _price,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: l10n.merchantMenuPrice,
                suffixText: l10n.currencySymbol(widget.currency),
                errorText: _invalid ? l10n.merchantMenuInvalidPrice : null,
              ),
            ),
            TextButton(
              key: const Key('item-photo'),
              onPressed: () async {
                final photo = await pickItemPhoto(context, ref);
                if (photo != null) setState(() => _photo = photo);
              },
              child: Text(
                _photo == null
                    ? l10n.merchantMenuChoosePhoto
                    : l10n.merchantMenuPhotoChosen,
              ),
            ),
            Text(l10n.merchantMenuReviewNote),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.merchantMenuCancel),
        ),
        TextButton(
          key: const Key('item-send'),
          onPressed: () {
            final price = minorOfTyped(_price.text, widget.currency);
            final name = _name.text.trim();
            if (price == null || name.isEmpty) {
              setState(() => _invalid = price == null);
              return;
            }
            final description = _description.text.trim();
            Navigator.of(context).pop(
              NewItem(
                categoryId: widget.categoryId,
                name: name,
                description: description.isEmpty ? null : description,
                price: price,
                currency: widget.currency,
                photo: _photo,
              ),
            );
          },
          child: Text(l10n.merchantMenuSendForReview),
        ),
      ],
    );
  }
}

/// A published item's name and description (RA §9.2).
Future<void> editItemText(
  BuildContext context,
  WidgetRef ref,
  MenuItem item,
) async {
  final asked = await showDialog<({String name, String? description})>(
    context: context,
    builder: (context) => _ItemTextDialog(item: item),
  );
  if (asked == null || !context.mounted) return;
  await reportRequest(
    context,
    ref
        .read(menuCommandsProvider)
        .requestItemText(item.id, asked.name, asked.description),
  );
}

class _ItemTextDialog extends StatefulWidget {
  const _ItemTextDialog({required this.item});

  final MenuItem item;

  @override
  State<_ItemTextDialog> createState() => _ItemTextDialogState();
}

class _ItemTextDialogState extends State<_ItemTextDialog> {
  // The pending values first (RA §9.5): sending the published one again
  // would withdraw its request.
  late final _name = TextEditingController(
    text:
        pendingOf(widget.item.pending, PendingField.rename)?.name ??
        widget.item.name,
  );
  late final _description = TextEditingController(
    text: switch (pendingOf(widget.item.pending, PendingField.description)) {
      final asked? => asked.description ?? '',
      null => widget.item.description ?? '',
    },
  );

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.merchantMenuEditText),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            key: const Key('item-name'),
            controller: _name,
            maxLength: 80,
            decoration: InputDecoration(labelText: l10n.merchantMenuName),
          ),
          TextField(
            key: const Key('item-description'),
            controller: _description,
            maxLength: 300,
            decoration: InputDecoration(
              labelText: l10n.merchantMenuDescription,
            ),
          ),
          Text(l10n.merchantMenuReviewNote),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.merchantMenuCancel),
        ),
        TextButton(
          key: const Key('item-send'),
          onPressed: () {
            final name = _name.text.trim();
            if (name.isEmpty) return;
            final description = _description.text.trim();
            Navigator.of(context).pop((
              name: name,
              description: description.isEmpty ? null : description,
            ));
          },
          child: Text(l10n.merchantMenuSendForReview),
        ),
      ],
    );
  }
}

/// A new or replaced photo (RA §9.2: the old one stays until approval).
Future<void> changeItemPhoto(
  BuildContext context,
  WidgetRef ref,
  String itemId,
) async {
  final photo = await pickItemPhoto(context, ref);
  if (photo == null || !context.mounted) return;
  await reportRequest(
    context,
    ref.read(menuCommandsProvider).requestItemPhoto(itemId, photo),
  );
}

/// «مجموعات الخيارات» (RA §9.1, §9.2): every group with its choices, items
/// and options, its pending requests, and for owners «تعديل المجموعة» and
/// «إضافة مجموعة خيارات».
class OptionGroupsSection extends ConsumerWidget {
  const OptionGroupsSection({
    required this.menu,
    required this.owner,
    super.key,
  });

  final Menu menu;
  final bool owner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(title: Text(l10n.merchantMenuGroups)),
        for (final group in menu.optionGroups) ...[
          ListTile(
            key: Key('group-${group.id}'),
            title: Text(group.name),
            subtitle: Text(
              [
                l10n.merchantMenuGroupChoices(
                  '${group.minChoices}',
                  '${group.maxChoices}',
                ),
                for (final option in group.options)
                  '${option.name} ${l10n.formatMoney(option.priceDelta.amount, option.priceDelta.currency)}',
              ].join(' · '),
            ),
            trailing: owner
                ? TextButton(
                    key: Key('edit-group-${group.id}'),
                    onPressed: () => editGroup(context, ref, menu, group),
                    child: Text(l10n.merchantMenuEditGroup),
                  )
                : null,
          ),
          PendingLines(menu: menu, pending: group.pending, owner: owner),
          for (final option in group.options)
            PendingLines(menu: menu, pending: option.pending, owner: owner),
        ],
        if (owner)
          TextButton(
            key: const Key('add-group'),
            onPressed: () => editGroup(context, ref, menu, null),
            child: Text(l10n.merchantMenuAddGroup),
          ),
      ],
    );
  }
}

/// A new option group, or a group's changes, as requests (RA §9.2). A
/// published option's delta stays as it is (its price changes through
/// «تعديل السعر», RA §9.4).
Future<void> editGroup(
  BuildContext context,
  WidgetRef ref,
  Menu menu,
  MenuGroup? group,
) async {
  final currency = menuCurrency(menu);
  if (currency == null) return;
  final asked = await showDialog<GroupRequest>(
    context: context,
    builder: (context) =>
        _GroupDialog(menu: menu, group: group, currency: currency),
  );
  if (asked == null || !context.mounted) return;
  await reportRequest(
    context,
    ref
        .read(menuCommandsProvider)
        .requestOptionGroup(group?.id ?? ref.read(newMenuIdProvider)(), asked),
  );
}

class _OptionRow {
  _OptionRow({
    required this.id,
    required String name,
    required String delta,
    required this.locked,
  }) : name = TextEditingController(text: name),
       delta = TextEditingController(text: delta);

  final String id;
  final TextEditingController name;
  final TextEditingController delta;

  /// A published option: its delta changes only through «تعديل السعر».
  final bool locked;
}

class _GroupDialog extends ConsumerStatefulWidget {
  const _GroupDialog({
    required this.menu,
    required this.group,
    required this.currency,
  });

  final Menu menu;
  final MenuGroup? group;
  final String currency;

  @override
  ConsumerState<_GroupDialog> createState() => _GroupDialogState();
}

class _GroupDialogState extends ConsumerState<_GroupDialog> {
  // The pending values first (RA §9.5), as the item's text.
  late final _choices = widget.group == null
      ? null
      : pendingOf(widget.group!.pending, PendingField.choices);
  late final _name = TextEditingController(
    text: widget.group == null
        ? ''
        : pendingOf(widget.group!.pending, PendingField.rename)?.name ??
              widget.group!.name,
  );
  late final _min = TextEditingController(
    text: '${_choices?.minChoices ?? widget.group?.minChoices ?? 0}',
  );
  late final _max = TextEditingController(
    text: '${_choices?.maxChoices ?? widget.group?.maxChoices ?? 1}',
  );
  late final Set<String> _items = {
    ...?(widget.group == null
        ? null
        : pendingOf(widget.group!.pending, PendingField.items)?.itemIds ??
              widget.group!.itemIds),
  };
  final _options = <_OptionRow>[];
  bool _invalid = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final group = widget.group;
    if (_options.isEmpty && group != null) {
      final l10n = AppLocalizations.of(context);
      final published = !isNew(group.pending);
      for (final option in group.options) {
        _options.add(
          _OptionRow(
            id: option.id,
            name:
                pendingOf(option.pending, PendingField.rename)?.name ??
                option.name,
            delta: typedOf(
              option.priceDelta.amount,
              option.priceDelta.currency,
              l10n,
            ),
            locked: published && !isNew(option.pending),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    for (final controller in [_name, _min, _max]) {
      controller.dispose();
    }
    for (final option in _options) {
      option.name.dispose();
      option.delta.dispose();
    }
    super.dispose();
  }

  GroupRequest? get _request {
    final name = _name.text.trim();
    final min = int.tryParse(_min.text.trim());
    final max = int.tryParse(_max.text.trim());
    if (name.isEmpty || min == null || max == null) return null;
    if (min < 0 || max < 1 || max < min) return null;
    final options =
        <({String id, String name, String delta, String currency})>[];
    for (final option in _options) {
      final optionName = option.name.text.trim();
      final delta = deltaOfTyped(option.delta.text, widget.currency);
      if (optionName.isEmpty || delta == null) return null;
      options.add((
        id: option.id,
        name: optionName,
        delta: delta,
        currency: widget.currency,
      ));
    }
    return GroupRequest(
      name: name,
      minChoices: min,
      maxChoices: max,
      itemIds: [
        for (final category in widget.menu.categories)
          for (final item in category.items)
            if (_items.contains(item.id)) item.id,
      ],
      options: options,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(
        widget.group == null
            ? l10n.merchantMenuAddGroup
            : l10n.merchantMenuEditGroup,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              key: const Key('group-name'),
              controller: _name,
              maxLength: 80,
              decoration: InputDecoration(labelText: l10n.merchantMenuName),
            ),
            TextField(
              key: const Key('group-min'),
              controller: _min,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.merchantMenuMinChoices,
              ),
            ),
            TextField(
              key: const Key('group-max'),
              controller: _max,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.merchantMenuMaxChoices,
              ),
            ),
            for (final (index, option) in _options.indexed) ...[
              TextField(
                key: Key('option-name-$index'),
                controller: option.name,
                maxLength: 80,
                decoration: InputDecoration(
                  labelText: l10n.merchantMenuOptionName,
                ),
              ),
              TextField(
                key: Key('option-delta-$index'),
                controller: option.delta,
                enabled: !option.locked,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: l10n.merchantMenuPriceDelta,
                  suffixText: l10n.currencySymbol(widget.currency),
                ),
              ),
            ],
            TextButton(
              key: const Key('group-add-option'),
              onPressed: () => setState(
                () => _options.add(
                  _OptionRow(
                    id: ref.read(newMenuIdProvider)(),
                    name: '',
                    delta: '0',
                    locked: false,
                  ),
                ),
              ),
              child: Text(l10n.merchantMenuAddOption),
            ),
            Text(l10n.merchantMenuGroupItems),
            for (final category in widget.menu.categories)
              for (final item in category.items)
                CheckboxListTile(
                  key: Key('group-item-${item.id}'),
                  title: Text(item.name),
                  value: _items.contains(item.id),
                  onChanged: (on) => setState(
                    () => on == true
                        ? _items.add(item.id)
                        : _items.remove(item.id),
                  ),
                ),
            if (_invalid) Text(l10n.merchantMenuRequestInvalid),
            Text(l10n.merchantMenuReviewNote),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.merchantMenuCancel),
        ),
        TextButton(
          key: const Key('group-send'),
          onPressed: () {
            final request = _request;
            if (request == null) {
              setState(() => _invalid = true);
              return;
            }
            Navigator.of(context).pop(request);
          },
          child: Text(l10n.merchantMenuSendForReview),
        ),
      ],
    );
  }
}
