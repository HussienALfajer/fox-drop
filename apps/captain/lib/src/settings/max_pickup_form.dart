import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../work/door_payment.dart' show majorOf, minorOf;
import 'max_pickup.dart';

/// «أقصى مبلغ أحمله» (CA §10.5, C4): an amount in the base currency, or
/// «بلا حد». On «الإعدادات» and in the question at «متصل» (K2). Unstyled
/// until the design.
class MaxPickupForm extends ConsumerStatefulWidget {
  const MaxPickupForm({super.key, required this.value, this.onSaved});

  final MaxPickup value;

  /// After the server took the answer.
  final VoidCallback? onSaved;

  @override
  ConsumerState<MaxPickupForm> createState() => _MaxPickupFormState();
}

class _MaxPickupFormState extends ConsumerState<MaxPickupForm> {
  late final _field = TextEditingController(
    text: switch (widget.value.limit) {
      final limit? => majorOf(limit),
      null => '',
    },
  );
  bool _invalid = false;
  bool _sending = false;

  @override
  void dispose() {
    _field.dispose();
    super.dispose();
  }

  Future<void> _save(String? minor) async {
    setState(() => _sending = true);
    final saved = await ref.read(maxPickupProvider.notifier).set(minor);
    if (!mounted) return;
    setState(() => _sending = false);
    if (saved) {
      widget.onSaved?.call();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).captainSaveFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final value = widget.value;
    final limit = value.limit;
    final currency = value.currency;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.captainMaxPickupExplain),
        Text(
          limit == null || currency == null
              ? l10n.captainMaxPickupNone
              : l10n.captainMaxPickupCurrent(l10n.formatMoney(limit, currency)),
          key: const Key('max-pickup-current'),
        ),
        TextField(
          key: const Key('max-pickup-field'),
          controller: _field,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: l10n.captainMaxPickupField,
            errorText: _invalid ? l10n.captainMaxPickupInvalid : null,
          ),
        ),
        FilledButton(
          // The city has no base yet: nothing to type an amount in.
          onPressed: _sending || currency == null
              ? null
              : () {
                  final minor = minorOf(_field.text);
                  setState(() => _invalid = minor == null);
                  if (minor != null) _save(minor);
                },
          child: Text(l10n.save),
        ),
        TextButton(
          onPressed: _sending ? null : () => _save(null),
          child: Text(l10n.captainMaxPickupNoLimit),
        ),
      ],
    );
  }
}

/// K2: at «متصل», while the captain has never answered «أقصى مبلغ أحمله»,
/// the question before going online, once: «حفظ» or «بلا حد» answers it. A
/// read that fails never holds going online back.
Future<void> askMaxPickupUnanswered(BuildContext context, WidgetRef ref) async {
  final MaxPickup value;
  try {
    value = await ref.read(maxPickupProvider.future);
  } on Object {
    ref.invalidate(maxPickupProvider);
    return;
  }
  if (value.answered || !context.mounted) return;
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialog) {
      final l10n = AppLocalizations.of(dialog);
      return AlertDialog(
        key: const Key('max-pickup-question'),
        title: Text(l10n.captainMaxPickup),
        content: SingleChildScrollView(
          child: MaxPickupForm(
            value: value,
            onSaved: () => Navigator.of(dialog).pop(),
          ),
        ),
      );
    },
  );
}
