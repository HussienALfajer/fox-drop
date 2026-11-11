import 'dart:async';
import 'dart:math';

import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:core_time/core_time.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../api.dart';
import '../auth.dart';
import 'package:core_auth/core_auth.dart';

/// One GPS point, its time on the server's clock (CA §4.6).
class Fix {
  const Fix({
    required this.latitude,
    required this.longitude,
    required this.accuracyMetres,
    required this.recordedAt,
    required this.simulated,
  });

  final double latitude;
  final double longitude;
  final double accuracyMetres;
  final DateTime recordedAt;

  /// A mock-location app gave it (CA §4.3).
  final bool simulated;

  /// The straight-line distance to a point, in metres, as the server measures
  /// the arrival radii (C6, K4).
  int metresTo(double toLatitude, double toLongitude) {
    const earthRadius = 6371000.0;
    double radians(double degrees) => degrees * pi / 180;
    final dLat = radians(toLatitude - latitude);
    final dLon = radians(toLongitude - longitude);
    final a =
        pow(sin(dLat / 2), 2) +
        cos(radians(latitude)) *
            cos(radians(toLatitude)) *
            pow(sin(dLon / 2), 2);
    return (2 * earthRadius * asin(sqrt(a))).round();
  }
}

/// K3: worse than 100 metres the arrival needs operations (fixed, as the
/// server's `WEAK_GPS_METRES`).
const weakGpsMetres = 100;

/// Why the phone gives no position.
enum LocationProblem { serviceOff, denied, failed }

/// The phone's location (CA §4.3), through `geolocator`; tests replace it.
abstract interface class LocationSource {
  /// Asks for the permission when it was never answered; null when granted.
  Future<LocationProblem?> ensureAccess();

  /// One fresh position, its time on the device's clock.
  Future<Fix?> current();

  /// A position about every 10 seconds while listened to. On Android it runs
  /// a foreground service with its permanent notification (CA §4.3), so the
  /// app keeps tracking in the background.
  Stream<Fix> track();
}

class GeolocatorSource implements LocationSource {
  const GeolocatorSource();

  @override
  Future<LocationProblem?> ensureAccess() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return LocationProblem.serviceOff;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      return permission == LocationPermission.whileInUse ||
              permission == LocationPermission.always
          ? null
          : LocationProblem.denied;
    } on Object {
      return LocationProblem.failed;
    }
  }

  @override
  Future<Fix?> current() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );
      return _fix(position);
    } on Object {
      return null;
    }
  }

  @override
  Stream<Fix> track() {
    // The notification's text is the one string outside a widget: the
    // service shows it before any screen does.
    final l10n = lookupAppLocalizations(const Locale('ar'));
    final settings = defaultTargetPlatform == TargetPlatform.android
        ? AndroidSettings(
            accuracy: LocationAccuracy.high,
            intervalDuration: locationEvery,
            foregroundNotificationConfig: ForegroundNotificationConfig(
              notificationTitle: l10n.captainAppName,
              notificationText: l10n.captainTrackingNotice,
              setOngoing: true,
              enableWakeLock: true,
            ),
          )
        : const LocationSettings(accuracy: LocationAccuracy.high);
    return Geolocator.getPositionStream(locationSettings: settings).map(_fix);
  }

  Fix _fix(Position position) => Fix(
    latitude: position.latitude,
    longitude: position.longitude,
    accuracyMetres: position.accuracy,
    recordedAt: position.timestamp.toUtc(),
    simulated: position.isMocked,
  );
}

final locationSourceProvider = Provider<LocationSource>(
  (ref) => const GeolocatorSource(),
);

/// CA §4.3: every 10 seconds while online (fixed, AP §4.2).
const locationEvery = Duration(seconds: 10);

/// The server takes at most 360 points per call.
const _batchSize = 360;

/// Points kept while no answer comes: a day of points every 10 seconds.
const _queueLimit = 8640;

/// Tracks the phone while the captain is online and sends the points every
/// 10 seconds, oldest first; points the server could not receive wait for the
/// next send, so the route stays complete (CA §4.3). The queue lives while the
/// app runs; one that survives a restart comes with `core_commands`.
class LocationTracker {
  LocationTracker({
    required this.source,
    required this.clock,
    required this.send,
  });

  final LocationSource source;
  final ServerClock clock;

  /// Sends a batch; throws a [DioException] when the server does not keep it.
  final Future<void> Function(List<Fix> points) send;

  final _queue = <Fix>[];
  StreamSubscription<Fix>? _tracking;
  // A start waiting for the location access; a stop or reset makes it stale.
  bool _starting = false;
  int _generation = 0;
  Timer? _timer;
  bool _sending = false;
  Fix? _latest;

  /// The latest point, for the commands' fix and the arrival radii.
  Fix? get latest => _latest;

  /// The points waiting to be sent.
  int get queued => _queue.length;

  bool get tracking => _tracking != null;

  /// Every new latest point.
  final _changes = StreamController<Fix>.broadcast();
  Stream<Fix> get changes => _changes.stream;

  /// A point on the server's clock (CA §4.6): the device's time moved by the
  /// offset the latest answer showed.
  Fix onServerClock(Fix fix) => Fix(
    latitude: fix.latitude,
    longitude: fix.longitude,
    accuracyMetres: fix.accuracyMetres,
    recordedAt: fix.recordedAt.add(clock.offset),
    simulated: fix.simulated,
  );

  /// Starts collecting once the phone gives the location. Asked here, not
  /// only at «متصل»: a phone signed in while the captain is online (a
  /// released device, CA §4.9) has never asked. Without access, or when the
  /// stream fails, it stays stopped, and the next online state tries again.
  void start() {
    if (_tracking != null || _starting) return;
    _starting = true;
    _timer ??= Timer.periodic(locationEvery, (_) => unawaited(flush()));
    final generation = _generation;
    unawaited(() async {
      try {
        final problem = await source.ensureAccess();
        if (generation != _generation || problem != null) return;
        _tracking = source.track().listen(
          _record,
          onError: (Object _) {
            unawaited(_tracking?.cancel());
            _tracking = null;
          },
        );
      } finally {
        if (generation == _generation) _starting = false;
      }
    }());
  }

  /// Stops collecting (CA §4.3: never while offline); the points already
  /// recorded are still sent, since the server keeps those recorded online.
  void stop() {
    _generation++;
    _starting = false;
    unawaited(_tracking?.cancel());
    _tracking = null;
    if (_queue.isEmpty) _stopTimer();
  }

  /// A position taken for a command, kept as the latest.
  void remember(Fix fix) => _record(fix);

  /// A position taken while offline: the latest, never sent (CA §4.3).
  void see(Fix fix) {
    _latest = onServerClock(fix);
    _changes.add(_latest!);
  }

  /// The session ended: nothing more is collected or sent, and the points
  /// held are dropped, since the server would refuse them.
  void reset() {
    _generation++;
    _starting = false;
    unawaited(_tracking?.cancel());
    _tracking = null;
    _queue.clear();
    _latest = null;
    _stopTimer();
  }

  void _record(Fix fix) {
    final point = onServerClock(fix);
    _latest = point;
    _changes.add(point);
    _queue.add(point);
    if (_queue.length > _queueLimit) _queue.removeAt(0);
  }

  Future<void> flush() async {
    if (_sending || _queue.isEmpty) {
      if (_tracking == null && _queue.isEmpty) _stopTimer();
      return;
    }
    _sending = true;
    final batch = _queue.take(_batchSize).toList();
    try {
      await send(batch);
      _queue.removeRange(0, batch.length);
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      // Offline (409 not_online) or a point refused (400): the server will
      // never keep them, so they leave the queue.
      if (status == 409 || status == 400) _queue.removeRange(0, batch.length);
    } finally {
      _sending = false;
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    _generation++;
    unawaited(_tracking?.cancel());
    _tracking = null;
    _stopTimer();
    unawaited(_changes.close());
  }
}

final locationTrackerProvider = Provider<LocationTracker>((ref) {
  final tracker = LocationTracker(
    source: ref.watch(locationSourceProvider),
    clock: ref.watch(serverClockProvider),
    send: (points) async {
      await ref
          .read(coreApiProvider)
          .getCaptainApi()
          .captainAvailabilityLocation(
            captainLocationsDto: CaptainLocationsDto(
              (b) => b.points.addAll([
                for (final p in points)
                  CaptainLocationsDtoPointsInner(
                    (point) => point
                      ..latitude = p.latitude
                      ..longitude = p.longitude
                      ..accuracyMetres = p.accuracyMetres
                      ..recordedAt = p.recordedAt
                      ..simulated = p.simulated,
                  ),
              ]),
            ),
          );
    },
  );
  // A sign-out while online (another device, a released device, K5) stops
  // the tracking and its foreground service at once.
  ref.listen(captainAuth.session, (previous, next) {
    if (next.value is! SignedIn) tracker.reset();
  });
  ref.onDispose(tracker.dispose);
  return tracker;
});

/// The latest point, for the screens.
final latestFixProvider = StreamProvider<Fix>((ref) {
  final tracker = ref.watch(locationTrackerProvider);
  final latest = tracker.latest;
  return Stream.multi((controller) {
    if (latest != null) controller.add(latest);
    final sub = tracker.changes.listen(controller.add);
    controller.onCancel = sub.cancel;
  });
});
