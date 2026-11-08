import 'dart:async';

import 'package:core_platform/core_platform.dart';
import 'package:core_realtime/core_realtime.dart';
import 'package:flutter_test/flutter_test.dart';

final on = EmergencyStop(active: true, startedAt: DateTime.utc(2026, 11, 9));

void main() {
  late List<Object> answers;
  late int reads;
  late EmergencyStopCheck check;
  late List<bool> switched;

  // Each read takes the next answer: a stop, or an error to throw.
  Future<EmergencyStop> read() async {
    reads++;
    final answer = answers.removeAt(0);
    if (answer is EmergencyStop) return answer;
    throw answer;
  }

  setUp(() {
    reads = 0;
    switched = [];
    check = EmergencyStopCheck(read);
    check.switched.listen(switched.add);
  });

  tearDown(() => check.dispose());

  testWidgets('shows no stop until the first answer', (tester) async {
    answers = [on];
    expect(check.stop.active, isFalse);
    check.start();
    await tester.pump();
    expect(check.stop, on);
  });

  testWidgets('the first answer is no switch; later changes are', (
    tester,
  ) async {
    answers = [on, EmergencyStop.none, on];
    check.start();
    await tester.pump();
    expect(switched, isEmpty);
    await check.check();
    await check.check();
    await tester.pump();
    expect(switched, [false, true]);
  });

  testWidgets('a first answer after a failed read is no switch either', (
    tester,
  ) async {
    answers = [Exception('offline'), on, EmergencyStop.none];
    check.start();
    await tester.pump();
    await tester.pump(const Duration(seconds: 5));
    expect(check.stop, on);
    await check.check();
    await tester.pump();
    expect(switched, [false]);
  });

  testWidgets('a check during a read reads once more after it', (tester) async {
    final first = Completer<EmergencyStop>();
    var calls = 0;
    final slow = EmergencyStopCheck(() {
      calls++;
      return calls == 1 ? first.future : Future.value(on);
    });
    addTearDown(slow.dispose);
    final running = slow.check();
    unawaited(slow.check());
    unawaited(slow.check());
    first.complete(EmergencyStop.none);
    await running;
    expect(calls, 2);
    expect(slow.stop, on);
  });

  testWidgets('a new stop seen without its end is a switch on', (tester) async {
    final later = EmergencyStop(
      active: true,
      startedAt: DateTime.utc(2026, 11, 9, 2),
    );
    answers = [on, later];
    check.start();
    await tester.pump();
    await check.check();
    await tester.pump();
    expect(switched, [true]);
  });

  testWidgets('an answer after dispose changes nothing', (tester) async {
    final first = Completer<EmergencyStop>();
    final late = EmergencyStopCheck(() => first.future);
    var notified = false;
    late.addListener(() => notified = true);
    final running = late.check();
    late.dispose();
    first.complete(on);
    await running;
    expect(notified, isFalse);
    expect(late.stop, EmergencyStop.none);
  });

  group('followPlatformBroadcasts', () {
    late StreamController<RealtimeSignal> channel;
    late int platformReads;
    late PlatformCheck platform;

    setUp(() {
      channel = StreamController<RealtimeSignal>();
      platformReads = 0;
      platform = PlatformCheck(() async {
        platformReads++;
        return PlatformStatus.clear;
      });
    });

    tearDown(() => platform.dispose());

    testWidgets('reads again on connecting and on each broadcast', (
      tester,
    ) async {
      answers = [on, EmergencyStop.none];
      final following = followPlatformBroadcasts(
        channel.stream,
        stop: check,
        platform: platform,
      );
      addTearDown(following.cancel);
      channel.add(const RealtimeUp(recovered: false));
      await tester.pump();
      expect((reads, platformReads), (1, 1));
      expect(check.stop, on);
      channel.add(
        const RealtimePublication({
          'type': 'platform.emergency_stop',
          'active': false,
        }),
      );
      await tester.pump();
      expect((reads, platformReads), (2, 1));
      expect(check.stop.active, isFalse);
      channel.add(
        const RealtimePublication({
          'type': 'platform.app_changed',
          'app': 'merchant',
        }),
      );
      await tester.pump();
      expect((reads, platformReads), (2, 2));
      // An order's publication is the feed's, not the platform's.
      channel.add(
        const RealtimePublication({
          'type': 'order.updated',
          'orderId': 'o1',
          'version': 3,
        }),
      );
      channel.add(const RealtimeDown());
      await tester.pump();
      expect((reads, platformReads), (2, 2));
    });
  });
}
