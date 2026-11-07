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

/// Makes the Centrifugo client; tests pass a fake.
typedef ClientFactory = Client Function(String url, ClientConfig config);

/// One Centrifugo connection for the app (architecture §6.1), opened with
/// the first channel listened to and closed with the last. Channel access is
/// checked by the API's subscription proxy, so subscriptions carry no token
/// of their own.
class CentrifugeTransport implements RealtimeTransport {
  CentrifugeTransport({
    required this.url,
    required this.token,
    ClientFactory? client,
  }) : _factory = client ?? createClient;

  /// `ws(s)://<host>/connection/websocket`.
  final String url;
  final RealtimeTokenSource token;
  final ClientFactory _factory;

  Client? _client;
  final Map<String, int> _listeners = {};

  Client _open() {
    final existing = _client;
    if (existing != null) {
      // A client that stopped for good (the session ended, then a new one
      // began) connects again with a new token.
      if (existing.state == State.disconnected) {
        unawaited(existing.connect().catchError((Object _) {}));
      }
      return existing;
    }
    final client = _factory(
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
    unawaited(client.connect().catchError((Object _) {}));
    return client;
  }

  @override
  Stream<RealtimeSignal> channel(String name) {
    late StreamController<RealtimeSignal> controller;
    final subscriptions = <StreamSubscription<Object?>>[];
    controller = StreamController<RealtimeSignal>(
      onListen: () {
        final client = _open();
        _listeners.update(name, (n) => n + 1, ifAbsent: () => 1);
        final sub =
            client.getSubscription(name) ?? client.newSubscription(name);
        void down(Object? _) => controller.add(const RealtimeDown());
        subscriptions.addAll([
          sub.subscribed.listen(
            (event) => controller.add(RealtimeUp(recovered: event.recovered)),
          ),
          sub.subscribing.listen(down),
          sub.unsubscribed.listen(down),
          client.disconnected.listen(down),
          sub.publication.listen((event) {
            final data = _decode(event.data);
            if (data != null) controller.add(RealtimePublication(data));
          }),
        ]);
        if (sub.state == SubscriptionState.subscribed) {
          // A second listener on a live subscription: it has seen no
          // publication yet, so it fetches the full state.
          controller.add(const RealtimeUp(recovered: false));
        } else if (sub.state == SubscriptionState.unsubscribed) {
          unawaited(sub.subscribe().catchError((Object _) {}));
        }
      },
      onCancel: () async {
        for (final s in subscriptions) {
          await s.cancel();
        }
        final left = (_listeners[name] ?? 1) - 1;
        if (left > 0) {
          _listeners[name] = left;
          return;
        }
        _listeners.remove(name);
        final client = _client;
        if (client == null) return;
        final sub = client.getSubscription(name);
        if (sub != null) await client.removeSubscription(sub);
        if (_listeners.isEmpty && identical(_client, client)) {
          _client = null;
          await client.close();
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
