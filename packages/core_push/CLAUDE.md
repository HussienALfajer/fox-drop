# packages/core_push

Push notifications of the three Flutter apps (architecture §8.1–8.2, §11.2; CU §14, RA §16, CA §14). The server side is the notifications module (`apps/server/src/modules/notifications/CLAUDE.md`, «Push tokens», «The push relay»).

## Layout

- `push.dart`: `Push` (the installation's token, its renewals and the taps), `NoPush`, `FirebasePush` and `startPush`.
- `notification_permission.dart`: `NotificationPermission`, the phone's permission to show notifications (Android 13's `POST_NOTIFICATIONS`, on `permission_handler`), and the way to its settings.
- `push_tokens.dart`: `PushTokens`, the token kept registered with the server while the app is signed in.
- `testing.dart` (tests only): `FakePush` and `FakeNotificationPermission`, which a test drives.

## Rules

- **Firebase:** `startPush()` runs after `startAppCheck()` (`packages/core_auth/CLAUDE.md`), on the Firebase app it started from the build's `--dart-define` values; without one (no `FIREBASE_APP_ID`), on iOS and on Windows it gives `NoPush`. Android only until the iOS slice (APNs, architecture §8.1).
- **The token is the Firebase Installation ID** (FID): `firebase_messaging` 17 deprecates FCM's registration tokens, so `FirebasePush.token()` registers the installation (`register()`) and reads its FID, and `onRegistered` gives the later ones. The server sends to `fid` (`fcm-sender.ts`).
- **Registration** (`PUT /v1/{party}/push-token`): each app gives `PushTokens` its call on the generated client, and calls `signedIn()` whenever its session is signed in (every start with a stored session, and each sign-in) and `signedOut()` otherwise. A failed call, or Firebase failing to give a token, is tried again, 5 s doubling to 5 minutes, while signed in; a renewal replaces the retry. One token is sent once per sign-in (`register()` also gives it on `onRegistered`). The server ties the token to the session, so signing out needs no call.
- **What the system shows:** pushes are FCM notifications on the Android channel of their level (`default`, `ring`, `chime`, `offer`, `cancellation`, `silent`; architecture §8.2). Each app creates the channels it receives natively in its `MainActivity`, since a channel must exist before a push arrives while the app is closed; their names are system texts (`res/values/strings.xml`), like the launcher name. While the app runs, the sounds that ring (RA §4.4, CA §4.4) are its own; while it cannot, the channel's sound stands in (architecture §8.2), such as the customer's `ring` channel with the phone's ringtone for «الكابتن عند الباب» (CU §14 row 5) until the app has its own sounds.
- **The permission:** when each app asks is its spec's (the customer's first order, CU §4.4, Q11); each app declares `android.permission.POST_NOTIFICATIONS` in its manifest, or Android 13 never asks.
- **Taps:** `initialTap()` (the push that started the app) and `taps` (while it runs in the background) give the push's data (`target` and its ids); each app maps it to a route. A push that arrives while the app is in the foreground is not shown: the app's screens are live.
