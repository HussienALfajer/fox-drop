import 'dart:async';

import 'package:core_l10n/core_l10n.dart';
import 'package:core_platform/core_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'platform.dart';
import 'push.dart';
import 'router.dart';
import 'board/board.dart';

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
    final platform = ref.watch(platformCheckProvider);
    // "On every reconnect" (RA §4.2): the channel coming back checks again.
    ref.listen(boardProvider, (previous, next) {
      if (previous?.value?.live == false && next.value?.live == true) {
        unawaited(platform.check());
      }
    });
    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
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
