import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;
import 'package:material_ui/material_ui.dart' as m;

/// The Syriac month names of the region (AP §4.7), January first.
const syriacMonths = [
  'كانون الثاني',
  'شباط',
  'آذار',
  'نيسان',
  'أيار',
  'حزيران',
  'تموز',
  'آب',
  'أيلول',
  'تشرين الأول',
  'تشرين الثاني',
  'كانون الأول',
];

/// Arabic Material strings with the FOX DROP formats (AP §4.7) for the date
/// and time pickers: Syriac month names, the week from Saturday, dates as
/// `dd/mm/yyyy`, 12-hour time with «ص» and «م», Western digits.
class FoxMaterialLocalizations extends m.MaterialLocalizationAr {
  FoxMaterialLocalizations()
    : super(
        fullYearFormat: intl.DateFormat('y'),
        compactDateFormat: intl.DateFormat('dd/MM/yyyy'),
        shortDateFormat: intl.DateFormat('dd/MM/yyyy'),
        mediumDateFormat: intl.DateFormat('dd/MM/yyyy'),
        longDateFormat: intl.DateFormat('dd/MM/yyyy'),
        yearMonthFormat: intl.DateFormat('MMMM y'),
        shortMonthDayFormat: intl.DateFormat('d/M'),
        decimalFormat: intl.NumberFormat('0'),
        twoDigitZeroPaddedFormat: intl.NumberFormat('00'),
      );

  static const LocalizationsDelegate<m.MaterialLocalizations> delegate =
      _Delegate();

  /// Saturday, as an index from Sunday (0).
  static const saturday = 6;

  static String two(int n) => n.toString().padLeft(2, '0');

  static String date(DateTime d) =>
      '${two(d.day)}/${two(d.month)}/${d.year.toString().padLeft(4, '0')}';

  /// `3:05 م`: 12-hour time with «ص» and «م» (AP §4.7).
  static String time(int hour, int minute) {
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    return '$hour12:${two(minute)} ${hour < 12 ? 'ص' : 'م'}';
  }

  @override
  String get anteMeridiemAbbreviation => 'ص';

  @override
  String get postMeridiemAbbreviation => 'م';

  @override
  int get firstDayOfWeekIndex => saturday;

  /// Needed: without it Material falls back to English initials («S M T…»),
  /// since no `ar` date symbols are loaded.
  @override
  List<String> get narrowWeekdays => const ['ح', 'ن', 'ث', 'ر', 'خ', 'ج', 'س'];

  /// The hint of the typed-in date: the order the field reads.
  @override
  String get dateHelpText => 'dd/mm/yyyy';

  @override
  String formatMonthYear(DateTime date) =>
      '${syriacMonths[date.month - 1]} ${date.year}';

  @override
  String formatCompactDate(DateTime date) =>
      FoxMaterialLocalizations.date(date);

  @override
  String formatShortDate(DateTime date) => FoxMaterialLocalizations.date(date);

  @override
  String formatMediumDate(DateTime date) => FoxMaterialLocalizations.date(date);

  @override
  String formatFullDate(DateTime date) =>
      '${date.day} ${syriacMonths[date.month - 1]} ${date.year}';

  @override
  String formatShortMonthDay(DateTime date) =>
      '${date.day} ${syriacMonths[date.month - 1]}';

  @override
  DateTime? parseCompactDate(String? inputString) {
    final match = RegExp(
      r'^(\d{1,2})/(\d{1,2})/(\d{4})$',
    ).firstMatch(inputString?.trim() ?? '');
    if (match == null) return null;
    final day = int.parse(match[1]!);
    final month = int.parse(match[2]!);
    final year = int.parse(match[3]!);
    final parsed = DateTime(year, month, day);
    // DateTime rolls 31/02 over to March; refuse it.
    if (parsed.day != day || parsed.month != month) return null;
    return parsed;
  }

  @override
  String formatDecimal(int number) => number.toString();

  @override
  String formatHour(
    m.TimeOfDay timeOfDay, {
    bool alwaysUse24HourFormat = false,
  }) {
    final hour = timeOfDay.hourOfPeriod;
    return (hour == 0 ? 12 : hour).toString();
  }

  @override
  String formatMinute(m.TimeOfDay timeOfDay) => two(timeOfDay.minute);

  @override
  String formatTimeOfDay(
    m.TimeOfDay timeOfDay, {
    bool alwaysUse24HourFormat = false,
  }) {
    final period = timeOfDay.period == m.DayPeriod.am
        ? anteMeridiemAbbreviation
        : postMeridiemAbbreviation;
    return '${formatHour(timeOfDay)}:${formatMinute(timeOfDay)} $period';
  }

  @override
  m.TimeOfDayFormat timeOfDayFormat({bool alwaysUse24HourFormat = false}) =>
      m.TimeOfDayFormat.h_colon_mm_space_a;
}

class _Delegate extends LocalizationsDelegate<m.MaterialLocalizations> {
  const _Delegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ar';

  @override
  Future<m.MaterialLocalizations> load(Locale locale) =>
      SynchronousFuture(FoxMaterialLocalizations());

  @override
  bool shouldReload(_Delegate old) => false;
}
