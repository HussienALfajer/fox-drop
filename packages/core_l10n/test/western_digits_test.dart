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
}
