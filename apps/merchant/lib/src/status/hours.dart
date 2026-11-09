import 'package:built_collection/built_collection.dart';
import 'package:core_api/core_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import 'status.dart';

typedef Hours = MerchantHoursDtoOutput;

/// One opening period being edited: minutes after midnight on the city's
/// clock; a closing time not after the opening crosses midnight (RA §10).
class Period {
  const Period(this.opensAt, this.closesAt);

  final int opensAt;
  final int closesAt;

  @override
  bool operator ==(Object other) =>
      other is Period && other.opensAt == opensAt && other.closesAt == closesAt;

  @override
  int get hashCode => Object.hash(opensAt, closesAt);
}

/// The weekdays in the order the screen lists them, Saturday first, as the
/// week runs in Syria; 0 is Sunday, as the server counts.
const weekdayOrder = [6, 0, 1, 2, 3, 4, 5];

/// The weekly schedule being edited (RA §10): each weekday's periods, none
/// for «مغلق طوال اليوم». The server checks it (overlaps, 30 minutes or
/// more) when it is saved.
class WeekDraft {
  WeekDraft(Map<int, List<Period>> days)
    : days = {
        for (final day in weekdayOrder) day: [...?days[day]],
      };

  factory WeekDraft.of(Hours hours) {
    final days = <int, List<Period>>{};
    for (final period in hours.periods) {
      (days[period.weekday] ??= []).add(
        Period(period.opensAt, period.closesAt),
      );
    }
    for (final periods in days.values) {
      periods.sort((a, b) => a.opensAt.compareTo(b.opensAt));
    }
    return WeekDraft(days);
  }

  final Map<int, List<Period>> days;

  /// A new period after the day's last one, or 09:00–17:00 on a closed day.
  WeekDraft add(int weekday) {
    final periods = days[weekday]!;
    final last = periods.isEmpty ? null : periods.last;
    final opensAt = last == null ? 9 * 60 : last.closesAt % 1440;
    final next = Period(opensAt, (opensAt + 60) % 1440);
    return WeekDraft({
      ...days,
      weekday: [...periods, next],
    });
  }

  WeekDraft remove(int weekday, int index) => WeekDraft({
    ...days,
    weekday: [...days[weekday]!]..removeAt(index),
  });

  WeekDraft change(int weekday, int index, Period period) => WeekDraft({
    ...days,
    weekday: [...days[weekday]!]..[index] = period,
  });

  /// What `PUT /v1/merchant/restaurant/hours` takes.
  List<({int weekday, int opensAt, int closesAt})> get periods => [
    for (final day in weekdayOrder)
      for (final period in days[day]!)
        (weekday: day, opensAt: period.opensAt, closesAt: period.closesAt),
  ];
}

/// The settlement weekday as the server names it, 0 Sunday to 6 Saturday.
int weekdayNumber(String name) => switch (name) {
  'sunday' => 0,
  'monday' => 1,
  'tuesday' => 2,
  'wednesday' => 3,
  'thursday' => 4,
  'friday' => 5,
  _ => 6,
};

/// The owners' «الحالة والأوقات» (RA §10): read once on opening, and again
/// after each save's answer.
final hoursProvider = FutureProvider.autoDispose<Hours>((ref) async {
  return (await ref
          .watch(coreApiProvider)
          .getMerchantApi()
          .merchantStatusHours())
      .data!;
});

/// Why the server refused a save, for the screen's message.
enum HoursRefusal { invalidSchedule, invalidHoliday, invalidSettings, other }

/// The owners' commands (RA §10, §18): each sets a value and applies at once.
class HoursCommands {
  HoursCommands(this._api, this._ref);

  final MerchantApi _api;
  final Ref _ref;

  Future<HoursRefusal?> saveSchedule(WeekDraft draft) => _hours(
    () => _api.merchantStatusSetHours(
      merchantScheduleDto: MerchantScheduleDto(
        (b) => b.periods = ListBuilder([
          for (final p in draft.periods)
            MerchantScheduleDtoPeriodsInner(
              (b) => b
                ..weekday = p.weekday
                ..opensAt = p.opensAt
                ..closesAt = p.closesAt,
            ),
        ]),
      ),
    ),
  );

  Future<HoursRefusal?> saveOrderSettings({
    required int defaultPrepMin,
    required int? maxActiveOrders,
  }) => _hours(
    () => _api.merchantStatusSetOrderSettings(
      merchantOrderSettingsDto: MerchantOrderSettingsDto(
        (b) => b
          ..defaultPrepMin = defaultPrepMin
          ..maxActiveOrders = maxActiveOrders,
      ),
    ),
  );

  /// From now when [startsAt] is null.
  Future<HoursRefusal?> closeForHoliday({
    required DateTime? startsAt,
    required DateTime endsAt,
    required String? message,
  }) => _status(
    () => _api.merchantStatusSetHolidayClose(
      merchantHolidayCloseDto: MerchantHolidayCloseDto(
        (b) => b
          ..startsAt = startsAt?.toUtc()
          ..endsAt = endsAt.toUtc()
          ..message = (message == null || message.trim().isEmpty)
              ? null
              : message.trim(),
      ),
    ),
  );

  Future<HoursRefusal?> endHoliday() =>
      _status(_api.merchantStatusEndHolidayClose);

  Future<HoursRefusal?> _hours(Future<Response<Hours>> Function() call) =>
      _run(() async {
        await call();
        _ref.invalidate(hoursProvider);
        // The limit and the hours change the status too.
        await _ref.read(statusFeedProvider)?.refresh();
      });

  Future<HoursRefusal?> _status(Future<Response<Status>> Function() call) =>
      _run(() async {
        final answer = await call();
        _ref.read(statusFeedProvider)?.answered(answer.data!);
        _ref.invalidate(hoursProvider);
      });

  Future<HoursRefusal?> _run(Future<void> Function() call) async {
    try {
      await call();
      return null;
    } on DioException catch (error) {
      final body = error.response?.data;
      return switch (body is Map ? body['error'] : null) {
        'invalid_schedule' => HoursRefusal.invalidSchedule,
        'invalid_holiday_close' => HoursRefusal.invalidHoliday,
        'invalid_prep_time' ||
        'invalid_max_active_orders' => HoursRefusal.invalidSettings,
        _ => HoursRefusal.other,
      };
    }
  }
}

/// Not disposed with its last reader: a save outlives the read that started
/// it, and its answer refreshes the hours and the status.
final hoursCommandsProvider = Provider<HoursCommands>(
  (ref) => HoursCommands(ref.watch(coreApiProvider).getMerchantApi(), ref),
);
