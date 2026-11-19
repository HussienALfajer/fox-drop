import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'menu.dart';
import 'texts.dart';

/// «تعديل جماعي للأسعار» (RA §9.4), the owners': raise or lower by a
/// percentage or a fixed amount, for one category or the whole menu, with
/// the before and after of every item before «تأكيد التعديل». The panel's
/// tool (AP §9.6.6). Unstyled until the design.
class BulkPriceScreen extends ConsumerStatefulWidget {
  const BulkPriceScreen({super.key});

  @override
  ConsumerState<BulkPriceScreen> createState() => _BulkPriceScreenState();
}

class _BulkPriceScreenState extends ConsumerState<BulkPriceScreen> {
  final _value = TextEditingController();
  String? _categoryId;
  bool _percent = true;
  bool _up = true;
  bool _busy = false;
  bool _invalid = false;
  BulkChange? _previewed;
  BulkPreview? _preview;

  @override
  void dispose() {
    _value.dispose();
    super.dispose();
  }

  /// The change as chosen; null while the value is unreadable.
  BulkChange? _change(String currency) {
    final value = _percent
        ? basisPointsOf(_value.text)
        : minorOfTyped(_value.text, currency);
    if (value == null) return null;
    return BulkChange(
      categoryId: _categoryId,
      percent: _percent,
      up: _up,
      value: value,
    );
  }

  void _changed() => setState(() {
    _preview = null;
    _previewed = null;
  });

  Future<void> _showPreview(String currency) async {
    final change = _change(currency);
    if (change == null) {
      setState(() => _invalid = true);
      return;
    }
    setState(() {
      _invalid = false;
      _busy = true;
    });
    final (preview, refusal) = await ref
        .read(menuCommandsProvider)
        .previewBulk(change);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _preview = preview;
      _previewed = preview == null ? null : change;
    });
    if (refusal != null) {
      _say(refusalText(AppLocalizations.of(context), refusal));
    }
  }

  Future<void> _apply() async {
    final change = _previewed;
    final preview = _preview;
    if (change == null || preview == null) return;
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    final commands = ref.read(menuCommandsProvider);
    final refusal = await commands.applyBulk(change);
    if (!mounted) return;
    setState(() => _busy = false);
    if (refusal != null) {
      _say(refusalText(l10n, refusal));
      return;
    }
    _say(
      l10n.merchantMenuBulkDone(commands.lastBulkChanged ?? preview.changed),
    );
    Navigator.of(context).maybePop();
  }

  void _say(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final menu = ref.watch(menuProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.merchantMenuBulk)),
      body: switch (menu) {
        AsyncData(:final value) => _form(l10n, value),
        AsyncError() => Center(child: Text(l10n.merchantMenuFailed)),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _form(AppLocalizations l10n, Menu menu) {
    final items = [for (final c in menu.categories) ...c.items];
    final currency = items.isEmpty ? 'TRY' : items.first.price.currency;
    final names = {for (final item in items) item.id: item.name};
    final preview = _preview;
    return ListView(
      children: [
        DropdownButton<String?>(
          key: const Key('bulk-category'),
          isExpanded: true,
          value: _categoryId,
          items: [
            DropdownMenuItem(child: Text(l10n.merchantMenuAllCategories)),
            for (final category in menu.categories)
              DropdownMenuItem(value: category.id, child: Text(category.name)),
          ],
          onChanged: (id) {
            _categoryId = id;
            _changed();
          },
        ),
        SegmentedButton<bool>(
          segments: [
            ButtonSegment(
              value: true,
              label: Text(
                l10n.merchantMenuBulkPercent,
                key: const Key('bulk-percent'),
              ),
            ),
            ButtonSegment(
              value: false,
              label: Text(
                l10n.merchantMenuBulkAmount,
                key: const Key('bulk-amount'),
              ),
            ),
          ],
          selected: {_percent},
          onSelectionChanged: (next) {
            _percent = next.first;
            _changed();
          },
        ),
        SegmentedButton<bool>(
          segments: [
            ButtonSegment(
              value: true,
              label: Text(l10n.merchantMenuBulkUp, key: const Key('bulk-up')),
            ),
            ButtonSegment(
              value: false,
              label: Text(
                l10n.merchantMenuBulkDown,
                key: const Key('bulk-down'),
              ),
            ),
          ],
          selected: {_up},
          onSelectionChanged: (next) {
            _up = next.first;
            _changed();
          },
        ),
        TextField(
          key: const Key('bulk-value'),
          controller: _value,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: l10n.merchantMenuBulkValue,
            suffixText: _percent ? '%' : l10n.currencySymbol(currency),
            errorText: _invalid ? l10n.merchantMenuInvalidPrice : null,
          ),
          onChanged: (_) => _changed(),
        ),
        // RA §9.4: price parity.
        Text(l10n.merchantMenuParityReminder),
        TextButton(
          key: const Key('bulk-preview'),
          onPressed: _busy ? null : () => _showPreview(currency),
          child: Text(l10n.merchantMenuBulkPreview),
        ),
        if (preview != null) ...[
          Text(
            l10n.merchantMenuBulkRounding(
              l10n.formatMoney(preview.roundingUnit, preview.currency),
            ),
          ),
          for (final row in preview.rows)
            ListTile(
              key: Key('bulk-row-${row.itemId}'),
              title: Text(names[row.itemId] ?? row.name),
              subtitle: Text(
                row.after == null
                    ? l10n.merchantMenuBulkReachesZero
                    : l10n.merchantMenuBulkRow(
                        l10n.formatMoney(row.before, preview.currency),
                        l10n.formatMoney(row.after!, preview.currency),
                      ),
              ),
            ),
          if (preview.refused > 0) Text(l10n.merchantMenuBulkRefused),
          TextButton(
            key: const Key('bulk-confirm'),
            onPressed: _busy || preview.refused > 0 || preview.changed == 0
                ? null
                : _apply,
            child: Text(l10n.merchantMenuBulkConfirm),
          ),
        ],
      ],
    );
  }
}
