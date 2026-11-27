import 'phone_rules.dart';

/// The E.164 of a mobile of any country typed or pasted under [country]
/// (ISO), or null when it is not one (D.11's normalisation table, read by
/// `phone_rules.dart`).
String? e164Phone(String country, String input) =>
    foxReadPhone(input, country).e164;

const _arabicIndicZero = 0x0660;
const _easternArabicIndicZero = 0x06F0;

/// The digits of [input] with Arabic-Indic digits made Western, for the code
/// field and a pasted code.
String westernDigits(String input) {
  final buffer = StringBuffer();
  for (final rune in input.runes) {
    if (rune >= _arabicIndicZero && rune <= _arabicIndicZero + 9) {
      buffer.writeCharCode(0x30 + rune - _arabicIndicZero);
    } else if (rune >= _easternArabicIndicZero &&
        rune <= _easternArabicIndicZero + 9) {
      buffer.writeCharCode(0x30 + rune - _easternArabicIndicZero);
    } else if (rune >= 0x30 && rune <= 0x39) {
      buffer.writeCharCode(rune);
    }
  }
  return buffer.toString();
}
