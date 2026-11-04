# 15. Server commands

> Part of the [customer app spec](README.md) (CU). A bare "§n" here means CU §n.

Every command carries an idempotency key (§4.5), is checked on the server against the account's state and the order's state, and returns the new state.

| Command | Allowed when | Effect |
|---|---|---|
| Check a point | Any time | Zone, coverage and the list of restaurants (§7.1) |
| Vote for an area | Point outside every zone, once per device per point | Vote recorded (§7.2) |
| Request a code / verify a code | Not signed in | Session, or the new-account step (§5.2) |
| Complete the account | New account | Name, gender, birthday and terms recorded (§5.3) |
| Update the profile | Signed in | Fields updated (§13) |
| Add, edit or delete an address | Signed in, pin inside an active zone | Address saved (§7.3) |
| Get a quote | Any time | The quote (§10.6) |
| Place an order | Signed in, the quote version is current, every check passes | `placed` (§10.7) |
| Cancel an order | Own order, `placed` | `cancelled` (§11.4) |
| Reveal the captain's number | Own order, `picked_up` or `arrived` | The number for the dialer only; the tap is recorded (§11.3) |
| Answer a ping («أنا قادم» or «سأتصل بالمستلم») | Own order, `arrived`, after a ping | The captain is told (§11.7) |
| Rate | Own delivered order, within the window, part not yet rated | Rating stored (§12.1) |
| Report a problem | Own delivered order, within the window, no report yet | Ticket created (§12.2) |
| Report a price | Signed in, not yet today for this restaurant | Ticket created (§9.5) |
| Suggest a restaurant | Any time | Lost-demand entry (§8.3) |
| Add or remove a favourite | Signed in | Favourites updated (§9.6) |
| Accept terms | A pending version | Recorded (§4.7) |
| Register the push token | Every launch | Token stored for this device |
| Sign out | Signed in | This device's session ends |
| Sign out every device | Signed in | Every session of the account ends (§5.4) |
| Close the account | No active order, fresh code | `مغلق` (§5.6) |

**Real-time events** the app subscribes to, on its order and account channels:

- order status, captain assignment and change, captain position (after pickup)
- edits, time changes, item-unavailable reports opened and closed, outcomes and amounts to collect
- door pings
- account state changes, new codes, ticket resolutions
- platform broadcasts: emergency stop, maintenance, version
