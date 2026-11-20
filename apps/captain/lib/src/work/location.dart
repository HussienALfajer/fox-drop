import 'dart:async';
import 'dart:math';

import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:core_time/core_time.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
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
  /// app keeps tracking in the background. Each point is also kept until
  /// [sent], across a restart of the app.
  Stream<Fix> track();

  /// The points kept and not sent yet, oldest first, at most [limit], their
  /// times on the device's clock.
  Future<List<KeptFix>> pending(int limit);

  /// Forgets the first points [pending] answered, once the server kept them
  /// or will never keep them.
  Future<void> sent(List<KeptFix> points);

  /// Forgets every point kept (the session ended).
  Future<void> clear();
}

/// A point the source keeps until it is sent, by the source's own id.
typedef KeptFix = ({String id, Fix fix});

/// CA §4.3, architecture §14.1 (slice 2.43): the permission and a one-off
/// position through `geolocator`; tracking through
/// `flutter_background_geolocation`, which runs its foreground service of
/// type `location` with the permanent notification «أنت متصل — FOX DROP
/// يتابع موقعك لتصلك العروض», keeps every point in its own database until
/// the app sends it (so a point recorded without a signal, or while the
/// system had stopped the app, is sent once it runs again), and goes on
/// after the app is closed and after a reboot until [track]'s listener
/// stops it. Its Android licence comes from the build
/// (`FOXDROP_BGGEO_LICENSE`, the CI secret `STAGING_CAPTAIN_BGGEO_LICENSE`);
/// a debug build works without one. A release
/// build without it (staging until the owner buys it) tracks through
/// `geolocator`'s foreground service as before, its points kept in memory.
class PhoneLocationSource implements LocationSource {
  PhoneLocationSource();

  Future<void>? _readying;

  // Whether a [track] listener wants the library running now.
  bool _listening = false;

  // Without the library: the points tracked and not sent, oldest first.
  final _memory = <Fix>[];

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
      return Fix(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracyMetres: position.accuracy,
        recordedAt: position.timestamp.toUtc(),
        simulated: position.isMocked,
      );
    } on Object {
      return null;
    }
  }

  // Once per run of the app, before any other call of the library (its
  // rule: `ready` once and only once). The library remembers that it ran
  // (`stopOnTerminate` false, `startOnBoot` true), so `ready` resumes it
  // after the system ended the app or a reboot: unless a listener wants it
  // now, it stops there, never tracking while offline or signed out (CA
  // §4.3).
  Future<void> _readyOnce() =>
      _readying ??= _ready().catchError((Object error) {
        // A failed `ready` is tried again by the next call.
        _readying = null;
        throw error;
      });

  Future<void> _ready() async {
    // The notification's text is the one string outside a widget: the
    // service shows it before any screen does.
    final l10n = lookupAppLocalizations(const Locale('ar'));
    await bg.BackgroundGeolocation.ready(
      bg.Config(
        geolocation: bg.GeoConfig(
          desiredAccuracy: bg.DesiredAccuracy.high,
          // CA §4.3: every 10 seconds, moving or not (waiting at the
          // restaurant included), never thinned by distance or a filter.
          distanceFilter: 0,
          locationUpdateInterval: locationEvery.inMilliseconds,
          fastestLocationUpdateInterval: locationEvery.inMilliseconds,
          allowIdenticalLocations: true,
          disableElasticity: true,
          filter: bg.LocationFilter(
            policy: bg.LocationFilterPolicy.passThrough,
          ),
        ),
        // No motion detection: no stop detection to feed, and no «النشاط
        // البدني» permission to ask for.
        activity: const bg.ActivityConfig(
          disableStopDetection: true,
          disableMotionActivityUpdates: true,
        ),
        app: bg.AppConfig(
          stopOnTerminate: false,
          startOnBoot: true,
          notification: bg.Notification(
            title: l10n.captainAppName,
            text: l10n.captainTrackingNotice,
            sticky: true,
          ),
        ),
        persistence: bg.PersistenceConfig(
          persistMode: bg.PersistMode.location,
          maxDaysToPersist: 1,
          maxRecordsToPersist: _queueLimit,
        ),
        logger: const bg.LoggerConfig(logLevel: bg.LogLevel.error),
      ),
    );
    if (!_listening) await _stopLibrary();
  }

  Future<void> _stopLibrary() async {
    try {
      if ((await bg.BackgroundGeolocation.state).enabled) {
        await bg.BackgroundGeolocation.stop();
      }
    } on Object catch (error) {
      debugPrint('Background location stop: $error');
    }
  }

  @override
  Stream<Fix> track() {
    if (!_background) {
      return _foregroundTrack().map((fix) {
        _memory.add(fix);
        if (_memory.length > _queueLimit) _memory.removeAt(0);
        return fix;
      });
    }
    bg.Subscription? subscription;
    var cancelled = false;
    late final StreamController<Fix> controller;
    controller = StreamController<Fix>(
      onListen: () async {
        _listening = true;
        try {
          await _readyOnce();
          if (cancelled) return;
          subscription = bg.BackgroundGeolocation.onLocation((location) {
            if (!location.sample) controller.add(_fix(location));
          }, (error) => controller.addError(error));
          await bg.BackgroundGeolocation.start();
          // Moving at once: no stationary state waits for motion.
          if (!cancelled) await bg.BackgroundGeolocation.changePace(true);
          // A cancel that came while starting found nothing to stop.
          if (cancelled) await _stopLibrary();
        } on Object catch (error) {
          if (!cancelled) controller.addError(error);
        }
      },
      onCancel: () async {
        cancelled = true;
        _listening = false;
        await subscription?.remove();
        await _stopLibrary();
      },
    );
    return controller.stream;
  }

  // geolocator's position stream, with its foreground service of type
  // location and the same notification, while the app's engine runs.
  Stream<Fix> _foregroundTrack() {
    final l10n = lookupAppLocalizations(const Locale('ar'));
    final settings = AndroidSettings(
      accuracy: LocationAccuracy.high,
      intervalDuration: locationEvery,
      foregroundNotificationConfig: ForegroundNotificationConfig(
        notificationTitle: l10n.captainAppName,
        notificationText: l10n.captainTrackingNotice,
        setOngoing: true,
        enableWakeLock: true,
      ),
    );
    return Geolocator.getPositionStream(locationSettings: settings).map(
      (position) => Fix(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracyMetres: position.accuracy,
        recordedAt: position.timestamp.toUtc(),
        simulated: position.isMocked,
      ),
    );
  }

  @override
  Future<List<KeptFix>> pending(int limit) async {
    if (!_background) {
      return [
        for (final (index, fix) in _memory.take(limit).indexed)
          (id: '$index', fix: fix),
      ];
    }
    await _readyOnce();
    final rows = await bg.BackgroundGeolocation.getLocations(
      bg.LocationQuery(limit: limit, order: bg.LocationQuery.ORDER_ASC),
    );
    return [
      for (final row in rows)
        if (bg.Location(row) case final location when location.uuid != '')
          (id: location.uuid, fix: _fix(location)),
    ];
  }

  @override
  Future<void> sent(List<KeptFix> points) async {
    if (!_background) {
      _memory.removeRange(0, points.length.clamp(0, _memory.length));
      return;
    }
    for (final point in points) {
      await bg.BackgroundGeolocation.destroyLocation(point.id);
    }
  }

  @override
  Future<void> clear() async {
    if (!_background) return _memory.clear();
    await _readyOnce();
    if (!_listening) await _stopLibrary();
    await bg.BackgroundGeolocation.destroyLocations();
  }

  Fix _fix(bg.Location location) => Fix(
    latitude: location.coords.latitude,
    longitude: location.coords.longitude,
    accuracyMetres: location.coords.accuracy,
    recordedAt:
        DateTime.tryParse('${location.timestamp}')?.toUtc() ??
        DateTime.now().toUtc(),
    simulated: location.mock,
  );
}

final locationSourceProvider = Provider<LocationSource>(
  (ref) => PhoneLocationSource(),
);

/// Whether the build carries `flutter_background_geolocation`'s licence: CI
/// passes `BACKGROUND_LOCATION_LICENSED` with the key (slice 2.43).
const backgroundLocationLicensed = bool.fromEnvironment(
  'BACKGROUND_LOCATION_LICENSED',
);

// The library works without its licence in a debug build only.
bool get _background => kDebugMode || backgroundLocationLicensed;

/// CA §4.3: every 10 seconds while online (fixed, AP §4.2).
const locationEvery = Duration(seconds: 10);

/// The server takes at most 360 points per call.
const _batchSize = 360;

/// Points kept while no answer comes: a day of points every 10 seconds.
const _queueLimit = 8640;

/// Tracks the phone while the captain is online and sends the points every
/// 10 seconds, oldest first; points the server could not receive wait for the
/// next send, so the route stays complete (CA §4.3). The source keeps them
/// (slice 2.43: the library's database on Android), so a restart loses none:
/// the next start or stop sends what it kept.
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
  Future<int> get queued async => (await source.pending(_queueLimit)).length;

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
    _sendKept();
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
    unawaited(flush());
  }

  /// A position taken for a command, kept as the latest; the server keeps
  /// it with the command (CA §15), so it is not sent again as a point.
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
    _latest = null;
    _stopTimer();
    unawaited(
      source.clear().catchError(
        (Object error) => debugPrint('Location points kept: $error'),
      ),
    );
  }

  // The source keeps every point it tracked (`LocationSource.track`).
  void _record(Fix fix) {
    final point = onServerClock(fix);
    _latest = point;
    _changes.add(point);
  }

  // Sends what the source keeps every 10 seconds, until nothing is left
  // while not tracking.
  void _sendKept() {
    _timer ??= Timer.periodic(locationEvery, (_) => unawaited(flush()));
  }

  Future<void> flush() async {
    if (_sending) return;
    _sending = true;
    try {
      final batch = await source.pending(_batchSize);
      if (batch.isEmpty) {
        if (_tracking == null && !_starting) _stopTimer();
        return;
      }
      // Points kept while not tracking (stopped, or from before a restart)
      // go every 10 seconds until none is left.
      _sendKept();
      try {
        await send([for (final point in batch) onServerClock(point.fix)]);
        await source.sent(batch);
      } on DioException catch (error) {
        final status = error.response?.statusCode;
        // Offline (409 not_online) or a point refused (400): the server will
        // never keep them, so they leave the queue.
        if (status == 409 || status == 400) await source.sent(batch);
      }
    } on Object catch (error) {
      // The source could not be read: the next round tries again.
      if (error is! DioException) debugPrint('Location points: $error');
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
