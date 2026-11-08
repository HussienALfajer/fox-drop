import 'package:core_l10n/core_l10n.dart';
import 'package:core_platform/core_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'platform.dart';
import 'push.dart';
import 'router.dart';

/// The captain app «تطبيق الكابتن»: Arabic only, right to left (AP §4.7).
class CaptainApp extends ConsumerWidget {
  const CaptainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Push (CA §14): the token registered while signed in, and a tapped
    // offer or order opening home.
    ref.watch(pushTokensProvider);
    ref.watch(pushTapsProvider);
    final platform = ref.watch(platformCheckProvider);
    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
      // CA §4.2: the suggested update's banner over every screen.
      builder: (context, child) =>
          UpdateBannerFrame(check: platform, url: updateUrl(), child: child!),
      onGenerateTitle: (context) => AppLocalizations.of(context).captainAppName,
      locale: const Locale('ar'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}
