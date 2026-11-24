import 'package:flutter/widgets.dart';

import '../status_chip/fox_tone.dart';
import '../theme/fox_theme.dart';

/// The states every Money use case and golden shows (R3), as the web's.
const moneyStates = [
  'default',
  'fraction',
  'large',
  'negative',
  'gain',
  'total',
];

/// The size of an amount: a row's secondary text up to the total's number.
enum FoxMoneyRole { secondary, body, subtitle, number }

const _minus = '−';
final _integer = RegExp(r'^-?\d+$');

/// An amount in minor units as text (AP §4.7; owner, 2026-11-24): Western
/// digits, a Western comma between thousands, a whole amount drops its
/// fraction and any other shows every minor digit; the minus is U+2212 and
/// [signed] puts a plus on a gain. The value never passes through a double.
String foxFormatAmount(String minor, int decimals, {bool signed = false}) {
  if (!_integer.hasMatch(minor)) {
    throw FormatException('Not an integer of minor units', minor);
  }
  final negative = minor.startsWith('-');
  final digits = (negative ? minor.substring(1) : minor).replaceFirst(
    RegExp(r'^0+(?=\d)'),
    '',
  );
  final padded = digits.padLeft(decimals + 1, '0');
  final whole = padded.substring(0, padded.length - decimals);
  final fraction = padded.substring(padded.length - decimals);
  final grouped = whole.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  final amount = RegExp(r'^0*$').hasMatch(fraction)
      ? grouped
      : '$grouped.$fraction';
  final zero = RegExp(r'^0+$').hasMatch(digits);
  final sign = zero
      ? ''
      : negative
      ? _minus
      : signed
      ? '+'
      : '';
  return '$sign$amount';
}

/// An amount and its currency symbol, as every app shows money: one
/// right-to-left run, so in Arabic the symbol sits to the amount's left as the
/// Figma file draws it, in tabular digits; the ₺ comes from Fox Lira.
class FoxMoney extends StatelessWidget {
  const FoxMoney({
    super.key,
    required this.amount,
    required this.symbol,
    this.decimals = 2,
    this.signed = false,
    this.role = FoxMoneyRole.body,
    this.tone,
    this.color,
    this.bold = false,
  });

  /// Minor units, as the API sends them: «41000» TRY is «410 ₺».
  final String amount;

  /// The currency's symbol from its data row: «₺», «\$», «ل.س».
  final String symbol;
  final int decimals;
  final bool signed;
  final FoxMoneyRole role;

  /// Success for a discount or a gain, danger for an amount owed.
  final FoxTone? tone;

  /// Overrides the tone: ivory on the orange total bar.
  final Color? color;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final base = switch (role) {
      FoxMoneyRole.secondary => theme.text.secondary,
      FoxMoneyRole.body => theme.text.body,
      FoxMoneyRole.subtitle => theme.text.subtitle.copyWith(
        fontWeight: FontWeight.w700,
      ),
      FoxMoneyRole.number => theme.text.number,
    };
    return Text(
      '${foxFormatAmount(amount, decimals, signed: signed)} $symbol',
      textDirection: TextDirection.rtl,
      softWrap: false,
      style: base.copyWith(
        color: color ?? tone?.strong(theme.colors) ?? theme.colors.onSurface,
        fontWeight: bold ? FontWeight.w700 : null,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}
