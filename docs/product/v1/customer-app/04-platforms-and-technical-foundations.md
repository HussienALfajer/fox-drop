# 4. Platforms and technical foundations

> Part of the [customer app spec](README.md) (CU). A bare "§n" here means CU §n.

## 4.1 Platforms

| Platform      | Minimum              | Notes         |
| ------------- | -------------------- | ------------- |
| Android phone | Android 8.0 (API 26) | Full features |
| iPhone        | iOS 15               | Same features |

- Both apps MUST have the same features and rules. They are one Flutter codebase, as in CA §4.1 (technology-stack §13).
- Phones, portrait. The layout MUST not break on a tablet.

## 4.2 Distribution and updates

- **Android:** Google Play, and a signed APK on the FOX DROP website for phones without Play, with the same signing certificate (as RA §4.2).
- **iPhone:** the App Store. FOX DROP's Apple Developer account is available (technology-stack T3).
- **Version check:** at launch and on every reconnect, the app compares its version with `app.customer.min_version` and `app.customer.latest_version` (AP §9.14).
  - Below the minimum, a blocking update screen appears with `app.customer.update_message`. An active order's status screen stays readable, so the customer can follow it.
  - Below the latest, a dismissible banner appears.

## 4.3 Real time and push

- **Order updates:** while an order is active and the app is open, the app subscribes to the order on a WebSocket. On reconnect it fetches the current state, so no change is missed. If the socket is down while an order screen is open, the app polls every 30 seconds (fixed).
- **Captain position:** on the map it updates as the captain app sends it, every 10 seconds (AP §4.2).
- **Push:** FCM on Android and APNs on iOS, for status changes and messages (§14). The arrival and the captain's door ping use high-priority pushes. On iPhone they are time-sensitive notifications.
- **Promotional pushes** come from the panel's mass push (AP §9.11.4).

## 4.4 Location and permissions

- **Location:** «أثناء استخدام التطبيق» (while using the app) only, never in the background (fixed). The app uses it for:
  - the first location (§7.1)
  - «التوصيل إلى موقعي الحالي» (§7.4)
  - the far-pin check, which runs on the device (§7.5)
- Every use has a map alternative. A customer who refuses location can still choose a point on the map.
- The device's position is sent to the server only to check a chosen point against the zones, or to record a vote (§7.2). It is not stored with orders.
- **Notifications (Q11):** asked when the customer places their first order: «اسمح بالإشعارات لتعرف متى يصل طلبك». If refused, the order still goes, and the order screen shows a banner with a link to the phone's settings.
- **Camera and photos:** asked only when the customer adds a photo to a report (§12.2, §9.5).

## 4.5 Weak internet and cheap phones

- **Commands** (place an order, cancel, rate, report) carry an idempotency key and retry with backoff, and are never applied twice (as CA §4.6). While waiting, the button shows «جارٍ الإرسال…» and cannot be pressed again.
- **Lists first, extras after:** restaurant lists render from cache or a light call first, and estimates and fees fill in after (research §11 item 12). Skeletons show while loading.
- **Caching:** home sections, restaurant pages and menus are cached and refreshed in the background. A changed menu replaces the cached one on the next open.
- **Images:** served in sizes that fit the screen, compressed, and cached. A report photo is compressed before upload.
- **Lost connection:** a bar shows «لا يوجد اتصال بالإنترنت». Browsing works from the cache. Placing an order needs a connection.
- **Timers** shown to the customer use server time, as in RA §4.7.

## 4.6 Formatting

As in AP §4.7:

- Arabic, right to left, with Western digits.
- Money with its symbol, for example `410 ₺` or `10.00 $`.
- Dates as `dd/mm/yyyy`, and 12-hour times with «ص/م».
- Durations as «12 د».
- Order numbers as `#10423`, and tickets as `T-5521`.

Distances show as «850 م» below 1 km and «2.4 كم» above. The app SHOULD stay usable with the system font enlarged up to 130%.

## 4.7 Maintenance, terms, platform hours and the emergency stop

- **Maintenance:** when `app.customer.maintenance` is on, a blocking screen shows the message. An active order's status screen stays readable.
- **Terms:** a new version of the customer terms (AP §9.13) is shown on the next open. Browsing continues, but ordering waits until the customer accepts it.
- **Platform hours:** outside `platform.hours` (24/7 by default, AP D9), browsing continues. The order button is disabled with «FOX DROP يستقبل الطلبات من الساعة {الساعة}».
- **Emergency stop (AP §9.1.6):**
  - Browsing continues. The order button is disabled, and a banner shows the browsing message. A customer who opens checkout during the stop counts once per stop as an attempt (AP §9.1.6).
  - Customers with an active order get a push and a banner on the order screen with the delay notice.
  - When the stop ends, the banner disappears. A push about the service being back is sent only if OPS choose to send it.
