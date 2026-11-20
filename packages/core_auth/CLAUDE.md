# packages/core_auth

Phone sign-in and the app session of the three Flutter apps (architecture §11.2, §15.1; CU §5.2–5.4, RA §5.2–5.3, CA §4.9). The server side is the identity module (`apps/server/src/modules/identity/CLAUDE.md`).

## Rules

- **Layout:** `auth_party.dart` (one app's sign-in routes on the generated client, `AuthRefusal`), `auth_scope.dart` (`AuthScope`: each app makes one as a top-level `final` in `lib/src/auth.dart`), `session.dart` (`SessionController`, `AuthInterceptor`), `sign_in.dart` (`SignInController`) and the unstyled `sign_in_screen.dart`, `phone.dart`, `app_check.dart`.
- **Two clients per app,** both from `apiClient` (`client.dart`): the party's client carries no interceptor; the app's `coreApiProvider` client carries `scope.interceptor`. Never put the interceptor on the party's client: a 401 of a refresh would refresh again. `receiveTimeout` (20 s) stays above the server's 10-second wait for the WhatsApp sender (a test pins it).
- **One refresh at a time:** `SessionController.refresh` shares one call between callers. A retry with the same token is allowed only within `refreshRetryWindow` (7 s) of the first try, since a later try would be a reuse that ends the session. A `401` ends the session; any other failure keeps it.
- **The access token** is renewed 1 minute before it expires, on this device's clock: `AuthParty.localExpiry` shifts the server's expiry by the answer's `Server-Time`, so a wrong phone clock does no harm. A `401` renews once and repeats the call; `401 other_device` ends the session at once.
- **Stored as one value:** the tokens and account id are one JSON value under `session`, so a crash never leaves a new access token beside a used refresh token; an unreadable value starts signed out. The device id is its own key and outlives sign-outs.
- **Never stuck:** every path of `AuthInterceptor` calls its handler, errors included (Dio does not await handlers); `SignInController` turns any failure into `AuthRefusal.failed`, never a busy screen.
- **Presentation apart from logic** (design stop): the screen only reads `SignInState` and calls `SignInController`; every string comes from `core_l10n`; refusal codes map to strings in `sign_in_screen.dart`.
- **App Check:** each app's `main` awaits `startAppCheck()` and overrides `scope.appCheck`; only `AuthParty.requestCode` sends the token (`X-Firebase-AppCheck`). Firebase starts from `--dart-define` values (`FIREBASE_APP_ID`, `FIREBASE_PROJECT_ID`, `FIREBASE_PROJECT_NUMBER`, `FIREBASE_API_KEY`), never from `google-services.json`. A missing, failed or slow (10 s) token is not sent; the server decides.
- **`join: true`** reaches only `CaptainAuth`; the other apps never pass it.
- **Tests** answer the client with `FakeServer` (`package:core_auth/testing.dart`) and override `scope.store` with `MemorySecureStore` and `scope.appCheck` with a fake, so they need no server or device.

## More

Behaviour, decisions and slice history: `docs/code/packages/core_auth.md`. Grep it for the feature, route, table or label you are changing and read only those lines; never read it whole.
