import 'dart:async';

import 'package:core_api/core_api.dart';
import 'package:core_realtime/core_realtime.dart';
import 'package:core_time/core_time.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../board/alerts.dart';
import '../device.dart';

typedef Status = MerchantStatusDtoOutput;
typedef StatusState = MerchantStatusDtoOutputStateEnum;
typedef PauseSource = MerchantStatusDtoOutputPauseSourceEnum;

/// The status pill (RA §6.2, §7.1): the state as the restaurant sees it.
enum StatusPill {
  open,
  busyMode,
  busy,
  paused,
  pausedByOperations,
  autoPaused,
  closed,
  holiday,
  suspended,
  inactive,
}

StatusPill statusPill(Status status) => switch (status.state) {
  StatusState.open =>
    status.busyMode == null ? StatusPill.open : StatusPill.busyMode,
  StatusState.busy => StatusPill.busy,
  StatusState.paused => switch (status.pauseSource) {
    PauseSource.ops => StatusPill.pausedByOperations,
    PauseSource.auto => StatusPill.autoPaused,
    _ => StatusPill.paused,
  },
  StatusState.closed => StatusPill.closed,
  StatusState.holiday => StatusPill.holiday,
  StatusState.suspended => StatusPill.suspended,
  _ => StatusPill.inactive,
};

/// The status banners of RA §6.3, highest first: item 3 (paused by
/// operations or the auto-pause; the suspension's own banner is RA §5.5's)
/// and item 6 (the active-orders limit, or busy mode on).
enum StatusBanner { pausedByOperations, limitReached, busyMode }

List<StatusBanner> statusBanners(Status status) => [
  if (status.state == StatusState.paused &&
      status.pauseSource != PauseSource.restaurant)
    StatusBanner.pausedByOperations,
  if (status.state == StatusState.busy) StatusBanner.limitReached,
  if (status.busyMode != null &&
      (status.state == StatusState.open || status.state == StatusState.busy))
    StatusBanner.busyMode,
];

/// What the status sheet allows (RA §7.2, §18): pausing while open or busy,
/// or over the restaurant's own pause to change its length; resuming its own
/// pause; busy mode while open. Operations' pause and the auto-pause lock
/// every button.
class SheetActions {
  const SheetActions({
    required this.pause,
    required this.resume,
    required this.busyModeOn,
    required this.busyModeOff,
    required this.lockedByOperations,
  });

  final bool pause;
  final bool resume;
  final bool busyModeOn;
  final bool busyModeOff;
  final bool lockedByOperations;
}

SheetActions sheetActions(Status status) {
  final locked =
      status.state == StatusState.paused &&
      status.pauseSource != PauseSource.restaurant;
  final open =
      status.state == StatusState.open || status.state == StatusState.busy;
  final ownPause =
      status.state == StatusState.paused &&
      status.pauseSource == PauseSource.restaurant;
  return SheetActions(
    pause: !locked && (open || ownPause),
    resume: ownPause,
    busyModeOn: open,
    busyModeOff: !locked && status.busyMode != null,
    lockedByOperations: locked,
  );
}

/// The next moment the status changes on its own (a pause or holiday close
/// ending, the schedule opening or closing, busy mode ending, a holiday
/// close starting), when the app reads it again; null when none is ahead.
DateTime? nextChange(Status status, DateTime now) {
  final moments = [
    status.stateUntil,
    status.closesAt,
    status.opensAt,
    status.busyMode?.until,
    status.holiday?.startsAt,
    status.holiday?.endsAt,
  ].whereType<DateTime>().where((at) => at.isAfter(now)).toList()..sort();
  return moments.isEmpty ? null : moments.first;
}

/// The state changes that chime with a notice on every device (RA §16 #3, #23,
/// #24, #25), as the server's relay names them, with their values.
sealed class StatusNotice {
  const StatusNotice();
}

/// #3: paused after [count] unanswered orders of the day.
class AutoPaused extends StatusNotice {
  const AutoPaused(this.count);
  final int count;
}

/// #24: a timed pause ended and the restaurant takes orders again.
class PauseEnded extends StatusNotice {
  const PauseEnded();
}

/// #25: busy mode still adds [minutes].
class BusyReminder extends StatusNotice {
  const BusyReminder(this.minutes);
  final int minutes;
}

/// #23: operations paused the restaurant, with their [reason].
class PausedByOperations extends StatusNotice {
  const PausedByOperations(this.reason);
  final String reason;
}

/// #23: operations resumed the restaurant.
class ResumedByOperations extends StatusNotice {
  const ResumedByOperations();
}

/// #23: operations ended busy mode.
class BusyEndedByOperations extends StatusNotice {
  const BusyEndedByOperations();
}

StatusNotice? statusNotice(Map<String, Object?> publication) {
  if (publication['type'] != 'restaurant.state_changed') return null;
  final values = publication['values'];
  final of = values is Map ? values : const <Object?, Object?>{};
  return switch (publication['kind']) {
    'auto_paused' => AutoPaused(of['count'] is int ? of['count'] as int : 0),
    // A pause that ended with the opening period leaves it closed: silent.
    'pause_ended' when of['push'] == true => const PauseEnded(),
    'busy_reminder' => BusyReminder(
      of['extraMin'] is int ? of['extraMin'] as int : 0,
    ),
    'paused_by_operations' => PausedByOperations(
      of['reason'] is String ? of['reason'] as String : '',
    ),
    'resumed_by_operations' => const ResumedByOperations(),
    'busy_ended_by_operations' => const BusyEndedByOperations(),
    _ => null,
  };
}

/// The restaurant's status kept current (RA §7, §18), as `LiveFeed` keeps the
/// board: the state shown is always one the server answered. It reads
/// `GET /v1/merchant/restaurant/status` at start, after a subscription that
/// did not recover, on every `restaurant.state_changed`, on order events
/// while a maximum counts the active orders (RA §7.4), at the next moment
/// the status changes on its own (on the server's clock), and every
/// [pollEvery] while the channel is down or the latest read failed.
class StatusFeed {
  StatusFeed({
    required this.transport,
    required this.channel,
    required this.fetch,
    required this.clock,
    this.pollEvery = const Duration(seconds: 30),
  });

  final RealtimeTransport transport;
  final String channel;
  final Future<Status> Function() fetch;
  final ServerClock clock;
  final Duration pollEvery;

  final _states = StreamController<LiveState<Status>>.broadcast();
  final _notices = StreamController<StatusNotice>.broadcast();
  LiveState<Status> _state = const LiveState<Status>();
  StreamSubscription<RealtimeSignal>? _signals;
  Timer? _poll;
  Timer? _change;
  Future<void>? _fetching;
  bool _again = false;
  bool _closed = false;

  LiveState<Status> get state => _state;

  /// The chimes' notices, as the events arrive.
  Stream<StatusNotice> get notices => _notices.stream;

  /// The current state, then every new one, with no gap between them.
  Stream<LiveState<Status>> watch() {
    late StreamController<LiveState<Status>> controller;
    StreamSubscription<LiveState<Status>>? subscription;
    controller = StreamController<LiveState<Status>>(
      onListen: () {
        subscription = _states.stream.listen(
          controller.add,
          onDone: controller.close,
        );
        controller.add(_state);
      },
      onCancel: () => subscription?.cancel(),
    );
    return controller.stream;
  }

  void start() {
    if (_signals != null || _closed) return;
    _signals = transport.channel(channel).listen(_onSignal);
    _schedulePoll();
    unawaited(refresh());
  }

  /// Reads the status now, as after a command's answer. Calls while a read
  /// runs make one more read after it.
  Future<void> refresh() {
    final running = _fetching;
    if (running != null) {
      _again = true;
      return running;
    }
    return _fetching = _run();
  }

  /// A command answered the status: shown at once, as a read would.
  void answered(Status status) {
    if (_closed) return;
    _emit(LiveState(value: status, live: _state.live));
  }

  Future<void> _run() async {
    do {
      _again = false;
      try {
        final value = await fetch();
        if (_closed) return;
        _emit(LiveState(value: value, live: _state.live));
      } on Object {
        if (_closed) return;
        _emit(LiveState(value: _state.value, live: _state.live, failed: true));
      }
    } while (_again && !_closed);
    _fetching = null;
    _schedulePoll();
  }

  void _onSignal(RealtimeSignal signal) {
    switch (signal) {
      case RealtimeUp(:final recovered):
        _emit(
          LiveState(value: _state.value, live: true, failed: _state.failed),
        );
        _schedulePoll();
        if (!recovered) unawaited(refresh());
      case RealtimeDown():
        if (!_state.live) return;
        _emit(
          LiveState(value: _state.value, live: false, failed: _state.failed),
        );
        _schedulePoll();
      case RealtimePublication(:final data):
        if (data['type'] == 'restaurant.state_changed') {
          if (statusNotice(data) case final notice?) _notices.add(notice);
          unawaited(refresh());
        } else if (data['orderId'] is String &&
            _state.value?.maxActiveOrders != null) {
          unawaited(refresh());
        }
    }
  }

  void _schedulePoll() {
    _poll?.cancel();
    _poll = null;
    if (_closed || (_state.live && !_state.failed)) return;
    _poll = Timer(pollEvery, () => unawaited(refresh()));
  }

  void _scheduleChange() {
    _change?.cancel();
    _change = null;
    final status = _state.value;
    if (_closed || status == null) return;
    final now = clock.now();
    final at = nextChange(status, now);
    if (at == null) return;
    // A second after the moment, so the server has passed it too.
    _change = Timer(
      at.difference(now) + const Duration(seconds: 1),
      () => unawaited(refresh()),
    );
  }

  void _emit(LiveState<Status> next) {
    final changed = !identical(next.value, _state.value);
    _state = next;
    _states.add(next);
    if (changed) _scheduleChange();
  }

  Future<void> close() async {
    _closed = true;
    _poll?.cancel();
    _change?.cancel();
    await _signals?.cancel();
    await _states.close();
    await _notices.close();
  }
}

final statusFeedProvider = Provider.autoDispose<StatusFeed?>((ref) {
  final restaurantId = ref.watch(
    merchantSessionProvider.select((s) => s.value?.restaurantId),
  );
  if (restaurantId == null) return null;
  final api = ref.watch(coreApiProvider).getMerchantApi();
  final feed = StatusFeed(
    transport: ref.watch(realtimeTransportProvider),
    channel: 'merchant:$restaurantId',
    fetch: () async => (await api.merchantStatusRead()).data!,
    clock: ref.watch(serverClockProvider),
  );
  feed.start();
  ref.onDispose(feed.close);
  return feed;
});

final statusProvider = StreamProvider.autoDispose<LiveState<Status>>((ref) {
  final feed = ref.watch(statusFeedProvider);
  if (feed == null) return const Stream.empty();
  return feed.watch();
});

/// The latest notice to show, posted by [statusChimesProvider].
class StatusNotices extends Notifier<StatusNotice?> {
  @override
  StatusNotice? build() => null;

  void post(StatusNotice notice) => state = notice;
}

final statusNoticesProvider = NotifierProvider<StatusNotices, StatusNotice?>(
  StatusNotices.new,
);

/// RA §16 #3, #23, #24, #25: each of these changes chimes once on every device
/// while the app runs, with its notice; the push covers a closed app.
/// Watched by `MerchantApp`.
final statusChimesProvider = Provider.autoDispose<void>((ref) {
  final feed = ref.watch(statusFeedProvider);
  if (feed == null) return;
  final ringer = ref.watch(ringerProvider);
  final notices = feed.notices.listen((notice) {
    ringer.chime();
    ref.read(statusNoticesProvider.notifier).post(notice);
  });
  ref.onDispose(() => unawaited(notices.cancel()));
});

/// Why the server refused a status command, for the sheet's message.
enum StatusRefusal { closed, pausedByOperations, other }

/// The status sheet's commands (RA §7.2): each sets a state, so a repeat is
/// harmless; each answer is the status after it.
class StatusCommands {
  StatusCommands(this._api, this._feed);

  final MerchantApi _api;
  final StatusFeed? _feed;

  Future<StatusRefusal?> pause(int? minutes) => _run(
    () => _api.merchantStatusPause(
      merchantPauseDto: MerchantPauseDto((b) => b..minutes = minutes),
    ),
  );

  Future<StatusRefusal?> resume() => _run(_api.merchantStatusResume);

  Future<StatusRefusal?> busyMode(int? extraMin) => _run(
    () => _api.merchantStatusBusyMode(
      merchantBusyModeDto: MerchantBusyModeDto((b) => b..extraMin = extraMin),
    ),
  );

  Future<StatusRefusal?> _run(Future<Response<Status>> Function() call) async {
    try {
      final answer = await call();
      _feed?.answered(answer.data!);
      return null;
    } on DioException catch (error) {
      unawaited(_feed?.refresh());
      final body = error.response?.data;
      final code = body is Map ? body['error'] : null;
      return switch (code) {
        'restaurant_closed' => StatusRefusal.closed,
        'paused_by_operations' => StatusRefusal.pausedByOperations,
        _ => StatusRefusal.other,
      };
    }
  }
}

final statusCommandsProvider = Provider.autoDispose<StatusCommands>(
  (ref) => StatusCommands(
    ref.watch(coreApiProvider).getMerchantApi(),
    ref.watch(statusFeedProvider),
  ),
);
