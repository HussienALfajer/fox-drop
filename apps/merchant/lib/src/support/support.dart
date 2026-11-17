import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../content.dart';
import 'report_photo.dart';

typedef MerchantTicket = MerchantReportTicketDtoOutputTicket;

/// RA Appendix C: «طلب تعديل بيانات», the type that names its subject (its
/// code in Content's merchant_ticket_type list; the server checks the same).
const dataChangeType = 'data_change';

/// RA §15 (owner decision 2026-11-17): what a data change may ask.
enum DataChangeSubject { minOrder, coverage, owners, ownerPhone }

extension DataChangeSubjectText on AppLocalizations {
  String subjectText(DataChangeSubject subject) => switch (subject) {
    DataChangeSubject.minOrder => merchantSubjectMinOrder,
    DataChangeSubject.coverage => merchantSubjectCoverage,
    DataChangeSubject.owners => merchantSubjectOwners,
    DataChangeSubject.ownerPhone => merchantSubjectOwnerPhone,
  };

  /// A ticket's subject as the server names it.
  String? ticketSubjectText(
    MerchantReportTicketDtoOutputTicketSubjectEnum? s,
  ) => switch (s) {
    MerchantReportTicketDtoOutputTicketSubjectEnum.minOrder =>
      merchantSubjectMinOrder,
    MerchantReportTicketDtoOutputTicketSubjectEnum.coverage =>
      merchantSubjectCoverage,
    MerchantReportTicketDtoOutputTicketSubjectEnum.owners =>
      merchantSubjectOwners,
    MerchantReportTicketDtoOutputTicketSubjectEnum.ownerPhone =>
      merchantSubjectOwnerPhone,
    _ => null,
  };

  /// AP Appendix C: the ticket's status.
  String ticketStatusText(MerchantReportTicketDtoOutputTicketStatusEnum s) =>
      switch (s) {
        MerchantReportTicketDtoOutputTicketStatusEnum.new_ => ticketNew,
        MerchantReportTicketDtoOutputTicketStatusEnum.inProgress =>
          ticketInProgress,
        MerchantReportTicketDtoOutputTicketStatusEnum.waiting => ticketWaiting,
        MerchantReportTicketDtoOutputTicketStatusEnum.resolved =>
          ticketResolved,
        _ => ticketClosed,
      };
}

const _subjects = {
  DataChangeSubject.minOrder: MerchantReportBodyDtoSubjectEnum.minOrder,
  DataChangeSubject.coverage: MerchantReportBodyDtoSubjectEnum.coverage,
  DataChangeSubject.owners: MerchantReportBodyDtoSubjectEnum.owners,
  DataChangeSubject.ownerPhone: MerchantReportBodyDtoSubjectEnum.ownerPhone,
};

/// A reason of Content's lists: its code and label.
typedef Reason = ({String code, String label});

/// RA §15, Appendix C: the active report types, in Content's order.
final ticketTypesProvider = FutureProvider<List<Reason>>((ref) async {
  final content = await ref.watch(merchantContentProvider.future);
  return [
    for (final r in content.reasons.merchantTicketType)
      (code: r.code, label: r.label),
  ];
});

/// RA §8.19, Appendix C: «مشكلة في الطلب»'s quick reasons.
final orderProblemsProvider = FutureProvider<List<Reason>>((ref) async {
  final content = await ref.watch(merchantContentProvider.future);
  return [
    for (final r in content.reasons.merchantProblem)
      (code: r.code, label: r.label),
  ];
});

/// RA §15 «الأسئلة الشائعة»: the restaurant's FAQ from Content.
final merchantFaqProvider =
    FutureProvider<List<({String question, String answer})>>((ref) async {
      final content = await ref.watch(merchantContentProvider.future);
      return [
        for (final f in content.faq) (question: f.question, answer: f.answer),
      ];
    });

/// RA §15 «بلاغاتي»: read while the support screen shows, and again after
/// a report (`ref.invalidate`).
final myReportsProvider = FutureProvider.autoDispose<List<MerchantTicket>>(
  (ref) async =>
      (await ref.watch(coreApiProvider).getMerchantApi().merchantReportsList())
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

  final MerchantTicket ticket;
}

/// Content changed the types meanwhile: they are read again.
class ReportTypeChanged extends ReportOutcome {
  const ReportTypeChanged();
}

/// The photo could not be uploaded, or the server refused it.
class ReportPhotoFailed extends ReportOutcome {
  const ReportPhotoFailed();
}

/// The order is not the restaurant's (any more).
class ReportOrderGone extends ReportOutcome {
  const ReportOrderGone();
}

/// No answer or another refusal: the same report may be sent again.
class ReportFailed extends ReportOutcome {
  const ReportFailed();
}

/// The restaurant's reports (RA §15, §8.19): `POST /v1/merchant/reports`
/// and `POST /v1/merchant/orders/{orderId}/problem`, each with a key per
/// body, kept until the server answers, so sending the same report again
/// after a lost answer replays it.
class MerchantReports {
  MerchantReports(this._ref);

  final Ref _ref;
  final Map<String, String> _keys = {};

  String _keyOf(String body) => _keys[body] ??= uuidV4();

  /// «إبلاغ عن مشكلة»: a type, optionally an order, a data change's subject,
  /// a note and a photo.
  Future<ReportOutcome> report({
    required String typeCode,
    required String? orderId,
    required DataChangeSubject? subject,
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
      subject?.name ?? '',
      note ?? '',
      uploadId ?? '',
    ].join('\n');
    return _send(body, photo, (key) async {
      final answer = await _api.merchantTicketsReport(
        idempotencyKey: key,
        merchantReportBodyDto: MerchantReportBodyDto(
          (b) => b
            ..typeCode = typeCode
            ..orderId = orderId
            ..subject = subject == null ? null : _subjects[subject]
            ..note = note
            ..photoUploadId = uploadId,
        ),
      );
      return answer.data!.ticket;
    });
  }

  /// «مشكلة في الطلب» (RA §8.19): a quick reason on the order.
  Future<ReportOutcome> orderProblem({
    required String orderId,
    required String reasonCode,
  }) => _send(['problem', orderId, reasonCode].join('\n'), null, (key) async {
    final answer = await _api.merchantTicketsProblem(
      orderId: orderId,
      idempotencyKey: key,
      merchantOrderProblemBodyDto: MerchantOrderProblemBodyDto(
        (b) => b
          ..reasonCode = reasonCode
          ..note = null,
      ),
    );
    return answer.data!.ticket;
  });

  MerchantApi get _api => _ref.read(coreApiProvider).getMerchantApi();

  Future<ReportOutcome> _send(
    String body,
    ReportPhoto? photo,
    Future<MerchantTicket> Function(String key) call,
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
        case 'unknown_reason' ||
            'reason_note_required' ||
            'subject_required' ||
            'invalid_subject':
          _ref.invalidate(merchantContentProvider);
          return const ReportTypeChanged();
        case 'unknown_order':
          return const ReportOrderGone();
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

final merchantReportsProvider = Provider<MerchantReports>(MerchantReports.new);
