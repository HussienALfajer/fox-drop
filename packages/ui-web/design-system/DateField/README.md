# DateField

A date: a pill with a calendar icon that shows the date as dd/mm/yyyy and opens a calendar of one month.

## Behaviour

- The value is an ISO date (`2027-03-05`), shown `05/03/2027` in Western digits, or the `placeholder` while empty. `onValueChange` receives the ISO date.
- The calendar shows the region's Syriac month names (كانون الثاني…كانون الأول), the week from Saturday, today ringed in the brand orange and the chosen day filled. `min` and `max` bound it.
- The arrows move by day in the reading direction (left is the next day in Arabic), Page Up and Page Down by month, Enter picks and closes, Escape closes. `previousLabel` and `nextLabel` name the month buttons.

## RTL and accessibility

The pill is a button named by the label and the date, described by the hint or the error. The digits and slashes keep their left-to-right order. The Flutter twin (`FoxDateField`) opens its calendar as a dialog.
