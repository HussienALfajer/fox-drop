import 'package:flutter_test/flutter_test.dart';
import 'package:merchant/src/settings/pickup_currencies.dart';

void main() {
  // RA §12.7: the base is fixed; the others keep the city's display order.
  test('switching a currency keeps the others in the city’s order', () {
    const currencies = PickupCurrencies(
      base: CurrencyChoice('TRY', 'ليرة تركية'),
      accepted: ['SYP'],
      choices: [
        CurrencyChoice('USD', 'دولار أمريكي'),
        CurrencyChoice('SYP', 'ليرة سورية'),
      ],
    );
    expect(currencies.switched('USD', on: true), ['USD', 'SYP']);
    expect(currencies.switched('SYP', on: false), isEmpty);
    expect(currencies.switched('USD', on: false), ['SYP']);
  });
}
