import 'package:built_collection/built_collection.dart';
import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:merchant/src/account/account.dart';

AccountLine _line(String day, String kind, {String? cause}) => AccountLine(
  (b) => b
    ..day = Date(
      int.parse(day.substring(0, 4)),
      int.parse(day.substring(5, 7)),
      int.parse(day.substring(8)),
    )
    ..kind = LineKind.valueOf(kind)
    ..at = DateTime.utc(2026, 11, 7)
    ..cause = cause == null ? null : Cause.valueOf(cause),
);

void main() {
  // RA §12.2: the commission rate as the app shows it.
  test('a rate in basis points shows as a percentage', () {
    expect(percentOf(1500), '15');
    expect(percentOf(1250), '12.5');
    expect(percentOf(1205), '12.05');
    expect(percentOf(0), '0');
  });

  // RA §12.2: «هذا الأسبوع» by day, in the server's order.
  test('the week groups its lines by day, keeping their order', () {
    final days = daysOf(
      BuiltList([
        _line('2026-11-07', 'order'),
        _line('2026-11-07', 'exception', cause: 'credit'),
        _line('2026-11-06', 'payment'),
      ]),
    );
    expect(days.map((day) => day.day.day), [7, 6]);
    expect(days.first.lines.map((line) => line.kind), [
      LineKind.order,
      LineKind.exception,
    ]);
  });

  // RA §12.5: each exception's label, the correction with its reason.
  test('an exception shows its label, a correction its reason', () {
    final l10n = lookupAppLocalizations(const Locale('ar'));
    expect(
      l10n.causeLabel(Cause.foodCredit, null),
      'تعويض عن طلب أُلغي بعد التحضير',
    );
    expect(l10n.causeLabel(Cause.debit, null), 'مشكلة بعد التسليم');
    expect(
      l10n.causeLabel(Cause.adjustment, 'خطأ في الكشف'),
      'تسوية يدوية: خطأ في الكشف',
    );
    for (final cause in Cause.values) {
      expect(l10n.causeLabel(cause, 'سبب'), isNotEmpty);
    }
  });
}
