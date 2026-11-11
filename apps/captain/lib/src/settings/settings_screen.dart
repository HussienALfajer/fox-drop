import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'carried_currencies.dart';
import 'max_pickup.dart';
import 'max_pickup_form.dart';

/// «الإعدادات» (owner decision 2026-11-11): «أقصى مبلغ أحمله» and «العملات
/// التي أحملها» for now (CA §10.5); it grows with the captain's settings.
/// Each section reads on its own, so one failing never hides the other.
/// Unstyled until the design.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currencies = ref.watch(carriedCurrenciesProvider);
    final notifier = ref.read(carriedCurrenciesProvider.notifier);
    final maxPickup = ref.watch(maxPickupProvider);
    Widget retry(VoidCallback onPressed) => Column(
      children: [
        Text(l10n.signInError),
        TextButton(onPressed: onPressed, child: Text(l10n.captainRetry)),
      ],
    );
    return Scaffold(
      appBar: AppBar(title: Text(l10n.captainSettings)),
      body: ListView(
        children: [
          ListTile(title: Text(l10n.captainMaxPickup)),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
            child: switch (maxPickup) {
              // A new key after each answer, so the field shows the amount
              // the server kept.
              AsyncData(value: final limit) => MaxPickupForm(
                key: ValueKey(limit.limit),
                value: limit,
              ),
              AsyncError() => retry(() => ref.invalidate(maxPickupProvider)),
              _ => const LinearProgressIndicator(),
            },
          ),
          ListTile(
            title: Text(l10n.captainCarriedCurrencies),
            subtitle: Text(l10n.captainCarriedCurrenciesExplain),
          ),
          ...switch (currencies) {
            AsyncData(:final value) => [
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
            AsyncError() => [
              retry(() => ref.invalidate(carriedCurrenciesProvider)),
            ],
            _ => [const LinearProgressIndicator()],
          },
        ],
      ),
    );
  }
}
