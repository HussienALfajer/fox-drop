# 4. Platforms and technical foundations

> Part of the [captain app spec](README.md) (CA). A bare "§n" here means CA §n.

## 4.1 Platforms

| Platform      | Minimum              | Notes                                                       |
| ------------- | -------------------- | ----------------------------------------------------------- |
| Android phone | Android 8.0 (API 26) | Full behaviour, including a foreground service while online |
| iPhone        | iOS 15               | Same features. Background rules differ (§4.3, §4.4).        |

- Both apps MUST have the same features and rules. They are one Flutter codebase, with `flutter_background_geolocation` for location and native layers for offers and sounds (technology-stack §14).
- Phones only. Tablets are not a target, but the layout MUST not break on one.

## 4.2 Distribution and updates

- **Android:** through Google Play where it is available, and as a signed APK from the FOX DROP website, with the same signing certificate (as RA §4.2).
- **iPhone:** through the App Store. FOX DROP's Apple Developer account is available (technology-stack T3).
- **Version check:** at launch and on every reconnect, the app compares its version with `app.captain.min_version` and `app.captain.latest_version` (AP §9.14).
  - Below the minimum, a blocking update screen appears. A captain with an active order can finish it first: the block applies to going online again.
  - Below the latest, a dismissible banner appears.

## 4.3 Location

- **While online:** the app sends the captain's location every 10 seconds (fixed, AP §4.2), with its accuracy. The panel's map, dispatch, ETAs and the customer's tracking use it.
- **While offline:** no location is collected or sent (fixed). The app says so in the permission explanation.
- **Android:** a foreground service runs while the captain is online. It shows a permanent notification, «أنت متصل — FOX DROP يتابع موقعك لتصلك العروض».
- **iPhone:** the app asks for location «دائماً» (Always) with precise location, and uses background location updates while online. iOS shows its blue location indicator while the app tracks in the background.
- **No signal:** points recorded without a connection are queued and sent when the connection returns, so the route is complete. If no point reaches the server for `captain.gps_stale_alert_min` (2) minutes during an active order, OPS get «انقطع اتصال كابتن أثناء طلب» (AP §9.1.3).
- **Mock locations:** the app detects simulated locations: mock-location apps on Android, and `isSimulatedBySoftware` on iOS 15+. While one is active, the captain cannot go online, or gets no new offers if already online (§7.2). The panel records it.

## 4.4 Offers and sounds

- **Android:**
  - An offer opens a full-screen offer screen, also over the lock screen where the system allows it. On Android 14+ the app asks for the full-screen permission.
  - The offer sound loops for the whole offer time. It plays through the alarm audio stream, so the media volume and the ringer's silent mode do not mute it. The phone vibrates as well.
- **iPhone (K15):**
  - With the app open, the offer screen appears and the sound plays for the whole offer time.
  - With the app in the background or the phone locked, the offer arrives as a **time-sensitive notification** with the offer sound. iOS limits the sound to 30 seconds and lets the ring/silent switch mute it.
  - The device check asks the captain to keep the ring switch on and to allow time-sensitive notifications.
  - FOX DROP SHOULD apply to Apple for the Critical Alerts entitlement. If Apple grants it, offers use critical alerts, which sound even on silent.
- **Channels:** a WebSocket while the app runs, and push (FCM on Android, APNs on iOS) when it does not. The app MUST NOT depend on push alone on Android (as RA §4.3).
- **Other sounds:** a short chime for order events (ready, restaurant confirmed, edits, messages) and a distinct sound for cancellation or withdrawal. Sounds are fixed assets bundled with the app.

## 4.5 Device check «فحص الجهاز»

The device check runs before the first time a captain goes online, and again from Settings. Each step explains with screenshots what to do, including settings paths for common Android brands (Samsung, Xiaomi/Redmi/Poco, Huawei/Honor, Oppo/Realme, Vivo).

| #   | Check                                                                                                 | Android                                                                                               | iPhone                                                                                                      |
| --- | ----------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| 1   | Notifications allowed                                                                                 | Read by the app                                                                                       | Read by the app, including time-sensitive notifications                                                     |
| 2   | Location always, precise                                                                              | Read by the app                                                                                       | Read by the app                                                                                             |
| 3   | Running in the background                                                                             | Battery optimisation off: read by the app. Brand auto-start: confirmed by the captain                 | Background App Refresh on and Low Power Mode off: read by the app                                           |
| 4   | Full-screen notifications allowed (Android 14+)                                                       | Read by the app                                                                                       | —                                                                                                           |
| 5   | Sound can be heard                                                                                    | Alarm volume at least 70%: read by the app. Do Not Disturb allowing the app: confirmed by the captain | Ring switch on and Focus allowing the app: confirmed by the captain (iOS does not let apps read the switch) |
| 6   | Test offer: the phone plays the offer sound with the screen locked, and the captain taps «سمعت الصوت» | Yes                                                                                                   | Yes                                                                                                         |
| 7   | Server connection and GPS accuracy                                                                    | Read by the app                                                                                       | Read by the app                                                                                             |
| 8   | Call permission for the emergency button                                                              | Read by the app                                                                                       | — (iOS asks to confirm each call)                                                                           |

- **Re-checks:** the checks the app can read are read again each time the app opens and each time the captain goes online. The checks the captain confirms are asked again only when the test offer (check 6) fails or the captain runs the check again. A failed check shows a yellow banner: «هاتفك قد لا يرن عند وصول عرض — أكمل فحص الجهاز».
- **Going online:** a failed check never blocks going online. It warns only, because a captain can still work with the app open.
- **Panel:** the result of the last check is sent to the server and shown in the captain profile (AP §9.7.4).

## 4.6 Weak internet and cheap phones

- **Commands:** every command carries an idempotency key and retries with backoff until the server answers, and it is never applied twice (as RA §4.7). While waiting, the button shows «جارٍ الإرسال…» and cannot be pressed again.
- **State conflicts:** the server checks each command against the current state. If the state changed (for example, the order was withdrawn), the app explains what happened.
- **Lost connection:** a red bar shows «لا يوجد اتصال بالإنترنت — لن تصلك العروض حتى يعود الاتصال». After 30 seconds offline (fixed), a chime plays once.
- **Timers** use server time, as in RA §4.7.
- **Light data:**
  - map tiles are cached
  - the route line is fetched once per leg
  - photos (documents) are compressed before upload
  - the app SHOULD stay under 2 MB of data per delivered order, excluding first-time map tiles
- **Navigation hand-off:** the in-app map shows the route for overview. «ابدأ الملاحة» opens Google Maps, or on iPhone Google Maps or Apple Maps as the captain prefers.

## 4.7 Formatting and business day

- **Formatting:** as in AP §4.7, with Western digits, money with its symbol, 12-hour times with «ص/م», and durations as «12 د».
- **Business day:** cutoff 06:00 by default (AP §4.3). It decides:
  - «اليوم» in earnings
  - what counts as custody from a previous day (§10.3)
- **Distances** show as «850 م» below 1 km and «2.4 كم» above.
- **Font size:** the app SHOULD stay usable with the system font enlarged up to 130%.

## 4.8 Maintenance and terms

- **Maintenance:** when `app.captain.maintenance` is on, the app shows a blocking screen with the message. A captain with an active order keeps the order screens, so they can finish.
- **Terms:** a new version of the captain terms (AP §9.13) must be accepted before going online (K7). A current order continues.
- **Work rules page:** the captain work rules page and the pay table text come from Content (AP §9.13) and are always available in the app.

## 4.9 Sign-in, session and device

- **Sign-in:** by phone number and a code sent over WhatsApp, the only channel in V1 (`otp.channel_order`, technology-stack §8.3), with the `otp.*` settings (AP Appendix A). A number without WhatsApp gets «هذا الرقم غير مسجّل على واتساب».
- **One device (K5):** a captain is signed in on one device at a time (fixed). Signing in on a new device signs the old one out, and the old device shows «سُجّل دخولك من جهاز آخر».
- **During an active order:** the captain cannot sign in on a second device by themselves. If the phone is lost, broken or out of battery, OPS release the old device from the panel (AP §9.7.5, «تحرير الجهاز»). The captain then signs in on the new device and continues the same order from its current step. If the captain has no phone at all, OPS can record the delivery on their behalf (AP §9.3.2).
- **Session length:** sessions do not expire with inactivity. They end on sign-out, a sign-in on another device, termination, or an admin forcing sign-out.
- **Phone number changes** go through OPS in the panel.
