import 'package:core_ui/core_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // CU §5.2: Syrian mobiles are 9 digits after +963 and start with 9; the
  // app accepts 09xxxxxxxx and 9xxxxxxxx. Turkish mobiles are 10 digits
  // after +90 and start with 5; it accepts 05xxxxxxxxx and 5xxxxxxxxx.
  group('Syria', () {
    String? e164(String input) => foxPhoneE164(FoxPhoneCountry.syria, input);

    test('accepts 09 and 9 and gives E.164', () {
      expect(e164('0912345678'), '+963912345678');
      expect(e164('912345678'), '+963912345678');
    });

    test('ignores spaces, dashes and Arabic-Indic digits', () {
      expect(e164('091 234 5678'), '+963912345678');
      expect(e164('091-234-5678'), '+963912345678');
      expect(e164('٠٩١٢٣٤٥٦٧٨'), '+963912345678');
    });

    test('refuses a wrong length or a wrong first digit', () {
      expect(e164('091234567'), isNull);
      expect(e164('09123456789'), isNull);
      expect(e164('812345678'), isNull);
      expect(e164('0812345678'), isNull);
      expect(e164(''), isNull);
      expect(e164('0'), isNull);
    });
  });

  group('Turkey', () {
    String? e164(String input) => foxPhoneE164(FoxPhoneCountry.turkey, input);

    test('accepts 05 and 5 and gives E.164', () {
      expect(e164('05321234567'), '+905321234567');
      expect(e164('5321234567'), '+905321234567');
    });

    test('refuses a wrong length or a wrong first digit', () {
      expect(e164('0532123456'), isNull);
      expect(e164('053212345678'), isNull);
      expect(e164('4321234567'), isNull);
      expect(e164('9321234567'), isNull);
    });
  });

  test('the dial codes and the digit counts of the two countries', () {
    expect(FoxPhoneCountry.syria.dialCode, '+963');
    expect(FoxPhoneCountry.turkey.dialCode, '+90');
  });
}
