import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';

/// A value the server answers, kept current: read at [start], each time the
/// app comes back to the foreground, on [check], and after a failed read
/// again, [firstRetry] doubling to [lastRetry], so it follows the connection
/// coming back. A [check] while a read runs reads once more after it, so an
/// answer that predates the call never stands as the latest.
abstract class KeptRead<T> extends ChangeNotifier {
  KeptRead(
    this._read,
    this._value, {
    this.firstRetry = const Duration(seconds: 5),
    this.lastRetry = const Duration(minutes: 5),
  });

  final Future<T> Function() _read;
  final Duration firstRetry;
  final Duration lastRetry;

  T _value;
  AppLifecycleListener? _lifecycle;
  Timer? _retry;
  Future<void>? _reading;
  bool _again = false;
  bool _disposed = false;

  /// The latest answer, or the initial value until one comes.
  T get value => _value;

  bool _answered = false;

  /// Whether a read has answered; false inside [changing] for the first.
  bool get answered => _answered;

  /// Called with the answer before it replaces [value], when it differs.
  @protected
  void changing(T before, T after) {}

  /// Reads now, and again whenever the app resumes.
  void start() {
    _lifecycle ??= AppLifecycleListener(onResume: () => unawaited(check()));
    unawaited(check());
  }

  /// Reads now; during a read, once more after it.
  Future<void> check() {
    final running = _reading;
    if (running != null) {
      _again = true;
      return running;
    }
    if (_disposed) return Future.value();
    return _begin(firstRetry);
  }

  Future<void> _begin(Duration wait) =>
      _reading = _run(wait).whenComplete(() => _reading = null);

  Future<void> _run(Duration wait) async {
    _retry?.cancel();
    _retry = null;
    try {
      do {
        _again = false;
        final next = await _read();
        if (_disposed) return;
        if (next != _value) {
          changing(_value, next);
          _value = next;
          notifyListeners();
        }
        _answered = true;
      } while (_again && !_disposed);
    } on Object catch (error) {
      if (_disposed) return;
      debugPrint('$runtimeType read failed: $error');
      final next = Duration(
        microseconds: min(wait.inMicroseconds * 2, lastRetry.inMicroseconds),
      );
      _retry = Timer(wait, () {
        if (_reading == null && !_disposed) unawaited(_begin(next));
      });
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
