import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';

typedef PaymentLine = ({String amount, String currency});

/// Minor units («24000») to an amount to type («240» or «240.50»). The three
/// seeded currencies have 2 minor digits (`core_l10n`'s table).
String majorOf(String minor) {
  final value = BigInt.parse(minor);
  final digits = value.abs().toString().padLeft(3, '0');
  final whole = digits.substring(0, digits.length - 2);
  final fraction = digits.substring(digits.length - 2);
  return '${value.isNegative ? '-' : ''}$whole${fraction == '00' ? '' : '.$fraction'}';
}

/// A typed amount back to minor units, without floating point; null when it
/// is not a positive amount with at most 2 decimals.
String? minorOf(String typed) {
  final match = RegExp(r'^(\d+)(?:[.,](\d{1,2}))?$').firstMatch(typed.trim());
  if (match == null) return null;
  final minor =
      BigInt.parse(match.group(1)!) * BigInt.from(100) +
      BigInt.parse((match.group(2) ?? '0').padRight(2, '0'));
  return minor > BigInt.zero ? minor.toString() : null;
}

/// RA §8.10 items 6 and 8: what the restaurant actually received, as currency
/// lines prefilled with the captain's. Null when closed without sending.
Future<List<PaymentLine>?> showDisputeSheet(
  BuildContext context,
  List<PaymentLine> prefilled,
) => showModalBottomSheet<List<PaymentLine>>(
  context: context,
  isScrollControlled: true,
  builder: (context) => _DisputeSheet(prefilled: prefilled),
);

class _DisputeSheet extends StatefulWidget {
  const _DisputeSheet({required this.prefilled});

  final List<PaymentLine> prefilled;

  @override
  State<_DisputeSheet> createState() => _DisputeSheetState();
}

class _DisputeSheetState extends State<_DisputeSheet> {
  late final _fields = [
    for (final line in widget.prefilled)
      TextEditingController(text: majorOf(line.amount)),
  ];
  bool _invalid = false;

  @override
  void dispose() {
    for (final field in _fields) {
      field.dispose();
    }
    super.dispose();
  }

  void _send() {
    final lines = <PaymentLine>[];
    for (var i = 0; i < _fields.length; i++) {
      final minor = minorOf(_fields[i].text);
      if (minor == null) {
        setState(() => _invalid = true);
        return;
      }
      lines.add((amount: minor, currency: widget.prefilled[i].currency));
    }
    Navigator.of(context).pop(lines);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: 16,
        end: 16,
        top: 16,
        bottom: 16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.merchantDisputeTitle),
          for (var i = 0; i < _fields.length; i++)
            TextField(
              key: Key('dispute-$i'),
              controller: _fields[i],
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: l10n.merchantDisputeAmount(
                  l10n.currencySymbol(widget.prefilled[i].currency),
                ),
                errorText: _invalid ? l10n.merchantLinesRefused : null,
              ),
            ),
          FilledButton(
            key: const Key('dispute-send'),
            onPressed: _send,
            child: Text(l10n.merchantSend),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.merchantClose),
          ),
        ],
      ),
    );
  }
}
