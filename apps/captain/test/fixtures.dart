import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:captain/src/api.dart';
import 'package:captain/src/app.dart';
import 'package:captain/src/auth.dart';
import 'package:captain/src/device_check/device_check.dart';
import 'package:captain/src/joining/application.dart';
import 'package:captain/src/joining/photo_check.dart';
import 'package:captain/src/profile/profile.dart';
import 'package:captain/src/push.dart';
import 'package:captain/src/statements.dart';
import 'package:captain/src/support/report_photo.dart';
import 'package:captain/src/work/alerts.dart';
import 'package:captain/src/work/call.dart';
import 'package:captain/src/work/commands.dart';
import 'package:captain/src/work/location.dart';
import 'package:captain/src/work/route.dart';
import 'package:core_alerts/testing.dart';
import 'package:core_auth/testing.dart';
import 'package:core_maps/core_maps.dart';
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
  String? lastOrderBy,
  String? lastOrderReason,
  int? offersExpired,
  Map<String, Object?>? office,
  bool warn = false,
  String closedDue = '0',
  DateTime? handInGraceUntil,
  DateTime? remitBy,
}) => {
  'office': office,
  'availability': {
    'state': state,
    'since': state == 'offline' ? null : now.toIso8601String(),
    'reasons': reasons,
    'suspensionReason': null,
    'suspendedUntil': null,
    'lastOrderBy': lastOrderBy,
    'lastOrderReason': lastOrderReason,
    'offersExpired': offersExpired,
  },
  'custody': {
    'usage': moneyJson(usage),
    'limit': moneyJson('500000'),
    'warn': warn,
    'closedDue': moneyJson(closedDue),
    'lastCutoff': now.toIso8601String(),
    'remitTolerance': moneyJson('0'),
    'handInGraceUntil': handInGraceUntil?.toIso8601String(),
    'remitBy': remitBy?.toIso8601String(),
  },
};

/// The city's office (CA §7.5, C13): Saturday to Thursday 09:00–23:00 on
/// the city's clock, open until 23:00 today unless closed (then it opens
/// on Sunday at 09:00).
Map<String, Object?> officeJson({bool open = true}) => {
  'latitude': 36.5862,
  'longitude': 37.0471,
  'hours': [
    for (final weekday in [6, 0, 1, 2, 3, 4])
      {'weekday': weekday, 'opensAt': 540, 'closesAt': 1380},
  ],
  'timeZone': 'Asia/Damascus',
  'open': open,
  // On Saturday 7 November: 23:00 in Azaz is 20:00 UTC; Sunday 09:00 is
  // 06:00 UTC.
  'closesAt': open ? '2026-11-07T20:00:00.000Z' : null,
  'opensAt': open ? null : '2026-11-08T06:00:00.000Z',
};

/// `GET /v1/captain/settings/max-pickup-amount` (CA §10.5, K2).
/// `GET /v1/captain/contract` (slice 2.35a): [phase] null for no contract.
/// CA §11 «أدائي» as the server answers it (slice 2.36b).
Map<String, Object?> performanceJson({
  int? rate,
  bool warn = false,
  List<Map<String, Object?>> offers = const [],
  List<Map<String, Object?>> violations = const [],
}) => {
  'acceptance': {
    'rate': rate,
    'accepted': rate == null ? 0 : 2,
    'answered': rate == null ? 0 : 3,
    'windowOffers': 50,
    'warn': warn,
    'alertPct': 70,
    'offers': offers,
  },
  'onTime': {'onTime': 4, 'counted': 5},
  'cancellations': 1,
  'windowDays': 90,
  'online': {'todayMinutes': 90, 'weekMinutes': 600},
  'violations': violations,
};

/// CA §12.1 «ملفي»'s data as the server answers it (slice 2.36c).
Map<String, Object?> profileJson() => {
  'foxDropId': 'C-00000002',
  'name': 'أحمد محمد علي',
  'phone': '+963912345678',
  'neighbourhood': 'الحي الشمالي',
  'vehicle': 'motorbike',
  'plateNumber': '12345',
};

/// One table's row for the captain's vehicle (CA §12.5), in TRY.
Map<String, Object?> payRateJson(String effectiveFrom, String basePay) => {
  'effectiveFrom': effectiveFrom,
  'basePay': {'amount': basePay, 'currency': 'TRY'},
  'includedMetres': 3000,
  'perExtraKm': {'amount': '500', 'currency': 'TRY'},
  'waitingPerMinute': {'amount': '100', 'currency': 'TRY'},
  'minimumPay': {'amount': '2000', 'currency': 'TRY'},
};

/// `GET /v1/captain/pay-table`: [current] null for none in force.
Map<String, Object?> payTableJson({
  Map<String, Object?>? current,
  List<Map<String, Object?>> announced = const [],
}) => {
  'vehicle': 'motorbike',
  'waitingThresholdMin': 10,
  'current': current,
  'announced': announced,
};

Map<String, Object?> contractJson(String? phase) => {
  'contract': phase == null
      ? null
      : {
          'signedOn': '2026-11-19',
          'startsOn': '2026-11-19',
          'probationEndsOn': '2026-12-19',
          'commitmentStartsOn': '2026-12-19',
          'commitmentEndsOn': '2027-03-19',
          'probationConfirmed': false,
          'phase': phase,
        },
  'kit': [
    {'label': 'حقيبة حرارية', 'size': null, 'quantity': 1},
    {'label': 'سترة', 'size': 'L', 'quantity': 1},
  ],
  'deposit': {
    'amount': moneyJson('50000'),
    'paid': '20000',
    'instalment': moneyJson('10000'),
  },
};

Map<String, Object?> maxPickupJson({String? limit, bool answered = true}) => {
  'limit': limit == null ? null : moneyJson(limit),
  'answered': answered,
  'baseCurrency': 'TRY',
};

/// An open offer of `GET /v1/captain/offers/current`.
Map<String, Object?> offerJson({
  Duration left = const Duration(seconds: 40),
  Map<String, Object?>? handover,
  bool aboveMaxPickup = false,
  Map<String, Object?>? peakBonus,
}) => {
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
  'handover': handover,
  'aboveMaxPickup': aboveMaxPickup,
  'peakBonus': peakBonus,
};

/// Where the first captain of a handover waits, about 110 m from [pin].
const firstCaptain = (latitude: 36.597, longitude: 37.044);

/// The open handover of the active order (CA §9.10.1, slice 2.12b).
Map<String, Object?> handoverJson({
  String role = 'receiving',
  bool assigned = true,
  String name = 'سامر',
  bool located = true,
}) => {
  'role': role,
  'assigned': assigned,
  'captain': {
    'name': name,
    'phone': '+963944333333',
    'location': located
        ? {
            'latitude': firstCaptain.latitude,
            'longitude': firstCaptain.longitude,
            'recordedAt': now.toIso8601String(),
          }
        : null,
  },
};

/// The order this captain handed to another (CA §9.10.1).
Map<String, Object?> handedOverJson() => {
  'orderId': orderId,
  'number': '10423',
  'toCaptainName': 'باسل',
  'at': now.toIso8601String(),
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
  Map<String, Object?>? handover,
  Map<String, Object?>? cannotComplete,
  Map<String, Object?>? emergency,
  Map<String, Object?>? noAnswer,
  List<Map<String, Object?>>? proposedLines,
  List<Map<String, Object?>>? pickupCurrencies,
  Map<String, Object?>? redeliveryOf,
}) {
  final atRestaurant = track != 'assigned';
  final atCustomer = track == 'at_customer';
  return {
    'id': orderId,
    'number': '10423',
    'redeliveryOf': redeliveryOf,
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
      'proposedLines': proposedLines ?? [moneyJson('40000')],
      'currencies': pickupCurrencies ?? [moneyJson('40000')],
      'request': request,
      'pickedUpAt': pickedUp ? now.toIso8601String() : null,
      'disputedAt': disputedAt?.toIso8601String(),
      'reportedAt': null,
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
    'handover': handover,
    'cannotComplete': cannotComplete,
    'emergency': emergency,
    'noAnswer': noAnswer,
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
    'captain_ticket_type': [
      _reason('app_problem', 'مشكلة في التطبيق'),
      _reason('data_change', 'طلب تعديل بيانات'),
      _reason('other', 'أخرى'),
    ],
    'captain_problem': [
      _reason('restaurant_late', 'المطعم متأخر'),
      _reason('pickup_amount', 'مشكلة في مبلغ الاستلام'),
      _reason('other', 'أخرى'),
    ],
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
      'peak': '0',
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
  int accessAsked = 0;

  /// The points recorded while tracked and not sent yet, oldest first, as
  /// the library's database keeps them.
  final kept = <Fix>[];

  @override
  Future<LocationProblem?> ensureAccess() async {
    accessAsked++;
    return problem;
  }

  @override
  Future<Fix?> current() async => fix;

  @override
  Stream<Fix> track() {
    tracking++;
    return _tracked.stream;
  }

  @override
  Future<List<KeptFix>> pending(int limit) async => [
    for (final (index, fix) in kept.take(limit).indexed)
      (id: '$index', fix: fix),
  ];

  @override
  Future<void> sent(List<KeptFix> points) async =>
      kept.removeRange(0, points.length);

  @override
  Future<void> clear() async => kept.clear();

  /// The phone moves to [point]; tracked, the point is kept until sent.
  void move(({double latitude, double longitude}) point) {
    fix = fixAt(point);
    if (_tracked.hasListener) kept.add(fix!);
    _tracked.add(fix!);
  }
}

/// CA §4.5 checks 2 and 8, everything allowed unless a test says otherwise.
class FakePhoneAccess implements PhoneAccessReader {
  PhoneAccess access = const PhoneAccess(
    locationAlways: true,
    locationPrecise: true,
    callAllowed: true,
  );
  int locationSettingsOpened = 0;
  int callRequested = 0;

  @override
  Future<PhoneAccess> read() async => access;

  @override
  Future<void> openLocationSettings() async => locationSettingsOpened++;

  @override
  Future<void> requestCall() async => callRequested++;
}

class FakeRinger implements Ringer {
  bool ringing = false;
  String? ringText;
  int chimes = 0;
  int cancellations = 0;

  @override
  void ring(String text) {
    ringing = true;
    ringText = text;
  }

  @override
  void stop() {
    ringing = false;
    ringText = null;
  }

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
  /// A publication without an order (slice 2.13a), such as
  /// `captain.availability_changed`.
  void signal(String type) =>
      send(captainChannel, RealtimePublication({'type': type}));

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
  // The native layer reads nothing unless a test gives readings (slice
  // 2.43): no device check then.
  final alerts = FakeAlerts();
  final access = FakePhoneAccess();
  final location = FakeLocation(fixAt(restaurant));
  final launched = <Uri>[];
  final push = FakePush();
  // The phone allows notifications unless a test says otherwise.
  final permission = FakeNotificationPermission(allowed: true);
  final caller = FakeCaller();
  // The images shared through the share sheet, by name (CA §10.7).
  final shared = <String, Uint8List>{};
  // Each view the route map drew (slice 2.29b), the latest last.
  final mapViews = <RouteView>[];
  // The photos the picker gives, in order, and where each was asked from;
  // none left reads as cancelled (CA §5.3).
  final picked = <PickedPhoto>[];
  final pickedFrom = <PhotoSource>[];
  // What the blur and darkness check answers (CA §5.3).
  PhotoQuality? photoQuality = PhotoQuality.ok;
  // The storage URLs each photo was put to.
  final puts = <String>[];
  // The device's preferences (the welcome tour's mark, slice 2.35a).
  final deviceStore = MemoryDeviceStore();
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
    Map<String, Object?>? handedOver,
    // K2: whether the captain answered «أقصى مبلغ أحمله», which «متصل» asks
    // until then.
    bool maxPickupAnswered = true,
  }) {
    server.on('/v1/captain/settings/max-pickup-amount', [
      FakeAnswer(200, maxPickupJson(answered: maxPickupAnswered)),
    ]);
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
          'handedOver': handedOver,
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
    // CA §12.2–12.4 (slice 2.35a): no contract (no welcome tour) and no
    // documents unless a test says otherwise.
    if (!server.routes.containsKey('/v1/captain/contract')) {
      server.on('/v1/captain/contract', [FakeAnswer(200, contractJson(null))]);
    }
    if (!server.routes.containsKey('/v1/captain/documents')) {
      server.on('/v1/captain/documents', [
        const FakeAnswer(200, {'documents': <Object?>[]}),
      ]);
    }
    // CA §12.1, §12.5 (slice 2.36c): the data, and no pay table unless a
    // test says otherwise.
    if (!server.routes.containsKey('/v1/captain/profile')) {
      server.on('/v1/captain/profile', [FakeAnswer(200, profileJson())]);
    }
    if (!server.routes.containsKey('/v1/captain/pay-table')) {
      server.on('/v1/captain/pay-table', [FakeAnswer(200, payTableJson())]);
    }
    // CA §11 (slice 2.36b): no warning unless a test says otherwise.
    if (!server.routes.containsKey('/v1/captain/performance')) {
      server.on('/v1/captain/performance', [
        FakeAnswer(200, performanceJson()),
      ]);
    }
    server.on('/v1/captain/content', [FakeAnswer(200, contentJson())]);
    server.on('/v1/captain/push-token', [
      const FakeAnswer(200, {'status': 'registered'}),
    ]);
    if (!server.routes.containsKey('/v1/captain/auth/session')) {
      server.on('/v1/captain/auth/session', [
        const FakeAnswer(200, {
          'accountId': accountId,
          'captainId': captainId,
          'sessionId': '00000000-0000-4000-8000-000000000003',
        }),
      ]);
    }
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
        alertsProvider.overrideWithValue(alerts),
        phoneAccessReaderProvider.overrideWithValue(access),
        keepScreenOnProvider.overrideWithValue((on) {}),
        locationSourceProvider.overrideWithValue(location),
        pushProvider.overrideWithValue(push),
        notificationPermissionProvider.overrideWithValue(permission),
        operationsCallerProvider.overrideWithValue(caller),
        imageSharerProvider.overrideWithValue((png, name) async {
          shared[name] = png;
        }),
        routeMapProvider.overrideWithValue(({required view}) {
          mapViews.add(view);
          return const Text('الخريطة', key: Key('route-map'));
        }),
        serverClockProvider.overrideWithValue(
          ServerClock(deviceNow: () => clockNow),
        ),
        photoPickerProvider.overrideWithValue((source) async {
          pickedFrom.add(source);
          return picked.isEmpty ? null : picked.removeAt(0);
        }),
        deviceStoreProvider.overrideWithValue(deviceStore),
        photoPutProvider.overrideWithValue((url, photo) async {
          puts.add(url);
        }),
        photoCheckerProvider.overrideWithValue((photo) async => photoQuality),
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

/// The call to operations of «طوارئ»: what was asked and called.
class FakeCaller implements OperationsCaller {
  int prepared = 0;
  final calls = <String>[];

  @override
  Future<void> prepare() async => prepared++;

  @override
  Future<void> call(String phone) async => calls.add(phone);
}
