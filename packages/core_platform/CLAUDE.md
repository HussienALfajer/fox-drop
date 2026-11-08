# packages/core_platform

The forced update and maintenance of the three Flutter apps (CU §4.2, §4.7, RA §4.2, §4.10, CA §4.2, §4.8; slice 2.4a). The server side is `GET /v1/{party}/platform` in the settings module (`apps/server/src/modules/settings/CLAUDE.md`, «The apps' read»), which the panel's «التطبيقات» sets (AP §9.14).

## Layout

- `platform_status.dart`: `PlatformStatus` (the update need, maintenance and their messages) and `platformStatusOf`, from the generated client's answer.
- `platform_check.dart`: `PlatformCheck`, the status kept current, and the update banner's dismissal.
- `platform_screens.dart`: `PlatformBlockScreen`, `UpdateBanner`, `UpdateBannerFrame` and `updateUrl()`.

## Rules

- **When the app checks** ("at launch and on every reconnect"): `start()` reads now and on each return to the foreground (`AppLifecycleListener.onResume`); a failed read is tried again, 5 s doubling to 5 minutes, so the check follows the connection coming back. Until the first answer the status is `PlatformStatus.clear`: a server out of reach never locks the app. The live push to open devices comes with slice 2.4c's platform broadcast.
- **The server decides:** the app sends its version and the server answers `updateNeed`; the app never compares versions.
- **Blocking:** each app turns `status.blocks` (maintenance, or a required update) into its router's redirect to `/blocked`, which shows `PlatformBlockScreen`, maintenance first since an update does not end it. What stays reachable is each app's rule (its `CLAUDE.md` «Update and maintenance»): the customer's active order, the captain's current order, nothing in the restaurant app.
- **The banner** of a suggested update is dismissed for the app's run (`dismissBanner`) and comes back at the next start. `UpdateBannerFrame` wraps `MaterialApp.router`'s `builder` child, so it shows over every screen.
- **The update button** opens `--dart-define=UPDATE_URL` (the store page, or the FOX DROP website's download for the platform, RA §4.2), with the system's browser or store; without it the button is hidden. It is not a setting: Appendix A has none, and each platform's build has its own address.
