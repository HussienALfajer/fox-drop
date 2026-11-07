# packages/core_auth

Phone sign-in and the app session of the three Flutter apps (architecture §11.2, §15.1; CU §5.2–5.4, RA §5.2–5.3, CA §4.9). The server side is the identity module (`apps/server/src/modules/identity/CLAUDE.md`).

## Layout

- `auth_party.dart`: `AuthParty`, one app's sign-in routes on the generated client (`CustomerAuth`, `MerchantAuth`, `CaptainAuth`), and `AuthRefusal`, a refused call with the server's `error`.
- `auth_scope.dart`: `AuthScope`, one app's providers (the party, the secure store, the session, the sign-in steps, the support numbers, the link launcher). Each app makes one as a top-level `final` in `lib/src/auth.dart`.
- `session.dart`: `SessionController` (the tokens and the device id in `core_storage`) and `AuthInterceptor`.
- `sign_in.dart`: `SignInController`, the steps' logic; `sign_in_screen.dart`: the unstyled screen that shows them.
- `phone.dart`: the number rules of CU §5.2 item 1.

## Rules

- **Two clients per app,** both from `apiClient` (`client.dart`): the party's client carries no interceptor (its calls run before a session exists, or renew it); the app's `coreApiProvider` client carries `scope.interceptor`. Never put the interceptor on the party's client: a 401 of a refresh would refresh again. `receiveTimeout` (20 s) stays above the server's 10-second wait for the WhatsApp sender, or a slow send would read as no answer and «لديّ رمز من العمليات» would never show (a test pins it).
- **One refresh at a time** (architecture §15.1): `SessionController.refresh` shares one call between callers. A try waits `refreshTryTimeout` (3 s); one with no answer, or the proxy's 502, 503 or 504 without an API error (`AuthRefusal.unanswered`), is tried again with the same token only while `refreshRetryWindow` (7 s) has not passed since the first try, so every try reaches the server within its 10-second grace (`REFRESH_RETRY_GRACE_SECONDS`); a later try would be a reuse that ends the session. A `401` ends the session (`other_device` for a captain signed in elsewhere, `ended` otherwise). Any other failure keeps the session.
- **The access token** is renewed `refreshAhead` (1 minute) before it expires, on this device's clock: `AuthParty.localExpiry` moves the server's expiry by the answer's `Server-Time`, so a wrong phone clock neither refreshes at every call nor sends expired tokens. A `401` on a call renews once and repeats the call; `401 other_device` ends the session at once.
- **Stored as one value:** the tokens and the account id are one JSON value under `session`, so a crash never leaves a new access token beside a used refresh token; an unreadable value starts signed out. The device id is its own key and outlives sign-outs.
- **Never stuck:** Dio does not await an interceptor's handlers, so every path of `AuthInterceptor` calls its handler, errors included; `SignInController` turns any failure into a refusal (`AuthRefusal.failed`), never a busy screen.
- **Presentation apart from logic** (design stop): the screen only reads `SignInState` and calls `SignInController`; every string comes from `core_l10n`. Refusal codes map to strings in `sign_in_screen.dart`.
- **«لديّ رمز من العمليات»** (RA §5.2, CA §4.9; owner decisions 2026-11-07): `offersOperationsCode` in the captain and restaurant apps; after `503 unavailable` it opens the code step with no code sent, with «اتصال بالعمليات» from `GET /v1/{party}/contact`. A `429 resend_wait` at the number opens the code step too: a code is still open, such as an emergency code, which a request never replaces.
- Tests answer the client with `FakeServer` (`package:core_auth/testing.dart`, for tests only) and override `scope.store` with `MemorySecureStore`, so they need no server or device.
