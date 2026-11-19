import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'menu.dart';
import 'texts.dart';

/// «سجل الأسعار» (RA §9.4), the owners': each item's or option's old and new
/// price, who changed it (the restaurant user's name, or «FOX DROP») and
/// when, newest first. Unstyled until the design.
class PriceLogScreen extends ConsumerWidget {
  const PriceLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final log = ref.watch(priceLogProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.merchantMenuPriceLog)),
      body: switch (log) {
        AsyncData(:final value) when value.isEmpty => Center(
          child: Text(l10n.merchantMenuPriceLogEmpty),
        ),
        AsyncData(:final value) => ListView(
          children: [
            for (final entry in value)
              ListTile(
                key: Key('price-log-${entry.id}'),
                title: Text(
                  entry.groupName == null
                      ? entry.name
                      : '${entry.groupName}: ${entry.name}',
                ),
                subtitle: Text(
                  '${l10n.merchantMenuPriceLogChange(l10n.formatMoney(entry.oldPrice.amount, entry.oldPrice.currency), l10n.formatMoney(entry.newPrice.amount, entry.newPrice.currency))}\n'
                  '${l10n.merchantMenuPriceLogBy(changedByText(l10n, entry), '${l10n.formatDate(entry.at)} ${l10n.formatTime(entry.at)}')}',
                ),
              ),
          ],
        ),
        AsyncError() => Center(
          child: TextButton(
            onPressed: () => ref.invalidate(priceLogProvider),
            child: Text('${l10n.merchantMenuFailed} ${l10n.merchantRetry}'),
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
