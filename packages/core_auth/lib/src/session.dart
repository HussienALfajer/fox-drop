import 'dart:async';
import 'dart:math';

import 'package:core_storage/core_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_party.dart';
import 'auth_scope.dart';

/// Why a session ended on this device.
enum SessionEndReason {
  /// The user signed out.
  signedOut,

  /// A captain signed in on another device (CA §4.9, K5): the app shows
  /// «سُجّل دخولك من جهاز آخر».
  otherDevice,

  /// The server ended it: sign-out everywhere, a reused refresh token, a
  /// removed user or a forced sign-out (CU §5.4, RA §5.3).
  ended,
}

sealed class SessionState {
  const SessionState();
}

class SignedOut extends SessionState {
  const SignedOut([this.reason]);

  /// Null when no session ever ended here, such as at the first start.
  final SessionEndReason? reason;
}

class SignedIn extends SessionState {
  const SignedIn(this.accountId);

  final String accountId;
}

const _accessKey = 'session.access_token';
const _accessExpiresKey = 'session.access_expires_at';
const _refreshKey = 'session.refresh_token';
const _accountKey = 'session.account_id';
const _deviceKey = 'device.id';

/// The app's session (architecture §15.1, CU §5.4): the tokens in the secure
/// store, the access token renewed shortly before it expires, one refresh at
/// a time, and the session ended when the server refuses the refresh.
class SessionController extends AsyncNotifier<SessionState> {
  SessionController(this._scope);

  final AuthScope _scope;
  AuthTokens? _tokens;
  Future<bool>? _refreshing;

  SecureStore get _store => ref.read(_scope.store);

  AuthParty get _party => ref.read(_scope.party);

  @override
  Future<SessionState> build() async {
    final values = await Future.wait([
      _store.read(_accessKey),
      _store.read(_accessExpiresKey),
      _store.read(_refreshKey),
      _store.read(_accountKey),
    ]);
    final expiresAt = DateTime.tryParse(values[1] ?? '');
    if (values.any((value) => value == null) || expiresAt == null) {
      return const SignedOut();
    }
    _tokens = AuthTokens(
      accessToken: values[0]!,
      accessTokenExpiresAt: expiresAt,
      refreshToken: values[2]!,
    );
    return SignedIn(values[3]!);
  }

  /// The app installation's id, generated once and kept until the app is
  /// removed (the `deviceId` of the sign-in routes).
  Future<String> deviceId() async {
    final stored = await _store.read(_deviceKey);
    if (stored != null) return stored;
    final id = _uuidV4();
    await _store.write(_deviceKey, id);
    return id;
  }

  /// A sign-in succeeded.
  Future<void> start(String accountId, AuthTokens tokens) async {
    await future;
    await _save(tokens);
    await _store.write(_accountKey, accountId);
    state = AsyncData(SignedIn(accountId));
  }

  /// The token for the next call, renewed first when it expires within
  /// [AuthScope.refreshAhead]; null when signed out.
  Future<String?> accessToken() async {
    await future;
    final tokens = _tokens;
    if (tokens == null) return null;
    final left = tokens.accessTokenExpiresAt.difference(_scope.clock());
    if (left <= _scope.refreshAhead) await refresh();
    return _tokens?.accessToken;
  }

  /// The access token held now, without renewing it.
  String? get currentAccessToken => _tokens?.accessToken;

  /// Renews the tokens; true when the session goes on. Concurrent callers
  /// share one refresh, so a refresh token is never sent twice by mistake.
  Future<bool> refresh() =>
      _refreshing ??= _refresh().whenComplete(() => _refreshing = null);

  Future<bool> _refresh() async {
    await future;
    final tokens = _tokens;
    if (tokens == null) return false;
    for (var attempt = 0; ; attempt++) {
      try {
        final next = await _party.refresh(tokens.refreshToken);
        // Signed out while the refresh ran.
        if (!identical(_tokens, tokens)) return _tokens != null;
        await _save(next);
        return true;
      } on AuthRefusal catch (refusal) {
        if (refusal.status == 401) {
          await end(
            refusal.error == 'other_device'
                ? SessionEndReason.otherDevice
                : SessionEndReason.ended,
          );
          return false;
        }
        // The answer may have been lost after the server used the token: the
        // server accepts the same token again for 10 seconds (the identity
        // module's REFRESH_RETRY_GRACE_SECONDS), so retry within them.
        final delays = _scope.refreshRetryDelays;
        if (refusal.error != AuthRefusal.network || attempt >= delays.length) {
          return false;
        }
        await Future<void>.delayed(delays[attempt]);
        if (!identical(_tokens, tokens)) return _tokens != null;
      }
    }
  }

  /// Ends the session on this device and forgets its tokens.
  Future<void> end(SessionEndReason reason) async {
    _tokens = null;
    await Future.wait([
      _store.delete(_accessKey),
      _store.delete(_accessExpiresKey),
      _store.delete(_refreshKey),
      _store.delete(_accountKey),
    ]);
    state = AsyncData(SignedOut(reason));
  }

  /// «تسجيل الخروج»: ends the session on the server, then here. Without an
  /// answer from the server the device still signs out.
  Future<void> signOut() async {
    final token = await accessToken();
    if (token != null) {
      try {
        await _party.signOut(token);
      } on AuthRefusal {
        // Signed out here all the same.
      }
    }
    await end(SessionEndReason.signedOut);
  }

  Future<void> _save(AuthTokens tokens) async {
    await Future.wait([
      _store.write(_accessKey, tokens.accessToken),
      _store.write(
        _accessExpiresKey,
        tokens.accessTokenExpiresAt.toUtc().toIso8601String(),
      ),
      _store.write(_refreshKey, tokens.refreshToken),
    ]);
    _tokens = tokens;
  }
}

String _uuidV4() {
  final random = Random.secure();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
      '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
}

/// Puts the session's access token on every call of the app's client and,
/// on a 401, renews it once and repeats the call (architecture §11.2, §15.1).
/// A captain signed in elsewhere (`401 other_device`) ends the session.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._session, this._dio);

  final SessionController Function() _session;
  final Dio _dio;

  static const _retried = 'core_auth.retried';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _session().accessToken();
    if (token != null) options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    if (err.response?.statusCode != 401 || options.extra[_retried] == true) {
      return handler.next(err);
    }
    final session = _session();
    if (AuthRefusal.of(err).error == 'other_device') {
      await session.end(SessionEndReason.otherDevice);
      return handler.next(err);
    }
    // Another call may have renewed the token since this one left.
    final sent = options.headers['Authorization'];
    final current = session.currentAccessToken;
    final renewed =
        (current != null && sent != 'Bearer $current') ||
        await session.refresh();
    if (!renewed) return handler.next(err);
    options.extra[_retried] = true;
    try {
      handler.resolve(await _dio.fetch<dynamic>(options));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }
}
