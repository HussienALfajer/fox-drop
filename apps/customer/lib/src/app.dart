import 'package:core_l10n/core_l10n.dart';
import 'package:core_platform/core_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'checkout/place_order.dart';
import 'notifications/push.dart';
import 'platform.dart';
import 'router.dart';
import 'terms.dart';

/// The customer app «تطبيق الزبون»: Arabic only, right to left (AP §4.7).
class CustomerApp extends ConsumerWidget {
  const CustomerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    // Push (CU §14): the token registered while signed in, and a tapped
    // push opening its order.
    ref.watch(pushTokensProvider);
    ref.watch(pushTapsProvider);
    // CU §11.7: a door ping while the app is open opens its ringing order.
    ref.watch(doorPingsProvider);
    // CU §4.7: a new version of the terms opens on the next open.
    ref.watch(termsPromptProvider);
    // A placed order opens its screen wherever the customer is: leaving
    // checkout never cancels the command (CU §10.7 item 7).
    ref.listen(placeOrderProvider, (previous, next) {
      if (next is PlacePlaced) {
        ref.read(placeOrderProvider.notifier).done();
        router.go('/orders/${next.orderId}');
      }
    });
    final platform = ref.watch(platformCheckProvider);
    return MaterialApp.router(
      routerConfig: router,
      // CU §4.2: the suggested update's banner over every screen.
      builder: (context, child) =>
          UpdateBannerFrame(check: platform, url: updateUrl(), child: child!),
      onGenerateTitle: (context) =>
          AppLocalizations.of(context).customerAppName,
      locale: const Locale('ar'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}
