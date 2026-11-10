import 'package:core_l10n/core_l10n.dart';

import 'alerts.dart';
import 'board.dart';
import 'commands.dart';

String columnTitle(AppLocalizations l10n, BoardColumn column) =>
    switch (column) {
      BoardColumn.incoming => l10n.merchantColumnIncoming,
      BoardColumn.preparing => l10n.merchantColumnPreparing,
      BoardColumn.ready => l10n.merchantColumnReady,
      BoardColumn.withCaptain => l10n.merchantColumnWithCaptain,
    };

String captainLineText(AppLocalizations l10n, CaptainLine line, DateTime now) =>
    switch (line) {
      WaitingForCaptain() => l10n.merchantWaitingForCaptain,
      CaptainOnTheWay(:final name) => l10n.merchantCaptainOnTheWay(name),
      CaptainWaiting(:final since) => l10n.merchantCaptainWaiting(
        now.difference(since).inMinutes,
      ),
      CaptainAsksPickup() => l10n.merchantCaptainAsksPickup,
      WithCaptain(:final name) => l10n.merchantWithCaptain(name),
    };

/// The column's running timer (RA §8.2): the auto-cancel countdown, the prep
/// countdown or «متأخر {د} د», or the time since pickup. The captain's
/// waiting time is in the captain line.
String? columnTimer(AppLocalizations l10n, BoardOrder order, DateTime now) {
  switch (order.status) {
    case OrderStatus.placed:
      final at = order.autoCancelAt;
      return at == null
          ? null
          : l10n.merchantAutoCancelIn(l10n.formatCountdown(at.difference(now)));
    case OrderStatus.accepted:
      final due = order.acceptance?.prepDueAt;
      if (due == null) return null;
      return now.isBefore(due)
          ? l10n.merchantPrepLeft(l10n.formatCountdown(due.difference(now)))
          : l10n.merchantPrepLate(now.difference(due).inMinutes);
    case OrderStatus.pickedUp || OrderStatus.arrived:
      final at = order.pickup.pickedUpAt;
      return at == null
          ? null
          : l10n.merchantPickedUpSince(now.difference(at).inMinutes);
    case OrderStatus.delivered:
      return l10n.merchantDelivered;
    default:
      return null;
  }
}

/// A rejection reason's label (RA §8.6, R3): Content's ([labels], which
/// operations may edit), else the built-in one; an unknown code shows
/// itself.
String rejectReasonText(
  AppLocalizations l10n,
  String code, [
  Map<String, String>? labels,
]) =>
    labels?[code] ??
    switch (code) {
      'item_unavailable' => l10n.merchantRejectItemUnavailable,
      'restaurant_closed' => l10n.merchantRejectRestaurantClosed,
      'too_busy' => l10n.merchantRejectTooBusy,
      _ => code,
    };

String noticeText(
  AppLocalizations l10n,
  BoardNotice notice, [
  Map<String, String>? rejectionLabels,
]) => switch (notice) {
  AcceptedByOperations(:final number, :final prepMin) =>
    l10n.merchantAcceptedByOperations(number, prepMin),
  RejectedByOperations(:final number, :final reason) =>
    l10n.merchantRejectedByOperations(
      number,
      rejectReasonText(l10n, reason, rejectionLabels),
    ),
  AutoCancelled(:final number) => l10n.merchantAutoCancelled(number),
  CustomerCancelled(:final number) => l10n.merchantCustomerCancelled(number),
  Cancelled(:final number) => l10n.merchantCancelled(number),
  PrepTimeChanged(:final number, :final prepMin) =>
    l10n.merchantPrepTimeChanged(number, prepMin),
  ItemReportClosed(:final number, :final reason) =>
    l10n.merchantItemReportClosed(number, reason),
  OrderEdited(:final number) => l10n.merchantOrderEdited(number),
  PrepLate(:final number) => l10n.merchantPrepLateChime(number),
  CaptainArrived(:final name, :final number) => l10n.merchantCaptainArrived(
    name,
    number,
  ),
  CaptainKeptWaiting(:final number, :final minutes) =>
    l10n.merchantCaptainKeptWaiting(number, minutes),
  PickupClosed(:final number, :final outcome, :final userName) =>
    pickupClosedText(l10n, number, outcome?.name, userName),
};

/// How a pickup request closed, as the other devices say it (RA §8.10).
String pickupClosedText(
  AppLocalizations l10n,
  String number,
  String? outcome,
  String? userName,
) {
  final name = userName ?? '';
  return switch (outcome) {
    'restaurant' => l10n.merchantPickupConfirmedBy(name),
    'amountIncorrect' ||
    'amount_incorrect' => l10n.merchantPickupDisputedBy(name),
    'incomplete' => l10n.merchantPickupIncompleteBy(name),
    'automatic' => l10n.merchantPickupAutoConfirmed(number),
    'operations' => l10n.merchantPickupByOperations(number),
    _ => l10n.merchantPickupClosed(number),
  };
}

String commandText(AppLocalizations l10n, CommandNotice notice) =>
    switch (notice) {
      AcceptedElsewhere(:final deviceName) =>
        deviceName == null
            ? l10n.merchantAcceptedElsewhere
            : l10n.merchantAcceptedOnDevice(deviceName),
      AcceptedByOperationsFirst() => l10n.merchantBadgeByOperations,
      CancelledFirst() => l10n.merchantCancelledFirst,
      RejectedFirst() => l10n.merchantRejectedFirst,
      RejectRefused() => l10n.merchantRejectRefused,
      PickupAnsweredElsewhere(:final outcome, :final userName) =>
        pickupClosedText(l10n, '', outcome, userName),
      StateChanged() => l10n.merchantStateChanged,
      LinesRefused() => l10n.merchantLinesRefused,
      AlreadyDisputed() => l10n.merchantAlreadyDisputed,
      ItemReportRefused() => l10n.merchantItemReportRefused,
      ReportWhilePickupOpen() => l10n.merchantItemReportPickupOpen,
      ItemReportOpenFirst() => l10n.merchantItemReportOpenFirst,
      ItemReportClosedFirst() => l10n.merchantItemReportClosedFirst,
      CommandFailed() => l10n.merchantCommandFailed,
    };

/// The report's optional notes (RA §8.12): Content's `item_unavailable_note`
/// list ([labels], codes to labels, which operations may edit), else the
/// built-in labels of its seeded codes.
Map<String, String> itemReportNoteLabels(
  AppLocalizations l10n, [
  Map<String, String>? labels,
]) =>
    labels ??
    {
      'similar_alternative': l10n.merchantItemReportSimilar,
      'insufficient_quantity': l10n.merchantItemReportNotEnough,
    };

String paymentLinesText(
  AppLocalizations l10n,
  Iterable<({String amount, String currency})> lines,
) => lines.map((l) => l10n.formatMoney(l.amount, l.currency)).join(' + ');

/// A request's payment lines as plain records.
List<({String amount, String currency})> requestLines(PickupRequest request) =>
    [
      for (final line in request.lines)
        if (line != null) (amount: line.amount, currency: line.currency),
    ];
