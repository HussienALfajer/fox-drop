# apps/customer

The customer app «تطبيق الزبون» (Android, iOS), a Flutter app in the Dart pub workspace (architecture §11, §13). `apps/captain` (Android, iOS) and `apps/merchant` (Android, Windows) follow the same rules, so the rules below hold for all three.

## Rules

- **Layout:** `lib/main.dart` starts App Check and push, then runs the app in a Riverpod `ProviderScope`; `lib/src/app.dart` is `MaterialApp.router` in Arabic; `router.dart`, `api.dart` and `auth.dart` hold the routes, API providers and `AuthScope`. One screen per file, then feature folders (`cart/`, `checkout/`, `orders/`, `browsing/`): logic (providers, notifiers, pure functions) in plain files; each `*_screen.dart` or `*_sheet.dart` only reads that state and calls it.
- **Libraries (architecture §11.3):** Riverpod for state and injection, go_router for navigation; no other state library, no `Navigator.push` for screens. Pin every dependency to an exact version; a package another workspace member also uses takes the same version.
- **API (E6):** call the server only through `coreApiProvider` (the generated `core_api` client) inside a provider; never Dio or `http` by hand (the one exception is the report photo's `PUT` to a signed URL, `photoPutProvider`). `authApiProvider`, without the interceptor, serves only the app's `AuthParty`.
- **Money:** amounts arrive as minor-unit strings, formatted with `formatMoney`; generated money models are nullable in Dart (`price!`).
- **Commands:** a command's `Idempotency-Key` belongs to one command body: a lost answer resends the same key, a refusal or another body takes a new one. A problem's action finds its cart line by `CartLine.key`, never by index.
- **Live state:** a screen follows a server object through a `LiveFeed` (`packages/core_realtime/CLAUDE.md`) and never patches it; every countdown runs on `serverClockProvider` (`packages/core_time/CLAUDE.md`).
- **Reason lists:** never a constant. Each app reads `GET /v1/<app>/content` into `contentProvider`; the choice sends the code, shows the label and offers a text field when the reason takes a note. `unknown_reason` and the `reason_note_*` refusals mean the panel changed the list: read it again and ask again.
- **Tests:** replace both API clients with `FakeServer` clients (`package:core_auth/testing.dart`) and the scope's `store` with `MemorySecureStore`. Build the app with `TestApp` (`test/support.dart`) and its overrides. End a test that opens a live feed with `app.done(tester)`, so the feed's timers stop before Flutter checks for pending timers.
- **Server address:** `--dart-define=API_BASE_URL=http://<address>:3000`. A release build refuses to start without it. Never put a key or secret in the app (E7): every `--dart-define` ships inside it. Never hand out a release build signed with the debug key.
- **Native folders:** `android/`, `ios/` and `windows/` come from `flutter create`; edit them only for a reason, and say it in a comment.
- **Arabic, right to left (AP §4.7):** every user-facing string is a getter of `AppLocalizations` from `core_l10n` (`packages/core_l10n/CLAUDE.md`); never a literal in a widget. Use `EdgeInsetsDirectional`, `AlignmentDirectional` and `start`/`end`, never `left`/`right`. Only the launcher name and the system's permission texts stay outside ARB (`AndroidManifest.xml`, `Info.plist`).
- **Design stop:** no `core_ui`, theme, colours, fonts or styling until the owner says the UI/UX and the design system are ready (root `CLAUDE.md`). Screens use plain Material widgets with their defaults.

## Commands

From the app's folder, with the pinned Flutter (`.fvm/flutter_sdk/bin` first on `PATH`), after `docker compose up --detach` and the server on port 3000:

- `flutter run`: on the running emulator or simulator (`-d windows` for the merchant app).
- `flutter test` and `dart analyze --fatal-infos`: what `pnpm verify` runs for every Flutter package through Melos.

## More

Behaviour, decisions and history: `docs/code/apps/customer.md`. Grep it for what you change; never read it whole.
