# packages/core_platform

The forced update and maintenance (slice 2.4a) and the terms and privacy (slice 2.4b) of the three Flutter apps (CU §4.2, §4.7, RA §4.2, §4.10, CA §4.2, §4.8). The server side is `GET /v1/{party}/platform` in the settings module (`apps/server/src/modules/settings/CLAUDE.md`, «The apps' read»), which the panel's «التطبيقات» sets (AP §9.14).

## Layout

- `platform_status.dart`: `PlatformStatus` (the update need, maintenance and their messages) and `platformStatusOf`, from the generated client's answer.
- `platform_check.dart`: `PlatformCheck`, the status kept current, and the update banner's dismissal.
- `platform_screens.dart`: `PlatformBlockScreen`, `UpdateBanner`, `UpdateBannerFrame` and `updateUrl()`.
- `terms.dart`: `Terms` and `termsOf`, `TermsCheck` (the terms kept current and «أوافق») and `TermsScreen`.

## Rules

- **When the app checks** ("at launch and on every reconnect"): `start()` reads now and on each return to the foreground (`AppLifecycleListener.onResume`); a failed read is tried again, 5 s doubling to 5 minutes, so the check follows the connection coming back; the restaurant and captain apps, which stay in the foreground for hours, also call `check()` when their channel comes back up (their `app.dart`, on the board and work feeds' `live`). Until the first answer the status is `PlatformStatus.clear`: a server out of reach never locks the app. The live push to open devices comes with slice 2.4c's platform broadcast.
- **The server decides:** the app sends its version and the server answers `updateNeed`; the app never compares versions. A version not in the form `1.4.0` is answered as below any minimum, never refused.
- **Blocking:** each app turns `status.blocks` (maintenance, or a required update) into its router's redirect to `/blocked`, which shows `PlatformBlockScreen`, maintenance first since an update does not end it. What stays reachable is each app's rule (its `CLAUDE.md` «Update and maintenance»): the customer's active order, the captain's current order, nothing in the restaurant app.
- **The banner** of a suggested update is dismissed for the app's run (`dismissBanner`) and comes back at the next start. `UpdateBannerFrame` wraps `MaterialApp.router`'s `builder` child, so it shows over every screen.
- **The update button** opens `--dart-define=UPDATE_URL` (the store page, or the FOX DROP website's download for the platform, RA §4.2), with the system's browser or store; without it the button is hidden. It is not a setting: Appendix A has none, and each platform's build has its own address.
- **Terms (AP §9.13):** `GET /v1/{party}/terms` (the content module) answers the version in force and `pending` for the signed-in account. `TermsCheck` reads it at `start()` and on each return to the foreground, so a version published meanwhile is asked for on the next open, with the same retries; until the first answer it is null and nothing waits on it (the server refuses what a pending version blocks). Each app makes one per sign-in (its provider watches the auth state). `accept(version)` sends the version the screen showed; a `409 terms_outdated` reads again and answers `outdated`, so the screen shows the newer text. `TermsScreen` shows the text and, while pending, «أوافق على الشروط وسياسة الخصوصية». What a pending version blocks is each app's rule (its `CLAUDE.md` «Terms»): the customer's ordering, the captain's going online, a restaurant owner's screens other than Orders.
