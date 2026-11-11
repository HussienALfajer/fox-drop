import 'package:core_api/core_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';

/// «أقصى مبلغ أحمله» (CA §10.5, C4, K2): the most the captain pays a
/// restaurant at pickup, in the city's base currency; null for no limit.
class MaxPickup {
  const MaxPickup({
    required this.limit,
    required this.answered,
    required this.currency,
  });

  /// Minor units, or null for no limit.
  final String? limit;

  /// Whether the captain has answered, a limit or none (K2: asked until
  /// then).
  final bool answered;

  /// The city's base, which the amount is typed in; null while it has none.
  final String? currency;
}

MaxPickup _of(CaptainMaxPickupDtoOutput dto) => MaxPickup(
  limit: dto.limit?.amount,
  answered: dto.answered,
  currency: dto.limit?.currency ?? dto.baseCurrency,
);

/// `GET` and `PUT /v1/captain/settings/max-pickup-amount`; a change applies
/// to the next offer.
class MaxPickupNotifier extends AsyncNotifier<MaxPickup> {
  CaptainApi get _api => ref.read(coreApiProvider).getCaptainApi();

  @override
  Future<MaxPickup> build() async =>
      _of((await _api.captainAvailabilityMaxPickup()).data!);

  /// Sets [minor] (null for no limit); false when the server did not take
  /// it (no signal, a city without a base).
  Future<bool> set(String? minor) async {
    try {
      final answer = await _api.captainAvailabilitySetMaxPickup(
        captainSetMaxPickupDto: CaptainSetMaxPickupDto(
          (b) => b..amount = minor,
        ),
      );
      state = AsyncData(_of(answer.data!));
      return true;
    } on DioException {
      ref.invalidateSelf();
      return false;
    }
  }
}

final maxPickupProvider = AsyncNotifierProvider<MaxPickupNotifier, MaxPickup>(
  MaxPickupNotifier.new,
);
