import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../content.dart';
import 'order_live.dart';

/// What «نعم، ألغِ الطلب» came to (CU §11.4).
enum CancelOutcome {
  /// The order is cancelled: «ألغيت طلبك».
  cancelled,

  /// The restaurant accepted first: «قبل المطعم طلبك قبل لحظات. لإلغائه
  /// تواصل مع الدعم.»
  tooLate,

  /// The order ended otherwise first (rejected, or cancelled for no
  /// answer); its screen shows why.
  ended,

  /// The panel changed the reasons: the list is read again and the customer
  /// chooses again.
  reasonChanged,

  /// No answer or another refusal: the customer may try again.
  failed,
}

/// The customer's cancellation of one order while placed (CU §11.4). Its
/// idempotency key belongs to one command body: the same body sent again
/// after a lost answer reuses it, a refusal or another body takes a new
/// one. The order's screen then reads the order again; the answer is never
/// patched in.
class CancelOrder {
  CancelOrder(this._ref, this.orderId);

  final Ref _ref;
  final String orderId;
  String? _key;
  String? _keyFor;

  Future<CancelOutcome> send(String reason, String? note) async {
    final fingerprint = '$reason\n${note ?? ''}';
    if (_keyFor != fingerprint) {
      _key = uuidV4();
      _keyFor = fingerprint;
    }
    // The sheet may be dismissed while the command runs: the command lives
    // until its answer, so its key and the order's refresh are not lost.
    final alive = _ref.keepAlive();
    try {
      return await _send(reason, note);
    } finally {
      alive.close();
    }
  }

  Future<CancelOutcome> _send(String reason, String? note) async {
    final api = _ref.read(coreApiProvider).getCustomerApi();
    try {
      await api.customerOrdersCancel(
        orderId: orderId,
        idempotencyKey: _key!,
        customerCancelOrderDto: CustomerCancelOrderDto(
          (b) => b
            ..reason = reason
            ..note = note,
        ),
      );
      _forget();
      _refresh();
      return CancelOutcome.cancelled;
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      final refusal = AuthRefusal.of(error).error;
      if (status == null || status >= 500) return CancelOutcome.failed;
      _forget();
      switch (refusal) {
        case 'order_state_changed':
          _refresh();
          return endedStatuses.contains(_statusIn(error.response?.data))
              ? CancelOutcome.ended
              : CancelOutcome.tooLate;
        case 'unknown_reason' ||
            'reason_note_required' ||
            'reason_note_not_allowed':
          _ref.invalidate(contentProvider);
          return CancelOutcome.reasonChanged;
        default:
          return CancelOutcome.failed;
      }
    }
  }

  /// The order's status in a 409 `order_state_changed` body.
  static Object? _statusIn(Object? body) {
    if (body is! Map) return null;
    final order = body['order'];
    return order is Map ? order['status'] : null;
  }

  void _forget() {
    _key = null;
    _keyFor = null;
  }

  void _refresh() => _ref.read(orderFeedProvider(orderId)).refresh();
}

final cancelOrderProvider = Provider.autoDispose.family<CancelOrder, String>(
  CancelOrder.new,
);

/// CU §11.4–11.5: what «مساعدة» offers about cancelling at a status: the
/// cancellation itself while placed, the explanation and its warning until
/// the pickup, nothing after it (Q24).
enum CancelHelp { cancel, viaSupport, none }

CancelHelp cancelHelpAt(String status) => switch (status) {
  'placed' => CancelHelp.cancel,
  'accepted' || 'ready' => CancelHelp.viaSupport,
  _ => CancelHelp.none,
};
