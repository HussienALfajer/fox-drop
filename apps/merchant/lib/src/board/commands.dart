import 'dart:async';
import 'dart:math';

import 'package:core_api/core_api.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_auth/core_auth.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import 'board.dart';

/// A board command (RA §8.5, §8.8, §8.10).
enum CommandKind {
  accept,
  reject,
  ready,
  confirmPickup,
  disputePickup,
  incomplete,
  acknowledgeCancellation,
  reportItems,
  withdrawItemReport,
}

/// The three rejection reasons, the codes of the closed list (RA §8.6, R3).
enum RejectReason {
  itemUnavailable('item_unavailable'),
  restaurantClosed('restaurant_closed'),
  tooBusy('too_busy');

  const RejectReason(this.code);
  final String code;
}

/// What «ضغط طلبات» also sets (RA §8.6: optional).
sealed class TooBusyStep {
  const TooBusyStep();
}

class RejectOnly extends TooBusyStep {
  const RejectOnly();
}

/// «تفعيل وضع الضغط» with one of the restaurant's busy-mode options.
class BusyModeStep extends TooBusyStep {
  const BusyModeStep(this.extraMin);
  final int extraMin;
}

/// «إيقاف 30 د».
class PauseStep extends TooBusyStep {
  const PauseStep();
}

/// RA §8.6: «إيقاف 30 د» is the only pause «ضغط طلبات» offers.
const tooBusyPauseMin = 30;

/// A rejection as the sheet sends it (RA §8.6): the reason; for «صنف غير
/// متوفر» the items, each off «حتى الغد» (true) or «حتى أعيده» (false); for
/// «ضغط طلبات» its step.
class Rejection {
  const Rejection(
    this.reason, {
    this.items = const {},
    this.step = const RejectOnly(),
  });

  final RejectReason reason;
  final Map<String, bool> items;
  final TooBusyStep step;

  /// Whether the server would take it: the items only for «صنف غير متوفر»,
  /// where one at least is needed.
  bool get complete =>
      reason == RejectReason.itemUnavailable ? items.isNotEmpty : items.isEmpty;

  /// The command's body, the same for each retry of its key.
  String get body => [
    reason.code,
    for (final entry in items.entries) '${entry.key}:${entry.value}',
    switch (step) {
      RejectOnly() => '',
      BusyModeStep(:final extraMin) => 'busy$extraMin',
      PauseStep() => 'pause',
    },
  ].join(' ');
}

/// «صنف غير متوفر — اتصلوا بالزبون» as the sheet sends it (RA §8.12): the
/// items, each off «حتى الغد» (true) or «حتى أعيده» (false), and the
/// optional note, a code of Content's `item_unavailable_note` list.
class ItemReport {
  const ItemReport(this.items, {this.note});

  final Map<String, bool> items;
  final String? note;

  /// One item at least (RA §8.12: the items are required).
  bool get complete => items.isNotEmpty;

  /// The command's body, the same for each retry of its key.
  String get body => [
    for (final entry in items.entries) '${entry.key}:${entry.value}',
    note ?? '',
  ].join(' ');
}

/// What the screen says after a command, when it says anything.
sealed class CommandNotice {
  const CommandNotice();
}

/// «قُبل الطلب من جهاز {اسم الجهاز}» (RA §4.7).
class AcceptedElsewhere extends CommandNotice {
  const AcceptedElsewhere(this.deviceName);
  final String? deviceName;
}

/// «قبلته العمليات»: operations accepted before this device's decision
/// arrived (RA §8.15).
class AcceptedByOperationsFirst extends CommandNotice {
  const AcceptedByOperationsFirst();
}

/// «أُلغي الطلب قبل وصول قبولك» (RA §4.7).
class CancelledFirst extends CommandNotice {
  const CancelledFirst();
}

/// The pickup request was answered first: by another user («أكّد {اسم
/// المستخدم} الاستلام», «أبلغ {اسم المستخدم} أن المبلغ غير صحيح») or
/// automatically (RA §8.10).
class PickupAnsweredElsewhere extends CommandNotice {
  const PickupAnsweredElsewhere(this.outcome, this.userName);
  final String? outcome;
  final String? userName;
}

/// «رُفض الطلب قبل وصول طلبك»: rejected by another device or operations.
class RejectedFirst extends CommandNotice {
  const RejectedFirst();
}

/// The rejection's choices were refused (`unknown_reason`,
/// `invalid_rejection`).
class RejectRefused extends CommandNotice {
  const RejectRefused();
}

/// The order changed in another way before the command arrived.
class StateChanged extends CommandNotice {
  const StateChanged();
}

/// The amounts were refused (`invalid_lines`, `currency_not_accepted`).
class LinesRefused extends CommandNotice {
  const LinesRefused();
}

/// The dispute window was used already (`pickup_already_disputed`).
class AlreadyDisputed extends CommandNotice {
  const AlreadyDisputed();
}

/// The report's choices were refused (`400 invalid_item_report`), or its
/// note is no longer in Content's list (`400 unknown_reason`): the list is
/// read again for the next report.
class ItemReportRefused extends CommandNotice {
  const ItemReportRefused();
}

/// The report came while the captain's pickup request was open (RA §8.10:
/// the button is hidden then).
class ReportWhilePickupOpen extends CommandNotice {
  const ReportWhilePickupOpen();
}

/// Another device reported an item first: one report is open at a time.
class ItemReportOpenFirst extends CommandNotice {
  const ItemReportOpenFirst();
}

/// «تراجع — الصنف متوفر» came after the report closed: operations edited,
/// cancelled or closed it, or another device withdrew it.
class ItemReportClosedFirst extends CommandNotice {
  const ItemReportClosedFirst();
}

/// Any other refusal.
class CommandFailed extends CommandNotice {
  const CommandFailed();
}

/// The orders with a command in flight, which show «جارٍ الإرسال…» and
/// cannot be pressed again (RA §4.7).
class BoardCommands extends Notifier<Set<String>> {
  final Map<String, String> _keys = {};

  /// The pickup requests this device answered, whose closing it does not
  /// announce as another user's.
  final Set<String> answeredHere = {};

  /// Waits before each retry; tests make it short.
  Duration Function(int attempt) backoff = (attempt) {
    final base = min(15000, 1000 * pow(2, attempt).toInt());
    return Duration(milliseconds: base ~/ 2 + Random().nextInt(base ~/ 2 + 1));
  };

  @override
  Set<String> build() => const {};

  MerchantApi get _api => ref.read(coreApiProvider).getMerchantApi();

  Future<CommandNotice?> accept(String orderId, int prepMin) => _send(
    orderId,
    CommandKind.accept,
    '$prepMin',
    (key) => _api.merchantOrdersAccept(
      orderId: orderId,
      idempotencyKey: key,
      merchantAcceptDto: MerchantAcceptDto((b) => b..prepMin = prepMin),
    ),
  );

  /// «رفض» with its reason and steps (RA §8.6).
  Future<CommandNotice?> reject(String orderId, Rejection rejection) => _send(
    orderId,
    CommandKind.reject,
    rejection.body,
    (key) => _api.merchantOrdersReject(
      orderId: orderId,
      idempotencyKey: key,
      merchantRejectDto: MerchantRejectDto(
        (b) => b
          ..reason = rejection.reason.code
          ..items = ListBuilder([
            for (final entry in rejection.items.entries)
              MerchantRejectDtoItemsInner(
                (i) => i
                  ..itemId = entry.key
                  ..until = entry.value
                      ? MerchantRejectDtoItemsInnerUntilEnum.tomorrow
                      : MerchantRejectDtoItemsInnerUntilEnum.turnedBackOn,
              ),
          ])
          ..busyExtraMin = switch (rejection.step) {
            BusyModeStep(:final extraMin) => extraMin,
            _ => null,
          }
          ..pauseMin = rejection.step is PauseStep ? tooBusyPauseMin : null,
      ),
    ),
  );

  Future<CommandNotice?> ready(String orderId) => _send(
    orderId,
    CommandKind.ready,
    '',
    (key) => _api.merchantOrdersReady(orderId: orderId, idempotencyKey: key),
  );

  Future<CommandNotice?> confirmPickup(String orderId, String requestId) {
    return _send(
      orderId,
      CommandKind.confirmPickup,
      requestId,
      answers: requestId,
      (key) => _api.merchantOrdersConfirmPickup(
        orderId: orderId,
        idempotencyKey: key,
      ),
    );
  }

  /// «المبلغ غير صحيح» with what the restaurant received, before or after
  /// the pickup (RA §8.10 items 6 and 8).
  Future<CommandNotice?> disputePickup(
    String orderId,
    String? requestId,
    List<({String amount, String currency})> received,
  ) {
    return _send(
      orderId,
      CommandKind.disputePickup,
      '$requestId ${received.map((l) => '${l.amount} ${l.currency}').join(',')}',
      answers: requestId,
      (key) => _api.merchantOrdersDisputePickup(
        orderId: orderId,
        idempotencyKey: key,
        merchantPickupDisputeDto: MerchantPickupDisputeDto(
          (b) => b.receivedLines.addAll([
            for (final line in received)
              MerchantPickupDisputeDtoReceivedLinesInner(
                (l) => l
                  ..amount = line.amount
                  ..currency = line.currency,
              ),
          ]),
        ),
      ),
    );
  }

  /// «الطلب غير مكتمل» (RA §8.10 item 7).
  Future<CommandNotice?> incomplete(String orderId, String requestId) {
    return _send(
      orderId,
      CommandKind.incomplete,
      requestId,
      answers: requestId,
      (key) => _api.merchantOrdersPickupIncomplete(
        orderId: orderId,
        idempotencyKey: key,
      ),
    );
  }

  /// «حسناً» on operations' cancellation after acceptance (RA §8.14, §18):
  /// every device's board drops the order, so the ring stops on all.
  Future<CommandNotice?> acknowledgeCancellation(String orderId) => _send(
    orderId,
    CommandKind.acknowledgeCancellation,
    '',
    (key) => _api.merchantOrdersAcknowledgeCancellation(
      orderId: orderId,
      idempotencyKey: key,
    ),
  );

  /// «صنف غير متوفر — اتصلوا بالزبون» (RA §8.12).
  Future<CommandNotice?> reportItems(String orderId, ItemReport report) =>
      _send(
        orderId,
        CommandKind.reportItems,
        report.body,
        (key) => _api.merchantOrdersReportItems(
          orderId: orderId,
          idempotencyKey: key,
          merchantItemReportDto: MerchantItemReportDto(
            (b) => b
              ..items = ListBuilder([
                for (final entry in report.items.entries)
                  MerchantRejectDtoItemsInner(
                    (i) => i
                      ..itemId = entry.key
                      ..until = entry.value
                          ? MerchantRejectDtoItemsInnerUntilEnum.tomorrow
                          : MerchantRejectDtoItemsInnerUntilEnum.turnedBackOn,
                  ),
              ])
              ..note = report.note,
          ),
        ),
      );

  /// «تراجع — الصنف متوفر»: the items come back on (RA §8.12).
  Future<CommandNotice?> withdrawItemReport(String orderId) => _send(
    orderId,
    CommandKind.withdrawItemReport,
    '',
    (key) => _api.merchantOrdersWithdrawItemReport(
      orderId: orderId,
      idempotencyKey: key,
    ),
  );

  // One command at a time per order. Its key belongs to the command's body:
  // a call without an answer (none, a 5xx, a 408 or a 429) is sent again
  // with the same key after a backoff until the server answers (RA §4.7),
  // and an answered command drops it. [answers] is the pickup request the
  // command closes, marked while it is sent and kept unless refused, so this
  // device does not announce its own answer as another user's.
  Future<CommandNotice?> _send(
    String orderId,
    CommandKind kind,
    String body,
    Future<Object?> Function(String key) call, {
    String? answers,
  }) async {
    if (state.contains(orderId)) return null;
    state = {...state, orderId};
    final command = '$orderId ${kind.name} $body';
    final key = _keys[command] ??= uuidV4();
    if (answers != null) answeredHere.add(answers);
    try {
      for (var attempt = 0; ; attempt++) {
        try {
          await call(key);
          return null;
        } on DioException catch (error) {
          final answer = error.response;
          final status = answer?.statusCode ?? 0;
          if (answer != null &&
              status < 500 &&
              status != 408 &&
              status != 429) {
            // Another device or the server answered first.
            if (answers != null) answeredHere.remove(answers);
            return _refused(kind, answer);
          }
          if (!ref.mounted) return null;
          await Future<void>.delayed(backoff(attempt));
          if (!ref.mounted) return null;
        }
      }
    } on Object {
      // An answer the client could not read: the board's next fetch shows
      // what happened.
      return const CommandFailed();
    } finally {
      _keys.remove(command);
      if (ref.mounted) {
        state = {...state}..remove(orderId);
        if (ref.exists(boardFeedProvider)) {
          unawaited(ref.read(boardFeedProvider)?.refresh());
        }
      }
    }
  }

  CommandNotice? _refused(CommandKind kind, Response<Object?> answer) {
    // The order no longer waits for «حسناً»: the board fetched after the
    // answer drops it, with nothing to explain.
    if (kind == CommandKind.acknowledgeCancellation &&
        answer.statusCode == 409) {
      return null;
    }
    final body = answer.data;
    final error = body is Map ? body['error'] : null;
    final order = body is Map ? body['order'] : null;
    switch (error) {
      case 'invalid_lines' || 'currency_not_accepted':
        return const LinesRefused();
      case 'pickup_already_disputed':
        return const AlreadyDisputed();
      case 'unknown_reason' when kind == CommandKind.reportItems:
        return const ItemReportRefused();
      case 'unknown_reason' || 'invalid_rejection':
        return const RejectRefused();
      case 'invalid_item_report':
        return const ItemReportRefused();
      case 'order_state_changed':
        if (order is! Map) return const StateChanged();
        final status = order['status'];
        if (status == 'cancelled') return const CancelledFirst();
        if (status == 'rejected') return const RejectedFirst();
        if (kind == CommandKind.withdrawItemReport) {
          return order['itemReport'] == null
              ? const ItemReportClosedFirst()
              : const StateChanged();
        }
        if (kind == CommandKind.reportItems) {
          final pickup = order['pickup'];
          final request = pickup is Map ? pickup['request'] : null;
          if (order['captainTrack'] == 'pickup_pending' ||
              (request is Map && request['status'] == 'open')) {
            return const ReportWhilePickupOpen();
          }
          if (order['itemReport'] != null) return const ItemReportOpenFirst();
          return const StateChanged();
        }
        if ((kind == CommandKind.accept || kind == CommandKind.reject) &&
            order['acceptance'] is Map) {
          final acceptance = order['acceptance'] as Map;
          if (acceptance['byOperations'] == true) {
            return const AcceptedByOperationsFirst();
          }
          return AcceptedElsewhere(acceptance['deviceName'] as String?);
        }
        final pickup = order['pickup'];
        final request = pickup is Map ? pickup['request'] : null;
        if (kind != CommandKind.accept &&
            kind != CommandKind.ready &&
            kind != CommandKind.reject &&
            request is Map &&
            request['status'] != 'open') {
          return PickupAnsweredElsewhere(
            request['outcome'] as String?,
            request['closedByUserName'] as String?,
          );
        }
        return const StateChanged();
      default:
        return const CommandFailed();
    }
  }
}

final boardCommandsProvider = NotifierProvider<BoardCommands, Set<String>>(
  BoardCommands.new,
);
