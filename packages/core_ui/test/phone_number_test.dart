import 'package:core_ui/core_ui.dart';
import 'package:flutter_test/flutter_test.dart';

// Every case of `packages/ui-web/src/phone-field/phone.test.ts`: the web and
// Flutter read a phone number by the same rules (CU §5.2).
const sy = FoxPhoneCountry.syria;
const tr = FoxPhoneCountry.turkey;

String? e164(FoxPhoneCountry country, String text) =>
    foxParsePhone(country, text).e164;

void main() {
  // CU §5.2: Syrian mobiles have 9 digits after +963 and start with 9 (09xxxxxxxx
  // and 9xxxxxxxx are accepted); Turkish mobiles have 10 digits after +90 and
  // start with 5 (05xxxxxxxxx and 5xxxxxxxxx); the number is stored in E.164.
  group('the picked country', () {
    for (final (country, typed, expected) in [
      (sy, '0912345678', '+963912345678'),
      (sy, '912345678', '+963912345678'),
      (sy, '09 123 456 78', '+963912345678'),
      (sy, '091-234-5678', '+963912345678'),
      (tr, '05321234567', '+905321234567'),
      (tr, '5321234567', '+905321234567'),
    ]) {
      test('$country $typed is $expected', () {
        expect(e164(country, typed), expected);
        expect(foxPhoneE164(country, typed), expected);
      });
    }

    for (final (country, typed) in [
      (sy, '091234567'), // 8 digits
      (sy, '0812345678'), // starts with 8
      (sy, '5321234567'), // a Turkish number under Syria
      (tr, '0532123456'), // 9 digits
      (tr, '9123456789'), // starts with 9
      (sy, ''),
      (sy, '0'),
    ]) {
      test('$country "$typed" is not a complete mobile number', () {
        expect(e164(country, typed), isNull);
      });
    }

    test(
      'reads Arabic-Indic and Persian digits as Western digits (AP §4.7)',
      () {
        expect(e164(sy, '٠٩١٢٣٤٥٦٧٨'), '+963912345678');
        expect(e164(sy, '۰۹۱۲۳۴۵۶۷۸'), '+963912345678');
        expect(foxPhoneDigits('۰۹١٢'), '0912');
      },
    );

    test('keeps the digits as typed in the box', () {
      expect(foxParsePhone(sy, '09123').display, '09123');
    });
  });

  group('never cuts digits', () {
    for (final (country, typed) in [
      (sy, '09123456789'),
      (sy, '9123456789'),
      (sy, '09123456789999'),
      (tr, '053212345678'),
    ]) {
      test('$country $typed is refused, not shortened', () {
        final parsed = foxParsePhone(country, typed);
        expect(parsed.refused, isTrue);
        expect(parsed.e164, isNull);
        expect(parsed.display, typed);
      });
    }
  });

  group('a number with its own calling code', () {
    for (final (picked, typed, country, expected) in [
      (sy, '+963 912 345 678', sy, '+963912345678'),
      (sy, '00963912345678', sy, '+963912345678'),
      (sy, '963912345678', sy, '+963912345678'), // not +963963912345
      (tr, '+90 532 123 45 67', tr, '+905321234567'),
      (tr, '905321234567', tr, '+905321234567'),
    ]) {
      test('$picked picked, $typed is $country $expected', () {
        final parsed = foxParsePhone(picked, typed);
        expect(parsed.country, country);
        expect(parsed.e164, expected);
        expect(parsed.refused, isFalse);
      });
    }

    for (final (picked, typed, country, expected) in [
      (sy, '+905321234567', tr, '+905321234567'),
      (sy, '00905321234567', tr, '+905321234567'),
      (sy, '905321234567', tr, '+905321234567'),
      (tr, '+963912345678', sy, '+963912345678'),
      (tr, '00963912345678', sy, '+963912345678'),
      (tr, '963912345678', sy, '+963912345678'),
    ]) {
      test(
        'the other country: $picked picked, $typed switches to $country',
        () {
          final parsed = foxParsePhone(picked, typed);
          expect(parsed.country, country);
          expect(parsed.e164, expected);
        },
      );
    }

    for (final (picked, typed) in [
      (sy, '+90912345678'), // +90 and a number that is not Turkish
      (sy, '+9059123'), // incomplete
      (tr, '+9639123'), // incomplete
      (sy, '+963912345678999'), // too long
      (sy, '+441234567890'), // neither country
    ]) {
      test('$picked $typed is refused, never reshaped into another number', () {
        final parsed = foxParsePhone(picked, typed);
        expect(parsed.refused, isTrue);
        expect(parsed.e164, isNull);
        expect(parsed.country, picked);
      });
    }
  });

  group('foxPhoneFromE164', () {
    test('splits a stored number into its country and national digits', () {
      expect(foxPhoneFromE164('+963912345678'), (
        country: sy,
        national: '912345678',
      ));
      expect(foxPhoneFromE164('+905321234567'), (
        country: tr,
        national: '5321234567',
      ));
    });

    test('refuses anything else', () {
      expect(foxPhoneFromE164(''), isNull);
      expect(foxPhoneFromE164('+96381234567'), isNull);
      expect(foxPhoneFromE164('+441234567890'), isNull);
    });
  });

  test('the dial codes of the two countries', () {
    expect(sy.dialCode, '+963');
    expect(tr.dialCode, '+90');
  });
}
