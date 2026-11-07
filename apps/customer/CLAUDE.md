# apps/customer

The customer app «تطبيق الزبون» (Android, iOS), a Flutter app in the Dart pub workspace (architecture §11, §13). `apps/captain` (Android, iOS) and `apps/merchant` (Android, Windows) follow the same rules.

## Layout

- `lib/main.dart`: runs the app inside a Riverpod `ProviderScope`.
- `lib/src/app.dart`: `MaterialApp.router`, fixed to Arabic. `lib/src/router.dart`: the go_router routes, as a provider.
- `lib/src/api.dart`: the API client providers and the server address. `lib/src/auth.dart`: the app's `AuthScope` (`packages/core_auth/CLAUDE.md`). One screen per file next to them, until a feature needs a folder.
- `test/`: widget tests, run by `flutter test`.
- `android/`, `ios/`, `windows/`: written by `flutter create` with the app ID `com.foxdrop.<app>` (owner decision 2026-11-05). Edit them only for a reason, and say it in a comment.

## Rules

- **Libraries (architecture §11.3):** Riverpod for state and dependency injection, go_router for navigation; no other state library, no `Navigator.push` for screens. Every dependency is pinned to an exact version; a package shared with another member of the workspace takes the same version.
- **API (E6):** call the server only through `coreApiProvider` (the generated `core_api` client, with the session's interceptor) inside a provider; never Dio or `http` by hand. `authApiProvider`, without the interceptor, serves only the app's `AuthParty`. Tests replace both with `FakeServer` clients (`package:core_auth/testing.dart`) and the scope's `store` with `MemorySecureStore`, so they need no server or device.
- **Session and routes (slice 1.14b):** the router redirects on the scope's session: `/starting` while it is read, `/sign-in` when signed out (the customer app lets guests stay, CU §5.1), home once signed in. The restaurant app sends a signed-in device without a name to `/device-name` (RA §5.2 item 5); the captain's sign-in screen shows «سُجّل دخولك من جهاز آخر» after `other_device` (CA §4.9).
- **Server address:** `--dart-define=API_BASE_URL=http://<address>:3000`. Without it a debug build uses the development machine (owner decision 2026-11-05): `10.0.2.2:3000` on the Android emulator, `localhost:3000` on iOS Simulator and Windows; a phone needs the machine's address. A release build refuses to start without it: `main()` reads the address before `runApp`. Flavors (development, staging, production, architecture §11.4) come with the deploy slice. Plain HTTP is allowed only in the Android debug manifest and, on iOS, for the local network (`NSAllowsLocalNetworking`). Never put a key or secret in the app (E7): every `--dart-define` ships inside it.
- **Arabic, right to left (AP §4.7):** every user-facing string is a getter of `AppLocalizations` from `core_l10n` (`packages/core_l10n/CLAUDE.md`); never a string literal in a widget. The app's `locale` is `ar`, so Flutter lays it out right to left. Use `EdgeInsetsDirectional`, `AlignmentDirectional` and `start`/`end`, never `left`/`right`. The launcher name is the only text outside ARB: `android:label` in `AndroidManifest.xml`, `CFBundleDisplayName` in `Info.plist`, and the window title in `windows/runner/main.cpp`.
- **Design stop:** no `core_ui`, theme, colours, fonts or styling until the owner says the UI/UX and the design system are ready (root `CLAUDE.md`). Screens use plain Material widgets with their defaults.

## Commands

From the app's folder, with the pinned Flutter (`.fvm/flutter_sdk/bin` first on `PATH`), after `docker compose up --detach` and the server on port 3000:

- `flutter run`: on the running emulator, simulator or (merchant) `-d windows`.
- `flutter test` and `dart analyze --fatal-infos`: what `pnpm verify` runs for every Flutter package through Melos.
