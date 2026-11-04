import 'dart:convert';
import 'dart:typed_data';

import 'package:core_api/core_api.dart';
import 'package:dio/dio.dart';
import 'package:test/test.dart';

/// Answers every request with [body] and records the requests.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.body);

  final Map<String, Object> body;
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      jsonEncode(body),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
        'server-time': ['1'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test('reads a route as its typed model', () async {
    final adapter = _FakeAdapter({'status': 'ok', 'serverTime': 1});
    final api = CoreApi(basePathOverride: 'https://api.example.test');
    api.dio.httpClientAdapter = adapter;

    final response = await api.getAdminApi().adminStatusGet();

    final StatusDtoOutput status = response.data!;
    expect(status.status, StatusDtoOutputStatusEnum.ok);
    expect(status.serverTime, 1);
    expect(
      adapter.requests.single.uri.toString(),
      'https://api.example.test/v1/admin/status',
    );
  });
}
