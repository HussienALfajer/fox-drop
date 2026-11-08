import 'package:core_auth/core_auth.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'auth.dart';
import 'browsing/restaurant_list.dart';
import 'cart/cart.dart';
import 'location/delivery_point.dart';
import 'location/position.dart';
import 'orders/order_live.dart';
import 'orders/order_screen.dart';

/// Home (CU §7.1, §7.2, §8.1): the delivery point first, then the
/// restaurants that deliver to it. Unstyled until the design (the design
/// stop in the root CLAUDE.md).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final point = ref.watch(deliveryPointProvider);
    final signedIn = ref.watch(customerAuth.session).value is SignedIn;
    final locate = ref.read(deliveryPointProvider.notifier).useCurrentLocation;
    return Scaffold(
      appBar: AppBar(
        title: point is PointChecked
            ? TextButton(
                onPressed: locate,
                child: Text(point.zoneName ?? l10n.customerAppName),
              )
            : Text(l10n.customerAppName),
        actions: [
          // CU §13 «المساعدة»: the customer FAQ set.
          TextButton(
            onPressed: () => context.push('/faq'),
            child: Text(l10n.faqTitle),
          ),
          if (ref.watch(cartProvider).value?.cart case final cart?)
            TextButton(
              key: const Key('open-cart'),
              onPressed: () => context.push('/cart'),
              child: Text(l10n.customerCartCount(cart.lines.length)),
            ),
          // CU §13 «الإشعارات», until «حسابي» exists.
          if (signedIn)
            TextButton(
              key: const Key('open-notifications'),
              onPressed: () => context.push('/notifications'),
              child: Text(l10n.customerNotificationsTitle),
            ),
          if (signedIn)
            TextButton(
              onPressed: () =>
                  ref.read(customerAuth.session.notifier).signOut(),
              child: Text(l10n.signOut),
            )
          else
            TextButton(
              onPressed: () => context.go('/sign-in'),
              child: Text(l10n.signInTitle),
            ),
        ],
      ),
      // CU §6: the active-order bar while an order is active.
      bottomNavigationBar: signedIn ? const _ActiveOrders() : null,
      body: switch (point) {
        PointUnset() => _Ask(onLocate: locate),
        PointLocating() => const Center(child: CircularProgressIndicator()),
        PointUnavailable(:final failure) => _Message(
          text: switch (failure) {
            PositionFailure.serviceOff => l10n.customerLocationServiceOff,
            PositionFailure.denied => l10n.customerLocationDenied,
            PositionFailure.failed => l10n.customerLocationFailed,
            null => l10n.statusError,
          },
          action: l10n.customerTryAgain,
          onAction: locate,
        ),
        PointChecked(coverage: PointCoverage.served) => const RestaurantList(),
        PointChecked(coverage: PointCoverage.noRestaurants) => _Message(
          text: l10n.customerNoRestaurantsHere,
          action: l10n.customerUseMyLocation,
          onAction: locate,
        ),
        PointChecked(coverage: PointCoverage.outsideZones, :final voted) =>
          _Message(
            text: voted ? l10n.customerVoteThanks : l10n.customerComingSoon,
            action: voted ? l10n.customerUseMyLocation : l10n.customerVote,
            onAction: voted
                ? locate
                : ref.read(deliveryPointProvider.notifier).vote,
          ),
      },
    );
  }
}

/// CU §6: «طلبك من {المطعم}: {الحالة}», or the count with a list when
/// several orders are active.
class _ActiveOrders extends ConsumerWidget {
  const _ActiveOrders();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final orders = ref.watch(activeOrdersProvider).value ?? const [];
    if (orders.isEmpty) return const SizedBox.shrink();
    if (orders.length == 1) {
      final order = orders.single;
      return ListTile(
        key: const Key('active-order'),
        title: Text(
          l10n.customerActiveOrder(
            order.restaurant.nameAr,
            statusText(l10n, order.status.name),
          ),
        ),
        onTap: () => context.push('/orders/${order.id}'),
      );
    }
    return ExpansionTile(
      key: const Key('active-order'),
      title: Text(l10n.customerActiveOrders(orders.length)),
      children: [
        for (final order in orders)
          ListTile(
            title: Text(
              l10n.customerActiveOrder(
                order.restaurant.nameAr,
                statusText(l10n, order.status.name),
              ),
            ),
            onTap: () => context.push('/orders/${order.id}'),
          ),
      ],
    );
  }
}

/// «أين نوصل طلبك؟» (CU §7.1); the map choice waits for Phase 2.
class _Ask extends StatelessWidget {
  const _Ask({required this.onLocate});

  final VoidCallback onLocate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _Message(
      text: l10n.customerWhereToDeliver,
      action: l10n.customerUseMyLocation,
      onAction: onLocate,
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.text,
    required this.action,
    required this.onAction,
  });

  final String text;
  final String action;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onAction, child: Text(action)),
          ],
        ),
      ),
    );
  }
}
