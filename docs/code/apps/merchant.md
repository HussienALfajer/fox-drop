# apps/merchant

> Moved here from `apps/merchant/CLAUDE.md` on 2026-11-20. In these notes, a folder's `CLAUDE.md` (or "its `CLAUDE.md`") means that folder's file under `docs/code/` when there is one, otherwise the folder's own `CLAUDE.md`; the folder's own `CLAUDE.md` now holds only the rules for working there.

The restaurant app «تطبيق المطعم» (Android, Windows; architecture §11, §12). It follows the rules of `.claude/rules/flutter-apps.md`.

**2026-11-27:** the owner deleted the sign-in screen (core_auth's `sign_in_screen.dart`, the `/sign-in` route) and the staff screen (`settings/staff_screen.dart`, the `/settings/staff` route, the `open-staff` row and their UI tests). Signed out, every route waits on `/starting` until a new sign-in screen is built. `staff.dart` (`staffProvider`, `devicesProvider`) stays; the shared `confirm`, `Failure`, `lastActiveText` and `platformText` moved to `settings/settings_parts.dart`. History: git.

## The board (slice 1.14e; RA §4.3–4.7, §8.1–8.11)

- **Layout:** `lib/src/board/`.
  `board.dart` holds the rules as pure functions (columns, sorting, lateness, the captain line, what rings) and the feed;
  `commands.dart` the commands;
  `alerts.dart` the ring and the chimes;
  `texts.dart` every string mapping;
  the `*_screen.dart`, `prompts.dart` and `dispute_sheet.dart` files only show that state and call it (the design stop).
- **State:** `boardFeedProvider` is a `LiveFeed` (`packages/core_realtime/CLAUDE.md`) of `GET /v1/merchant/orders` over `merchant:{restaurant_id}`;
  the screens read `boardProvider` and never patch it.
  The order detail (`/orders/:id`) reads the same board, so it never shows another version of an order.
- **Time:** every countdown and «منذ» runs on `serverClockProvider` (`packages/core_time/CLAUDE.md`), through `tickProvider` once a second; never `DateTime.now()`.
- **Commands** (`BoardCommands`, RA §4.7): one at a time per order, shown as «جارٍ الإرسال…»;
  the `Idempotency-Key` belongs to the command and its body, and a call without an answer (no response, a 5xx, a 408 or a 429) is sent again with the same key after a backoff with jitter until the server answers.
  Any answer refreshes the board.
  A `409 order_state_changed` is explained from the order it carries (`commandText`).
  Since slice 2.42 every command waits in the device's queue (`commandQueueProvider`, `packages/core_commands`) with its key and its arguments (`_call` builds the request from them) until the server answers, and the queue's commands of the account signed in are sent again when the app starts (another account's are dropped), so a restart never loses an accepted order.
- **Ring and chimes** (RA §4.4; owner decisions 2026-11-07): what rings is derived from the board, never from an event: every `placed` order, every open pickup request and every operations' cancellation after acceptance not yet acknowledged, oldest first, one sound for all, the prompts stacked.
  So the ring stops on every device once any device (or the server) handles it.
  `alertStep` is the pure rule for the chimes and their notices (automatic cancellation from the event's reason, the prep late at its time and every 5 minutes, the captain's arrival and waiting, a prompt closed by another device, 30 seconds offline).
  `AlertsRinger` rings through `core_alerts` (slice 2.42): the bundled sound of the oldest ringing item (`ringSound`: a new order, a pickup request, a cancellation or an edit) looping on the alarm stream, with its prompt's text over the lock screen (`ringText`);
  an owner's device with «الرنين على هذا الجهاز» off (`ringsHereProvider`) shows the prompts without ringing;
  on Windows the ring loops on the default output device, brings the window to the front and shows a toast (slice 2.44).
  Events wait for the board fetched after them, so a cancellation's chime plays after its prompt closed;
  a ringing item past its deadline (`autoCancelAt`, `confirmBy`) fetches the board again, so a lost event never leaves a ring on.
  `BoardAlertsLayer` puts the banners and the prompts over the board and the detail alike (the offline bar is over every screen, `OfflineFrame`);
  Back does not leave the app while something rings.
  `MerchantApp` watches `boardAlertsProvider`, so the ring and the chimes run whatever screen shows, and with none: the receiving service (`receivingProvider`, `core_alerts`) keeps the app's engine running with the screen off, after a reboot and after an update, while a user is signed in;
  the screen stays on while the board shows (`wakelock_plus`).
- **Tests:** `board_test.dart` proves the pure rules;
  `board_screen_test.dart` drives the screens with `FakeServer`, `FakeTransport` and `FakeRinger` (`test/board_fixtures.dart`, the board's JSON as the server sends it).
  Widget tests end with `done(tester)`, which disposes the container inside the test so the board's timers stop before Flutter checks for pending timers.

## Reject and operations' decisions (slice 2.7a; RA §8.6, §8.15, §16 #5–6)

- **«رفض»** on the new-order prompt opens `showRejectSheet` (`reject_sheet.dart`): the three reasons of R3 (`RejectReason`), offered while active in Content with Content's labels (`rejectionReasonsProvider` in `lib/src/content.dart`, `GET /v1/merchant/content` through `merchantContentProvider`, which a failed read invalidates), else the built-in labels of `rejectReasonText`;
  «صنف غير متوفر» picks the order's items (`lines[].itemId`), each «حتى الغد» (the default) or «حتى أعيده»;
  «المطعم مغلق» shows its note;
  «ضغط طلبات» offers «الرفض فقط», busy mode with each of the status's `busyExtraOptionsMin`, or «إيقاف 30 د».
  «تأكيد الرفض» stays off until the choice is complete (`Rejection.complete`).
  `BoardCommands.reject` sends it like any command;
  its key belongs to `Rejection.body`.
  `400 unknown_reason`/`invalid_rejection` is `RejectRefused`, a `409` on a rejected order `RejectedFirst`, on one operations accepted `AcceptedByOperationsFirst`.
- **Operations' decisions:** every order event carries `byOperations`.
  `alertStep` chimes «رفضت العمليات الطلب #{رقم}: {السبب}» (`RejectedByOperations`, the event's reason code) and «قبلت العمليات الطلب #{رقم} نيابة عنكم — وقت التحضير {د} د» (`AcceptedByOperations`, the prep time from the board fetched after the event);
  the restaurant's own decision on another device only closes the prompt.
  The card and the detail show «قبلته العمليات» while `acceptance.byOperations`.
- History lists rejected orders since slice 2.40, and «التقارير» counts them by reason and party since slice 2.41.

## Operations' cancellation (slice 2.8b; RA §8.14, §18)

- An order operations cancelled after acceptance stays on the board with `cancellation` (`at`, the reason's code and label, `byOperations`) until «حسناً» on any device;
  the server lists it for 24 hours at most and never gives the note, the responsible party or the money.
  `ringing` turns it into `CancelledRinging`, so it rings with the others and stops on every device once the board drops it;
  `CancelledPrompt` shows «أوقف التحضير — أُلغي الطلب #{رقم}: {السبب}» (the label) and «حسناً», which sends `BoardCommands.acknowledgeCancellation` (`POST /v1/merchant/orders/{orderId}/acknowledge-cancellation`, with a key; a `409` says nothing, since the board fetched after it drops the order).
  It has no deadline: only «حسناً» ends it.
- `alertStep`: an `order.cancelled` with `byOperations` whose order rings on the fetched board adds no «أُلغي الطلب #{رقم}» notice (the prompt says it);
  a placed order operations cancelled keeps that chime.
  The pickup request the cancellation voids closes without `PickupClosed`.
  A cancelled order never chimes «وصل الكابتن» or «الكابتن ينتظر الطلب…», even when a board carries its `captainArrival` (the server sends it only for an accepted or ready order).
  `order.cancellation_acknowledged` only refreshes the board.

## The item-unavailable report and operations' time change (slice 2.9; RA §8.7, §8.10, §8.12, §16 #12, #37)

- **«صنف غير متوفر — اتصلوا بالزبون»** is on the detail while `canReportItems` (an accepted or ready order, no pickup request open, no report open).
  It opens `showItemReportSheet` (`item_report_sheet.dart`), which shares the reject sheet's item picker (`UnavailableItemsPicker`, `items_picker.dart`: each item «حتى الغد» by default or «حتى أعيده») and adds the optional note from Content's `item_unavailable_note` list (`itemReportNotesProvider` in `lib/src/content.dart`, which shares one read of `GET /v1/merchant/content` with `rejectionReasonsProvider` through `merchantContentProvider`), sending its code;
  when the list could not be read, the built-in labels of its seeded codes (`itemReportNoteLabels`: `similar_alternative` «يوجد بديل مشابه», `insufficient_quantity` «الكمية غير كافية»), and the failed read is read again on the next report.
  The detail shows the note's `label` as the server kept it.
  «إرسال البلاغ» stays off until an item is picked (`ItemReport.complete`);
  `BoardCommands.reportItems` sends `POST /v1/merchant/orders/{orderId}/item-report` with a key bound to `ItemReport.body`.
- While the board's `itemReport` is set, the card and the detail show «صنف نفد — بانتظار العمليات» and «العمليات تتواصل مع الزبون» (the detail also names the items), and the detail offers «تراجع — الصنف متوفر» (`canWithdrawItemReport`, `BoardCommands.withdrawItemReport`, `POST .../item-report/withdraw`).
  Refusals: `400 invalid_item_report` is `ItemReportRefused`, and so is `400 unknown_reason` (a note removed from Content), which also reads Content again;
  a report's `409` with the pickup request open is `ReportWhilePickupOpen`, with another device's report open `ItemReportOpenFirst`;
  a withdrawal's `409` without a report is `ItemReportClosedFirst`.
- **Chimes (`alertStep`):** `order.time_changed` with `prep_time_changed` chimes «عدّلت العمليات وقت تحضير #{رقم} إلى {د} د» (`PrepTimeChanged`, the prep time from the board fetched after the event) and starts the late-prep chime again from the new prep time;
  `promised_time_changed` says nothing to the restaurant.
  `order.item_report_closed` chimes «أغلقت العمليات بلاغ الصنف في الطلب #{رقم}: {السبب}» (`ItemReportClosed`, operations' text from the event).
  `order.item_reported` and `order.item_report_withdrawn` only refresh the board.

## Edits by operations (slice 2.10a; RA §8.13, §8.10, §16 #16–17)

- The board's `edits` are operations' edits not yet acknowledged, oldest first, each with its changes («أُضيف: …», «حُذف: …», «{الصنف}: {قبل} ← {بعد}», `editChangeText`), the new items value and the extra minutes of a ready order sent back to preparing.
  `editRings` (one added items) makes `ringing` give `EditRinging`, before the new-order prompt of a placed order, so it rings until acknowledged with `EditPrompt` («تم تعديل الطلب #{رقم} — أُضيفت أصناف»);
  an edit that added nothing chimes «تم تعديل الطلب #{رقم}» on its `order.edited` (reason `changed`, `OrderEdited`) and stays on the card and the detail with the same prompt.
  «اطلعت على التعديل» sends `BoardCommands.acknowledgeEdit` (`POST /v1/merchant/orders/{orderId}/acknowledge-edit` with `through`, the newest edit's `at` the prompt showed, so an edit that arrived since keeps ringing; a `409` says nothing, since the board fetched after it shows what is left).
  It has no deadline.

## Push (slice 2.3c; RA §16, RA §4.4–4.5; `packages/core_push/CLAUDE.md`)

- `lib/src/push.dart`: `pushTokensProvider` keeps the installation's token registered while signed in (`PUT /v1/merchant/push-token`), `notificationAskProvider` asks for the permission, and `pushTapsProvider` opens a tapped push's target, all watched by `MerchantApp`.
  `pushTargetPath` maps an order's push to `/orders/:id` a statement's or receipt's to its screen under «الحساب» (slice 2.19e) and the overdue reminder to «الحساب» (2.19f);
  a ticket's opens `/support` (slice 2.24b);
  the menu's comes with its slice.
  A tapped target waits for the session's details (signed in, the device named), so the push that started the app is not lost to the router's start.
  `main` gives `startPush()`, which is `NoPush` on Windows.
- **The permission (owner decision 2026-11-08):** asked once per installation on Android, at the first sign-in (`notifications_asked` in the device store), with the system's dialog;
  a phone that already allows notifications is not asked.
  The device check (slice 2.42) reads it again as its check 1.
- **Channels:** `MainActivity` creates `ring_order` (the bundled new-order sound on the alarm stream, slice 2.42), `chime` (the notification sound once) and `silent` (low importance, no sound);
  their names are in `res/values/strings.xml`.
  A push of an unknown channel shows on `chime`.
- **Tests:** `app_test.dart` gives `FakePush`, `FakeNotificationPermission` and `MemoryDeviceStore`;
  every test container must override `notificationPermissionProvider` and `deviceStoreProvider`, since the real ones call the platform.
- **Since slice 2.42:** `ring` became `ring_order`, with the bundled new-order sound (the old channel is deleted: a channel keeps its first sound), and an owner's device with ringing off gets ring pushes on `silent` (the server's `channelOf`);
  a push that arrives while the system ended the app starts the receiving service again from FCM's background isolate (`wakeReceiving` in `main.dart`, `AndroidAlerts.wake`), so the board rings;
  `target: devices` (RA §16 #27) opens «الأجهزة».
- **Not yet:** the owner-only rows (RA §16 #19, #21, #22, #33) with their events.
  A tapped push of an order that left the board (cancelled, rejected) opens a detail with nothing to show until history (RA §8.18).

## Receiving (slice 2.42; RA §4.3–4.7, §14.2–14.3; owner decisions 2026-11-20)

- `lib/src/receiving/`: `receiving.dart` holds `thisDeviceProvider` (`PUT /v1/merchant/device` with the app's version at every start once the device is named, answering the ring setting and the last check; `setRinging`, an owner's; `recordCheck`), `ringsHereProvider` (true until the server says off, so a failed read never silences a device), `receivingProvider` (the service while signed in, stopped at sign-out; watched by `MerchantApp`), and the device check's pure rules (`CheckItem`, `failedReadings`, `failedItems`, the 70% alarm volume) with `deviceReadingsProvider` (read again on every resume) and `deviceCheckBannerProvider`;
  `prompts.dart` holds `deviceCheckPromptProvider` (the check over the board at the first sign-in of each installation, `device_check_done` in the device store) and `OfflineFrame`.
- **«هذا الجهاز»** (`/device`, every user; a cashier's `open-this-device` floating button, an owner's first row of «الإعدادات»): «الرنين على هذا الجهاز» for an owner, «جهاز الكاشير يرن دائماً.» for a cashier, and «فحص الجهاز» with the last result.
  The terms' wait leaves `/device` open (`ownerScreenWaits`).
- **«فحص الجهاز»** (`/device/check`, RA §4.5): each check with what to do and «فتح الإعدادات» (`DeviceSetting`), read again on coming back;
  the brand's auto-start confirmed with «فعّلته» (`autostart_confirmed`), since no app can read it;
  «تشغيل رنين تجريبي» then «سمعت الصوت» or «لم أسمع»;
  the connection's delay from one timed request;
  «حفظ نتيجة الفحص» sends the failed items and the delay (`PUT /v1/merchant/device/check`), which the panel shows and the activation needs.
  On Windows (slice 2.44) it shows the PC's checks: Windows' notifications, «التشغيل مع ويندوز» (turned on by its button), the output not muted, and the sleep on mains power (check 6, `sleep`, a warning the server never fails).
  The yellow banner «هذا الجهاز قد لا يرن عند وصول طلب — أكمل فحص الجهاز» sits in `BoardAlertsLayer` while a check of 1–6 fails.
- **«الأجهزة»** shows each device's ringing, connection and last check, and «لا يوجد جهاز يستقبل الطلبات في مطعمك الآن» while the server's `withoutDevice` (RA §14.2).
- **The test ring** goes through `Ringer.test`, the board's own ring, so ending it never silences a real order: the board's next step rings again what still rings.
  A failed version report is sent again when the channel comes back.
  A queued command whose account is no longer signed in is dropped, never sent in another's name.
- **The offline bar** (RA §4.7) is `OfflineFrame`, over every screen from `MaterialApp.builder`; the 30-second chime is `alertStep`'s.
- **Tests:** every test container overrides `alertsProvider` with a `FakeAlerts` (`package:core_alerts/testing.dart`), since the real one calls the platform;
  `board_screen_test.dart` drives the ring's sound and text, the ring setting, the device check and a command a restart interrupted.
- **Not yet:** the brands' screenshots (the design). The 8-hour lock is proved on a real phone (the owner).

## Windows (slice 2.44; RA §4.2–4.5, architecture §8.3.3 item 1, §12.3; owner decisions 2026-11-20)

- `lib/src/windows/`: `registration.dart` (`WindowsRegistration`: the PC's Ed25519 key in the secure store under `windows.signing_key`, registered once with an owner's pairing code by `POST /v1/merchant/auth/windows-registration`, and `sign`, which `MerchantAuth.deviceSignature` calls before each code request: `codeRequestMessage`, the installation, the number and the moment on the server's clock, which the sign-in client now learns too), `pairing_screen.dart` («ربط هذا الكمبيوتر», `/windows-pairing`: a PC signs in unpaired while the server does not require App Check; a code request refused with `app_check_failed` (never paired, or a key the server no longer knows) drops the key (`MerchantAuth.onAttestationRefused`) and `pairingNeededProvider` sends sign-in there until paired; a key that cannot be read counts as none, so nothing waits on it), `shell.dart` (`setUpWindows`: the tray's texts and the quit question over the current screen) and `update.dart` (the self-update).
- `windows/runner/main.cpp`: one copy per installation (a mutex named by the executable's path; a second start shows the running window, since two copies would use one session's refresh token up), and Velopack's `--veloapp-*` hooks exit at once, the uninstall removing «Start with Windows».
- `main` makes a `WindowsAlerts` on Windows, overrides `alertsProvider` with it in its `ProviderContainer` and sets it up before the first screen.
  The first sign-in of an installation turns «Start with Windows» on (`windows_startup_set` in the device store, RA §4.3 «on by default»);
  the device check covers it after.
- **Owners' pairing code:** «الأجهزة»'s «ربط كمبيوتر بويندوز» (`pair-windows`) shows the 8-digit code (`POST /v1/merchant/devices/windows-pairing`), valid 10 minutes, once.
- **Self-update (RA §4.2):** `windowsUpdateProvider` (watched by `MerchantApp`) runs only on a Velopack install (`current/sq.version` and `Update.exe` beside it) built with `WINDOWS_UPDATE_FEED` and `WINDOWS_FEED_PUBLIC_KEY`: it reads `releases.win.json` at the start and every hour, trusts it only with that key's Ed25519 signature (`releases.win.json.sig`, `feedSigned`; signed by CI with a key the deploy key never holds), downloads a newer full package (`newestFull`, SemVer 2 order with `AppVersion`) into Velopack's `packages` folder checked against its SHA-256, and restarts through `Update.exe apply --waitPid` once `mayRestartForUpdate`: signed out, or a board read with no order and nothing ringing.
  `UPDATE_URL` is the installer for the blocking update screen.
- **Tests:** `windows_registration_test.dart`, `windows_check_test.dart`, `windows_update_test.dart`; the tray, the window and the Win32 calls are proved on a real PC (the owner).
- **Not yet:** code signing (Azure Trusted Signing, owner decision 2026-11-20: bought later; SmartScreen warns until then);
  a registration bound to its restaurant at sign-in;
  removing a PC's registration when an owner signs it out;
  the portal's pairing code (2.45);
  Windows' own builds per environment (Flutter has no Windows flavors: staging's values come from `--dart-define`).

## Terms (slice 2.4b; AP §9.13, RA §4.10, §5.2 item 3, S13)

- `termsCheckProvider` (`lib/src/terms.dart`) follows `.claude/rules/flutter-apps.md` «Terms»;
  the server answers `pending: false` to a cashier, so a cashier's device is never affected.
  An owner with a pending version gets `/terms` pushed over the board once per version, on the next open or resume, after the device is named (`termsPromptProvider`, watched by `MerchantApp`), may go back to Orders, and sees «وافق على الشروط الجديدة لتستخدم شاشات المطعم الأخرى. الطلبات تصل كالمعتاد.» on the board;
  the router sends every other screen to `/terms` while pending (`ownerScreenWaits`: only `/`, `/orders/:id` and `/terms` stay), so each owner screen added later is covered.
  The board keeps ringing meanwhile.
  Not yet: the owner web portal's accept screen (RA §4.10 «in the app or the portal», with the portal's sign-in) and the server refusing owner-only routes while pending (none exists besides naming the device, which comes first).

## Emergency stop (slice 2.4d; RA §8.17, §16 #34, §18)

- `emergencyStopProvider` (`lib/src/platform.dart`) is an `EmergencyStopCheck` (`packages/core_platform/CLAUDE.md`) on `GET /v1/merchant/emergency-stop` while signed in;
  `platformBroadcastsProvider` follows `merchant:{restaurant_id}` for it and for `platform.app_changed`, and reads both again whenever the channel connects.
  `BoardAlertsLayer` shows `EmergencyStopBanner` right after the offline bar on the board and the detail (RA §6.3 item 2), and the other signed-in screens (the terms, naming the device) get it above them from their route (`WithStopBanner`), so it is on every screen (RA §8.17);
  signed out there is no stop to show.
  Each start or end seen while the app runs chimes once on every device (`ringerProvider`).
  Active orders and the restaurant's own state are untouched.

## Status and hours (slice 2.6a; RA §6.2–6.3, §7, §10, §16 #3, #24, #25)

- **Layout:** `lib/src/status/`.
  `status.dart` holds the pure rules (the pill, the banners of RA §6.3 items 3 and 6, what the sheet allows, the next change, the notices) and the feed and commands;
  `hours.dart` the weekly schedule being edited (`WeekDraft`) and the owners' commands;
  `texts.dart` every string mapping;
  `status_sheet.dart` and `hours_screen.dart` only show that state and call it (the design stop).
- **State:** `statusFeedProvider` is a `StatusFeed` of `GET /v1/merchant/restaurant/status` over `merchant:{restaurant_id}`, built as `LiveFeed` is but without order versions: it reads at start, after a subscription that did not recover, on every `restaurant.state_changed`, on order events while a maximum counts the active orders, a second after the next moment the status changes on its own (`nextChange`, on the server's clock), and every 30 s while down or failed.
  A command's answer is shown at once (`answered`).
  Screens read `statusProvider`.
- **Where it shows:** the pill in the board's top bar opens the status sheet (owners and cashiers);
  `StatusBanners` sits in `BoardAlertsLayer` after the offline bar and the stop;
  `/status-and-hours` (the clock button, until the navigation of RA §6.2) shows the status to everyone and the schedule, holiday close, default prep time, maximum active orders and the admin-set fields to owners.
  Its date and time pickers use the city's clock (`cityUtcOffset`).
- **Chimes:** `statusChimesProvider` (watched by `MerchantApp`) chimes once per auto-pause, pause ended on its own (only when the restaurant takes orders again), busy-mode reminder, and operations' pause (with its reason), resume and end of busy mode (RA §16 #23, slice 2.6b), and the board shows its notice;
  the push covers a closed app.
- **Tests:** `status_test.dart` proves the pure rules over `status_fixtures.dart`; `status_screen_test.dart` drives the pill, sheet, banners, chime and the hours screen.
- **Not yet:** the sheet's call button to operations (RA §7.2: the restaurant app has no operations number yet), «طلب تعديل» (RA §10, with support tickets), the bottom navigation and the connection dot (RA §6.2), up to two banners with a counter (RA §6.3), the banners' colours (the design).

## Settings (slice 2.14b; RA §12.7, §14.3; owner decision 2026-11-11)

- `lib/src/settings/`, owners only: the board's gear button (`open-settings`, shown only to an owner, until the navigation of RA §6.2) opens `/settings`, which the terms' wait covers (`ownerScreenWaits`).
  «الأجهزة» (below), then «العملات التي تقبلها من الكابتن».
  `pickupCurrenciesProvider` reads and sets `GET`/`PUT /v1/merchant/settings/pickup-currencies` on opening (auto-disposed): the base shown fixed on with «العملة الأساسية، مقبولة دائماً», a switch per other currency the city has enabled with its Arabic name from the server (`PickupCurrencies.switched` keeps the city's order), «لا عملات أخرى مفعّلة في المدينة.» without one.
  One save at a time: the switches are off until a save's answer, since each sends the whole set.
  A refused change shows «لم يُحفظ التغيير، حاول مرة أخرى» and reads the switches again;
  a read refused with `403` (a cashier, a terminated restaurant) says «هذه الإعدادات لمالكي المطعم فقط.» with no retry, any other failure «تعذّر تحميل الإعدادات، حاول مرة أخرى» with «إعادة المحاولة».
  A change applies to the pickups requested after it.
- **«الموظفون» and «الأجهزة» (slice 2.33; RA §14.1–14.2; owner decisions 2026-11-19):** the row «الأجهزة» at the top of «الإعدادات» (`open-devices`), shown even when the currencies' read failed (a `403` hides it with the rest), pushes `/settings/devices` (nested, so the terms' wait covers it). The «الموظفون» row and screen were deleted on 2026-11-27 and return with their own screen slice.
  `staff.dart` holds `staffProvider` and `devicesProvider` (auto-disposed, read on opening, each command's answer shown at once, any refusal but `phone_taken` reads the list again);
  `devices_screen.dart` only shows them (with `settings_parts.dart`).
  «الأجهزة»: name («هذا الجهاز» on this one), user and role, platform and version, signed in or not, the last activity;
  «إعادة تسمية» and, while signed in, «تسجيل خروج الجهاز» after a confirmation.
  A removed cashier's device, or one signed out, is signed out at its next call (`401`) and waits on `/starting` until the sign-in screen returns.
  No limit on cashiers.
- **Not yet:** the restaurant's info of RA §14.3. «هذا الجهاز» (slice 2.42) is the first row of «الإعدادات» and a cashier's own button.

## «الحساب» and the order's owner lines (slice 2.19d; RA §8.4, §12.1–12.2, §12.5, R10)

- `lib/src/account/`, owners only: the board's wallet button (`open-account`, beside the gear, shown only to an owner, until the navigation of RA §6.2) opens `/account`, which the terms' wait covers.
  `accountProvider` reads `GET /v1/merchant/account` on opening and on «تحديث» (auto-disposed);
  a `403` says «الحساب للمالكين فقط.» with no retry, any other failure «تعذّر تحميل الحساب.» with «إعادة المحاولة».
  `account.dart` holds the pure parts (`daysOf` groups the week's flat lines by their day in the server's order, `percentOf` shows basis points as «15» or «12.5», `causeLabel` gives each exception's label of RA §12.5, the correction as «تسوية يدوية: {السبب}», `balanceText`, `settlementText`);
  `account_screen.dart` only shows them: the balance card («المستحق عليك حتى الآن», «لك عند FOX DROP» below zero, «لا مستحقات عليك الآن.» at zero) with «موعد التسوية: {اليوم} {التاريخ}», the current rate and a scheduled change («تتغيّر عمولتك إلى…»), «قبضت اليوم من الكباتن» with each pickup (order, time, captain, the currency lines), and «هذا الأسبوع» by day: each order's commission and restaurant-funded discount, each exception with its order and whether it raises or lowers what is owed, each payment.
- **The detail (RA §8.4):** the board's `owner` adds «العمولة {النسبة}% — تُسدَّد يوم السبت» and «صافيك من الطلب», or «طلب تجريبي — لا عمولة», under the items value;
  a cashier's board carries none.
  Every user sees «طلب تجريبي» on a test order's card and detail (`testOrder`, RA §8.16; slice 2.30b).
- **«الكشوف» and «الإيصالات» (slice 2.19e; RA §12.3–12.5, §16 #30–#31):** «الحساب» links to `/account/statements` and `/account/receipts`, each detail nested under its list (so Back goes to the list, then «الحساب»), all covered by the terms' wait.
  `records.dart` holds the providers (each read while its screen shows, auto-disposed), the pure parts (`statusOf` by the status's name, `linesOf` splits a statement's flat lines into orders, exceptions and payments, `failureOf`: a `403` says «الكشوف والإيصالات للمالكين فقط.» and a `404`/`400` «لم يُعثر على …» with no retry, anything else «تعذّر التحميل.» with «إعادة المحاولة») and the texts;
  `records_screen.dart` only shows them.
  The statement shows the panel's printed labels: each order with the currency lines the captain paid, its commission and restaurant-funded discount, the exceptions with their order, label (`causeNameLabel`, shared with «الحساب»), direction and «من قرّر: {الموظف}» (or «تلقائياً» for the system), the payments, the totals down to «المجموع المستحق», the status and what is unpaid.
  «مشاركة كصورة» shares a PNG of the statement through `share_plus` (`imageSharerProvider`, as the captain's; an image only, owner decision 2026-11-16; PDF and Excel with the portal, 2.45), rendered at the screen's pixel ratio lowered so its longest side stays within 8192 pixels (`imageRatio`), so a busy week's statement still renders on Android.
  «الحساب»'s week shows «من قرّر» on its exceptions too (`deciderNameText`).
  The receipts list sits under the safety note of RA §12.4;
  a receipt shows its number, time, method, staff member, each currency line with its base value, the total and the balance before and after.
  `pushTargetPath` opens `statement` (`statementId`) and `receipt` (`receiptId`) pushes there.
- **The overdue settlement (slice 2.19f; RA §6.3 item 7, §12.2, §12.6, §16 #32):** «الحساب»'s `overdue` shows «متأخر: {المبلغ} من كشف {التاريخ}» under the balance (`account-overdue`; red with the design).
  `overdueProvider` (`account/overdue.dart`) reads `GET /v1/merchant/account/overdue` for an owner only (null for a cashier or signed out, with no request), at start, on a resume a minute or more after the last read (`overdueResumeGap`: Windows resumes on every focus change) and every `overdueRefresh` (15 minutes), since a payment at the desk or a statement past its days sends no event the app follows;
  «تحديث» on «الحساب» reads it again too.
  `OverdueBanner` shows «لديك مبلغ متأخر: {المبلغ}. يرجى التسوية في أقرب وقت.» in `BoardAlertsLayer` after `StatusBanners` (item 7 after items 3 and 6; amber with the design);
  a failed read keeps the last answer.
  The reminder push (`target: account`) opens «الحساب».
  The restaurant is never paused for it.
- **Not yet:** «لدي استفسار» (tickets), the restaurant-funded discount on the detail (codes, Phase 2), reading the account again on a receipt's push, the statement image's own layout (the design).

## «التقييمات» (slice 2.26b; RA §13, §6.1 row 7, R16; owner decisions 2026-11-17)

- `lib/src/ratings/`, owners only: the board's star button (`open-ratings`, shown only to an owner, until the navigation of RA §6.2) opens `/ratings`, which the terms' wait covers.
  `ratingsProvider` (`RatingsNotifier`, auto-disposed) reads `GET /v1/merchant/ratings` on opening, on each filter (`show`, which reads the first page again) and on «تحديث»;
  «عرض المزيد» (`more`) adds the next page, sent with the first page's `asOf`, and drops a page that answers after a newer first read or once the screen closed (`ref.mounted`).
  `ratings.dart` holds the state and the pure parts (`RatingPeriod`, the reports' periods of RA §11 and «الكل», sent as the route's values; `periodLabel`, `reasonsText`);
  `ratings_screen.dart` only shows them: the period chips, the average «{المتوسط} من 5» (`formatAverage` of `core_l10n`, without a needless «.0»; or «لا تقييم بعد»), «عدد التقييمات: {العدد}», the distribution from 5 to 1, the stars chips («كل النجوم», then each star; the summary counts every star), and each rating's stars, reasons, comment and business day (`noonOf` its `day`), never the customer, the order or the time (the server sends none).
  A `403` says «التقييمات للمالكين فقط.» to a cashier and «انتهى حساب مطعمك، والتقييمات لم تعد متاحة.» to a terminated restaurant (`refusalOf`), with no retry, any other failure «تعذّر تحميل التقييمات.» with «إعادة المحاولة»;
  a failed next page says «تعذّر التحميل، حاول مرة أخرى» on its button.
  No replies (R16).
  Tested by `ratings_screen_test.dart`.

## «التقارير» and «الملخص اليومي» (slice 2.41; RA §11; owner decisions 2026-11-20)

- `lib/src/reports/`, owners only: the board's floating `open-reports` button (shown only to an owner, above «السجل»: the owner's top bar has no room) opens `/reports`, and «الملخص اليومي» `/reports/summary`;
  the terms' wait covers both.
  `reports.dart` holds the providers (`reportsProvider` by `ReportsPeriod`, `summaryProvider` by day: `GET /v1/merchant/figures`, auto-disposed), the pure parts (`Metric`, RA §11's figures with their kinds and values; `changeOf`, the arrow and the change in whole percent against the previous period, `Rose` above a previous 0; `businessDayOf`, the city's day of a period's start; `oneDecimal`) and the texts (`metricLabel`, `metricInfo`, `metricValue`, `changeText`);
  the screens only show them.
  «التقارير»: the period chips (the ratings' words), every figure with «↑ 25%» or «↓ …» and «السابق: …», its definition in a dialog from the info icon (RA §11 «Definitions»), the rejections, the top items by quantity and by sales, the delivered orders by hour and the pause minutes by source, as plain lists until the design;
  busy-mode minutes say «غير متاحة بعد».
  «الملخص اليومي» opens on today's business day (the start of «اليوم»'s period), «اختيار يوم آخر» picks another within a year, and shows `summaryMetrics` with their arrows against the day before in a `RepaintBoundary` that «مشاركة كصورة» shares as a PNG (`imageSharerProvider` and `imageRatio` from «الكشوف»; the image's own layout with the design).
  A `403` says «التقارير للمالكين فقط.» or that the restaurant's account ended.
  Tested by `reports_screen_test.dart`.
  The portal's custom range and Excel come with 2.45.

## Support (slice 2.24b; RA §15, §8.19, §16 #29; owner decisions 2026-11-17)

- `lib/src/support/`: `support.dart` holds the providers and the commands, `report_photo.dart` the photo (as the customer app's: picked scaled to 1600 pixels, its type by its signature, `POST /v1/merchant/uploads/report-photo` then the PUT to the storage, the camera on Android only), and the screens only show them.
  The board's `open-support` button (everyone, until the navigation of RA §6.2) opens `/support`: «اتصال بالعمليات» and «واتساب العمليات» (`contactTiles`, the numbers of `merchantAuth.contact`; a missing one hides its button), «إبلاغ عن مشكلة», «بلاغاتي» (`myReportsProvider`, `GET /v1/merchant/reports`, read while the screen shows and again after a report: each ticket's number and type, the data change's subject, the order, the note, «من مستخدم آخر» or «من العمليات» on an owner's list (`openedBy`), the status of AP Appendix C and «الرد: …») and the FAQ (`merchantFaqProvider`, from `GET /v1/merchant/content`, which `merchantContentProvider` now answers whole).
  `/support/report` takes a type of `merchant_ticket_type`, the subject for «طلب تعديل بيانات» (`DataChangeSubject`; «إرسال البلاغ» stays off until it is chosen), optionally a board order, a note and one photo.
  The order detail's «مشكلة في الطلب» (`showOrderProblem`, every order) offers the call, WhatsApp with «بخصوص الطلب #{رقم}» and the quick reasons of `merchant_problem`;
  one tap sends it, after asking the text of a reason Content requires it for (`Reason.noteRequired`, as the report's «إرسال البلاغ» waits for the note).
  `MerchantReports` keeps a key per body until the server answers, so sending the same report again after a lost answer replays it;
  `unknown_reason` and the subject's refusals read Content again, a photo's refusal uploads it again on the next send.
  The answer says «استلمنا بلاغك T-{رقم}. سنرد عليك خلال {المدة}.» from the ticket's `replyWithinMinutes` (`formatReplyWithin`).
  A `ticket` push («تم حل بلاغك», to the owners and the reporter) opens `/support`.
- **Tests:** the `support` group of `board_screen_test.dart`.
- **Not yet:** a ticket's own screen; RA §10's «طلب تعديل» from the hours screen and «لدي استفسار» from «الحساب» (they can link `/support/report`).

## «القائمة» (slice 2.32a; RA §6.1 #3, §9.1–9.4, §9.6–9.7, §18)

- `lib/src/menu/`: `menu.dart` holds the state, the commands and the pure parts (`quickRows`, `moved`, `typedOf`, `deltaOfTyped`, `basisPointsOf`, `changesMenu`);
  `texts.dart` the string mappings;
  the `*_screen.dart` files only show them (the design stop).
  The board's floating button (`open-menu`, everyone, until the navigation of RA §6.2: the top bar's actions already fill a phone) opens `/menu`, with `quick-edit`, `bulk-price`, `price-log` and `preview` under it;
  the terms' wait covers them.
- **State:** `menuProvider` (`MenuNotifier`, auto-disposed) reads `GET /v1/merchant/menu` on opening and again after a subscription that did not recover and on every `restaurant.state_changed` of kind `menu_changed`, `price_change` or `price_change_bulk` on `merchant:{restaurant_id}`, so every device shows what the last one published;
  each command's answer (the menu) is shown at once, the availability switch's (only the switch) by a read.
- **Everyone (RA §6):** each category, item and option with its own switch («متوفر», «متوقف حتى الغد», «متوقف حتى أعيده»), «غير متوفر للزبائن» for an item off through its category, window or a required group, the window and «مخفي عن الزبائن»;
  switching off asks «حتى الغد» or «حتى أعيده».
  «تعديل سريع» (search by name, filter by category; an option shared by several items shows once) has the switch for everyone.
- **Owners:** «تعديل السعر» on each item and option (the field in major units, `minorOfTyped`; a delta may be 0), always with «تذكير: سعر التطبيق يجب ألا يزيد على سعر المحل»;
  «إخفاء»/«إظهار»;
  up and down for categories and items (until the design's drag);
  «فترة التوفر» with the system's time pickers on the minutes of the city's day, or «طوال اليوم»;
  «تعديل جماعي للأسعار» (category or the whole menu, percentage or amount, up or down, «معاينة قبل وبعد» then «تأكيد التعديل», off while a price would reach 0; its key belongs to the body until the server answers);
  «سجل الأسعار» (the user's name or «FOX DROP»);
  «معاينة كما يراها الزبون» (unavailable items faded with «يتوفر غداً», «متوفر من {الساعة}» or «غير متوفر حالياً»).
  The cashier sees none of these (the server answers them `403 owner_only`).
- **Tests:** `menu_screen_test.dart`.
- **Change requests (slice 2.32b; RA §9.2 «After admin review», §9.5, §18):** `request_forms.dart` holds the forms and `PendingLines`.
  The menu's answer carries each row's `pending` (a request «بانتظار المراجعة»: `pendingText` says what it asks: «الاسم المطلوب: …», «الوصف المطلوب: …», «صورة جديدة بانتظار المراجعة؛ تبقى الصورة الحالية حتى الموافقة», a group's choices and items) and the new rows waiting for review (`isNew`: «جديد — لا يراه الزبائن قبل الموافقة», no switch, price, hiding, order or window; `publishedIds` keeps them out of the reorder and `quickRows` out of «تعديل سريع»), and `optionGroups`, shown by `OptionGroupsSection` («مجموعات الخيارات»).
  Everyone sees the badge;
  owners get «سحب الطلب» on each request and the forms, each answering the menu: «إضافة تصنيف» (the app bar) and «تعديل الاسم» on a category, «إضافة صنف» (name, description, price with the parity reminder, a photo) and «تعديل الطلب» on a new item, «تعديل الاسم والوصف» and «تغيير الصورة» on a published one, «إضافة مجموعة خيارات» and «تعديل المجموعة» (name, minimum and maximum, the items ticked, the options; a published option's delta is read only, since it changes through «تعديل السعر»).
  Each form starts from the pending values (`pendingOf`), since sending a published value again withdraws its request.
  A new row's id comes from `newMenuIdProvider` (`uuidV4`; tests give their own), so a request sent again changes the same row.
  A photo is picked as the report's (`photoPickerProvider`, the camera or the gallery on Android, a file on Windows), uploaded once (`ItemPhoto`, `POST /v1/merchant/uploads/item-photo`, then the PUT through `photoPutProvider` to `/public-media/incoming/` on the API's host) and sent by its upload id.
  A refusal says «قُرّر هذا الطلب أو سُحب.», «تعذّر رفع الصورة، حاول مرة أخرى.» or «تحقق من الحقول وحاول مرة أخرى.» (`refusalText(…, request: true)`).
  A review's decision (`menu_change_approved`, `menu_change_rejected`) reads the menu again;
  its silent push reaches the owners.
- **Not yet:** the menu's push target (`pushTargetPath`), the drag, showing the photos themselves (the design), the photo crop before review (the design), a menu without any price yet (onboarding never leaves one) has no «إضافة صنف» since the base currency comes from the menu's prices.

## «السجل» (slice 2.40; RA §8.18, S12; owner decisions 2026-11-20)

- `lib/src/history/`: `history.dart` holds `historyProvider` (`HistoryNotifier`, auto-disposed: `GET /v1/merchant/orders/history` on opening and on each filter, `show`; «عرض المزيد» reads the page after `next` and drops one that answers after a newer first read), `historyOrderProvider` (`GET /v1/merchant/orders/{orderId}`) and the texts;
  `history_screen.dart` only shows them.
  The board's floating `open-history` button (everyone; beside the menu's, since an owner's top bar has no room left) opens `/history`, each order `/history/:id`;
  the terms' wait covers them for an owner.
  A cashier sees «اليوم وآخر 7 أيام» fixed and no money but the items value;
  an owner gets the presets «اليوم وآخر 7 أيام» (the server's default), «اليوم», «آخر 30 يوماً» (from the business day today the first default read answered) and «فترة أخرى» (the date range picker, a year back), and each row's «العمولة … · الصافي …».
  Every user filters by status and searches by number within the range.
  The detail shows the order as the board's detail does, read only, with «مراحل الطلب»;
  a `404` says «لم يُعثر على هذا الطلب.» with no retry.
  Excel stays with the portal (2.45).
  Tests: `history_screen_test.dart`.

## «اتصال بالكابتن» (slice L.1b; RA §8.9, §22 item 10)

- The order screen shows the button while the order has a captain and is accepted, ready, picked up or arrived (`canCallCaptain` in `board/commands.dart`).
  A tap reveals the number through `merchantOrderContactsCallCaptain`, which records the tap on the server; the board never carries the captain's phone.
  Android dials `tel:`; Windows shows «رقم الكابتن: …» in a dialog, since a desktop cannot dial.
- The reveal is a direct call, not a queued board command: no idempotency key and no retry, so each tap is one record. A refusal (`409`, the order moved on) dials nothing and shows the board's notice.
- Tests: the "call the captain" group of `board_screen_test.dart`.

## Not yet (slice 1.14e)

- The banner «طلبات دون رد اليوم: {العدد} من {الحد}…» (RA §8.3: the board does not give the day's count yet);
  the cards' «تحتاج وقتاً أطول؟ اتصل بالعمليات» and the «مع الكابتن» card's «المبلغ غير صحيح» and call button (RA §8.7, §8.11) are on the detail only until the design places them.
  The badges and the timeline of the detail (RA §8.4), the captain's photo and ETA (RA §8.9), the other cancellations' wordings (RA §8.14), with their server fields and slices.
