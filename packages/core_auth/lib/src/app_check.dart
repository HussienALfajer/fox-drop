import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Gives the Firebase App Check token a code request carries as
/// `X-Firebase-AppCheck` (architecture §8.3.3 item 1), or null for none.
typedef AppCheckToken = Future<String?> Function();

/// No App Check: builds without a Firebase project, and platforms App Check
/// does not cover here (the restaurant app on Windows, iOS until its slice).
Future<String?> noAppCheckToken() async => null;

/// How long a code request waits for its token before it goes without one,
/// and the server decides (`otp.app_check_required`).
const appCheckTokenTimeout = Duration(seconds: 10);

/// Starts Firebase and App Check from the build's `--dart-define` values
/// (owner decision 2026-11-07: no `google-services.json` in the public
/// repository): `FIREBASE_PROJECT_ID`, `FIREBASE_PROJECT_NUMBER`,
/// `FIREBASE_API_KEY` and the app's `FIREBASE_APP_ID`. None of them is a
/// secret; every `--dart-define` ships inside the app.
///
/// Android only (owner decision 2026-11-07). A release build attests with
/// Play Integrity; a debug build uses App Check's debug provider, whose
/// token the owner registers in Firebase for one device, so it never passes
/// in production. Without `FIREBASE_APP_ID`, or when Firebase fails to
/// start, code requests carry no token.
Future<AppCheckToken> startAppCheck() async {
  const appId = String.fromEnvironment('FIREBASE_APP_ID');
  if (appId.isEmpty ||
      kIsWeb ||
      defaultTargetPlatform != TargetPlatform.android) {
    return noAppCheckToken;
  }
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: String.fromEnvironment('FIREBASE_API_KEY'),
        appId: appId,
        messagingSenderId: String.fromEnvironment('FIREBASE_PROJECT_NUMBER'),
        projectId: String.fromEnvironment('FIREBASE_PROJECT_ID'),
      ),
    );
    await FirebaseAppCheck.instance.activate(
      providerAndroid: kDebugMode
          ? const AndroidDebugProvider()
          : const AndroidPlayIntegrityProvider(),
    );
  } on Object catch (error) {
    debugPrint('App Check did not start: $error');
    return noAppCheckToken;
  }
  return firebaseAppCheckToken;
}

/// The SDK's token, cached and renewed by Firebase; null when attestation
/// fails or takes longer than [appCheckTokenTimeout].
Future<String?> firebaseAppCheckToken() =>
    guardedAppCheckToken(FirebaseAppCheck.instance.getToken);

/// [source]'s token, or null when it fails or takes longer than [timeout]:
/// the code request then goes without one.
Future<String?> guardedAppCheckToken(
  Future<String?> Function() source, {
  Duration timeout = appCheckTokenTimeout,
}) async {
  try {
    return await source().timeout(timeout);
  } on Object catch (error) {
    debugPrint('No App Check token: $error');
    return null;
  }
}
