# apps/merchant

The restaurant app «تطبيق المطعم» (Android and Windows; architecture §11, §12; RA §4–§16). Read `apps/customer/CLAUDE.md` first (it does not load here by itself): its rules hold here too.

## Rules

- **Layout of a feature:** `lib/src/<feature>/` (`board`, `status`, `menu`, `receiving`, `windows`, ...). The state, commands and pure rules sit in one Dart file (`board/board.dart` is the pattern), every string mapping in `texts.dart`, and the `*_screen.dart` files only show that state and call it (the design stop: no styling yet).
- **Board state:** the board is a `LiveFeed` (`packages/core_realtime/CLAUDE.md`) of `GET /v1/merchant/orders` over `merchant:{restaurant_id}`. Screens read `boardProvider` and never patch it; the order detail reads the same board.
- **Time:** every countdown and «منذ» runs on `serverClockProvider` (`packages/core_time/CLAUDE.md`) through `tickProvider`; never `DateTime.now()`.
- **Commands:** go through `BoardCommands`, one at a time per order, waiting in the device's queue (`commandQueueProvider`, `packages/core_commands`). The `Idempotency-Key` belongs to the command and its body (`Rejection.body`, `ItemReport.body`), so a retry after no answer, a 5xx, a 408 or a 429 sends the same key. Any answer refreshes the board. A `409` is explained from what it carries. A command whose account is no longer signed in is dropped, never sent in another's name.
- **Ring and chimes:** what rings is derived from the board, never from an event, so the ring stops on every device once any device or the server handles it. Chime rules are the pure `alertStep`; an event waits for the board fetched after it. A new ringing kind goes through `ringing`, `ringSound` and `ringText`, not a new mechanism.
- **Owners and cashiers:** owner-only screens (account, ratings, reports, settings, staff, devices, price edits) must be added to `ownerScreenWaits` so the terms' wait covers them; a button shown only to an owner is hidden for a cashier, and the server's `403` is the real guard.
- **Floating buttons:** the board's actions are floating or top-bar buttons (`open-<name>`) until the navigation of RA §6.2; a new screen follows that pattern.
- **Push:** a push's target is mapped in `pushTargetPath` (`lib/src/push.dart`) and waits for the session's details. Android channels (`ring_order`, `chime`, `silent`) are created in `MainActivity`; a channel keeps its first sound, so a new sound needs a new channel.
- **Windows:** no flavors; staging's values come from `--dart-define`. `windows/runner/main.cpp` allows one copy per installation. The update is trusted only with the feed's Ed25519 signature.
- **Photos and shares:** a photo goes through `POST /v1/merchant/uploads/...` and then a PUT to storage, sent by its upload id; a share is a PNG through `imageSharerProvider` with `imageRatio`.
- **Tests:** pure rules in `test/board_test.dart`, `status_test.dart`; screens with `FakeServer`, `FakeTransport` and `FakeRinger` over `test/board_fixtures.dart` and `status_fixtures.dart`. Every test container overrides `alertsProvider` (`FakeAlerts` from `package:core_alerts/testing.dart`), `notificationPermissionProvider` and `deviceStoreProvider`, since the real ones call the platform. Widget tests end with `done(tester)` so the board's timers stop.

## More

Behaviour, decisions and history: `docs/code/apps/merchant.md`. Grep it for what you change; never read it whole.
