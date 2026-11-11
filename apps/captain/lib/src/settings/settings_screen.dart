import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'carried_currencies.dart';

/// «الإعدادات» (owner decision 2026-11-11): «العملات التي أحملها» only for
/// now (CA §10.5); it grows with the captain's settings. Unstyled until the
/// design.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currencies = ref.watch(carriedCurrenciesProvider);
    final notifier = ref.read(carriedCurrenciesProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.captainSettings)),
      body: switch (currencies) {
        AsyncData(:final value) => ListView(
          children: [
            ListTile(
              title: Text(l10n.captainCarriedCurrencies),
              subtitle: Text(l10n.captainCarriedCurrenciesExplain),
            ),
            for (final choice in value.choices)
              SwitchListTile(
                title: Text(choice.name),
                subtitle: choice.base ? Text(l10n.captainBaseCurrency) : null,
                value: value.carried.contains(choice.code),
                onChanged: switch (value.switched(
                  choice.code,
                  on: !value.carried.contains(choice.code),
                )) {
                  final next? => (_) async {
                    if (!await notifier.set(next) && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.captainSaveFailed)),
                      );
                    }
                  },
                  null => null,
                },
              ),
          ],
        ),
        AsyncError() => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.signInError),
              TextButton(
                onPressed: () => ref.invalidate(carriedCurrenciesProvider),
                child: Text(l10n.captainRetry),
              ),
            ],
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
