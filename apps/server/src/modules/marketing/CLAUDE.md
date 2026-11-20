# marketing module

Promo codes «أكواد الخصم» (AP §9.11.1), «تعويض الزبون» with its caps and approvals (AP §6.4, §9.3.2), the home sections, the banners and the mass pushes (AP §9.11.2-9.11.4); architecture §4.2.

## Rules

- **Ownership:** this module owns the `marketing` tables (`promo_codes`, `promo_code_uses`, `idempotency_keys`, `compensations`, `late_codes`, `home_sections`, `banners`, `mass_pushes`). Cities, restaurants, zones, orders and accounts are plain ids; never import another module. Customers and ordering register ports at start (for example `useAudience`); add a port instead of an import.
- **Pure rules:** `promo-codes.ts` holds the code rules and `normalizeCode`, with `promo-discount.test.ts` for the money. Ordering calls only the public `PromoCodeUsesService` (`check` for the quote, `hold` for placing, `record` once the order has its id). `promoDiscount` works in integer minor units, half up (AP §8.4).
- **Advisory locks:** `hold` takes `marketing.code:<id>` so two orders never take the last use or the rest of the day. A compensation takes `marketing.compensation:<orderId>`, then `marketing.codes:<cityId>`; do not add a currencies lock after them (it inverts the lock order with `CaptainsService.setCustodyLimit`).
- **Personal codes:** a compensation code or a late code is made only by `createPersonalCode` (`personal-codes.ts`), shared by `CompensationsService` and `LateCodesService`, never in «أكواد الخصم». The list, the report and every code route leave them out (`unknown_promo_code`).
- **Idempotency:** creating a code or a batch takes `Idempotency-Key` (per admin account, a hash of the command, checked under the key's advisory lock; another command with the key is `422 idempotency_key_reused`). Edit, pause and resume set a value, so they take none.
- **Audit:** every admin write is audited with a dotted action (`promo_code.create`, `.generate`, `.edit`, `.pause`, `.resume`, `mass_push.create`, `mass_push.cancel`).
- **Money and permissions:** money travels as strings of minor units, percentages and ratios as basis points. Reads need `marketing.read`, writes `marketing.manage` (OWN); costs show only with `marketing.read_costs` or `marketing.manage`.
- **Mass pushes:** the audience is the customers module's to say (never a guest) and is fixed at the confirmation. One transaction records the push and queues one push per customer through `PushQueue`. The application role may update only `cancelled_at` and `cancelled_by`.
- **Words and layout:** every label is a translation, in Arabic, with Western digits; codes are upper-case Latin letters and digits.

## More

Behaviour, decisions and slice history: `docs/code/apps/server/src/modules/marketing.md`. Grep it for the feature, route, table or label you are changing and read only those lines; never read it whole.
