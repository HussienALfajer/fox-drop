# 11. Flutter apps: shared foundation (E5)

> Part of the [technology stack](README.md). A bare "§n" here means §n of the technology stack.

## 11.1 Repository

- The Flutter apps live in the single repository (T6, §19.1) as a **Dart pub workspace**, with **Melos** for scripts.
- Three apps: `apps/merchant` (Android, Windows), `apps/captain` (Android, iOS), `apps/customer` (Android, iOS).
- Flutter stable channel, the same version pinned for all three apps (FVM).

## 11.2 Shared packages

As built (aligned with the code on 2026-11-27, §2 T17):

| Package         | Contains                                                                                                                                                                         |
| --------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `core_api`      | The Dart client generated from OpenAPI (`openapi-generator`, `dart-dio`, `built_value` models), `Idempotency-Key` and app-version headers                                        |
| `core_realtime` | The Centrifugo client (`centrifuge`), `LiveFeed`: subscription, recovery, full re-fetch after reconnect, version ordering of events                                              |
| `core_commands` | The outgoing command queue, kept in `core_storage` so it survives a restart: idempotency keys, retries with exponential backoff and jitter, «جارٍ الإرسال…», conflicts (RA §4.7) |
| `core_time`     | Server clock offset from `Server-Time`; every countdown uses it                                                                                                                  |
| `core_storage`  | `shared_preferences` for small caches and queues (`DeviceStore`), `flutter_secure_storage` for tokens; a database (Drift) when a cache outgrows it (when needed)                 |
| `core_tokens`   | The design tokens in plain Dart, generated from `packages/design-tokens` (§9.2)                                                                                                  |
| `core_ui`       | The design system (§9.7): the theme only since D.R1 (T16)                                                                                                                        |
| `core_l10n`     | Arabic strings (ARB files), formatters for money, dates, durations and distances (AP §4.7), the country list                                                                     |
| `core_maps`     | The map interface on `maplibre_gl`, the shared style from `/maps/`, route drawing                                                                                                |
| `core_platform` | The forced update, maintenance, terms and the emergency stop (CU §4.2, §4.7, RA §4.2)                                                                                            |
| `core_alerts`   | The native ringing layer: alarm audio stream, full-screen intents, foreground services, the device checks' readers, Windows tray and window control (§12, §14)                   |
| `core_push`     | FCM registration, token refresh, notification channels, the notification permission                                                                                              |
| `core_auth`     | The phone rules for every country (D.11a), App Check, session handling and the auth interceptor; the sign-in screen returns with its approved drawing (D.R1, T16)                |
| `fox_lints`     | The analyzer rules R2 and R5 (§9.5) and their compiled check                                                                                                                     |

The device-check guides live in each app (`device_check/`, `receiving/`) on `core_alerts`' readers. Error reporting and analytics in the apps come with slice L.6 (§16), in a package of their own then.

## 11.3 Libraries

| Concern                        | Choice                                                                                                                    |
| ------------------------------ | ------------------------------------------------------------------------------------------------------------------------- |
| State and dependency injection | **Riverpod** (`flutter_riverpod`; one state library, never mixed; BeeOrder shipped three, research §10)                   |
| Navigation and deep links      | **go_router**                                                                                                             |
| Models                         | `built_value`, from the generated client; the apps' own state in plain Dart classes                                       |
| HTTP                           | **Dio** (inside `core_api`)                                                                                               |
| Images                         | `cached_network_image` with sizes from imgproxy; `image_picker` with its size and quality limits for photos the apps send |
| Location                       | `geolocator`; `flutter_background_geolocation` for the captain's tracking (§14.1)                                         |
| Permissions                    | `permission_handler`, plus native checks in `core_alerts`                                                                 |
| Phones                         | `phone_numbers_parser` (in `core_auth`)                                                                                   |
| Device and sharing             | `package_info_plus`, `wakelock_plus`, `share_plus`, `url_launcher`                                                        |
| Code push                      | **Shorebird** for urgent Dart fixes without a store release (when needed, §22 item 8)                                     |
| Crash and error reporting      | **Sentry**, with slice L.6 (§16)                                                                                          |
| Analytics                      | **PostHog** (no session replay with keystrokes; research §1 item 22), with slice L.6 (§16)                                |

## 11.4 Builds and distribution

- **Android:** one signing key per app, kept in a hardware-backed key store and in CI secrets. Google Play App Signing uses an upload key; the APK on the FOX DROP website is signed with the same app signing key, so either can update the other (RA §4.2).
- **iOS:** automatic signing in CI with an App Store Connect API key and `xcodebuild`, uploaded to TestFlight (the `staging-ios` job, slice 2.46); no fastlane.
- **Windows:** MSIX is not used; see §12.3.
- **Release pipeline:** GitHub Actions builds every app per tag, runs tests, uploads to Play (internal track first), TestFlight, and the website. Release notes in Arabic.
- **Flavors:** development, staging, production, each with its own Firebase project, API URL and app ID suffix.
