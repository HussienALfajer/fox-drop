import 'package:core_api/core_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';

/// A currency of the city on «العملات التي تقبلها من الكابتن» (RA §12.7).
class CurrencyChoice {
  const CurrencyChoice(this.code, this.name);

  final String code;

  /// Its Arabic name, from the server's currencies (AP §8.6).
  final String name;
}

/// «العملات التي تقبلها من الكابتن» (RA §12.7): the base, always accepted and
/// fixed, and the other currencies the city has enabled, each switched on or
/// off by an owner.
class PickupCurrencies {
  const PickupCurrencies({
    required this.base,
    required this.accepted,
    required this.choices,
  });

  /// Null while the city has no base currency.
  final CurrencyChoice? base;
  final List<String> accepted;
  final List<CurrencyChoice> choices;

  /// The other currencies accepted after switching [code] on or off, in the
  /// city's display order.
  List<String> switched(String code, {required bool on}) => [
    for (final choice in choices)
      if (choice.code == code ? on : accepted.contains(choice.code))
        choice.code,
  ];
}

PickupCurrencies _of(MerchantPickupCurrenciesDtoOutput dto) => PickupCurrencies(
  base: switch (dto.baseCurrency) {
    final base? => CurrencyChoice(base.currency, base.name),
    null => null,
  },
  accepted: dto.accepted.toList(),
  choices: [
    for (final choice in dto.choices)
      CurrencyChoice(choice.currency, choice.name),
  ],
);

/// `GET` and `PUT /v1/merchant/settings/pickup-currencies`, the owners'
/// (a cashier gets `403 owner_only`); read on opening «الإعدادات», and a
/// change applies to the pickups requested after it.
class PickupCurrenciesNotifier extends AsyncNotifier<PickupCurrencies> {
  MerchantApi get _api => ref.read(coreApiProvider).getMerchantApi();

  @override
  Future<PickupCurrencies> build() async =>
      _of((await _api.merchantStatusPickupCurrencies()).data!);

  /// False when the server did not take it (a currency disabled since, no
  /// signal): the switches are read again.
  Future<bool> set(List<String> currencies) async {
    try {
      final answer = await _api.merchantStatusSetPickupCurrencies(
        merchantSetPickupCurrenciesDto: MerchantSetPickupCurrenciesDto(
          (b) => b..currencies.addAll(currencies),
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

final pickupCurrenciesProvider =
    AsyncNotifierProvider.autoDispose<
      PickupCurrenciesNotifier,
      PickupCurrencies
    >(PickupCurrenciesNotifier.new);
