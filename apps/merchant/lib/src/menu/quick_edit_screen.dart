import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'menu.dart';
import 'menu_screen.dart';
import 'texts.dart';

/// «تعديل سريع» (RA §9.6): every item and option in one list, searched by
/// name and filtered by category, with the switch for everyone and the
/// price for owners (RA §9.4). Unstyled until the design.
class QuickEditScreen extends ConsumerStatefulWidget {
  const QuickEditScreen({super.key});

  @override
  ConsumerState<QuickEditScreen> createState() => _QuickEditScreenState();
}

class _QuickEditScreenState extends ConsumerState<QuickEditScreen> {
  String _query = '';
  String? _categoryId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final owner = isOwner(ref);
    final menu = ref.watch(menuProvider);
    final commands = ref.read(menuCommandsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.merchantMenuQuickEdit)),
      body: switch (menu) {
        AsyncData(:final value) => Column(
          children: [
            TextField(
              key: const Key('quick-search'),
              decoration: InputDecoration(
                labelText: l10n.merchantMenuSearch,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (text) => setState(() => _query = text),
            ),
            DropdownButton<String?>(
              key: const Key('quick-category'),
              isExpanded: true,
              value: _categoryId,
              items: [
                DropdownMenuItem(child: Text(l10n.merchantMenuAllCategories)),
                for (final category in value.categories)
                  DropdownMenuItem(
                    value: category.id,
                    child: Text(category.name),
                  ),
              ],
              onChanged: (id) => setState(() => _categoryId = id),
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  final rows = quickRows(
                    value,
                    query: _query,
                    categoryId: _categoryId,
                  );
                  if (rows.isEmpty) {
                    return Center(child: Text(l10n.merchantMenuNoMatch));
                  }
                  return ListView(
                    children: [
                      for (final row in rows)
                        _QuickRow(row: row, owner: owner, commands: commands),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        AsyncError() => Center(child: Text(l10n.merchantMenuFailed)),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _QuickRow extends ConsumerWidget {
  const _QuickRow({
    required this.row,
    required this.owner,
    required this.commands,
  });

  final QuickRow row;
  final bool owner;
  final MenuCommands commands;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final option = row.option;
    final price = option?.priceDelta ?? row.item.price;
    final off = option?.switchedOff ?? row.item.switchedOff;
    return ListTile(
      key: Key('quick-${row.id}'),
      title: Text(row.name),
      subtitle: Text(
        [
          if (option != null) l10n.merchantMenuOptionOf(row.item.name),
          l10n.formatMoney(price.amount, price.currency),
          switchText(l10n, off),
        ].join(' · '),
      ),
      onTap: owner
          ? () => editPrice(
              context,
              ref,
              name: row.name,
              price: price,
              delta: option != null,
              save: (minor) => option != null
                  ? commands.setOptionDelta(option.id, minor, price.currency)
                  : commands.setItemPrice(row.item.id, minor, price.currency),
            )
          : null,
      trailing: Switch(
        key: Key('quick-switch-${row.id}'),
        value: off == null,
        onChanged: (on) => switchRow(
          context,
          ref,
          option != null ? RowType.option : RowType.item,
          row.id,
          on: on,
        ),
      ),
    );
  }
}
