import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../checkout/checkout.dart';
import 'addresses.dart';

/// A saved address's name: «البيت», «العمل» or its own (CU §7.3).
String addressLabelText(AppLocalizations l10n, SavedAddress address) =>
    switch (address.label.name) {
      'home' => l10n.customerLabelHome,
      'work' => l10n.customerLabelWork,
      _ => address.customLabel ?? l10n.customerLabelOther,
    };

/// The sentence of an [AddressOutcome] that is not `done`.
String addressOutcomeText(AppLocalizations l10n, AddressOutcome outcome) =>
    switch (outcome) {
      AddressOutcome.outsideZones => l10n.customerAddressOutside,
      AddressOutcome.limit => l10n.customerAddressLimit(maxAddresses),
      _ => l10n.customerSaveFailed,
    };

/// «عناويني» (CU §13, §7.3): the saved addresses, the default first and
/// marked, one outside every active zone with «خارج منطقة التوصيل حالياً»;
/// «إضافة عنوان» up to 10, «تعديل», «اجعله الافتراضي» and «حذف» after a
/// confirmation. Unstyled until the design.
class AddressesScreen extends ConsumerWidget {
  const AddressesScreen({super.key});

  Future<void> _report(
    BuildContext context,
    Future<AddressOutcome> command,
  ) async {
    final outcome = await command;
    if (outcome == AddressOutcome.done || !context.mounted) return;
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(addressOutcomeText(l10n, outcome))));
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    SavedAddress address,
  ) async {
    final l10n = AppLocalizations.of(context);
    final book = ref.read(addressBookProvider);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.customerDeleteAddressConfirm),
        content: Text(addressLabelText(l10n, address)),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: Text(l10n.customerCancel),
          ),
          TextButton(
            key: const Key('confirm-delete-address'),
            onPressed: () => context.pop(true),
            child: Text(l10n.customerRemove),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await _report(context, book.delete(address.id));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final saved = ref.watch(savedAddressesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.customerMyAddressesTitle)),
      body: switch (saved) {
        AsyncData(:final value) => ListView(
          children: [
            if (value.isEmpty) ListTile(title: Text(l10n.customerNoAddresses)),
            for (final address in value) ...[
              ListTile(
                key: Key('address-${address.id}'),
                title: Text(addressLabelText(l10n, address)),
                subtitle: Text(
                  [
                    address.street,
                    address.neighbourhood ?? l10n.customerOutsideZoneNow,
                    if (address.isDefault) l10n.customerDefaultAddress,
                  ].join(' · '),
                ),
              ),
              Wrap(
                children: [
                  TextButton(
                    key: Key('edit-address-${address.id}'),
                    onPressed: () =>
                        context.push('/account/addresses/${address.id}'),
                    child: Text(l10n.customerEdit),
                  ),
                  // Q6: an address outside every active zone cannot be
                  // chosen, so it cannot be the default either.
                  if (!address.isDefault && address.neighbourhood != null)
                    TextButton(
                      key: Key('default-address-${address.id}'),
                      onPressed: () => _report(
                        context,
                        ref.read(addressBookProvider).makeDefault(address.id),
                      ),
                      child: Text(l10n.customerMakeDefault),
                    ),
                  TextButton(
                    key: Key('delete-address-${address.id}'),
                    onPressed: () => _delete(context, ref, address),
                    child: Text(l10n.customerRemove),
                  ),
                ],
              ),
            ],
            Padding(
              padding: const EdgeInsetsDirectional.all(16),
              child: value.length < maxAddresses
                  ? FilledButton(
                      key: const Key('add-address'),
                      onPressed: () => context.push('/account/addresses/new'),
                      child: Text(l10n.customerAddAddress),
                    )
                  : Text(l10n.customerAddressLimit(maxAddresses)),
            ),
          ],
        ),
        AsyncError() => Center(
          child: TextButton(
            onPressed: () => ref.invalidate(savedAddressesProvider),
            child: Text(l10n.customerTryAgain),
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
