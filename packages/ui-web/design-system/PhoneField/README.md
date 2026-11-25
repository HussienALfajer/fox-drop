# PhoneField

The phone number of every app: one pill with a left-to-right island inside, the country chip (ISO letters and calling code, a chevron), then the digits, a check mark once the number is a complete mobile, and a clear button.

## Countries and format

- Every region the phone metadata knows. The chip opens a searchable list: Syria and Turkey first, then the last country used (`lastUsedCountry`), then every other country in Arabic order; names and calling codes only, no flags. Search by the Arabic name, the English name or the calling code.
- Accepted as typed or pasted: a national number with or without its 0; `+`, `00` or the bare calling code; a 0 before or after the code; Arabic-Indic and Persian digits; spaces, dashes, brackets, dots, hidden direction marks and no-break spaces; a number inside pasted text. A mobile of another country switches the chip by itself, and the field says so.
- `onValueChange` receives the E.164 number (`+963944123456`) once it is a complete mobile, else an empty string, with the reading. The digits show grouped (`944 123 456`).
- A problem (missing digits, too long, a landline, a prefix that is not a mobile, an unknown code) shows on leaving the field or on Enter, then live until fixed, in the words passed as `messages`.

## RTL and accessibility

The label and the error stay right to left; the island (chip and digits) stays left to right, and every calling code is isolated left to right. The chip is named by `chipLabel` («الدولة: سوريا، +963. اضغط لتغييرها»); `busy` locks the field while the number is sent.
