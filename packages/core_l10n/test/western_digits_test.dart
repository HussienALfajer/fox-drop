import 'dart:convert';
import 'dart:io';

import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

// Arabic-Indic (U+0660-0669) and Extended Arabic-Indic (U+06F0-06F9) digits.
final _easternDigits = RegExp('[٠-٩۰-۹]');

void main() {
  // AP §4.7: the apps show Western digits everywhere.
  test('no Arabic string is written with Eastern digits', () {
    final arb = File('lib/src/arb/app_ar.arb').readAsStringSync();
    final strings = (jsonDecode(arb) as Map<String, dynamic>).entries
        .where((entry) => !entry.key.startsWith('@'))
        .map((entry) => '${entry.key}: ${entry.value}');
    expect(strings.where(_easternDigits.hasMatch), isEmpty);
  });

  // The generated code formats placeholders with intl in the locale's name,
  // so a number or date placeholder must come out in Western digits too.
  test('numbers and dates in the app locale use Western digits', () async {
    final localeName = lookupAppLocalizations(const Locale('ar')).localeName;
    await initializeDateFormatting(localeName);

    final number = NumberFormat.decimalPattern(localeName).format(1234567.5);
    final date = DateFormat.yMd(
      localeName,
    ).add_Hm().format(DateTime(2026, 11, 5, 18, 30));

    expect(number, isNot(matches(_easternDigits)));
    expect(number, contains('1,234,567'));
    expect(date, isNot(matches(_easternDigits)));
    expect(date, contains('2026'));
  });

  // The int placeholders of the sign-in strings.
  test('the sign-in counts use Western digits', () {
    final l10n = lookupAppLocalizations(const Locale('ar'));
    for (final text in [
      l10n.signInResendIn(45),
      l10n.signInTryLater(12),
      l10n.signInResendWait(30),
      l10n.signInWrongCode(3),
    ]) {
      expect(text, isNot(matches(_easternDigits)));
      expect(text, matches(RegExp(r'\d')));
    }
  });

  // The formatters of AP §4.7 and CU §4.6.
  test('money, times, dates, durations and distances', () {
    final l10n = lookupAppLocalizations(const Locale('ar'));
    expect(l10n.formatMoney('41000', 'TRY'), '410 ₺');
    expect(l10n.formatMoney('1050', 'USD'), r'10.50 $');
    expect(l10n.formatMoney('5', 'SYP'), '0.05 ل.س');
    expect(l10n.formatMoney('-250', 'TRY'), '-2.50 ₺');
    expect(l10n.formatMoney('100', 'EUR'), '1 EUR');
    expect(l10n.currencySymbol('USD'), r'$');
    expect(l10n.currencySymbol('EUR'), 'EUR');
    expect(l10n.formatMinuteOfDay(0), '12:00 ص');
    expect(l10n.formatMinuteOfDay(9 * 60 + 5), '9:05 ص');
    expect(l10n.formatMinuteOfDay(12 * 60), '12:00 م');
    expect(l10n.formatMinuteOfDay(23 * 60 + 30), '11:30 م');
    expect(l10n.formatDate(DateTime.utc(2026, 3, 6, 22)), '07/03/2026');
    // Moments are on the city's clock (UTC+3), whatever the phone's zone.
    expect(l10n.formatTime(DateTime.utc(2026, 11, 5, 15, 30)), '6:30 م');
    expect(l10n.weekdayOf(DateTime.utc(2026, 11, 7, 22)), 'الأحد');
    expect(l10n.weekdayName(0), 'الأحد');
    expect(l10n.weekdayName(6), 'السبت');
    expect(l10n.durationMinutes(12), '12 د');
    expect(l10n.durationSeconds(45), '45 ث');
    expect(
      l10n.formatCountdown(const Duration(minutes: 6, seconds: 59)),
      '6:59',
    );
    expect(l10n.formatCountdown(const Duration(seconds: -3)), '0:00');
    expect(l10n.merchantAccept(20), 'قبول — 20 د');
    expect(l10n.merchantAutoConfirmIn(60), 'يُؤكَّد تلقائياً خلال 60 ث');
    expect(l10n.formatDistance(850), '850 م');
    expect(l10n.formatDistance(2400), '2.4 كم');
    for (final text in [
      l10n.formatMoney('123456789', 'SYP'),
      l10n.formatTime(DateTime(2026, 11, 5, 18, 30)),
      l10n.formatDate(DateTime(2026, 11, 5)),
      l10n.formatDistance(1234),
    ]) {
      expect(text, isNot(matches(_easternDigits)));
    }
  });
}
