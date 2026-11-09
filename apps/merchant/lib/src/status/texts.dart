import 'package:core_l10n/core_l10n.dart';

import 'status.dart';

String pillText(AppLocalizations l10n, Status status) =>
    switch (statusPill(status)) {
      StatusPill.open => l10n.merchantStatusOpen,
      StatusPill.busyMode => l10n.merchantStatusBusyMode(
        status.busyMode?.extraMin ?? 0,
      ),
      StatusPill.busy => l10n.merchantStatusBusy,
      StatusPill.paused => l10n.merchantStatusPaused,
      StatusPill.pausedByOperations => l10n.merchantStatusPausedByOperations,
      StatusPill.autoPaused => l10n.merchantStatusAutoPaused,
      StatusPill.closed => l10n.merchantStatusClosed,
      StatusPill.holiday => l10n.merchantStatusHoliday(
        status.stateUntil == null ? '' : l10n.formatDate(status.stateUntil!),
      ),
      StatusPill.suspended => l10n.merchantStatusSuspended,
      StatusPill.inactive => l10n.merchantStatusInactive,
    };

/// «اليوم 11:30 م» or «الجمعة 9:00 ص», on the city's clock.
String dayAndTime(AppLocalizations l10n, DateTime at, DateTime now) {
  final day = l10n.formatDate(at) == l10n.formatDate(now)
      ? l10n.merchantStatusToday
      : l10n.weekdayOf(at);
  return '$day ${l10n.formatTime(at)}';
}

/// The next schedule change (RA §7.2): «يغلق اليوم 11:30 م» inside an
/// opening period, «يفتح الجمعة 9:00 ص» closed by the schedule.
String? nextScheduleText(AppLocalizations l10n, Status status, DateTime now) {
  if (status.closesAt case final closesAt?) {
    return l10n.merchantStatusClosesAt(dayAndTime(l10n, closesAt, now));
  }
  if (status.opensAt case final opensAt?) {
    return l10n.merchantStatusOpensAt(dayAndTime(l10n, opensAt, now));
  }
  return null;
}

/// When a pause ends (RA §7.2 «remaining time»); a holiday close's end is in
/// its pill.
String? stateUntilText(AppLocalizations l10n, Status status, DateTime now) {
  if (status.state != StatusState.paused) return null;
  final until = status.stateUntil;
  if (until == null) return null;
  return l10n.merchantStatusPauseEnds(dayAndTime(l10n, until, now));
}

String bannerText(AppLocalizations l10n, StatusBanner banner, Status status) =>
    switch (banner) {
      StatusBanner.pausedByOperations => l10n.merchantStatusLockedByOperations,
      StatusBanner.limitReached => l10n.merchantStatusLimitBanner(
        status.activeOrders ?? status.maxActiveOrders ?? 0,
      ),
      StatusBanner.busyMode => l10n.merchantStatusBusyModeBanner(
        status.busyMode?.extraMin ?? 0,
      ),
    };

String refusalText(AppLocalizations l10n, StatusRefusal refusal) =>
    switch (refusal) {
      StatusRefusal.closed => l10n.merchantStatusRefusedClosed,
      StatusRefusal.pausedByOperations => l10n.merchantStatusLockedByOperations,
      StatusRefusal.other => l10n.merchantStatusRefusedOther,
    };

String statusNoticeText(AppLocalizations l10n, StatusNotice notice) =>
    switch (notice) {
      AutoPaused(:final count) => l10n.merchantNoticeAutoPaused(count),
      PauseEnded() => l10n.merchantNoticePauseEnded,
      BusyReminder(:final minutes) => l10n.merchantNoticeBusyReminder(minutes),
      PausedByOperations(:final reason) =>
        l10n.merchantNoticePausedByOperations(reason),
      ResumedByOperations() => l10n.merchantNoticeResumedByOperations,
      BusyEndedByOperations() => l10n.merchantNoticeBusyEndedByOperations,
    };
