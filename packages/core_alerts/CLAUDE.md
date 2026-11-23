# packages/core_alerts

The native ringing layer of the restaurant app (architecture §11.2, §12.2; RA §4.3–4.5), of the captain app (architecture §14.2; CA §4.4–4.5) and the restaurant app's Windows layer (architecture §12.3).

## Rules

- **Layout:** `lib/src/alerts.dart` holds `Alerts`, `AndroidAlerts`, `IosAlerts`, `NoAlerts`, `DeviceReadings` and `platformAlerts()` on the channel `fox_drop/core_alerts`; `lib/src/windows_alerts.dart` and `windows/core_alerts_plugin.cpp` are Windows; `ios/core_alerts/` is a Swift package (no podspec: the captain app builds plugins through Swift Package Manager); Android Kotlin is in `android/src/main/kotlin/com/foxdrop/core_alerts/`. Tests use `FakeAlerts` from `lib/testing.dart`.
- **Sounds:** the bundled sounds are `android/src/main/res/raw/` (placeholders from `tool/placeholder_sounds.py`); `keep.xml` keeps them through resource shrinking, since `Ringer` finds them by name. Keep the iOS notification sound at most 30 seconds (`fd_offer_30s.wav`). Windows reuses the Android raw files as package assets.
- **One Flutter engine:** `ReceivingService.engine(context)` creates the app's engine once and caches it as `fox_drop_main`; the app's `MainActivity` provides it (`provideFlutterEngine`) and never destroys it (`shouldDestroyEngineWithHost` false). An app using this package must do the same.
- **Receiving service (restaurant app):** a foreground service of type `specialUse` with a permanent notification and a partial wake lock; `startReceiving` records a signed-in device, `stopReceiving` (sign-out) clears it, and `StartReceiver` restarts it after boot only then. A start the system refuses stops the service instead of crashing; `wake` never throws.
- **The captain app** uses the ring, the chime and the readings, never the receiving service: its manifest removes `ReceivingService`, `StartReceiver` and `FOREGROUND_SERVICE_SPECIAL_USE` (`tools:node="remove"`).
- **The ring:** looped on `USAGE_ALARM` (media volume and silent mode do not mute it); a ring already playing changes only its sound or text. The chime plays once on `USAGE_NOTIFICATION`, never over a ring.
- **Strings:** the service's and the ring channel's texts are system texts in `res/values/strings.xml` (`.claude/rules/flutter-apps.md`, «Arabic»); the ring's own text comes from the app.
- **iOS:** no receiving service (`startReceiving`, `stopReceiving`, `wake` do nothing). A ring in the background becomes one local notification `fd_ring`. The app bundles the sounds itself (Xcode resources), since a plugin's own resources are not in the main bundle where iOS looks for a notification's sound.
- **Windows:** closing the window hides it (tray icon). Stay on `window_manager` and `tray_manager` 0.5.x (0.6 and later moved to `nativeapi`). Do not use `launch_at_startup` (its `win32` 5 clashes with `package_info_plus`'s 6). No `ReceivingService`: the app keeps running in the tray.
- **Tests:** the Kotlin, C++ and Swift build with the app (the `android-release`, `windows-release` and `ios-release` CI jobs) and have no unit tests; `test/alerts_test.dart` proves the channel's calls.

## More

Behaviour, decisions and history: `docs/code/packages/core_alerts.md`. Grep it for what you change; never read it whole.
