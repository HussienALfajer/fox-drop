import 'dart:async';

import 'package:core_realtime/core_realtime.dart';

import 'kept_read.dart';
import 'platform_check.dart';

/// The city's emergency stop as the app reads it (AP §9.1.6, D7):
/// `GET /v1/{party}/emergency-stop`. The customer's read also carries the
/// browsing message and the delay notice, its reason filled.
class EmergencyStop {
  const EmergencyStop({
    required this.active,
    this.startedAt,
    this.browseMessage,
    this.delayNotice,
  });

  /// Before the first answer, and when the server answers none.
  static const none = EmergencyStop(active: false);

  final bool active;
  final DateTime? startedAt;
  final String? browseMessage;
  final String? delayNotice;

  @override
  bool operator ==(Object other) =>
      other is EmergencyStop &&
      other.active == active &&
      other.startedAt == startedAt &&
      other.browseMessage == browseMessage &&
      other.delayNotice == delayNotice;

  @override
  int get hashCode => Object.hash(active, startedAt, browseMessage, delayNotice);
}

/// The emergency stop kept current (`KeptRead`): read at [start], on each
/// return to the foreground, and on [check], which [followPlatformBroadcasts]
/// calls when the channel connects and on each `platform.emergency_stop`.
/// Until the first answer it is [EmergencyStop.none]: a server out of reach
/// never shows a stop.
class EmergencyStopCheck extends KeptRead<EmergencyStop> {
  EmergencyStopCheck(
    Future<EmergencyStop> Function() read, {
    super.firstRetry,
    super.lastRetry,
  }) : super(read, EmergencyStop.none);

  final _switched = StreamController<bool>.broadcast();
  EmergencyStop get stop => value;

  /// The stop starting (true) or ending (false), seen after an earlier
  /// answer (a new stop's start, even with no end seen between, is true): the restaurant and captain apps chime once (RA §16 #34, CA §14
  /// #31). The first answer is the state the app opened in, never a switch.
  Stream<bool> get switched => _switched.stream;

  @override
  void changing(EmergencyStop before, EmergencyStop after) {
    if (!answered) return;
    // A stop that ended and another that started between two reads is a
    // switch too: its start differs.
    final restarted =
        before.active && after.active && before.startedAt != after.startedAt;
    if (before.active != after.active || restarted) {
      _switched.add(after.active);
    }
  }

  @override
  void dispose() {
    unawaited(_switched.close());
    super.dispose();
  }
}

/// The platform broadcasts on an app's channel (RA §18, CA §15): each says
/// only that a fact changed, which the app reads again in full. The channel
/// connecting (the first time and every reconnect, RA §4.2) reads both again;
/// `platform.emergency_stop` reads the stop, `platform.app_changed` the
/// platform. Cancel the subscription to stop following.
StreamSubscription<RealtimeSignal> followPlatformBroadcasts(
  Stream<RealtimeSignal> channel, {
  EmergencyStopCheck? stop,
  PlatformCheck? platform,
}) => channel.listen((signal) {
  switch (signal) {
    case RealtimeUp():
      if (stop != null) unawaited(stop.check());
      if (platform != null) unawaited(platform.check());
    case RealtimePublication(:final data):
      switch (data['type']) {
        case 'platform.emergency_stop':
          if (stop != null) unawaited(stop.check());
        case 'platform.app_changed':
          if (platform != null) unawaited(platform.check());
      }
    case RealtimeDown():
  }
});
