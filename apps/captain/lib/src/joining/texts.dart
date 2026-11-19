import 'package:core_l10n/core_l10n.dart';

import 'application.dart';

/// Every string of the joining screens (CA §5, Appendix B).

String vehicleText(AppLocalizations l10n, Vehicle vehicle) => switch (vehicle) {
  Vehicle.motorbike => l10n.captainApplicationVehicleMotorbike,
  Vehicle.car => l10n.captainApplicationVehicleCar,
  Vehicle.bicycle => l10n.captainApplicationVehicleBicycle,
  Vehicle.walking => l10n.captainApplicationVehicleWalking,
};

String documentText(AppLocalizations l10n, DocumentKind kind) => switch (kind) {
  DocumentKind.nationalId => l10n.captainDocumentNationalId,
  DocumentKind.personalPhoto => l10n.captainDocumentPersonalPhoto,
  DocumentKind.civilRegistry => l10n.captainDocumentCivilRegistry,
  DocumentKind.criminalRecord => l10n.captainDocumentCriminalRecord,
  DocumentKind.vehiclePapers => l10n.captainDocumentVehiclePapers,
  DocumentKind.drivingLicence => l10n.captainDocumentDrivingLicence,
};

/// A document's line on step 3 and the status page (CA §5.3).
String documentStatusText(
  AppLocalizations l10n,
  ApplicationDocument? document,
) => switch (document?.status) {
  null => l10n.captainDocumentNotUploaded,
  DocumentStatus.pending => l10n.captainDocumentPending,
  DocumentStatus.accepted => l10n.captainDocumentAccepted,
  DocumentStatus.rejected => l10n.captainDocumentRejected(
    document?.reason ?? '',
  ),
};

String missingText(AppLocalizations l10n, Missing missing) => switch (missing) {
  MissingVehicle() => l10n.captainApplicationStepVehicle,
  MissingDocument(:final kind) => documentText(l10n, kind),
  MissingTerms() => l10n.captainApplicationStepTerms,
};

/// CA §5.4: what the applicant sees at each stage, the appointment and the
/// rejection on the city's clock; a stage the server sent without its
/// appointment or reason shows the stage's name.
String stageText(AppLocalizations l10n, Application application) =>
    switch (application.stage) {
      ApplicationStage.draft ||
      ApplicationStage.newApplication => l10n.captainApplicationStageNew,
      ApplicationStage.underReview => l10n.captainApplicationStageUnderReview,
      ApplicationStage.interview => switch (application.interview) {
        final interview? => l10n.captainApplicationInterviewAt(
          '${l10n.weekdayOf(interview.at)} ${l10n.formatDate(interview.at)}',
          l10n.formatTime(interview.at),
          interview.place,
        ),
        null => l10n.captainApplicationStageNameInterview,
      },
      ApplicationStage.awaitingKit => l10n.captainApplicationStageAwaitingKit,
      ApplicationStage.active => l10n.captainApplicationStageActive,
      ApplicationStage.waitlist => l10n.captainApplicationStageWaitlist,
      ApplicationStage.rejected => switch (application.rejection) {
        final rejection? => l10n.captainApplicationRejectedBecause(
          rejection.reason,
          l10n.formatDate(rejection.reapplyFrom),
        ),
        null => l10n.captainApplicationStageNameRejected,
      },
    };

/// An open «طلب مستند»: «يرجى رفع {المستند}: {السبب}».
String requestText(AppLocalizations l10n, DocumentRequest request) =>
    l10n.captainApplicationDocumentRequested(
      documentText(l10n, request.kind),
      request.reason,
    );

/// A stage's name in the history (AP §9.7.1).
String stageName(
  AppLocalizations l10n,
  ApplicationStage stage,
) => switch (stage) {
  ApplicationStage.draft => l10n.captainApplicationStageNameDraft,
  ApplicationStage.newApplication => l10n.captainApplicationStageNameNew,
  ApplicationStage.underReview => l10n.captainApplicationStageNameUnderReview,
  ApplicationStage.interview => l10n.captainApplicationStageNameInterview,
  ApplicationStage.awaitingKit => l10n.captainApplicationStageNameAwaitingKit,
  ApplicationStage.active => l10n.captainApplicationStageNameActive,
  ApplicationStage.waitlist => l10n.captainApplicationStageNameWaitlist,
  ApplicationStage.rejected => l10n.captainApplicationStageNameRejected,
};

/// One line of the history: the stage, then its date and time on the
/// city's clock.
String historyText(AppLocalizations l10n, StageChange change) =>
    '${stageName(l10n, change.stage)}: '
    '${l10n.formatDate(change.at)} ${l10n.formatTime(change.at)}';

/// A step's refusal (the server's codes, and the photo checks').
String refusalText(AppLocalizations l10n, ApplicationRefusal refusal) =>
    switch (refusal.error) {
      'invalid_name' => l10n.captainApplicationInvalidName,
      'too_young' => l10n.captainApplicationTooYoung,
      'unknown_zone' => l10n.captainApplicationUnknownZone,
      'plate_required' => l10n.captainApplicationPlateRequired,
      'number_required' => l10n.captainApplicationIdNumberRequired,
      'issue_date_required' => l10n.captainApplicationIssueDateRequired,
      'issue_date_in_future' => l10n.captainApplicationIssueDateFuture,
      'document_expired' => l10n.captainApplicationDocumentExpired,
      'application_submitted' => l10n.captainApplicationSubmitted,
      'reapply_wait' => l10n.captainApplicationReapplyWait,
      'too_many_uploads' => l10n.captainApplicationTooManyUploads,
      ApplicationRefusal.twoSides => l10n.captainApplicationTwoSides,
      ApplicationRefusal.blurry => l10n.captainPhotoBlurry,
      ApplicationRefusal.dark => l10n.captainPhotoDark,
      ApplicationRefusal.unreadable => l10n.captainPhotoUnreadable,
      _ => l10n.captainApplicationFailed,
    };
