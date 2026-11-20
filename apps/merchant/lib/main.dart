import 'package:core_alerts/core_alerts.dart';
import 'package:core_auth/core_auth.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:core_push/core_push.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/api.dart';
import 'src/app.dart';
import 'src/auth.dart';
import 'src/board/alerts.dart';
import 'src/push.dart';
import 'src/windows/registration.dart';
import 'src/windows/shell.dart';

Future<void> main() async {
  // A release build without API_BASE_URL stops here, before its first screen.
  apiBaseUrl();
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase App Check for the code requests (packages/core_auth/CLAUDE.md).
  final appCheck = await startAppCheck();
  // Push on the Firebase app App Check started (packages/core_push/CLAUDE.md).
  final push = startPush(background: wakeReceiving);
  // Windows (architecture §12.3, slice 2.44): the tray, the window and the
  // ring's native layer.
  final windows = onWindows
      ? WindowsAlerts(
          appName: lookupAppLocalizations(const Locale('ar')).merchantAppName,
        )
      : null;
  final container = ProviderContainer(
    overrides: [
      merchantAuth.appCheck.overrideWithValue(appCheck),
      pushProvider.overrideWithValue(push),
      if (windows != null) alertsProvider.overrideWithValue(windows),
    ],
  );
  if (windows != null) await setUpWindows(windows, container);
  runApp(
    UncontrolledProviderScope(container: container, child: const MerchantApp()),
  );
}

/// RA §4.3: a high-priority push that arrives while the system ended the
/// app starts the receiving service again, which runs the app, so the order
/// rings from the board rather than only as the push's notification.
@pragma('vm:entry-point')
Future<void> wakeReceiving(RemoteMessage message) => AndroidAlerts.wake();
