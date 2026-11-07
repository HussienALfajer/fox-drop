import 'generated/app_localizations.dart';

/// A currency the apps show: its symbol and its minor-unit digits. The server
/// seeds these three (`fx.currencies`, migration 0008); the API sends amounts
/// in minor units with the currency's code only, so the app keeps the same
/// table. An unknown code shows itself with 2 digits.
const _currencies = {
  'TRY': (symbol: '₺', decimals: 2),
  'USD': (symbol: r'$', decimals: 2),
  'SYP': (symbol: 'ل.س', decimals: 2),
};

/// The formatters of money, times, dates, durations and distances (AP §4.7,
/// CU §4.6), always with Western digits.
extension Formats on AppLocalizations {
  /// [minor] is an integer amount in the currency's minor units, as the API
  /// sends it («41000» TRY is «410 ₺»). A whole amount drops its fraction;
  /// any other shows every minor digit («1050» USD is «10.50 $»).
  String formatMoney(String minor, String currency) {
    final known = _currencies[currency];
    final symbol = known?.symbol ?? currency;
    final decimals = known?.decimals ?? 2;
    final value = BigInt.parse(minor);
    final negative = value.isNegative;
    final digits = value.abs().toString().padLeft(decimals + 1, '0');
    final whole = digits.substring(0, digits.length - decimals);
    final fraction = digits.substring(digits.length - decimals);
    final amount = fraction.replaceAll('0', '').isEmpty
        ? whole
        : '$whole.$fraction';
    return money('${negative ? '-' : ''}$amount', symbol);
  }

  /// A 12-hour time on the phone's clock, with «ص» or «م».
  String formatTime(DateTime time) {
    final local = time.toLocal();
    return formatMinuteOfDay(local.hour * 60 + local.minute);
  }

  /// A time given as minutes after midnight, such as a schedule's opening.
  String formatMinuteOfDay(int minutes) {
    final hour = (minutes ~/ 60) % 24;
    final minute = (minutes % 60).toString().padLeft(2, '0');
    final clock = '${hour % 12 == 0 ? 12 : hour % 12}:$minute';
    return hour < 12 ? timeMorning(clock) : timeEvening(clock);
  }

  /// A date as `dd/mm/yyyy` on the phone's clock.
  String formatDate(DateTime date) {
    final local = date.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)}/${local.year}';
  }

  /// The weekday's name, 0 for Sunday to 6 for Saturday (RA §10).
  String weekdayName(int weekday) => switch (weekday % 7) {
    0 => weekdaySunday,
    1 => weekdayMonday,
    2 => weekdayTuesday,
    3 => weekdayWednesday,
    4 => weekdayThursday,
    5 => weekdayFriday,
    _ => weekdaySaturday,
  };

  /// The weekday's name of a moment on the phone's clock.
  String weekdayOf(DateTime time) => weekdayName(time.toLocal().weekday % 7);

  /// A distance: metres below 1 km, kilometres with one decimal above.
  String formatDistance(int metres) => metres < 1000
      ? distanceMetres(metres)
      : distanceKilometres((metres / 1000).toStringAsFixed(1));
}
