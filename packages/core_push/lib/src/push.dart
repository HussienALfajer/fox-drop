import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// What a push opens on a tap: the data the server sent with it (`target`
/// and its ids, such as `{target: order, orderId: …}`), as strings.
typedef PushData = Map<String, String>;

/// The app installation's push messaging (architecture §8.1): its token, the
/// Firebase Installation ID (FID) FCM sends to, and the pushes the person
/// taps. The system shows the notification itself
/// while the app is in the background or closed.
abstract interface class Push {
  /// Registers the installation with FCM and gives its token, or null when
  /// it has none.
  Future<String?> token();

  /// Each token FCM registers the installation with after [token].
  Stream<String> get tokenRefreshes;

  /// The push whose tap started the app, or null.
  Future<PushData?> initialTap();

  /// The pushes tapped while the app runs in the background.
  Stream<PushData> get taps;

  /// The pushes that arrive while the app is in the foreground, which the
  /// system does not show: an app acts on the ones it must (the customer's
  /// door ping, CU §11.7).
  Stream<PushData> get received;
}

/// No push: builds without a Firebase project, and platforms push does not
/// cover yet (iOS, Windows).
class NoPush implements Push {
  const NoPush();

  @override
  Future<String?> token() async => null;

  @override
  Stream<String> get tokenRefreshes => const Stream.empty();

  @override
  Future<PushData?> initialTap() async => null;

  @override
  Stream<PushData> get taps => const Stream.empty();

  @override
  Stream<PushData> get received => const Stream.empty();
}

/// Push through FCM on the Firebase app `startAppCheck` started from the
/// build's values (`packages/core_auth/CLAUDE.md`); Android only for now
/// (owner decision 2026-11-07). Call after `startAppCheck`.
Push startPush() {
  if (kIsWeb ||
      defaultTargetPlatform != TargetPlatform.android ||
      Firebase.apps.isEmpty) {
    return const NoPush();
  }
  return FirebasePush();
}

/// [Push] on `firebase_messaging` 17, which deprecates FCM's registration
/// tokens for the Firebase Installation ID: the app registers, and the server
/// sends to the installation's `fid`.
class FirebasePush implements Push {
  FirebaseMessaging get _messaging => FirebaseMessaging.instance;

  @override
  Future<String?> token() async {
    await _messaging.register();
    return FirebaseInstallations.instance.getId();
  }

  @override
  Stream<String> get tokenRefreshes => _messaging.onRegistered;

  @override
  Future<PushData?> initialTap() async {
    final message = await _messaging.getInitialMessage();
    return message == null ? null : _data(message);
  }

  @override
  Stream<PushData> get taps => FirebaseMessaging.onMessageOpenedApp.map(_data);

  @override
  Stream<PushData> get received => FirebaseMessaging.onMessage.map(_data);

  static PushData _data(RemoteMessage message) => {
    for (final entry in message.data.entries)
      if (entry.value != null) entry.key: '${entry.value}',
  };
}
