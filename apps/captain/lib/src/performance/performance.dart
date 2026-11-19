import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';

typedef Performance = CaptainPerformanceDtoOutput;
typedef Violation = CaptainPerformanceDtoOutputViolationsInner;
typedef ViolationStep = CaptainPerformanceDtoOutputViolationsInnerStepEnum;
typedef OfferResponse =
    CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum;
typedef AppealOutcome =
    CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum;

/// CA §11 «أدائي» (slice 2.36b): `GET /v1/captain/performance`, read each
/// time the screen or home's warning shows, and again after an appeal and on
/// the violation's push.
final performanceProvider = FutureProvider.autoDispose<Performance>((
  ref,
) async {
  final answer = await ref
      .read(coreApiProvider)
      .getCaptainApi()
      .captainPerformanceRead();
  return answer.data!;
});

/// Online minutes as hours to one decimal, Western digits.
String hoursOf(int minutes) {
  final hours = minutes / 60;
  return hours == hours.roundToDouble()
      ? hours.round().toString()
      : hours.toStringAsFixed(1);
}

/// The appeal's state on a violation (CA §11.3).
enum AppealState { none, open, accepted, rejected }

AppealState appealStateOf(Violation violation) {
  final appeal = violation.appeal;
  if (appeal == null) return AppealState.none;
  return switch (appeal.outcome) {
    AppealOutcome.accepted => AppealState.accepted,
    AppealOutcome.rejected => AppealState.rejected,
    _ => AppealState.open,
  };
}

extension PerformanceTexts on AppLocalizations {
  /// AP §9.7.6: the ladder's steps.
  String stepText(ViolationStep step) => switch (step) {
    ViolationStep.warning => captainStepWarning,
    ViolationStep.suspension1d => captainStepSuspension1d,
    ViolationStep.suspension7d => captainStepSuspension7d,
    _ => captainStepTermination,
  };

  /// CA §11.1: an offer's response.
  String responseText(OfferResponse response) => switch (response) {
    OfferResponse.accepted => captainOfferAccepted,
    OfferResponse.declined => captainOfferDeclined,
    _ => captainOfferExpired,
  };

  /// CA §11.3: what became of the appeal; null without one.
  String? appealText(AppealState state) => switch (state) {
    AppealState.none => null,
    AppealState.open => captainAppealOpen,
    AppealState.accepted => captainAppealAccepted,
    AppealState.rejected => captainAppealRejected,
  };
}
