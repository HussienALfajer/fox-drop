import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../content.dart';
import '../work/door_payment.dart';
import 'report_photo.dart';

typedef CaptainTicket = CaptainReportTicketDtoOutputTicket;

/// CA Appendix C: «مشكلة في مبلغ الاستلام», the quick reason that opens the
/// pickup dispute (CA §9.4 item 6) with the lines the captain handed over;
/// its code in Content's captain_problem list (the server checks the same).
const pickupAmountReason = 'pickup_amount';

extension CaptainTicketText on AppLocalizations {
  /// AP Appendix C: the ticket's status.
  String ticketStatusText(CaptainReportTicketDtoOutputTicketStatusEnum s) =>
      switch (s) {
        CaptainReportTicketDtoOutputTicketStatusEnum.new_ => ticketNew,
        CaptainReportTicketDtoOutputTicketStatusEnum.inProgress =>
          ticketInProgress,
        CaptainReportTicketDtoOutputTicketStatusEnum.waiting => ticketWaiting,
        CaptainReportTicketDtoOutputTicketStatusEnum.resolved => ticketResolved,
        _ => ticketClosed,
      };
}

/// CA §13 «بلاغاتي»: read while the support screen shows, and again after a
/// report (`ref.invalidate`) and on the push of a resolution.
final myReportsProvider = FutureProvider.autoDispose<List<CaptainTicket>>(
  (ref) async =>
      (await ref.watch(coreApiProvider).getCaptainApi().captainReportsList())
          .data!
          .tickets
          .toList(),
);

/// What sending a report came to.
sealed class ReportOutcome {
  const ReportOutcome();
}

/// «استلمنا بلاغك T-{رقم}. سنرد عليك خلال {المدة}.»
class ReportSent extends ReportOutcome {
  const ReportSent(this.ticket);

  final CaptainTicket ticket;
}

/// Content changed the types meanwhile: they are read again.
class ReportTypeChanged extends ReportOutcome {
  const ReportTypeChanged();
}

/// The photo could not be uploaded, or the server refused it.
class ReportPhotoFailed extends ReportOutcome {
  const ReportPhotoFailed();
}

/// The order is not the captain's (any more).
class ReportOrderGone extends ReportOutcome {
  const ReportOrderGone();
}

/// The order no longer takes this report: not active, or for the pickup
/// amount, before the pickup or not the captain who paid.
class ReportClosed extends ReportOutcome {
  const ReportClosed();
}

/// «مشكلة في مبلغ الاستلام»: the restaurant or the captain disputed the
/// pickup already.
class PickupAlreadyDisputed extends ReportOutcome {
  const PickupAlreadyDisputed();
}

/// «مشكلة في مبلغ الاستلام»: the lines are the ones recorded at the pickup.
class PickupAmountSame extends ReportOutcome {
  const PickupAmountSame();
}

/// No answer or another refusal: the same report may be sent again.
class ReportFailed extends ReportOutcome {
  const ReportFailed();
}

/// The captain's reports (CA §13, §9.11, §9.4 item 6): `POST
/// /v1/captain/reports` and `POST /v1/captain/orders/{orderId}/problem`,
/// each with a key per body, kept until the server answers, so sending the
/// same report again after a lost answer replays it.
class CaptainReports {
  CaptainReports(this._ref);

  final Ref _ref;
  final Map<String, String> _keys = {};

  String _keyOf(String body) => _keys[body] ??= uuidV4();

  /// «إبلاغ عن مشكلة»: a type, optionally the order, a note and a photo.
  Future<ReportOutcome> report({
    required String typeCode,
    required String? orderId,
    required String? note,
    required ReportPhoto? photo,
  }) async {
    final String? uploadId;
    try {
      uploadId = photo == null ? null : await uploadPhoto(_ref, photo);
    } on DioException {
      return const ReportPhotoFailed();
    }
    final body = [
      'report',
      typeCode,
      orderId ?? '',
      note ?? '',
      uploadId ?? '',
    ].join('\n');
    return _send(body, photo, (key) async {
      final answer = await _api.captainTicketsReport(
        idempotencyKey: key,
        captainReportBodyDto: CaptainReportBodyDto(
          (b) => b
            ..typeCode = typeCode
            ..orderId = orderId
            ..note = note
            ..photoUploadId = uploadId,
        ),
      );
      return answer.data!.ticket;
    });
  }

  /// «مشكلة» with a quick reason (CA §9.11) on the active order; for
  /// «مشكلة في مبلغ الاستلام» the lines the captain handed over.
  Future<ReportOutcome> problem({
    required String orderId,
    required String reasonCode,
    String? note,
    List<Money>? paidLines,
  }) => _send(
    [
      'problem',
      orderId,
      reasonCode,
      note ?? '',
      for (final line in paidLines ?? const <Money>[]) '$line',
    ].join('\n'),
    null,
    (key) async {
      final answer = await _api.captainTicketsProblem(
        orderId: orderId,
        idempotencyKey: key,
        captainProblemBodyDto: CaptainProblemBodyDto((b) {
          b
            ..reasonCode = reasonCode
            ..note = note;
          if (paidLines != null) {
            b.paidLines.replace([
              for (final line in paidLines)
                MerchantPickupDisputeDtoReceivedLinesInner(
                  (l) => l
                    ..amount = line.amount
                    ..currency = line.currency,
                ),
            ]);
          } else {
            b.paidLines = null;
          }
        }),
      );
      return answer.data!.ticket;
    },
  );

  CaptainApi get _api => _ref.read(coreApiProvider).getCaptainApi();

  Future<ReportOutcome> _send(
    String body,
    ReportPhoto? photo,
    Future<CaptainTicket> Function(String key) call,
  ) async {
    try {
      final ticket = await call(_keyOf(body));
      _keys.remove(body);
      _ref.invalidate(myReportsProvider);
      return ReportSent(ticket);
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      if (status == null || status >= 500 || status == 408 || status == 429) {
        return const ReportFailed();
      }
      _keys.remove(body);
      switch (AuthRefusal.of(error).error) {
        case 'unknown_reason' || 'reason_note_required':
          _ref.invalidate(contentProvider);
          return const ReportTypeChanged();
        case 'unknown_order':
          return const ReportOrderGone();
        case 'order_state_changed':
          return const ReportClosed();
        case 'pickup_already_disputed':
          return const PickupAlreadyDisputed();
        case 'no_difference':
          return const PickupAmountSame();
        case 'upload_not_found' ||
            'upload_expired' ||
            'upload_missing' ||
            'upload_invalid' ||
            'upload_used':
          // The next send uploads the photo again.
          photo?.uploadId = null;
          return const ReportPhotoFailed();
        default:
          return const ReportFailed();
      }
    }
  }
}

final captainReportsProvider = Provider<CaptainReports>(CaptainReports.new);
