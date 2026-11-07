import 'package:core_api/core_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth.dart';

/// The server address, set with `--dart-define=API_BASE_URL=...`.
const _apiBaseUrl = String.fromEnvironment('API_BASE_URL');

/// The server on the development machine (owner decision 2026-11-05): the
/// Android emulator reaches it at 10.0.2.2, Windows at localhost. A
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
final authApiProvider = Provider<CoreApi>(
  (ref) => CoreApi(basePathOverride: apiBaseUrl(), interceptors: []),
);

/// The generated client (E6); the only way the app reaches the server. It
/// sends the session's token and renews it.
final coreApiProvider = Provider<CoreApi>((ref) {
  final api = CoreApi(basePathOverride: apiBaseUrl(), interceptors: []);
  api.dio.interceptors.add(merchantAuth.interceptor(ref, api.dio));
  return api;
});

final statusProvider = FutureProvider<StatusDtoOutput>((ref) async {
  final response = await ref
      .watch(coreApiProvider)
      .getMerchantApi()
      .merchantStatusGet();
  return response.data!;
});
