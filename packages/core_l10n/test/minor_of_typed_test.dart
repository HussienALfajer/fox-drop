import 'package:core_l10n/core_l10n.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // An amount typed in major units, sent in minor units (CU §9.5).
  test('reads an amount typed in major units', () {
    expect(minorOfTyped('120', 'TRY'), '12000');
    expect(minorOfTyped(' 10.5 ', 'USD'), '1050');
    expect(minorOfTyped('10.25', 'SYP'), '1025');
    expect(minorOfTyped('10.255', 'TRY'), isNull);
    expect(minorOfTyped('0', 'TRY'), isNull);
    expect(minorOfTyped('-5', 'TRY'), isNull);
    expect(minorOfTyped('١٢٠٫٥', 'TRY'), '12050');
    expect(minorOfTyped('abc', 'TRY'), isNull);
  });
}
