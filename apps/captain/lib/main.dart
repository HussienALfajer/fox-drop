import 'package:core_alerts/core_alerts.dart';
import 'package:core_auth/core_auth.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:core_push/core_push.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/api.dart';
import 'src/app.dart';
import 'src/auth.dart';
import 'src/push.dart';

Future<void> main() async {
  // A release build without API_BASE_URL stops here, before its first screen.
  apiBaseUrl();
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase App Check for the code requests (packages/core_auth/CLAUDE.md).
  final appCheck = await startAppCheck();
  // Push on the Firebase app App Check started (packages/core_push/CLAUDE.md).
  final push = startPush(background: ringOffer);
  runApp(
    ProviderScope(
      overrides: [
        captainAuth.appCheck.overrideWithValue(appCheck),
        pushProvider.overrideWithValue(push),
      ],
      child: const CaptainApp(),
    ),
  );
}

/// CA §4.4 (slice 2.43): an offer's push that arrives while the app is in
/// the background or closed rings from the push's own isolate, with the
/// bundled offer sound on the alarm stream, vibration and the prompt over
/// the lock screen, until the offer's end (`expiresAt` in its data, on this
/// phone's clock). Tapping the prompt opens the app, which shows the offer
/// and stops the ring once it is answered.
@pragma('vm:entry-point')
Future<void> ringOffer(RemoteMessage message) async {
  final stopAfter = offerRingTime(message.data, DateTime.now());
  if (stopAfter == null) return;
  final l10n = lookupAppLocalizations(const Locale('ar'));
  await const AndroidAlerts().ring(
    RingSound.offer,
    title: l10n.captainAppName,
    body: message.notification?.body ?? l10n.captainNewOffer,
    vibrate: true,
    stopAfter: stopAfter,
  );
}
