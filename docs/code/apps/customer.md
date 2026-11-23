# apps/customer

> Moved here from `apps/customer/CLAUDE.md` on 2026-11-20 (`docs/archive/claude-code-workflow.md`). In these notes, a folder's `CLAUDE.md` (or "its `CLAUDE.md`") means that folder's file under `docs/code/` when there is one, otherwise the folder's own `CLAUDE.md`; the folder's own `CLAUDE.md` now holds only the rules for working there.

The customer app «تطبيق الزبون» (Android, iOS), a Flutter app in the Dart pub workspace (architecture §11, §13).
`apps/captain` (Android, iOS) and `apps/merchant` (Android, Windows) follow the same rules.

## Layout

- `lib/main.dart`: starts App Check (`startAppCheck`, `packages/core_auth/CLAUDE.md`) and push (`startPush`, `packages/core_push/CLAUDE.md`), then runs the app inside a Riverpod `ProviderScope` that gives the scope its token source.
- `lib/src/app.dart`: `MaterialApp.router`, fixed to Arabic. `lib/src/router.dart`: the go_router routes, as a provider.
- `lib/src/api.dart`: the API client providers and the server address.
  `lib/src/auth.dart`: the app's `AuthScope` (`packages/core_auth/CLAUDE.md`).
  `lib/src/device.dart` (customer): the device store, the clock and the app version.
  One screen per file next to them, until a feature needs a folder.
- Feature folders (customer, slice 1.14d): `profile/`, `location/`, `browsing/`, `cart/`, `checkout/`, `orders/`, `notifications/` (slice 2.3b) and `search/` (slice 2.28a).
  Each keeps its logic (providers, notifiers, pure functions such as `ItemChoice` or `problemViews`) in plain files and each screen in a `*_screen.dart` or `*_sheet.dart` that only reads that state and calls it (the design stop).
- `test/`: widget tests, run by `flutter test`.
- `android/`, `ios/`, `windows/`: written by `flutter create` with the app ID `com.foxdrop.<app>` (owner decision 2026-11-05). Edit them only for a reason, and say it in a comment.

## Rules

- **The device id (slice 2.25d, docs/domain/08):** `lib/src/device_id.dart`'s `customerDeviceId` overrides `customerAuth.stableDeviceId` in `main`: on Android, MainActivity's `com.foxdrop.customer/device` channel answers Android ID made a name-based UUID (`UUID.nameUUIDFromBytes`, never the raw id), which survives a reinstall until a factory reset;
  on iOS it answers null and the installation's id in the Keychain is kept across a reinstall.
  The sign-in sends it as `deviceId`, so a block follows the phone.
- **Libraries (architecture §11.3):** Riverpod for state and dependency injection, go_router for navigation;
  no other state library, no `Navigator.push` for screens.
  Every dependency is pinned to an exact version;
  a package shared with another member of the workspace takes the same version.
- **API (E6):** call the server only through `coreApiProvider` (the generated `core_api` client, with the session's interceptor) inside a provider;
  never Dio or `http` by hand, but for the one `PUT` of a report's photo to the storage's signed URL (`photoPutProvider`, «Reports» below).
  `authApiProvider`, without the interceptor, serves only the app's `AuthParty`.
  Tests replace both with `FakeServer` clients (`package:core_auth/testing.dart`) and the scope's `store` with `MemorySecureStore`, so they need no server or device.
- **Session and routes (slice 1.14b):** the router redirects on the scope's session: `/starting` while it is read, `/sign-in` when signed out (the customer app lets guests stay, CU §5.1), home once signed in.
  In the customer app a screen that needs sign-in sends the guest to `signInFrom(<its path>)`, and sign-in returns to that `from` (only a path of the app);
  while `GET /v1/customer/profile` answers `completed: false` every route goes to `/complete-profile` («أكمل بياناتك», CU §5.3) with the same `from` (slice 1.14d).
  The restaurant app sends a signed-in device without a name to `/device-name` (RA §5.2 item 5);
  the captain's sign-in screen shows «سُجّل دخولك من جهاز آخر» after `other_device` (CA §4.9).
- **Ordering (customer, slice 1.14d; CU §7, §10):** the delivery point (`deliveryPointProvider`) comes from the phone through `positionSourceProvider` (`geolocator`; tests use a fake), a pin set on the map (`usePin`) or a saved address's pin, and lives while the app runs;
  the last request wins, and the checkout's chosen address is the point's `addressId` (null for the point as an unsaved address).
  Sign-in from checkout and «أكمل بياناتك» use `context.go`, so the router's redirect sees them;
  «تأكيد الطلب» reads the profile first and never sends without a completed one.
  The cart is the only state kept on the device (`DeviceStore`, 24 hours), with each line's `unitPrice` as the quote's `knownUnitPrice`;
  «موافق» on a new price updates it;
  the order's code (CU §10.4, slice 2.21c) is kept in the cart (`Cart.code`, set by «تطبيق», cleared by «إزالة», dropped by a new cart) and sent with every quote and the order command, and the quote names it (`promoCode`) only while it applies;
  a refused code is the problem `promo_code` (`codeRefusalText` maps its `refusal` to CU Appendix C, with the missing `amount` for `below_minimum`) with «إزالة», blocking like every problem, and checkout lists the quote's `availableCodes` under «الأكواد المتاحة لك» (each with `codeValueText`, its minimum, «ينتهي {التاريخ}», and «يوفر عليك {المبلغ}» or what its minimum lacks) and its `suggestedCode` as «لديك كود يوفر عليك {المبلغ}: {الكود}»;
  only the customer's «تطبيق» applies one (U11), and a code that replaces the applied one asks first (`replacesCode`, slice 2.21d), and a code that stopped working at «تأكيد الطلب» comes back as `409 order_blocked` with the new quote showing it;
  a problem's action finds its line by `CartLine.key`, never by index.
  `quoteProvider` re-asks on every change of the cart, the point or «سأدفع بـ», and every problem it lists blocks «تأكيد الطلب» (`problemViews` maps them to CU Appendix C).
  `placeOrderProvider` is kept alive, so leaving checkout never cancels a command, and `CustomerApp` opens the placed order wherever the customer is;
  its `Idempotency-Key` belongs to one command body (a lost answer resends the same key, a refusal or another body takes a new one).
  The far-pin check (`farPinMetres`) runs on the device only and never asks for the permission.
  Amounts are minor-unit strings formatted with `formatMoney`, and the money models the generator shares come out nullable in Dart (`price!`), though the server always sends them.
- **The live order (customer, slice 1.14e; CU §4.3, §6, §11):** `orderFeedProvider(id)` is a `LiveFeed` (`packages/core_realtime/CLAUDE.md`) of `GET /v1/customer/orders/{orderId}` over `order:{order_id}`, opened with the order screen and closed with it;
  the screen never patches the order.
  `titleOf` maps the order to the title and subtitle of CU §11.2 and §11.9 (the captain from `captain`, never the captain track), `stepOf` to the five-step progress;
  `titleTexts` and `statusText` turn them into strings.
  The home's active-order bar (`activeOrdersProvider`, CU §6) is read when home opens.
  Every countdown runs on `serverClockProvider` (`packages/core_time/CLAUDE.md`).
  Tests drive the channel with `FakeTransport` (`test/fakes.dart`, in `TestApp`) and end a test that opens an order with `app.done(tester)`, which stops the feed's polling before Flutter checks for pending timers.
  **«اتصال بالكابتن» (CU §11.3, §19 item 17; slice L.1b):** the captain card shows it while the order says `captain.canCall` (from pickup to the end), and the door ring's call uses the same `callCaptain` (`door_ring.dart`).
  The order never carries the captain's phone: a tap reveals it through `customerOrderContactsCallCaptain`, which records the tap, then dials `tel:`; a refusal dials nothing and shows the error snackbar. The button and the map leave when the order ends.
  **The late apology (CU §11.6, §19 item 19; slice L.1b):** `LateApologyBanner` shows «نعتذر، طلبك متأخر قليلاً…» once the server clock passes the order's `lateApologyAt` (20 minutes past the promised time) while the order is open; the push of the same moment comes from the server's timer.
  Not yet: «تريد تغيير العنوان؟» in «مساعدة» (§11.5, §11.10), the edit's banner of §11.6 and the delivery's amounts (§11.8), and the bar's refresh while home stays open.
  **A rejected or unanswered order (CU §11.9, Q22; slice 2.7b):** the title's subtitle is the rejection's customer text;
  `OrderAgainSection` lists the similar restaurants (`similarRestaurantsProvider`, the restaurant list with `similarTo` at the order's pin) and, for «صنف غير متوفر» while an item is left, «اطلب بدون الأصناف غير المتوفرة»: `rebuildFromOrder` reads the restaurant's page at the pin and `rebuildLines` builds the cart from the order's lines without `unavailableItemIds`, at today's prices with the notes, skipping and naming («لم نضف: …») a line whose item or options are gone, unavailable or no longer fit their groups;
  the screen asks first when the cart is not empty, then `CartController.replaceWith` and `/cart`.
  «اطلب مرة أخرى» (CU §12.3, slice 2.28b) reuses it.
  **«مساعدة» and the customer's cancellation (CU §11.4–11.5; slice 2.8a):** the order screen's «مساعدة» (until the order ends) opens `OrderHelpSheet`: «اتصال بالدعم» and «واتساب الدعم» (prefilled «بخصوص الطلب #{رقم}») from `customerAuth.contact` through `customerAuth.launch` (tests record the links in `TestApp.launched`), the FAQ, and by `cancelHelpAt` «إلغاء الطلب» while placed, «لإلغاء الطلب تواصل مع الدعم» with the late-cancellation warning while accepted or ready, nothing after the pickup (Q24).
  The sheet answers a `HelpChoice` and the screen acts on it with its own context;
  while placed the screen also shows «إلغاء الطلب» itself (CU §11.1).
  `CancelOrderSheet` offers Content's `customer_cancel` reasons (`CustomerContent.cancelReasons`, a text field when the reason takes one, a retry when Content failed) and «نعم، ألغِ الطلب»;
  `cancelOrderProvider(id)` sends `POST /v1/customer/orders/{orderId}/cancel` with a key per command body, kept alive until its answer even when the sheet is dismissed, then refreshes the order's feed: `CancelOutcome.tooLate` (`409 order_state_changed`, the order not ended) shows «قبل المطعم طلبك قبل لحظات. لإلغائه تواصل مع الدعم.», a reason refusal reads Content again and asks again.
  An order with `cancellation.byCustomer` is titled «ألغيت طلبك» (`CancelledByYou`).
  **An outcome after the pickup (CU §11.9, AP §8.9; slice 2.11a):** a failed order is titled «تعذّر التسليم» with `outcome.text`, the reason the server copied from Content (`Failed`);
  a free or damaged one delivered with nothing to collect says «لم تدفع شيئاً لهذا الطلب» (`Delivered.paidNothing`);
  while an outcome waits for its amount (`outcome.awaitingCollection`, slice 2.11b, K9) the order on its way or at the door says «المبلغ المطلوب الآن: {المبلغ}» (`OnTheWay.dueNow`, `AtDoor.dueNow`).
  Checkout's `dues_unpaid` shows «عليك {المبلغ} لـ FOX DROP. ادفعه في المكتب ليُفك الحظر تلقائياً.» with «تواصل مع الدعم» (slice 2.25a).
- **The pin on the map (customer, slice 2.29a; CU §7.1, §7.4, architecture §7.2):** `location/pin.dart` and `pin_screen.dart`.
  «اختر على الخريطة» (home's first question, beside every home message, so a refused permission or another point can still choose) pushes `/pin?lat=&lng=&zoom=` (`pinPath`; without them `cityCentre` at `cityZoom` 14, a known point at `streetZoom` 17), which shows `pinMapProvider`'s map (`core_maps`' `maplibrePinMap` on `mapStyleUrl`; tests draw `FakePinMap` through `TestApp.pinMap` and `move` its camera) under the fixed pin;
  «تأكيد الموقع» works only while `pinConfirmable` (zoom 16 or closer), else «قرّب الخريطة لتحديد موقعك بدقة», and pops the centre, which the caller gives `usePin` (the zone check, no accuracy).
  At checkout, the phone's position worse than 100 m (`accurateMetres`) shows «دقة موقعك …» with «عدّل الدبوس», opening the map at that position.
- **Following the captain (customer, slice 2.29b; CU §11.3, U12, architecture §6.2):** `orders/captain_map.dart`.
  From the pickup until the order ends (`followedStatuses`) the order screen shows `CaptainMap` under the captain card: `routeMapProvider`'s map (`core_maps`' `maplibreRouteMap`; tests record each view in `TestApp.mapViews`) of `Following.view`, the pin, the captain and the route line when the routing service answered;
  none before the pickup.
  `followingProvider(id)` reads `GET /v1/customer/orders/{orderId}/route` (the captain's newest point, the pin and the line) when the map opens (the first subscription's `RealtimeUp` reads nothing more), after every later reconnect that did not recover and after `order.handed_over` (the new captain's way), and listens to `order:{id}` itself for `captain.position` (`positionOf`: this order's only), which moves the captain unless it is older than the point shown (`Following.moved`);
  the order's `LiveFeed` ignores these publications, which carry no version, so a position never reads the order again.
  Nothing shows until the first read answers, and a failed read reads again after `followRetry` (30 seconds).
- **«عناويني» (customer, slice 2.29a; CU §7.3, §13):** `account/addresses.dart`, `addresses_screen.dart` and `address_form_screen.dart`.
  «حسابي» → «عناويني» opens `/account/addresses` (signed in only, under `/account`): `savedAddressesProvider` (shared with checkout), the default first and marked «العنوان الافتراضي», one outside every active zone with «خارج منطقة التوصيل حالياً» and no «اجعله الافتراضي» (Q6);
  «إضافة عنوان» up to `maxAddresses` (10), else «يمكنك حفظ 10 عناوين كحد أقصى».
  `/account/addresses/new` and `/account/addresses/:addressId` share the form: the pin first (`/pin` at street level, from the address's pin, the delivery point or the city), «الحي» the zone at it (`pinZoneProvider`, read-only), then checkout's fields and checks (`CheckoutForm`, `addressProblems` reuses `formProblems`; `formOf` prefills an edit, its own contact number as E.164).
  `addressBookProvider`'s `AddressBook` sends `POST`, `PUT …/{addressId}`, `PUT …/{addressId}/default` and `DELETE …/{addressId}` (after «تأكيد حذف العنوان»), reads the list again, and keeps the delivery point in step: an edited address that is the point moves it to the new pin (`useAddress`), a deleted one, or one a `404` says is gone, leaves it unsaved (`forgetAddress`).
  `outside_zones` and `address_limit` have their sentences (`addressOutcomeText`);
  a `404` reads the list again, and the form of an address no longer listed closes.
  A save sends `Idempotency-Key` (CU §19 item 28, slice L.1c): `AddressBook.create` keeps one key per body (its `toString()`) until an answer or a refusal, so a retry after a lost answer saves once; checkout's «احفظ هذا العنوان» saves through it. `PUT` and `DELETE` send none (the server takes none).
  Checkout's «احفظ هذا العنوان» builds its body with the same `newAddressDto`.
- **Categories (customer, slice 2.27a; CU §8.1–8.2, AP §9.13):** `browsing/categories.dart`'s `categoriesProvider` reads `GET /v1/customer/categories` (public; the active ones in the panel's order).
  Home shows them as a row of chips (`CategoryRow`, with the image through `MediaImage`) where the panel puts «التصنيفات» (slice 2.27b) while the point is served;
  a chip opens `/categories/:id` (`CategoryScreen`, titled with the category's name once read, «التصنيف» before), which is `RestaurantList(categoryId:)` on `categoryRestaurantsProvider(id)`: the list with `categoryId`, in the server's order (open first, closed last).
  The cards and the restaurant page show the restaurant's `categories` joined by «، » (`categoriesText`);
  the generated client types each one as a shared nullable `{ id, name }` model, so read them with `nonNulls`.
  Tests answer the categories with none by default.
- **The home's sections (customer, slice 2.27b; CU §8.1, AP §9.11.3):** `browsing/browsing.dart`'s `homeProvider` reads `GET /v1/customer/restaurants?home=true` at the served point into a `HomeView`: every card in the list's order and the sections the panel shows in its order, each naming its cards by id (`cardsOf`, an id without a card left out).
  `HomeSections` (`browsing/home_sections.dart`) shows them in that order: «البانرات» the banner strip (below), «التصنيفات» the `CategoryRow`, «الأقرب إليك», «الأكثر طلباً», «جديد على FOX DROP», «العروض» and a custom section (its title) as a heading over its cards (`RestaurantTile`, shared with the category page), then «كل المطاعم» (decided by us) with every card.
  Pull to refresh (always scrollable) reads the home and the categories again.
- **Offline browsing (customer, slice L.1c; CU §4.5, §19 item 28, owner decisions 2026-11-21):** `browsing/browse_cache.dart`.
  `homeProvider`, `categoriesProvider` and `restaurantPageProvider` are `StreamProvider`s over `browse()`: a kept read that fits shows at once, then the live read replaces it and is kept (`deviceStoreProvider`, keys `browse_home`, `browse_categories`, `browse_page_<id>` with the index `browse_pages` of the last 20 pages fetched, its changes chained one after another; a page that answers `404` is dropped).
  Pull to refresh waits for the live read (`HomeView.pending` is the kept read shown meanwhile).
  An entry fits for 7 days (`browseCacheMaxAge`), for its account (null a guest; the categories for everyone) and within 1 km of the point (`browseCacheRadiusMetres`, decided by us: fees and «لا يوصل إلى موقعك» change with distance).
  A read with no answer (`noAnswer`: a `DioException` without a response) keeps a fitting entry, marked `offline`: «لا يوجد اتصال بالإنترنت» (`customerOffline`, key `offline`) over home and the page; an answer with an error, or nothing kept, fails as before.
  A failed zone check (`PointUnavailable(null)`) shows the kept home at its stored point and pages from their entries there (`browsingPlace`), with no live read; pull to refresh and the return to the foreground repeat the last point request (`DeliveryPointController.retry`). Hearts read from a kept answer use its `savedAt` as `since`.
  Not kept: category pages, banner lists beyond home's answer, search, favourites and «طلباتي»; no connectivity package (the failed read is the signal) and no «آخر تحديث» time. The cart takes items offline; the quote and placing need the server.
- **Search (customer, slice 2.28a; CU §8.3, AP §9.17, owner decisions 2026-11-18):** `search/`.
  Home shows «ابحث عن مطعم أو صنف» while the point is served, which opens `/search` («البحث», guests too; `SearchScreen`): the box searches `searchDelay` (400 ms) after typing stops, the trimmed text of `searchMinLength` (2) to 50 characters (`searchQuery`), through `searchProvider(query)` (`GET /v1/customer/search` at `browsingPoint`, the served point), whose cards `cardOfSearch` turns into the list's `RestaurantCard` (the same fields), so `RestaurantTile` shows them.
  The answer's «المطاعم» and «الأصناف» are two tabs in the server's order (closed last; the items tab first when only items were found);
  an item shows its restaurant and price («من» with `fromPrice`) and the restaurant's badge, and opens the restaurant's page.
  Each search made goes first in the recent searches (`recentSearchesProvider`, `recent_searches` in the device store, `withRecent`: once each, `recentSearchesMax` 10), listed while the box is empty, a tap searching again, «مسح» clearing them.
  Nothing found shows «لا توجد نتائج لـ «{البحث}»» with «لم تجده؟ أخبرنا», which opens `/search/suggest?q=` (`SuggestScreen`): «اسم المطعم» (required, 60), «ملاحظة (اختياري)» (200) and «إرسال» (`restaurantSuggestionProvider`: `POST /v1/customer/restaurant-suggestions` at the point with the search it followed, a key per body until an answer), then «شكراً، سنحاول إضافته».
  The bottom bar of CU §6.1 waits for the design.
- **Favourites (customer, slice 2.28b; CU §9.6, U18, owner decisions 2026-11-18):** `browsing/favourites.dart`.
  `HeartButton` sits on `RestaurantTile` (the list, the home, the category page, the search, «المفضلة») and in the restaurant page's app bar;
  it shows the card's or page's `favourite` unless this device changed it since (`heartsProvider`, by restaurant, started again on a sign-in or sign-out).
  A guest's tap goes to sign-in and back (`signInFrom` the current location);
  a signed-in tap changes the heart at once and sends `PUT` or `DELETE /v1/customer/favourites/{restaurantId}` without a confirmation, puts it back with «حدث خطأ» when the call fails, and reads «المفضلة» again.
  «حسابي» → «المفضلة» opens `/account/favourites` (`FavouritesScreen`): `favouritesProvider` (`GET /v1/customer/favourites` at `browsingPoint`, its cards turned into the list's with `cardOfSearch`), only those that deliver to the point, «لا توجد مطاعم مفضلة توصل إلى هذا العنوان» without one.
- **«طلباتي» (customer, slice 2.28b; CU §12.3, U18):** home (signed in) and «حسابي» open `/orders` (signed in only; `orders/my_orders_screen.dart`): `myOrdersProvider` reads `GET /v1/customer/orders`, «الطلبات الجارية» first, then «الطلبات السابقة», each row the restaurant, «#{رقم}», the date, the status (`historyStatusText`) and the total, opening `/orders/:id`;
  «عرض المزيد» reads the next page by the answer's `next` (`loadMore`, a failure keeps the list).
  The order screen adds CU §12.3's detail: «قيمة الأصناف», «رسوم التوصيل», «الخصم», «تقريب» when not 0, the total, «سأدفع بـ», «استلم الكابتن: …» and «أعاد لك: …» (Q23), «الكابتن: {الاسم}» once ended, «مراحل الطلب» (the server's `timeline`, `timelineStepText`) and «اطلب مرة أخرى» (`OrderAgainButton`, `canOrderAgain`: delivered, rejected or cancelled, never a free re-delivery), which runs `rebuildCart` (shared with «اطلب بدون الأصناف غير المتوفرة»): asks before it replaces a cart, `OrderAgain.run` reads the restaurant's page at the order's pin and `rebuildLines` builds the cart at today's prices with the notes and without the code, naming what it skipped;
  a restaurant customers no longer see (`404`) shows «المطعم غير متاح حالياً» and builds nothing, and one that cannot take orders now still gets its cart (checkout shows the state).
- **Banners (customer, slice 2.27c; CU §8.1, AP §9.11.2, owner decisions 2026-11-18):** the home's answer carries `banners` (at most 10, the panel's order, only those the customer can open at the point), kept in `HomeView.banners`;
  «البانرات» is `BannerStrip` (`browsing/banner_strip.dart`): a `PageView` across the screen's width at 1200:500 (`bannerAspect`), one `MediaImage` per banner labelled with its title, swiped one at a time, nothing without a banner.
  A tap pushes `bannerPath`: `/restaurants/:id`, `/categories/:id`, `/banners/:id` (`BannerListScreen`: the banner's title over its cards from the same home answer, `cardsOfBanner`, open first and closed last; «لا توجد مطاعم…» once the banner is gone) or `/codes?code=` («أكوادي» signs a guest in first and keeps the query; `MyCodesScreen(shown:)` puts that code first in «متاحة», `selected`, or says «الكود {الكود} غير متاح لك الآن»).
- **The account's state (customer, slice 2.25a; CU §5.5, AP §8.8, §9.8, §9.12.1):** `account/`.
  `accountStateProvider` reads `GET /v1/customer/account-state` at the checked delivery point for a signed-in customer (none for a guest), when the point changes and, through `AccountStateBanners`' `AppLifecycleListener`, when the app returns to the foreground;
  a block from the panel shows at the next read, and the quote refuses ordering meanwhile.
  Home shows the banners first, the block («حسابك محظور حتى {التاريخ}: {السبب}» or «حسابك محظور: {السبب}. تواصل مع الدعم.», `blockText`, the date and time on the city's clock), the dues («عليك {المبلغ} لـ FOX DROP…») with «موقع المكتب وساعاته», which opens `OfficeSheet` (the desk now, the hours from Saturday, `officeWeek`, and «موقع المكتب على الخريطة», a Google Maps link through `customerAuth.launch`; «لم يُحدَّد موقع المكتب بعد…» without one), and the review stop;
  the block and the review stop with «اتصال بالدعم» and «واتساب الدعم».
  Browsing goes on.
  Checkout's `account_blocked` shows the same block text (its `message` the reason's customer text, `until`);
  it, `review_stop` and `dues_unpaid` offer «تواصل مع الدعم» (`ProblemAction.contactSupport`: WhatsApp, else a call; CU Appendix C «Pre-order problems»).
  Tests answer the route through `TestApp.accountState(...)` (free to order by default).
- **«حسابي» (customer, slice 2.25b; CU §13, §5.4, §8.2; owner decision 2026-11-17):** home's «حسابي» opens `/account` (signed in only; `account/my_account_screen.dart`): «بياناتي» (`/account/profile`: `ProfileScreen` with `editing`, prefilled from `profileProvider`, the account's own number read-only with «لتغيير رقمك تواصل مع الدعم», no terms tick, and the save sends `acceptTerms: false`, so an edit never accepts a newer version), «أكوادي», «الإشعارات», «المساعدة» (the FAQ, «واتساب الدعم», «اتصال بالدعم» from `customerAuth.contact`), «انضم إلينا» («انضم ككابتن» opens `captainStorePage`, the captain app's Play page; «أضف مطعمك» WhatsApp to support with «أريد إضافة مطعمي إلى FOX DROP»), «الشروط والخصوصية», «عن التطبيق» (`appVersion`), «تسجيل الخروج» and «تسجيل الخروج من كل الأجهزة» (after a confirmation, `signOutEverywhereProvider`: `POST /v1/customer/auth/sign-out-everywhere`, then this device's session ends; a failed call stays with its sentence);
  both sign-outs go home as a guest.
  «عناويني» since 2.29a;
  «طلباتي» and «المفضلة» since 2.28b.
  «حذف الحساب» (slice 2.25c, CU §5.6, D19) opens `/account/delete` (`DeleteAccountScreen`): the three points of the explanation, «إرسال رمز التحقق» (`deleteAccountProvider.sendCode`: `POST /v1/customer/account/close-code` with the App Check token, a fresh code to the account's own number), the code and «تأكيد حذف الحساب» (`close`: `POST /v1/customer/account/close`), then this device's session ends and home opens as a guest;
  refusals have their sentences (`deleteAccountMessage`: «لا يمكن حذف الحساب أثناء وجود طلب جارٍ», the code request's limits, a wrong or expired code).
  A restaurant card and page with `testMode` (an admin test account's view, AP §9.8) start their line with «تجريبي».
- **The door ping (customer, slice 2.13d; CU §11.7, Q5, U12; owner decision 2026-11-11: no full-screen intent over the lock screen):** the order's `doorPing` is the captain's latest «تنبيه الزبون».
  `DoorRingGate` (`orders/door_ring.dart`) wraps the order screen: while `ringingPing` gives a ping (the order `arrived`, the ping unanswered, under `doorRingFor`, 30 seconds fixed, by the server's clock, and not put away on this phone) it shows the full screen «الكابتن عند الباب ويحاول الوصول إليك» (or «… إلى {المستلم}» for an order for someone else) and rings through `doorRingerProvider` (the phone's ringtone, looping, on Android and iOS since slice 2.46, until the bundled sounds; tests give `FakeDoorRinger` in `TestApp.doorRinger`), with «أنا قادم» (or «سأتصل بالمستلم»: the server picks the answer by the order) and «اتصال بالكابتن» while the captain card gives `phone` (from the pickup, U12; the app never prints it).
  Either button puts the ping away;
  the answer (`answerPingProvider`, `POST /v1/customer/orders/{orderId}/answer-ping` with one key per ping until an answer) refreshes the feed, and another device's answer (`409`) changes nothing.
  The ping arrives as `order.customer_pinged` on the order's channel;
  a ping while the app is open on another screen comes as a foreground push with `kind: door_ping` (`doorPingsProvider`, watched by `CustomerApp`), which opens the order;
  with the app closed the system shows the push on the `ring` channel.
- **A free re-delivery (customer, slice 2.23d; CU §11.2, AP §9.9.3):** an order with `redeliveryOf` shows «إعادة توصيل مجانية لطلب #{رقم}» at the top of its screen (the restaurant's board and the captain's order show the same badge, owner decision 2026-11-17), its total is 0, and `cancelHelpAt(…, redelivery: true)` offers no cancellation.
- **Reports (customer, slice 2.24a; CU §12.2, §12.3, §9.5, owner decisions 2026-11-17):** the order screen's `ReportSection` (`orders/report_section.dart`) shows, by `reportOfferOf` on the server's clock, «بلاغك T-{رقم}: {الحالة}» (AP Appendix C, `ticketStatusText`) with the resolution message once the order has `report`, «الإبلاغ عن مشكلة» while `reportUntil` is ahead (a delivered order, a free re-delivery too), else once the order ended «تواصل مع الدعم» with call and WhatsApp;
  and a link per `redeliveries` («إعادة التوصيل: الطلب #{رقم}»).
  `/orders/:id/report` (`ReportProblemScreen`) takes the type from Content's `customer_problem` (`CustomerContent.problemTypes`), the order's lines by `position` with how many for `itemReportTypes` (required there, none otherwise), the note («أخرى» requires it, up to 300) and up to 3 photos;
  `reportProblemProvider(id)` uploads each photo once (`uploadPhotos`), then sends `POST /v1/customer/orders/{orderId}/report` with a key per body, reads the order again and answers «استلمنا بلاغك T-{رقم}. سنرد عليك خلال 24 ساعة.»;
  `report_closed` and `already_reported` go back to the order with their sentence, a reason refusal reads Content again.
  The restaurant page's «نفس أسعار المحل» dialog offers «أبلغ عن سعر مختلف»: `/restaurants/:id/price-report` (signed in only; `PriceReportScreen`, `priceReportProvider`) with the item from the menu, the shop price typed in the menu's currency (`minorOfTyped` from `core_l10n`), the note and one photo, «شكراً، سنتحقق من السعر» or «أرسلت بلاغاً عن هذا المطعم اليوم».
  **Photos** (`reports/`): `photoPickerProvider` (`image_picker`, camera or gallery, scaled to 1600 pixels; typed by its first bytes, `imageTypeOf`; above 8 MB refused), `PhotoFields` to add and remove them, and `photoPutProvider`, the one request outside the API client: a plain Dio `PUT` of the bytes to the signed URL of `POST /v1/customer/uploads/report-photo` (the storage, with no session; the signature covers the type and size).
  Tests give both through `TestApp`'s overrides. iOS's `Info.plist` names the camera and the photo library.
- **Ratings (customer, slice 2.26a; CU §12.1, U15, Q16):** the order screen's `RatingSection` (`orders/rate_order_sheet.dart`) shows each part the order's `rating` gives as sent («تقييمك للمطعم: {النجوم} من 5», «تقييمك للكابتن: …», with the reasons and the comment; never edited) and «قيّم طلبك» while `ratingPartsLeft` (`orders/rate_order.dart`: the parts not sent while `rating.until` is ahead on the server's clock, the captain's only with `captainRatable`) has any.
  The sheet opens by itself once per order on this phone (`RatingSheetOnce`, `rating_sheet_shown:<id>` in the device store), then only from «قيّم طلبك».
  `RateOrderSheet` has «قيّم المطعم» and «قيّم الكابتن», each with five stars, the reason chips of Content's list for the stars (`CustomerContent.ratingReasons` by list name, `ratingReasonList`: other stars clear the chips; the chosen star tapped again clears the part) and a comment up to 300 characters counted in code points as the server counts them (`commentFits`; the field's counter does not enforce it);
  a part without stars is skipped.
  `rateOrderProvider(id)` sends `POST /v1/customer/orders/{orderId}/rating` with no key (a sent part is never edited: a repeat is `already_rated`), then reads the order again: «شكراً لتقييمك».
  On `already_rated` (a lost answer retried, or a part sent from another phone) it reads the order and sends once more only the parts it carried that are still left, «شكراً لتقييمك» when none is;
  `rating_closed`, `not_ratable` or a second `already_rated` «لم يعد بالإمكان إرسال هذا التقييم»;
  `unknown_reason` reads Content again.
  The cards and the restaurant page show the server's `rating` and `ratingCount`, or «جديد» while null (below 5 ratings).
- **An edit by FOX DROP (customer, slice 2.10a; CU §11.6):** while the order's `edited` is set, the order screen shows «عدّلت FOX DROP طلبك. المجموع الجديد: {المبلغ}»;
  a line an edit added is marked «أُضيف», a changed quantity shows «{الصنف}: {قبل} ← {بعد}», and `removedLines` are listed struck through with «حُذف».
  No approval is asked (operations agree it by phone).
- **The item-unavailable report and a moved time (customer, slice 2.9; CU §11.6, RA §8.12):** while the order's `itemReport` is set (the restaurant reported an item and the report is open), the order screen shows «المطعم أبلغ أن صنفاً في طلبك غير متوفر. سيتصل بك فريق FOX DROP الآن.» after the emergency delay notice;
  it goes when the read gives null (edited, cancelled, closed or withdrawn).
  `order.time_changed`, `order.item_reported`, `order.item_report_withdrawn` and `order.item_report_closed` carry a newer version, so the feed reads the order again and «يصل حوالي {الساعة}» shows the new `promisedAt`;
  the push «تغيّر موعد وصول طلبك إلى {الساعة}» is the server's.
- **Push (customer, slice 2.3b; CU §4.4, §13, §14):** `pushTokensProvider` keeps the installation's token registered while signed in (`PUT /v1/customer/push-token`) and `pushTapsProvider` opens a tapped push's target, both watched by `CustomerApp`;
  `pushTargetPath` maps a push's data to a route (`order`, `home`, and `codes` for «أكوادي», CU §14 #23; the account with its slice), for the «الإشعارات» screen too.
  Android's channels `default` and `ring` are created in `MainActivity`.
  The permission is asked once per installation (`notifications_asked` in the device store), at the first order, after the far-pin check and before the command: «سماح» asks the phone, «ليس الآن» does not, and the order goes either way (`NotificationAsk`);
  a phone that already allows notifications is not asked.
  While the customer was asked and the phone does not allow them, an active order's screen shows `NotificationsOffBanner`, which opens the phone's settings and is read again when the app resumes.
  «الإشعارات» (`/notifications`, signed in only) reads `GET /v1/customer/notifications` when it opens;
  it is reached from «حسابي».
  Tests give `FakePush` through `pushProvider`, and `TestApp.permission`, a `FakeNotificationPermission` that allows notifications unless the test says otherwise.
  Not yet: a push received while the app is in the foreground is not shown (the screens are live; only the door ping acts on it), the app's own sounds for «الكابتن عند الباب», iOS.
- **«أكوادي» (customer, slice 2.21d; CU §12.4):** `/codes` (signed in only; linked from «حسابي», and opened by the push «أُعيد الكود {الكود} إلى أكوادك») reads `GET /v1/customer/promo-codes` at the checked delivery point (`myCodesProvider`; «حدّد موقعك لعرض أكوادك» without one, since the codes are a city's) when it opens, pulling reads again.
  «متاحة» and «منتهية» are tabs;
  each code shows `codeValueText`, its minimum, restaurants, zones and hours (`formatMinuteOfDay`), then «ينتهي {التاريخ}» and the uses left, or when it was used or ended;
  «استخدم» opens the restaurant of a one-restaurant code, home otherwise (`useCodePath`).
  The customer's personal codes (compensation, the late code) come in the same list and in checkout's «الأكواد المتاحة لك» from the server (slice 2.22b);
  the push «لك كود تعويض…» (CU §14 #16) opens `/codes`.
  A cancelled order with `cancellation.compensation` shows «لك كود تعويض {القيمة}: {الكود}» (`personalCodeValueText`, the push's words) with «ينتهي {التاريخ}» and «أكوادي» under its title (CU §11.9).
  An order with `lateCode` (slice 2.22c) shows «تأخر طلبك، وهذا كود خصم {القيمة} لطلبك القادم: {الكود}» (CU §11.6's words; a percentage without a maximum is «15%») with «ينتهي {التاريخ}» and «أكوادي»;
  the code changes the order without an event, so any push of the order on screen reads it again (`doorPingsProvider`).
- **Update and maintenance (slice 2.4a; CU §4.2, §4.7, RA §4.2, §4.10, CA §4.2, §4.8):** each app's `platformCheckProvider` (`lib/src/platform.dart`) is a `PlatformCheck` (`packages/core_platform/CLAUDE.md`) on `GET /v1/<app>/platform` with the app's version, started with the app.
  The router listens to it: while `status.blocks` (maintenance, or a required update) it redirects to `/blocked` («يلزم تحديث التطبيق» or «التطبيق في صيانة» with the panel's message), and back to home once lifted;
  `MaterialApp.router`'s `builder` puts the suggested update's banner (`UpdateBannerFrame`) over every screen.
  What stays reachable: the customer's `/orders/:id` (the blocked screen lists the active orders with `ActiveOrdersBar`);
  in the captain app, `captainBlocked` keeps home while an order is current, and while the captain is online, for a required update (it applies the next time they go online, CA §7.2) and for maintenance alike (owner to confirm: so an online captain keeps the offers and the switch to go offline), and decides nothing before the work's first read, so the router follows the work feed too;
  in the restaurant app nothing, on every device, owner or cashier, signed in or not (RA §4.2, §4.10).
  Tests answer the route through `TestApp.platform(...)` (no update, no maintenance by default).
  A screen can now leave before it read its providers, so a state that uses one in `dispose` reads it in `initState`.
- **Terms (slice 2.4b; AP §9.13, CU §4.7, CA §4.8, K7, RA §4.10, S13):** each app's `termsCheckProvider` (`lib/src/terms.dart`) is a `TermsCheck` (`packages/core_platform/CLAUDE.md` «Terms») on `GET /v1/<app>/terms`, kept for the app's life (never rebuilt at sign-in: the router reads it, and a router rebuilt loses its screens), started at each sign-in and cleared at sign-out;
  `/terms` shows `TermsScreen`.
  The customer app pushes `/terms` once per pending version (`termsPromptProvider`, watched by `CustomerApp`) when the screen on top is not one that waits (before home, `/blocked`, an order's screen);
  the customer may go back and browse, home shows «وافق على الشروط الجديدة لتتمكن من الطلب» with «عرض الشروط», checkout's `terms_pending` offers the same and asks the quote again on return, and the sign-up's tick links to the terms (the tick accepts the version in force on the server, and the app reads the terms again before the profile counts as completed).
  Home links to the terms until «حسابي» exists.
  A guest reads the text when the screen opens and has nothing to accept.
  Tests answer the route through `TestApp.terms(...)` (version 1, accepted, by default).
- **Emergency stop (customer, slice 2.4d; AP §9.1.6, CU §4.7, §10.6, §11.6, §14 #18–19):** `lib/src/emergency_stop.dart`.
  `emergencyStopProvider` is an `EmergencyStopCheck` (`packages/core_platform/CLAUDE.md`) on `GET /v1/customer/emergency-stop` at the checked delivery point, read when the point changes and on each return to the foreground: the app has no channel of its own, so a stop that starts while it stays open shows at the next read, and the quote refuses the order meanwhile.
  `EmergencyStopNotice` shows the browsing message on home (second among CU §6.2's banners), the restaurant page and the cart;
  browsing goes on.
  Ordering stops at checkout: the quote's `emergency_stop` problem shows its `message` and keeps «تأكيد الطلب» off, like every problem.
  The quote checkout's first frame asks carries `openedCheckout: true` (`CheckoutOpening`, marked in the screen's `initState`, taken by the quote before any wait; a cart quote still alive is asked again), so the server counts the attempt;
  every later quote sends false.
  `orderEmergencyStopProvider(id)` reads the stop at the order's address while its screen is open and follows `order:{id}` for `platform.emergency_stop` (and reads again whenever it connects);
  `EmergencyDelayNotice` shows the delay notice, its reason filled by the server, on an order that has not ended.
  The pushes are the server's (#18 opens the order; #19 «الخدمة عادت» has `target: home`, which opens home).
- **Images (customer, slice 2.5; CU §4.5, architecture §5.8):** the API gives keys in `public-media` (`logoKey`, `coverKey`, `photoKey`, null without an image);
  `MediaImage` (`lib/src/media_image.dart`) shows one at a logical size, asking imgproxy for the smallest preset width that fills it on this screen (`mediaUrl`, `mediaWidth` in `lib/src/media.dart`, `mediaWidths` kept equal to `infra/imgproxy/imgproxy.env` by a test), as WebP, cached on the phone's disk (`cached_network_image`);
  while it loads or if it fails, the space stays empty.
  The list shows the logo, the restaurant page the cover, the logo and item photos, the item sheet the photo.
  The images' base is `--dart-define=MEDIA_BASE_URL`, else the API's host under `/media` (nginx), or, in a debug build, the API's host on port 8088 (the development imgproxy).
  Tests answer every image from memory through `mediaLoaderProvider` and record the URLs in `TestApp.mediaUrls`.
- **Content (slice 2.1; AP §9.13):** each app reads `GET /v1/<app>/content` once into its `contentProvider` (`lib/src/content.dart`, kept for the app's life; a failed read is read again with `ref.invalidate`): the reason lists it picks from, as `{ code, label, needsText }`, and its FAQ set.
  A reason list is never a constant in an app: the choice sends the code back, shows the label, and offers a text field when `note` is `optional` or `required` (required: «أخرى»).
  A command refused with `unknown_reason`, `reason_note_required` or `reason_note_not_allowed` means the panel changed the list: the app reads it again (`ReasonChanged` in the captain app) and the person chooses again.
  The customer app shows «الملاحظات الجاهزة» at checkout (none while not read), the FAQ at `/faq`, and the `cancellation.text` of an order operations cancelled under «أُلغي طلبك» (the automatic cancellation keeps CU §11.9's own «لم يرد المطعم على طلبك، نعتذر»);
  the captain app takes the away and shortfall reasons from it and shows the work rules (`/work-rules`, one rule per line) and the FAQ (`/faq`).
- **Server address:** `--dart-define=API_BASE_URL=http://<address>:3000`.
  Without it a debug build uses the development machine (owner decision 2026-11-05): `10.0.2.2:3000` on the Android emulator, `localhost:3000` on iOS Simulator and Windows;
  a phone needs the machine's address.
  A release build refuses to start without it: `main()` reads the address before `runApp`.
  Android has three flavors (architecture §11.4, slice 1.14b): `development` (`.dev`, the pubspec's `default-flavor`, so `flutter run` needs no flag), `staging` (`.staging`) and `production`;
  CI builds the staging APKs signed with each app's key (the `deploy` skill, «The staging APKs»).
  A release build without `FOXDROP_KEYSTORE_FILE` is signed with the debug key: never hand it out. iOS has the same three flavors (slice 2.46, Android's bundle IDs), from iOS 15.5 (`IPHONEOS_DEPLOYMENT_TARGET`, the Podfile's platform: MapLibre's minimum, CU §4.1 and CA §4.1; owner decision 2026-11-20): one scheme per flavor and the configurations `Debug-<flavor>`, `Release-<flavor>` and `Profile-<flavor>`, each on its own `ios/Flutter/<configuration>.xcconfig` (which includes CocoaPods' file when it exists, then `Generated.xcconfig`), with `Runner/Runner.entitlements` (push, time-sensitive notifications, App Attest).
  Every plugin builds through Swift Package Manager but `flutter_ringtone_player`, so this app keeps a `Podfile` mapping the nine configurations;
  a new configuration goes into it too.
  Its `Podfile.lock` and the `[CP]` build phases `pod install` adds come from the first build on a Mac (CI builds without them).
  Info.plist's `remote-notification` background mode lets a mass push, which the server sends with `content-available`, wake the background handler that acknowledges it (AP §9.11.4).
  CI builds both iOS apps unsigned on every pull request (`ios-release`) and signs and uploads them to TestFlight once the Apple account exists (the `deploy` skill, «The staging iOS builds»).
  On iOS the Firebase values are the iOS app's ID and the iOS API key.
  On Windows, when the repository and the pub cache are on different drives, a release build needs `--android-project-arg=kotlin.incremental=false` (Kotlin's incremental caches fail across drives).
  Plain HTTP is allowed only in the Android debug manifest and, on iOS, for the local network (`NSAllowsLocalNetworking`).
  Firebase (App Check) takes four more `--dart-define` values, which CI passes to the staging APKs (the `deploy` skill, «App Check»);
  without them the app sends no App Check token, which the local server accepts while `otp.app_check_required` is off.
  Never put a key or secret in the app (E7): every `--dart-define` ships inside it, the Firebase API key included, which is an identifier, not a secret.
- **Arabic, right to left (AP §4.7):** every user-facing string is a getter of `AppLocalizations` from `core_l10n` (`packages/core_l10n/CLAUDE.md`);
  never a string literal in a widget.
  The app's `locale` is `ar`, so Flutter lays it out right to left.
  Use `EdgeInsetsDirectional`, `AlignmentDirectional` and `start`/`end`, never `left`/`right`.
  The launcher name and the system's permission texts are the only text outside ARB: `android:label` in `AndroidManifest.xml`, the push channels' names in `res/values/strings.xml`, `CFBundleDisplayName` and the `NS…UsageDescription` keys in `Info.plist`, and the window title in `windows/runner/main.cpp`.
- **Design stop:** no `core_ui`, theme, colours, fonts or styling until the owner says the UI/UX and the design system are ready (root `CLAUDE.md`).
  Screens use plain Material widgets with their defaults.

## Commands

From the app's folder, with the pinned Flutter (`.fvm/flutter_sdk/bin` first on `PATH`), after `docker compose up --detach` and the server on port 3000:

- `flutter run`: on the running emulator, simulator or (merchant) `-d windows`.
- `flutter test` and `dart analyze --fatal-infos`: what `pnpm verify` runs for every Flutter package through Melos.
