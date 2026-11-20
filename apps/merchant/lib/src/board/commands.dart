import 'dart:async';

import 'package:core_api/core_api.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_auth/core_auth.dart';
import 'package:core_commands/core_commands.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../device.dart';
import '../push.dart';
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
  acknowledgeEdit,
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
/// cannot be pressed again (RA §4.7). Every command waits in the device's
/// queue (`core_commands`) until the server answers, so one sent before a
/// restart, a crash or the system ending the app is sent again with its key
/// when the app starts (architecture §11.2).
class BoardCommands extends Notifier<Set<String>> {
  /// The pickup requests this device answered, whose closing it does not
  /// announce as another user's.
  final Set<String> answeredHere = {};

  /// Waits before each retry; tests make it short.
  Duration Function(int attempt) backoff = retryDelay;

  String? _resumedFor;

  @override
  Set<String> build() {
    // RA §4.7: the commands a restart interrupted go again, for the account
    // signed in now; another account's are dropped.
    ref.listen(merchantSessionProvider, (previous, next) {
      final accountId = next.value?.accountId;
      if (accountId != null && accountId != _resumedFor) {
        _resumedFor = accountId;
        unawaited(_resume(accountId));
      }
    }, fireImmediately: true);
    return const {};
  }

  MerchantApi get _api => ref.read(coreApiProvider).getMerchantApi();
  CommandQueue get _queue => ref.read(commandQueueProvider);

  Future<CommandNotice?> accept(String orderId, int prepMin) =>
      _send(orderId, CommandKind.accept, {'prepMin': prepMin});

  /// «رفض» with its reason and steps (RA §8.6).
  Future<CommandNotice?> reject(String orderId, Rejection rejection) =>
      _send(orderId, CommandKind.reject, {
        'reason': rejection.reason.code,
        'items': rejection.items,
        'busyExtraMin': switch (rejection.step) {
          BusyModeStep(:final extraMin) => extraMin,
          _ => null,
        },
        'pauseMin': rejection.step is PauseStep ? tooBusyPauseMin : null,
      });

  Future<CommandNotice?> ready(String orderId) =>
      _send(orderId, CommandKind.ready, const {});

  Future<CommandNotice?> confirmPickup(String orderId, String requestId) =>
      _send(orderId, CommandKind.confirmPickup, {'requestId': requestId});

  /// «المبلغ غير صحيح» with what the restaurant received, before or after
  /// the pickup (RA §8.10 items 6 and 8).
  Future<CommandNotice?> disputePickup(
    String orderId,
    String? requestId,
    List<({String amount, String currency})> received,
  ) => _send(orderId, CommandKind.disputePickup, {
    'requestId': requestId,
    'lines': [
      for (final line in received)
        {'amount': line.amount, 'currency': line.currency},
    ],
  });

  /// «الطلب غير مكتمل» (RA §8.10 item 7).
  Future<CommandNotice?> incomplete(String orderId, String requestId) =>
      _send(orderId, CommandKind.incomplete, {'requestId': requestId});

  /// «حسناً» on operations' cancellation after acceptance (RA §8.14, §18):
  /// every device's board drops the order, so the ring stops on all.
  Future<CommandNotice?> acknowledgeCancellation(String orderId) =>
      _send(orderId, CommandKind.acknowledgeCancellation, const {});

  /// «اطلعت على التعديل» (RA §8.13): the edits up to the newest one the
  /// prompt showed ([through]); the ring stops on every device and the
  /// captain's pickup is free, while a newer edit keeps ringing.
  Future<CommandNotice?> acknowledgeEdit(String orderId, DateTime through) =>
      _send(orderId, CommandKind.acknowledgeEdit, {
        'through': through.toUtc().toIso8601String(),
      });

  /// «صنف غير متوفر — اتصلوا بالزبون» (RA §8.12).
  Future<CommandNotice?> reportItems(String orderId, ItemReport report) =>
      _send(orderId, CommandKind.reportItems, {
        'items': report.items,
        'note': report.note,
      });

  /// «تراجع — الصنف متوفر»: the items come back on (RA §8.12).
  Future<CommandNotice?> withdrawItemReport(String orderId) =>
      _send(orderId, CommandKind.withdrawItemReport, const {});

  // The call of a command from what the queue keeps of it.
  Future<Object?> _call(
    CommandKind kind,
    String orderId,
    Map<String, Object?> args,
    String key,
  ) {
    List<MerchantRejectDtoItemsInner> items() => [
      for (final entry in (args['items']! as Map).cast<String, bool>().entries)
        MerchantRejectDtoItemsInner(
          (i) => i
            ..itemId = entry.key
            ..until = entry.value
                ? MerchantRejectDtoItemsInnerUntilEnum.tomorrow
                : MerchantRejectDtoItemsInnerUntilEnum.turnedBackOn,
        ),
    ];
    return switch (kind) {
      CommandKind.accept => _api.merchantOrdersAccept(
        orderId: orderId,
        idempotencyKey: key,
        merchantAcceptDto: MerchantAcceptDto(
          (b) => b..prepMin = args['prepMin']! as int,
        ),
      ),
      CommandKind.reject => _api.merchantOrdersReject(
        orderId: orderId,
        idempotencyKey: key,
        merchantRejectDto: MerchantRejectDto(
          (b) => b
            ..reason = args['reason']! as String
            ..items = ListBuilder(items())
            ..busyExtraMin = args['busyExtraMin'] as int?
            ..pauseMin = args['pauseMin'] as int?,
        ),
      ),
      CommandKind.ready => _api.merchantOrdersReady(
        orderId: orderId,
        idempotencyKey: key,
      ),
      CommandKind.confirmPickup => _api.merchantOrdersConfirmPickup(
        orderId: orderId,
        idempotencyKey: key,
      ),
      CommandKind.disputePickup => _api.merchantOrdersDisputePickup(
        orderId: orderId,
        idempotencyKey: key,
        merchantPickupDisputeDto: MerchantPickupDisputeDto(
          (b) => b.receivedLines.addAll([
            for (final line
                in (args['lines']! as List).cast<Map<String, Object?>>())
              MerchantPickupDisputeDtoReceivedLinesInner(
                (l) => l
                  ..amount = line['amount'] as String
                  ..currency = line['currency'] as String,
              ),
          ]),
        ),
      ),
      CommandKind.incomplete => _api.merchantOrdersPickupIncomplete(
        orderId: orderId,
        idempotencyKey: key,
      ),
      CommandKind.acknowledgeCancellation =>
        _api.merchantOrdersAcknowledgeCancellation(
          orderId: orderId,
          idempotencyKey: key,
        ),
      CommandKind.acknowledgeEdit => _api.merchantOrdersAcknowledgeEdit(
        orderId: orderId,
        idempotencyKey: key,
        merchantAcknowledgeEditDto: MerchantAcknowledgeEditDto(
          (b) => b..through = DateTime.parse(args['through']! as String),
        ),
      ),
      CommandKind.reportItems => _api.merchantOrdersReportItems(
        orderId: orderId,
        idempotencyKey: key,
        merchantItemReportDto: MerchantItemReportDto(
          (b) => b
            ..items = ListBuilder(items())
            ..note = args['note'] as String?,
        ),
      ),
      CommandKind.withdrawItemReport => _api.merchantOrdersWithdrawItemReport(
        orderId: orderId,
        idempotencyKey: key,
      ),
    };
  }

  // One command at a time per order. Its key belongs to the command and its
  // arguments: kept in the queue until the server answers, a call without an
  // answer (none, a 5xx, a 408 or a 429) is sent again with the same key
  // after a backoff (RA §4.7), and an answered command leaves the queue.
  Future<CommandNotice?> _send(
    String orderId,
    CommandKind kind,
    Map<String, Object?> args,
  ) async {
    if (state.contains(orderId)) return null;
    final accountId = ref.read(merchantSessionProvider).value?.accountId;
    if (accountId == null) return const CommandFailed();
    state = {...state, orderId};
    final queued = QueuedCommand(
      key: uuidV4(),
      kind: kind.name,
      subject: orderId,
      accountId: accountId,
      args: args,
      queuedAt: DateTime.now().toUtc(),
    );
    final same = (await _queue.pending(
      DateTime.now().toUtc(),
    )).where((each) => each.identity == queued.identity).firstOrNull;
    return _drive(same ?? queued);
  }

  // [answers] (a pickup command's request) is marked while it is sent and
  // kept unless refused, so this device does not announce its own answer as
  // another user's.
  Future<CommandNotice?> _drive(QueuedCommand command) async {
    final kind = CommandKind.values.byName(command.kind);
    final orderId = command.subject;
    final answers = command.args['requestId'] as String?;
    if (answers != null) answeredHere.add(answers);
    await _queue.put(command);
    try {
      for (var attempt = 0; ; attempt++) {
        try {
          await _call(kind, orderId, command.args, command.key);
          await _queue.remove(command.key);
          return null;
        } on DioException catch (error) {
          final answer = error.response;
          if (answer != null && !unanswered(answer.statusCode)) {
            // Another device or the server answered first.
            await _queue.remove(command.key);
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
      await _queue.remove(command.key);
      return const CommandFailed();
    } finally {
      if (ref.mounted) {
        state = {...state}..remove(orderId);
        if (ref.exists(boardFeedProvider)) {
          unawaited(ref.read(boardFeedProvider)?.refresh());
        }
      }
    }
  }

  // The queue's commands of the account signed in, each sent again as the
  // board's own; the board fetched after each answer shows its outcome.
  Future<void> _resume(String accountId) async {
    final pending = await _queue.pending(DateTime.now().toUtc());
    for (final command in pending) {
      if (command.accountId != accountId ||
          !CommandKind.values.any((kind) => kind.name == command.kind)) {
        await _queue.remove(command.key);
        continue;
      }
      if (state.contains(command.subject)) continue;
      state = {...state, command.subject};
      unawaited(_drive(command));
    }
  }

  CommandNotice? _refused(CommandKind kind, Response<Object?> answer) {
    // The order no longer waits for «حسناً»: the board fetched after the
    // answer drops it, with nothing to explain.
    // Or another device acknowledged the edits first: the board fetched
    // after the answer shows none.
    if ((kind == CommandKind.acknowledgeCancellation ||
            kind == CommandKind.acknowledgeEdit) &&
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

/// The device's command queue (architecture §11.2).
final commandQueueProvider = Provider<CommandQueue>(
  (ref) => CommandQueue(ref.watch(deviceStoreProvider)),
);

final boardCommandsProvider = NotifierProvider<BoardCommands, Set<String>>(
  BoardCommands.new,
);
