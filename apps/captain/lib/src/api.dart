import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:core_realtime/core_realtime.dart';
import 'package:core_time/core_time.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth.dart';

/// The server address, set with `--dart-define=API_BASE_URL=...`.
const _apiBaseUrl = String.fromEnvironment('API_BASE_URL');

/// The server on the development machine (owner decision 2026-11-05): the
/// Android emulator reaches it at 10.0.2.2, iOS Simulator at localhost. A
/// phone passes the machine's address in `API_BASE_URL`. A release build has
/// no default: each flavor's build passes its address.
String apiBaseUrl() {
  if (_apiBaseUrl.isNotEmpty) return _apiBaseUrl;
  if (kReleaseMode) {
    throw StateError('A release build needs --dart-define=API_BASE_URL.');
  }
  return defaultTargetPlatform == TargetPlatform.android
      ? 'http://10.0.2.2:3000'
      : 'http://localhost:3000';
}

/// The client of the sign-in routes, without the session's interceptor
/// (`packages/core_auth/CLAUDE.md`).
final authApiProvider = Provider<CoreApi>((ref) => apiClient(apiBaseUrl()));

/// The generated client (E6); the only way the app reaches the server. It
/// sends the session's token and renews it.
final coreApiProvider = Provider<CoreApi>((ref) {
  final api = apiClient(apiBaseUrl());
  api.dio.interceptors
    ..add(ServerTimeInterceptor(ref.watch(serverClockProvider)))
    ..add(captainAuth.interceptor(ref, api.dio));
  return api;
});

/// The server's clock, which every countdown and every point's time uses
/// (CA §4.6).
final serverClockProvider = Provider<ServerClock>((ref) => ServerClock());

/// The signed-in captain (its id names the channel), or null while signed
/// out. Read again at every sign-in.
final captainSessionProvider = FutureProvider<CaptainSessionDtoOutput?>((
  ref,
) async {
  final session = await ref.watch(captainAuth.session.future);
  if (session is! SignedIn) return null;
  final response = await ref
      .watch(coreApiProvider)
      .getCaptainApi()
      .captainAuthCurrent();
  return response.data;
});

/// Centrifugo's address: `--dart-define=REALTIME_URL=...`, or derived from
/// the API's (`packages/core_realtime/CLAUDE.md`).
const _realtimeUrl = String.fromEnvironment('REALTIME_URL');

/// The app's one real-time connection (architecture §6.1), with a token from
/// `POST /v1/captain/realtime/token`.
final realtimeTransportProvider = Provider<RealtimeTransport>((ref) {
  return CentrifugeTransport(
    url: _realtimeUrl.isNotEmpty ? _realtimeUrl : realtimeUrl(apiBaseUrl()),
    token: () async {
      final session = await ref.read(captainAuth.session.future);
      if (session is! SignedIn) throw const RealtimeSignedOut();
      try {
        final answer = await ref
            .read(coreApiProvider)
            .getCaptainApi()
            .captainRealtimeToken();
        return answer.data!.token;
      } on DioException catch (error) {
        if (error.response?.statusCode == 401 ||
            error.response?.statusCode == 403) {
          throw const RealtimeSignedOut();
        }
        rethrow;
      }
    },
  );
});
