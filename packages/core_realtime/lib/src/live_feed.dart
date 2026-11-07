import 'dart:async';

import 'transport.dart';

/// What a live feed shows: the latest full state the server gave, and
/// whether the channel is up.
class LiveState<T> {
  const LiveState({this.value, this.live = false, this.failed = false});

  /// Null until the first fetch answers.
  final T? value;

  /// The channel is subscribed; false while it is down, when the feed polls.
  final bool live;

  /// The latest fetch failed; [value] is the one before it.
  final bool failed;
}

/// Keeps a full state current over one channel (RA §4.3, CU §4.3):
///
/// - it fetches the state when it starts, and again whenever the channel is
///   subscribed without recovering what it missed;
/// - a publication whose order version is newer than the one shown fetches
///   the state again; an older or repeated one is ignored;
/// - while the channel is down, or after a failed fetch, it fetches every
///   [pollEvery].
///
/// Publications carry `orderId` and `version` (the outbox relay's payload);
/// [versions] gives the version of each order in a fetched state. The feed
/// fetches rather than applying an event, so the state shown is always one
/// the server answered.
class LiveFeed<T> {
  LiveFeed({
    required this.transport,
    required this.channel,
    required this.fetch,
    required this.versions,
    this.pollEvery = const Duration(seconds: 30),
  });

  final RealtimeTransport transport;
  final String channel;
  final Future<T> Function() fetch;
  final Map<String, int> Function(T state) versions;
  final Duration pollEvery;

  final _states = StreamController<LiveState<T>>.broadcast();
  final _events = StreamController<Map<String, Object?>>.broadcast();
  LiveState<T> _state = LiveState<T>();
  final Map<String, int> _known = {};
  StreamSubscription<RealtimeSignal>? _signals;
  Timer? _poll;
  Future<void>? _fetching;
  bool _again = false;
  bool _closed = false;

  /// Every new state, the latest first to a new listener's read of [state].
  Stream<LiveState<T>> get states => _states.stream;

  LiveState<T> get state => _state;

  /// The current state, then every new one, with no gap between them: the
  /// stream listens to [states] before it gives the current state.
  Stream<LiveState<T>> watch() {
    late StreamController<LiveState<T>> controller;
    StreamSubscription<LiveState<T>>? subscription;
    controller = StreamController<LiveState<T>>(
      onListen: () {
        subscription = states.listen(controller.add, onDone: controller.close);
        controller.add(_state);
      },
      onCancel: () => subscription?.cancel(),
    );
    return controller.stream;
  }

  /// The publications newer than the version shown, as they arrive, before
  /// the fetch they cause: the app reads their `type` and `reason` for its
  /// sounds and messages.
  Stream<Map<String, Object?>> get events => _events.stream;

  void start() {
    if (_signals != null || _closed) return;
    _signals = transport.channel(channel).listen(_onSignal);
    _schedulePoll();
    unawaited(refresh());
  }

  /// Fetches the state now, as after pull to refresh or a command's answer.
  /// Calls while a fetch runs make one more fetch after it.
  Future<void> refresh() {
    final running = _fetching;
    if (running != null) {
      _again = true;
      return running;
    }
    final fetching = _run();
    _fetching = fetching;
    return fetching;
  }

  Future<void> _run() async {
    do {
      _again = false;
      try {
        final value = await fetch();
        if (_closed) return;
        _remember(versions(value));
        _emit(LiveState(value: value, live: _state.live));
      } on Object {
        if (_closed) return;
        _emit(LiveState(value: _state.value, live: _state.live, failed: true));
      }
    } while (_again && !_closed);
    _fetching = null;
    _schedulePoll();
  }

  // Versions only grow, so the highest seen stays, even for an order that
  // left the state: a late repeat of its last event is still ignored.
  void _remember(Map<String, int> seen) {
    for (final entry in seen.entries) {
      final known = _known[entry.key];
      if (known == null || entry.value > known) _known[entry.key] = entry.value;
    }
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
        final orderId = data['orderId'];
        final version = data['version'];
        if (orderId is! String || version is! int) return;
        final known = _known[orderId];
        if (known != null && version <= known) return;
        _known[orderId] = version;
        _events.add(data);
        unawaited(refresh());
    }
  }

  // Polls while the channel is down or the latest fetch failed.
  void _schedulePoll() {
    _poll?.cancel();
    _poll = null;
    if (_closed || (_state.live && !_state.failed)) return;
    _poll = Timer(pollEvery, () => unawaited(refresh()));
  }

  void _emit(LiveState<T> next) {
    _state = next;
    _states.add(next);
  }

  Future<void> close() async {
    _closed = true;
    _poll?.cancel();
    await _signals?.cancel();
    await _states.close();
    await _events.close();
  }
}
