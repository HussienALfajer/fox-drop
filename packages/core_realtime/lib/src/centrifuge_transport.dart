import 'dart:async';
import 'dart:convert';

import 'package:centrifuge/centrifuge.dart';

import 'transport.dart';

/// Asks the app's token route (`POST /v1/{party}/realtime/token`) for a
/// connection token. Throw [RealtimeSignedOut] when the session has ended,
/// so the client stops reconnecting.
typedef RealtimeTokenSource = Future<String> Function();

/// The session ended: no token will come.
class RealtimeSignedOut implements Exception {
  const RealtimeSignedOut();
}

/// One Centrifugo connection for the app (architecture §6.1), opened with
/// the first channel listened to and closed with the last. Channel access is
/// checked by the API's subscription proxy, so subscriptions carry no token
/// of their own.
class CentrifugeTransport implements RealtimeTransport {
  CentrifugeTransport({required this.url, required this.token});

  /// `ws(s)://<host>/connection/websocket`.
  final String url;
  final RealtimeTokenSource token;

  Client? _client;
  final Map<String, int> _listeners = {};

  Client _open() {
    final existing = _client;
    if (existing != null) return existing;
    final client = createClient(
      url,
      ClientConfig(
        getToken: (_) async {
          try {
            return await token();
          } on RealtimeSignedOut {
            throw UnauthorizedException();
          }
        },
      ),
    );
    _client = client;
    unawaited(client.connect());
    return client;
  }

  @override
  Stream<RealtimeSignal> channel(String name) {
    late StreamController<RealtimeSignal> controller;
    final subscriptions = <StreamSubscription<Object?>>[];
    Subscription? subscription;
    controller = StreamController<RealtimeSignal>(
      onListen: () {
        final client = _open();
        _listeners.update(name, (n) => n + 1, ifAbsent: () => 1);
        final sub =
            client.getSubscription(name) ?? client.newSubscription(name);
        subscription = sub;
        subscriptions
          ..add(
            sub.subscribed.listen(
              (event) => controller.add(RealtimeUp(recovered: event.recovered)),
            ),
          )
          ..add(
            sub.subscribing.listen((_) => controller.add(const RealtimeDown())),
          )
          ..add(
            sub.unsubscribed.listen(
              (_) => controller.add(const RealtimeDown()),
            ),
          )
          ..add(
            client.disconnected.listen(
              (_) => controller.add(const RealtimeDown()),
            ),
          )
          ..add(
            sub.publication.listen((event) {
              final data = _decode(event.data);
              if (data != null) controller.add(RealtimePublication(data));
            }),
          );
        if (sub.state == SubscriptionState.subscribed) {
          controller.add(const RealtimeUp(recovered: false));
        } else {
          unawaited(sub.subscribe().catchError((Object _) {}));
        }
      },
      onCancel: () async {
        for (final s in subscriptions) {
          await s.cancel();
        }
        final left = (_listeners[name] ?? 1) - 1;
        final client = _client;
        if (left > 0) {
          _listeners[name] = left;
          return;
        }
        _listeners.remove(name);
        final sub = subscription;
        if (client != null && sub != null) {
          await client.removeSubscription(sub);
        }
        if (_listeners.isEmpty && client != null) {
          _client = null;
          await client.disconnect();
        }
      },
    );
    return controller.stream;
  }

  static Map<String, Object?>? _decode(List<int> data) {
    try {
      final value = jsonDecode(utf8.decode(data));
      return value is Map<String, Object?> ? value : null;
    } on FormatException {
      return null;
    }
  }
}
