# customers module

> Moved here from `apps/server/src/modules/customers/CLAUDE.md` on 2026-11-20 (`docs/claude-code-workflow.md`). In these notes, a folder's `CLAUDE.md` (or "its `CLAUDE.md`") means that folder's file under `docs/code/` when there is one, otherwise the folder's own `CLAUDE.md`; the folder's own `CLAUDE.md` now holds only the rules for working there.

The customers' profiles and saved addresses (architecture §4.2; CU §5.3, §7), and their browsing of the restaurants that deliver to a point (CU §8.2, §8.4, §9.1–9.4).
The late-cancellation strikes and review stop (docs/domain/08), the blocks and the dues read (AP §8.8, §9.8; slice 2.25a), and the panel's customers module (AP §9.8).

## Rules

- **The account is identity's:** `customer_accounts` and sign-in live in `identity`; this module keys its rows by the account id, a plain column, and reads `AppSession.accountId` in its routes.
- **Details (CU §5.3):** `profiles`, one row per account, written by `PUT /v1/customer/profile` («أكمل بياناتك», and later edits in «حسابي»).
  The first save needs `acceptTerms` (`400 terms_required`), records `terms_accepted_at` and, in the same transaction, accepts the customer terms in force (`TermsService.acceptCurrent`, AP §9.13);
  a later version is accepted through `POST /v1/customer/terms/accept` (the content module).
  Names are 2 to 30 Arabic or Latin letters with spaces and «-», two letters at least, Arabic marks such as the shadda allowed;
  the birthday is optional and before today on Syria's clock (`400 invalid_birthday`).
  `GET /v1/customer/profile` answers `completed: false` until the first save, so an app that stopped before the details shows them again whatever `newAccount` said.
- **The zone check (CU §7.1):** `GET /v1/customer/location` (public, for guests too, CU §5.1) answers `served`, `no_restaurants` or `outside_zones`, with the zone.
  The app knows no city: `GeoService.locate` finds it from the point, then `MerchantsService.coveringRestaurants` tells the first two apart.
- **Votes (CU §7.2):** `POST /v1/customer/zone-votes` (public) records the point through `GeoService.castVote`; geo owns the votes and their rules.
- **Saved addresses (CU §7.3):** `addresses`, never deleted (`deleted_at`), up to 10 (`MAX_ADDRESSES`, `409 address_limit`), one default (a partial unique index): the first address is the default, `isDefault` or `PUT …/default` moves it (never to one outside every active zone, `409 outside_zones`), and deleting the default passes it to the newest remaining address inside a zone, or else the newest.
  The pin must be inside an active zone when saved or edited (`409 outside_zones`);
  the city comes from `GeoService.locate`.
  «الحي» is not stored: each read names the active zone at the pin, and null is «خارج منطقة التوصيل حالياً» (Q6).
  Changes of one customer's addresses take turns on an advisory lock.
- **A save retried (CU §19 item 28, slice L.1c):** `POST /v1/customer/addresses` needs `Idempotency-Key`; the key and a SHA-256 of the body without the other contact number (an unkeyed hash of it would undo its encryption; a repeat compares it with the row's, decrypted) sit on the address row (`idempotency_key`, `request_hash`, null on older rows; unique per account where set).
  The key is looked up before the zone check and again under the address lock, before the limit: a repeat answers the first save (`201`, even at 10 addresses), `404 unknown_address` once it was deleted, and another body is `422 idempotency_key_reused`.
  `PUT` and `DELETE` take no key (they set a value, or name their target and a repeat is refused).
- **Contact number (U5, Q5):** null is the account's own number (the app sends null when the customer keeps it);
  another Syrian or Turkish mobile is kept encrypted with identity's key (`PhoneCipher`, architecture §15.3) and needs «اسم المستلم» (a `CHECK` and the route's schema).
- **Browsing (CU §8.2, §9; owner decision 2026-11-06: one plain list in Phase 1):** `BrowsingService` and `customer-browsing.controller.ts`, open to guests (CU §5.1; `@AppSignedInOrGuest()` since slice 2.25b, so an admin test account's session also lists the restaurants in test mode, each card's `testMode` giving «تجريبي», and opens their page; a guest and any other account never see them).
  `GET /v1/customer/restaurants` lists the cards of `coveringRestaurants` for the point: open first, then busy and paused, then closed (holiday closes included), each group in the restaurants' own order;
  empty outside every zone.
  A card has the estimate range, the fee to the point before any item (`deliveryFee` with `itemsValue` 0, null while the city has no fee rule), and the state as customers see it (`MerchantsService.storefrontState`: the holiday or operations message, the next opening while closed by the schedule).
  `GET /v1/customer/restaurants/{id}` adds the description, minimum order, free-delivery threshold, weekly schedule, `deliversHere` and the menu;
  a restaurant customers do not see (not `active` or not visible) answers `404`.
  With `similarTo` (CU §11.9, slice 2.7b), the list is the similar restaurants under a rejected or unanswered order, at its pin (`BrowsingService.similar`): the open ones (busy mode included) of that restaurant's category, without it, in the list's own order, up to 5;
  empty when it has no active category or the server does not know it.
  Since slice 2.27a a card's `categories` are the restaurant's active categories (`CategoriesService.active`, `{ id, name }` in the restaurant's order), `category` the first one's name for older apps;
  «مشابه» means sharing any active category;
  `categoryId` is the category page (CU §8.2): only that category's restaurants in the same order, empty for a category that is not active.
- **The home (CU §8.1, AP §9.11.3; slice 2.27b, owner decisions 2026-11-18):** `GET /v1/customer/restaurants?home=true` answers the list's cards and `sections` (null without `home`, with `similarTo` or `categoryId`): `BrowsingService.home`, the city's shown sections in the panel's order (marketing's `HomeSectionsService.sections`), each `{ kind, title, restaurantIds }` naming cards of the same answer.
  `banners` and `categories` name none (the app fills them);
  «الأقرب إليك» the `HOME_SECTION_SIZE` (10) nearest by the card's trip (the fee's or the estimate's distance);
  «الأكثر طلباً» the 10 with the most orders delivered within `HOME_LOOKBACK_DAYS` (30), ordering's port (`useDeliveredCounts`, registered by `OrdersService`: test orders and free re-deliveries left out), ties in the list's order;
  «جديد على FOX DROP» the 10 first activated within the 30 days (merchants' `activatedAt`), newest first;
  «العروض» every restaurant of a visible code limited to restaurants (marketing's `offerRestaurants`), in the list's order;
  a custom section its restaurants in the admin's order.
  Each takes its restaurants by its own rule whatever their state, then shows them open first, busy and paused, then closed (owner decision 2026-11-18);
  a restaurant section with none is left out.
  Since slice 2.27c the home adds `banners` (null without `home`): marketing's `BannersService.running` (started, not ended, in the point's zone, in the panel's order, a code target only while its code runs now), each `{ id, title, imageKey, target, restaurantIds, categoryId, code }`, left out when the customer cannot open its target here (a restaurant or a list with no card of the answer, the list's cards open first and closed last; a category no longer active; decided by us), then the first `HOME_BANNERS_MAX` (10, owner decision 2026-11-18);
  «البانرات» is left out without one, and none are read while it is hidden.
  The list, the home and the category page share one read of the cards (`listed`, in the sort weight's order with each trip's metres).
- **Search and the lost demand (CU §8.3, AP §9.17; slice 2.28a, owner decisions 2026-11-18):** `GET /v1/customer/search?latitude=&longitude=&q=` (`customer-search.controller.ts`, `@AppSignedInOrGuest()`; `q` 2 to 50 characters after trimming) runs `BrowsingService.search` over the list's cards (`listed`, so only the restaurants that deliver to the point, test mode for an admin test account): `restaurants` whose Arabic or English name or an active category matches, and `items` (each with its restaurant's id, Arabic name and state, at most `SEARCH_ITEMS_MAX`, 50) whose name or description matches among the menu customers see (hidden ones never), both open first and closed last as the list sorts, the items in each restaurant's menu order.
  The match is `search-text.ts` (pure, `search-text.test.ts`): every word of the search inside the fields, after `searchText` drops the diacritics and the tatweel and makes «ة» «ه», «ى» «ي» and «أ», «إ», «آ», «ٱ» «ا», Latin in lower case.
  A search with nothing found at a point a zone serves (not an admin test account's, nor one whose `searchText` form is empty) is kept in `customers.search_misses` (the text, its `searchText` form, the city, the zone, the account or null for a guest; append-only), none outside every zone.
  «لم تجده؟ أخبرنا» is `POST /v1/customer/restaurant-suggestions` (guests too; `restaurantName` 1 to 60, `note` up to 200 and `query` up to 50, empty ones null; `Idempotency-Key` kept on the row, `restaurant_suggestions_key`, a repeat adds nothing and another body is `422 idempotency_key_reused`; `409 outside_zones` where no zone covers the point) into `customers.restaurant_suggestions` (append-only), answering `{ status: 'received' }`.
  `LostDemandService` (`lost-demand.service.ts`) writes both and reads the panel's `GET /v1/admin/lost-demand?cityId=` (`admin-lost-demand.controller.ts`, `reports.operations` or `reports.all`, an operations report of AP §6.2; `404 unknown_city`): within `LOST_DEMAND_DAYS` (30), the `LOST_DEMAND_ROWS` (100) searches missed most (grouped by the `searchText` form, the latest text typed, the count and the latest time) and the 100 latest suggestions.
- **Favourites (CU §9.6, U18; slice 2.28b, owner decisions 2026-11-18):** `customers.favourites`, one row per account and restaurant (`FavouritesService`, `favourites.ts`): the heart sets `added_at` and clears `removed_at`, removing it sets `removed_at`, so a row is never deleted (`favourites_removed_after_added`; a removal is never before the adding, `GREATEST`, so a removal racing a later heart keeps it; the application role updates only `added_at` and `removed_at`).
  `PUT` and `DELETE /v1/customer/favourites/{restaurantId}` (`customer-favourites.controller.ts`, `@AppSignedIn()`: a guest gets `401` and the app asks them to sign in) set the state, so they take no key;
  a repeat changes nothing, a restaurant customers do not see cannot be hearted (`404 unknown_restaurant`, `BrowsingService.seen`), removing one that is not a favourite is quiet, and removal asks for no confirmation.
  `GET /v1/customer/favourites?latitude=&longitude=` («المفضلة» in «حسابي») answers the cards of the favourites among the list's cards for the point (`BrowsingService.favourites`), in the list's order: one that does not deliver to the point is left out and stays a favourite.
  Every card (the list, the home, the category page, the similar ones, the search) and the page carry `favourite` for the signed-in customer, false for a guest (`heartedBy`).
- **The menu customers see (CU §9.3):** read through `MerchantsService.menu(id, now)` only.
  Hidden categories and items are left out;
  a category keeps its daily `window` (minutes on the city clock).
  An unavailable item keeps its place with `unavailableReason`: `unavailable` («غير متوفر حالياً») when any switch holding it back (its own, its category's, the options of a required group with none left) is off until turned back on;
  else `tomorrow` («يتوفر غداً») when some are off until the next cutoff;
  else `window` («متوفر من {الساعة}»), its category's window.
  `fromPrice` («من {أقل سعر}») is set when a required group has an option with a price delta: the price with each required group's cheapest available choices, and none when an option is in another currency.
  The restaurant's `logoKey` and `coverKey` and the item's `photoKey` are keys in `public-media` (null without an image), set from the panel (slice 2.5);
  the app shows them through imgproxy at a width it picks (architecture §5.8, CU §4.5).
- **«معاينة كما يراها الزبون» (AP §9.6.6; slice 2.31, `admin-menu-preview.controller.ts`):** `GET /v1/admin/restaurants/{id}/menu/customer-preview` (`restaurants.read` or `restaurants.menus`; `404 unknown_restaurant`) answers `BrowsingService.previewMenu`: the restaurant page's menu through the same `storefrontMenu` and item shape (`storefrontItem`, `itemBody`), whatever the restaurant's status, so the panel shows a draft's menu as customers will see it.
  The restaurant app's owners read the same through `GET /v1/merchant/menu/customer-preview` (RA §9.7, slice 2.32a, `merchant-menu-preview.controller.ts`; `403 owner_only` for a cashier, `403 restaurant_terminated`), its category shape named `MerchantMenuPreviewCategory` so the generator never ties it to the panel's.
- **The estimate (CU §8.4, docs/domain/03):** `estimateRange` and `tripMinutes` from `geo`: default prep + busy-mode minutes + the trip at `order.eta_speed_kmh` + `order.eta_buffer_min`, from a multiple of 5 to 10 minutes later.
  The trip is the motorbike's distance (`GeoService.distance`, so `pricing.distance_method` applies), as the fee's is.
  Ratings (CU §12.1, Q16; slice 2.26a): the cards' and the page's `rating` (the average to one decimal) and `ratingCount` from ordering's port (`useRatings`, registered by its `RatingsService` at start: the restaurant's ratings without test orders), both null («جديد») below 5 ratings.
  A card measures the trip once: a distance-band fee's distance, or else `GeoService.distance`.
  A restaurant suspended between the list and its card is left out;
  its page answers `404`.
- **Snapshots (Q6):** an order keeps its own copy of the address, so editing or deleting one changes no order.
  `orderAddress(accountId, { addressId } | { fields })` gives it: a saved address of this customer (`unknown_address` otherwise) or the fields of an unsaved one (CU §7.4, another contact number encrypted here), with the active zone at the pin now as «الحي» (`outside_zones` outside every one).
  The route schemas of the address fields are in `address-fields.ts`;
  `unsavedAddressFields` and `withRecipient` are exported for the order command.
- **Late-cancellation strikes and the review stop (docs/domain/08; slice 2.8b, owner decision 2026-11-09):** `late_cancel_strikes` (one per order, never changed) and `review_stops` (one open per account, a partial unique index; the application role may change only `ended_at`, `ended_by` and, since 2.25b, `end_note`, the first two together).
  `recordLateCancel(tx, …)` runs in operations' cancellation's transaction (after the order's lock): it takes the customer's ordering lock (`customerOrderLock(accountId)`, exported for placing, which placing takes first, so a stop and a placing take turns; placing never takes an order's lock), records the strike, counts the customer's strikes within `customer.late_cancel_window_days` from the latest clear (`strikesSince`) and opens a stop at `customer.late_cancel_strikes` (both read by the caller with the order's city).
  `reviewStopped(accountId, executor?)` is what the quote shows as `review_stop` («حسابك موقوف حتى مراجعة فريق الدعم») and what placing reads again under the customer's lock.
- **Trust marks, strike clears and ending a review stop (AP §9.8, §8.8, D23, docs/domain/08; slice 2.25b, owner decisions 2026-11-17; `trust.ts`):** `trust_marks` and `strike_clears`, append-only (the application role cannot update them), each with the admin and the required note.
  `trustBasis` is the pure rule ordering's `ActiveOrders.customer` reads with `trustMark`: the deliveries count after the later of the latest fake outcome and the latest mark, and a «توثيق» newer than every fake outcome in force, by when each was set (a «تغيير النتيجة» to fake after it removes the trust), trusts the account whatever the count;
  «إزالة الثقة» restarts the count.
  `strikesSince` counts the strikes within the window and after the latest clear (`strikesClearedAt`), for `recordLateCancel` and the profile.
  `POST /v1/admin/customers/{customerId}/trust` (`trusted`, `note`; `customers.manage`: OWN, OPS) sets a value (the latest mark's value again writes nothing, so a repeated «إزالة الثقة» never restarts the count twice), so it takes no key;
  `.../clear-strikes` (`note`; `customers.clear_strikes`: OWN, OPS, SUP) records a clear and ends an open review stop with it, `409 nothing_to_clear` without a strike since the latest clear nor a stop;
  `.../end-review-stop` (`stopId` the stop the panel showed, `note`; same permission) ends that stop only and leaves the strikes counted, `409 not_stopped` when it is no longer open.
  Each runs under the customer's ordering lock and is audited (`customer.trust_mark`, `customer.clear_strikes`, `customer.end_review_stop`) and answers the profile, which adds `trustMark`, `lateCancels.cleared` and `reviewStop.id`.
- **The profile's activity and notes (AP §9.8; slice 2.25b):** the profile adds `orders` (ordering's port, `useOrderFacts`: the count in the city without re-deliveries, what the normal deliveries totalled per currency, test orders left out, the latest order), `tickets` (support's port, `useCustomerTickets`, registered by `SupportService` at start: the latest 20 in the city), `codes` (marketing's `PromoCodeUsesService.usesOf`: the latest 20 uses in the city, held, spent or given back), `addresses` (the saved ones, another contact number only masked, `maskedContactPhone`, since the number is the special permission `customers.reveal_phone`'s) and `notes` (the latest 50 with their authors).
  `customers.notes` keeps each «ملاحظة داخلية» with its author and the command's key (`notes_key`), never changed;
  `POST /v1/admin/customers/{customerId}/notes` (`body` up to 500 characters; `customers.read`: everyone with access, AP §9.8; `Idempotency-Key`, a repeat adds nothing, another body under the same key is `422 idempotency_key_reused`) is audited `customer.note` (only when it wrote the note) and answers the profile.
  Since slice 2.26a the profile adds `ratings` («التقييمات المكتوبة»: ordering's port `useRatings`, the latest 20 in the city with the order's number, the restaurant's and the captain's names, the stars, reasons and comment; admins see everything, CU §12.1).
- **The admin test account (AP §9.8, §9.6.3, CU §8.2; slice 2.25b, owner decision 2026-11-17):** `test_account_flags`, append-only, the latest row in force (`isTestAccount`).
  `POST /v1/admin/customers/{customerId}/test-account` (`flagged`; `customers.test_account`, OWN alone, AP §6.3) sets the value, so it takes no key, is audited `customer.test_account` and answers the profile, whose `testAccount` shows it.
  Such an account sees the restaurants in test mode (`seenByCustomer`) and the quote lets it order from them;
  the order is a test order because its restaurant is in test mode (ordering's `test_order`), and its orders at active restaurants are normal ones.
- **«تغيير الرقم» and «تسجيل الخروج من كل الأجهزة» (AP §9.8, CU §5.4; slice 2.25b):** `POST /v1/admin/customers/{customerId}/change-phone` (`phone` in any usual form, `phoneOf`, else `400 invalid_phone`; `note`; `customers.manage`: OWN, OPS; `409 phone_taken`; answers the profile) and `.../sign-out-everywhere` (`note`; `customers.sign_out_everywhere`: OWN, OPS, SUP; answers `sessionsEnded`) run identity's `CustomerAccountsService.changePhone` and `signOutEverywhere` (its `CLAUDE.md`).
  Neither takes a key: the same number again and a second sign-out change nothing.
- **Blocks (AP §9.8, CU §5.5, docs/domain/08; slice 2.25a, owner decisions 2026-11-17; `blocks.ts`, `customer-admin.service.ts`):** `customers.blocks`, one row per «حظر»: `until` (a duration, ending after now and within `BLOCK_MAX_DAYS`), `indefinite` («حتى إشعار آخر») or `dues` («حتى دفع مستحق»);
  the reason a code of Content's `customer_block` list with its label and customer text copied (CU Appendix C), the admin's required note, the start and the admin, and the end (`ended_at`, `ended_by`, `end_note`; the application role may change only those).
  `blockInForce` is the pure rule: an open `until` or `indefinite` row until its time;
  a `dues` row never stops ordering by itself: it records the `dues.charge` of its amount in the city's base against `platform.adjustments` (`city_id`, `dues_amount`, `dues_currency`, `dues_journal_id`; never ends, `blocks_dues`), so the dues balance is the block and the desk's payment lifts it.
  One open `until` or `indefinite` per account (`blocks_one_open`, `409 already_blocked`);
  one whose time passed is closed at its `until` with no admin when the next block starts.
  `POST /v1/admin/customers/{customerId}/block` (`customers.block`: OWN, OPS; `Idempotency-Key` kept on the row for good with the request's hash, `blocks_key`, so a dues block never charges twice; `422 idempotency_key_reused`) and `.../unblock` (`blockId`, the block in force the panel showed, and the note; no key: it names its target, so a repeat, or a block replaced since, is `409 not_blocked`; it ends only a duration or «حتى إشعار آخر»: dues go through the desk or «القيود التصحيحية», owner decision 2026-11-17) run under the customer's ordering lock (`customerOrderLock`), so placing reads them;
  audited `customer.block` and `customer.unblock`.
  `activeBlock(accountId, now, executor?)` is what the quote shows as `account_blocked` (the customer text as its `message`, `until`) and placing reads again under the lock, with the dues (a dues block charged since the quote refuses the order);
  `dues(cityId, accountId, executor?)` is what it shows as `dues_unpaid` (ordering's `customer-dues.ts` moved here).
  **The panel (`admin-customers.controller.ts`, `customers.read`: OWN, OPS, SUP, FIN; `404 unknown_city` for a city that is not one):** `POST /v1/admin/customers/search` (`{ cityId, q }`: a number in the desk's forms, `phoneOf`, through identity's `customerByPhone`, else a part of the first or last name, the latest 20) answers each customer's name, `maskedPhone` (`maskedPhone`: the country code and the last three digits, decided by us; the number is never answered) and `status` (`accountStatus`: `blocked`, `dues_unpaid`, `review_stop` or `active`, the first that applies);
  `GET /v1/admin/customers/{customerId}?cityId=` the profile: the details, the status, the block in force, the open review stop, the trust (D23: `trusted`, `delivered`, `trustedAfter`) and the fake orders from ordering's port (`useOrderFacts`, registered by `OrdersService` at start, since this module cannot import ordering), the late cancellations within `customer.late_cancel_window_days` and in all, the dues balance in the city (+ owes, − a credit) and the latest 20 blocks with the admins' names.
  **The app (`customer-account-state.controller.ts`):** `GET /v1/customer/account-state?latitude=&longitude=` (`@AppSignedIn()`) answers CU §5.5's banners: `reviewStop`, `block` (`until`, the reason's customer text), `dues` in the point's city and, with dues, the city's `office` for the sheet (AP §9.12.1);
  outside every city, no dues.

- **Closing the account and its line (AP §8.8, D19, AP §9.8, CU §5.5, §5.6; slice 2.25c, owner decisions 2026-11-17):** a new account on the number of a closed one continues its line (identity's `lineage_id`).
  Every read of the customer's standing takes the line (`CustomersService.lineage`): the block in force (`activeBlock`), the review stop, the strikes and their clears, the trust marks (and ordering's fake outcomes and normal deliveries, so the trust carries over as it was);
  the profile lists the line's blocks and its open stop.
  Commands take the ordering lock of every account of the line in order (`lockLine`; placing takes its own account's), so «فك الحظر» and «إنهاء الإيقاف» from the new account's profile end a closed account's block or stop by its id.
  The dues move instead (owner decision): the listener registered with identity at start (`moveDues`) posts, per closed dues account with a balance, two `dues.transfer` journals against `platform.adjustments` (the closed account to zero, the new account charged or credited the same), with the system as actor and the reasons `DUES_MOVED_OUT` and `DUES_MOVED_IN`, in the sign-in's transaction, under the closed account's dues lock (`lockCustomerDues`, moved here from cashdesk, which the desk and «القيود التصحيحية» take on every account of the line in order), so a payment at the desk on the closed account commits first or finds the dues moved.
  Every dues read is the line's (`lineDues`, summed per currency): the quote's and placing's `dues`, the account state, the panel's status and profile and the desk's due, so dues posted on a closed account after the move (a «تغيير النتيجة» of its order, a reversal, a block on its profile) still stop the account that continues it, and a payment on the new account settles them.
  **Closing** (`CustomerAdminService.closeAccount`): one transaction under the line's lock, `409 active_order` while ordering's port (`useActiveOrders`, registered by `OrdersService`: an order of the account from `placed` to `arrived`, a re-delivery included) answers true, then identity's `close`;
  placing reads `accountOpen` again under its lock.
  The panel's `POST /v1/admin/customers/{customerId}/close` (`note`; `customers.close_account`: OWN, OPS, SUP; no key: a repeat is `409 account_closed`) answers the profile.
  The app's `POST /v1/customer/account/close-code` (`@AppSignedIn()`, App Check header; `409 active_order` before any code is sent, else the code request's refusals) and `POST /v1/customer/account/close` (`code`; `409 active_order` checked before the code is used and again under the lock; `400 wrong_code` or `code_expired` with `attemptsLeft`) answer `{ status: 'closed' }` (`customer-closure.controller.ts`).
  **The panel:** the search by number lists every account of the number (`customersByPhone`, newest first), a closed one with the status `closed` («مغلق», first in `accountStatus`);
  the profile adds `closed` (when, the admin's name or null for the app, the reason) and `linkedAccounts` (the line's other accounts, newest first).
  All data is kept (AP §13 item 6 to check again before the store submission).
- **The device block (docs/domain/08, AP §9.8, CU §5.5; slice 2.25d, owner decisions 2026-11-10 and 2026-11-18; `devices.ts`):** the device is the customer session's `deviceId`, which the customer app keeps across a reinstall (Android ID on Android, a Keychain value on iOS; `core_auth`'s `stableDeviceId`).
  Identity's `deviceSightings(accountIds)` gives, per device and account, every customer session on a device the accounts used (open or ended: the first and latest sign-in, the last seen, the latest sign-in's IP address and user agent, signals only, never the block).
  `deviceLinks` is the pure rule (`devices.test.ts`): the accounts outside the line signed in on a device the line used, both sign-ins after the device's latest lift;
  one step only (a link of a link is not followed), so a block never spreads beyond the phones it was seen on.
  `activeBlock` is the line's own block (`lineBlock`) or else a linked account's line's, with `viaAccountId`, its `until` null and its customer text `DEVICE_BLOCK_TEXT` («هذا الهاتف مرتبط بحساب آخر محظور», the wording ours: never another account's reason, end or amount);
  `dues` the line's own or else a linked account's line's, with `viaAccountId`, which the quote shows as `account_blocked` with `DEVICE_BLOCK_TEXT` (not `dues_unpaid`) and the account state as that block (no dues, no office);
  the profile's `duesViaAccountId` names the account whose dues they are, which the desk takes on its profile.
  So the quote, placing, the account state, the search's and the profile's status follow the phone;
  «فك الحظر» ends the line's own block only (`lineBlock`, `409 not_blocked` for one through a device).
  Every account seen on the phone is stopped, old or new (owner decision 2026-11-18: a family phone is lifted by OWN).
  **«فك حظر الجهاز»:** `customers.device_lifts`, append-only (the device, the moment, the admin, the required note);
  `POST /v1/admin/customers/{customerId}/lift-device-block` (`deviceId` the device the profile listed, `note`; `customers.lift_device_block`, OWN alone, migration 0105 and AP §6.3) runs under the line's lock, `404 unknown_device` for a device the line never signed in on, `409 device_not_blocked` while no account signed in on it since its latest lift has its own block or dues in any city (`owesAnywhere`; so a repeat needs no key), taking turns with another lift of the device on an advisory lock, audited `customer.lift_device_block` with the accounts that blocked it, and answers the profile.
  A blocked account signing in on the device after the lift links it again.
  **The profile's `devices`** («الأجهزة», latest seen first): each device of the line with when it was first and last seen, the latest IP address and user agent, and, while the line itself signed in on it since its latest lift (as `deviceLinks` links), `blocked` and the other accounts signed in on it since the lift (name, masked phone, status) and the latest lift with its admin;
  the profile's `block.viaAccountId` names the account a device block comes from.
- **For the reports (AP §9.17; slice 2.41):** `reportProfiles(accountIds)` gives the names, gender and birthday, and `blocksBetween(from, to)` the panel's blocks (not the dues blocks) started in a window by label and those in force at its end.
- **The mass push's audience (AP §9.11.4; slice 2.27d, owner decisions 2026-11-18; `mass-push-audience.ts`):** `MassPushAudienceSource` registers with marketing's `MassPushesService.useAudience` at start: registered customers (`registered`: a profile) whose identity account is not closed (identity's `lines`, every account with its line and whether it is open, read whole rather than by a list of ids), and for `zone` those with a saved address (not deleted) in the zone (`withAddressIn`, geo's `covered` in one query), for `inactive` and `never_ordered` the latest delivery of the account's line (AP §8.8) from ordering's `useLastDeliveries` (registered by `OrdersService`: each account's latest delivered order in the city, test orders and free re-deliveries left out).

## Not yet

- A request limit on the public routes: the deploy slice's per-IP limits in nginx (architecture §15.5) must cover `/v1/customer/zone-votes`, `/v1/customer/restaurants`, whose cards each read the database and OSRM, `/v1/customer/search` (every covering restaurant's card and menu, and a row per miss) and `/v1/customer/restaurant-suggestions` (a row per key).
- Recognising the account's own number typed as another contact number (it then asks for a recipient).
- The home measures every covering restaurant's trip for «الأقرب إليك», as the list does;
  the search does too and reads every covering restaurant's menu at each search (fine for Azaz; an index of the names when menus grow).
  The lost demand's Excel export is the reporting module's «التقارير» (slice 2.41, `LostDemandService.between`, exported);
  the orders blocked by the capacity check are not recorded yet.
  A search's typos and the parts typed before a pause are kept as misses too (the app waits until typing stops), and so is the same search read again (the retry, a sign-in with the search open).
  An admin test account's misses and a search of diacritics only are not kept (decided by us).
- One road distance per card: the OSRM `table` matrix replaces it when lists grow.
- The device block: Play Integrity's device recall and DeviceCheck (owner decision 2026-11-18: with the Google Cloud project and the Apple account);
  a block on a linked account takes that account's lock, not the placing customer's, so a placing racing it may pass;
  a payment at the desk on the account that holds the dues lifts the block on every phone;
  an Android phone that had the app before 2.25d keeps its sessions under the installation's id, so they never link to its later sign-ins (no app is on real phones yet);
  each linked account costs a lineage and ledger read on every quote (batch them if shared phones grow).
  The name search lists a closed account's profile as any other.
  The relink itself is not audited, and `lineage_id` has no foreign key.
  A block reaches the app at its next read of the account state (on opening and on returning to it), not by real time (CU §5.4 «applies at once»: the server refuses at once).
  The name search scans `profiles` with `ilike` and reads each hit's status (up to 20): a trigram index (`pg_trgm`, a new extension in `db/bootstrap.sql`) and batched reads when the customers grow.
