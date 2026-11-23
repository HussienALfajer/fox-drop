# PhoneField

The phone number of the customer app: one pill with a left-to-right island inside, the country chip and its chevron, then the digits.

## Countries and format

- The chip offers «سوريا +963» and «تركيا +90» (names passed as `countryLabels`); `defaultCountry` is Syria unless the app passes `customer.phone_default_country`.
- Syrian mobiles: 9 digits after +963, starting with 9; `09xxxxxxxx` and `9xxxxxxxx` are accepted. Turkish: 10 digits after +90, starting with 5; `05xxxxxxxxx` and `5xxxxxxxxx`.
- `onValueChange` receives the number in E.164 (`+963912345678`) once it is a complete mobile number, and an empty string before. Arabic-Indic digits and a pasted `+963` are accepted.

## RTL and accessibility

The label and the error stay right to left; the island (chip and digits) stays left to right so the number reads correctly. The digits are the labelled input; the chip has its own name, `countryLabel`.
