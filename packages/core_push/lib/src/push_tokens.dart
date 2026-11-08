import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import 'push.dart';

/// Keeps the installation's token registered with the server while the app
/// is signed in (`PUT /v1/{party}/push-token`): at sign-in, which includes
/// every start with a stored session, and whenever Firebase renews it. The
/// server ties the token to the session, so a signed-out installation gets
/// nothing and needs no call.
///
/// A registration that fails is tried again after [firstRetry], doubling up
/// to [lastRetry], while the app stays signed in: without it no push reaches
/// the phone until the next start.
class PushTokens {
  PushTokens(
    this._push,
    this._register, {
    this.firstRetry = const Duration(seconds: 5),
    this.lastRetry = const Duration(minutes: 5),
  });

  final Push _push;
  final Future<void> Function(String token) _register;
  final Duration firstRetry;
  final Duration lastRetry;

  StreamSubscription<String>? _refreshes;
  Timer? _retry;
  // A new sign-in or sign-out makes the older calls' answers moot.
  int _generation = 0;
  // The token being sent or last registered in this sign-in: `register()`
  // also gives it on the renewals' stream, and one call is enough.
  String? _sent;
  bool get _signedIn => _refreshes != null;

  /// The app signed in: registers the token now and every renewal after.
  void signedIn() {
    if (_signedIn) return;
    final generation = ++_generation;
    _sent = null;
    _refreshes = _push.tokenRefreshes.listen(
      (token) => _send(token, generation, firstRetry),
    );
    unawaited(_fetch(generation, firstRetry));
  }

  /// The app signed out: stops registering.
  void signedOut() {
    _generation++;
    _retry?.cancel();
    _retry = null;
    unawaited(_refreshes?.cancel());
    _refreshes = null;
  }

  void dispose() => signedOut();

  Duration _next(Duration wait) => Duration(
    microseconds: min(wait.inMicroseconds * 2, lastRetry.inMicroseconds),
  );

  // Firebase failing to give a token (no connection at start) is tried again
  // as a failed registration is.
  Future<void> _fetch(int generation, Duration wait) async {
    final String? token;
    try {
      token = await _push.token();
    } on Object catch (error) {
      if (generation != _generation || _sent != null) return;
      debugPrint('No push token: $error');
      _retry = Timer(wait, () => unawaited(_fetch(generation, _next(wait))));
      return;
    }
    if (token != null) await _send(token, generation, firstRetry);
  }

  Future<void> _send(String token, int generation, Duration wait) async {
    if (generation != _generation || token == _sent) return;
    // A newer token replaces any retry of an older one.
    _retry?.cancel();
    _sent = token;
    try {
      await _register(token);
    } on Object catch (error) {
      if (generation != _generation || _sent != token) return;
      debugPrint('Push token not registered: $error');
      _sent = null;
      _retry = Timer(
        wait,
        () => unawaited(_send(token, generation, _next(wait))),
      );
    }
  }
}
