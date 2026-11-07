import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

/// A point on the map, in degrees.
class GeoPoint {
  const GeoPoint(this.latitude, this.longitude);

  final double latitude;
  final double longitude;

  /// The great-circle distance to [other], in metres.
  double metresTo(GeoPoint other) {
    const earthRadius = 6371000.0;
    double radians(double degrees) => degrees * pi / 180;
    final dLat = radians(other.latitude - latitude);
    final dLon = radians(other.longitude - longitude);
    final a =
        pow(sin(dLat / 2), 2) +
        cos(radians(latitude)) *
            cos(radians(other.latitude)) *
            pow(sin(dLon / 2), 2);
    return 2 * earthRadius * asin(sqrt(a));
  }

  @override
  bool operator ==(Object other) =>
      other is GeoPoint &&
      other.latitude == latitude &&
      other.longitude == longitude;

  @override
  int get hashCode => Object.hash(latitude, longitude);
}

/// The phone's position, with its accuracy in metres.
class PositionFix {
  const PositionFix(this.point, this.accuracyMetres);

  final GeoPoint point;
  final double accuracyMetres;
}

/// Why no position came.
enum PositionFailure { serviceOff, denied, failed }

/// A position or why there is none.
typedef PositionResult = ({PositionFix? fix, PositionFailure? failure});

/// The phone's location while the app is used (CU §4.4), through
/// `geolocator`; tests override [positionSourceProvider].
abstract interface class PositionSource {
  /// Asks for the permission when it was never answered. With [ask] false a
  /// missing permission is `denied` without a prompt (the far-pin check,
  /// CU §7.5).
  Future<PositionResult> current({required Duration timeLimit, bool ask});
}

class GeolocatorPositionSource implements PositionSource {
  const GeolocatorPositionSource();

  @override
  Future<PositionResult> current({
    required Duration timeLimit,
    bool ask = true,
  }) async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return (fix: null, failure: PositionFailure.serviceOff);
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied && ask) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever ||
          permission == LocationPermission.unableToDetermine) {
        return (fix: null, failure: PositionFailure.denied);
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: timeLimit,
        ),
      );
      return (
        fix: PositionFix(
          GeoPoint(position.latitude, position.longitude),
          position.accuracy,
        ),
        failure: null,
      );
    } on Object {
      return (fix: null, failure: PositionFailure.failed);
    }
  }
}

final positionSourceProvider = Provider<PositionSource>(
  (ref) => const GeolocatorPositionSource(),
);
