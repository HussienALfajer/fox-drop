import 'package:customer/src/checkout/codes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a percentage in basis points shows with Western digits', () {
    expect(percentText(2000), '20');
    expect(percentText(1250), '12.5');
    expect(percentText(1205), '12.05');
    expect(percentText(3333), '33.33');
    expect(percentText(10000), '100');
  });

  test('another code replaces the applied one, whatever its case', () {
    expect(replacesCode(null, 'FOX20'), isFalse);
    expect(replacesCode('fox20', 'FOX20'), isFalse);
    expect(replacesCode('SHIP', 'FOX20'), isTrue);
  });
}
