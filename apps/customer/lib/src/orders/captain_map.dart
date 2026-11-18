import 'dart:async';

import 'package:core_maps/core_maps.dart';
import 'package:core_realtime/core_realtime.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';

/// The map of the captain's way (`packages/core_maps`); tests draw a fake.
final routeMapProvider = Provider<RouteMapBuilder>(
  (ref) => maplibreRouteMap(mapStyleUrl(apiBaseUrl(), debug: kDebugMode)),
);

/// The statuses the customer follows the captain in (CU §11.3, U12: from
/// the pickup until the order ends).
const followedStatuses = {'pickedUp', 'picked_up', 'arrived'};

/// The captain's way to the pin: where the captain is (null before their
/// first point), the pin, and the route line when the routing service
/// answered.
class Following {
  const Following({
    required this.captain,
    required this.captainAt,
    required this.destination,
    required this.line,
  });

  final GeoPoint? captain;
  final DateTime? captainAt;
  final GeoPoint destination;
  final List<GeoPoint>? line;

  /// The state after a `captain.position` publication: a point recorded
  /// before the one shown is dropped, since publications may arrive out of
  /// order.
  Following moved(GeoPoint point, DateTime at) {
    final shown = captainAt;
    if (shown != null && !at.isAfter(shown)) return this;
    return Following(
      captain: point,
      captainAt: at,
      destination: destination,
      line: line,
    );
  }

  /// What the map draws: the pin, the captain and the route line.
  RouteView get view => RouteView(
    markers: [
      MapMarker(MapMarkerKind.destination, destination),
      if (captain case final point?) MapMarker(MapMarkerKind.captain, point),
    ],
    line: line,
  );
}

/// The point of a `captain.position` publication of [orderId], or null for
/// any other publication.
({GeoPoint point, DateTime at})? positionOf(
  Map<String, Object?> data,
  String orderId,
) {
  if (data['type'] != 'captain.position' || data['orderId'] != orderId) {
    return null;
  }
  final latitude = data['latitude'];
  final longitude = data['longitude'];
  final at = DateTime.tryParse('${data['recordedAt']}');
  if (latitude is! num || longitude is! num || at == null) return null;
  return (point: GeoPoint(latitude.toDouble(), longitude.toDouble()), at: at);
}

/// How long the map waits to read the route again after a failed read.
const followRetry = Duration(seconds: 30);

/// CU §11.3, architecture §6.2: the captain's way, read from
/// `GET /v1/customer/orders/{orderId}/route` when the map opens, after a
/// later reconnect that did not recover and after a handover
/// (`order.handed_over`), then moved by each `captain.position` on
/// `order:{order_id}` (the order's feed ignores them: they carry no
/// version). A failed read leaves the map out and reads again after
/// [followRetry].
final followingProvider = StreamProvider.autoDispose.family<Following, String>((
  ref,
  orderId,
) {
  final api = ref.watch(coreApiProvider).getCustomerApi();
  final transport = ref.watch(realtimeTransportProvider);
  final controller = StreamController<Following>();
  Following? shown;
  Timer? retry;
  // The read at opening stands for the first subscription's.
  var sawUp = false;

  Future<void> read() async {
    retry?.cancel();
    try {
      final body = (await api.customerOrderRouteRoute(orderId: orderId)).data!;
      final captain = body.captain;
      var next = Following(
        captain: null,
        captainAt: null,
        destination: GeoPoint(
          body.destination.latitude.toDouble(),
          body.destination.longitude.toDouble(),
        ),
        line: body.route?.line
            ?.map(
              (p) => GeoPoint(p.latitude.toDouble(), p.longitude.toDouble()),
            )
            .toList(),
      );
      if (captain != null) {
        next = next.moved(
          GeoPoint(captain.latitude.toDouble(), captain.longitude.toDouble()),
          captain.recordedAt,
        );
      }
      // A position published while the read ran stays.
      if (shown case final before? when before.captainAt != null) {
        next = next.moved(before.captain!, before.captainAt!);
      }
      shown = next;
      if (!controller.isClosed) controller.add(next);
    } catch (_) {
      // Read again later, or at the next reconnect.
      if (!controller.isClosed) retry = Timer(followRetry, read);
    }
  }

  final signals = transport.channel('order:$orderId').listen((signal) {
    switch (signal) {
      case RealtimeUp(:final recovered):
        if (sawUp && !recovered) unawaited(read());
        sawUp = true;
      case RealtimePublication(:final data):
        // CA §9.10.1: the new captain's way from the receipt.
        if (data['type'] == 'order.handed_over') {
          unawaited(read());
          return;
        }
        final position = positionOf(data, orderId);
        final current = shown;
        if (position == null || current == null) return;
        final next = current.moved(position.point, position.at);
        if (identical(next, current)) return;
        shown = next;
        controller.add(next);
      case RealtimeDown():
        break;
    }
  });
  unawaited(read());
  ref.onDispose(() {
    retry?.cancel();
    unawaited(signals.cancel());
    unawaited(controller.close());
  });
  return controller.stream;
});

/// The map on the order screen from the pickup until the order ends (CU
/// §11.3): the captain's live position, the pin and the route line when
/// available. Nothing shows until the first read answers.
class CaptainMap extends ConsumerWidget {
  const CaptainMap({super.key, required this.orderId});

  final String orderId;

  static const height = 240.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final following = ref.watch(followingProvider(orderId)).value;
    if (following == null) return const SizedBox.shrink();
    return SizedBox(
      key: const Key('captain-map'),
      height: height,
      child: ref.watch(routeMapProvider)(view: following.view),
    );
  }
}
