import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../device.dart';
import 'menu.dart';
import 'texts.dart';

/// Whether the signed-in user is an owner: the menu's commands but
/// availability are theirs (RA §6, §9.2).
bool isOwner(WidgetRef ref) => ref.watch(
  merchantSessionProvider.select(
    (s) => s.value?.role == MerchantSessionDtoOutputRoleEnum.owner,
  ),
);

/// The «القائمة» tab (RA §6.1 #3, §9.1–9.3): categories, items and options
/// with their switches for everyone, and for owners hiding, the order (up
/// and down until the design's drag), a category's window and the prices,
/// with «تعديل سريع», the bulk change, «سجل الأسعار» and the customer
/// preview. Unstyled until the design.
class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final owner = isOwner(ref);
    final menu = ref.watch(menuProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.merchantMenu),
        actions: [
          IconButton(
            key: const Key('menu-quick-edit'),
            tooltip: l10n.merchantMenuQuickEdit,
            onPressed: () => context.push('/menu/quick-edit'),
            icon: const Icon(Icons.bolt),
          ),
          if (owner) ...[
            IconButton(
              key: const Key('menu-bulk'),
              tooltip: l10n.merchantMenuBulk,
              onPressed: () => context.push('/menu/bulk-price'),
              icon: const Icon(Icons.percent),
            ),
            IconButton(
              key: const Key('menu-price-log'),
              tooltip: l10n.merchantMenuPriceLog,
              onPressed: () => context.push('/menu/price-log'),
              icon: const Icon(Icons.history),
            ),
            IconButton(
              key: const Key('menu-preview'),
              tooltip: l10n.merchantMenuCustomerPreview,
              onPressed: () => context.push('/menu/preview'),
              icon: const Icon(Icons.visibility),
            ),
          ],
        ],
      ),
      body: switch (menu) {
        AsyncData(:final value) =>
          value.categories.isEmpty
              ? Center(child: Text(l10n.merchantMenuEmpty))
              : ListView(
                  children: [
                    for (final category in value.categories)
                      _Category(menu: value, category: category, owner: owner),
                  ],
                ),
        AsyncError(:final error) => _Failed(
          terminated: isTerminated(error),
          onRetry: () => ref.invalidate(menuProvider),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Failed extends StatelessWidget {
  const _Failed({required this.terminated, required this.onRetry});

  final bool terminated;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            terminated ? l10n.merchantMenuTerminated : l10n.merchantMenuFailed,
          ),
          if (!terminated)
            TextButton(onPressed: onRetry, child: Text(l10n.merchantRetry)),
        ],
      ),
    );
  }
}

class _Category extends ConsumerWidget {
  const _Category({
    required this.menu,
    required this.category,
    required this.owner,
  });

  final Menu menu;
  final MenuCategory category;
  final bool owner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final commands = ref.read(menuCommandsProvider);
    final ids = [for (final c in menu.categories) c.id];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          key: Key('category-${category.id}'),
          title: Text(category.name),
          subtitle: Text(
            [
              switchText(l10n, category.switchedOff),
              windowText(l10n, category),
              if (category.hidden) l10n.merchantMenuHidden,
            ].join(' · '),
          ),
          trailing: _Switch(
            keyName: 'switch-category-${category.id}',
            type: RowType.category,
            id: category.id,
            on: category.switchedOff == null,
          ),
        ),
        if (owner)
          Wrap(
            children: [
              TextButton(
                key: Key('hide-category-${category.id}'),
                onPressed: () => _report(
                  context,
                  commands.setHidden(
                    RowType.category,
                    category.id,
                    !category.hidden,
                  ),
                ),
                child: Text(
                  category.hidden
                      ? l10n.merchantMenuShow
                      : l10n.merchantMenuHide,
                ),
              ),
              _Move(
                keyName: 'category-${category.id}',
                ids: ids,
                id: category.id,
                send: commands.orderCategories,
              ),
              TextButton(
                key: Key('window-category-${category.id}'),
                onPressed: () => _editWindow(context, ref, category),
                child: Text(l10n.merchantMenuSetWindow),
              ),
            ],
          ),
        for (final item in category.items)
          _Item(category: category, item: item, owner: owner),
        const Divider(),
      ],
    );
  }
}

class _Item extends ConsumerWidget {
  const _Item({
    required this.category,
    required this.item,
    required this.owner,
  });

  final MenuCategory category;
  final MenuItem item;
  final bool owner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final commands = ref.read(menuCommandsProvider);
    final ids = [for (final i in category.items) i.id];
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            key: Key('item-${item.id}'),
            title: Text(item.name),
            subtitle: Text(
              [
                l10n.formatMoney(item.price.amount, item.price.currency),
                switchText(l10n, item.switchedOff),
                if (item.switchedOff == null && !item.available)
                  l10n.merchantMenuUnavailableToCustomers,
                if (item.hidden) l10n.merchantMenuHidden,
              ].join(' · '),
            ),
            trailing: _Switch(
              keyName: 'switch-item-${item.id}',
              type: RowType.item,
              id: item.id,
              on: item.switchedOff == null,
            ),
          ),
          if (owner)
            Wrap(
              children: [
                TextButton(
                  key: Key('price-item-${item.id}'),
                  onPressed: () => editPrice(
                    context,
                    ref,
                    name: item.name,
                    price: item.price,
                    delta: false,
                    save: (minor) => commands.setItemPrice(
                      item.id,
                      minor,
                      item.price.currency,
                    ),
                  ),
                  child: Text(l10n.merchantMenuEditPrice),
                ),
                TextButton(
                  key: Key('hide-item-${item.id}'),
                  onPressed: () => _report(
                    context,
                    commands.setHidden(RowType.item, item.id, !item.hidden),
                  ),
                  child: Text(
                    item.hidden ? l10n.merchantMenuShow : l10n.merchantMenuHide,
                  ),
                ),
                _Move(
                  keyName: 'item-${item.id}',
                  ids: ids,
                  id: item.id,
                  send: (next) => commands.orderItems(category.id, next),
                ),
              ],
            ),
          for (final group in item.optionGroups)
            for (final option in group.options)
              ListTile(
                key: Key('option-${item.id}-${option.id}'),
                contentPadding: const EdgeInsetsDirectional.only(
                  start: 32,
                  end: 16,
                ),
                title: Text('${group.name}: ${option.name}'),
                subtitle: Text(
                  [
                    l10n.formatMoney(
                      option.priceDelta.amount,
                      option.priceDelta.currency,
                    ),
                    switchText(l10n, option.switchedOff),
                  ].join(' · '),
                ),
                onTap: owner
                    ? () => editPrice(
                        context,
                        ref,
                        name: option.name,
                        price: option.priceDelta,
                        delta: true,
                        save: (minor) => commands.setOptionDelta(
                          option.id,
                          minor,
                          option.priceDelta.currency,
                        ),
                      )
                    : null,
                trailing: _Switch(
                  keyName: 'switch-option-${item.id}-${option.id}',
                  type: RowType.option,
                  id: option.id,
                  on: option.switchedOff == null,
                ),
              ),
        ],
      ),
    );
  }
}

/// The availability switch of a row, for owners and cashiers (RA §9.3):
/// switching off asks «حتى الغد» (the default) or «حتى أعيده».
class _Switch extends ConsumerWidget {
  const _Switch({
    required this.keyName,
    required this.type,
    required this.id,
    required this.on,
  });

  final String keyName;
  final RowType type;
  final String id;
  final bool on;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Switch(
    key: Key(keyName),
    value: on,
    onChanged: (next) => switchRow(context, ref, type, id, on: next),
  );
}

/// Switches a row on, or asks how long it stays off and switches it off.
Future<void> switchRow(
  BuildContext context,
  WidgetRef ref,
  RowType type,
  String id, {
  required bool on,
}) async {
  final commands = ref.read(menuCommandsProvider);
  if (on) {
    await _report(context, commands.setAvailability(type, id, available: true));
    return;
  }
  final offFor = await showModalBottomSheet<OffFor>(
    context: context,
    builder: (context) {
      final l10n = AppLocalizations.of(context);
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text(l10n.merchantMenuOffFor)),
            ListTile(
              key: const Key('off-tomorrow'),
              title: Text(l10n.merchantRejectUntilTomorrow),
              onTap: () => Navigator.of(context).pop(OffFor.tomorrow),
            ),
            ListTile(
              key: const Key('off-until-back'),
              title: Text(l10n.merchantRejectUntilTurnedBackOn),
              onTap: () => Navigator.of(context).pop(OffFor.untilBack),
            ),
          ],
        ),
      );
    },
  );
  if (offFor == null || !context.mounted) return;
  await _report(
    context,
    commands.setAvailability(type, id, available: false, offFor: offFor),
  );
}

class _Move extends StatelessWidget {
  const _Move({
    required this.keyName,
    required this.ids,
    required this.id,
    required this.send,
  });

  final String keyName;
  final List<String> ids;
  final String id;
  final Future<MenuRefusal?> Function(List<String>) send;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final up = moved(ids, id, -1);
    final down = moved(ids, id, 1);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          key: Key('up-$keyName'),
          tooltip: l10n.merchantMenuMoveUp,
          onPressed: up == null ? null : () => _report(context, send(up)),
          icon: const Icon(Icons.arrow_upward),
        ),
        IconButton(
          key: Key('down-$keyName'),
          tooltip: l10n.merchantMenuMoveDown,
          onPressed: down == null ? null : () => _report(context, send(down)),
          icon: const Icon(Icons.arrow_downward),
        ),
      ],
    );
  }
}

/// The price of an item or an option's delta, with the parity reminder
/// (RA §9.4); the field takes major units («12.50»).
Future<void> editPrice(
  BuildContext context,
  WidgetRef ref, {
  required String name,
  required MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice price,
  required bool delta,
  required Future<MenuRefusal?> Function(String minor) save,
}) async {
  final l10n = AppLocalizations.of(context);
  final minor = await showDialog<String>(
    context: context,
    builder: (context) => _PriceDialog(
      name: name,
      initial: typedOf(price.amount, price.currency, l10n),
      currency: price.currency,
      delta: delta,
    ),
  );
  if (minor == null || minor == price.amount || !context.mounted) return;
  await _report(context, save(minor));
}

class _PriceDialog extends StatefulWidget {
  const _PriceDialog({
    required this.name,
    required this.initial,
    required this.currency,
    required this.delta,
  });

  final String name;
  final String initial;
  final String currency;
  final bool delta;

  @override
  State<_PriceDialog> createState() => _PriceDialogState();
}

class _PriceDialogState extends State<_PriceDialog> {
  late final _field = TextEditingController(text: widget.initial);
  bool _invalid = false;

  @override
  void dispose() {
    _field.dispose();
    super.dispose();
  }

  String? get _minor => widget.delta
      ? deltaOfTyped(_field.text, widget.currency)
      : minorOfTyped(_field.text, widget.currency);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(widget.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // RA §9.4: price parity.
          Text(l10n.merchantMenuParityReminder),
          TextField(
            key: const Key('price-field'),
            controller: _field,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: widget.delta
                  ? l10n.merchantMenuPriceDelta
                  : l10n.merchantMenuPrice,
              suffixText: l10n.currencySymbol(widget.currency),
              errorText: _invalid ? l10n.merchantMenuInvalidPrice : null,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.merchantMenuCancel),
        ),
        TextButton(
          key: const Key('price-save'),
          onPressed: () {
            final minor = _minor;
            if (minor == null) {
              setState(() => _invalid = true);
              return;
            }
            Navigator.of(context).pop(minor);
          },
          child: Text(l10n.save),
        ),
      ],
    );
  }
}

/// A category's daily window (RA §9.1): two times on the city's clock, or
/// «طوال اليوم».
Future<void> _editWindow(
  BuildContext context,
  WidgetRef ref,
  MenuCategory category,
) async {
  final l10n = AppLocalizations.of(context);
  final commands = ref.read(menuCommandsProvider);
  final current = category.window;
  final choice = await showModalBottomSheet<String>(
    context: context,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(l10n.merchantMenuSetWindow),
            subtitle: Text(windowText(l10n, category)),
          ),
          ListTile(
            key: const Key('window-set'),
            title: Text(
              '${l10n.merchantMenuWindowFrom} … ${l10n.merchantMenuWindowTo}',
            ),
            onTap: () => Navigator.of(context).pop('set'),
          ),
          ListTile(
            key: const Key('window-clear'),
            title: Text(l10n.merchantMenuWindowClear),
            onTap: () => Navigator.of(context).pop('clear'),
          ),
        ],
      ),
    ),
  );
  if (choice == null || !context.mounted) return;
  if (choice == 'clear') {
    await _report(context, commands.setWindow(category.id, null));
    return;
  }
  TimeOfDay of(int minutes) =>
      TimeOfDay(hour: (minutes % 1440) ~/ 60, minute: minutes % 60);
  final from = await showTimePicker(
    context: context,
    helpText: l10n.merchantMenuWindowFrom,
    initialTime: of(current?.startsAt ?? 6 * 60),
  );
  if (from == null || !context.mounted) return;
  final to = await showTimePicker(
    context: context,
    helpText: l10n.merchantMenuWindowTo,
    initialTime: of(current?.endsAt ?? 12 * 60),
  );
  if (to == null || !context.mounted) return;
  final endsAt = to.hour * 60 + to.minute;
  await _report(
    context,
    commands.setWindow(category.id, (
      startsAt: from.hour * 60 + from.minute,
      // Midnight as the end is the day's end.
      endsAt: endsAt == 0 ? 1440 : endsAt,
    )),
  );
}

/// Shows a refusal's message once the command answered.
Future<void> _report(BuildContext context, Future<MenuRefusal?> command) async {
  final messenger = ScaffoldMessenger.of(context);
  final l10n = AppLocalizations.of(context);
  final refusal = await command;
  if (refusal == null) return;
  messenger.showSnackBar(SnackBar(content: Text(refusalText(l10n, refusal))));
}

/// Shared with the other menu screens.
Future<void> reportCommand(
  BuildContext context,
  Future<MenuRefusal?> command,
) => _report(context, command);
