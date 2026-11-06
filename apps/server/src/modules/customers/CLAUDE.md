# customers module

The customers' profiles and saved addresses (architecture §4.2; CU §5.3, §7). Trust, strikes and dues (AP §8.8) join with their slices.

## Rules

- **The account is identity's:** `customer_accounts` and sign-in live in `identity`; this module keys its rows by the account id, a plain column, and reads `AppSession.accountId` in its routes.
- **Details (CU §5.3):** `profiles`, one row per account, written by `PUT /v1/customer/profile` («أكمل بياناتك», and later edits in «حسابي»). The first save needs `acceptTerms` (`400 terms_required`) and records `terms_accepted_at`; the terms versions (AP §9.13) join with the content slice. Names are 2 to 30 Arabic or Latin letters with spaces and «-», two letters at least, Arabic marks such as the shadda allowed; the birthday is optional and before today on Syria's clock (`400 invalid_birthday`). `GET /v1/customer/profile` answers `completed: false` until the first save, so an app that stopped before the details shows them again whatever `newAccount` said.
- **The zone check (CU §7.1):** `GET /v1/customer/location` (public, for guests too, CU §5.1) answers `served`, `no_restaurants` or `outside_zones`, with the zone. The app knows no city: `GeoService.locate` finds it from the point, then `MerchantsService.coveringRestaurants` tells the first two apart.
- **Votes (CU §7.2):** `POST /v1/customer/zone-votes` (public) records the point through `GeoService.castVote`; geo owns the votes and their rules.
- **Saved addresses (CU §7.3):** `addresses`, never deleted (`deleted_at`), up to 10 (`MAX_ADDRESSES`, `409 address_limit`), one default (a partial unique index): the first address is the default, `isDefault` or `PUT …/default` moves it (never to one outside every active zone, `409 outside_zones`), and deleting the default passes it to the newest remaining address inside a zone, or else the newest. The pin must be inside an active zone when saved or edited (`409 outside_zones`); the city comes from `GeoService.locate`. «الحي» is not stored: each read names the active zone at the pin, and null is «خارج منطقة التوصيل حالياً» (Q6). Changes of one customer's addresses take turns on an advisory lock.
- **Contact number (U5, Q5):** null is the account's own number (the app sends null when the customer keeps it); another Syrian or Turkish mobile is kept encrypted with identity's key (`PhoneCipher`, architecture §15.3) and needs «اسم المستلم» (a `CHECK` and the route's schema).
- **Snapshots (Q6):** an order keeps its own copy of the address (slice 1.8), so editing or deleting one changes no order.

## Not yet

- Idempotency keys on the address commands (CU §15, §4.5): they arrive with the order command's mechanism (slice 1.8); until then a lost answer retried adds a second address.
- A request limit on the public vote route: the deploy slice's per-IP limits in nginx (architecture §15.5) must cover `/v1/customer/zone-votes`.
- Recognising the account's own number typed as another contact number (it then asks for a recipient).
- Favourites (CU §9.6) and the price report (§9.5): Phase 2 (owner decision 2026-11-06).
- Account states (CU §5.5), closing the account (§5.6), trust, strikes and dues (AP §8.8).
- The panel's customer screens (AP §9.8).
