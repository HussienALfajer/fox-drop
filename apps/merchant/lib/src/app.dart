import 'package:core_l10n/core_l10n.dart';
import 'package:core_platform/core_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'platform.dart';
import 'push.dart';
import 'router.dart';
import 'terms.dart';

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
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      routerConfig: router,
      // RA §4.2: the suggested update's banner over every screen.
      builder: (context, child) =>
          UpdateBannerFrame(check: platform, url: updateUrl(), child: child!),
      onGenerateTitle: (context) =>
          AppLocalizations.of(context).merchantAppName,
      locale: const Locale('ar'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}
