import 'dart:async';

import 'package:core_api/core_api.dart';
import 'package:core_realtime/core_realtime.dart';
import 'package:merchant/src/board/alerts.dart';
import 'package:merchant/src/board/board.dart';

final placedAt = DateTime.utc(2026, 11, 7, 12);

const shawarmaId = '00000000-0000-4000-8000-0000000000c1';
const falafelId = '00000000-0000-4000-8000-0000000000c2';

/// One order of `GET /v1/merchant/orders` as JSON.
Map<String, Object?> orderJson({
  String id = '00000000-0000-4000-8000-0000000000a1',
  String number = '10001',
  String status = 'placed',
  int version = 1,
  DateTime? placed,
  Duration? acceptedAfter,
  int prepMin = 20,
  bool byOperations = false,
  String? captainTrack,
  String? captainName,
  DateTime? arrivedAt,
  Map<String, Object?>? request,
  DateTime? pickedUpAt,
  DateTime? disputeUntil,
  Map<String, Object?>? cancellation,
  Map<String, Object?>? itemReport,
}) {
  final at = placed ?? placedAt;
  final accepted = acceptedAfter == null ? null : at.add(acceptedAfter);
  return {
    'id': id,
    'number': number,
    'status': status,
    'version': version,
    'placedAt': at.toIso8601String(),
    'acceptAlertAt': at.add(const Duration(minutes: 3)).toIso8601String(),
    'autoCancelAt': status == 'placed'
        ? at.add(const Duration(minutes: 7)).toIso8601String()
        : null,
    'acceptance': accepted == null
        ? null
        : {
            'at': accepted.toIso8601String(),
            'prepMin': prepMin,
            'prepDueAt': accepted
                .add(Duration(minutes: prepMin))
                .toIso8601String(),
            'deviceName': byOperations ? null : 'كاشير 1',
            'byOperations': byOperations,
          },
    'readyAt': null,
    'customer': {'firstName': 'أحمد', 'neighbourhood': 'المركز'},
    'note': 'بدون بصل',
    'lines': [
      {
        'itemId': shawarmaId,
        'name': 'شاورما',
        'quantity': 2,
        'options': [
          {'name': 'كبير'},
        ],
        'note': null,
        'lineTotal': '24000',
      },
      {
        'itemId': falafelId,
        'name': 'فلافل',
        'quantity': 1,
        'options': <Object?>[],
        'note': null,
        'lineTotal': '0',
      },
    ],
    'currency': 'TRY',
    'itemsValue': '24000',
    'captainTrack': captainTrack,
    'captain': captainName == null
        ? null
        : {'firstName': captainName, 'vehicle': 'motorbike'},
    'captainArrival': arrivedAt == null
        ? null
        : {
            'at': arrivedAt.toIso8601String(),
            'waitingAlertAt': arrivedAt
                .add(const Duration(minutes: 10))
                .toIso8601String(),
          },
    'pickup': {
      'request': request,
      'pickedUpAt': pickedUpAt?.toIso8601String(),
      'readyNotPressed': false,
      'disputeUntil': disputeUntil?.toIso8601String(),
      'disputedAt': null,
    },
    'cancellation': cancellation,
    'itemReport': itemReport,
  };
}

/// An open item-unavailable report as the board gives it (RA §8.12).
Map<String, Object?> itemReportJson({
  Map<String, Object?>? note = const {
    'code': 'similar_alternative',
    'label': 'يوجد بديل مشابه',
  },
}) => {
  'at': placedAt.add(const Duration(minutes: 10)).toIso8601String(),
  'items': [
    {'itemId': falafelId, 'name': 'فلافل', 'until': 'tomorrow'},
  ],
  'note': note,
};

/// An order's `cancellation` as the board gives it: only operations'
/// cancellation after acceptance, until «حسناً» (RA §8.14).
Map<String, Object?> cancellationJson({DateTime? at}) => {
  'at': (at ?? placedAt.add(const Duration(minutes: 30))).toIso8601String(),
  'reason': 'customer_unreachable',
  'label': 'تعذر الوصول إلى الزبون',
  'byOperations': true,
};

Map<String, Object?> requestJson({
  String id = '00000000-0000-4000-8000-0000000000b1',
  String status = 'open',
  String? outcome,
  String? closedBy,
  DateTime? confirmBy,
}) => {
  'id': id,
  'status': status,
  'outcome': outcome,
  'amount': {'amount': '24000', 'currency': 'TRY'},
  'lines': [
    {'amount': '24000', 'currency': 'TRY'},
  ],
  'baseEquivalent': '24000',
  'confirmBy': (confirmBy ?? placedAt.add(const Duration(minutes: 30)))
      .toIso8601String(),
  'closedAt': status == 'open' ? null : placedAt.toIso8601String(),
  'closedByUserName': closedBy,
  'closedByDeviceName': null,
};

Map<String, Object?> boardJson(List<Map<String, Object?>> orders) => {
  'orders': orders,
  'prepTime': {
    'options': [10, 15, 20, 30, 45],
    'stepMin': 5,
    'floorMin': 5,
    'ceilingMin': 90,
    'defaultMin': 20,
  },
};

Board board(List<Map<String, Object?>> orders) => standardSerializers
    .deserializeWith(MerchantOrdersDtoOutput.serializer, boardJson(orders))!;

class FakeRinger implements Ringer {
  bool ringing = false;
  int chimes = 0;

  @override
  void ring() => ringing = true;

  @override
  void stop() => ringing = false;

  @override
  void chime() => chimes++;
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
}
