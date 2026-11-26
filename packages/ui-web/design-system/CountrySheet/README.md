# CountrySheet

The phone field's country list, a searchable list of every region that opens beside its trigger.

## Behaviour

- Sections, each named: «الأكثر استعمالاً» (Syria and Turkey), «آخر ما استعملته» (`lastUsed`, when it is neither) and «كل الدول» in Arabic order. Each row is 48 high: the Arabic name and its calling code; no flags.
- The search finds a country by its Arabic name, its English name (any case) or its calling code (`+49`, `0049`, `49`, in any digits); with nothing found it says `emptyLabel`.
- `value` is the picked country (ISO), `onValueChange` receives the new one. The children are the button that opens it, a `CountrySheet.Trigger`; focus returns to it when the list closes.

## RTL and accessibility

The list is right to left; every calling code is isolated left to right. The search field is a combobox over a listbox; the arrows move, Enter picks, Escape closes. The phone field's chip uses it; the Flutter twin is a bottom sheet with radio rows.
