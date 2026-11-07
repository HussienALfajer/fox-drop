import 'dart:typed_data';

import 'package:core_time/core_time.dart';
import 'package:dio/dio.dart';
import 'package:test/test.dart';

void main() {
  final deviceAt = DateTime.utc(2026, 11, 7, 12);
  ServerClock clockAt(DateTime device) => ServerClock(deviceNow: () => device);

  test('runs on the device clock until the first answer', () {
    expect(clockAt(deviceAt).now(), deviceAt);
  });

  test('moves the device clock by the offset of Server-Time', () {
    final clock = clockAt(deviceAt);
    // The phone is 5 minutes ahead of the server.
    final server = deviceAt.subtract(const Duration(minutes: 5));
    clock.observe('${server.millisecondsSinceEpoch}');
    expect(clock.offset, const Duration(minutes: -5));
    expect(clock.now(), server);
    expect(
      clock.until(server.add(const Duration(seconds: 90))),
      const Duration(seconds: 90),
    );
    expect(
      clock.since(server.subtract(const Duration(minutes: 2))),
      const Duration(minutes: 2),
    );
  });

  test('never counts below zero', () {
    final clock = clockAt(deviceAt);
    expect(
      clock.until(deviceAt.subtract(const Duration(seconds: 1))),
      Duration.zero,
    );
    expect(
      clock.since(deviceAt.add(const Duration(seconds: 1))),
      Duration.zero,
    );
  });

  test('ignores a missing or malformed header', () {
    final clock = clockAt(deviceAt)..offset = const Duration(seconds: 3);
    clock.observe(null);
    clock.observe('soon');
    expect(clock.offset, const Duration(seconds: 3));
  });

  test('reads the header of answers and refusals', () async {
    final clock = clockAt(deviceAt);
    final adapter = _Answers();
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.test'))
      ..httpClientAdapter = adapter
      ..interceptors.add(ServerTimeInterceptor(clock));

    adapter.answer(200, deviceAt.add(const Duration(seconds: 40)));
    await dio.get<Object?>('/v1/merchant/orders');
    expect(clock.offset, const Duration(seconds: 40));

    adapter.answer(409, deviceAt.add(const Duration(seconds: 10)));
    await expectLater(
      dio.post<Object?>('/v1/merchant/orders/x/accept'),
      throwsA(isA<DioException>()),
    );
    expect(clock.offset, const Duration(seconds: 10));
  });
}

class _Answers implements HttpClientAdapter {
  int _status = 200;
  DateTime _server = DateTime.utc(2026);

  void answer(int status, DateTime server) {
    _status = status;
    _server = server;
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => ResponseBody.fromString(
    '{}',
    _status,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
      'server-time': ['${_server.millisecondsSinceEpoch}'],
    },
  );

  @override
  void close({bool force = false}) {}
}
