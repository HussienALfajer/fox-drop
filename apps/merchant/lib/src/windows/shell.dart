import 'package:core_alerts/core_alerts.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../router.dart';
import '../settings/settings_parts.dart';

/// RA §4.3 on Windows (slice 2.44): the tray and the window, set up by
/// `main` before the first screen. Quitting asks first, over whatever screen
/// shows; with no screen yet it quits.
Future<void> setUpWindows(WindowsAlerts alerts, ProviderContainer container) {
  final l10n = lookupAppLocalizations(const Locale('ar'));
  return alerts.setUp(
    TrayTexts(
      tooltip: l10n.merchantTrayTooltip,
      open: l10n.merchantTrayOpen,
      quit: l10n.merchantTrayQuit,
    ),
    () async {
      final context = container
          .read(routerProvider)
          .routerDelegate
          .navigatorKey
          .currentContext;
      if (context == null || !context.mounted) return true;
      return confirm(context, l10n.merchantQuitConfirm, l10n.merchantTrayQuit);
    },
  );
}
