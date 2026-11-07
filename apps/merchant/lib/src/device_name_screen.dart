import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'device.dart';

/// RA §5.2 item 5: the first sign-in on a device names it. Unstyled until the
/// design; the device check and the terms come with their slices.
class DeviceNameScreen extends ConsumerStatefulWidget {
  const DeviceNameScreen({super.key});

  @override
  ConsumerState<DeviceNameScreen> createState() => _DeviceNameScreenState();
}

class _DeviceNameScreenState extends ConsumerState<DeviceNameScreen> {
  final _name = TextEditingController();
  bool _busy = false;
  bool _failed = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _busy = true;
      _failed = false;
    });
    try {
      await nameDevice(ref, _name.text);
    } on Exception {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.merchantDeviceNameTitle)),
      body: ListView(
        padding: const EdgeInsetsDirectional.all(16),
        children: [
          TextField(
            key: const Key('device-name'),
            controller: _name,
            enabled: !_busy,
            maxLength: 60,
            decoration: InputDecoration(
              hintText: l10n.merchantDeviceNameHint,
              errorText: _failed ? l10n.signInError : null,
            ),
          ),
          FilledButton(onPressed: _busy ? null : _save, child: Text(l10n.save)),
        ],
      ),
    );
  }
}
