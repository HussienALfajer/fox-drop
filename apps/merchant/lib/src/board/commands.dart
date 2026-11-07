import 'dart:async';
import 'dart:math';

import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import 'board.dart';

/// A board command (RA §8.5, §8.8, §8.10).
enum CommandKind { accept, ready, confirmPickup, disputePickup, incomplete }

/// What the screen says after a command, when it says anything.
sealed class CommandNotice {
  const CommandNotice();
}

/// «قُبل الطلب من جهاز {اسم الجهاز}» (RA §4.7).
class AcceptedElsewhere extends CommandNotice {
  const AcceptedElsewhere(this.deviceName);
  final String? deviceName;
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

  Future<CommandNotice?> ready(String orderId) => _send(
    orderId,
    CommandKind.ready,
    '',
    (key) => _api.merchantOrdersReady(orderId: orderId, idempotencyKey: key),
  );

  Future<CommandNotice?> confirmPickup(String orderId, String requestId) {
    answeredHere.add(requestId);
    return _send(
      orderId,
      CommandKind.confirmPickup,
      requestId,
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
    if (requestId != null) answeredHere.add(requestId);
    return _send(
      orderId,
      CommandKind.disputePickup,
      '$requestId ${received.map((l) => '${l.amount} ${l.currency}').join(',')}',
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
    answeredHere.add(requestId);
    return _send(
      orderId,
      CommandKind.incomplete,
      requestId,
      (key) => _api.merchantOrdersPickupIncomplete(
        orderId: orderId,
        idempotencyKey: key,
      ),
    );
  }

  // One command at a time per order. Its key belongs to the command's body:
  // a lost answer sends the same key again until the server answers (RA
  // §4.7), and an answered command drops it.
  Future<CommandNotice?> _send(
    String orderId,
    CommandKind kind,
    String body,
    Future<Object?> Function(String key) call,
  ) async {
    if (state.contains(orderId)) return null;
    state = {...state, orderId};
    final command = '$orderId ${kind.name} $body';
    final key = _keys[command] ??= uuidV4();
    try {
      for (var attempt = 0; ; attempt++) {
        try {
          await call(key);
          return null;
        } on DioException catch (error) {
          final answer = error.response;
          if (answer != null && (answer.statusCode ?? 0) < 500) {
            return _refused(kind, answer);
          }
          if (!ref.mounted) return null;
          await Future<void>.delayed(backoff(attempt));
          if (!ref.mounted) return null;
        }
      }
    } finally {
      _keys.remove(command);
      if (ref.mounted) {
        state = {...state}..remove(orderId);
        unawaited(ref.read(boardFeedProvider)?.refresh());
      }
    }
  }

  CommandNotice _refused(CommandKind kind, Response<Object?> answer) {
    final body = answer.data;
    final error = body is Map ? body['error'] : null;
    final order = body is Map ? body['order'] : null;
    switch (error) {
      case 'invalid_lines' || 'currency_not_accepted':
        return const LinesRefused();
      case 'pickup_already_disputed':
        return const AlreadyDisputed();
      case 'order_state_changed':
        if (order is! Map) return const StateChanged();
        final status = order['status'];
        if (status == 'cancelled') return const CancelledFirst();
        if (kind == CommandKind.accept && order['acceptance'] is Map) {
          final acceptance = order['acceptance'] as Map;
          return AcceptedElsewhere(acceptance['deviceName'] as String?);
        }
        final pickup = order['pickup'];
        final request = pickup is Map ? pickup['request'] : null;
        if (kind != CommandKind.accept &&
            kind != CommandKind.ready &&
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
