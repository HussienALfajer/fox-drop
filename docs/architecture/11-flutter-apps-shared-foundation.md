# 11. Flutter apps: shared foundation (E5)

> Part of the [technology stack](README.md). A bare "§n" here means §n of the technology stack.

## 11.1 Repository

- The Flutter apps live in the single repository (T6, §19.1) as a **Dart pub workspace**, with **Melos** for scripts.
- Three apps: `apps/merchant` (Android, Windows), `apps/captain` (Android, iOS), `apps/customer` (Android, iOS).
- Flutter stable channel, the same version pinned for all three apps (FVM).

## 11.2 Shared packages

| Package              | Contains                                                                                                                                                |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `core_api`           | The Dart client generated from OpenAPI, auth interceptors, `Idempotency-Key` and app-version headers                                                    |
| `core_realtime`      | The Centrifugo client, subscription management, recovery, full re-fetch after reconnect, version ordering of events                                     |
| `core_commands`      | The outgoing command queue in SQLite: idempotency keys, retries with exponential backoff and jitter, «جارٍ الإرسال…» state, conflict handling (RA §4.7) |
| `core_time`          | Server clock offset from `Server-Time`; every countdown uses it                                                                                         |
| `core_storage`       | **Drift** (SQLite) for caches and queues, `flutter_secure_storage` for tokens                                                                           |
| `core_ui`            | The design system (§9.3)                                                                                                                                |
| `core_l10n`          | Arabic strings (ARB files), formatters for money, dates, durations and distances (AP §4.7)                                                              |
| `core_maps`          | The map interface on `maplibre_gl`, tile caching, route drawing                                                                                         |
| `core_device_check`  | The device-check framework and the per-brand guides with screenshots (RA §4.5, CA §4.5)                                                                 |
| `core_alerts`        | The native ringing layer: alarm audio stream, full-screen intents, foreground services, Windows tray and window control (§12, §14)                      |
| `core_push`          | FCM registration, token refresh, notification channels                                                                                                  |
| `core_auth`          | Phone input for +963 and +90, the WhatsApp code screen, session handling                                                                                |
| `core_observability` | Sentry setup, PostHog events, structured logs                                                                                                           |

## 11.3 Libraries

| Concern                        | Choice                                                                                        |
| ------------------------------ | --------------------------------------------------------------------------------------------- |
| State and dependency injection | **Riverpod** (one state library, never mixed; BeeOrder shipped three, research §10)           |
| Navigation and deep links      | **go_router**                                                                                 |
| Models                         | **freezed** and **json_serializable**                                                         |
| HTTP                           | **Dio** (inside `core_api`)                                                                   |
| Images                         | `cached_network_image` with sizes from imgproxy                                               |
| Permissions                    | `permission_handler`, plus native checks in `core_alerts`                                     |
| Code push                      | **Shorebird** for urgent Dart fixes without a store release; works for store and APK installs |
| Crash and error reporting      | **Sentry**                                                                                    |
| Analytics                      | **PostHog** (no session replay with keystrokes; research §1 item 22)                          |

## 11.4 Builds and distribution

- **Android:** one signing key per app, kept in a hardware-backed key store and in CI secrets. Google Play App Signing uses an upload key; the APK on the FOX DROP website is signed with the same app signing key, so either can update the other (RA §4.2).
- **iOS:** App Store Connect with automatic signing in CI (fastlane match).
- **Windows:** MSIX is not used; see §12.3.
- **Release pipeline:** GitHub Actions builds every app per tag, runs tests, uploads to Play (internal track first), TestFlight, and the website. Release notes in Arabic.
- **Flavors:** development, staging, production, each with its own Firebase project, API URL and app ID suffix.
