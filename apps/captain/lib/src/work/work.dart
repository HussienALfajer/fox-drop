import 'package:core_api/core_api.dart';
import 'package:core_realtime/core_realtime.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';

typedef Availability = CaptainAvailabilityDtoOutput;
typedef AvailabilityState = CaptainAvailabilityDtoOutputAvailabilityStateEnum;
typedef NoOffersReason = CaptainAvailabilityDtoOutputAvailabilityReasonsEnum;
typedef Offer = CaptainCurrentOfferDtoOutputOffer;
typedef ActiveOrder = CaptainActiveOrderDtoOutputOrder;
typedef Track = CaptainActiveOrderDtoOutputOrderCaptainTrackEnum;
typedef PickupRequest = CaptainActiveOrderDtoOutputOrderPickupRequest;
typedef RequestStatus = CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum;
typedef RequestOutcome =
    CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum;
typedef Summary = CaptainDeliverySummaryDtoOutputSummary;

/// What the captain's screens show, always as the server answered it: the
/// availability (CA §7), the open offer (CA §8) and the active order (CA §9).
class Work {
  const Work({required this.availability, this.offer, this.order});

  final Availability availability;
  final Offer? offer;
  final ActiveOrder? order;

  AvailabilityState get state => availability.availability.state;

  /// Online in any way: the location is tracked (CA §4.3).
  bool get online =>
      state != AvailabilityState.offline &&
      state != AvailabilityState.suspended;
}

/// The step of the active order (CA §9.1), 1 to 4.
int stepOf(ActiveOrder order) => switch (order.captainTrack) {
  Track.atMerchant || Track.pickupPending => 2,
  Track.pickedUp => 3,
  Track.atCustomer || Track.done => 4,
  _ => 1,
};

/// The open pickup request (CA §9.4), or null.
PickupRequest? openRequest(ActiveOrder order) {
  final request = order.pickup.request;
  return request?.status == RequestStatus.open ? request : null;
}

/// The latest request the restaurant refused, while the captain is back at
/// the restaurant (CA §9.4 item 4), or null.
PickupRequest? refusedRequest(ActiveOrder order) {
  final request = order.pickup.request;
  return order.captainTrack == Track.atMerchant &&
          request?.status == RequestStatus.rejected
      ? request
      : null;
}

/// The captain's state kept current over `captain:{captain_id}` (CA §15):
/// fetched on opening, after each newer event and every reconnect without
/// recovery, and polled while the connection is down.
final workFeedProvider = Provider.autoDispose<LiveFeed<Work>?>((ref) {
  final session = ref.watch(captainSessionProvider).value;
  if (session == null) return null;
  final api = ref.watch(coreApiProvider).getCaptainApi();
  final feed = LiveFeed<Work>(
    transport: ref.watch(realtimeTransportProvider),
    channel: 'captain:${session.captainId}',
    fetch: () async {
      final (availability, offer, order) = await (
        api.captainAvailabilityState(),
        api.captainOffersCurrent(),
        api.captainOrdersActive(),
      ).wait;
      return Work(
        availability: availability.data!,
        offer: offer.data!.offer,
        order: order.data!.order,
      );
    },
    versions: (work) => {
      if (work.order case final order?) order.id: order.version,
    },
  );
  feed.start();
  ref.onDispose(feed.close);
  return feed;
});

/// The captain's latest state.
final workProvider = StreamProvider.autoDispose<LiveState<Work>>((ref) {
  final feed = ref.watch(workFeedProvider);
  if (feed == null) return const Stream.empty();
  return feed.watch();
});

/// Ticks once a second while watched: every countdown and «منذ» timer
/// watches it and reads the server clock (CA §4.6).
final tickProvider = StreamProvider.autoDispose<int>(
  (ref) => Stream.periodic(const Duration(seconds: 1), (count) => count),
);

/// Fetches the state again, after a command's answer.
void refreshWork(Ref ref) {
  if (ref.exists(workFeedProvider)) ref.read(workFeedProvider)?.refresh();
}
