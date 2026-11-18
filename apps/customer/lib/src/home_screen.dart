import 'package:core_auth/core_auth.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:core_maps/core_maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'account/account_banners.dart';
import 'auth.dart';
import 'browsing/home_sections.dart';
import 'cart/cart.dart';
import 'emergency_stop.dart';
import 'location/delivery_point.dart';
import 'location/pin.dart';
import 'location/position.dart';
import 'orders/order_live.dart';
import 'orders/order_screen.dart';
import 'terms.dart';

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
    // «اختر على الخريطة» (CU §7.1): from the point the customer has, else
    // the city; the customer can choose another point at any time (§7.2).
    Future<void> chooseOnMap() async {
      final camera = point is PointChecked
          ? MapCamera(point.point, streetZoom)
          : const MapCamera(cityCentre, cityZoom);
      final chosen = await context.push<GeoPoint>(pinPath(camera));
      if (chosen != null) {
        await ref.read(deliveryPointProvider.notifier).usePin(chosen);
      }
    }

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
          // CU §6.1, §12.3 «طلباتي».
          if (signedIn)
            TextButton(
              key: const Key('open-my-orders'),
              onPressed: () => context.push('/orders'),
              child: Text(l10n.customerMyOrdersTitle),
            ),
          // CU §13 «حسابي»: the codes, the notifications, the help and
          // signing out.
          if (signedIn)
            TextButton(
              key: const Key('open-account'),
              onPressed: () => context.push('/account'),
              child: Text(l10n.customerMyAccountTitle),
            )
          else
            TextButton(
              onPressed: () => context.go('/sign-in'),
              child: Text(l10n.signInTitle),
            ),
        ],
      ),
      // CU §6: the active-order bar while an order is active.
      bottomNavigationBar: signedIn ? const ActiveOrdersBar() : null,
      body: Column(
        children: [
          // CU §5.5 (slice 2.25a): the block, the dues and the review stop.
          const AccountStateBanners(),
          // CU §6.2 item 2: the emergency stop's browsing message.
          const EmergencyStopNotice(),
          // CU §6.2 item 5: terms waiting for acceptance.
          if (ref.watch(termsPendingProvider))
            ListTile(
              key: const Key('terms-pending'),
              title: Text(l10n.customerTermsPending),
              trailing: TextButton(
                onPressed: () => context.push('/terms'),
                child: Text(l10n.customerTermsShow),
              ),
            ),
          // CU §8.3: the search box on the home header, while the point is
          // served.
          if (point case PointChecked(coverage: PointCoverage.served))
            ListTile(
              key: const Key('open-search'),
              leading: const Icon(Icons.search),
              title: Text(l10n.customerSearchHint),
              onTap: () => context.push('/search'),
            ),
          Expanded(child: _body(point, l10n, locate, chooseOnMap, ref)),
          // CU §13 «الشروط والخصوصية», until «حسابي» exists.
          TextButton(
            key: const Key('open-terms'),
            onPressed: () => context.push('/terms'),
            child: Text(l10n.termsTitle),
          ),
        ],
      ),
    );
  }

  Widget _body(
    DeliveryPointState point,
    AppLocalizations l10n,
    VoidCallback locate,
    VoidCallback chooseOnMap,
    WidgetRef ref,
  ) => switch (point) {
    PointUnset() => _Message(
      text: l10n.customerWhereToDeliver,
      action: l10n.customerUseMyLocation,
      onAction: locate,
      onMap: chooseOnMap,
    ),
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
      onMap: chooseOnMap,
    ),
    // CU §8.1: the sections in the panel's order (slice 2.27b).
    PointChecked(coverage: PointCoverage.served) => const HomeSections(),
    PointChecked(coverage: PointCoverage.noRestaurants) => _Message(
      text: l10n.customerNoRestaurantsHere,
      action: l10n.customerUseMyLocation,
      onAction: locate,
      onMap: chooseOnMap,
    ),
    PointChecked(coverage: PointCoverage.outsideZones, :final voted) =>
      _Message(
        text: voted ? l10n.customerVoteThanks : l10n.customerComingSoon,
        action: voted ? l10n.customerUseMyLocation : l10n.customerVote,
        onAction: voted
            ? locate
            : ref.read(deliveryPointProvider.notifier).vote,
        onMap: chooseOnMap,
      ),
  };
}

/// CU §6: «طلبك من {المطعم}: {الحالة}», or the count with a list when
/// several orders are active. Also on the update and maintenance screen,
/// where an active order stays readable (CU §4.2, §4.7).
class ActiveOrdersBar extends ConsumerWidget {
  const ActiveOrdersBar({super.key});

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

class _Message extends StatelessWidget {
  const _Message({
    required this.text,
    required this.action,
    required this.onAction,
    required this.onMap,
  });

  final String text;
  final String action;
  final VoidCallback onAction;

  /// «اختر على الخريطة» (CU §7.1, §7.2).
  final VoidCallback onMap;

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
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: onMap,
              child: Text(AppLocalizations.of(context).customerChooseOnMap),
            ),
          ],
        ),
      ),
    );
  }
}
