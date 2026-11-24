# AmountsSummary

The money lines of an order and its total (CU §10.3, §12.3).

## Behaviour

- Each line is a label and an amount in minor units, parted by dashed rules; a line's `text` replaces the amount («مجاني»); a discount takes `tone="success"`.
- `variant="prominent"` puts the total on the orange bar of the Figma cart, for the customer's cart and checkout; `plain` writes it bold under a rule everywhere else.
- `equivalents` shows one equivalent per accepted currency under the total.

## RTL and accessibility

The lines are a list, so a screen reader announces their count; each amount is a Money run.
