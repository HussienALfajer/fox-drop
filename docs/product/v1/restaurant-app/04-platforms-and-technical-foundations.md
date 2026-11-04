# 4. Platforms and technical foundations

> Part of the [restaurant app spec](README.md) (RA). A bare "§n" here means RA §n.

## 4.1 Platforms

| Platform            | Users   | Receives orders           | Other screens              | Minimum                                 |
| ------------------- | ------- | ------------------------- | -------------------------- | --------------------------------------- |
| Android phone       | MO, MC  | Yes, with tabs            | By role (§5.4)             | Android 8.0 (API 26)                    |
| Android tablet      | MO, MC  | Yes, with four columns    | By role                    | Android 8.0 (API 26)                    |
| Windows desktop app | MO, MC  | Yes, with four columns    | By role                    | Windows 10 or 11, 64-bit                |
| Owner web portal    | MO only | No: a read-only live view | Everything an owner can do | Current Chrome, Edge, Firefox or Safari |

- The Android and Windows apps MUST have the same features and rules. They are one Flutter codebase, with native layers for ringing on Android and Windows (technology-stack §12).
- Layout follows the window width, not the platform: at 840 dp or wider, the orders screen shows four columns; below that it shows tabs (§6.2).

## 4.2 Distribution and updates

- **Android:** through Google Play where it is available, and as a signed APK from the FOX DROP website. Both use the same signing certificate, so either can update the other. FOX DROP's Google Play account is available (technology-stack T3); the APK serves phones without Google Play.
- **Windows:** a signed installer from the FOX DROP website. The app updates itself: it downloads in the background and installs on the next restart. It never restarts while a ring or a pickup prompt is open, or while the restaurant has active orders.
- **Version check:** at launch and on every reconnect, the app compares its version with `app.merchant.min_version` and `app.merchant.latest_version` (AP §9.14).
  - Below the minimum: a blocking update screen with the download link for the platform.
  - Below the latest: a dismissible update banner.
- OWN SHOULD publish forced updates outside peak hours. A restaurant whose devices are all below the minimum version has no receiving device (§4.6).

## 4.3 Real-time connection and waking up

- **Connection:** every signed-in device keeps a WebSocket connection to the server, subscribed to its restaurant's channel. It sends a heartbeat every 20 seconds (fixed). The server marks a device disconnected after 60 seconds without a heartbeat (fixed).
- **Android background:** a foreground service keeps the connection open and allows ringing while the app is in the background or the screen is off. It shows a permanent notification, «FOX DROP يستقبل طلباتك». The service starts again after a reboot and after an app update.
- **Android push:** a high-priority push message is a second channel for new orders, pickup requests and cancellations. It wakes the app if the system killed the service. The app MUST NOT depend on push alone, because Google services may be missing or unreliable on some devices (§21).
- **Windows:**
  - The app starts with Windows (on by default; the device check covers it).
  - It runs in the system tray. Closing the window minimizes it to the tray.
  - Quitting asks for confirmation: «إغلاق التطبيق يوقف استقبال الطلبات على هذا الجهاز. هل أنت متأكد؟»
  - A ring brings the window to the front. Where Windows blocks that, the taskbar button flashes. A native Windows notification is shown as well.
- **Reconnect:** after any reconnect, the app fetches the full current state (active orders, restaurant state, open prompts) before showing it, so no event is missed.
- **Ordering:** every order event carries the order's version number. The app ignores an event older than the version it already shows.

## 4.4 Sounds and alert levels

| Level  | Arabic  | Behaviour                                                                                                                                                                         | Used for                                                                          |
| ------ | ------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| Ring   | «رنين»  | Loops until someone handles it. On Android, a full-screen prompt where the system allows it (§4.5), otherwise a heads-up notification. On Windows, the window comes to the front. | New order, pickup request, cancellation after acceptance, an edit that adds items |
| Chime  | «تنبيه» | Plays once, with a notification                                                                                                                                                   | The events marked Chime in §16                                                    |
| Silent | «صامت»  | A notification or a screen update only                                                                                                                                            | The events marked Silent in §16                                                   |

- **Stopping a ring:** a ring stops on every device of the restaurant as soon as any device handles it (accept, reject, confirm, dispute, acknowledge), or when its condition ends (for example the order was auto-cancelled or operations accepted it).
- **Several rings at once:** one sound loop plays. The prompts stack, oldest first, with a counter.
- **Volume:** on Android, ring sounds play through the alarm audio stream, so the media volume and the ringer's silent mode do not mute them. Do Not Disturb may still silence them; the device check covers this. On Windows, the sound plays through the default output device.
- **Owner devices:** each owner device has «الرنين على هذا الجهاز» (ring on this device), on by default. When it is off, ring events reach that device as silent notifications. Cashier devices always ring (fixed). The setting affects only that device.
- **Sound files:** distinct, fixed sounds for a new order, a pickup request, a cancellation or edit, and a chime. They are bundled with the app.

## 4.5 Device check «فحص الجهاز»

The device check runs at the first sign-in on each device, and can be run again from Settings. Each step explains what to do with screenshots, including the settings path for common phone brands (Samsung, Xiaomi/Redmi/Poco, Huawei/Honor, Oppo/Realme, Vivo).

| #   | Check                                                                                       | Android                      | Windows                             |
| --- | ------------------------------------------------------------------------------------------- | ---------------------------- | ----------------------------------- |
| 1   | Notifications allowed                                                                       | Yes                          | Yes                                 |
| 2   | Battery optimisation off for the app                                                        | Yes                          | —                                   |
| 3   | Auto-start allowed (brand setting)                                                          | Yes, where the brand has one | Start with Windows on               |
| 4   | Full-screen notifications allowed (Android 14+)                                             | Yes                          | —                                   |
| 5   | Alarm volume at least 70% and Do Not Disturb off or allowing the app                        | Yes                          | Output not muted                    |
| 6   | The computer does not sleep during opening hours                                            | —                            | SHOULD read the power plan and warn |
| 7   | Test ring: the device plays the new-order sound and the user taps «سمعت الصوت» (I heard it) | Yes                          | Yes                                 |
| 8   | Server connection and its delay                                                             | Yes                          | Yes                                 |

- Checks 1–6 are read again automatically each time the app opens. If any check fails, a yellow banner stays on the orders screen: «هذا الجهاز قد لا يرن عند وصول طلب — أكمل فحص الجهاز».
- The result of each device's last check is sent to the server and shown in the panel (AP §9.6.4).
- At least one device MUST pass the check before a restaurant can be activated (AP §9.6.3).

## 4.6 Receiving devices and the no-device alert

- A device counts as a **receiving device** when it is signed in, connected (§4.3), has ringing on (§4.4), and runs a version at or above the minimum (§4.2).
- While the restaurant's operating state is open or busy (§7), if it has no receiving device for `merchant.no_device_alert_min` (5) minutes:
  - operations get the warning «مطعم مفتوح بلا جهاز استقبال» (restaurant open with no receiving device) (AP §9.1.3)
  - owners get a push on all their devices: «لا يوجد جهاز يستقبل الطلبات في مطعمك الآن»
  - the alert resolves itself when a receiving device connects or the restaurant stops being open
- The server does not pause the restaurant for this. The unanswered-order rule (§8.3) still applies.

## 4.7 Unstable internet

- **Safe retries:** every command carries a client-generated idempotency key. The app retries with backoff until the server answers. A command repeated with the same key is never applied twice.
- **Pending state:** while waiting, the button shows «جارٍ الإرسال…» and cannot be pressed again.
- **State conflicts:** the server checks every command against the current state when it arrives. If the state changed, the server returns the current state and the app explains what happened, for example «قُبل الطلب من جهاز {اسم الجهاز}» or «أُلغي الطلب قبل وصول قبولك».
- **Lost connection:** a red bar shows on every screen: «لا يوجد اتصال بالإنترنت — لن تصلك الطلبات الجديدة حتى يعود الاتصال». After 30 seconds offline (fixed), the device plays a chime once.
- **Clocks:** all countdowns use server time. The app measures the offset between its clock and the server's and corrects every timer, so a wrong phone clock never changes a countdown.
- **Images:** menu photos are cached on the device.

## 4.8 Formatting

As in AP §4.7: Arabic, right to left, Western digits, money with its currency symbol (`400 ₺`), dates as `dd/mm/yyyy`, 12-hour times with «ص/م», durations as «12 د» and «45 ث». Order numbers as `#10423`, receipts as `AZ-2026-000123`, tickets as `T-5521` (AP §4.8).

The app SHOULD stay usable with the system font enlarged up to 130%.

## 4.9 Business day

Daily counts and reports use the city's business day (AP §4.3; cutoff 06:00 by default). This covers:

- «اليوم» (today) in reports
- the unanswered-order counter
- items marked «غير متوفر حتى الغد», which become available again at the cutoff (§9.3)
- the Saturday statement, which closes at the Saturday cutoff (§12.3)

## 4.10 Maintenance and terms

- **Maintenance:** when `app.merchant.maintenance` is on, every device shows a blocking screen with the maintenance message (AP §9.14).
- **Terms:** when a new version of the restaurant terms is published (AP §9.13):
  - an owner must accept it on their next open, in the app or the portal, before using any screen other than Orders
  - owner devices keep ringing and keep the Orders screen until then, and cashier devices are not affected, so orders keep arriving (S13)
