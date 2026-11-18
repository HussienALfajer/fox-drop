import 'package:core_auth/core_auth.dart';
import 'package:core_push/core_push.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/api.dart';
import 'src/app.dart';
import 'src/auth.dart';
import 'src/device_id.dart';
import 'src/notifications/push.dart';

Future<void> main() async {
  // A release build without API_BASE_URL stops here, before its first screen.
  apiBaseUrl();
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase App Check for the code requests (packages/core_auth/CLAUDE.md).
  final appCheck = await startAppCheck();
  // Push on the Firebase app App Check started (packages/core_push/CLAUDE.md).
  final push = startPush(background: acknowledgeInBackground);
  runApp(
    ProviderScope(
      overrides: [
        customerAuth.appCheck.overrideWithValue(appCheck),
        customerAuth.stableDeviceId.overrideWithValue(customerDeviceId),
        pushProvider.overrideWithValue(push),
      ],
      child: const CustomerApp(),
    ),
  );
}

/// AP §9.11.4 «وصل»: a mass push that arrives while the app is in the
/// background or closed is acknowledged from FCM's isolate, which has no
/// providers: the public receipt route on a client of its own.
@pragma('vm:entry-point')
Future<void> acknowledgeInBackground(RemoteMessage message) =>
    acknowledgePush(apiClient(apiBaseUrl()), pushDataOf(message));
