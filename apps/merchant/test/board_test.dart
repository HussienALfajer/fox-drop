import 'package:core_realtime/core_realtime.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:merchant/src/board/alerts.dart';
import 'package:merchant/src/board/board.dart';
import 'package:merchant/src/board/commands.dart';

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

    test("operations' cancellation after acceptance rings until «حسناً» "
        '(RA §8.14)', () {
      final state = board([
        orderJson(id: a, placed: placedAt.add(const Duration(minutes: 40))),
        orderJson(
          id: b,
          status: 'cancelled',
          acceptedAfter: Duration.zero,
          cancellation: cancellationJson(),
        ),
        // A cancelled order without the record never rings.
        orderJson(id: c, status: 'cancelled'),
      ]);
      final rings = ringing(state);
      expect(rings.map((r) => r.order.id), [b, a]);
      expect(
        rings.first,
        isA<CancelledRinging>().having(
          (r) => r.cancellation.label,
          'label',
          'تعذر الوصول إلى الزبون',
        ),
      );
      expect(columnOf(state.orders[1]), isNull);
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

    test('operations deciding for the restaurant chime with their message '
        '(RA §8.15, §16 #5–6)', () {
      final memory = AlertMemory();
      final rejected = step(
        memory,
        [],
        events: [
          {
            'type': 'order.rejected',
            'orderId': a,
            'number': '10001',
            'reason': 'restaurant_closed',
            'byOperations': true,
          },
          // The restaurant's own decision on another device: no notice.
          {
            'type': 'order.rejected',
            'orderId': b,
            'number': '10002',
            'reason': 'too_busy',
            'byOperations': false,
          },
        ],
      );
      expect(rejected.chime, isTrue);
      expect(
        rejected.notices.single,
        isA<RejectedByOperations>()
            .having((n) => n.number, 'number', '10001')
            .having((n) => n.reason, 'reason', 'restaurant_closed'),
      );
      final accepted = step(
        AlertMemory(),
        [
          orderJson(
            id: a,
            status: 'accepted',
            acceptedAfter: Duration.zero,
            prepMin: 25,
            byOperations: true,
          ),
        ],
        events: [
          {
            'type': 'order.accepted',
            'orderId': a,
            'number': '10001',
            'reason': null,
            'byOperations': true,
          },
        ],
      );
      expect(
        accepted.notices.single,
        isA<AcceptedByOperations>().having((n) => n.prepMin, 'prepMin', 25),
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

    test("the customer's cancellation chimes with its message (RA §8.3)", () {
      final result = step(
        AlertMemory(),
        [],
        events: [
          {
            'type': 'order.cancelled',
            'number': '10001',
            'reason': 'changed_mind',
            'byOperations': false,
            'byCustomer': true,
          },
        ],
      );
      expect(result.chime, isTrue);
      expect(
        result.notices.single,
        isA<CustomerCancelled>().having((n) => n.number, 'number', '10001'),
      );
    });

    test("operations' cancellation that rings has no chime notice of its own; "
        'a placed order operations cancelled keeps its chime', () {
      final rings = step(
        AlertMemory(),
        [
          orderJson(
            id: a,
            status: 'cancelled',
            acceptedAfter: Duration.zero,
            cancellation: cancellationJson(),
          ),
        ],
        events: [
          {
            'type': 'order.cancelled',
            'orderId': a,
            'number': '10001',
            'reason': 'customer_unreachable',
            'byOperations': true,
            'byCustomer': false,
          },
        ],
      );
      expect(rings.ring, isTrue);
      expect(rings.notices, isEmpty);
      final placed = step(
        AlertMemory(),
        [],
        events: [
          {
            'type': 'order.cancelled',
            'orderId': b,
            'number': '10002',
            'reason': 'customer_unreachable',
            'byOperations': true,
            'byCustomer': false,
          },
        ],
      );
      expect(placed.chime, isTrue);
      expect(
        placed.notices.single,
        isA<Cancelled>().having((n) => n.number, 'number', '10002'),
      );
    });

    test('«حسناً» on any device stops the ring without a notice', () {
      final memory = AlertMemory();
      final cancelled = orderJson(
        status: 'cancelled',
        acceptedAfter: Duration.zero,
        cancellation: cancellationJson(),
      );
      expect(step(memory, [cancelled]).ring, isTrue);
      final acknowledged = step(
        memory,
        [],
        events: [
          {
            'type': 'order.cancellation_acknowledged',
            'orderId': a,
            'number': '10001',
            'reason': null,
            'byOperations': false,
            'byCustomer': false,
          },
        ],
      );
      expect(acknowledged.ring, isFalse);
      expect(acknowledged.notices, isEmpty);
      expect(acknowledged.chime, isFalse);
    });

    test('a pickup request voided by the cancellation says nothing', () {
      final memory = AlertMemory();
      step(memory, [orderJson(status: 'ready', request: requestJson())]);
      final cancelled = step(memory, [
        orderJson(
          status: 'cancelled',
          version: 2,
          acceptedAfter: Duration.zero,
          request: requestJson(status: 'voided', outcome: 'cancelled'),
          cancellation: cancellationJson(),
        ),
      ]);
      expect(cancelled.notices, isEmpty);
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

    test('a cancelled order never chimes the captain arriving or waiting', () {
      final memory = AlertMemory();
      final before = orderJson(
        status: 'accepted',
        acceptedAfter: Duration.zero,
        captainTrack: 'assigned',
        captainName: 'سامر',
      );
      // An older server still sends the arrival on a cancelled order.
      final cancelled = orderJson(
        status: 'cancelled',
        acceptedAfter: Duration.zero,
        captainTrack: 'at_merchant',
        captainName: 'سامر',
        arrivedAt: placedAt,
        version: 2,
        cancellation: cancellationJson(),
      );
      step(memory, [before]);
      final later = placedAt.add(const Duration(minutes: 10));
      expect(
        step(memory, [cancelled], now: later).notices,
        isNot(
          contains(anyOf(isA<CaptainArrived>(), isA<CaptainKeptWaiting>())),
        ),
      );
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

  group("operations' time and report chimes (RA §16 #12, #37)", () {
    test('a prep time change chimes with the time on the fetched board, and '
        'the late chime starts again from it', () {
      final memory = AlertMemory();
      final late = orderJson(
        status: 'accepted',
        acceptedAfter: Duration.zero,
        prepMin: 20,
      );
      final moved = {...late, 'version': 3, ..._prep(30)};
      final now = placedAt.add(const Duration(minutes: 21));
      final first = alertStep(
        memory,
        state: LiveState(value: board([late]), live: true),
        events: const [],
        now: now,
      );
      expect(first.notices.single, isA<PrepLate>());
      // Operations added 10 minutes: due at 30, late again from then.
      final changed = alertStep(
        memory,
        state: LiveState(value: board([moved]), live: true),
        events: const [
          {
            'type': 'order.time_changed',
            'orderId': a,
            'number': '10001',
            'reason': 'prep_time_changed',
          },
        ],
        now: now,
      );
      expect(
        changed.notices.single,
        isA<PrepTimeChanged>()
            .having((n) => n.number, 'number', '10001')
            .having((n) => n.prepMin, 'prepMin', 30),
      );
      expect(changed.chime, isTrue);
      final lateAgain = alertStep(
        memory,
        state: LiveState(value: board([moved]), live: true),
        events: const [],
        now: placedAt.add(const Duration(minutes: 30)),
      );
      expect(lateAgain.notices.single, isA<PrepLate>());
    });

    test('a promised time change alone says nothing to the restaurant', () {
      final result = alertStep(
        AlertMemory(),
        state: LiveState(value: board([]), live: true),
        events: const [
          {
            'type': 'order.time_changed',
            'orderId': a,
            'number': '10001',
            'reason': 'promised_time_changed',
          },
        ],
        now: placedAt,
      );
      expect(result.notices, isEmpty);
    });

    test("closing the report chimes with operations' reason", () {
      final result = alertStep(
        AlertMemory(),
        state: LiveState(value: board([]), live: true),
        events: const [
          {
            'type': 'order.item_report_closed',
            'orderId': a,
            'number': '10001',
            'reason': 'الزبون يقبل الطلب بدون الصنف',
          },
          // Reporting and withdrawing only refresh the board.
          {'type': 'order.item_reported', 'orderId': a, 'number': '10001'},
          {
            'type': 'order.item_report_withdrawn',
            'orderId': a,
            'number': '10001',
          },
        ],
        now: placedAt,
      );
      expect(result.chime, isTrue);
      expect(
        result.notices.single,
        isA<ItemReportClosed>()
            .having((n) => n.number, 'number', '10001')
            .having((n) => n.reason, 'reason', 'الزبون يقبل الطلب بدون الصنف'),
      );
    });
  });

  group('the item-unavailable report (RA §8.12, §8.10)', () {
    BoardOrder one(Map<String, Object?> order) => board([order]).orders.single;

    test('is offered on an accepted or ready order without a pickup request '
        'or a report open', () {
      expect(
        canReportItems(
          one(orderJson(status: 'accepted', acceptedAfter: Duration.zero)),
        ),
        isTrue,
      );
      // A request the restaurant refused no longer blocks it (RA §8.10
      // item 7).
      expect(
        canReportItems(
          one(
            orderJson(
              status: 'ready',
              acceptedAfter: Duration.zero,
              captainTrack: 'at_merchant',
              captainName: 'سامر',
              arrivedAt: placedAt,
              request: requestJson(status: 'rejected', outcome: 'incomplete'),
            ),
          ),
        ),
        isTrue,
      );
      expect(canReportItems(one(orderJson())), isFalse);
      expect(
        canReportItems(
          one(
            orderJson(
              status: 'ready',
              acceptedAfter: Duration.zero,
              captainTrack: 'pickup_pending',
              request: requestJson(),
            ),
          ),
        ),
        isFalse,
      );
      expect(
        canReportItems(
          one(
            orderJson(
              status: 'picked_up',
              acceptedAfter: Duration.zero,
              pickedUpAt: placedAt,
            ),
          ),
        ),
        isFalse,
      );
      final reported = one(
        orderJson(
          status: 'accepted',
          acceptedAfter: Duration.zero,
          itemReport: itemReportJson(),
        ),
      );
      expect(canReportItems(reported), isFalse);
      expect(canWithdrawItemReport(reported), isTrue);
      expect(
        canWithdrawItemReport(
          one(orderJson(status: 'accepted', acceptedAfter: Duration.zero)),
        ),
        isFalse,
      );
    });

    test('needs one item at least; its body tells its choices apart', () {
      expect(const ItemReport({}).complete, isFalse);
      expect(const ItemReport({shawarmaId: true}).complete, isTrue);
      expect(
        const ItemReport({shawarmaId: true}).body,
        isNot(const ItemReport({shawarmaId: false}).body),
      );
      expect(
        const ItemReport({shawarmaId: true}).body,
        isNot(
          const ItemReport({
            shawarmaId: true,
          }, note: 'insufficient_quantity').body,
        ),
      );
    });
  });

  group('the rejection (RA §8.6)', () {
    test('needs items only for «صنف غير متوفر»', () {
      expect(const Rejection(RejectReason.itemUnavailable).complete, isFalse);
      expect(
        const Rejection(
          RejectReason.itemUnavailable,
          items: {shawarmaId: true},
        ).complete,
        isTrue,
      );
      expect(const Rejection(RejectReason.restaurantClosed).complete, isTrue);
      expect(
        const Rejection(
          RejectReason.tooBusy,
          items: {shawarmaId: true},
        ).complete,
        isFalse,
      );
    });

    test('its body tells its choices apart, for the key', () {
      expect(
        const Rejection(RejectReason.tooBusy, step: BusyModeStep(10)).body,
        isNot(const Rejection(RejectReason.tooBusy, step: PauseStep()).body),
      );
      expect(
        const Rejection(
          RejectReason.itemUnavailable,
          items: {shawarmaId: true},
        ).body,
        isNot(
          const Rejection(
            RejectReason.itemUnavailable,
            items: {shawarmaId: false},
          ).body,
        ),
      );
    });
  });
}

/// The `acceptance` of an order accepted at [placedAt] with [prepMin].
Map<String, Object?> _prep(int prepMin) => {
  'acceptance': {
    'at': placedAt.toIso8601String(),
    'prepMin': prepMin,
    'prepDueAt': placedAt.add(Duration(minutes: prepMin)).toIso8601String(),
    'deviceName': 'كاشير 1',
    'byOperations': false,
  },
};
