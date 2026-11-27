import 'dart:convert';
import 'dart:io';

import 'package:core_auth/core_auth.dart';
import 'package:flutter_test/flutter_test.dart';

/// `{U+XXXX}` in the table is the invisible character itself.
String _withMarks(String text) => text.replaceAllMapped(
  RegExp(r'\{U\+([0-9A-F]{4})\}'),
  (m) => String.fromCharCode(int.parse(m[1]!, radix: 16)),
);

// D.11's normalisation table: the web's phone field, once rebuilt, reads a
// number by the same rules and the same table.
void main() {
  final table =
      jsonDecode(File('test/phone-cases.json').readAsStringSync())
          as Map<String, dynamic>;
  final cases = (table['cases'] as List).cast<Map<String, dynamic>>();

  group('foxReadPhone: every row of phone-cases.json', () {
    for (final c in cases) {
      test(c['name'] as String, () {
        final read = foxReadPhone(
          _withMarks(c['input'] as String),
          c['picked'] as String,
        );
        expect(
          {
            'country': read.country,
            'grouped': read.grouped,
            'e164': read.e164,
            'problem': read.problem?.name,
            'missing': read.missing,
            'prefix': read.prefix,
            'switchedFrom': read.switchedFrom,
          },
          {
            'country': c['country'],
            'grouped': c['grouped'],
            'e164': c['e164'],
            'problem': c['problem'],
            'missing': c['missing'],
            'prefix': c['prefix'],
            'switchedFrom': c['switchedFrom'],
          },
        );
      });
    }
  });

  test('cleans to + and Western digits only', () {
    expect(
      foxCleanPhone('${String.fromCharCode(0x200F)}+٩٦٣ (944)-123.456'),
      '+963944123456',
    );
    expect(foxCleanPhone('call 0944 123 456 now'), '0944123456');
  });

  test('groups by three, the rest as one group of up to four', () {
    expect(foxGroupDigits('944123456'), '944 123 456');
    expect(foxGroupDigits('5321234567'), '532 123 4567');
    expect(foxGroupDigits('9441'), '9441');
  });

  test('knows every region’s calling code', () {
    expect(foxCallingCode('SY'), '963');
    expect(foxCallingCode('TR'), '90');
    expect(foxCallingCode('XX'), isNull);
  });
}
