import 'dart:async';

import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../device.dart';
import 'receiving.dart';

/// «هذا الجهاز» (RA §14.3 «This device», every user): «الرنين على هذا
/// الجهاز» for an owner (a cashier's device always rings, RA §4.4) and
/// «فحص الجهاز» with the last result. Unstyled until the design.
class ThisDeviceScreen extends ConsumerStatefulWidget {
  const ThisDeviceScreen({super.key});

  @override
  ConsumerState<ThisDeviceScreen> createState() => _ThisDeviceScreenState();
}

class _ThisDeviceScreenState extends ConsumerState<ThisDeviceScreen> {
  bool _saving = false;

  Future<void> _setRinging(bool on, AppLocalizations l10n) async {
    setState(() => _saving = true);
    final saved = await ref.read(thisDeviceProvider.notifier).setRinging(on);
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
    final device = ref.watch(thisDeviceProvider).value;
    final owner =
        ref.watch(merchantSessionProvider).value?.role ==
        MerchantSessionDtoOutputRoleEnum.owner;
    final check = device?.check;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.merchantThisDevice)),
      body: ListView(
        children: [
          if (owner)
            SwitchListTile(
              key: const Key('ring-on-this-device'),
              title: Text(l10n.merchantRingOnThisDevice),
              subtitle: Text(l10n.merchantRingOnThisDeviceExplain),
              value: device?.ringing ?? true,
              onChanged: _saving || device == null
                  ? null
                  : (on) => unawaited(_setRinging(on, l10n)),
            )
          else
            ListTile(
              title: Text(l10n.merchantRingOnThisDevice),
              subtitle: Text(l10n.merchantCashierAlwaysRings),
            ),
          ListTile(
            key: const Key('open-device-check'),
            title: Text(l10n.merchantDeviceCheck),
            subtitle: Text(
              check == null
                  ? l10n.merchantCheckNone
                  : '${check.passed ? l10n.merchantDeviceCheckOk : l10n.merchantDeviceCheckNotOk} · '
                        '${l10n.merchantCheckLast('${l10n.formatDate(check.at)} ${l10n.formatTime(check.at)}')}',
            ),
            onTap: () => context.push('/device/check'),
          ),
        ],
      ),
    );
  }
}
