import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'staff.dart';
import 'staff_screen.dart';

/// «الأجهزة» (RA §14.2), the owners': each device with its user, platform,
/// version and whether someone is signed in on it, renamed or signed out
/// (after a confirmation; its user stays; never this device, RA §14.3),
/// with its ringing, connection and last device check, and the warning while
/// the restaurant is open with no receiving device (slice 2.42). Unstyled
/// until the design.
class DevicesScreen extends ConsumerWidget {
  const DevicesScreen({super.key});

  Future<void> _rename(
    BuildContext context,
    WidgetRef ref,
    RestaurantDevice device,
  ) async {
    final name = await showDialog<String>(
      context: context,
      builder: (context) => _RenameDialog(initial: device.name),
    );
    if (name == null || name == device.name || !context.mounted) return;
    final saved = await ref
        .read(devicesProvider.notifier)
        .rename(device.deviceId, name);
    if (!saved && context.mounted) _failed(context);
  }

  Future<void> _signOut(
    BuildContext context,
    WidgetRef ref,
    RestaurantDevice device,
  ) async {
    final l10n = AppLocalizations.of(context);
    final sure = await confirm(
      context,
      l10n.merchantSignOutDeviceConfirm(device.name),
      l10n.merchantSignOutDevice,
    );
    if (!sure || !context.mounted) return;
    final done = await ref
        .read(devicesProvider.notifier)
        .signOut(device.deviceId);
    if (!done && context.mounted) _failed(context);
  }

  /// RA §4.3 (slice 2.44): a one-time code that registers a Windows PC,
  /// shown once.
  Future<void> _pairWindows(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final code = await pairingCode(ref);
    if (!context.mounted) return;
    if (code == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.merchantPairWindowsFailed)));
      return;
    }
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.merchantPairWindows),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SelectableText(
              key: const Key('pairing-code'),
              code,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(l10n.merchantPairWindowsHow),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.merchantClose),
          ),
        ],
      ),
    );
  }

  void _failed(BuildContext context) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).merchantSaveFailed),
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final devices = ref.watch(devicesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.merchantDevices),
        actions: [
          TextButton(
            key: const Key('pair-windows'),
            onPressed: () => _pairWindows(context, ref),
            child: Text(l10n.merchantPairWindows),
          ),
        ],
      ),
      body: switch (devices) {
        AsyncData(:final value) when value.isEmpty => Center(
          child: Text(l10n.merchantNoDevices),
        ),
        AsyncData(:final value) => ListView(
          children: [
            if (ref.read(devicesProvider.notifier).withoutDevice)
              MaterialBanner(
                key: const Key('no-receiving-device'),
                content: Text(l10n.merchantNoReceivingDevice),
                actions: const [SizedBox.shrink()],
              ),
            for (final device in value)
              Column(
                key: Key('device-${device.deviceId}'),
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    title: Text(
                      device.thisDevice
                          ? '${device.name} · ${l10n.merchantThisDevice}'
                          : device.name,
                    ),
                    subtitle: Text(
                      [
                        if (device.user case final user?)
                          l10n.merchantDeviceUser(
                            user,
                            device.userIsOwner
                                ? l10n.merchantRoleOwner
                                : l10n.merchantRoleCashier,
                          ),
                        l10n.merchantDeviceDetails(
                          platformText(l10n, device.platform),
                          device.appVersion,
                        ),
                        if (device.signedIn)
                          l10n.merchantDeviceSignedIn
                        else
                          l10n.merchantDeviceSignedOut,
                        lastActiveText(l10n, device.lastSeenAt),
                        if (device.ringing)
                          l10n.merchantDeviceRinging
                        else
                          l10n.merchantDeviceSilent,
                        if (device.connected)
                          l10n.merchantDeviceConnected
                        else
                          l10n.merchantDeviceNotConnected,
                        switch (device.checkPassed) {
                          true => l10n.merchantDeviceCheckOk,
                          false => l10n.merchantDeviceCheckNotOk,
                          null => l10n.merchantDeviceNotChecked,
                        },
                      ].join(' · '),
                    ),
                  ),
                  OverflowBar(
                    alignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        key: Key('rename-${device.deviceId}'),
                        onPressed: () => _rename(context, ref, device),
                        child: Text(l10n.merchantRenameDevice),
                      ),
                      // This device signs out from «هذا الجهاز» (RA §14.3).
                      if (device.signedIn && !device.thisDevice)
                        TextButton(
                          key: Key('sign-out-${device.deviceId}'),
                          onPressed: () => _signOut(context, ref, device),
                          child: Text(l10n.merchantSignOutDevice),
                        ),
                    ],
                  ),
                ],
              ),
          ],
        ),
        AsyncError(:final error) => Failure(
          error: error,
          retry: () => ref.invalidate(devicesProvider),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _RenameDialog extends StatefulWidget {
  const _RenameDialog({required this.initial});

  final String initial;

  @override
  State<_RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<_RenameDialog> {
  late final _name = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.merchantRenameDevice),
      content: TextField(
        key: const Key('device-name'),
        controller: _name,
        maxLength: 60,
        decoration: InputDecoration(hintText: l10n.merchantDeviceNameHint),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.merchantMenuCancel),
        ),
        TextButton(
          key: const Key('device-name-save'),
          onPressed: () {
            final name = _name.text.trim();
            if (name.isNotEmpty) Navigator.of(context).pop(name);
          },
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
