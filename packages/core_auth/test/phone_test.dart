import 'package:core_auth/core_auth.dart';
import 'package:flutter_test/flutter_test.dart';

// CU §5.2 item 1.
void main() {
  test('takes Syrian mobiles with or without the leading 0', () {
    expect(e164Phone(PhoneCountry.syria, '0944 123 456'), '+963944123456');
    expect(e164Phone(PhoneCountry.syria, '944123456'), '+963944123456');
    expect(e164Phone(PhoneCountry.syria, '+963944123456'), '+963944123456');
    expect(e164Phone(PhoneCountry.syria, '٠٩٤٤١٢٣٤٥٦'), '+963944123456');
  });

  test('takes Turkish mobiles with or without the leading 0', () {
    expect(e164Phone(PhoneCountry.turkey, '0532-123-4567'), '+905321234567');
    expect(e164Phone(PhoneCountry.turkey, '5321234567'), '+905321234567');
    expect(e164Phone(PhoneCountry.turkey, '00905321234567'), '+905321234567');
  });

  test('refuses what is not a mobile of the chosen country', () {
    expect(e164Phone(PhoneCountry.syria, '0211234567'), isNull);
    expect(e164Phone(PhoneCountry.syria, '94412345'), isNull);
    expect(e164Phone(PhoneCountry.syria, '5321234567'), isNull);
    expect(e164Phone(PhoneCountry.turkey, '944123456'), isNull);
    expect(e164Phone(PhoneCountry.turkey, ''), isNull);
  });

  test('reads a code typed in Arabic-Indic digits', () {
    expect(westernDigits('١٢٣ 456'), '123456');
  });
}
