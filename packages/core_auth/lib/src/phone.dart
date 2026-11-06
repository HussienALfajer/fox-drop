/// The countries of the number picker (CU §5.2 item 1).
enum PhoneCountry {
  syria('+963'),
  turkey('+90');

  const PhoneCountry(this.dialCode);

  final String dialCode;
}

const _arabicIndicZero = 0x0660;
const _easternArabicIndicZero = 0x06F0;

/// The number typed in [country] as E.164, or null when it is not a mobile
/// of that country (CU §5.2 item 1): Syrian `09xxxxxxxx` or `9xxxxxxxx`,
/// Turkish `05xxxxxxxxx` or `5xxxxxxxxx`. Spaces and dashes are ignored, and
/// Arabic-Indic digits from an Arabic keyboard count as Western ones (AP
/// §4.7). The full international form is accepted too, for a pasted number.
String? e164Phone(PhoneCountry country, String input) {
  final buffer = StringBuffer();
  for (final rune in input.runes) {
    if (rune >= _arabicIndicZero && rune <= _arabicIndicZero + 9) {
      buffer.writeCharCode(0x30 + rune - _arabicIndicZero);
    } else if (rune >= _easternArabicIndicZero &&
        rune <= _easternArabicIndicZero + 9) {
      buffer.writeCharCode(0x30 + rune - _easternArabicIndicZero);
    } else if (rune != 0x20 && rune != 0x2D) {
      buffer.writeCharCode(rune);
    }
  }
  var digits = buffer.toString();
  final international = country.dialCode.substring(1);
  if (digits.startsWith('+$international')) {
    digits = digits.substring(international.length + 1);
  } else if (digits.startsWith('00$international')) {
    digits = digits.substring(international.length + 2);
  } else if (digits.startsWith('0')) {
    digits = digits.substring(1);
  }
  final national = switch (country) {
    PhoneCountry.syria => RegExp(r'^9\d{8}$'),
    PhoneCountry.turkey => RegExp(r'^5\d{9}$'),
  };
  return national.hasMatch(digits) ? '${country.dialCode}$digits' : null;
}

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
