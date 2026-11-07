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
