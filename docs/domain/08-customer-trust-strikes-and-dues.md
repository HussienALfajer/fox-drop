# 8.8 Customer trust, strikes and dues

> Part of AP §8, the domain reference shared by all four V1 specs ([index](README.md)). A bare "§n" here means AP §n.

- **Trust (D23):**
  - New accounts may have `customer.new_max_active_orders` (1) active order at a time.
  - After `customer.trusted_after_delivered_orders` (3) orders that were delivered with outcome `normal`, the account becomes «موثوق» (trusted), with `customer.trusted_max_active_orders` (3).
  - A `fake` outcome removes trust and resets the count.
  - OWN or OPS can mark an account trusted, or remove trust, with a reason.
- **Late cancellation:** a cancellation after the restaurant accepted, at the customer's request. `customer.late_cancel_strikes` (2) within `customer.late_cancel_window_days` (30) blocks ordering «موقوف حتى مراجعة الدعم» until support reviews the account.
- **Fake order:**
  - When the outcome is set to fake, the customer is blocked until they pay their dues.
  - Dues follow `customer.fake_order_dues_rule`: `fee_plus_merchant_net` (default: delivery fee + merchant net), `fee_plus_items_value`, or `fixed` (an amount set by OWN).
  - FIN records the payment at the desk, which unblocks the customer automatically.
- **The device block (owner decision 2026-11-10, slice 2.25b):** a dues block or a manual block follows the account, its phone number and the phone itself, so a new account, another number, a reinstall or a VPN on the same phone cannot order. The device's identity must survive a reinstall (Android ID with Play Integrity's device recall on Android, a Keychain item with DeviceCheck on iOS); the IP address is only a signal, never the block, since a VPN changes it and many customers share one. OWN can lift a device's block with a reason, for a phone sold on.
- **Dues ledger «مستحقات الزبون»** (base currency):

  | Entry             | Sign | When                                                                  |
  | ----------------- | ---- | --------------------------------------------------------------------- |
  | `dues.charge`     | +    | A fake order, or a collection shortfall with the customer responsible |
  | `dues.payment`    | −    | Payment recorded at the desk (receipt)                                |
  | `dues.adjustment` | ±    | Manual correction (OWN/FIN, reason)                                   |

  A dues block lifts automatically when the balance reaches 0 or less.

- **Account closure (D19):**
  - Closure happens from the customer app's own delete-account button, or from the panel on the customer's request. Both lead to the same result (app stores require deletion to be possible inside the app).
  - Closure is refused while the customer has an active order, in the app and in the panel.
  - Status becomes «مغلق»: the customer cannot sign in and drops out of active-customer lists.
  - All data is kept.
  - If the same phone number registers again, a new account is created and linked internally to the closed one. Blocks, unpaid dues, strikes, trust state and promo history carry over, so the new account is **not** a "new user" for promo codes.
