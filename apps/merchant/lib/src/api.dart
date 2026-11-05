import 'package:core_api/core_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The server address, set with `--dart-define=API_BASE_URL=...`.
const _apiBaseUrl = String.fromEnvironment('API_BASE_URL');

/// The server on the development machine (owner decision 2026-11-05): the
/// Android emulator reaches it at 10.0.2.2, Windows at localhost. A
/// phone passes the machine's address in `API_BASE_URL`. A release build has
/// no default: the deploy slice gives each flavor its address.
String apiBaseUrl() {
  if (_apiBaseUrl.isNotEmpty) return _apiBaseUrl;
  if (kReleaseMode) {
    throw StateError('A release build needs --dart-define=API_BASE_URL.');
  }
  return defaultTargetPlatform == TargetPlatform.android
      ? 'http://10.0.2.2:3000'
      : 'http://localhost:3000';
}

/// The generated client (E6); the only way the app reaches the server.
final coreApiProvider = Provider<CoreApi>(
  (ref) => CoreApi(basePathOverride: apiBaseUrl()),
);

final statusProvider = FutureProvider<StatusDtoOutput>((ref) async {
  final response = await ref
      .watch(coreApiProvider)
      .getMerchantApi()
      .merchantStatusGet();
  return response.data!;
});
