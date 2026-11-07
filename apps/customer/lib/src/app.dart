import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'checkout/place_order.dart';
import 'router.dart';

/// The customer app «تطبيق الزبون»: Arabic only, right to left (AP §4.7).
class CustomerApp extends ConsumerWidget {
  const CustomerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    // A placed order opens its screen wherever the customer is: leaving
    // checkout never cancels the command (CU §10.7 item 7).
    ref.listen(placeOrderProvider, (previous, next) {
      if (next is PlacePlaced) {
        ref.read(placeOrderProvider.notifier).done();
        router.go('/orders/${next.orderId}');
      }
    });
    return MaterialApp.router(
      routerConfig: router,
      onGenerateTitle: (context) =>
          AppLocalizations.of(context).customerAppName,
      locale: const Locale('ar'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}
