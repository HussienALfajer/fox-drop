# packages/core_platform

The forced update and maintenance, the terms and privacy and the emergency stop of the three Flutter apps (CU §4.2, §4.7, RA §4.2, §4.10, §8.17, CA §4.2, §4.8, §6.3). The server side is `GET /v1/{party}/platform` in the settings module (`apps/server/src/modules/settings/CLAUDE.md`).

## Rules

- **Layout (`lib/src/`):** `platform_status.dart`, `kept_read.dart` (`KeptRead`, a server answer kept current), `platform_check.dart`, `emergency_stop.dart`, `platform_screens.dart`, `terms.dart`.
- **The server decides:** the app sends its version and the server answers `updateNeed`; the app never compares versions.
- **A failed check never locks the app:** until the first answer the status is `PlatformStatus.clear` (and the stop `EmergencyStop.none`). A failed read is retried, 5 s doubling to 5 minutes; a `check()` during a read reads once more after it, so an answer older than the call never stands.
- **When the app checks:** `start()` reads now and on each return to the foreground (`AppLifecycleListener.onResume`).
- **Broadcasts are only a cue:** `followPlatformBroadcasts` makes each broadcast (`platform.emergency_stop`, `platform.app_changed`) and each channel reconnect read the state again; the state is always the read's answer. The customer app has no channel of its own and follows the stop on an open order's channel only.
- **Blocking:** each app turns `status.blocks` into its router's redirect to `/blocked` (`PlatformBlockScreen`, maintenance first). What stays reachable is each app's own rule (its `CLAUDE.md`, «Update and maintenance»).
- **Terms:** `TermsCheck` reads at `start()` and on each foreground return; until the first answer nothing waits on it (the server refuses what a pending version blocks). `accept(version)` sends the version the screen showed; `409 terms_outdated` reads again and shows the newer text. What a pending version blocks is each app's rule («Terms» in its `CLAUDE.md`). Each app makes one `TermsCheck` per sign-in.
- **Update button:** opens `--dart-define=UPDATE_URL` (a build setting, not a server setting); without it the button is hidden. The suggested-update banner is dismissed for the app's run only.
- **Placement:** `UpdateBannerFrame` wraps `MaterialApp.router`'s `builder` child; `EmergencyStopBanner` goes under each screen's top bar, after the offline bar. Presentation waits for the design (design stop).

## More

Behaviour, decisions and slice history: `docs/code/packages/core_platform.md`. Grep it for the feature, route, table or label you are changing and read only those lines; never read it whole.
