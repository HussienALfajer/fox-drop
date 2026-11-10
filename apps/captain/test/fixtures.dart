import 'dart:async';
import 'dart:convert';

import 'package:captain/src/api.dart';
import 'package:captain/src/app.dart';
import 'package:captain/src/auth.dart';
import 'package:captain/src/push.dart';
import 'package:captain/src/work/alerts.dart';
import 'package:captain/src/work/commands.dart';
import 'package:captain/src/work/location.dart';
import 'package:core_auth/testing.dart';
import 'package:core_push/testing.dart';
import 'package:core_realtime/core_realtime.dart';
import 'package:core_storage/core_storage.dart';
import 'package:core_time/core_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const accountId = '00000000-0000-4000-8000-000000000001';
const captainId = '00000000-0000-4000-8000-000000000002';
const captainChannel = 'captain:$captainId';
const orderId = '00000000-0000-4000-8000-0000000000a1';
const offerId = '00000000-0000-4000-8000-0000000000c1';
const requestId = '00000000-0000-4000-8000-0000000000b1';

/// The fixtures' moment: what the server's clock says during a test.
final now = DateTime.utc(2026, 11, 7, 12);

/// The restaurant and the customer's pin, about 1.1 km apart.
const restaurant = (latitude: 36.586, longitude: 37.044);
const pin = (latitude: 36.596, longitude: 37.044);

Map<String, Object?> moneyJson(String amount, [String currency = 'TRY']) => {
  'amount': amount,
  'currency': currency,
};

/// `GET /v1/captain/availability`.
Map<String, Object?> availabilityJson({
  String state = 'offline',
  List<String> reasons = const [],
  String usage = '0',
}) => {
  'availability': {
    'state': state,
    'since': state == 'offline' ? null : now.toIso8601String(),
    'reasons': reasons,
    'suspensionReason': null,
    'suspendedUntil': null,
  },
  'custody': {
    'usage': moneyJson(usage),
    'limit': moneyJson('500000'),
    'warn': false,
    'closedDue': moneyJson('0'),
    'lastCutoff': now.toIso8601String(),
  },
};

/// An open offer of `GET /v1/captain/offers/current`.
Map<String, Object?> offerJson({Duration left = const Duration(seconds: 40)}) =>
    {
      'id': offerId,
      'status': 'open',
      'orderId': orderId,
      'number': '10423',
      'fromOperations': true,
      'offeredAt': now.toIso8601String(),
      'expiresAt': now.add(left).toIso8601String(),
      'pay': moneyJson('3500'),
      'restaurant': {
        'name': 'مطعم الشام',
        'location': {
          'latitude': restaurant.latitude,
          'longitude': restaurant.longitude,
        },
        'distanceMetres': 1200,
      },
      'customer': {'neighbourhood': 'حي الشهداء', 'tripMetres': 2800},
      'pickupPayment': moneyJson('40000'),
      'collect': moneyJson('41000'),
      'preparation': {
        'ready': false,
        'readyAt': now.add(const Duration(minutes: 8)).toIso8601String(),
      },
    };

/// The active order of `GET /v1/captain/orders/active`.
Map<String, Object?> orderJson({
  String status = 'accepted',
  String track = 'assigned',
  int version = 3,
  bool ready = false,
  Map<String, Object?>? request,
  DateTime? disputedAt,
  String? awayReason,
  bool itemReportOpen = false,
  bool editUnacknowledged = false,
  String pickupPayment = '40000',
  String collect = '41000',
  int quantity = 2,
  bool pickedUp = false,
}) {
  final atRestaurant = track != 'assigned';
  final atCustomer = track == 'at_customer';
  return {
    'id': orderId,
    'number': '10423',
    'status': status,
    'version': version,
    'captainTrack': track,
    'restaurant': {
      'name': 'مطعم الشام',
      'address': 'شارع المطاعم',
      'phone': '+963944111111',
      'location': {
        'latitude': restaurant.latitude,
        'longitude': restaurant.longitude,
      },
    },
    'preparation': {
      'ready': ready,
      'readyAt': ready ? now.toIso8601String() : null,
      'prepDueAt': now.add(const Duration(minutes: 8)).toIso8601String(),
    },
    'arrival': atRestaurant
        ? {'at': now.subtract(const Duration(minutes: 3)).toIso8601String()}
        : null,
    'itemCount': 2,
    'lines': [
      {
        'name': 'شاورما',
        'quantity': quantity,
        'options': [
          {'name': 'كبير'},
        ],
        'note': 'بدون بصل',
      },
    ],
    'note': null,
    'pickupPayment': moneyJson(pickupPayment),
    'collect': moneyJson(collect),
    'pickup': {
      'proposedLines': [moneyJson('40000')],
      'request': request,
      'pickedUpAt': pickedUp ? now.toIso8601String() : null,
      'disputedAt': disputedAt?.toIso8601String(),
    },
    'customer': {
      'name': 'أحمد',
      'phone': '+963944222222',
      'location': {'latitude': pin.latitude, 'longitude': pin.longitude},
      'address': {
        'neighbourhood': 'حي الشهداء',
        'street': 'شارع الجامع',
        'floor': '2',
        'landmark': 'قرب الفرن',
        'directions': null,
      },
      'payIn': 'USD',
      'collectEquivalents': [moneyJson('1000', 'USD')],
      'promisedAt': now.add(const Duration(minutes: 40)).toIso8601String(),
      'arrival': atCustomer
          ? {'at': now.toIso8601String(), 'awayReason': awayReason}
          : null,
    },
    'radii': {'restaurantMetres': 150, 'customerMetres': 200},
    'itemReportOpen': itemReportOpen,
    'editUnacknowledged': editUnacknowledged,
  };
}

/// An order of this captain cancelled by operations (CA §9.10), as
/// `GET /v1/captain/orders/active` sends it beside the active order.
Map<String, Object?> cancelledJson({
  String? cash = 'returned',
  Map<String, Object?>? compensation,
}) => {
  'orderId': orderId,
  'number': '10423',
  'reason': 'طلب الزبون الإلغاء',
  'cash': cash,
  'compensation': compensation,
  'at': now.toIso8601String(),
};

/// An order operations took from this captain before the pickup (CA §9.10,
/// slice 2.12a), as `GET /v1/captain/orders/active` sends it.
Map<String, Object?> withdrawnJson({String? cash}) => {
  'orderId': orderId,
  'number': '10423',
  'reason': 'تأخر الكابتن',
  'cash': cash,
  'at': now.toIso8601String(),
};

/// An order of this captain operations ended with an outcome (CA §9.10,
/// §9.12), as `GET /v1/captain/orders/active` sends it beside the active
/// order.
Map<String, Object?> endedJson({
  String outcome = 'failed_other',
  String status = 'failed',
  String? food = 'returned_to_restaurant',
  Map<String, Object?>? pay,
  Map<String, Object?>? charge,
}) => {
  'orderId': orderId,
  'number': '10423',
  'outcome': outcome,
  'status': status,
  'food': food,
  'pay': pay,
  'charge': charge,
  'at': now.toIso8601String(),
};

/// A pickup request of the active order.
Map<String, Object?> requestJson({
  String status = 'open',
  String? outcome,
  List<Map<String, Object?>>? received,
}) => {
  'id': requestId,
  'status': status,
  'outcome': outcome,
  'amount': moneyJson('40000'),
  'lines': [moneyJson('40000')],
  'receivedLines': received,
  'openedAt': now.toIso8601String(),
  'confirmBy': now.add(const Duration(seconds: 60)).toIso8601String(),
  'closedAt': status == 'open' ? null : now.toIso8601String(),
};

Map<String, Object?> _reason(String code, String label, [bool text = false]) =>
    {'code': code, 'label': label, 'note': text ? 'required' : 'none'};

/// `GET /v1/captain/content` with the defaults of AP Appendix B.
Map<String, Object?> contentJson() => {
  'reasons': {
    'captain_cannot_complete': [_reason('accident', 'حادث')],
    'captain_away': [
      _reason('customer_requested_other_place', 'الزبون طلب مكاناً آخر'),
      _reason('pin_inaccurate', 'موقع الزبون على الخريطة غير دقيق'),
      _reason('other', 'أخرى', true),
    ],
    'shortfall': [
      _reason('customer_short', 'الزبون لا يملك المبلغ كاملاً'),
      _reason('counting_error', 'خطأ في العد'),
      _reason('other', 'أخرى', true),
    ],
    'food_after_failed': [_reason('destroyed', 'أُتلف')],
    'captain_ticket_type': [_reason('other', 'أخرى')],
    'captain_problem': [_reason('other', 'أخرى')],
  },
  'faq': [
    {'question': 'متى أستلم أرباحي؟', 'answer': 'كل يوم خميس.'},
  ],
  'workRules': 'العمل حر.\nالخوذة إلزامية.',
};

/// The delivery summary of `POST .../deliver`.
Map<String, Object?> summaryJson() => {
  'summary': {
    'orderId': orderId,
    'number': '10423',
    'pay': {
      'base': '3000',
      'distance': '500',
      'topUp': '0',
      'waiting': '0',
      'total': '3500',
      'currency': 'TRY',
    },
    'custodyChange': moneyJson('1000'),
    'handInToday': moneyJson('41000'),
  },
};

Fix fixAt(({double latitude, double longitude}) point, {double accuracy = 8}) =>
    Fix(
      latitude: point.latitude,
      longitude: point.longitude,
      accuracyMetres: accuracy,
      recordedAt: now,
      simulated: false,
    );

class FakeLocation implements LocationSource {
  FakeLocation(this.fix);

  Fix? fix;
  LocationProblem? problem;
  final _tracked = StreamController<Fix>.broadcast();
  int tracking = 0;

  @override
  Future<LocationProblem?> ensureAccess() async => problem;

  @override
  Future<Fix?> current() async => fix;

  @override
  Stream<Fix> track() {
    tracking++;
    return _tracked.stream;
  }

  /// The phone moves to [point].
  void move(({double latitude, double longitude}) point) {
    fix = fixAt(point);
    _tracked.add(fix!);
  }
}

class FakeRinger implements Ringer {
  bool ringing = false;
  int chimes = 0;
  int cancellations = 0;

  @override
  void ring() => ringing = true;

  @override
  void stop() => ringing = false;

  @override
  void chime() => chimes++;

  @override
  void cancellation() => cancellations++;
}

class FakeTransport implements RealtimeTransport {
  /// Every listener of each channel: the feed and the platform broadcasts
  /// listen to the same one, as on `CentrifugeTransport`.
  final channels = <String, List<StreamController<RealtimeSignal>>>{};

  @override
  Stream<RealtimeSignal> channel(String name) {
    final controller = StreamController<RealtimeSignal>();
    (channels[name] ??= []).add(controller);
    controller.onCancel = () => channels[name]!.remove(controller);
    return controller.stream;
  }

  void send(String name, RealtimeSignal signal) {
    for (final controller in [...?channels[name]]) {
      controller.add(signal);
    }
  }

  /// The channel says the order changed to [version].
  void event(String type, int version) => send(
    captainChannel,
    RealtimePublication({'type': type, 'orderId': orderId, 'version': version}),
  );
}

/// The stored session of a signed-in captain.
Map<String, String> signedIn() => {
  'session': jsonEncode({
    'accessToken': 'access-0',
    'accessTokenExpiresAt': DateTime.now()
        .add(const Duration(minutes: 10))
        .toUtc()
        .toIso8601String(),
    'refreshToken': 'refresh-0',
    'accountId': accountId,
  }),
};

/// The app against a fake server, channel, location and ring.
class TestApp {
  final server = FakeServer();
  final transport = FakeTransport();
  final ringer = FakeRinger();
  final location = FakeLocation(fixAt(restaurant));
  final launched = <Uri>[];
  final push = FakePush();
  // The phone allows notifications unless a test says otherwise.
  final permission = FakeNotificationPermission(allowed: true);
  late final ProviderContainer container;

  /// The server's clock in the test, which [advance] moves.
  DateTime clockNow = now;

  /// The answers of the three reads, consumed in order (the last repeats);
  /// [cancelled], [withdrawn] and [ended] go with every answer of the active
  /// order.
  void work({
    required List<Map<String, Object?>> availability,
    List<Map<String, Object?>?> offers = const [null],
    List<Map<String, Object?>?> orders = const [null],
    Map<String, Object?>? cancelled,
    Map<String, Object?>? withdrawn,
    Map<String, Object?>? ended,
  }) {
    server.on('/v1/captain/availability', [
      for (final a in availability) FakeAnswer(200, a),
    ]);
    server.on('/v1/captain/offers/current', [
      for (final o in offers) FakeAnswer(200, {'offer': o}),
    ]);
    server.on('/v1/captain/orders/active', [
      for (final o in orders)
        FakeAnswer(200, {
          'order': o,
          'cancelled': cancelled,
          'withdrawn': withdrawn,
          'ended': ended,
        }),
    ]);
  }

  /// The answer of `GET /v1/captain/platform` (CA §4.2, §4.8): no update
  /// and no maintenance unless a test says otherwise.
  /// `GET /v1/captain/terms` (AP §9.13): version 1, accepted, unless a test
  /// says otherwise.
  void terms({int version = 1, bool pending = false}) =>
      server.on('/v1/captain/terms', [
        FakeAnswer(200, {
          'version': version,
          'body': 'شروط العمل',
          'publishedAt': '2026-11-08T09:00:00.000Z',
          'pending': pending,
        }),
      ]);

  void platform({String updateNeed = 'none', bool maintenance = false}) =>
      server.on('/v1/captain/platform', [
        FakeAnswer(200, {'updateNeed': updateNeed, 'maintenance': maintenance}),
      ]);

  void emergencyStop({bool active = false}) =>
      server.on('/v1/captain/emergency-stop', [
        FakeAnswer(200, {
          'active': active,
          'startedAt': active ? '2026-11-09T09:00:00.000Z' : null,
        }),
      ]);

  Future<void> pump(WidgetTester tester, {Map<String, String>? stored}) async {
    if (!server.routes.containsKey('/v1/captain/platform')) platform();
    if (!server.routes.containsKey('/v1/captain/emergency-stop')) {
      emergencyStop();
    }
    if (!server.routes.containsKey('/v1/captain/terms')) terms();
    server.on('/v1/captain/content', [FakeAnswer(200, contentJson())]);
    server.on('/v1/captain/push-token', [
      const FakeAnswer(200, {'status': 'registered'}),
    ]);
    server.on('/v1/captain/auth/session', [
      const FakeAnswer(200, {
        'accountId': accountId,
        'captainId': captainId,
        'sessionId': '00000000-0000-4000-8000-000000000003',
      }),
    ]);
    container = ProviderContainer(
      overrides: [
        authApiProvider.overrideWithValue(server.client()),
        coreApiProvider.overrideWith((ref) {
          final api = server.client();
          api.dio.interceptors.add(captainAuth.interceptor(ref, api.dio));
          return api;
        }),
        captainAuth.store.overrideWithValue(
          MemorySecureStore({...stored ?? signedIn()}),
        ),
        captainAuth.launch.overrideWithValue((uri) async {
          launched.add(uri);
          return true;
        }),
        appVersionProvider.overrideWith((ref) async => '0.1.0+1'),
        realtimeTransportProvider.overrideWithValue(transport),
        ringerProvider.overrideWithValue(ringer),
        keepScreenOnProvider.overrideWithValue((on) {}),
        locationSourceProvider.overrideWithValue(location),
        pushProvider.overrideWithValue(push),
        notificationPermissionProvider.overrideWithValue(permission),
        serverClockProvider.overrideWithValue(
          ServerClock(deviceNow: () => clockNow),
        ),
      ],
      retry: (retryCount, error) => null,
    );
    container.read(commandsProvider.notifier).backoff = (_) =>
        const Duration(milliseconds: 10);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const CaptainApp(),
      ),
    );
    await settle(tester);
  }

  /// The channel comes up, so the feed fetches.
  Future<void> live(WidgetTester tester) async {
    transport.send(captainChannel, const RealtimeUp(recovered: false));
    await settle(tester);
  }

  /// Lets the answers arrive; the home's one-second tick never settles.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  /// Moves the clock and the frames by [by].
  Future<void> advance(WidgetTester tester, Duration by) async {
    clockNow = clockNow.add(by);
    await tester.pump(by);
  }

  /// Scrolls to the widget, then taps it, with no message over it.
  Future<void> tapVisible(WidgetTester tester, Finder finder) async {
    tester
        .state<ScaffoldMessengerState>(find.byType(ScaffoldMessenger))
        .removeCurrentSnackBar();
    await tester.ensureVisible(finder);
    await tester.pump();
    await tester.tap(finder);
  }

  /// Disposes the container inside the test, so the feed's timers stop
  /// before Flutter checks for pending timers.
  Future<void> done(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    container.dispose();
    await tester.pump(const Duration(seconds: 1));
  }
}
