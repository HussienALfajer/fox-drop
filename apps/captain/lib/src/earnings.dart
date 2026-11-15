import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api.dart';
import 'work/work.dart';

typedef Earnings = CaptainEarningsDtoOutput;
typedef EarningsOrder = CaptainEarningsDtoOutputOrdersInner;
typedef EarningsLine = CaptainEarningsDtoOutputLinesInner;
typedef EarningsKind = CaptainEarningsDtoOutputLinesInnerKindEnum;
typedef NegativePolicy = CaptainEarningsDtoOutputNegativePolicyEnum;

/// CA §10.6 «أرباحي»: `GET /v1/captain/earnings`, read while the tab shows
/// and again after every read of the captain's state: a delivery ends the
/// order, and every desk receipt (the payout among them) sends
/// `captain.availability_changed`, which reads the state again, even when
/// only the earnings moved.
final earningsProvider = FutureProvider.autoDispose<Earnings>((ref) async {
  // Each read of the state is a new `Work`.
  ref.watch(workProvider.select((live) => live.value?.value));
  final answer = await ref
      .read(coreApiProvider)
      .getCaptainApi()
      .captainEarningsRead();
  return answer.data!;
});

/// The moment a date of the city's calendar is noon there, for the
/// formatters, which read moments on the city's clock (UTC+3 in Azaz).
DateTime noonOf(Date date) => DateTime.utc(date.year, date.month, date.day, 9);

extension EarningsTexts on AppLocalizations {
  /// A moment of the cycle: its weekday, date and time on the city's clock
  /// (a cycle holds two Thursdays).
  String momentText(DateTime at) =>
      '${weekdayOf(at)} ${formatDate(at)} ${formatTime(at)}';

  /// «ساعات الاتصال: {hours} س {minutes} د».
  String onlineText(int minutes) =>
      captainEarningsOnline(minutes ~/ 60, minutes % 60);

  /// CA §10.6: «موعد القبض: الخميس {التاريخ}».
  String payoutText(Date date) {
    final noon = noonOf(date);
    return captainEarningsPayoutDate(weekdayOf(noon), formatDate(noon));
  }

  /// CA §10.7: a negative balance and what happens to it, else null.
  String? negativeText(Earnings earnings) {
    if (!BigInt.parse(earnings.balance).isNegative) return null;
    return earnings.negativePolicy == NegativePolicy.collectAtDesk
        ? captainEarningsNegativeCollect
        : captainEarningsNegativeCarry;
  }

  String orderText(EarningsOrder order, String currency) {
    final total = formatMoney(order.total, currency);
    return switch (order.orderNumber) {
      final number? => captainEarningsOrder(number, total),
      null => captainEarningsOrderUnnumbered(total),
    };
  }

  /// One order's parts (CA §10.6), the zeros left out but the base pay.
  List<String> partTexts(EarningsOrder order, String currency) {
    final parts = order.parts;
    if (parts == null) return const [];
    String money(String amount) => formatMoney(amount, currency);
    bool some(String amount) => BigInt.parse(amount) != BigInt.zero;
    return [
      captainPayBase(money(parts.base_)),
      if (some(parts.distance)) captainPayDistance(money(parts.distance)),
      if (some(parts.topUp)) captainPayTopUp(money(parts.topUp)),
      if (some(parts.waiting)) captainPayWaiting(money(parts.waiting)),
      if (some(parts.peak)) captainPayPeak(money(parts.peak)),
    ];
  }

  String kindText(EarningsLine line) => switch (line.kind) {
    EarningsKind.bonus => captainEarningsBonus,
    EarningsKind.charge => captainEarningsCharge,
    EarningsKind.instalment => captainEarningsInstalment,
    // A payout takes off what is owed; one that adds is a collection.
    EarningsKind.payout =>
      BigInt.parse(line.amount).isNegative
          ? captainEarningsPayout
          : captainEarningsCollection,
    _ => captainEarningsAdjustment,
  };

  /// One other line: its kind and amount, then its reason, its order or
  /// its receipt.
  List<String> lineTexts(EarningsLine line, String currency) => [
    captainEarningsLine(kindText(line), formatMoney(line.amount, currency)),
    ?line.reason,
    if (line.orderNumber case final number?) captainEarningsLineOrder(number),
    if (line.receiptNumber case final number?)
      captainEarningsLineReceipt(number),
  ];
}
