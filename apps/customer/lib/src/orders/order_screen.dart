import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../emergency_stop.dart';
import '../notifications/notifications_off_banner.dart';
import 'order_again_section.dart';
import 'order_live.dart';

/// The order screen (CU §11): the status title and subtitle of §11.2, the
/// five-step progress, the time, the captain card from assignment and the
/// summary, kept live over the order's channel. The map, «مساعدة»,
/// «إلغاء الطلب», the other banners and the rating sheet come with their slices.
/// Unstyled until the design.
class OrderScreen extends ConsumerWidget {
  const OrderScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(orderProvider(orderId)).value;
    final order = state?.value;
    if (order == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: state?.failed ?? false
              ? TextButton(
                  onPressed: () =>
                      ref.read(orderFeedProvider(orderId)).refresh(),
                  child: Text(l10n.customerTryAgain),
                )
              : const CircularProgressIndicator(),
        ),
      );
    }
    final (title, subtitle) = titleTexts(l10n, order);
    final step = stepOf(order.status.name);
    final captain = order.captain;
    final ended = endedStatuses.contains(order.status.name);
    String total() => [
      l10n.formatMoney(order.money.total, order.currency),
      for (final e in order.equivalents) l10n.formatMoney(e.amount, e.currency),
    ].join(' / ');

    return Scaffold(
      appBar: AppBar(title: Text(l10n.customerOrderNumber(order.number))),
      body: RefreshIndicator(
        onRefresh: () => ref.read(orderFeedProvider(orderId)).refresh(),
        child: ListView(
          children: [
            ListTile(
              key: const Key('order-status'),
              title: Text(title),
              subtitle: subtitle == null ? null : Text(subtitle),
            ),
            // CU §11.9: a rejected or unanswered order.
            OrderAgainSection(order: order),
            // CU §11.6: the emergency stop's delay notice.
            if (!ended) EmergencyDelayNotice(orderId: orderId),
            // CU §4.4: notifications refused at the first order.
            if (!ended) const NotificationsOffBanner(),
            if (step != null)
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  children: [
                    for (final s in OrderStep.values)
                      Chip(
                        key: Key('step-${s.name}'),
                        // Done, current, or still ahead (CU §11.1); a
                        // delivered order has every step done.
                        avatar: Icon(
                          s.index < step.index || step == OrderStep.delivered
                              ? Icons.check_circle
                              : s == step
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                        ),
                        label: Text(stepText(l10n, s)),
                      ),
                  ],
                ),
              ),
            if (!ended)
              ListTile(
                title: Text(
                  order.promisedAt == null
                      ? l10n.customerArrivesWithin(
                          order.estimate.fromMin,
                          order.estimate.toMin,
                        )
                      : l10n.customerArrivesAbout(
                          l10n.formatTime(order.promisedAt!),
                        ),
                ),
              ),
            if (captain != null && !ended)
              ListTile(
                key: const Key('captain-card'),
                title: Text(captain.firstName),
                subtitle: Text(l10n.vehicleName(captain.vehicle.name)),
              ),
            // CU §11.7: at the door, the amount due large, with equivalents.
            if (order.status.name == 'arrived')
              ListTile(
                title: Text(
                  total(),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ListTile(title: Text(order.restaurant.nameAr)),
            for (final line in order.lines)
              ListTile(
                title: Text('${line.quantity} × ${line.name}'),
                subtitle: line.options.isEmpty && line.note == null
                    ? null
                    : Text(
                        [
                          if (line.options.isNotEmpty)
                            line.options.map((o) => o.name).join('، '),
                          ?line.note,
                        ].join('\n'),
                      ),
                trailing: Text(
                  l10n.formatMoney(line.lineTotal, order.currency),
                ),
              ),
            ListTile(
              title: Text(order.address.street),
              subtitle: Text(order.address.landmark),
            ),
            ListTile(title: Text(l10n.customerTotal), trailing: Text(total())),
          ],
        ),
      ),
    );
  }
}

/// CU §11.2 and §11.9 as strings.
(String, String?) titleTexts(AppLocalizations l10n, CustomerOrder order) {
  return switch (titleOf(order)) {
    AwaitingRestaurant(:final restaurant) => (
      l10n.customerStatusPlaced,
      l10n.customerOrderSent(restaurant),
    ),
    Preparing(:final promisedAt, :final captain, :final captainThere) => (
      l10n.customerStatusAccepted,
      captain != null
          ? (captainThere
                ? l10n.customerCaptainAtRestaurant(captain)
                : l10n.customerCaptainToRestaurant(captain))
          : promisedAt == null
          ? null
          : l10n.customerArrivesAbout(l10n.formatTime(promisedAt)),
    ),
    ReadyForCaptain(:final captainThere) => (
      l10n.customerStatusReady,
      captainThere
          ? l10n.customerCaptainCollecting
          : l10n.customerAwaitingCaptain,
    ),
    OnTheWay(:final captain) => (
      l10n.customerStatusPickedUp,
      l10n.customerCaptainPickedUp(captain),
    ),
    AtDoor() => (
      l10n.customerStatusArrived,
      l10n.customerPrepareAmount(
        l10n.formatMoney(order.money.total, order.currency),
      ),
    ),
    Delivered() => (l10n.customerStatusDelivered, l10n.customerEnjoy),
    NoRestaurantResponse() => (l10n.customerNoRestaurantResponse, null),
    Rejected(:final text) => (l10n.customerRejected, text),
    Cancelled(:final text) => (l10n.customerCancelled, text),
    Failed() => (l10n.customerDeliveryFailed, null),
  };
}

String stepText(AppLocalizations l10n, OrderStep step) => switch (step) {
  OrderStep.confirm => l10n.customerStepConfirm,
  OrderStep.preparing => l10n.customerStepPreparing,
  OrderStep.onTheWay => l10n.customerStepOnTheWay,
  OrderStep.atDoor => l10n.customerStepAtDoor,
  OrderStep.delivered => l10n.customerStepDelivered,
};

/// A status as the active-order bar names it (CU §6, Appendix B).
String statusText(AppLocalizations l10n, String status) => switch (status) {
  'placed' => l10n.customerStatusPlaced,
  'accepted' => l10n.customerStatusAccepted,
  'ready' => l10n.customerStatusReady,
  'pickedUp' || 'picked_up' => l10n.customerStatusPickedUp,
  'arrived' => l10n.customerStatusArrived,
  _ => l10n.customerStatusDelivered,
};
