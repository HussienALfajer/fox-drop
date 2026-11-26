# SignInHero

The sign-in screen's head: an illustration of where the guest came from, the title and the lead line.

## Behaviour

- `origin` picks the illustration: `checkout` (the saved cart: the restaurant, the items, the total and «سلّتك محفوظة»), `orders` (the tracking steps on a sample order, passed as `steps`) or `account` (what an account keeps, as small cards).
- It gives way by the height it is given: first the lead goes, then the illustration, never the title. `keyboard` shows the title alone, smaller, at the bottom.

## RTL and accessibility

The title is the page's heading; the illustration is hidden from screen readers, since the title and the lead say it in words. Amounts show in Western digits.
