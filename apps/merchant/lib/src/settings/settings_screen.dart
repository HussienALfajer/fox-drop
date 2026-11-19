import 'package:core_l10n/core_l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'pickup_currencies.dart';

/// «الإعدادات», the owners' (RA §14.3; owner decision 2026-11-11):
/// «الموظفون» and «الأجهزة» first (RA §14.1–14.2; owner decision
/// 2026-11-19), then «العملات التي تقبلها من الكابتن» (RA §12.7). Unstyled
/// until the design.
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
        // A 403 (a cashier, a terminated restaurant) would fail again, and
        // staff and devices with it.
        AsyncError(:final error)
            when error is DioException && error.response?.statusCode == 403 =>
          Center(child: Text(l10n.merchantSettingsNotAllowed)),
        _ => ListView(
          children: [
            ListTile(
              key: const Key('open-staff'),
              title: Text(l10n.merchantStaff),
              onTap: () => context.push('/settings/staff'),
            ),
            ListTile(
              key: const Key('open-devices'),
              title: Text(l10n.merchantDevices),
              onTap: () => context.push('/settings/devices'),
            ),
            ListTile(
              title: Text(l10n.merchantPickupCurrencies),
              subtitle: Text(l10n.merchantPickupCurrenciesExplain),
            ),
            ...switch (currencies) {
              AsyncData(:final value) => [
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
              AsyncError() => [
                ListTile(title: Text(l10n.merchantSettingsFailed)),
                TextButton(
                  onPressed: () => ref.invalidate(pickupCurrenciesProvider),
                  child: Text(l10n.merchantRetry),
                ),
              ],
              _ => [const Center(child: CircularProgressIndicator())],
            },
          ],
        ),
      },
    );
  }
}
