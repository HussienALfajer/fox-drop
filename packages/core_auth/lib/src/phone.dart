import 'package:core_l10n/core_l10n.dart';
import 'package:core_ui/core_ui.dart';

/// The phone field's words from the app's strings (D.11 items 5 to 7 and
/// 11): the sign-in screen, the customer's checkout and the restaurant's
/// staff screen pass them to `FoxPhoneField`.
FoxPhoneStrings phoneFieldStrings(AppLocalizations l10n) => FoxPhoneStrings(
  chip: (name, code) => l10n.phoneCountryChip(name, code),
  valid: l10n.phoneValid,
  clear: l10n.phoneClear,
  empty: l10n.phoneEmpty,
  missingDigits: l10n.phoneMissingDigits,
  tooLong: l10n.phoneTooLong,
  landline: l10n.phoneLandline,
  notMobilePrefix: l10n.phoneNotMobilePrefix,
  unknownCode: l10n.phoneUnknownCode,
  switched: l10n.phoneSwitchedCountry,
  sheet: FoxCountrySheetStrings(
    title: l10n.countrySheetTitle,
    close: l10n.countrySheetClose,
    search: l10n.countrySearch,
    clearSearch: l10n.countrySearchClear,
    pinned: l10n.countryPinned,
    lastUsed: l10n.countryLastUsed,
    all: l10n.countryAll,
    none: l10n.countryNone,
  ),
);

/// The E.164 of a mobile of any country typed or pasted under [country]
/// (ISO), or null when it is not one (D.11's normalisation table, read by
/// core_ui's shared rules).
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
