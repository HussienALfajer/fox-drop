# 13. Customer app (Android and iOS)

> Part of the [technology stack](README.md). A bare "§n" here means §n of the technology stack.

- Flutter on the shared foundation (§11). BeeOrder also uses Flutter (research §10); FOX DROP's app is leaner: one state library, no shipped secrets, no keystroke session replay, a smaller binary (research §11 items 1 and 5).
- **Lists first, extras after** (CU §4.5): restaurant lists render from the Drift cache, then refresh; estimates and fees fill in later.
- **Live tracking:** `order:{id}` channel; the captain marker moves smoothly between 10 s updates; the route comes from the server (OSRM) once per leg.
- **Location** only while using the app (CU §4.4) through `geolocator`; the far-pin check runs on the device (CU §7.5).
- **Notifications** asked at the first order (CU §4.4).
- **Deep links** for codes and banners with `app_links`.
- **App size target:** under 25 MB download on Android (split per ABI).
