import 'package:core_l10n/core_l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pickup_currencies.dart';

/// «الإعدادات», the owners' (RA §14.3; owner decision 2026-11-11): only
/// «العملات التي تقبلها من الكابتن» for now (RA §12.7); it grows with
/// RA §14. Unstyled until the design.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  /// One save at a time: each sends the whole set, built from the answer of
  /// the one before, so two quick switches never overwrite each other.
  bool _saving = false;

  Future<void> _save(List<String> currencies) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _saving = true);
    final saved = await ref
        .read(pickupCurrenciesProvider.notifier)
        .set(currencies);
    if (!mounted) return;
    setState(() => _saving = false);
    if (!saved) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.merchantSaveFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currencies = ref.watch(pickupCurrenciesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.merchantSettings)),
      body: switch (currencies) {
        AsyncData(:final value) => ListView(
          children: [
            ListTile(
              title: Text(l10n.merchantPickupCurrencies),
              subtitle: Text(l10n.merchantPickupCurrenciesExplain),
            ),
            if (value.base case final base?)
              SwitchListTile(
                key: Key('pickup-currency-${base.code}'),
                title: Text(base.name),
                subtitle: Text(l10n.merchantBaseCurrencyAlways),
                value: true,
                onChanged: null,
              ),
            for (final choice in value.choices)
              SwitchListTile(
                key: Key('pickup-currency-${choice.code}'),
                title: Text(choice.name),
                value: value.accepted.contains(choice.code),
                onChanged: _saving
                    ? null
                    : (on) => _save(value.switched(choice.code, on: on)),
              ),
            if (value.choices.isEmpty)
              ListTile(title: Text(l10n.merchantNoOtherCurrencies)),
          ],
        ),
        // A 403 (a cashier, a terminated restaurant) would fail again.
        AsyncError(:final error)
            when error is DioException && error.response?.statusCode == 403 =>
          Center(child: Text(l10n.merchantSettingsNotAllowed)),
        AsyncError() => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.merchantSettingsFailed),
              TextButton(
                onPressed: () => ref.invalidate(pickupCurrenciesProvider),
                child: Text(l10n.merchantRetry),
              ),
            ],
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
