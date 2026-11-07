import 'package:core_api/core_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../auth.dart';
import 'position.dart';

/// How long the app waits for the phone's first position.
const locateTimeLimit = Duration(seconds: 15);

/// A pin is accurate enough for an address within this many metres (CU
/// §7.4, fixed).
const accurateMetres = 100.0;

/// The zone check's answer (CU §7.1).
enum PointCoverage { served, noRestaurants, outsideZones }

sealed class DeliveryPointState {
  const DeliveryPointState();
}

/// «أين نوصل طلبك؟»: no point chosen yet.
class PointUnset extends DeliveryPointState {
  const PointUnset();
}

class PointLocating extends DeliveryPointState {
  const PointLocating();
}

/// No position, or the server did not answer the zone check.
class PointUnavailable extends DeliveryPointState {
  const PointUnavailable(this.failure);

  /// Null when the zone check failed.
  final PositionFailure? failure;
}

/// The point the customer browses with, and its zone check.
class PointChecked extends DeliveryPointState {
  const PointChecked({
    required this.point,
    required this.accuracyMetres,
    required this.coverage,
    required this.zoneName,
    this.addressId,
    this.voted = false,
  });

  final GeoPoint point;

  /// Null for a saved address's pin.
  final double? accuracyMetres;
  final PointCoverage coverage;
  final String? zoneName;

  /// The saved address the point came from (CU §10.3 item 1).
  final String? addressId;

  /// «شكراً، سنخبرك عندما نصل إلى منطقتك» after a vote (CU §7.2).
  final bool voted;

  PointChecked withVote() => PointChecked(
    point: point,
    accuracyMetres: accuracyMetres,
    coverage: coverage,
    zoneName: zoneName,
    addressId: addressId,
    voted: true,
  );
}

/// The delivery point for browsing and checkout (CU §7.1, §7.2; owner
/// decision 2026-11-07: from the phone's location, the map waits for Phase
/// 2). It lives while the app runs; each start asks again.
class DeliveryPointController extends Notifier<DeliveryPointState> {
  @override
  DeliveryPointState build() => const PointUnset();

  CustomerApi get _api => ref.read(coreApiProvider).getCustomerApi();

  /// «استخدم موقعي الحالي».
  Future<void> useCurrentLocation() async {
    if (state is PointLocating) return;
    state = const PointLocating();
    final result = await ref
        .read(positionSourceProvider)
        .current(timeLimit: locateTimeLimit);
    final fix = result.fix;
    if (fix == null) {
      state = PointUnavailable(result.failure);
      return;
    }
    await _check(fix.point, accuracyMetres: fix.accuracyMetres);
  }

  /// A saved address's pin (CU §10.3 item 1: changing the address at
  /// checkout changes the point used for browsing).
  Future<void> useAddress(String addressId, GeoPoint point) async {
    state = const PointLocating();
    await _check(point, addressId: addressId);
  }

  Future<void> _check(
    GeoPoint point, {
    double? accuracyMetres,
    String? addressId,
  }) async {
    try {
      final answer = (await _api.customerProfileLocation(
        latitude: '${point.latitude}',
        longitude: '${point.longitude}',
      )).data!;
      state = PointChecked(
        point: point,
        accuracyMetres: accuracyMetres,
        coverage: switch (answer.state) {
          CustomerLocationDtoOutputStateEnum.served => PointCoverage.served,
          CustomerLocationDtoOutputStateEnum.noRestaurants =>
            PointCoverage.noRestaurants,
          _ => PointCoverage.outsideZones,
        },
        zoneName: answer.zone?.name,
        addressId: addressId,
      );
    } on Object {
      state = const PointUnavailable(null);
    }
  }

  /// «صوّت لمنطقتك» (CU §7.2): once per point and device, which the server
  /// keeps; a repeat is thanked the same way.
  Future<void> vote() async {
    final checked = state;
    if (checked is! PointChecked || checked.voted) return;
    try {
      final deviceId = await ref.read(customerAuth.session.notifier).deviceId();
      await _api.customerProfileVote(
        customerZoneVoteDto: CustomerZoneVoteDto(
          (b) => b
            ..deviceId = deviceId
            ..location.latitude = checked.point.latitude
            ..location.longitude = checked.point.longitude,
        ),
      );
      if (identical(state, checked)) state = checked.withVote();
    } on Object {
      // The button stays; the customer can vote again.
    }
  }
}

final deliveryPointProvider =
    NotifierProvider<DeliveryPointController, DeliveryPointState>(
      DeliveryPointController.new,
    );
