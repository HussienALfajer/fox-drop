import 'dart:async';

import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'registration.dart';

/// «ربط هذا الكمبيوتر» (RA §4.3, slice 2.44): on Windows, before the first
/// sign-in, the owner's pairing code registers this PC. Unstyled until the
/// design.
class WindowsPairingScreen extends ConsumerStatefulWidget {
  const WindowsPairingScreen({super.key});

  @override
  ConsumerState<WindowsPairingScreen> createState() =>
      _WindowsPairingScreenState();
}

class _WindowsPairingScreenState extends ConsumerState<WindowsPairingScreen> {
  final _code = TextEditingController();
  bool _busy = false;
  PairingRefusal? _refusal;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _pair() async {
    setState(() {
      _busy = true;
      _refusal = null;
    });
    final refusal = await ref
        .read(windowsRegistrationProvider)
        .register(_code.text.trim());
    if (!mounted) return;
    setState(() {
      _busy = false;
      _refusal = refusal;
    });
    if (refusal == null) ref.invalidate(windowsRegisteredProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final complete = RegExp(r'^\d{8}$').hasMatch(_code.text.trim());
    return Scaffold(
      appBar: AppBar(title: Text(l10n.merchantPairThisPc)),
      body: ListView(
        padding: const EdgeInsetsDirectional.all(16),
        children: [
          Text(l10n.merchantPairThisPcIntro),
          const SizedBox(height: 16),
          TextField(
            key: const Key('pairing-code-field'),
            controller: _code,
            keyboardType: TextInputType.number,
            maxLength: 8,
            textDirection: TextDirection.ltr,
            decoration: InputDecoration(labelText: l10n.merchantPairingCode),
            onChanged: (_) => setState(() {}),
          ),
          if (_refusal case final refusal?)
            Text(key: const Key('pairing-refusal'), switch (refusal) {
              PairingRefusal.invalidCode => l10n.merchantPairingInvalid,
              PairingRefusal.tooMany => l10n.merchantPairingTooMany,
              PairingRefusal.terminated => l10n.merchantPairingTerminated,
              PairingRefusal.failed => l10n.merchantPairingFailed,
            }),
          const SizedBox(height: 16),
          FilledButton(
            key: const Key('pair'),
            onPressed: _busy || !complete ? null : () => unawaited(_pair()),
            child: Text(l10n.merchantPair),
          ),
        ],
      ),
    );
  }
}
