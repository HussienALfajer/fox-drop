import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';

import 'platform_status.dart';

/// The app's update and maintenance kept current (CU §4.2, RA §4.2, CA §4.2:
/// "at launch and on every reconnect"): read at [start], each time the app
/// comes back to the foreground, and after a failed read again, 5 s doubling
/// to 5 minutes, so the check follows the connection coming back. Its value
/// is the latest answer, [PlatformStatus.clear] until one comes.
class PlatformCheck extends ChangeNotifier {
  PlatformCheck(
    this._read, {
    this.firstRetry = const Duration(seconds: 5),
    this.lastRetry = const Duration(minutes: 5),
  });

  final Future<PlatformStatus> Function() _read;
  final Duration firstRetry;
  final Duration lastRetry;

  PlatformStatus _status = PlatformStatus.clear;
  bool _dismissed = false;
  AppLifecycleListener? _lifecycle;
  Timer? _retry;
  bool _reading = false;
  bool _disposed = false;

  PlatformStatus get status => _status;

  /// The dismissible banner of a suggested update, until dismissed for the
  /// app's run.
  bool get showsBanner => _status.update == UpdateNeed.suggested && !_dismissed;

  void dismissBanner() {
    _dismissed = true;
    notifyListeners();
  }

  /// Reads now, and again whenever the app resumes.
  void start() {
    _lifecycle ??= AppLifecycleListener(onResume: () => unawaited(check()));
    unawaited(check());
  }

  /// Reads the status now, unless a read is already running.
  Future<void> check() => _check(firstRetry);

  Future<void> _check(Duration wait) async {
    if (_reading || _disposed) return;
    _retry?.cancel();
    _retry = null;
    _reading = true;
    try {
      final status = await _read();
      if (_disposed) return;
      if (status != _status) {
        _status = status;
        notifyListeners();
      }
    } on Object catch (error) {
      if (_disposed) return;
      debugPrint('Platform check failed: $error');
      final next = Duration(
        microseconds: min(wait.inMicroseconds * 2, lastRetry.inMicroseconds),
      );
      _retry = Timer(wait, () => unawaited(_check(next)));
    } finally {
      _reading = false;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _retry?.cancel();
    _lifecycle?.dispose();
    super.dispose();
  }
}
