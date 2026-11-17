import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../reports/report_photos.dart';

/// What «أبلغ عن سعر مختلف» came to (CU §9.5).
enum PriceReportOutcome {
  /// «شكراً، سنتحقق من السعر».
  sent,

  /// «أرسلت بلاغاً عن هذا المطعم اليوم»: one a restaurant per business day.
  today,

  /// The photo could not be uploaded or the server refused it.
  photoFailed,

  /// No answer or another refusal: the customer may try again.
  failed,
}

/// The customer's price report on one restaurant (CU §9.5, AP §9.9.1): the
/// photo uploaded once, then `POST /v1/customer/restaurants/{id}/price-
/// report` with a key per command body.
class PriceReport {
  PriceReport(this._ref, this.restaurantId);

  final Ref _ref;
  final String restaurantId;
  String? _key;
  String? _keyFor;

  Future<PriceReportOutcome> send({
    required String? itemId,
    required String? shopPrice,
    required String? note,
    required ReportPhoto? photo,
  }) async {
    final alive = _ref.keepAlive();
    try {
      final String? uploadId;
      try {
        uploadId = photo == null
            ? null
            : (await uploadPhotos(_ref, [photo])).single;
      } on DioException {
        return PriceReportOutcome.photoFailed;
      }
      final fingerprint = [itemId, shopPrice, note, uploadId].join('\n');
      if (_keyFor != fingerprint) {
        _key = uuidV4();
        _keyFor = fingerprint;
      }
      try {
        await _ref
            .read(coreApiProvider)
            .getCustomerApi()
            .customerPriceReportsReport(
              restaurantId: restaurantId,
              idempotencyKey: _key!,
              customerPriceReportBodyDto: CustomerPriceReportBodyDto(
                (b) => b
                  ..itemId = itemId
                  ..shopPrice = shopPrice
                  ..note = note
                  ..photoUploadId = uploadId,
              ),
            );
        _forget();
        return PriceReportOutcome.sent;
      } on DioException catch (error) {
        final status = error.response?.statusCode;
        if (status == null || status >= 500) return PriceReportOutcome.failed;
        _forget();
        return switch (AuthRefusal.of(error).error) {
          'already_reported_today' => PriceReportOutcome.today,
          'upload_not_found' ||
          'upload_expired' ||
          'upload_missing' ||
          'upload_invalid' ||
          'upload_used' => PriceReportOutcome.photoFailed,
          _ => PriceReportOutcome.failed,
        };
      }
    } finally {
      alive.close();
    }
  }

  void _forget() {
    _key = null;
    _keyFor = null;
  }
}

final priceReportProvider = Provider.autoDispose.family<PriceReport, String>(
  PriceReport.new,
);
