import 'package:core_auth/core_auth.dart';
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
  final push = startPush();
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
