import 'dart:async';

import 'package:core_l10n/core_l10n.dart';
import 'package:core_maps/core_maps.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import 'location.dart';
import 'work.dart';

/// The map of a route (`packages/core_maps`); tests draw a fake.
final routeMapProvider = Provider<RouteMapBuilder>(
  (ref) => maplibreRouteMap(mapStyleUrl(apiBaseUrl(), debug: kDebugMode)),
);

/// A leg of the active order (CA §9.2: step 1, to the restaurant; CA §9.5:
/// step 3, to the customer).
typedef LegKey = ({String orderId, String leg});

/// What the server answered for a leg: the arrival time (the read's moment
/// on the server clock plus the leg's duration, so it stays true while the
/// leg lasts) and the route line, null when the routing service did not
/// answer (the straight line × 1.3 then gives the time alone).
class LegRoute {
  const LegRoute({required this.arriveAt, required this.line});

  final DateTime arriveAt;
  final List<GeoPoint>? line;
}

/// How long a leg waits to read its route again after a failed read, or one
/// without the captain's point yet.
const legRetry = Duration(seconds: 30);

/// The leg's route, read once per leg (CA §4.6: light data) and kept while
/// the leg lasts; a failed read, or one before the captain's first point,
/// leaves the map without a line or a time and reads again after
/// [legRetry].
final legRouteProvider = FutureProvider.family<LegRoute?, LegKey>((
  ref,
  key,
) async {
  final clock = ref.read(serverClockProvider);
  void retryLater() {
    final timer = Timer(legRetry, ref.invalidateSelf);
    ref.onDispose(timer.cancel);
  }

  try {
    final answer = await ref
        .watch(coreApiProvider)
        .getCaptainApi()
        .captainOrderRouteRoute(orderId: key.orderId);
    final route = answer.data!.route;
    if (route == null) {
      retryLater();
      return null;
    }
    return LegRoute(
      arriveAt: clock.now().add(Duration(seconds: route.seconds)),
      line: route.line
          ?.map((p) => GeoPoint(p.latitude.toDouble(), p.longitude.toDouble()))
          .toList(),
    );
  } catch (_) {
    retryLater();
    rethrow;
  }
});

/// The map's markers and line: the destination (the restaurant or the
/// customer's pin), the captain at the latest fix when there is one, and the
/// route line when the server gave it.
RouteView legView({
  required MapMarkerKind destinationKind,
  required GeoPoint destination,
  required Fix? fix,
  required LegRoute? route,
}) => RouteView(
  markers: [
    MapMarker(destinationKind, destination),
    if (fix != null)
      MapMarker(MapMarkerKind.captain, GeoPoint(fix.latitude, fix.longitude)),
  ],
  line: route?.line,
);

/// The map and the ETA of a step (CA §9.2, §9.5); «ابدأ الملاحة» stays the
/// step's own button (CA §4.6: the map is for overview).
class LegMap extends ConsumerWidget {
  const LegMap({super.key, required this.order, required this.toCustomer});

  final ActiveOrder order;
  final bool toCustomer;

  static const height = 220.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final destination = toCustomer
        ? GeoPoint(
            order.customer.location.latitude.toDouble(),
            order.customer.location.longitude.toDouble(),
          )
        : GeoPoint(
            order.restaurant.location.latitude.toDouble(),
            order.restaurant.location.longitude.toDouble(),
          );
    final key = (
      orderId: order.id,
      leg: toCustomer ? 'to_customer' : 'to_restaurant',
    );
    final route = ref.watch(legRouteProvider(key)).value;
    final view = legView(
      destinationKind: toCustomer
          ? MapMarkerKind.destination
          : MapMarkerKind.restaurant,
      destination: destination,
      fix: ref.watch(latestFixProvider).value,
      route: route,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: height,
          child: ref.watch(routeMapProvider)(view: view),
        ),
        if (route != null)
          Text(
            l10n.captainEta(l10n.formatTime(route.arriveAt)),
            key: const Key('eta'),
          ),
      ],
    );
  }
}
