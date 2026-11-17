import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../auth.dart';
import '../location/delivery_point.dart';

typedef AccountState = CustomerAccountStateDtoOutput;
typedef Office = CustomerAccountStateDtoOutputOffice;

/// CU §5.5 (slice 2.25a): the account's state for home's banners, read at
/// the checked delivery point (the dues and the office are its city's) when
/// it changes and when the banners return to the foreground. Null for a
/// guest or without a checked point. The quote refuses ordering meanwhile,
/// whatever this read says.
final accountStateProvider = FutureProvider.autoDispose<AccountState?>((
  ref,
) async {
  final signedIn = ref.watch(
    customerAuth.session.select((state) => state.value is SignedIn),
  );
  final point = ref.watch(
    deliveryPointProvider.select((p) => p is PointChecked ? p.point : null),
  );
  if (!signedIn || point == null) return null;
  final answer = await ref
      .watch(coreApiProvider)
      .getCustomerApi()
      .customerAccountStateRead(
        latitude: '${point.latitude}',
        longitude: '${point.longitude}',
      );
  return answer.data;
});

/// The texts of the block banner (CU §5.5): for a duration, or until
/// further notice.
String blockText(AppLocalizations l10n, DateTime? until, String reason) =>
    until == null
    ? l10n.customerBlockedIndefinite(reason)
    : l10n.customerBlockedUntil(
        '${l10n.formatDate(until)} ${l10n.formatTime(until)}',
        reason,
      );

/// The weekdays from Saturday, the Syrian week (0 Sunday to 6 Saturday).
const officeWeek = [6, 0, 1, 2, 3, 4, 5];

extension OfficeTexts on AppLocalizations {
  /// The desk now: open until when, or when it opens next.
  String officeNowText(Office office) {
    if (office.open && office.closesAt != null) {
      return customerOfficeOpenUntil(formatTime(office.closesAt!));
    }
    if (office.opensAt case final opens?) {
      return customerOfficeClosed(weekdayOf(opens), formatTime(opens));
    }
    return customerOfficeClosedAlways;
  }

  /// One weekday's desk hours (0 Sunday to 6 Saturday).
  String officeDayText(Office office, int weekday) {
    final day = weekdayName(weekday);
    for (final period in office.hours) {
      if (period.weekday == weekday) {
        return customerOfficeDay(
          day,
          formatMinuteOfDay(period.opensAt.toInt()),
          formatMinuteOfDay(period.closesAt.toInt() % (24 * 60)),
        );
      }
    }
    return customerOfficeDayClosed(day);
  }
}

/// Opens the office in Google Maps (CU §5.5's sheet «on a map»).
Uri officeMapUri(num latitude, num longitude) => Uri.https(
  'www.google.com',
  '/maps/search/',
  {'api': '1', 'query': '$latitude,$longitude'},
);
