import 'package:captain/src/work/alerts.dart';
import 'package:captain/src/work/commands.dart';
import 'package:captain/src/work/door_payment.dart';
import 'package:captain/src/work/location.dart';
import 'package:captain/src/work/work.dart';
import 'package:core_api/core_api.dart';
import 'package:core_time/core_time.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

Work work({
  String state = 'online_available',
  Map<String, Object?>? offer,
  Map<String, Object?>? order,
}) => Work(
  availability: standardSerializers.deserializeWith(
    CaptainAvailabilityDtoOutput.serializer,
    availabilityJson(state: state),
  )!,
  offer: offer == null
      ? null
      : standardSerializers.deserializeWith(
          CaptainCurrentOfferDtoOutputOffer.serializer,
          offer,
        ),
  order: order == null
      ? null
      : standardSerializers.deserializeWith(
          CaptainActiveOrderDtoOutputOrder.serializer,
          order,
        ),
);

DioException refused(int status, [Object? body]) => DioException(
  requestOptions: RequestOptions(),
  response: status == 0
      ? null
      : Response(
          requestOptions: RequestOptions(),
          statusCode: status,
          data: body,
        ),
);

void main() {
  group('the door payment (CA §9.7)', () {
    test('reads typed amounts in minor units, and back', () {
      expect(minorOf('410'), '41000');
      expect(minorOf('10.5'), '1050');
      expect(minorOf('10,25'), '1025');
      expect(minorOf('0'), isNull);
      expect(minorOf('10.555'), isNull);
      expect(minorOf('abc'), isNull);
      expect(majorOf('41000'), '410');
      expect(majorOf('1050'), '10.5');
      expect(majorOf('5'), '0.05');
    });

    test("lists the amount due with the customer's pay-in currency first", () {
      const total = Money('41000', 'TRY');
      const usd = Money('1000', 'USD');
      expect(dueIn(total, [usd], null), [total, usd]);
      expect(dueIn(total, [usd], 'USD'), [usd, total]);
    });

    test('computes the change in the one currency received', () {
      const due = [Money('41000', 'TRY'), Money('1000', 'USD')];
      expect(
        changeDue([const Money('50000', 'TRY')], due),
        const Money('9000', 'TRY'),
      );
      expect(
        changeDue([const Money('2000', 'USD')], due),
        const Money('1000', 'USD'),
      );
      expect(
        changeDue([const Money('40000', 'TRY')], due),
        const Money('-1000', 'TRY'),
      );
      // Two currencies need the order's rates: the server checks them.
      expect(
        changeDue([
          const Money('1000', 'USD'),
          const Money('1000', 'TRY'),
        ], due),
        isNull,
      );
      expect(changeDue([], due), isNull);
    });
  });

  group('the refusals (CA §4.6, §15)', () {
    test('map to what the screen explains', () {
      expect(refusal({'error': 'offer_unavailable'}), isA<OfferUnavailable>());
      expect(
        refusal({'error': 'too_far_from_customer', 'distanceMetres': 640}),
        isA<TooFar>()
            .having((n) => n.fromCustomer, 'fromCustomer', true)
            .having((n) => n.distanceMetres, 'distance', 640),
      );
      expect(
        refusal({
          'error': 'shortfall_reason_required',
          'shortfall': {'amount': '1000', 'currency': 'TRY'},
        }),
        isA<ShortfallReasonRequired>().having(
          (n) => n.shortfall,
          'shortfall',
          const Money('1000', 'TRY'),
        ),
      );
      expect(
        refusal({
          'error': 'amount_due_changed',
          'order': {
            'collect': {'amount': '45000', 'currency': 'TRY'},
          },
        }),
        isA<AmountDueChanged>().having(
          (n) => n.amountDue,
          'amountDue',
          const Money('45000', 'TRY'),
        ),
      );
      expect(
        refusal({
          'error': 'online_blocked',
          'blocks': [
            {'kind': 'cash_limit', 'limit': '500000'},
          ],
        }),
        isA<OnlineBlocked>().having(
          (n) => n.blocks.single['kind'],
          'kind',
          'cash_limit',
        ),
      );
      expect(refusal({'error': 'weak_location'}), isA<WeakLocation>());
      expect(refusal('not json'), isA<CommandFailed>());
    });
  });

  group('the alerts (CA §14)', () {
    final answered = Answered();

    test(
      'an offer gone before its time is unavailable; one past it expired',
      () {
        final offered = work(offer: offerJson());
        expect(
          alertStep(offered, work(), now, answered).single,
          isA<OfferGone>(),
        );
        expect(
          alertStep(
            offered,
            work(),
            now.add(const Duration(minutes: 1)),
            answered,
          ).single,
          isA<OfferExpired>(),
        );
        // Answered here: nothing to announce.
        final mine = Answered()..offers.add(offerId);
        expect(alertStep(offered, work(), now, mine), isEmpty);
      },
    );

    test('an order not accepted here was assigned by operations', () {
      expect(
        alertStep(work(), work(order: orderJson()), now, answered).single,
        isA<AssignedByOperations>(),
      );
      final mine = Answered()..orders.add(orderId);
      expect(alertStep(work(), work(order: orderJson()), now, mine), isEmpty);
    });

    test('chimes for ready, the pickup and its refusal, and a dispute', () {
      final before = work(order: orderJson(track: 'at_merchant'));
      expect(
        alertStep(
          before,
          work(order: orderJson(track: 'at_merchant', ready: true)),
          now,
          answered,
        ).single,
        isA<OrderReady>(),
      );
      final pending = work(
        order: orderJson(track: 'pickup_pending', request: requestJson()),
      );
      expect(
        alertStep(
          pending,
          work(
            order: orderJson(
              status: 'picked_up',
              track: 'picked_up',
              request: requestJson(status: 'confirmed', outcome: 'operations'),
            ),
          ),
          now,
          answered,
        ).single,
        isA<PickedUp>().having((a) => a.byOperations, 'byOperations', true),
      );
      expect(
        alertStep(
          pending,
          work(
            order: orderJson(
              track: 'at_merchant',
              request: requestJson(status: 'rejected', outcome: 'incomplete'),
            ),
          ),
          now,
          answered,
        ).single,
        isA<PickupRefused>(),
      );
      final pickedUp = work(
        order: orderJson(status: 'picked_up', track: 'picked_up'),
      );
      expect(
        alertStep(
          pickedUp,
          work(
            order: orderJson(
              status: 'picked_up',
              track: 'picked_up',
              disputedAt: now,
            ),
          ),
          now,
          answered,
        ).single,
        isA<PickupDisputed>(),
      );
    });

    test('the offer rings while open and in time, unless answered here', () {
      final offered = work(offer: offerJson());
      expect(ringingOffer(offered, now, {}), isNotNull);
      expect(
        ringingOffer(offered, now.add(const Duration(seconds: 41)), {}),
        isNull,
      );
      expect(ringingOffer(offered, now, {offerId}), isNull);
    });
  });

  group('the location (CA §4.3)', () {
    late FakeLocation source;
    late List<List<Fix>> sent;
    late List<Object?> answers;
    late LocationTracker tracker;

    setUp(() {
      source = FakeLocation(null);
      sent = [];
      answers = [];
      tracker = LocationTracker(
        source: source,
        clock: ServerClock(deviceNow: () => now)
          ..offset = const Duration(seconds: 5),
        send: (points) async {
          sent.add(points);
          final answer = answers.isEmpty ? null : answers.removeAt(0);
          if (answer is DioException) throw answer;
        },
      );
    });

    tearDown(() => tracker.dispose());

    test(
      'keeps the points on the server clock and sends them oldest first',
      () async {
        tracker.start();
        source.move(restaurant);
        source.move(pin);
        await Future<void>.delayed(Duration.zero);
        expect(tracker.latest!.recordedAt, now.add(const Duration(seconds: 5)));
        await tracker.flush();
        expect(sent.single.map((p) => p.latitude), [
          restaurant.latitude,
          pin.latitude,
        ]);
        expect(tracker.queued, 0);
      },
    );

    test(
      'keeps the points when no answer comes, and drops them when offline',
      () async {
        tracker.start();
        source.move(restaurant);
        await Future<void>.delayed(Duration.zero);
        answers.add(refused(0));
        await tracker.flush();
        expect(tracker.queued, 1);
        answers.add(refused(503));
        await tracker.flush();
        expect(tracker.queued, 1);
        answers.add(refused(409, {'error': 'not_online'}));
        await tracker.flush();
        expect(tracker.queued, 0);
      },
    );

    test(
      'stops collecting when stopped, still sending what it holds',
      () async {
        tracker.start();
        source.move(restaurant);
        await Future<void>.delayed(Duration.zero);
        tracker.stop();
        expect(tracker.tracking, isFalse);
        source.move(pin);
        await Future<void>.delayed(Duration.zero);
        await tracker.flush();
        expect(sent.single, hasLength(1));
      },
    );
  });
}
