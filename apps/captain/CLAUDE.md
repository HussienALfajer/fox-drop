# apps/captain

The captain app «تطبيق الكابتن» (Android, iOS; architecture §11, §14; CA §4.3-4.6, §7-§9, §14-§15). The rules shared by the three Flutter apps are `.claude/rules/flutter-apps.md`; they load by themselves here.

## Rules

- **Layout:** the work cycle lives in `lib/src/work/`: `work.dart` the state, its pure rules and the feed; `location.dart` the location; `commands.dart` the commands and their refusals; `alerts.dart` the ring and the chimes; `texts.dart` every string mapping. Other features have their own folder (`joining/`, `profile/`, `device_check/`, `performance/`, `support/`, `settings/`). Screens and sheets only show state and call it.
- **State:** `workFeedProvider` is a `LiveFeed` over `captain:{captain_id}` whose fetch reads the availability, the open offer and the active order together, so the screens never show one newer than the others. Screens read `workProvider` and never patch it; every command's answer refreshes it.
- **Commands (CA §4.6, §15):** `Commands` runs one command at a time per subject (`availability`, the offer's id, the order's id). The `Idempotency-Key` belongs to the command and its body (the location fix is left out, as the server's hash does); a call without an answer, a 5xx, a 408 or a 429 is sent again with the same key after a backoff. `refusal` maps every refusal of CA §15 to a `Notice`, which `texts.dart` explains.
- **Time:** every countdown and «منذ» watches `tickProvider` and reads `serverClockProvider`; never `DateTime.now()`.
- **The offer (CA §8):** it shows and rings only while open, before its `expiresAt` on the server clock and not answered on this phone (`ringingOffer`); past its time the feed is fetched again, so a lost event never leaves it on. Ring through `core_alerts` (`AlertsRinger`); the chime and the cancellation sound play once, never over a ring.
- **Location (CA §4.3, architecture §14.1):** `PhoneLocationSource` takes one-off positions through `geolocator` and tracks through `flutter_background_geolocation`. `LocationTracker` runs while the state is online in any way and is started and stopped by `WorkLayer`; never track while offline or signed out. Its Android licence is the build's env `FOXDROP_BGGEO_LICENSE`: never commit it. On iOS the library gives a point about every second and `LocationThinner` keeps one every 10 seconds.
- **Reason lists:** the away and shortfall reasons come from Content, never from a constant.
- **Tests:** `work_test.dart` proves the pure rules (door payment, refusals, alerts, ring, location queue); `home_test.dart` drives the cycle with `TestApp` (`test/fixtures.dart` holds the server's JSON). A feature adds its own `<feature>_test.dart` beside them.

## More

Behaviour, decisions and history: `docs/code/apps/captain.md`. Grep it for what you change; never read it whole.
