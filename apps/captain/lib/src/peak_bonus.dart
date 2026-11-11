import 'dart:async';

import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api.dart';

typedef PeakBonus = CaptainPeakBonusDtoOutput;
typedef PeakWindow = CaptainPeakBonusDtoOutputWindowsInner;
typedef ActivePeak = CaptainPeakBonusDtoOutputActiveInner;

/// How long a read of the windows stands before it is read again, so a
/// window that starts while home stays open shows within this time (and at
/// once with its push, CA §14 #23).
const peakRefresh = Duration(minutes: 5);

/// CA §12.5 (AP §9.12.5, D15): `GET /v1/captain/peak-bonus`, the windows in
/// force while the bonus is on and those running now, read again when a
/// running window ends and every [peakRefresh].
final peakBonusProvider = FutureProvider.autoDispose<PeakBonus>((ref) async {
  final answer = await ref
      .read(coreApiProvider)
      .getCaptainApi()
      .captainPeakBonusPeakBonus();
  final bonus = answer.data!;
  final clock = ref.read(serverClockProvider);
  var wait = peakRefresh;
  for (final window in bonus.active) {
    final left = clock.until(window.until);
    if (left < wait) wait = left;
  }
  final timer = Timer(
    (wait.isNegative ? Duration.zero : wait) + const Duration(seconds: 1),
    ref.invalidateSelf,
  );
  ref.onDispose(timer.cancel);
  return bonus;
});

/// ISO days in the Syrian week's order, Saturday first.
const peakDays = [6, 7, 1, 2, 3, 4, 5];

extension PeakTexts on AppLocalizations {
  String peakDay(int day) => switch (day) {
    1 => captainPeakDayMonday,
    2 => captainPeakDayTuesday,
    3 => captainPeakDayWednesday,
    4 => captainPeakDayThursday,
    5 => captainPeakDayFriday,
    6 => captainPeakDaySaturday,
    _ => captainPeakDaySunday,
  };

  /// One window: its days, hours and amount, and its zones.
  String peakWindowText(PeakWindow window) {
    final days = peakDays.where(window.days.contains).map(peakDay).join('، ');
    final line = captainPeakWindow(
      days,
      formatMinuteOfDay(window.startMinute),
      formatMinuteOfDay(window.endMinute),
      formatMoney(window.amount.amount, window.amount.currency),
    );
    final zones = window.zones.isEmpty
        ? captainPeakAllZones
        : captainPeakZones(window.zones.map((zone) => zone.name).join('، '));
    return window.endMinute <= window.startMinute
        ? '$line $captainPeakNextDay — $zones'
        : '$line — $zones';
  }

  /// The home screen's line for a window running now.
  String peakNowText(ActivePeak window) {
    final line = captainPeakNow(
      formatMoney(window.amount.amount, window.amount.currency),
      formatTime(window.until),
    );
    return window.zones.isEmpty
        ? line
        : '$line — ${captainPeakZones(window.zones.map((zone) => zone.name).join('، '))}';
  }
}

/// CA §12.5: «مكافأة الذروة الآن: +{المبلغ} لكل طلب حتى {الساعة}» while a
/// window runs, and the link to the windows while the bonus is on; nothing
/// while it is off or the read failed.
class PeakBonusLine extends ConsumerWidget {
  const PeakBonusLine({super.key, required this.onWindows});

  final VoidCallback onWindows;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final bonus = ref.watch(peakBonusProvider).value;
    if (bonus == null || bonus.windows.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final window in bonus.active)
          Text(l10n.peakNowText(window), key: const Key('peak-now')),
        TextButton(onPressed: onWindows, child: Text(l10n.captainPeakWindows)),
      ],
    );
  }
}

/// CA §12.5: the peak windows in force, until the captain's profile (2.36).
class PeakWindowsScreen extends ConsumerWidget {
  const PeakWindowsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final bonus = ref.watch(peakBonusProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.captainPeakWindows)),
      body: switch (bonus) {
        AsyncData(:final value) => ListView(
          padding: const EdgeInsetsDirectional.all(16),
          children: [
            Text(l10n.captainPeakExplain),
            if (value.windows.isEmpty) Text(l10n.captainPeakOff),
            for (final window in value.windows)
              Text(l10n.peakWindowText(window)),
          ],
        ),
        AsyncError() => Center(
          child: TextButton(
            onPressed: () => ref.invalidate(peakBonusProvider),
            child: Text(l10n.captainRetry),
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
