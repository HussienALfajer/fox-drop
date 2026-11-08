import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'push.dart';
import 'router.dart';

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
    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
      onGenerateTitle: (context) =>
          AppLocalizations.of(context).merchantAppName,
      locale: const Locale('ar'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}
