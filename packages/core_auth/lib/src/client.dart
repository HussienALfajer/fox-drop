import 'package:core_api/core_api.dart';
import 'package:dio/dio.dart';

/// How long a call may wait for the server's answer. A code request waits up
/// to 10 seconds for the WhatsApp sender before the server answers `503
/// unavailable` (the identity module's SEND_ANSWER_TIMEOUT_MS), so the app
/// must wait longer, or «لديّ رمز من العمليات» never shows.
const receiveTimeout = Duration(seconds: 20);

const connectTimeout = Duration(seconds: 10);

/// A generated client for [baseUrl] with no interceptors and the timeouts
/// above; the app adds the session's interceptor to its main client.
CoreApi apiClient(String baseUrl) => CoreApi(
  dio: Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
    ),
  ),
  interceptors: [],
);
