import 'package:core_api/core_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';

/// One of the city's currencies on «العملات التي أحملها» (CA §10.5).
class CurrencyChoice {
  const CurrencyChoice(this.code, this.name, {required this.base});

  final String code;

  /// Its Arabic name, from the server's currencies (AP §8.6).
  final String name;
  final bool base;
}

/// «العملات التي أحملها» (CA §10.5): what the captain carries of the city's
/// currencies; the server proposes the pickup payment in one the restaurant
/// accepts too.
class CarriedCurrencies {
  const CarriedCurrencies({required this.carried, required this.choices});

  final List<String> carried;
  final List<CurrencyChoice> choices;

  /// The set after switching [code] on or off; the last one stays on.
  List<String>? switched(String code, {required bool on}) {
    final next = [
      for (final choice in choices)
        if (choice.code == code ? on : carried.contains(choice.code))
          choice.code,
    ];
    return next.isEmpty ? null : next;
  }
}

CarriedCurrencies _of(CaptainCarriedCurrenciesDtoOutput dto) =>
    CarriedCurrencies(
      carried: dto.carried.toList(),
      choices: [
        for (final choice in dto.choices)
          CurrencyChoice(
            choice.currency,
            choice.name,
            base: choice.currency == dto.baseCurrency,
          ),
      ],
    );

/// `GET` and `PUT /v1/captain/settings/carried-currencies`; a change applies
/// to the next pickup's proposal.
class CarriedCurrenciesNotifier extends AsyncNotifier<CarriedCurrencies> {
  CaptainApi get _api => ref.read(coreApiProvider).getCaptainApi();

  @override
  Future<CarriedCurrencies> build() async =>
      _of((await _api.captainAvailabilityCarriedCurrencies()).data!);

  /// False when the server did not take it (a currency disabled since, no
  /// signal): the switches stay as they were.
  Future<bool> set(List<String> currencies) async {
    try {
      final answer = await _api.captainAvailabilitySetCarriedCurrencies(
        captainSetCarriedCurrenciesDto: CaptainSetCarriedCurrenciesDto(
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

final carriedCurrenciesProvider =
    AsyncNotifierProvider<CarriedCurrenciesNotifier, CarriedCurrencies>(
      CarriedCurrenciesNotifier.new,
    );
