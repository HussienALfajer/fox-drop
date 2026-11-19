import 'package:core_api/core_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../support/report_photo.dart';
import 'photo_check.dart';

/// The joining's logic (CA §5.1–5.4; slice 2.34a): the application as the
/// server answers it, the form's steps and their refusals. The screens only
/// show it and call it (the design stop).

enum ApplicationStage {
  draft,
  newApplication,
  underReview,
  interview,
  awaitingKit,
  active,
  waitlist,
  rejected,
}

enum Vehicle { motorbike, car, bicycle, walking }

bool isMotor(Vehicle vehicle) =>
    vehicle == Vehicle.motorbike || vehicle == Vehicle.car;

/// The documents of CA §5.3, in the form's order, by their wire names.
enum DocumentKind {
  nationalId('national_id'),
  personalPhoto('personal_photo'),
  civilRegistry('civil_registry'),
  criminalRecord('criminal_record'),
  vehiclePapers('vehicle_papers'),
  drivingLicence('driving_licence');

  const DocumentKind(this.wire);

  final String wire;

  /// The ID's front and back; one or two pages of the others.
  int get minFiles => this == nationalId ? 2 : 1;
  int get maxFiles => 2;

  /// Where the photo comes from (CA §5.3): the camera, the front camera for
  /// the personal photo, or also a file for the civil registry and the
  /// criminal record.
  bool get fromFile => this == civilRegistry || this == criminalRecord;
  bool get frontCamera => this == personalPhoto;
}

/// The documents the form shows for a vehicle: the vehicle papers only for a
/// motor vehicle, the driving licence always (optional).
List<DocumentKind> formDocuments(Vehicle? vehicle) => [
  for (final kind in DocumentKind.values)
    if (kind != DocumentKind.vehiclePapers ||
        (vehicle != null && isMotor(vehicle)))
      kind,
];

bool isRequired(DocumentKind kind) => kind != DocumentKind.drivingLicence;

enum DocumentStatus { pending, accepted, rejected }

class ApplicationDocument {
  const ApplicationDocument({
    required this.kind,
    required this.status,
    this.reason,
    this.number,
    this.issueDate,
    this.expiresOn,
  });

  final DocumentKind kind;
  final DocumentStatus status;
  final String? reason;
  final String? number;
  final String? issueDate;
  final String? expiresOn;
}

/// What «إرسال الطلب» still waits for (the server's `missing`).
sealed class Missing {
  const Missing();
}

class MissingVehicle extends Missing {
  const MissingVehicle();
}

class MissingDocument extends Missing {
  const MissingDocument(this.kind);
  final DocumentKind kind;
}

class MissingTerms extends Missing {
  const MissingTerms();
}

/// An open «طلب مستند» from the panel (AP §9.7.1).
class DocumentRequest {
  const DocumentRequest({
    required this.kind,
    required this.reason,
    required this.requestedAt,
  });

  final DocumentKind kind;
  final String reason;
  final DateTime requestedAt;
}

/// «تحديد مقابلة»: the appointment and the office's point.
class Interview {
  const Interview({
    required this.at,
    required this.place,
    required this.latitude,
    required this.longitude,
  });

  final DateTime at;
  final String place;
  final num latitude;
  final num longitude;
}

/// The rejection's reason and the moment re-applying opens (K11, 30 days).
class Rejection {
  const Rejection({
    required this.reason,
    required this.at,
    required this.reapplyFrom,
  });

  final String reason;
  final DateTime at;
  final DateTime reapplyFrom;
}

/// One stage the application entered, and when.
class StageChange {
  const StageChange(this.stage, this.at);

  final ApplicationStage stage;
  final DateTime at;
}

class Application {
  const Application({
    required this.stage,
    required this.fullName,
    required this.birthDate,
    required this.zoneId,
    required this.vehicle,
    required this.plate,
    required this.documents,
    required this.missing,
    this.requests = const [],
    this.interview,
    this.rejection,
    this.history = const [],
  });

  final ApplicationStage stage;
  final String fullName;
  final String birthDate;
  final String zoneId;
  final Vehicle? vehicle;
  final String? plate;
  final List<ApplicationDocument> documents;
  final List<Missing> missing;
  final List<DocumentRequest> requests;
  final Interview? interview;
  final Rejection? rejection;

  /// The stages entered, oldest first.
  final List<StageChange> history;

  ApplicationDocument? document(DocumentKind kind) {
    for (final each in documents) {
      if (each.kind == kind) return each;
    }
    return null;
  }

  DocumentRequest? request(DocumentKind kind) {
    for (final each in requests) {
      if (each.kind == kind) return each;
    }
    return null;
  }

  bool get termsAccepted => !missing.any((each) => each is MissingTerms);
}

/// The form's five steps (CA §5.2), numbered from 0.
const personalStep = 0;
const vehicleStep = 1;
const documentsStep = 2;
const termsStep = 3;
const reviewStep = 4;

/// The step a draft opens at: the first one with something missing, or the
/// review when nothing is.
int firstOpenStep(Application? application) {
  if (application == null) return personalStep;
  final missing = application.missing;
  if (missing.any((each) => each is MissingVehicle)) return vehicleStep;
  if (missing.any((each) => each is MissingDocument)) return documentsStep;
  if (missing.any((each) => each is MissingTerms)) return termsStep;
  return reviewStep;
}

/// The stages after «إرسال الطلب» in which the server takes a document
/// again (a requested or a rejected one only).
const _uploadAgainStages = {
  ApplicationStage.newApplication,
  ApplicationStage.underReview,
  ApplicationStage.interview,
  ApplicationStage.awaitingKit,
  ApplicationStage.waitlist,
};

/// Whether the status page offers to upload [kind] again (CA §5.3–5.4): a
/// document the panel requested, or one whose copy in force was rejected,
/// while the application is still open.
bool canUploadAgain(Application application, DocumentKind kind) =>
    _uploadAgainStages.contains(application.stage) &&
    (application.request(kind) != null ||
        application.document(kind)?.status == DocumentStatus.rejected);

/// The documents the status page lists: those uploaded and those requested,
/// in the form's order.
List<DocumentKind> statusDocuments(Application application) => [
  for (final kind in DocumentKind.values)
    if (application.document(kind) != null || application.request(kind) != null)
      kind,
];

/// Whether «تقديم طلب جديد» shows (K11): rejected, and [now] (the server's
/// clock) at or past the rejection's `reapplyFrom`.
bool canReapply(Application application, DateTime now) {
  final rejection = application.rejection;
  return application.stage == ApplicationStage.rejected &&
      rejection != null &&
      !now.isBefore(rejection.reapplyFrom);
}

Application? applicationOf(CaptainApplicationDtoOutput answer) {
  final found = answer.application;
  if (found == null) return null;
  return Application(
    stage: _stages[found.stage]!,
    fullName: found.fullName,
    birthDate: found.birthDate.toString(),
    zoneId: found.zoneId,
    vehicle: found.vehicle == null ? null : _vehicles[found.vehicle],
    plate: found.plate,
    documents: [
      for (final document in found.documents)
        ApplicationDocument(
          kind: _kinds[document.kind]!,
          status: _statuses[document.status]!,
          reason: document.reason,
          number: document.number,
          issueDate: document.issueDate?.toString(),
          expiresOn: document.expiresOn?.toString(),
        ),
    ],
    missing: [for (final each in found.missing) _missing[each]!],
    requests: [
      for (final request in found.requests)
        DocumentRequest(
          kind: _requestKinds[request.kind]!,
          reason: request.reason,
          requestedAt: request.requestedAt,
        ),
    ],
    interview: switch (found.interview) {
      final interview? => Interview(
        at: interview.at,
        place: interview.place,
        latitude: interview.latitude,
        longitude: interview.longitude,
      ),
      null => null,
    },
    rejection: switch (found.rejection) {
      final rejection? => Rejection(
        reason: rejection.reason,
        at: rejection.at,
        reapplyFrom: rejection.reapplyFrom,
      ),
      null => null,
    },
    history: [
      for (final change in found.history)
        StageChange(_historyStages[change.stage]!, change.at),
    ],
  );
}

final _stages = {
  CaptainApplicationDtoOutputApplicationStageEnum.draft: ApplicationStage.draft,
  CaptainApplicationDtoOutputApplicationStageEnum.new_:
      ApplicationStage.newApplication,
  CaptainApplicationDtoOutputApplicationStageEnum.underReview:
      ApplicationStage.underReview,
  CaptainApplicationDtoOutputApplicationStageEnum.interview:
      ApplicationStage.interview,
  CaptainApplicationDtoOutputApplicationStageEnum.awaitingKit:
      ApplicationStage.awaitingKit,
  CaptainApplicationDtoOutputApplicationStageEnum.active:
      ApplicationStage.active,
  CaptainApplicationDtoOutputApplicationStageEnum.waitlist:
      ApplicationStage.waitlist,
  CaptainApplicationDtoOutputApplicationStageEnum.rejected:
      ApplicationStage.rejected,
};

final _historyStages = {
  CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum.draft:
      ApplicationStage.draft,
  CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum.new_:
      ApplicationStage.newApplication,
  CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum.underReview:
      ApplicationStage.underReview,
  CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum.interview:
      ApplicationStage.interview,
  CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum.awaitingKit:
      ApplicationStage.awaitingKit,
  CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum.active:
      ApplicationStage.active,
  CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum.waitlist:
      ApplicationStage.waitlist,
  CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum.rejected:
      ApplicationStage.rejected,
};

final _vehicles = {
  CaptainApplicationDtoOutputApplicationVehicleEnum.motorbike:
      Vehicle.motorbike,
  CaptainApplicationDtoOutputApplicationVehicleEnum.car: Vehicle.car,
  CaptainApplicationDtoOutputApplicationVehicleEnum.bicycle: Vehicle.bicycle,
  CaptainApplicationDtoOutputApplicationVehicleEnum.walking: Vehicle.walking,
};

final _vehicleChoices = {
  Vehicle.motorbike: CaptainApplicationVehicleDtoVehicleEnum.motorbike,
  Vehicle.car: CaptainApplicationVehicleDtoVehicleEnum.car,
  Vehicle.bicycle: CaptainApplicationVehicleDtoVehicleEnum.bicycle,
  Vehicle.walking: CaptainApplicationVehicleDtoVehicleEnum.walking,
};

final _kinds = {
  CaptainApplicationDtoOutputApplicationDocumentsInnerKindEnum.nationalId:
      DocumentKind.nationalId,
  CaptainApplicationDtoOutputApplicationDocumentsInnerKindEnum.personalPhoto:
      DocumentKind.personalPhoto,
  CaptainApplicationDtoOutputApplicationDocumentsInnerKindEnum.civilRegistry:
      DocumentKind.civilRegistry,
  CaptainApplicationDtoOutputApplicationDocumentsInnerKindEnum.criminalRecord:
      DocumentKind.criminalRecord,
  CaptainApplicationDtoOutputApplicationDocumentsInnerKindEnum.vehiclePapers:
      DocumentKind.vehiclePapers,
  CaptainApplicationDtoOutputApplicationDocumentsInnerKindEnum.drivingLicence:
      DocumentKind.drivingLicence,
};

final _requestKinds = {
  CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum.nationalId:
      DocumentKind.nationalId,
  CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum.personalPhoto:
      DocumentKind.personalPhoto,
  CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum.civilRegistry:
      DocumentKind.civilRegistry,
  CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum.criminalRecord:
      DocumentKind.criminalRecord,
  CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum.vehiclePapers:
      DocumentKind.vehiclePapers,
  CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum.drivingLicence:
      DocumentKind.drivingLicence,
};

final _statuses = {
  CaptainApplicationDtoOutputApplicationDocumentsInnerStatusEnum.pending:
      DocumentStatus.pending,
  CaptainApplicationDtoOutputApplicationDocumentsInnerStatusEnum.accepted:
      DocumentStatus.accepted,
  CaptainApplicationDtoOutputApplicationDocumentsInnerStatusEnum.rejected:
      DocumentStatus.rejected,
};

final _missing = <CaptainApplicationDtoOutputApplicationMissingEnum, Missing>{
  CaptainApplicationDtoOutputApplicationMissingEnum.vehicle:
      const MissingVehicle(),
  CaptainApplicationDtoOutputApplicationMissingEnum.documentColonNationalId:
      const MissingDocument(DocumentKind.nationalId),
  CaptainApplicationDtoOutputApplicationMissingEnum.documentColonPersonalPhoto:
      const MissingDocument(DocumentKind.personalPhoto),
  CaptainApplicationDtoOutputApplicationMissingEnum.documentColonCivilRegistry:
      const MissingDocument(DocumentKind.civilRegistry),
  CaptainApplicationDtoOutputApplicationMissingEnum.documentColonCriminalRecord:
      const MissingDocument(DocumentKind.criminalRecord),
  CaptainApplicationDtoOutputApplicationMissingEnum.documentColonVehiclePapers:
      const MissingDocument(DocumentKind.vehiclePapers),
  CaptainApplicationDtoOutputApplicationMissingEnum.documentColonDrivingLicence:
      const MissingDocument(DocumentKind.drivingLicence),
  CaptainApplicationDtoOutputApplicationMissingEnum.terms: const MissingTerms(),
};

class Zone {
  const Zone({required this.id, required this.name});
  final String id;
  final String name;
}

/// The applicant's application, read while the joining screens show; null
/// before step 1. Every step's answer replaces it.
final applicationProvider =
    AsyncNotifierProvider.autoDispose<ApplicationController, Application?>(
      ApplicationController.new,
    );

/// The neighbourhoods (owner decision 2026-11-19: the city's active zones).
final applicationZonesProvider = FutureProvider.autoDispose<List<Zone>>((
  ref,
) async {
  final answer = await ref
      .watch(coreApiProvider)
      .getCaptainApi()
      .captainApplicationZones();
  return [
    for (final zone in answer.data!.zones) Zone(id: zone.id, name: zone.name),
  ];
});

/// Why a step was not saved: the server's refusal code, or `failed` for no
/// answer or anything else.
class ApplicationRefusal implements Exception {
  const ApplicationRefusal(this.error);

  final String error;

  static const failed = 'failed';
  static const blurry = 'photo_blurry';
  static const dark = 'photo_dark';
  static const unreadable = 'photo_unreadable';
  static const twoSides = 'two_sides';
}

ApplicationRefusal _refusalOf(Object error) {
  if (error is ApplicationRefusal) return error;
  if (error is DioException) {
    final body = error.response?.data;
    if (body is Map && body['error'] is String) {
      return ApplicationRefusal(body['error'] as String);
    }
  }
  return const ApplicationRefusal(ApplicationRefusal.failed);
}

/// A document's photos picked and checked, then uploaded once each, however
/// often the document is sent again.
class DocumentPhoto {
  DocumentPhoto(this.photo);

  final PickedPhoto photo;
  String? uploadId;
}

/// Checks a picked photo for blur and darkness (CA §5.3); throws the retake
/// refusal when it fails. Tests give their own.
typedef PhotoChecker = Future<PhotoQuality?> Function(PickedPhoto photo);

final photoCheckerProvider = Provider<PhotoChecker>(
  (ref) =>
      (photo) => checkPhoto(photo.bytes),
);

class ApplicationController extends AsyncNotifier<Application?> {
  CaptainApi get _api => ref.read(coreApiProvider).getCaptainApi();

  @override
  Future<Application?> build() async {
    final answer = await ref
        .watch(coreApiProvider)
        .getCaptainApi()
        .captainApplicationGet();
    return applicationOf(answer.data!);
  }

  /// Reads the application again, such as after the terms were accepted.
  Future<void> reload() async {
    ref.invalidateSelf();
    await future;
  }

  /// Step 1. Throws an [ApplicationRefusal].
  Future<void> savePersonal({
    required String fullName,
    required String birthDate,
    required String zoneId,
  }) => _save(
    () => _api.captainApplicationPersonal(
      captainApplicationPersonalDto: CaptainApplicationPersonalDto(
        (b) => b
          ..fullName = fullName
          ..birthDate = DateTime.parse(birthDate).toDate()
          ..zoneId = zoneId,
      ),
    ),
  );

  /// Step 2.
  Future<void> saveVehicle(Vehicle vehicle, String plate) => _save(
    () => _api.captainApplicationVehicle(
      captainApplicationVehicleDto: CaptainApplicationVehicleDto(
        (b) => b
          ..vehicle = _vehicleChoices[vehicle]
          ..plate = isMotor(vehicle) ? plate : null,
      ),
    ),
  );

  /// Step 3: one document's photos, uploaded if not yet, then saved.
  Future<void> saveDocument(
    DocumentKind kind,
    List<DocumentPhoto> photos, {
    String? number,
    String? issueDate,
  }) async {
    if (photos.length < kind.minFiles) {
      throw ApplicationRefusal(
        kind == DocumentKind.nationalId
            ? ApplicationRefusal.twoSides
            : ApplicationRefusal.failed,
      );
    }
    await _save(() async {
      final ids = [for (final photo in photos) await _upload(photo)];
      return _api.captainApplicationDocument(
        kind: kind.wire,
        captainApplicationDocumentDto: CaptainApplicationDocumentDto(
          (b) => b
            ..uploadIds.replace(ids)
            ..number = number
            ..issueDate = issueDate == null
                ? null
                : DateTime.parse(issueDate).toDate(),
        ),
      );
    });
  }

  /// Step 5 «إرسال الطلب».
  Future<void> submit() => _save(() => _api.captainApplicationSubmit());

  /// Checks a picked photo before it joins a document (CA §5.3).
  Future<DocumentPhoto> check(PickedPhoto photo) async {
    final quality = await ref.read(photoCheckerProvider)(photo);
    switch (quality) {
      case PhotoQuality.ok:
        return DocumentPhoto(photo);
      case PhotoQuality.dark:
        throw const ApplicationRefusal(ApplicationRefusal.dark);
      case PhotoQuality.blurry:
        throw const ApplicationRefusal(ApplicationRefusal.blurry);
      case null:
        throw const ApplicationRefusal(ApplicationRefusal.unreadable);
    }
  }

  Future<String> _upload(DocumentPhoto photo) async {
    final known = photo.uploadId;
    if (known != null) return known;
    final answer = await _api.captainApplicationUpload(
      customerNewUploadDto: CustomerNewUploadDto(
        (b) => b
          ..contentType = _types[photo.photo.contentType]
          ..sizeBytes = photo.photo.bytes.length,
      ),
    );
    final upload = answer.data!;
    await ref.read(photoPutProvider)(upload.url, photo.photo);
    return photo.uploadId = upload.uploadId;
  }

  Future<void> _save(
    Future<Response<CaptainApplicationDtoOutput>> Function() call,
  ) async {
    try {
      final answer = await call();
      state = AsyncData(applicationOf(answer.data!));
    } on Object catch (error) {
      throw _refusalOf(error);
    }
  }
}

const _types = {
  'image/jpeg': CustomerNewUploadDtoContentTypeEnum.imageSlashJpeg,
  'image/png': CustomerNewUploadDtoContentTypeEnum.imageSlashPng,
  'image/webp': CustomerNewUploadDtoContentTypeEnum.imageSlashWebp,
};
