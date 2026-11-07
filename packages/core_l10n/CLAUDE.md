# packages/core_l10n

The Arabic strings of the three Flutter apps (architecture §11.2, AP §4.7).

## Rules

- Add a string to `lib/src/arb/app_ar.arb` with an `@key` description, then run `flutter gen-l10n` in this folder and commit `lib/src/generated/` with it. `pnpm verify` regenerates the folder and fails when the committed one is stale. Never edit `lib/src/generated/` by hand.
- Arabic is the only locale. Strings use Western digits; `test/western_digits_test.dart` fails an ARB value with Arabic-Indic digits, and proves that intl formats numbers and dates in the apps' locale with Western digits. A placeholder that formats a value (a number, a date, money) adds its case to that test.
- A string that belongs to one app is prefixed with the app (`customerAppName`); shared strings have no prefix.
- **Formatters** (`lib/src/formats.dart`, the `Formats` extension on `AppLocalizations`; CU §4.6): `formatMoney` takes the API's minor units and the currency code («410 ₺», «10.50 $»; a whole amount drops its fraction), from a table of the three currencies the server seeds (the API sends no symbol or digits; an unknown code shows itself). Times are 12-hour with «ص/م» on the phone's clock, dates `dd/mm/yyyy`, durations «12 د», distances «850 م» or «2.4 كم». Screens format through these, never by hand; each case is in `western_digits_test.dart`.
- `intl` takes the version the pinned Flutter's `flutter_localizations` pins, and moves with Flutter (`renovate.json`).
