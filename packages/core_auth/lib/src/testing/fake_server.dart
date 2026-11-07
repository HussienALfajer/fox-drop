import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:core_api/core_api.dart';
import 'package:dio/dio.dart';

/// An answer of [FakeServer]: a status and a JSON body, or no answer at all.
class FakeAnswer {
  const FakeAnswer(this.status, [this.body = const {}, this.headers]);

  /// The connection fails before any answer.
  const FakeAnswer.none() : status = 0, body = null, headers = null;

  final int status;
  final Object? body;
  final Map<String, String>? headers;
}

/// Answers the client's requests by path, so tests need no server. A route
/// gets each of its answers in turn and keeps the last.
class FakeServer implements HttpClientAdapter {
  final Map<String, List<FakeAnswer>> routes = {};
  final List<RequestOptions> requests = [];

  /// Completes each answer after the gate, when set.
  Completer<void>? gate;

  void on(String path, List<FakeAnswer> answers) => routes[path] = answers;

  List<RequestOptions> to(String path) =>
      requests.where((r) => r.uri.path == path).toList();

  /// A client on this fake, with no interceptors.
  CoreApi client() {
    final api = CoreApi(
      basePathOverride: 'https://api.example.test',
      interceptors: [],
    );
    api.dio.httpClientAdapter = this;
    return api;
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    // A copy: a repeated call sends the same options with a new header.
    requests.add(options.copyWith(headers: Map.of(options.headers)));
    await gate?.future;
    final answers = routes[options.uri.path];
    if (answers == null || answers.isEmpty) {
      return ResponseBody.fromString('{}', 404);
    }
    final answer = answers.length > 1 ? answers.removeAt(0) : answers.first;
    if (answer.status == 0) throw StateError('connection failed');
    return ResponseBody.fromString(
      jsonEncode(answer.body),
      answer.status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
        for (final entry in (answer.headers ?? {}).entries)
          entry.key: [entry.value],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

/// A token answer of the refresh and sign-in routes.
Map<String, Object?> tokens(String suffix, DateTime expiresAt) => {
  'accessToken': 'access-$suffix',
  'accessTokenExpiresAt': expiresAt.toUtc().toIso8601String(),
  'refreshToken': 'refresh-$suffix',
};
