import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../joining/application.dart';
import '../joining/texts.dart';

typedef CaptainProfile = CaptainProfileDtoOutput;
typedef PayTable = CaptainPayTableDtoOutput;
typedef PayCalculation = CaptainPayCalculationDtoOutput;

/// The largest sample «احسب أجري» takes, as the server does.
const sampleMaxMetres = 100000;
const sampleMaxWaitedMinutes = 1440;

/// CA §12.1 (slice 2.36c): `GET /v1/captain/profile`, read each time «ملفي»
/// opens.
final captainProfileProvider = FutureProvider.autoDispose<CaptainProfile>(
  (ref) async =>
      (await ref.read(coreApiProvider).getCaptainApi().captainProfileProfile())
          .data!,
);

/// CA §12.5: `GET /v1/captain/pay-table`, the captain's vehicle row of the
/// table in force and of each one announced.
final payTableProvider = FutureProvider.autoDispose<PayTable>(
  (ref) async =>
      (await ref
              .read(coreApiProvider)
              .getCaptainApi()
              .captainPayTablePayTable())
          .data!,
);

/// «احسب أجري»: the server prices the sample by each table (money is the
/// server's to compute), `GET /v1/captain/pay-table/calculate`.
final payCalculatorProvider =
    Provider<Future<PayCalculation> Function(int metres, int waitedMinutes)>(
      (ref) =>
          (metres, waitedMinutes) async =>
              (await ref
                      .read(coreApiProvider)
                      .getCaptainApi()
                      .captainPayTableCalculate(
                        metres: metres,
                        waitedMinutes: waitedMinutes,
                      ))
                  .data!,
    );

/// What an Arabic keyboard types («٦٫٤», «٢٥») read as Western digits.
String _western(String typed) => typed
    .trim()
    .replaceAll('٫', '.')
    .replaceAllMapped(
      RegExp('[٠-٩]'),
      (m) => '${m[0]!.codeUnitAt(0) - 0x0660}',
    );

/// A distance typed in km («4», «4.5», «4,25»; up to three decimals) as
/// whole metres, or null when it is not one of 0 to 100 km.
int? metresOf(String typed) {
  final match = RegExp(
    r'^(\d{1,3})(?:[.,](\d{1,3}))?$',
  ).firstMatch(_western(typed));
  if (match == null) return null;
  final metres =
      int.parse(match[1]!) * 1000 +
      int.parse((match[2] ?? '').padRight(3, '0'));
  return metres <= sampleMaxMetres ? metres : null;
}

/// Minutes waited as typed, none being 0, or null when they are not a whole
/// number of 0 to a day.
int? waitedOf(String typed) {
  final text = _western(typed);
  if (text.isEmpty) return 0;
  if (!RegExp(r'^\d{1,4}$').hasMatch(text)) return null;
  final minutes = int.parse(text);
  return minutes <= sampleMaxWaitedMinutes ? minutes : null;
}

/// The distance a base pay includes, exact to the metre: the pay counts
/// each metre past it (CA §12.5).
String includedText(AppLocalizations l10n, int metres) {
  if (metres < 1000) return l10n.distanceMetres(metres);
  final km = (metres / 1000)
      .toStringAsFixed(3)
      .replaceFirst(RegExp(r'\.?0+$'), '');
  return l10n.distanceKilometres(km);
}

String profileVehicleText(
  AppLocalizations l10n,
  CaptainProfileDtoOutputVehicleEnum vehicle,
) => vehicleText(
  l10n,
  Vehicle.values.firstWhere(
    (each) => each.name == vehicle.name,
    orElse: () => Vehicle.motorbike,
  ),
);
