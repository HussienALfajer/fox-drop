# 14. Captain app (Android and iOS)

> Part of the [technology stack](README.md). A bare "§n" here means §n of the technology stack.

## 14.1 Location: `flutter_background_geolocation`

- The **Transistorsoft `flutter_background_geolocation`** library, with a paid licence for Android. It is the standard for courier apps because it solves the hardest parts of CA §4.3:
  - reliable background tracking on Android and iOS, with motion detection to save battery
  - a **persistent queue of points** while offline, sent in batches when the connection returns
  - an HTTP sync to the server with retries
  - the 10 s interval with accuracy per point, only while online
- Location is never collected while offline (CA §4.3): the app starts the library when the captain goes online and stops it when they go offline.

## 14.2 Offers and sounds (native layer in `core_alerts`)

- **Android:** the same foreground service and alarm-stream sound as the restaurant app, with the notification «أنت متصل — FOX DROP يتابع موقعك لتصلك العروض»; foreground service type `location`; a full-screen offer over the lock screen where granted; vibration (CA §4.4).
- **iOS (Swift):** time-sensitive notifications with the offer sound (30 s limit); critical alerts if Apple grants the entitlement; in the foreground, the offer screen with the looping sound (CA §4.4).

## 14.3 Integrity and fraud

- **Mock locations:** `isMock` on Android and `isSimulatedBySoftware` on iOS, read per point (CA §4.3).
- **Firebase App Check** on every request from the captain app.
- Root and jailbreak signals reported to the panel; they do not block by themselves in V1.
- **One device** (CA §4.9): the session is bound to a device ID generated at install and stored in secure storage; the server ends the old session on a new sign-in.

## 14.4 Light data (CA §4.6)

- Map tiles cached; the route line fetched once per leg; document photos compressed on the device (`flutter_image_compress`) before upload; JSON responses compressed (gzip or Brotli).
- A CI check measures the data used by a scripted delivery against the 2 MB target.
