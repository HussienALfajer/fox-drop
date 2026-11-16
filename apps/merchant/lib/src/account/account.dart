import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';

typedef Account = MerchantAccountDtoOutput;
typedef AccountLine = MerchantAccountDtoOutputWeekLinesInner;
typedef LineKind = MerchantAccountDtoOutputWeekLinesInnerKindEnum;
typedef Cause = MerchantAccountDtoOutputWeekLinesInnerCauseEnum;

/// `GET /v1/merchant/account` (RA §12.2), the owners' (a cashier gets `403
/// owner_only`); read on opening «الحساب» and on «تحديث».
final accountProvider = FutureProvider.autoDispose<Account>(
  (ref) async =>
      (await ref.read(coreApiProvider).getMerchantApi().merchantAccountRead())
          .data!,
);

/// A day of «هذا الأسبوع» (RA §12.2): its orders' commission and discount
/// share, then its exceptions and payments, as the server lists them.
class AccountDay {
  const AccountDay(this.day, this.lines);

  final Date day;
  final List<AccountLine> lines;
}

/// The week's lines by their business day, newest day first (the server's
/// order).
List<AccountDay> daysOf(Iterable<AccountLine> lines) {
  final days = <AccountDay>[];
  for (final line in lines) {
    if (days.isEmpty || days.last.day != line.day) {
      days.add(AccountDay(line.day, []));
    }
    days.last.lines.add(line);
  }
  return days;
}

/// A rate in basis points as the app shows it: 1500 is «15», 1250 «12.5».
String percentOf(int bp) {
  final whole = bp ~/ 100;
  final rest = bp % 100;
  if (rest == 0) return '$whole';
  final fraction = rest.toString().padLeft(2, '0');
  return '$whole.${fraction.endsWith('0') ? fraction[0] : fraction}';
}

/// The moment a date of the city's calendar is noon there, for the
/// formatters, which read moments on the city's clock (UTC+3 in Azaz).
DateTime noonOf(Date date) => DateTime.utc(date.year, date.month, date.day, 9);

extension AccountTexts on AppLocalizations {
  /// RA §12.5: an exception's label, the manual correction's with its reason.
  String causeLabel(Cause? cause, String? reason) =>
      causeNameLabel(cause?.name, reason);

  /// The same by the cause's name, whichever generated enum carries it (the
  /// account's or the statement's).
  String causeNameLabel(String? cause, String? reason) {
    if (cause == 'adjustment') return merchantCauseAdjustment(reason ?? '');
    return switch (cause) {
      'foodCredit' => merchantCauseFoodCredit,
      'credit' => merchantCauseCredit,
      'pickupRefund' => merchantCausePickupRefund,
      'pickupKept' => merchantCausePickupKept,
      'itemsRemoved' => merchantCauseItemsRemoved,
      'feeLowered' => merchantCauseFeeLowered,
      'feeCutReturned' => merchantCauseFeeCutReturned,
      'commissionReversal' => merchantCauseCommissionReversal,
      'commissionRestored' => merchantCauseCommissionRestored,
      'discountReversal' => merchantCauseDiscountReversal,
      'outcomeChanged' => merchantCauseOutcomeChanged,
      // A debit with a reason ordering does not name (RA §12.5: a problem
      // after the delivery).
      _ => merchantCauseDebit,
    };
  }

  /// RA §12.2: «المستحق عليك حتى الآن», or what the platform owes.
  String balanceText(Account account) {
    final balance = BigInt.parse(account.balance);
    final currency = account.currency;
    if (balance == BigInt.zero || currency == null) {
      return merchantAccountSettled;
    }
    return balance.isNegative
        ? merchantAccountCredit(formatMoney((-balance).toString(), currency))
        : merchantAccountOwed(formatMoney(balance.toString(), currency));
  }

  /// RA §12.2: «موعد التسوية: السبت {التاريخ}».
  String settlementText(Date date) {
    final noon = noonOf(date);
    return merchantAccountSettlement(weekdayOf(noon), formatDate(noon));
  }
}
