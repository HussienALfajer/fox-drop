import 'package:core_l10n/core_l10n.dart';
import 'package:core_platform/core_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'board/alerts.dart';
import 'platform.dart';
import 'receiving/prompts.dart';
import 'receiving/receiving.dart';
import 'push.dart';
import 'router.dart';
import 'status/status.dart';
import 'terms.dart';
import 'windows/update.dart';

/// The restaurant app «تطبيق المطعم»: Arabic only, right to left (AP §4.7).
class MerchantApp extends ConsumerWidget {
  const MerchantApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Push (RA §16): the token registered while signed in, the permission
    // at the first sign-in, and a tapped push opening its order.
    ref.watch(pushTokensProvider);
    ref.watch(notificationAskProvider);
    ref.watch(pushTapsProvider);
    // RA §4.10: a new version of the terms asks the owner on the next open.
    ref.watch(termsPromptProvider);
    final platform = ref.watch(platformCheckProvider);
    // RA §18: the platform broadcasts, and "on every reconnect" (RA §4.2).
    ref.watch(platformBroadcastsProvider);
    // RA §16 #3, #24, #25: the restaurant's state changes chime.
    ref.watch(statusChimesProvider);
    // RA §4.3–4.5 (slice 2.42): the receiving service while signed in, the
    // ring and the chimes whatever screen shows (or none, with the screen
    // off), and the device check at the first sign-in.
    ref.watch(receivingProvider);
    ref.watch(boardAlertsProvider);
    ref.watch(deviceCheckPromptProvider);
    // RA §4.2 on Windows (slice 2.44): the self-update, outside active orders.
    ref.watch(windowsUpdateProvider);
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      routerConfig: router,
      // RA §4.2: the suggested update's banner over every screen.
      // RA §4.7: the offline bar over every screen.
      builder: (context, child) => UpdateBannerFrame(
        check: platform,
        url: updateUrl(),
        child: OfflineFrame(child: child!),
      ),
      onGenerateTitle: (context) =>
          AppLocalizations.of(context).merchantAppName,
      locale: const Locale('ar'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}
