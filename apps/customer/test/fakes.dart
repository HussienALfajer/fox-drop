import 'dart:async';

import 'package:core_realtime/core_realtime.dart';
import 'package:customer/src/location/position.dart';

/// Azaz's centre, inside the test zone.
const azaz = GeoPoint(36.5862, 37.0463);

/// A phone whose position is [result]; it counts the requests.
class FakePositionSource implements PositionSource {
  FakePositionSource([PositionResult? result])
    : result = result ?? (fix: const PositionFix(azaz, 12), failure: null);

  PositionResult result;
  final List<({Duration timeLimit, bool ask})> calls = [];

  @override
  Future<PositionResult> current({
    required Duration timeLimit,
    bool ask = true,
  }) async {
    calls.add((timeLimit: timeLimit, ask: ask));
    return result;
  }
}

/// The real-time channel without Centrifugo: tests send the signals.
class FakeTransport implements RealtimeTransport {
  /// Every listener of each channel: the feed and the platform broadcasts
  /// listen to the same one, as on `CentrifugeTransport`.
  final channels = <String, List<StreamController<RealtimeSignal>>>{};

  @override
  Stream<RealtimeSignal> channel(String name) {
    final controller = StreamController<RealtimeSignal>();
    (channels[name] ??= []).add(controller);
    controller.onCancel = () => channels[name]!.remove(controller);
    return controller.stream;
  }

  void send(String name, RealtimeSignal signal) {
    for (final controller in [...?channels[name]]) {
      controller.add(signal);
    }
  }
}
