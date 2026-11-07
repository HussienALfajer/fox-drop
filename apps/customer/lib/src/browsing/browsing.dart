import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../location/delivery_point.dart';
import '../location/position.dart';

/// The browsing point, or null before the zone check found one.
GeoPoint? _browsingPoint(Ref ref) {
  final point = ref.watch(deliveryPointProvider);
  return point is PointChecked && point.coverage == PointCoverage.served
      ? point.point
      : null;
}

/// The cards of the restaurants that deliver to the point (CU §8.2), in the
/// server's order: open, then busy and paused, then closed.
final restaurantsProvider =
    FutureProvider.autoDispose<
      List<CustomerRestaurantListDtoOutputRestaurantsInner>
    >((ref) async {
      final point = _browsingPoint(ref);
      if (point == null) return const [];
      final response = await ref
          .watch(coreApiProvider)
          .getCustomerApi()
          .customerBrowsingList(
            latitude: '${point.latitude}',
            longitude: '${point.longitude}',
          );
      return response.data!.restaurants.toList();
    });

/// A restaurant's page and menu for the point (CU §9.1–9.3).
final restaurantPageProvider = FutureProvider.autoDispose
    .family<CustomerRestaurantPageDtoOutput?, String>((ref, id) async {
      final point = _browsingPoint(ref);
      if (point == null) return null;
      final response = await ref
          .watch(coreApiProvider)
          .getCustomerApi()
          .customerBrowsingPage(
            restaurantId: id,
            latitude: '${point.latitude}',
            longitude: '${point.longitude}',
          );
      return response.data;
    });

/// The restaurant's state as the list and the page give it.
class RestaurantState {
  const RestaurantState({
    required this.state,
    required this.busyMode,
    required this.until,
    required this.opensAt,
    required this.message,
  });

  factory RestaurantState.ofCard(
    CustomerRestaurantListDtoOutputRestaurantsInnerState s,
  ) => RestaurantState(
    state: s.state.name,
    busyMode: s.busyMode,
    until: s.until,
    opensAt: s.opensAt,
    message: s.message,
  );

  factory RestaurantState.ofQuote(CustomerQuoteDtoOutputRestaurant s) =>
      RestaurantState(
        state: s.state.name,
        busyMode: s.busyMode,
        until: s.until,
        opensAt: s.opensAt,
        message: s.message,
      );

  /// `open`, `busy`, `paused`, `closed` or `holiday` (RA §7.1).
  final String state;
  final bool busyMode;
  final DateTime? until;
  final DateTime? opensAt;

  /// The holiday's or operations' message (AP §9.6.5).
  final String? message;

  /// Items can go in the cart only while it is open (CU §9.2).
  bool get takesOrders => state == 'open';
}

/// The state's message of CU §9.2, or null while open without busy mode.
String? restaurantStateText(
  AppLocalizations l10n,
  RestaurantState s,
  DateTime now,
) {
  final extra = s.message == null ? '' : '\n${s.message}';
  final until = s.until;
  final opensAt = s.opensAt;
  return switch (s.state) {
    'open' => s.busyMode ? l10n.customerRestaurantBusyMode : null,
    'busy' => l10n.customerRestaurantBusy,
    'paused' =>
      (until == null
              ? l10n.customerRestaurantPausedSoon
              : l10n.customerRestaurantPausedFor(
                  l10n.durationMinutes(_minutesUntil(now, until)),
                )) +
          extra,
    'holiday' =>
      (until == null
              ? l10n.customerRestaurantClosed
              : l10n.customerRestaurantClosedUntil(l10n.formatDate(until))) +
          extra,
    _ =>
      opensAt == null
          ? l10n.customerRestaurantClosed
          : l10n.customerRestaurantOpensAt(
              l10n.weekdayOf(opensAt),
              l10n.formatTime(opensAt),
            ),
  };
}

/// A card's badge (CU §8.2), or null while open.
String? restaurantBadge(
  AppLocalizations l10n,
  RestaurantState s,
  DateTime now,
) => switch (s.state) {
  'open' => null,
  'busy' => l10n.customerBadgeBusy,
  'paused' => l10n.customerBadgePaused,
  _ => restaurantStateText(l10n, s, now),
};

int _minutesUntil(DateTime now, DateTime until) {
  final seconds = until.difference(now).inSeconds;
  return seconds <= 0 ? 1 : (seconds + 59) ~/ 60;
}

/// «30–40 د» (CU §8.4).
String estimateText(AppLocalizations l10n, int fromMin, int toMin) =>
    l10n.customerEstimate(fromMin, toMin);
