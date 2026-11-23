# DataTable

The panel's and portal's table, compact 40, with sort, selection, loading and empty rows.

## Behaviour

- `columns` give each header and cell; `numeric` aligns numbers and money to the end in tabular digits.
- A `sortable` column's header is a button; the table asks the app to sort through `onSortChange`.
- With `selection` and `onSelectionChange` each row gets a checkbox named by `rowLabel`; `onRowOpen` opens a row by click or Enter.
- `loading` adds skeleton rows; with no rows `empty` (an EmptyState) shows inside the table.

## RTL and accessibility

The sorted column says so with `aria-sort`; the header stays in view while the table scrolls; a wide table scrolls in its own box.
