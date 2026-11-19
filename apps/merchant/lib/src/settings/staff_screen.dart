import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'staff.dart';

/// «الموظفون» (RA §14.1), the owners': owners read-only, cashiers added
/// with a name and a number and removed after a confirmation. Unstyled
/// until the design.
class StaffScreen extends ConsumerWidget {
  const StaffScreen({super.key});

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final cashier = await showDialog<({String name, String phone})>(
      context: context,
      builder: (context) => const _NewCashierDialog(),
    );
    if (cashier == null || !context.mounted) return;
    final refusal = await ref
        .read(staffProvider.notifier)
        .addCashier(cashier.name, cashier.phone);
    if (refusal == null || !context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(switch (refusal) {
          StaffRefusal.phoneTaken => l10n.merchantPhoneTaken,
          StaffRefusal.failed => l10n.merchantSaveFailed,
        }),
      ),
    );
  }

  Future<void> _remove(
    BuildContext context,
    WidgetRef ref,
    StaffMember cashier,
  ) async {
    final l10n = AppLocalizations.of(context);
    final sure = await confirm(
      context,
      l10n.merchantRemoveCashierConfirm(cashier.name),
      l10n.merchantRemove,
    );
    if (!sure || !context.mounted) return;
    final refusal = await ref
        .read(staffProvider.notifier)
        .remove(cashier.accountId);
    if (refusal != null && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.merchantSaveFailed)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final staff = ref.watch(staffProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.merchantStaff),
        actions: [
          if (staff case AsyncData())
            TextButton(
              key: const Key('add-cashier'),
              onPressed: () => _add(context, ref),
              child: Text(l10n.merchantAddCashier),
            ),
        ],
      ),
      body: switch (staff) {
        AsyncData(:final value) => ListView(
          children: [
            ListTile(title: Text(l10n.merchantOwnersNote)),
            for (final member in value)
              ListTile(
                key: Key('staff-${member.accountId}'),
                title: Text(member.name),
                subtitle: Text(
                  [
                    member.owner
                        ? l10n.merchantRoleOwner
                        : l10n.merchantRoleCashier,
                    // Left to right inside the Arabic line (AP §4.7).
                    '\u2066${member.phone}\u2069',
                    l10n.merchantStaffDevices(member.devices),
                    lastActiveText(l10n, member.lastActiveAt),
                  ].join(' · '),
                ),
                trailing: member.owner
                    ? null
                    : TextButton(
                        key: Key('remove-${member.accountId}'),
                        onPressed: () => _remove(context, ref, member),
                        child: Text(l10n.merchantRemove),
                      ),
              ),
          ],
        ),
        AsyncError(:final error) => Failure(
          error: error,
          retry: () => ref.invalidate(staffProvider),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

/// «آخر نشاط: …» on the city's clock, or «لم يسجّل الدخول بعد».
String lastActiveText(AppLocalizations l10n, DateTime? at) => at == null
    ? l10n.merchantNeverActive
    : l10n.merchantLastActive(l10n.formatDate(at), l10n.formatTime(at));

/// Asks before a command that cannot be undone; true once confirmed.
Future<bool> confirm(BuildContext context, String question, String yes) async {
  final l10n = AppLocalizations.of(context);
  final answer = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      content: Text(question),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.merchantMenuCancel),
        ),
        TextButton(
          key: const Key('confirm'),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(yes),
        ),
      ],
    ),
  );
  return answer ?? false;
}

/// A refused read: a `403` (a cashier, a terminated restaurant) would fail
/// again, any other failure offers a retry.
class Failure extends StatelessWidget {
  const Failure({super.key, required this.error, required this.retry});

  final Object error;
  final VoidCallback retry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (error is DioException &&
        (error as DioException).response?.statusCode == 403) {
      return Center(child: Text(l10n.merchantSettingsNotAllowed));
    }
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.merchantSettingsFailed),
          TextButton(onPressed: retry, child: Text(l10n.merchantRetry)),
        ],
      ),
    );
  }
}

class _NewCashierDialog extends StatefulWidget {
  const _NewCashierDialog();

  @override
  State<_NewCashierDialog> createState() => _NewCashierDialogState();
}

class _NewCashierDialogState extends State<_NewCashierDialog> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  var _country = PhoneCountry.syria;
  var _invalidPhone = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _send() {
    final name = _name.text.trim();
    final phone = e164Phone(_country, _phone.text);
    setState(() => _invalidPhone = phone == null);
    if (name.isEmpty || phone == null) return;
    Navigator.of(context).pop((name: name, phone: phone));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.merchantAddCashier),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            key: const Key('cashier-name'),
            controller: _name,
            maxLength: 80,
            decoration: InputDecoration(labelText: l10n.merchantCashierName),
          ),
          DropdownButton<PhoneCountry>(
            value: _country,
            onChanged: (country) {
              if (country != null) setState(() => _country = country);
            },
            items: [
              DropdownMenuItem(
                value: PhoneCountry.syria,
                child: Text(l10n.signInCountrySyria),
              ),
              DropdownMenuItem(
                value: PhoneCountry.turkey,
                child: Text(l10n.signInCountryTurkey),
              ),
            ],
          ),
          TextField(
            key: const Key('cashier-phone'),
            controller: _phone,
            keyboardType: TextInputType.phone,
            textDirection: TextDirection.ltr,
            decoration: InputDecoration(
              labelText: l10n.signInPhoneLabel,
              errorText: _invalidPhone ? l10n.signInInvalidPhone : null,
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
          key: const Key('cashier-add'),
          onPressed: _send,
          child: Text(l10n.merchantAdd),
        ),
      ],
    );
  }
}

/// The platform's name (RA §14.2).
String platformText(
  AppLocalizations l10n,
  MerchantDevicesDtoOutputDevicesInnerPlatformEnum platform,
) => switch (platform) {
  MerchantDevicesDtoOutputDevicesInnerPlatformEnum.ios =>
    l10n.merchantPlatformIos,
  MerchantDevicesDtoOutputDevicesInnerPlatformEnum.windows =>
    l10n.merchantPlatformWindows,
  _ => l10n.merchantPlatformAndroid,
};
