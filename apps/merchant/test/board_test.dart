import 'package:core_realtime/core_realtime.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:merchant/src/board/alerts.dart';
import 'package:merchant/src/board/board.dart';

import 'board_fixtures.dart';

// The board's rules (RA §4.4, §4.7, §8.1–8.10) as pure functions.
void main() {
  const a = '00000000-0000-4000-8000-0000000000a1';
  const b = '00000000-0000-4000-8000-0000000000a2';
  const c = '00000000-0000-4000-8000-0000000000a3';

  group('columns and sorting (RA §8.1–8.2)', () {
    test('each status has its column, oldest new order first', () {
      final state = board([
        orderJson(id: a, placed: placedAt.add(const Duration(minutes: 2))),
        orderJson(id: b),
        orderJson(id: c, status: 'picked_up', pickedUpAt: placedAt),
      ]);
      expect(columnOrders(state, BoardColumn.incoming).map((o) => o.id), [
        b,
        a,
      ]);
      expect(columnOrders(state, BoardColumn.withCaptain).map((o) => o.id), [
        c,
      ]);
    });

    test('in preparation, the least time left comes first', () {
      final state = board([
        orderJson(
          id: a,
          status: 'accepted',
          acceptedAfter: Duration.zero,
          prepMin: 30,
        ),
        orderJson(
          id: b,
          status: 'accepted',
          acceptedAfter: Duration.zero,
          prepMin: 10,
        ),
      ]);
      expect(columnOrders(state, BoardColumn.preparing).map((o) => o.id), [
        b,
        a,
      ]);
    });

    test('ready: the waiting captain on top', () {
      final state = board([
        orderJson(id: a, status: 'ready', captainTrack: 'assigned'),
        orderJson(
          id: b,
          status: 'ready',
          captainTrack: 'at_merchant',
          arrivedAt: placedAt,
        ),
      ]);
      expect(columnOrders(state, BoardColumn.ready).map((o) => o.id), [b, a]);
    });

    test('late: a new order past the accept alert, a prep past its time', () {
      final placed = board([orderJson()]).orders.single;
      expect(isLate(placed, placedAt.add(const Duration(minutes: 2))), isFalse);
      expect(isLate(placed, placedAt.add(const Duration(minutes: 3))), isTrue);
      final preparing = board([
        orderJson(status: 'accepted', acceptedAfter: Duration.zero),
      ]).orders.single;
      expect(
        isLate(preparing, placedAt.add(const Duration(minutes: 19))),
        isFalse,
      );
      expect(
        isLate(preparing, placedAt.add(const Duration(minutes: 20))),
        isTrue,
      );
    });

    test('the captain line follows the captain track (RA §8.1)', () {
      CaptainLine? line(Map<String, Object?> json) =>
          captainLine(board([json]).orders.single);
      expect(
        line(orderJson(status: 'accepted', captainTrack: 'searching')),
        isA<WaitingForCaptain>(),
      );
      expect(
        line(
          orderJson(
            status: 'accepted',
            captainTrack: 'assigned',
            captainName: 'سامر',
          ),
        ),
        isA<CaptainOnTheWay>().having((l) => l.name, 'name', 'سامر'),
      );
      expect(
        line(orderJson(status: 'ready', captainTrack: 'pickup_pending')),
        isA<CaptainAsksPickup>(),
      );
      expect(line(orderJson(status: 'ready')), isA<WaitingForCaptain>());
      expect(line(orderJson()), isNull);
    });
  });

  group('what rings (RA §4.4)', () {
    test('new orders and open pickup requests, oldest first', () {
      final state = board([
        orderJson(
          id: a,
          status: 'ready',
          request: requestJson(
            confirmBy: placedAt.add(const Duration(minutes: 1)),
          ),
        ),
        orderJson(id: b, placed: placedAt.add(const Duration(minutes: 5))),
        orderJson(
          id: c,
          status: 'ready',
          request: requestJson(status: 'confirmed', outcome: 'restaurant'),
        ),
      ]);
      final rings = ringing(state);
      expect(rings.map((r) => r.order.id), [a, b]);
      expect(rings.first, isA<PickupRinging>());
    });
  });

  group('alerts (RA §4.7, §8.3, §8.7, §8.9, §8.10)', () {
    AlertStep step(
      AlertMemory memory,
      List<Map<String, Object?>> orders, {
      DateTime? now,
      bool live = true,
      List<Map<String, Object?>> events = const [],
      Set<String> answeredHere = const {},
    }) => alertStep(
      memory,
      state: LiveState(value: board(orders), live: live),
      events: events,
      now: now ?? placedAt,
      answeredHere: answeredHere,
    );

    test('rings while a new order waits, and stops once it is handled', () {
      final memory = AlertMemory();
      expect(step(memory, [orderJson()]).ring, isTrue);
      expect(
        step(memory, [
          orderJson(status: 'accepted', acceptedAfter: Duration.zero),
        ]).ring,
        isFalse,
      );
    });

    test('an automatic cancellation chimes with its message', () {
      final result = step(
        AlertMemory(),
        [],
        events: [
          {
            'type': 'order.cancelled',
            'number': '10001',
            'reason': 'merchant_auto_cancel',
          },
        ],
      );
      expect(result.chime, isTrue);
      expect(
        result.notices.single,
        isA<AutoCancelled>().having((n) => n.number, 'number', '10001'),
      );
    });

    test('a late prep chimes at its time, then every 5 minutes', () {
      final memory = AlertMemory();
      final order = orderJson(status: 'accepted', acceptedAfter: Duration.zero);
      DateTime at(int minutes, [int seconds = 0]) =>
          placedAt.add(Duration(minutes: minutes, seconds: seconds));
      expect(step(memory, [order], now: at(19)).notices, isEmpty);
      expect(
        step(memory, [order], now: at(20)).notices.single,
        isA<PrepLate>(),
      );
      expect(step(memory, [order], now: at(24, 59)).notices, isEmpty);
      expect(
        step(memory, [order], now: at(25)).notices.single,
        isA<PrepLate>(),
      );
    });

    test('the captain arriving chimes once; waiting past 10 minutes once', () {
      final memory = AlertMemory();
      final before = orderJson(
        status: 'ready',
        captainTrack: 'assigned',
        captainName: 'سامر',
      );
      final arrived = orderJson(
        status: 'ready',
        captainTrack: 'at_merchant',
        captainName: 'سامر',
        arrivedAt: placedAt,
        version: 2,
      );
      expect(step(memory, [before]).notices, isEmpty);
      expect(
        step(memory, [arrived]).notices.single,
        isA<CaptainArrived>().having((n) => n.name, 'name', 'سامر'),
      );
      final later = placedAt.add(const Duration(minutes: 10));
      expect(
        step(memory, [arrived], now: later).notices.single,
        isA<CaptainKeptWaiting>().having((n) => n.minutes, 'minutes', 10),
      );
      expect(step(memory, [arrived], now: later).notices, isEmpty);
    });

    test('a prompt closed by another device says who answered', () {
      final memory = AlertMemory();
      step(memory, [orderJson(status: 'ready', request: requestJson())]);
      final closed = step(memory, [
        orderJson(
          status: 'picked_up',
          version: 2,
          request: requestJson(
            status: 'confirmed',
            outcome: 'restaurant',
            closedBy: 'ليلى',
          ),
        ),
      ]);
      expect(
        closed.notices.single,
        isA<PickupClosed>().having((n) => n.userName, 'user', 'ليلى'),
      );
    });

    test('a prompt this device answered closes without a notice', () {
      final memory = AlertMemory();
      step(memory, [orderJson(status: 'ready', request: requestJson())]);
      final request = requestJson(status: 'confirmed', outcome: 'restaurant');
      final closed = step(
        memory,
        [orderJson(status: 'picked_up', version: 2, request: request)],
        answeredHere: {request['id']! as String},
      );
      expect(closed.notices, isEmpty);
    });

    test('30 seconds offline chime once', () {
      final memory = AlertMemory();
      expect(step(memory, [], live: false).chime, isFalse);
      final later = placedAt.add(const Duration(seconds: 30));
      expect(step(memory, [], live: false, now: later).chime, isTrue);
      expect(step(memory, [], live: false, now: later).chime, isFalse);
      step(memory, []);
      expect(step(memory, [], live: false, now: later).chime, isFalse);
    });
  });
}
