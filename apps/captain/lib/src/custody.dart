import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api.dart';
import 'work/door_payment.dart';
import 'work/work.dart';

typedef Custody = CaptainCustodyDtoOutput;
typedef CustodyEntry = CaptainCustodyDtoOutputEntriesInner;
typedef EntryKind = CaptainCustodyDtoOutputEntriesInnerKindEnum;
typedef Receipt = CaptainCustodyDtoOutputReceiptsInner;
typedef Office = CaptainAvailabilityDtoOutputOffice;

/// CA §10.2 «عهدتي»: `GET /v1/captain/custody`, read while the screen shows
/// and again whenever the captain's state is read with another custody: the
/// desk's receipt sends the captain channel's `captain.availability_changed`,
/// which reads the state again, so the receipt shows at once (AP §9.10.3).
final custodyProvider = FutureProvider.autoDispose<Custody>((ref) async {
  ref.watch(
    workProvider.select((live) => live.value?.value?.availability.custody),
  );
  final answer = await ref
      .read(coreApiProvider)
      .getCaptainApi()
      .captainCustodyCustody();
  return answer.data!;
});

/// The usage of the cash limit, 0 to 1, for its bar (CA §10.4).
double limitShare(String usage, String limit) {
  final held = BigInt.parse(usage);
  final cap = BigInt.parse(limit);
  if (cap <= BigInt.zero || held <= BigInt.zero) return 0;
  if (held >= cap) return 1;
  return held.toDouble() / cap.toDouble();
}

extension CustodyTexts on AppLocalizations {
  /// CA §10.2: «عليك تسليم {المبلغ}» or «لك عند المكتب {المبلغ}».
  String custodySentence(Custody custody) {
    final total = BigInt.parse(custody.total.amount);
    final currency = custody.total.currency;
    if (total > BigInt.zero) {
      return captainOwes(formatMoney(custody.total.amount, currency));
    }
    if (total < BigInt.zero) {
      return captainCustodyOwed(formatMoney((-total).toString(), currency));
    }
    return captainCustodyNothing;
  }

  String entryKindText(EntryKind? kind) => switch (kind) {
    EntryKind.payMerchant => captainCustodyEntryPayMerchant,
    EntryKind.collect => captainCustodyEntryCollect,
    EntryKind.changeGiven => captainCustodyEntryChange,
    EntryKind.handIn => captainCustodyEntryHandIn,
    EntryKind.reimburse => captainCustodyEntryReimburse,
    EntryKind.fxConvert => captainCustodyEntryConversion,
    EntryKind.pickupCorrection ||
    EntryKind.adjustment => captainCustodyEntryCorrection,
    _ => captainCustodyEntryOther,
  };

  /// One entry: its kind, the order or receipt, and the amount.
  String entryText(CustodyEntry entry) {
    final kind = entryKindText(entry.kind);
    final amount = formatMoney(entry.amount.amount, entry.amount.currency);
    if (entry.orderNumber case final number?) {
      return captainCustodyEntryOrder(kind, number, amount);
    }
    if (entry.receiptNumber case final receipt?) {
      return captainCustodyEntryReceipt(kind, receipt, amount);
    }
    return captainCustodyEntryPlain(kind, amount);
  }

  /// A receipt's type; a later one (2.18) has no name yet.
  String? receiptTypeText(String type) => switch (type) {
    'captain_hand_in' => captainCustodyEntryHandIn,
    'captain_reimbursement' => captainCustodyEntryReimburse,
    _ => null,
  };

  /// CA §7.5, C13: the desk now: open until when, or when it opens next.
  String officeNowText(Office office) {
    if (office.open && office.closesAt != null) {
      return captainOfficeOpenUntil(formatTime(office.closesAt!));
    }
    if (office.opensAt case final opens?) {
      return captainOfficeClosed(weekdayOf(opens), formatTime(opens));
    }
    return captainOfficeClosedAlways;
  }

  /// One weekday's desk hours (0 Sunday to 6 Saturday).
  String officeDayText(Office office, int weekday) {
    final day = weekdayName(weekday);
    for (final period in office.hours) {
      if (period.weekday == weekday) {
        return captainOfficeDay(
          day,
          formatMinuteOfDay(period.opensAt),
          formatMinuteOfDay(period.closesAt % (24 * 60)),
        );
      }
    }
    return captainOfficeDayClosed(day);
  }

  /// CA §7.5: the hand-in reminder, with the desk's hours when known.
  String handInText(Money amount, Office? office) {
    final owed = formatMoney(amount.amount, amount.currency);
    if (office == null) return captainOwes(owed);
    if (office.open && office.closesAt != null) {
      return captainHandInOpen(owed, formatTime(office.closesAt!));
    }
    if (office.opensAt case final opens?) {
      return captainHandInClosed(owed, weekdayOf(opens), formatTime(opens));
    }
    return captainHandInClosedAlways(owed);
  }
}

/// The weekdays from Saturday, the Syrian week (0 Sunday to 6 Saturday).
const officeWeek = [6, 0, 1, 2, 3, 4, 5];
