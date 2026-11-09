import 'package:core_api/core_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:merchant/src/status/status.dart';

import 'status_fixtures.dart';

// The status pill, banners, sheet and timers (RA §6.2–6.3, §7.1–7.4) as pure
// functions over the server's answer.
void main() {
  Status of(Map<String, Object?> json) =>
      standardSerializers.deserializeWith(Status.serializer, json)!;

  group('the pill (RA §7.1)', () {
    test('names each state, busy mode on open, and who paused', () {
      expect(statusPill(of(statusJson())), StatusPill.open);
      expect(statusPill(of(statusJson(busyMode: 20))), StatusPill.busyMode);
      expect(statusPill(of(statusJson(state: 'busy'))), StatusPill.busy);
      expect(
        statusPill(of(statusJson(state: 'paused', pauseSource: 'restaurant'))),
        StatusPill.paused,
      );
      expect(
        statusPill(of(statusJson(state: 'paused', pauseSource: 'ops'))),
        StatusPill.pausedByOperations,
      );
      expect(
        statusPill(of(statusJson(state: 'paused', pauseSource: 'auto'))),
        StatusPill.autoPaused,
      );
      expect(statusPill(of(statusJson(state: 'closed'))), StatusPill.closed);
      expect(statusPill(of(statusJson(state: 'holiday'))), StatusPill.holiday);
      expect(
        statusPill(of(statusJson(state: 'suspended'))),
        StatusPill.suspended,
      );
      expect(statusPill(of(statusJson(state: 'draft'))), StatusPill.inactive);
    });
  });

  group('the banners (RA §6.3 items 3 and 6)', () {
    test(
      'red for operations and the auto-pause, amber for the limit and busy mode',
      () {
        expect(statusBanners(of(statusJson())), isEmpty);
        expect(
          statusBanners(of(statusJson(state: 'paused', pauseSource: 'auto'))),
          [StatusBanner.pausedByOperations],
        );
        expect(
          statusBanners(
            of(statusJson(state: 'paused', pauseSource: 'restaurant')),
          ),
          isEmpty,
        );
        expect(statusBanners(of(statusJson(state: 'busy', busyMode: 10))), [
          StatusBanner.limitReached,
          StatusBanner.busyMode,
        ]);
        // Busy mode matters only while open.
        expect(
          statusBanners(of(statusJson(state: 'closed', busyMode: 10))),
          isEmpty,
        );
      },
    );
  });

  group('the sheet (RA §7.2, §18)', () {
    test('pauses and turns busy mode on while open or busy', () {
      for (final state in ['open', 'busy']) {
        final actions = sheetActions(of(statusJson(state: state)));
        expect(actions.pause, isTrue);
        expect(actions.busyModeOn, isTrue);
        expect(actions.resume, isFalse);
        expect(actions.lockedByOperations, isFalse);
      }
    });

    test('resumes or changes its own pause', () {
      final actions = sheetActions(
        of(statusJson(state: 'paused', pauseSource: 'restaurant')),
      );
      expect(actions.resume, isTrue);
      expect(actions.pause, isTrue);
      expect(actions.busyModeOn, isFalse);
    });

    test('locks every button under operations or the auto-pause (S4)', () {
      for (final source in ['ops', 'auto']) {
        final actions = sheetActions(
          of(statusJson(state: 'paused', pauseSource: source, busyMode: 10)),
        );
        expect(actions.lockedByOperations, isTrue);
        expect([
          actions.pause,
          actions.resume,
          actions.busyModeOn,
          actions.busyModeOff,
        ], everyElement(isFalse));
      }
    });

    test('offers nothing but busy mode off while closed', () {
      final actions = sheetActions(
        of(statusJson(state: 'closed', busyMode: 10)),
      );
      expect([
        actions.pause,
        actions.resume,
        actions.busyModeOn,
      ], everyElement(isFalse));
      expect(actions.busyModeOff, isTrue);
    });
  });

  group('the next change', () {
    test('is the earliest moment ahead', () {
      final status = of(
        statusJson(
          state: 'paused',
          pauseSource: 'restaurant',
          stateUntil: now.add(const Duration(minutes: 15)),
          closesAt: now.add(const Duration(hours: 3)),
        ),
      );
      expect(nextChange(status, now), now.add(const Duration(minutes: 15)));
      expect(
        nextChange(status, now.add(const Duration(minutes: 20))),
        now.add(const Duration(hours: 3)),
      );
      expect(nextChange(status, now.add(const Duration(hours: 4))), isNull);
    });
  });

  group('the notices (RA §16 #3, #24, #25)', () {
    Map<String, Object?> event(String kind, Map<String, Object?> values) => {
      'type': 'restaurant.state_changed',
      'kind': kind,
      'values': values,
    };

    test('reads the auto-pause, the pause’s end and the reminder', () {
      expect(
        statusNotice(event('auto_paused', {'count': 3})),
        isA<AutoPaused>().having((n) => n.count, 'count', 3),
      );
      expect(
        statusNotice(event('pause_ended', {'push': true})),
        isA<PauseEnded>(),
      );
      expect(
        statusNotice(event('busy_reminder', {'extraMin': 20})),
        isA<BusyReminder>().having((n) => n.minutes, 'minutes', 20),
      );
    });

    test('stays silent for the rest', () {
      expect(statusNotice(event('pause_ended', {'push': false})), isNull);
      expect(statusNotice(event('paused', {})), isNull);
      expect(
        statusNotice({'type': 'order.placed', 'kind': 'auto_paused'}),
        isNull,
      );
    });
  });
}
