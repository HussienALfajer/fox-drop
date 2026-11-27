# apps/captain

> Moved here from `apps/captain/CLAUDE.md` on 2026-11-20 (`docs/archive/claude-code-workflow.md`). In these notes, a folder's `CLAUDE.md` (or "its `CLAUDE.md`") means that folder's file under `docs/code/` when there is one, otherwise the folder's own `CLAUDE.md`; the folder's own `CLAUDE.md` now holds only the rules for working there.

The captain app «تطبيق الكابتن» (Android, iOS; architecture §11, §14). It follows the rules of `.claude/rules/flutter-apps.md`.

**D.R1 (2026-11-27):** with every UI component, the owner deleted the sign-in screen (core_auth's `sign_in_screen.dart`): the `/sign-in` and `/join` routes, the captain's sign-in wrapper with «سُجّل دخولك من جهاز آخر» (CA §4.9) and the welcome screen's two buttons went with their UI tests. Signed out, every route leads to `/welcome`, an empty screen, until the new sign-in and join screens are built. History: git before the D.R1 merge (`docs/slices/D.R1-delete-components-screen-first.md`).

## The work cycle (slice 1.14g; CA §4.3–4.6, §7–§9, §14–§15)

- **Layout:** `lib/src/work/`.
  `work.dart` holds the state and its pure rules (the step, the open and refused pickup requests) and the feed;
  `location.dart` the location;
  `commands.dart` the commands and their refusals;
  `door_payment.dart` the door payment's pure rules;
  `alerts.dart` the ring and the chimes;
  `texts.dart` every string mapping;
  `offer_sheet.dart`, `order_view.dart`, `payment_form.dart` and `reason_sheet.dart` only show that state and call it (the design stop).
  `home_screen.dart` shows the availability or the active order, under `WorkLayer`: the offline bar, the offer, the alerts, the hand-in reminder and the summary.
- **State:** `workFeedProvider` is a `LiveFeed` (`packages/core_realtime/CLAUDE.md`) over `captain:{captain_id}` (the id from `GET /v1/captain/auth/session`) whose fetch reads the availability, the open offer and the active order together, so the screens never show one newer than the others;
  the versions are the active order's.
  The screens read `workProvider` and never patch it;
  every command's answer refreshes it.
- **Location (CA §4.3, architecture §14.1; slice 2.43, owner decision 2026-11-20):** `PhoneLocationSource` (`location.dart`) asks for the permission and takes one-off positions through `geolocator`, and tracks through `flutter_background_geolocation`: every 10 seconds moving or not (`distanceFilter` 0, `allowIdenticalLocations`, the filter `passThrough`, stop detection and motion activity off, so no «النشاط البدني» permission, `changePace(true)` at start), its foreground service of type `location` with «أنت متصل — FOX DROP يتابع موقعك لتصلك العروض», `stopOnTerminate` false and `startOnBoot` true, and every point kept in its own database (a day, 8640 points at most) until the app sends it.
  `ready` runs once per run of the app (one shared future), and since the library remembers it ran (after the system ended the app, or a reboot), it is stopped right after unless a `track` listener wants it, and on `clear`: never tracking while offline or signed out;
  a cancel while starting stops it once started.
  Its Android licence is the env `FOXDROP_BGGEO_LICENSE` of the build (CI: the secret `STAGING_CAPTAIN_BGGEO_LICENSE`, made for the staging app ID), a manifest placeholder (`app/build.gradle.kts`, which keeps resources unshrunk as the library requires), bought later (owner decision 2026-11-20);
  a debug build needs none, and a release build without it (`BACKGROUND_LOCATION_LICENSED` not defined, which `staging-apks` passes with the key) tracks through `geolocator`'s foreground service as before, its points in memory.
  `LocationTracker` runs while the state is online in any way (available, busy, no offers), started and stopped by `WorkLayer` from the state, never while offline.
  The source keeps the points (`LocationSource.pending`, `sent`, `clear`): the tracker reads up to 360 every 10 seconds, oldest first, puts them on the server clock (`ServerClock.offset`) when it sends them, and forgets them once the server answers, or for `409 not_online` and a `400`;
  no answer or a 5xx keeps them.
  A stop sends what is kept (from before a restart too) every 10 seconds until none is left.
  The latest point feeds the arrival radii and every command's fix (which the server keeps with the command, so it is not sent again as a point), taken again at each retry (a fresh position when it is older than 20 seconds).
  Going online asks for the location permission and a position first, then sends its mock flag;
  that position is kept as the latest, never sent, since the captain is still offline.
  `start` asks for the location access itself before tracking, since a phone signed in while the captain is online (a released device, CA §4.9) never went online on it;
  without access, or when the stream fails, it stays stopped and the next online state tries again.
  A session that ends (sign-out, another device, a released device) resets the tracker: no more points, the kept points dropped, the foreground service stopped.
  `WorkLayer` ignores the loading states, which still carry the last online state.
- **Commands (CA §4.6, §15):** `Commands` runs one command at a time per subject (`availability`, the offer's id, the order's id), shown as «جارٍ الإرسال…».
  As in the restaurant app, the `Idempotency-Key` belongs to the command and its body (the fix is left out, as the server's hash does), and a call without an answer, a 5xx, a 408 or a 429 is sent again with the same key after a backoff.
  `refusal` maps every refusal of CA §15 to a `Notice`, which `texts.dart` explains.
  The answers of going offline (the hand-in) and delivery (the summary) are kept in `handInProvider` and `summaryProvider` until closed.
- **The offer (CA §8, §4.4; slice 2.43):** it shows and rings while it is open, before its `expiresAt` on the server clock and not answered on this phone (`ringingOffer`), checked every second;
  past its time the feed is fetched again, so a lost event never leaves it on.
  `AlertsRinger` (`alerts.dart`) rings through `core_alerts`: the bundled offer sound looping on the alarm stream, vibration, and the prompt with «عرض جديد: {الأجر} — {المطعم}» (`offerRingText`) over the lock screen, full screen where Android allows it and heads-up otherwise (CA §18 item 6).
  The native ring is the process's and an offer's push rings it too, so every 5 seconds (`resendEvery`) a ringing offer is rung again (which lifts the push's phone-clock timer) and a quiet state stopped again (a push that came after the offer was answered here);
  the device check's test offer (`test`, `stopTest`) is left alone by `stop` and never plays over an offer;
  the chime and the cancellation sound play once, never over a ring.
  `MainActivity` provides `core_alerts`' cached engine and keeps it (`shouldDestroyEngineWithHost` false), so the feed and the ring outlive the activity while the location's service keeps the process.
  The screen stays on while online (`wakelock_plus`).
  Back does not leave the app while an offer shows.
- **Time:** every countdown and «منذ» watches `tickProvider` (once a second) and reads `serverClockProvider`; never `DateTime.now()`.
- **Alerts (CA §14):** `alertStep` compares two states the server answered: the offer gone before its time («لم يعد العرض متاحاً», silent) or after it («انتهى العرض»), an order not accepted on this phone («عيّنتك العمليات على طلب»), ready, the pickup confirmed (by operations or not), refused, and disputed after pickup, each with a chime unless silent.
  Thirty seconds without the channel chime once.
- **Cancelled by operations (slice 2.8b; CA §9.10, §14 #11):** the active read's `cancelled` (the latest order of this captain operations cancelled, not yet seen, within 12 hours) is `Work.cancelled`.
  `alertStep` raises `OrderCancelled` when a record appears that the previous state did not have, which plays `Ringer.cancellation()` (the bundled cancellation sound once, slice 2.43) and no message;
  a record already waiting when the app opens shows silently.
  `_CancelledCard` covers home with «أُلغيت المهمة: {السبب}» (the reason's label), the cash line (`cashText`: `returned` «استرجع المبلغ من المطعم», `not_returned` «لا تسترجع المبلغ، يُخصم من المطعم في التسوية», otherwise none), «تعويض: {المبلغ}» when compensated, and «حسناً», which posts `acknowledge-cancellation` (no `Idempotency-Key` and no location: it only records once that the captain saw it);
  the availability shows under it, and an offer over it.
- **Taken from the captain (slice 2.12a; CA §9.10, §14 #11, AP §9.3.2):** the active read's `withdrawn` (the latest withdrawal from this captain, not yet seen, within 12 hours) is `Work.withdrawn`.
  `alertStep` raises `OrderWithdrawn` when a withdrawal appears that the previous state did not have (another order, or the same order taken again), which plays `Ringer.cancellation()` and no message;
  `_WithdrawnCard` covers home with «سُحب منك الطلب: {السبب}» (the reason's label), the cash line (`withdrawnCashText`, the cancellation's two texts) and «حسناً», which posts `acknowledge-withdrawal` (no key, no location).
- **An outcome set by operations (slice 2.11a; CA §9.10, §9.12):** the active read's `ended` (the latest order of this captain operations ended with an outcome, not yet seen, within 12 hours) is `Work.ended`.
  `alertStep` raises `OutcomeSet` when a record appears, which chimes with no message;
  `_EndedCard` covers home with «أنهت العمليات الطلب: {النتيجة}.» (`outcomeText`, AP Appendix C), where the food goes (`foodText`: «الطعام يبقى معك», «أعِد الطعام إلى المطعم», «أتلف الطعام»), «أجرك من الطلب: {المبلغ}» or, with the captain responsible, «خُصم من مستحقاتك {المبلغ}: {النتيجة}», and «حسناً», which posts `acknowledge-outcome` (no key, no location).
  **An amount to collect (slice 2.11b, K9):** while the active order's `outcomeToCollect` is set, `OrderView` replaces the step with «بانتظار تسجيل التحصيل», «أنهت العمليات الطلب: {النتيجة}. اقبض {المبلغ}.» and `PaymentForm` with `outcomeAmount` and `outcomeEquivalents` (the amount in the other accepted currencies, which the server computes from the order's snapshot), whose «تم التسليم» posts `Commands.collectOutcome` (`outcome-payment` with the latest fix when there is one, no radius) and opens the summary;
  `alertStep` chimes `OutcomeToCollect` when it appears.
  A payment operations record instead ends the order with the outcome card.
- **The handover after the pickup (slice 2.12b; CA §9.10.1, §14 #11, K17):** an offer whose `handover` is set shows «استلام من كابتن», «من الكابتن {الاسم} — {المسافة}» in place of the restaurant and «لا تدفع شيئاً» in place of the pickup payment.
  The active order's `handover` replaces the steps: `receiving` (the second captain, `receiving()`) is step 1 «استلام من كابتن» to the first captain's latest point, with «ابدأ الملاحة», «اتصال بالكابتن», «لا تدفع شيئاً», the amount to collect and «الحي», and «استلمت الطلب من الكابتن {الاسم}» enabled within `radii.customerMetres` of that point (`Commands.receiveHandover`, `receive-handover` with the fix; `too_far_from_captain` is `TooFarFromCaptain`);
  `giving` (the order's captain, `giving()`) is the waiting screen «سيستلم الكابتن {الاسم} الطلب منك. انتظره في موقعك.» with the second captain's distance and «اتصال بالكابتن» once assigned (while still offered: «تبحث العمليات عن كابتن يستلم الطلب منك. انتظر في موقعك.»), which `alertStep` chimes once (`HandoverStarted`).
  While a handover is open both screens read the order again every 15 seconds, so the other captain's position stays live.
  After the receipt the active read's `handedOver` is `Work.handedOver`: `OrderHandedOver` plays `Ringer.cancellation()` and `_HandedOverCard` shows «سلّمت الطلب للكابتن {الاسم}» with «حسناً» (`acknowledge-handover`, no key, no location);
  the first captain is offline then (K17).
- **The steps (CA §9.1–9.8):** the arrival buttons use the radii the active order sends (`radii`, the settings `captain.merchant_arrival_radius_m` and `captain.customer_radius_m`) against the latest point by the straight line, as the server measures;
  worse than 100 m the restaurant arrival waits for operations (K3).
  The item check resets when the restaurant answers «الطلب غير مكتمل».
  The pickup sends the proposed lines (the base currency only in Phase 1).
  «وصلت» and «تم التسليم» ask for the away reason first when the phone is beyond the radius, and again when the server measures it so;
  a reason given at the arrival covers the delivery (K4).
  The door payment keeps the amount due it showed, and says «تغيّر المبلغ المطلوب إلى …» when the order's changes.
  It proposes the change only for money received in the base currency, which needs no rate (CA §9.7 item 3: the change is in the base currency);
  the server checks every other line with the order's rates.
  A shortfall is the server's to find (a gap within half the largest rounding unit is rounding, AP §8.6): its `shortfall_reason_required` brings the reason list, and «تم التسليم» waits for a reason.
- **Tests:** `work_test.dart` proves the pure rules (the door payment, the refusals, the alerts, the ring, the location queue);
  `home_test.dart` drives the cycle from going online to the summary with `TestApp` (`test/fixtures.dart`: the JSON as the server sends it, `FakeServer`, `FakeTransport`, `FakeLocation`, `FakeRinger`, a server clock the test moves with `advance`).
  Widget tests wait with `settle` (the home's one-second tick never lets `pumpAndSettle` finish), tap below the fold with `tapVisible` and end with `done`.

## Joining (slice 2.34a; CA §5.1–5.4, §15; owner decisions 2026-11-19)

- **Layout:** `lib/src/joining/`.
  `application.dart` holds the application as the server answers it (`Application`, `applicationOf`), the pure rules (`firstOpenStep`, `formDocuments`, `isRequired`), `applicationProvider` (`ApplicationController`: `GET /v1/captain/application` and each step's command, its answer replacing the state; refusals as `ApplicationRefusal` with the server's code) and `applicationZonesProvider`;
  `photo_check.dart` the blur and darkness check (`photoQuality`: the mean brightness under `darkBelow`, the variance of the Laplacian under `blurryBelow`, on the photo read `photoCheckWidth` wide; thresholds decided by us);
  `texts.dart` every string mapping;
  `welcome_screen.dart` and `application_screen.dart` only show that state and call it (the design stop).
- **The entry (CA §5.1):** signed out, every route leads to `/welcome` (its «انضم ككابتن» and «تسجيل الدخول», the `/sign-in` and `/join` routes and the other-device notice were deleted in D.R1 and return with the new sign-in screen; a join calls `requestCode(input, join: true)`, so the code request carries `join` and reaches a new number).
  After the sign-in the router waits on `/starting` until `GET /v1/captain/auth/session` first answers (a read again keeps the last answer; a failed read is tried again after 5 seconds): `captainId` null is an applicant, kept to `/application`, `/terms` and `/work-rules` (maintenance and a required update still block it);
  the work feed and the captain channel stay off for it;
  the push token registers for it too (slice 2.34b), and a push with `target: application` opens `/application` and, tapped or received in the foreground, reads the application again.
- **The form (CA §5.2):** a `Stepper` of the five steps, opening at the first with something missing (`firstOpenStep`);
  each step saves on the server before the next (the draft), and the steps after the first open once step 1 is saved.
  Step 1: the three-part name, the date of birth, the neighbourhood from the zones.
  Step 2: the vehicle (the four of CA §5.2), the plate and «نقبل المركبات المرخّصة فقط» for a motor vehicle.
  Step 3: each document of `formDocuments` with its status;
  «رفع» or «رفع نسخة جديدة» opens `DocumentSheet`: the camera (the front camera for the personal photo, «اختيار ملف» too for the civil registry and the criminal record, `photoPickerProvider` of the reports), each photo checked by `photoCheckerProvider` before it joins (`captainPhotoBlurry`, `captainPhotoDark`), the ID's two sides and number, the criminal record's issue date, then «حفظ المستند» uploads each photo once (`POST …/documents/upload`, `photoPutProvider`) and saves the document.
  Step 4: «قواعد العمل» and `/terms` (core_platform's `TermsScreen`, whose «أوافق» is the required tick), then the application is read again.
  Step 5: the summary, what is missing, «إرسال الطلب».
- **The status page (CA §5.4; slice 2.34b):** once sent, the stage's sentence (`stageText`: the spec's words for each stage; the interview's day, time and place and the rejection's reason and `reapplyFrom` date on the city's clock, the stage's name when the server sent neither), «يرجى رفع {المستند}: {السبب}» for each open request (`requestText`), the interview's office through `navigationTo` and `captainAuth.launch` (no map widget), each uploaded or requested document (`statusDocuments`) with its status and, by `canUploadAgain` (a request or a rejected copy in force, while new, under review, interview, awaiting kit or waitlist, as the server takes it), «رفع نسخة جديدة», which opens the form's `DocumentSheet` with its photo checks;
  then «مراحل الطلب» (`historyText`, oldest first).
  After a rejection, `canReapply` (on `serverClockProvider`, read when the page builds) shows «تقديم طلب جديد», which shows the form again with step 1 filled from the rejected application;
  its save starts the new draft on the server, and `409 reapply_wait` says «لم يحن موعد التقديم من جديد.».
  «تسجيل الخروج» sits in the bar of both.
- **Tests:** `joining_test.dart` (the photo check, the rules, the join, step 1, a document's check and upload, the submission and the status);
  `TestApp` gives `picked`, `pickedFrom`, `photoQuality` and `puts`, and a test sets its own `/v1/captain/auth/session` before `pump`.
- **Not yet:** the guide frame over the ID camera (CA §5.3; the system camera has none, an in-app camera waits for the design), a PDF for «اختيار ملف» (images only, as the server's uploads), the contract's scan in the app (a signed GET on the API's host).

## Activation and the profile's contract and documents (slice 2.35a; CA §5.4–5.5, §12.2–12.4, K6)

- **Layout:** `lib/src/profile/`.
  `profile.dart` holds `contractProvider` (`GET /v1/captain/contract`), `phaseText`, `captainDocumentsProvider` (`CaptainDocumentsController`: `GET /v1/captain/documents` and «رفع نسخة جديدة», which uploads through `POST …/documents/upload` and `photoPutProvider` and sends `PUT …/documents/{kind}`; refusals as the application's `ApplicationRefusal`, `refusalOf`), `documentsOf`, `documentStateText`, `documentBanners`, and the welcome tour's mark (`deviceStoreProvider`, core_storage's `DeviceStore`, the key `captain.welcome_tour.<captainId>`; `tourSeenProvider`, `markTourSeen`);
  the screens only show that state (the design stop).
- **The move home:** «مفعّل» read on the status page invalidates `captainSessionProvider`, whose answer now names the captain, so the router leaves `/application`;
  the push «مرحباً بك في FOX DROP!» (`target: home`) reads the application and the session again too.
- **The welcome tour (CA §5.5):** `ProfileNotices` on home opens `/tour` once while the captain has a contract and the device has no mark: five pages (going online, an offer, an order, custody, earnings; our words, to confirm with the owner), then `SettingsBody` (the settings' «أقصى مبلغ أحمله» and «العملات التي أحملها», now one widget for both screens) and «ابدأ العمل», which writes the mark.
  A captain the seed made has no contract and sees no tour.
- **Documents (CA §12.2, K6):** «المستندات» (`/documents`, from «ملفي») lists each document with its state («ساري», «ينتهي قريباً», «منتهي»), its expiry, a replacement waiting and the latest rejection, and «رفع نسخة جديدة» opens the joining's `DocumentSheet` with `save: controller.replace`.
  Home shows the amber banner (`documentBanners`, unstyled) of a document expiring or expired, which opens the screen.
  Going online refused for an expired required document says «انتهت صلاحية {المستندات}…» (`document_expired`, `documentKindOf`).
- **«العقد والعدة» (CA §12.3–12.4):** `/contract` shows the phase, the start, the probation's and the commitment's ends, the early exit's three rules (C17) and «لإنهاء العقد اطلب ذلك عبر «الدعم».», the kit issued with sizes, the deposit, what is paid and the weekly instalment, and the refund's rule.
  The contract's scan waits for a signed GET on the API's host.
- **Pushes:** `target: contract` opens `/contract`, `documents` `/documents`, `home` `/`; each reads its provider again on arrival (`refresh` in `pushTapsProvider`).
- **The applicant's documents** leave out the office's `signed_contract` (`applicationOf`).
- **Tests:** `profile_test.dart` (the tour once, the banner and a replacement, the contract screen);
  `TestApp` gives `deviceStore` and answers no contract and no documents unless a test says otherwise (`contractJson`).

## The map and the route (slice 2.29b; CA §4.6, §9.2, §9.5, architecture §7.1–7.2)

- `LegMap` (`work/route.dart`) sits on top of step 1 (to the restaurant) and step 3 (to the customer): `routeMapProvider`'s map (`core_maps`' `maplibreRouteMap` on the style of `mapStyleUrl`) of `legView`: the restaurant or the pin, the captain at the latest fix (`latestFixProvider`, so the marker follows every point) and the route line when the server gave one, then «الوصول حوالي {الساعة}» (`LegRoute.arriveAt`: the read's moment on the server clock plus the leg's duration, so it stays true while the leg lasts).
  `legRouteProvider` reads `GET /v1/captain/orders/{orderId}/route` once per leg (keyed by the order and the leg, CA §4.6);
  without OSRM it has no line and the time is the straight line's;
  a failed read, or one before the captain's first point, leaves the map without either and reads again after `legRetry` (30 seconds).
  «ابدأ الملاحة» stays each step's button (CA §4.6: the map is for overview).
  Tests give a fake map (`TestApp.mapViews` records each view drawn);
  `route_test.dart`.

## Last-order mode (slice 2.13a; CA §7.3, §7.5, §7.6, K13, K18)

- During an active order `_LastOrderBar` above the order replaces «متصل» with «لا أريد طلبات جديدة» (`Commands.setLastOrder`, `POST /v1/captain/availability/last-order`), «ستصبح غير متصل بعد هذا الطلب.» while on;
  a mode operations, a suspension or a termination set shows its reason instead (`lastOrderText`), with no switch, and `last_order_not_yours` says so.
  `workFeedProvider` reads the state again on `captain.availability_changed` (a publication with no order version, which `LiveFeed` ignores), and `handInAfterLastOrder` opens the hand-in card when a last order took the captain offline holding more than `custody.remitTolerance`.
  The force offline's push (CA §14 #26) shows as a notification.

## «مشكلة» and «لا أستطيع إكمال الطلب» (slice 2.13b; CA §9.11, C5, K17)

- `ProblemBar` (`work/problem_sheet.dart`) sits above every step of the active order, under `_LastOrderBar`: «مشكلة» opens a sheet with «اتصال بالعمليات» and «واتساب العمليات» (the support numbers, `captainAuth.contact`; a missing one hides its button) and, while no request is open, «لا أستطيع إكمال الطلب», which picks a reason of Content's `captain_cannot_complete` list (`CaptainContent.cannotComplete`, «أخرى» with its text) and posts `Commands.cannotComplete` (`cannot-complete` with the fix).
  While the active order's `cannotComplete` is set the bar shows «بانتظار العمليات», the reason's label and «تراجع» (`Commands.withdrawCannotComplete`);
  every step stays open (owner decision 2026-11-11).
  When operations take the order the app hears the withdrawal or the handover as before, and `captain.availability_changed` reads the state: the captain is offline (K17).
  The report with a quick reason waits for slice 2.24.

## «طوارئ» (slice 2.13c; CA §9.11, C15, K12, K17, CA §4.5 check 8)

- `EmergencyButton` (`work/emergency_button.dart`) sits under `ProblemBar` on every step of the active order: red (the spec's colour, otherwise unstyled), held `emergencyHold` (2 seconds, K12) with its progress ring;
  a shorter press does nothing.
  Held, it calls operations (`captainAuth.contact`'s phone) through `operationsCallerProvider` (`work/call.dart`) and, for the order's own captain while none is open, posts `Commands.emergency` (`emergency` with the latest fix whatever its age, a new one within 3 seconds, or null: the server never refuses it), on its own subject so a step being sent never holds it back.
  The operations number is kept on the phone (`captainAuth.store`, `operationsPhoneKey`) at every fetch, so a press without signal still calls;
  with no number at all it says «لم يصل رقم العمليات إلى هاتفك بعد…» (`NoOperationsNumber`) and still sends.
  While the active order's `emergency` is set it shows «أُبلغت العمليات بالطوارئ وموقعك. ابقَ في مكان آمن.» (or, when `located` is false, «…ولم يصل موقعك…») and another press only calls: it cannot be withdrawn (owner decision 2026-11-11).
  When operations take the order the app hears it as before and the captain is offline (K17).
- **The call:** `PhoneCaller` calls through `MainActivity`'s `com.foxdrop.captain/call` channel: `ACTION_CALL` with `CALL_PHONE`, else `ACTION_DIAL` with the number;
  off Android (and when the channel fails) it opens `tel:`, where iOS asks to confirm.
  `Commands.goOnline` asks for the call permission after the notification permission (`askCallPermission`, permission_handler's `Permission.phone`), never blocking, as check 8 of the device check until it exists.
  Tests give `FakeCaller` (`caller`: `prepared`, `calls`).

## The customer not answering (slice 2.13d; CA §9.9, §14 #13, #13a; owner decisions 2026-11-11)

- `DoorPanel` (`work/door.dart`) sits in step 4 between the customer block and the payment, while the active order's `noAnswer` is set (the server gives it at the door only): «تنبيه الزبون» enabled once the server's `nextPingAt` passed (`Commands.pingCustomer`, `ping-customer` with the fix), «التنبيهات المتبقية: {العدد}», «يمكنك التنبيه مرة أخرى الساعة {الساعة}» until then;
  the customer's latest answer («الزبون رأى التنبيه وهو قادم» or «الزبون يتواصل مع المستلم», `pingAnswerText`);
  from `reportableAt` «الزبون لا يستجيب» (`Commands.reportNoAnswer`, `customer-not-answering`), before it «يظهر «الزبون لا يستجيب» الساعة {الساعة}»;
  then «العمليات تراجع الطلب — انتظر تعليماتهم» until operations' «انتظر», whose message shows as a card «العمليات: انتظر الزبون. {الرسالة}» while the button comes back at the next `reportableAt`.
  Every time is the server's and the panel watches `tickProvider`.
  `alertStep` chimes `CustomerAnswered` when a newer answer appears and `WaitForCustomer` when a wait does, each with its message.
  The payment stays below: the customer may appear meanwhile (CA §9.9 item 5);
  the outcome is operations' «تحديد النتيجة», which the app shows as before.

## Pickup currencies (slice 2.14a; CA §10.5, C8, RA §12.7; owner decisions 2026-11-11)

- **«الإعدادات»:** `lib/src/settings/`, reached from «المزيد» (`/settings`);
  for now «أقصى مبلغ أحمله» and «العملات التي أحملها», which grow with the captain's settings (CA §12).
  `carriedCurrenciesProvider` reads and sets `GET`/`PUT /v1/captain/settings/carried-currencies`;
  a switch per currency of the city with its Arabic name from the server, the base marked «العملة الأساسية», and the last one carried cannot be switched off (`CarriedCurrencies.switched`).
- **«أقصى مبلغ أحمله» (slice 2.15a; CA §10.5, C4, K2):** `maxPickupProvider` (`settings/max_pickup.dart`) reads and sets `GET`/`PUT /v1/captain/settings/max-pickup-amount`.
  `MaxPickupForm` (`settings/max_pickup_form.dart`) shows the limit («الحد الآن: {المبلغ}» or «بلا حد الآن»), a field in the base currency (`minorOf`, «اكتب مبلغاً أكبر من صفر.»), «حفظ» and «بلا حد»;
  it sits on «الإعدادات» (apart from the currencies, so one failed read never hides the other) and in the question `askMaxPickupUnanswered` asks at «متصل» while the server says the captain never answered (K2, once: «حفظ» or «بلا حد» answers it; a failed read never holds going online back).
  The server refuses a change during an order (`409 active_order`, CA §15).
  An offer with `aboveMaxPickup` shows «المبلغ أكبر من الحد الذي حددته — اقبل فقط إذا كان معك ما يكفي» (CA §8.4).
  The activation's ask is the welcome tour's last page (slice 2.35a).
  Tests: `max_pickup_test.dart`.
- **The pickup's payment:** step 2 pays the server's one proposed line (`pickup.proposedLines`).
  With more than one currency the restaurant accepts (`pickup.currencies`, each with the whole pickup payment in it), «تقسيم المبلغ أو تعديله» opens one field per currency, the proposal filling its own;
  the typed lines go with «دفعت للمطعم واستلمت الطلب» and the server checks them (`amount_mismatch`, `currency_not_accepted`).
  Tests: `pickup_currencies_test.dart`.

## The item-unavailable report (slice 2.9; CA §9 step 2, RA §8.12, §8.10)

- While the active order's `itemReportOpen` (`pickupBlocked`), the at-restaurant step keeps the item check but shows «بانتظار تعديل الطلب من العمليات» in place of the payment and «دفعت للمطعم واستلمت الطلب»;
  a pickup request refused with `409 item_report_open` (`ItemReportOpen`) says the same.
  The order events of slice 2.9 (`order.item_reported`, `order.item_report_withdrawn`, `order.item_report_closed`, `order.time_changed`) carry a newer version, so the feed reads the active order again like any event;
  `alertStep` compares states only, so they add no chime.
  Slice 2.10a: while `editUnacknowledged` (operations added items and the restaurant has not acknowledged), `pickupBlocked` holds the pickup with «بانتظار تأكيد المطعم للتعديل» (also for `409 edit_unacknowledged`, `EditUnacknowledged`), and an edit before the pickup that changes the amounts or the lines chimes «تم تعديل الطلب — المبلغ الجديد للمطعم {المبلغ}، للتحصيل {المبلغ}» (`OrderEdited`);
  the item check shows the new lines.
  Slice 2.10b: after the pickup an edit that changes the lines chimes «حُذفت أصناف من الطلب — المبلغ الجديد للتحصيل {المبلغ}» (`ItemsRemovedAfterPickup`) and one that only lowers the amount to collect «المبلغ الجديد للتحصيل: {المبلغ}» (`CollectLowered`);
  the door payment then says «تغيّر المبلغ المطلوب إلى …» as before.

## The peak bonus (slice 2.16; CA §8.2, §9.8, §12.5, §14 #23, AP §9.12.5, D15)

- `peakBonusProvider` (`lib/src/peak_bonus.dart`) reads `GET /v1/captain/peak-bonus` while a screen watches it, and again when a running window ends and every `peakRefresh` (5 minutes).
  `PeakBonusLine` on home (offline or online, without an order) shows each running window as «مكافأة الذروة الآن: +{المبلغ} لكل طلب حتى {الساعة}» (with «في: {المناطق}» for a window limited to zones) and, while the bonus is on, «أوقات مكافأة الذروة», which opens `/peak-bonus` (`PeakWindowsScreen`: each window's days, Saturday first, its hours on the city's clock, «(تنتهي في اليوم التالي)» past midnight, its amount and zones), also opened from «ملفي» (2.36c).
  Nothing shows while the bonus is off or the read failed.
  The offer's `pay` already includes the bonus and `peakBonus` adds «يشمل مكافأة الذروة +{المبلغ}»;
  the summary shows «مكافأة الذروة: {المبلغ}» when `pay.peak` is above 0. The push of a window that starts (`target: peak_bonus`) opens home.
  Tests: `peak_bonus_test.dart`.

## «عهدتي» and the office (slice 2.17c; CA §10.2, §10.4, §7.5, C13, §14 #19)

- `custodyProvider` (`lib/src/custody.dart`) reads `GET /v1/captain/custody` while `/custody` (`CustodyScreen`, `custody_screen.dart`, the «عهدتي» tab) shows, and again whenever the work feed reads a state with another custody: every desk receipt sends `captain.availability_changed`, so the receipt shows at once (AP §9.10.3).
  The screen shows the sentence (`custodySentence`: «عليك تسليم {المبلغ}», «لك عند المكتب {المبلغ}» or none), each currency with its base equivalent, «من أيام سابقة» and «من اليوم», `CustodyLimitBar` («حد العهدة: {المستخدم} من {الحد}» over a bar, `limitShare`), the office (from the availability's `office`: the desk now, `officeNowText`, the hours per weekday from Saturday, `officeDayText`, and `OfficeMapButton`, which opens Google Maps like «ابدأ الملاحة»), the receipts (number, type, time, conversions, amounts, cashier) and the entries (`entryText`: the kind, the order or receipt number, the amount).
  Home shows `CustodyLimitBar` under the cash held.
  The hand-in reminder says «عليك تسليم {المبلغ}. المكتب مفتوح حتى {الساعة}.» or adds «المكتب مغلق الآن، يفتح {اليوم} {الساعة}.» (`handInText`), with the map button.
  A receipt's push (`target: custody`) opens `/custody`.
  Tests: `custody_test.dart`.

## The cash warning and hand-in lines (slice 2.17d; CA §10.3–10.4, §14 #15–#18)

- `CashLines` (`home_screen.dart`) sits on top of home, above the availability and above the active order: at `custody.warn` the amber banner «اقتربت من حد العهدة. سلّم النقد قريباً.» (amber is the spec's colour; otherwise unstyled), then, while `custody.remitBy` is set, «سلّم نقد أمس قبل {الساعة} لتستمر العروض», or, while `custody.handInGraceUntil` is set and cash from a closed day is above the tolerance, «مُنحت مهلة حتى {الساعة}» (`cashLines` in `work/texts.dart`).
  The state is read again on every `captain.availability_changed`, which the warning, the grace and every desk receipt send.
  The pushes of the warning, the 22:00 reminder and the cutoff (`target: custody`) open «عهدتي».
  Tests: `custody_test.dart`.

## The bottom navigation and «أرباحي» (slice 2.18b; CA §6.2, §10.6, §10.7)

- **The tabs (`lib/src/shell.dart`):** a `ShellRoute` puts `CaptainShell` around `/`, `/earnings`, `/custody` and `/more` (`captainTabs`): the `NavigationBar` «الرئيسية» · «أرباحي» · «عهدتي» · «المزيد», and `WorkLayer` around every tab inside a `SafeArea` (the banners sit below the status bar), so the offer rings and shows, the cards cover and the alerts come whichever tab is open;
  `HomeScreen` no longer holds it.
  While an order is active, the other tabs show the bar «الطلب الجاري», which returns home.
  Back on another tab goes home;
  on home it leaves the app.
  `MoreScreen` («المزيد») lists «أدائي», «السجل», «ملفي», «الإعدادات», «قواعد العمل», «الأسئلة الشائعة» and «الدعم» (pushed above the tabs).
  The home app bar has no links now.
- **«أرباحي» (`earnings.dart`, `earnings_screen.dart`):** `earningsProvider` reads `GET /v1/captain/earnings` while the tab shows, and again after every read of the work feed (each is a new `Work`): a delivery, and every desk receipt, the payout included, whose `captain.availability_changed` reads the state even when only the earnings moved.
  The screen shows «رصيدك المستحق: {المبلغ}», «موعد القبض: {اليوم} {التاريخ}» (`payoutText`, the server's date at noon on the city's clock), a negative balance explained by `captain.negative_earnings_policy` (`negativeText`), today and this week (earnings, orders, «ساعات الاتصال: {س} س {د} د»), this week's orders with their total and parts (`partTexts`, the summary's strings; an order the server gives no parts shows its total), and the other lines (`lineTexts`: «مكافأة», «خصم», «قسط تأمين العدة», «صرف المستحقات» or, above zero, «تحصيل رصيد سالب», «تصحيح», with the reason, «الطلب #{رقم}» or «إيصال {رقم}»), each line with its weekday, date and time (`momentText`: a cycle holds two Thursdays).
  Tests: `earnings_test.dart` (the offer over another tab and the bar too).
- **«كشف الأسبوع» (slice 2.18c; CA §10.7, §14 #20; `statements.dart`, `statements_screen.dart`):** «أرباحي» links «كشف الأسبوع» to `/earnings/statements` (`StatementsScreen`: `statementsProvider`, `GET /v1/captain/statements`, newest first, each «{التاريخ}: قبضت {المبلغ}», «… سدّدت {المبلغ} من رصيد سالب» or «… لم تقبض شيئاً، يُرحَّل {المبلغ}» with «عدد الطلبات»), and each opens `/earnings/statements/:statementId` (`StatementScreen`: `statementProvider`, read once, since a statement never changes).
  Both are sub-routes of `/earnings` on the root navigator (`parentNavigatorKey`), so they show above the tabs and back returns through the list to «أرباحي»;
  `CaptainShell` keeps a tab's index for its own sub-routes.
  The statement shows the captain, the period («من … إلى …», «حتى …» for the first), the orders and the desk's lines with the panel's labels (`statementLines`: carried in, pay by part, bonuses, charges, instalments, corrections, the balance, the paid amount in the payout's currency, with its base value when it is another, the collected and the carried; a `404` or `400` says «لم يُعثر على هذا الكشف.» with no retry), and «مشاركة كصورة»: the statement inside a `RepaintBoundary` (with its own background) rendered to a PNG at the screen's pixel ratio and handed to `imageSharerProvider` (`share_plus`, the phone's share sheet, so WhatsApp among the rest; a failure says «تعذّرت مشاركة الكشف.»).
  A plain layout until the design, the image included.
  The push «كشف الأسبوع جاهز: قبضت {المبلغ}» (`target: statement`, `statementId`) opens the statement.
  Tests: `statements_test.dart` (`TestApp.shared` records the shared images; the image renders inside `tester.runAsync`).
- Since the navigation bar lifts the snack bars, a test taps a button low on home with `tapVisible`.

## «السجل» (slice 2.40; CA §9.13, K8)

- `lib/src/history.dart` holds `historyProvider` (`HistoryNotifier`, auto-disposed: `GET /v1/captain/orders/history` when the screen opens and on each range, `show`; «عرض المزيد» reads the page after `next`), `daysOf` (the rows by business day in the server's order) and the texts (`endText`, `stepText`, `linesText`);
  `history_screen.dart` only shows them.
  «المزيد» (`more-history`) opens `/history`, above the tabs: «كل الطلبات» or «اختر فترة» (the date range picker, a year back on the server clock), then each day with its orders: the number, the time, «تم التسليم», «لم يُسلَّم», «أُلغي» or «سلّمته لكابتن آخر», the restaurant and «الحي» (never the customer, K8), «أجرك: …» or «بلا أجر».
  A tap opens a sheet with the outcome (`outcomeText`), the pay, «دفعت للمطعم», «قبضت من الزبون», «أعدت الباقي» and «خطواتك», each step with its date and time.
  Tests: `history_test.dart`.

## «الدعم» (slice 2.24c; CA §13, §9.11, §9.4 item 6, §14 #30; owner decisions 2026-11-17)

- **Layout:** `lib/src/support/`, as the restaurant app's: `support.dart` («بلاغاتي» `myReportsProvider`, `GET /v1/captain/reports`; `CaptainReports` with a key per body until the server answers, its refusals as `ReportOutcome`s), `report_photo.dart` (the restaurant app's photo picker and upload, `POST /v1/captain/uploads/report-photo`; tests override `photoPickerProvider` and `photoPutProvider`), `support_screen.dart`, `report_screen.dart` and `pickup_amount_sheet.dart`.
  `image_picker` and the iOS camera and photo-library strings came with it.
- **«الدعم»** (`/support`, from «المزيد»): «اتصال بالعمليات», «واتساب العمليات», «إبلاغ عن مشكلة» (`/support/report`: a type of Content's `captain_ticket_type`, which carries the requests «طلب تعديل بيانات», «إنهاء التعاقد», «تبديل العدة»; «عن الطلب الجاري #…» while an order is active; a note; a photo; «استلمنا بلاغك T-…. سنرد عليك خلال …»), «الأسئلة الشائعة» and «بلاغاتي» (each ticket's number and type, order, note, «من العمليات», status and «الرد: …»).
  «الرسائل» and the appeals come with their slices.
  The push of a resolution (`target: ticket`) opens `/support`.
- **«مشكلة» with a quick reason:** `ProblemBar`'s sheet adds «إبلاغ العمليات بسبب سريع» for the order's own captain (not the receiving captain of a handover): a reason of Content's `captain_problem` through `pickReason`, posted to `POST /v1/captain/orders/{orderId}/problem`.
  «مشكلة في مبلغ الاستلام» is offered only after the pickup by the captain who paid and before any dispute (`offersPickupAmount`: `pickup.pickedUpAt`, the confirmed request, neither `pickup.disputedAt` nor the captain's own `pickup.reportedAt`);
  it asks the lines the captain handed over, one field per currency prefilled with those recorded (`askPickupAmount`), and a note, sent as `paidLines`.
  The server's `order_state_changed`, `pickup_already_disputed` and `no_difference` have their sentences.
  Tests: `support_test.dart`.

## Push (slice 2.3c; CA §14, CA §4.4–4.5; `packages/core_push/CLAUDE.md`)

- `lib/src/push.dart`: `pushTokensProvider` keeps the installation's token registered while signed in (`PUT /v1/captain/push-token`) and `pushTapsProvider` opens a tapped push's target, both watched by `CaptainApp`.
  `pushTargetPath` maps an offer's or an order's push to home, which shows the open offer or the active order, a receipt's to «عهدتي» and a statement's to the statement;
  the other targets come with their slices.
- **The permission (owner decision 2026-11-08):** `Commands.goOnline` asks for it first (`askNotifications`) while the phone does not allow it, on Android and iOS (slice 2.46, with Critical Alerts below);
  the answer never blocks going online (CA §4.5: the check only warns).
  It stands for check 1 of the device check until that exists, and lets the location service's notification show.
- **Channels:** `MainActivity` creates `ring_offer` (the bundled offer sound on the alarm stream, slice 2.43; the earlier `offer` is deleted, since a channel keeps its first sound), `chime` (the notification sound once), `cancellation` (the notification sound until the bundled cancellation sound) and `silent` (low importance, no sound);
  their names are in `res/values/strings.xml`.
  A push of an unknown channel shows on `chime`.
- **The offer's push (CA §4.4; slice 2.43):** `main.dart`'s `ringOffer`, core_push's background handler, rings an offer's push (`target: offer`, its `expiresAt` in the data, `offerRingTime`) from the push's isolate through `AndroidAlerts` until the offer's end on the phone's clock, with the push's text, so an offer rings over the lock screen while the app is in the background or closed;
  tapping the prompt opens the app.
  A push that arrives after the offer was answered on this phone rings until the app's next stop (5 seconds) while the app runs, and until its end when it does not.
- **Tests:** `TestApp` gives `FakePush` (`push`) and `FakeNotificationPermission` (`permission`, allowing unless a test says otherwise);
  `push_test.dart` proves the token, the permission at «متصل», the taps and the offer push's ring time.

## Terms (slice 2.4b; AP §9.13, CA §4.8, §7.2, K7)

- `termsCheckProvider` (`lib/src/terms.dart`) follows `.claude/rules/flutter-apps.md` «Terms».
  A pending version shows «وافق على الشروط الجديدة لتتمكن من الاتصال» on home while offline, with a link to `/terms`;
  «متصل» refused with `terms_not_accepted` («The terms screen», CA §7.2) reads the terms again and opens `/terms`, beside the other blocks' message.
  A version published while the captain is online or on an order blocks nothing until the next time they go online.
  The application form's step 4 (slice 2.34a) accepts the same terms on `/terms`.

## Emergency stop (slice 2.4d; CA §6.3, §14 #31, §15)

- `emergencyStopProvider` (`lib/src/platform.dart`) is an `EmergencyStopCheck` (`packages/core_platform/CLAUDE.md`) on `GET /v1/captain/emergency-stop` while signed in;
  `platformBroadcastsProvider` follows `captain:{captain_id}` for it and for `platform.app_changed`, and reads both again whenever the channel connects.
  `WorkLayer` shows `EmergencyStopBanner` right after the offline bar (CA §6.3 item 2).
  Each start or end seen while the app runs chimes once (`ringerProvider`).
  A current order goes on;
  the server sends no offers meanwhile.

## «فحص الجهاز» (slice 2.43; CA §4.5, §6.3 item 4, §15, AP §9.7.4)

- **Layout:** `lib/src/device_check/`: `device_check.dart` holds the items (`CheckItem`, the server's codes), the pure rules (`failedReadings`, `failedItems`), the phone's readings (`phoneReadingsProvider`: `core_alerts`' readings and `PhoneAccessReader`'s location always and precise and call permission, read again on resume, at «متصل» and at each start; an iPhone's too since slice 2.46; null elsewhere), `thisDeviceCheckProvider` (`GET`/`PUT /v1/captain/device/check`: this phone's last check, null before its first) and `deviceCheckBannerProvider`;
  `device_check_screen.dart` shows and runs it (unstyled; the brands' screenshots come with the design).
- **The checks (Android):** 1 notifications;
  2 the location «دائماً» and precise (`openLocationSettings`: the app's settings, where Android asks for the background location);
  3 battery optimisation off and, on a brand with its own page, the auto-start the captain confirms («فعّلته», again on each run; the banner counts it as the last check found it);
  4 full screen (always below Android 14);
  5 the alarm volume at 70% or more (`alarm_volume`) and Do Not Disturb silencing alarms (`do_not_disturb`, read, not confirmed);
  6 the test offer, the offer sound with vibration over the lock screen for 30 seconds (`testOfferRings`) and «سمعت الصوت» or «لم أسمع»;
  7 one timed request (`GET /v1/captain/auth/current`) and one fresh position, failing (`connection`, `gps_accuracy`) without an answer or worse than 100 metres (K3);
  8 the call permission of «طوارئ».
  «حفظ نتيجة الفحص» sends the failed codes;
  the panel shows the last check in «التطبيق».
- **When:** the first «متصل» on a phone with no check of its own opens the check, then goes online once it closes, saved or not (`deviceCheckNeeded`; the device store's `captain.device_check_opened`, written when it opens, so it opens once; a failed read asks nothing), and «الإعدادات» opens it any time.
  The yellow banner «هاتفك قد لا يرن عند وصول عرض — أكمل فحص الجهاز» (after the emergency stop's) shows once this phone has a check while a check the app reads fails, or while the last test offer was not heard;
  it opens the check.
  A failed check never blocks going online.
- **Tests:** `device_check_test.dart`; `TestApp` gives `FakeAlerts` (`alerts`, no readings unless a test gives them, so no check) and `FakePhoneAccess` (`access`).

## iOS (slice 2.46; architecture §14, CA §4.3–4.5, K15; owner decisions 2026-11-20)

- **The project:** the customer app's flavors and entitlements (`.claude/rules/flutter-apps.md`), all its plugins through Swift Package Manager (no Podfile).
  Info.plist asks for the location «دائماً» (`NSLocationAlwaysAndWhenInUseUsageDescription`), declares the background modes `location`, `fetch` and `remote-notification`, the library's `com.transistorsoft.fetch` task and its licence `TSLocationManagerLicense` from the build setting `FOXDROP_BGGEO_LICENSE` (the CI secret, as on Android; empty otherwise).
  The bundled sounds are resources of the Runner target straight from `packages/core_alerts` (`fd_offer`, `fd_chime`, `fd_cancellation` and the offer's 29-second `fd_offer_30s`, since a notification plays its sound once).
- **Offers (CA §4.4, K15):** in the foreground `core_alerts`' iOS layer loops the offer sound and vibrates;
  when the app leaves the foreground while it rings, or a ring starts in the background, one local notification takes over, time-sensitive with `fd_offer_30s.wav`, critical once the captain allowed Critical Alerts.
  A closed or suspended app gets the offer's push, which the server makes time-sensitive with the same sound (critical with `APNS_CRITICAL_ALERTS`);
  `ringOffer` is Android's only.
  The notification ask at «متصل» runs on iOS too, and every «متصل» asks for Critical Alerts while not granted (`criticalAlertsAskProvider`, whatever notifications answered, since Apple grants the entitlement after captains allowed them), which iOS shows once and only to a build carrying the entitlement (the `deploy` skill, «The staging iOS builds», step 8).
  When a ring that played ends, the layer removes the offer pushes left in the Notification Centre, and it posts no notification of its own for an offer whose push already shows.
- **The device check's iPhone column:** 1 notifications and time-sensitive ones (`notifications`);
  2 the location «دائماً» and precise: geolocator asks for «أثناء الاستخدام» only, so `askLocationAlways` (permission_handler's `locationAlways`) asks once to change it to «دائماً», at going online (`ensureAccess`) and from the check, which then opens the settings;
  3 Background App Refresh (`background_refresh`) and Low Power Mode (`low_power_mode`);
  5 the ring switch and a Focus, which the captain confirms with «فعّلته» (`ring_switch`, again on each run; the banner counts it as the last check found it);
  6 and 7 as on Android;
  no 4 or 8 (iOS asks to confirm each call). iOS opens only the app's page of its settings (its notifications page from iOS 16).
- **Location (CA §4.3):** the library on iOS never pauses (`pausesLocationUpdatesAutomatically` false) and shows the blue indicator;
  iOS has no interval and gives a point about every second, so `LocationThinner` keeps one every 10 seconds and, with `PersistMode.none` on iOS, only those are kept (`insertLocation`) for sending.
  Without the licence a release build tracks through `geolocator`'s `AppleSettings` background updates, thinned the same way.
  `isSimulatedBySoftware` comes as each path's mock flag;
  the inserted points carry it in their extras too (`simulated`), read back with the library's `mock`.
  The library's own English alert about «دائماً» is off (`disableLocationAuthorizationAlert`): the device check says it.
- **Not yet:** proved on a real iPhone (the owner, through TestFlight); Google Maps or Apple Maps as the captain prefers for «ابدأ الملاحة» (CA §4.6); the device check's screenshots (the design).

## Calls and the waiting pay (slice L.1b; CA §9.3, §9.5, §19 items 10 and 13)

- The order never carries the customer's phone. «اتصال بالزبون» and «واتساب» reveal it through `Commands.revealCustomerPhone` (`captainOrderContactsContactCustomer` with the channel), which records the tap and is refused outside the order; then `tel:` or `https://wa.me/<digits>`. A refusal opens nothing and shows the notice; a reveal is never retried.
- At the restaurant, «بدأ احتساب أجر الانتظار» shows once the server clock passes the order's `waitingPayFrom` (`_AtRestaurant` in `order_view.dart`, on the step's tick).
- Tests: `customer_contact_test.dart`.

## Not yet (slice 1.14g)

- The suggestion of «وصلت» when entering the customer's radius (CA §9.6).
- «الرسائل» (CA §13).
  The screens pushed above the tabs («الإعدادات», «قواعد العمل», «الأسئلة الشائعة», `/profile`, `/peak-bonus`, `/terms`, the statements `/earnings/statements…`) show neither the bar «الطلب الجاري» nor an offer, which still rings under them.
- The `cancellation` and `chime` push channels still play the phone's notification sound (renaming them for the bundled sounds needs the server's channels too).
  The library's points recorded while the app was closed by a server that took the captain offline are refused (`409`) and dropped.
- A batch the server refuses with a `400` (a point past its clock skew) is dropped whole; dropping only the bad points needs the refusal to name them.
- A location permission revoked while online (the tracker then gets no points; the device check's banner shows it at the next read).

## «أدائي» (slice 2.36b; CA §11, §14 #25)

- **Layout:** `lib/src/performance/`.
  `performance.dart` holds `performanceProvider` (`GET /v1/captain/performance`, read while «أدائي» or home's warning shows, again on the violation's push, `target: performance`), `hoursOf`, `appealStateOf` and the texts (`stepText`, `responseText`, `appealText`);
  `performance_screen.dart` only shows it (the design stop).
- **«أدائي»** (`/performance`, from «المزيد», `more-performance`): «نسبة القبول: {النسبة}%» with the offers counted, the spec's warning below `captain.acceptance_alert_pct` (the server's `warn`), the last offers counted (time, restaurant, response), on time, the cancellations within `captain.violation_window_days`, online hours today and this week, the rating (`RatingSummary`, below), each violation (date, type, step, order, the suspension's end, the appeal's state), and «قواعد العمل» (CA §11.4).
  A violation without an appeal shows «اعتراض» (`appeal-<id>`), which opens `/performance/appeal/:violationId` (`appeal_screen.dart`: the text, required, and an optional photo through the reports' picker and upload; `CaptainReports.appeal`, a key per body, `POST /v1/captain/violations/{id}/appeal`; «استلمنا اعتراضك T-{رقم}. تابعه في «الدعم».», `already_appealed` says «سبق أن اعترضت…»; «أدائي» is read again);
  the ticket then shows in «بلاغاتي» with its status and decision.
  `ProfileNotices` on home shows the same warning (`home-acceptance-warning`), which opens «أدائي».
  `TestApp` answers a performance with no warning unless a test says otherwise (`performanceJson`).
  Tests: `performance_test.dart`.

## «ملفي» (slice 2.36c; CA §12, Appendix B; owner decisions 2026-11-19)

- **Layout:** `lib/src/profile/my_profile.dart` holds `captainProfileProvider` (`GET /v1/captain/profile`), `payTableProvider` (`GET /v1/captain/pay-table`), `payCalculatorProvider` (`GET /v1/captain/pay-table/calculate`: the server prices the sample, the app never computes pay) and the pure rules of what is typed (`metresOf`: km with up to three decimals, 0 to 100; `waitedOf`: whole minutes up to a day, none being 0; both read an Arabic keyboard's digits and «٫»);
  `my_profile_screen.dart` only shows it (the design stop).
- **«ملفي»** (`/profile`, from «المزيد», `more-profile`, which replaced the links to the documents and the contract): «بياناتي» read-only («رقم الهوية في FOX DROP: C-…», the name, the phone under «الهاتف», the number alone left to right, the neighbourhood, the vehicle, the plate), «لتعديل الهاتف أو المركبة أو الحي اطلب ذلك عبر «الدعم».» and «طلب تعديل» (`/support/report?type=data_change`: `ReportScreen`'s `type` chooses «طلب تعديل بيانات»; a type Content does not list is never sent), the links to «المستندات», «العقد والعدة» and «أوقات مكافأة الذروة», and «جدول الأجور» for the captain's vehicle: the base and the distance it includes, exact to the metre (`includedText`), per extra km, the waiting rate past `captain.waiting_threshold_min`, the minimum, then each announced table under «الجدول الجديد من {التاريخ} {الساعة}» (a later table starts to the minute, 7 days after it is published);
  with a table, «احسب أجري» (the distance, the optional minutes waited, «احسب») shows the parts in the summary's strings and «المجموع» by the table in force and by each announced one.
  «أرباحي» links «احسب أجري» to «ملفي» (Appendix B).
  All words but «ملفي» and «احسب أجري» are ours, to confirm with the owner.
  `TestApp` answers a profile and no pay table unless a test says otherwise (`profileJson`, `payTableJson`, `payRateJson`).
  Tests: `my_profile_test.dart`.

## «تقييمي» (slice 2.26c; CA §11.2, C14, CU Q16; owner decisions 2026-11-18)

- `lib/src/rating.dart`, inside «أدائي» since 2.36b (`RatingSummary`; the `/rating` route is gone): `GET /v1/captain/ratings`, read each time the screen opens, shows the average over every rating («{المتوسط} من 5», `formatAverage` of `core_l10n`, or «لا تقييم بعد»), «عدد التقييمات: {العدد}» and the reasons customers picked with their counts, most picked first;
  never a customer's name nor a comment, which the server never sends.
  `test/rating_test.dart`.
