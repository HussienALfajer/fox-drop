import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../content.dart';
import '../reports/report_photos.dart';
import 'order_live.dart';

/// CU §12.2: the types whose report names the order's lines: «صنف ناقص»,
/// «صنف خطأ» and «الطلب تالف» (their codes in Content's customer_problem
/// list; the server checks the same).
const itemReportTypes = {'missing_item', 'wrong_item', 'damaged_order'};

/// CU §12.2: up to 3 photos (fixed).
const maxReportPhotos = 3;

/// What the order screen offers about reporting (CU §12.2): the report's
/// status once sent, «الإبلاغ عن مشكلة» within its window, else «تواصل مع
/// الدعم» once the order ended; nothing while it is active.
enum ReportOffer { status, report, contactSupport, none }

ReportOffer reportOfferOf(CustomerOrder order, DateTime now) {
  if (order.report != null) return ReportOffer.status;
  final until = order.reportUntil;
  if (until != null && now.isBefore(until)) return ReportOffer.report;
  return endedStatuses.contains(order.status.name)
      ? ReportOffer.contactSupport
      : ReportOffer.none;
}

/// What «إرسال البلاغ» came to.
sealed class ReportOutcome {
  const ReportOutcome();
}

/// «استلمنا بلاغك T-{رقم}. سنرد عليك خلال {المدة}.», the ticket's timer
/// (owner decision 2026-11-17: support.resolution_post_delivery_hours).
class ReportSent extends ReportOutcome {
  const ReportSent(this.number, this.replyWithinMinutes);

  final String number;
  final int replyWithinMinutes;
}

/// The window closed meanwhile, or a report was already sent (Q17): the
/// order screen shows which.
class ReportRefused extends ReportOutcome {
  const ReportRefused({required this.already});

  final bool already;
}

/// The panel changed the types: they are read again and the customer
/// chooses again.
class ReportTypeChanged extends ReportOutcome {
  const ReportTypeChanged();
}

/// A photo could not be uploaded or the server refused it.
class ReportPhotoFailed extends ReportOutcome {
  const ReportPhotoFailed();
}

/// No answer or another refusal: the customer may try again.
class ReportFailed extends ReportOutcome {
  const ReportFailed();
}

/// The customer's report on one order (CU §12.2): its photos uploaded once,
/// then `POST /v1/customer/orders/{orderId}/report` with a key per command
/// body (the same body sent again after a lost answer reuses it). The
/// order's screen then reads the order again.
class ReportProblem {
  ReportProblem(this._ref, this.orderId);

  final Ref _ref;
  final String orderId;
  String? _key;
  String? _keyFor;
  List<ReportPhoto> _photos = const [];

  Future<ReportOutcome> send({
    required String typeCode,
    required String? note,
    required Map<int, int> items,
    required List<ReportPhoto> photos,
  }) async {
    final alive = _ref.keepAlive();
    try {
      final List<String> uploadIds;
      try {
        uploadIds = await uploadPhotos(_ref, photos);
      } on DioException {
        return const ReportPhotoFailed();
      }
      final chosen = items.entries.where((e) => e.value > 0).toList()
        ..sort((a, b) => a.key.compareTo(b.key));
      final fingerprint = [
        typeCode,
        note ?? '',
        for (final e in chosen) '${e.key}:${e.value}',
        ...uploadIds,
      ].join('\n');
      if (_keyFor != fingerprint) {
        _key = uuidV4();
        _keyFor = fingerprint;
      }
      _photos = photos;
      return await _send(typeCode, note, chosen, uploadIds);
    } finally {
      alive.close();
    }
  }

  Future<ReportOutcome> _send(
    String typeCode,
    String? note,
    List<MapEntry<int, int>> items,
    List<String> uploadIds,
  ) async {
    final api = _ref.read(coreApiProvider).getCustomerApi();
    try {
      final answer = await api.customerOrdersReport(
        orderId: orderId,
        idempotencyKey: _key!,
        customerReportOrderDto: CustomerReportOrderDto(
          (b) => b
            ..typeCode = typeCode
            ..note = note
            ..items.addAll([
              for (final e in items)
                CustomerReportOrderDtoItemsInner(
                  (i) => i
                    ..position = e.key
                    ..quantity = e.value,
                ),
            ])
            ..photoUploadIds.addAll(uploadIds),
        ),
      );
      _forget();
      _refresh();
      final report = answer.data!.order.report!;
      return ReportSent(report.number, report.replyWithinMinutes);
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      if (status == null || status >= 500) return const ReportFailed();
      _forget();
      switch (AuthRefusal.of(error).error) {
        case 'report_closed':
          _refresh();
          return const ReportRefused(already: false);
        case 'already_reported':
          _refresh();
          return const ReportRefused(already: true);
        case 'unknown_reason' ||
            'reason_note_required' ||
            'reason_note_not_allowed':
          _ref.invalidate(contentProvider);
          return const ReportTypeChanged();
        case 'upload_not_found' ||
            'upload_expired' ||
            'upload_missing' ||
            'upload_invalid' ||
            'upload_used':
          // The next send uploads the photos again.
          forgetUploads(_photos);
          return const ReportPhotoFailed();
        default:
          return const ReportFailed();
      }
    }
  }

  void _forget() {
    _key = null;
    _keyFor = null;
  }

  void _refresh() => _ref.read(orderFeedProvider(orderId)).refresh();
}

final reportProblemProvider = Provider.autoDispose
    .family<ReportProblem, String>(ReportProblem.new);
