# packages/core_auth

Phone sign-in and the app session of the three Flutter apps (architecture §11.2, §15.1; CU §5.2–5.4, RA §5.2–5.3, CA §4.9). The server side is the identity module (`apps/server/src/modules/identity/CLAUDE.md`).

## Layout

- `auth_party.dart`: `AuthParty`, one app's sign-in routes on the generated client (`CustomerAuth`, `MerchantAuth`, `CaptainAuth`), and `AuthRefusal`, a refused call with the server's `error`.
- `auth_scope.dart`: `AuthScope`, one app's providers (the party, the secure store, the session, the sign-in steps, the support numbers, the link launcher). Each app makes one as a top-level `final` in `lib/src/auth.dart`.
- `session.dart`: `SessionController` (the tokens and the device id in `core_storage`) and `AuthInterceptor`.
- `sign_in.dart`: `SignInController`, the steps' logic; `sign_in_screen.dart`: the unstyled screen that shows them.
- `phone.dart`: the number rules of CU §5.2 item 1.

## Rules

- **Two clients per app:** the party's client carries no interceptor (its calls run before a session exists, or renew it); the app's `coreApiProvider` client carries `scope.interceptor`. Never put the interceptor on the party's client: a 401 of a refresh would refresh again.
- **One refresh at a time** (architecture §15.1): `SessionController.refresh` shares one call between callers. A refresh with no answer is retried with the same token within the server's 10-second grace (`refreshRetryDelays`); a `401` ends the session (`other_device` for a captain signed in elsewhere, `ended` otherwise). Any other failure keeps the session.
- **The access token** is renewed `refreshAhead` (1 minute) before it expires; a `401` on a call renews once and repeats the call; `401 other_device` ends the session at once.
- **Presentation apart from logic** (design stop): the screen only reads `SignInState` and calls `SignInController`; every string comes from `core_l10n`. Refusal codes map to strings in `sign_in_screen.dart`.
- **«لديّ رمز من العمليات»** (RA §5.2, CA §4.9; owner decisions 2026-11-07): `offersOperationsCode` in the captain and restaurant apps; after `503 unavailable` it opens the code step with no code sent, with «اتصال بالعمليات» from `GET /v1/{party}/contact`. A `429 resend_wait` at the number opens the code step too: a code is still open, such as an emergency code, which a request never replaces.
- Tests answer the client with `test/fake_server.dart` and override `scope.store` with `MemorySecureStore`, so they need no server or device.
