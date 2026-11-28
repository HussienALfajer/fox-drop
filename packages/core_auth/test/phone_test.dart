import 'package:core_auth/core_auth.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter_test/flutter_test.dart';

// The number's rules are `phone_rules.dart`, tested against the table in
// `test/phone-cases.json` (D.11b).
void main() {
  test('reads any country through the shared rules', () {
    expect(e164Phone('SY', '0944 123 456'), '+963944123456');
    expect(e164Phone('SY', '+90 532 123 45 67'), '+905321234567');
    expect(e164Phone('SY', '0112345678'), isNull);
  });

  test('every region of the country list is one the Dart rules know', () {
    for (final country in foxCountryNames) {
      expect(foxCallingCode(country.iso), country.code, reason: country.iso);
    }
  });

  test('reads a code typed in Arabic-Indic digits', () {
    expect(westernDigits('١٢٣ 456'), '123456');
  });
}
