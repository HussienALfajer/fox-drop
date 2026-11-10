import 'package:core_l10n/core_l10n.dart';

import 'alerts.dart';
import 'commands.dart';
import 'door_payment.dart';
import 'location.dart';
import 'work.dart';

/// AP Appendix C: the labels of the outcomes that keep an amount to collect.
String collectOutcomeText(AppLocalizations l10n, CollectOutcome outcome) =>
    outcome == CollectOutcome.damaged
    ? l10n.captainOutcomeDamaged
    : l10n.captainOutcomeFree;

/// AP Appendix C: the outcomes' labels.
String outcomeText(AppLocalizations l10n, EndedOutcome outcome) =>
    switch (outcome) {
      EndedOutcome.free => l10n.captainOutcomeFree,
      EndedOutcome.fake => l10n.captainOutcomeFake,
      EndedOutcome.damaged => l10n.captainOutcomeDamaged,
      EndedOutcome.wrongRefused => l10n.captainOutcomeWrongRefused,
      _ => l10n.captainOutcomeFailedOther,
    };

/// CA §9.12, K10: what the captain does with a failed order's food.
String? foodText(AppLocalizations l10n, EndedFood? food) => switch (food) {
  EndedFood.keptByCaptain => l10n.captainFoodKept,
  EndedFood.returnedToRestaurant => l10n.captainFoodReturned,
  EndedFood.destroyed => l10n.captainFoodDestroyed,
  _ => null,
};

/// Every string the captain's screens map from a state, a refusal or an
/// alert (CA §7–§9, Appendix B).
extension CaptainTexts on AppLocalizations {
  String moneyOf(Money value) => formatMoney(value.amount, value.currency);

  String stateText(AvailabilityState state) => switch (state) {
    AvailabilityState.onlineAvailable => captainStateAvailable,
    AvailabilityState.busy => captainStateBusy,
    AvailabilityState.notReceivingOffers => captainStateNoOffers,
    AvailabilityState.suspended => captainStateSuspended,
    _ => captainStateOffline,
  };

  /// Why no offers arrive (CA §7.1: the reason is shown).
  List<String> noOffersTexts(Availability availability) {
    final custody = availability.custody;
    return [
      for (final reason in availability.availability.reasons)
        switch (reason) {
          NoOffersReason.cashLimit => captainNoOffersCashLimit(
            formatMoney(custody.limit.amount, custody.limit.currency),
          ),
          NoOffersReason.closedDue => captainNoOffersClosedDue(
            formatMoney(custody.closedDue.amount, custody.closedDue.currency),
          ),
          _ => captainStopMockLocation,
        },
    ];
  }

  /// A block of going online (CA §7.2), from the server's refusal. Amounts
  /// are in the base currency of the captain's custody.
  String blockText(Map<Object?, Object?> block, String currency) {
    String text(Object? value) => value?.toString() ?? '';
    DateTime? at(Object? value) =>
        value is String ? DateTime.tryParse(value) : null;
    return switch (block['kind']) {
      'closed_due' => captainBlockClosedDue(
        // The cutoff closes the business day before it (CA §4.7).
        at(block['cutoff']) == null
            ? ''
            : formatDate(
                at(block['cutoff'])!.subtract(const Duration(days: 1)),
              ),
        formatMoney(text(block['amount']), currency),
      ),
      'cash_limit' => captainNoOffersCashLimit(
        formatMoney(text(block['limit']), currency),
      ),
      'suspended' =>
        at(block['until']) == null
            ? captainBlockSuspended(text(block['reason']))
            : captainBlockSuspendedUntil(
                formatDate(at(block['until'])!),
                text(block['reason']),
              ),
      'terms_not_accepted' => captainTermsPendingBanner,
      'version_below_minimum' => captainBlockVersion(text(block['minVersion'])),
      'simulated_location' => captainStopMockLocation,
      'contract_ended' => captainContractEnded,
      _ => captainCommandFailed,
    };
  }

  String locationText(LocationProblem? problem) => switch (problem) {
    LocationProblem.serviceOff => captainLocationOff,
    LocationProblem.denied => captainLocationDenied,
    _ => captainLocationFailed,
  };

  /// A command's refusal (CA §4.6). [currency] is the custody's, for the
  /// online blocks.
  String noticeText(Notice notice, {String currency = 'TRY'}) =>
      switch (notice) {
        LocationNeeded(:final problem) => locationText(problem),
        OnlineBlocked(:final blocks) =>
          blocks.map((b) => blockText(b, currency)).join('\n'),
        OfflineWithOrder() => captainOfflineWithOrder,
        OfferUnavailable() => captainOfferUnavailable,
        TooFar(fromCustomer: false) => captainGetCloser,
        TooFar() => captainAwayTitle,
        WeakLocation() => captainWeakGps,
        SimulatedLocation() => captainStopMockLocation,
        StaleLocation() => captainStaleLocation,
        NotOnline() => captainNotOnline,
        AmountMismatch() => captainAmountMismatch,
        ShortfallReasonRequired(:final shortfall) => captainShortBy(
          moneyOf(shortfall),
        ),
        Overpaid() => captainOverpaid,
        AmountDueChanged(:final amountDue) =>
          amountDue == null
              ? captainStateChanged
              : captainAmountDueChanged(moneyOf(amountDue)),
        StateChanged() => captainStateChanged,
        ItemReportOpen() => captainWaitingForOrderEdit,
        EditUnacknowledged() => captainWaitingForEditAcknowledgement,
        CommandFailed() => captainCommandFailed,
        ReasonChanged() => captainReasonChanged,
      };

  String alertText(Alert alert) => switch (alert) {
    OfferExpired() => captainOfferExpired,
    OfferGone() => captainOfferUnavailable,
    AssignedByOperations(:final number) => captainOpsAssigned(number),
    OrderReady(:final number) => captainOrderReadyChime(number),
    PickedUp(byOperations: true) => captainOpsConfirmedPickup,
    PickedUp() => captainPickedUp,
    PickupRefused(:final request) => refusalText(request),
    PickupDisputed() => captainPickupDisputed,
    OrderCancelled(:final cancelled) => captainTaskCancelled(cancelled.reason),
    OrderWithdrawn(:final withdrawn) => captainOrderWithdrawn(withdrawn.reason),
    OutcomeSet(:final ended) => captainOutcomeSet(
      outcomeText(this, ended.outcome),
    ),
    OutcomeToCollect(:final outcome, :final amount) => captainOutcomeCollect(
      collectOutcomeText(this, outcome),
      moneyOf(amount),
    ),
    OrderEdited(:final pay, :final collect) => captainOrderEdited(
      moneyOf(pay),
      moneyOf(collect),
    ),
    ItemsRemovedAfterPickup(:final collect) => captainItemsRemovedAfterPickup(
      moneyOf(collect),
    ),
    CollectLowered(:final collect) => captainCollectLowered(moneyOf(collect)),
  };

  /// What to do about the cash paid to the restaurant on a cancelled order
  /// (CA §9.10), or null when there is nothing to say.
  String? cashText(CancelledCash? cash) => switch (cash) {
    CancelledCash.returned => captainCashTakeBack,
    CancelledCash.notReturned => captainCashKeepWithRestaurant,
    _ => null,
  };

  /// The same on an order operations took from the captain (CA §9.10, AP
  /// §8.1).
  String? withdrawnCashText(WithdrawnCash? cash) => switch (cash) {
    WithdrawnCash.returned => captainCashTakeBack,
    WithdrawnCash.notReturned => captainCashKeepWithRestaurant,
    _ => null,
  };

  /// The restaurant's answer to a refused pickup request (CA §9.4 item 4).
  String refusalText(PickupRequest request) {
    final received = request.receivedLines;
    if (request.outcome == RequestOutcome.amountIncorrect && received != null) {
      return captainRestaurantReceived(
        received.map((l) => formatMoney(l.amount, l.currency)).join(' + '),
      );
    }
    return captainRestaurantIncomplete;
  }

  String stepName(int step) => switch (step) {
    2 => captainStepAtRestaurant,
    3 => captainStepToCustomer,
    4 => captainStepAtCustomer,
    _ => captainStepToRestaurant,
  };

  /// «تغيّرت عهدتك: {+المبلغ}» shows its sign (CA §9.8).
  String signedMoney(String amount, String currency) {
    final text = formatMoney(amount, currency);
    return BigInt.parse(amount) > BigInt.zero ? '+$text' : text;
  }
}
