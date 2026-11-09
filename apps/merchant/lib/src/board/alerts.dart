import 'dart:async';

import 'package:core_realtime/core_realtime.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

import '../api.dart';
import 'board.dart';
import 'commands.dart';

/// The sounds of RA §4.4. Until the design's bundled sounds (owner decision
/// 2026-11-07), the ring is the phone's alarm sound, looping on the alarm
/// stream so the media volume and silent mode do not mute it, and the chime
/// is the phone's notification sound.
abstract interface class Ringer {
  void ring();
  void stop();
  void chime();
}

/// The phone's sounds through `flutter_ringtone_player` (Android). Windows
/// has no player yet, so the calls do nothing there.
///
/// The plugin loops only on Android 9 and later, and the system may stop a
/// sound (a call, another app taking the audio), so while ringing the alarm
/// is started again every [replayEvery]; the stand-in sounds go with the
/// bundled ones and `core_alerts` (architecture §12.2).
class PhoneRinger implements Ringer {
  PhoneRinger({this.replayEvery = const Duration(seconds: 10)});

  final Duration replayEvery;
  final _player = FlutterRingtonePlayer();
  Timer? _replay;

  bool get _supported => defaultTargetPlatform == TargetPlatform.android;

  void _play() => unawaited(_player.playAlarm(looping: true, asAlarm: true));

  @override
  void ring() {
    if (!_supported || _replay != null) return;
    _play();
    _replay = Timer.periodic(replayEvery, (_) => _play());
  }

  @override
  void stop() {
    if (!_supported || _replay == null) return;
    _replay?.cancel();
    _replay = null;
    unawaited(_player.stop());
  }

  @override
  void chime() {
    // One player: a chime would end the ring, which is louder anyway.
    if (!_supported || _replay != null) return;
    unawaited(_player.playNotification());
  }
}

final ringerProvider = Provider<Ringer>((ref) => PhoneRinger());

/// A message the board shows with a chime (RA §8.3, §8.7, §8.9, §8.10).
sealed class BoardNotice {
  const BoardNotice();
}

/// «أُلغي الطلب #{رقم} لعدم الرد».
class AutoCancelled extends BoardNotice {
  const AutoCancelled(this.number);
  final String number;
}

/// «ألغى الزبون الطلب #{رقم}»: the customer cancelled while placed (RA §8.3,
/// §16 #4).
class CustomerCancelled extends BoardNotice {
  const CustomerCancelled(this.number);
  final String number;
}

/// «أُلغي الطلب #{رقم}»: another cancellation, whose prompts come with their
/// slices (RA §8.14).
class Cancelled extends BoardNotice {
  const Cancelled(this.number);
  final String number;
}

/// «قبلت العمليات الطلب #{رقم} نيابة عنكم — وقت التحضير {د} د» (RA §8.15,
/// §16 #5).
class AcceptedByOperations extends BoardNotice {
  const AcceptedByOperations(this.number, this.prepMin);
  final String number;
  final int prepMin;
}

/// «رفضت العمليات الطلب #{رقم}: {السبب}» (RA §8.15, §16 #6), with the
/// reason's code.
class RejectedByOperations extends BoardNotice {
  const RejectedByOperations(this.number, this.reason);
  final String number;
  final String reason;
}

/// «تحضير متأخر #{رقم} — اضغط «الطلب جاهز» فور الانتهاء».
class PrepLate extends BoardNotice {
  const PrepLate(this.number);
  final String number;
}

/// «وصل الكابتن {الاسم} لاستلام الطلب #{رقم}».
class CaptainArrived extends BoardNotice {
  const CaptainArrived(this.name, this.number);
  final String name;
  final String number;
}

/// «الكابتن ينتظر الطلب #{رقم} منذ {د} دقائق».
class CaptainKeptWaiting extends BoardNotice {
  const CaptainKeptWaiting(this.number, this.minutes);
  final String number;
  final int minutes;
}

/// The pickup prompt closed on this device because another one answered:
/// «أكّد {اسم المستخدم} الاستلام» or «أبلغ {اسم المستخدم} أن المبلغ غير
/// صحيح» (RA §8.10), or automatically.
class PickupClosed extends BoardNotice {
  const PickupClosed(this.number, this.outcome, this.userName);
  final String number;
  final PickupOutcome? outcome;
  final String? userName;
}

/// RA §4.7: 30 seconds offline (fixed) plays one chime.
const offlineChimeAfter = Duration(seconds: 30);

/// RA §8.7: the late-prep chime repeats every 5 minutes (fixed).
const prepLateRepeat = Duration(minutes: 5);

/// What the alerts remember between steps, so each chime plays once.
class AlertMemory {
  Board? board;
  final Map<String, int> prepLateChimes = {};
  final Set<String> waitingChimed = {};
  DateTime? offlineSince;
  bool offlineChimed = false;
}

/// One step's result: whether to ring, and the chimes with their notices.
class AlertStep {
  const AlertStep({
    required this.ring,
    this.notices = const [],
    this.chime = false,
  });
  final bool ring;
  final List<BoardNotice> notices;
  final bool chime;
}

/// The alert rules of RA §4.4, §4.7, §8.3, §8.7, §8.9 and §8.10 as a pure
/// step over the latest board, the new events and the server time.
AlertStep alertStep(
  AlertMemory memory, {
  required LiveState<Board> state,
  required List<Map<String, Object?>> events,
  required DateTime now,
  Set<String> answeredHere = const {},
}) {
  final notices = <BoardNotice>[];
  var chime = false;

  // The connection: one chime after 30 seconds without it.
  if (state.live) {
    memory
      ..offlineSince = null
      ..offlineChimed = false;
  } else {
    memory.offlineSince ??= now;
    if (!memory.offlineChimed &&
        now.difference(memory.offlineSince!) >= offlineChimeAfter) {
      memory.offlineChimed = true;
      chime = true;
    }
  }

  final board = state.value;
  for (final event in events) {
    final number = '${event['number']}';
    switch (event['type']) {
      // Operations' cancellation after acceptance rings with its own prompt
      // (RA §8.14); one of a placed order keeps its chime.
      case 'order.cancelled'
          when event['byOperations'] == true &&
              (board?.orders.any(
                    (o) =>
                        o.id == event['orderId'] &&
                        o.status == OrderStatus.cancelled &&
                        o.cancellation != null,
                  ) ??
                  false):
        break;
      case 'order.cancelled':
        notices.add(
          event['reason'] == 'merchant_auto_cancel'
              ? AutoCancelled(number)
              : event['byCustomer'] == true
              ? CustomerCancelled(number)
              : Cancelled(number),
        );
      // RA §8.15: operations decided for the restaurant; the restaurant's own
      // decisions on another device only close the prompt.
      case 'order.rejected' when event['byOperations'] == true:
        notices.add(RejectedByOperations(number, '${event['reason']}'));
      case 'order.accepted' when event['byOperations'] == true:
        // The event carries no prep time: the board fetched after it does.
        final order = board?.orders
            .where((o) => o.id == event['orderId'])
            .firstOrNull;
        final prepMin = order?.acceptance?.prepMin;
        if (prepMin != null) {
          notices.add(AcceptedByOperations(number, prepMin));
        }
    }
  }

  if (board == null) {
    return AlertStep(
      ring: false,
      notices: notices,
      chime: chime || notices.isNotEmpty,
    );
  }
  final before = {
    for (final o in memory.board?.orders ?? <BoardOrder>[]) o.id: o,
  };
  for (final order in board.orders) {
    final previous = before[order.id];
    // Captain arrived: the arrival appeared since the last board. A
    // cancelled order has no captain waiting for it (RA §8.9, §8.14).
    final arrival = order.status == OrderStatus.cancelled
        ? null
        : order.captainArrival;
    if (memory.board != null &&
        previous != null &&
        previous.captainArrival == null &&
        arrival != null) {
      notices.add(CaptainArrived(order.captain?.firstName ?? '', order.number));
    }
    // Captain waiting past captain.waiting_threshold_min, once.
    if (arrival != null &&
        !now.isBefore(arrival.waitingAlertAt) &&
        memory.waitingChimed.add(order.id)) {
      notices.add(
        CaptainKeptWaiting(order.number, now.difference(arrival.at).inMinutes),
      );
    }
    // Prep late: at the prep time, then every 5 minutes while accepted.
    final acceptance = order.acceptance;
    if (order.status == OrderStatus.accepted &&
        acceptance != null &&
        !now.isBefore(acceptance.prepDueAt)) {
      final slot =
          now.difference(acceptance.prepDueAt).inMicroseconds ~/
          prepLateRepeat.inMicroseconds;
      if ((memory.prepLateChimes[order.id] ?? -1) < slot) {
        memory.prepLateChimes[order.id] = slot;
        notices.add(PrepLate(order.number));
      }
    }
    // A pickup prompt closed by another device's answer.
    final request = order.pickup.request;
    final was = previous?.pickup.request;
    // A request the cancellation voided closes with the cancellation's own
    // prompt or chime.
    if (order.status != OrderStatus.cancelled &&
        was != null &&
        request != null &&
        was.id == request.id &&
        was.status == PickupRequestStatus.open &&
        request.status != PickupRequestStatus.open &&
        !answeredHere.contains(request.id)) {
      notices.add(
        PickupClosed(order.number, request.outcome, request.closedByUserName),
      );
    }
  }
  memory.board = board;
  return AlertStep(
    ring: ringing(board).isNotEmpty,
    notices: notices,
    chime: chime || notices.isNotEmpty,
  );
}

/// The notices the screen shows, newest last.
class BoardNotices extends Notifier<List<BoardNotice>> {
  @override
  List<BoardNotice> build() => const [];

  void post(List<BoardNotice> notices) {
    if (notices.isNotEmpty) state = notices;
  }
}

final boardNoticesProvider = NotifierProvider<BoardNotices, List<BoardNotice>>(
  BoardNotices.new,
);

/// How long past a ringing item's deadline (the automatic cancellation, the
/// automatic pickup confirmation) the board is fetched again, in case the
/// event that ends it was lost (RA §4.4: the ring stops when its condition
/// ends).
const ringDeadlineGrace = Duration(seconds: 3);

/// Runs [alertStep] on every board and every second while the board is
/// open, and drives the ringer (RA §4.4: the ring stops on every device once
/// any device handles it, since each device's board no longer shows it).
/// Events wait for the board fetched after them, so a cancellation's chime
/// plays once its prompt has closed.
final boardAlertsProvider = Provider.autoDispose<void>((ref) {
  final feed = ref.watch(boardFeedProvider);
  if (feed == null) return;
  final ringer = ref.watch(ringerProvider);
  final clock = ref.watch(serverClockProvider);
  final memory = AlertMemory();
  final pending = <Map<String, Object?>>[];
  final refetchedFor = <String>{};

  void step({required bool fresh}) {
    final state = feed.state;
    final take = fresh && !state.failed;
    final now = clock.now();
    final result = alertStep(
      memory,
      state: state,
      events: take ? [...pending] : const [],
      now: now,
      answeredHere: ref.read(boardCommandsProvider.notifier).answeredHere,
    );
    if (take) pending.clear();
    if (result.ring) {
      ringer.ring();
    } else {
      ringer.stop();
    }
    if (result.chime) ringer.chime();
    ref.read(boardNoticesProvider.notifier).post(result.notices);
    final board = state.value;
    if (board == null) return;
    for (final item in ringing(board)) {
      final deadline = switch (item) {
        NewOrderRinging(:final order) => order.autoCancelAt,
        PickupRinging(:final request) => request.confirmBy,
        // Only «حسناً» ends it, on this device or another one.
        CancelledRinging() => null,
      };
      final key = switch (item) {
        NewOrderRinging(:final order) => order.id,
        PickupRinging(:final request) => request.id,
        CancelledRinging(:final order) => 'cancelled-${order.id}',
      };
      if (deadline != null &&
          now.isAfter(deadline.add(ringDeadlineGrace)) &&
          refetchedFor.add(key)) {
        unawaited(feed.refresh());
      }
    }
  }

  final subscriptions = [
    feed.states.listen((_) => step(fresh: true)),
    feed.events.listen(pending.add),
  ];
  final ticker = Timer.periodic(
    const Duration(seconds: 1),
    (_) => step(fresh: false),
  );
  ref.onDispose(() {
    ticker.cancel();
    for (final s in subscriptions) {
      unawaited(s.cancel());
    }
    ringer.stop();
  });
});
