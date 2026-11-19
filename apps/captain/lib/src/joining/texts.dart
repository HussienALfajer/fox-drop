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

/// CA §5.4: what the applicant sees at each stage. The interview's
/// appointment and the rejection's reason come with slice 2.34b.
String stageText(AppLocalizations l10n, ApplicationStage stage) =>
    switch (stage) {
      ApplicationStage.draft ||
      ApplicationStage.newApplication => l10n.captainApplicationStageNew,
      ApplicationStage.underReview => l10n.captainApplicationStageUnderReview,
      ApplicationStage.interview => l10n.captainApplicationStageInterview,
      ApplicationStage.awaitingKit => l10n.captainApplicationStageAwaitingKit,
      ApplicationStage.active => l10n.captainApplicationStageActive,
      ApplicationStage.waitlist => l10n.captainApplicationStageWaitlist,
      ApplicationStage.rejected => l10n.captainApplicationStageRejected,
    };

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
      'too_many_uploads' => l10n.captainApplicationTooManyUploads,
      ApplicationRefusal.twoSides => l10n.captainApplicationTwoSides,
      ApplicationRefusal.blurry => l10n.captainPhotoBlurry,
      ApplicationRefusal.dark => l10n.captainPhotoDark,
      ApplicationRefusal.unreadable => l10n.captainPhotoUnreadable,
      _ => l10n.captainApplicationFailed,
    };
