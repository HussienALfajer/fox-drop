# packages/core_push

Push notifications of the three Flutter apps (architecture §8.1–8.2, §11.2; CU §14, RA §16, CA §14). The server side is the notifications module (`apps/server/src/modules/notifications/CLAUDE.md`, «Push tokens», «The push relay»).

## Rules

- **Layout (`lib/src/`):** `push.dart` (`Push`, `NoPush`, `FirebasePush`, `startPush`), `notification_permission.dart`, `push_tokens.dart`. Tests use `FakePush` and `FakeNotificationPermission` from `lib/testing.dart`.
- **Start order:** `startPush()` runs after `startAppCheck()` (`packages/core_auth/CLAUDE.md`), on the Firebase app started from the build's `--dart-define` values. Without `FIREBASE_APP_ID`, and on Windows, it gives `NoPush`.
- **The token is the Firebase Installation ID** (FID), not an FCM registration token (`firebase_messaging` 17 deprecates those); the server sends to `fid`.
- **Registration** (`PUT /v1/{party}/push-token`): each app calls `PushTokens.signedIn()` whenever its session is signed in (every start with a stored session, each sign-in) and `signedOut()` otherwise. A failure is retried, 5 s doubling to 5 minutes, while signed in. The server ties the token to the session, so signing out needs no call.
- **Android channels:** pushes arrive on the channel of their level (`default`, `ring`, `chime`, `offer`, `cancellation`, `silent`; architecture §8.2). Each app creates the channels it receives natively in its `MainActivity`, since a channel must exist before a push arrives while the app is closed; their names are system texts (`res/values/strings.xml`). Android keeps a channel's sound and importance once it exists, so a changed sound needs a new channel id (sent by `channelOf` in the server's `push-relay.ts`) and the apps delete the old channel.
- **Permission:** each app declares `android.permission.POST_NOTIFICATIONS` in its manifest, or Android 13 never asks; when to ask is each spec's.
- **iOS:** FCM sends through APNs; the app carries the `aps-environment` entitlement and registers its token with `platform: ios`.
- **Foreground:** a push that arrives while the app is in the foreground is not shown (the screens are live); `received` gives its data for the few an app acts on.
- **Taps:** `initialTap()` and `taps` give the push's data (`target` and ids); each app maps it to a route.
- **Background:** `startPush(background: ...)` takes a top-level function marked `@pragma('vm:entry-point')`; it runs in its own isolate with no providers and no session.

## More

Behaviour, decisions and history: `docs/code/packages/core_push.md`. Grep it for what you change; never read it whole.
