import 'package:dio/dio.dart';

/// The server's clock as this device sees it (RA §4.7, architecture §11.2):
/// the device's clock moved by the offset the latest `Server-Time` header
/// showed, so a wrong phone clock never changes a countdown.
class ServerClock {
  ServerClock({DateTime Function()? deviceNow})
    : _deviceNow = deviceNow ?? DateTime.now;

  final DateTime Function() _deviceNow;

  /// The server's clock minus the device's; zero until the first answer.
  Duration offset = Duration.zero;

  /// The server's time now.
  DateTime now() => _deviceNow().add(offset);

  /// The time left until [at] on the server's clock, never negative.
  Duration until(DateTime at) {
    final left = at.difference(now());
    return left.isNegative ? Duration.zero : left;
  }

  /// The time since [at] on the server's clock, never negative.
  Duration since(DateTime at) {
    final past = now().difference(at);
    return past.isNegative ? Duration.zero : past;
  }

  /// Records an answer's `Server-Time` (Unix milliseconds), read as the
  /// answer arrives. The answer took some time to travel, so the offset is
  /// off by at most one trip, which a countdown in seconds does not show.
  void observe(String? serverTime) {
    final millis = serverTime == null ? null : int.tryParse(serverTime.trim());
    if (millis == null) return;
    final server = DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true);
    offset = server.difference(_deviceNow());
  }
}

/// Feeds [clock] with the `Server-Time` header of every answer, refusals
/// included (the server sends it on each one, `apps/server/CLAUDE.md`).
class ServerTimeInterceptor extends Interceptor {
  ServerTimeInterceptor(this.clock);

  final ServerClock clock;

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    clock.observe(response.headers.value('server-time'));
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;
    if (response != null) clock.observe(response.headers.value('server-time'));
    handler.next(err);
  }
}
