import 'dart:async';
import 'dart:convert';

import 'package:centrifuge/centrifuge.dart';
import 'package:core_realtime/core_realtime.dart';
import 'package:fixnum/fixnum.dart';
import 'package:test/test.dart';

class FakeSubscription implements Subscription {
  FakeSubscription(this.channel);

  @override
  final String channel;
  @override
  SubscriptionState state = SubscriptionState.unsubscribed;
  int subscribes = 0;

  final subscribedEvents = StreamController<SubscribedEvent>.broadcast();
  final subscribingEvents = StreamController<SubscribingEvent>.broadcast();
  final unsubscribedEvents = StreamController<UnsubscribedEvent>.broadcast();
  final publications = StreamController<PublicationEvent>.broadcast();

  @override
  Stream<SubscribedEvent> get subscribed => subscribedEvents.stream;
  @override
  Stream<SubscribingEvent> get subscribing => subscribingEvents.stream;
  @override
  Stream<UnsubscribedEvent> get unsubscribed => unsubscribedEvents.stream;
  @override
  Stream<PublicationEvent> get publication => publications.stream;

  @override
  Future<void> subscribe() async {
    subscribes++;
    state = SubscriptionState.subscribing;
  }

  void up({bool recovered = false}) {
    state = SubscriptionState.subscribed;
    subscribedEvents.add(
      SubscribedEvent(false, recovered, const [], null, false, true),
    );
  }

  void send(Map<String, Object?> data) => publications.add(
    PublicationEvent(utf8.encode(jsonEncode(data)), Int64(1), null, const {}),
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeClient implements Client {
  FakeClient(this.config);

  final ClientConfig config;
  @override
  State state = State.disconnected;
  int connects = 0;
  bool closed = false;
  final subs = <String, FakeSubscription>{};
  final removed = <String>[];
  final disconnectedEvents = StreamController<DisconnectedEvent>.broadcast();

  @override
  Stream<DisconnectedEvent> get disconnected => disconnectedEvents.stream;

  @override
  Future<void> connect() async {
    connects++;
    state = State.connecting;
  }

  @override
  Future<void> close() async => closed = true;

  @override
  Subscription? getSubscription(String channel) => subs[channel];

  @override
  Subscription newSubscription(String channel, [SubscriptionConfig? config]) =>
      subs[channel] = FakeSubscription(channel);

  @override
  Future<void> removeSubscription(Subscription subscription) async {
    removed.add(subscription.channel);
    subs.remove(subscription.channel);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<void> settle() => Future<void>.delayed(Duration.zero);

void main() {
  late List<FakeClient> clients;
  late CentrifugeTransport transport;
  var signedOut = false;

  setUp(() {
    clients = [];
    signedOut = false;
    transport = CentrifugeTransport(
      url: 'ws://localhost:8000/connection/websocket',
      token: () async {
        if (signedOut) throw const RealtimeSignedOut();
        return 'token';
      },
      client: (url, config) {
        final client = FakeClient(config);
        clients.add(client);
        return client;
      },
    );
  });

  test(
    'connects with the first channel and turns events into signals',
    () async {
      final signals = <RealtimeSignal>[];
      final listening = transport.channel('merchant:r1').listen(signals.add);
      await settle();
      final client = clients.single;
      final sub = client.subs['merchant:r1']!;
      expect(client.connects, 1);
      expect(sub.subscribes, 1);

      sub.up(recovered: true);
      sub.send({'orderId': 'a', 'version': 2});
      sub.publications.add(
        PublicationEvent(utf8.encode('not json'), Int64(2), null, const {}),
      );
      client.disconnectedEvents.add(DisconnectedEvent(3, 'transport closed'));
      await settle();
      expect(signals, [
        isA<RealtimeUp>().having((s) => s.recovered, 'recovered', true),
        isA<RealtimePublication>().having(
          (s) => s.data['version'],
          'version',
          2,
        ),
        isA<RealtimeDown>(),
      ]);
      await listening.cancel();
    },
  );

  test(
    'a second listener shares the subscription and fetches in full',
    () async {
      final first = transport.channel('merchant:r1').listen((_) {});
      await settle();
      clients.single.subs['merchant:r1']!.up(recovered: true);
      final signals = <RealtimeSignal>[];
      final second = transport.channel('merchant:r1').listen(signals.add);
      await settle();
      expect(clients, hasLength(1));
      expect(clients.single.subs['merchant:r1']!.subscribes, 1);
      expect(
        signals.single,
        isA<RealtimeUp>().having((s) => s.recovered, 'r', false),
      );

      await first.cancel();
      expect(clients.single.removed, isEmpty);
      expect(clients.single.closed, isFalse);
      await second.cancel();
      expect(clients.single.removed, ['merchant:r1']);
      expect(clients.single.closed, isTrue);
    },
  );

  test(
    'the last channel closes the client; the next one opens another',
    () async {
      final a = transport.channel('order:a').listen((_) {});
      final b = transport.channel('order:b').listen((_) {});
      await settle();
      await a.cancel();
      expect(clients.single.closed, isFalse);
      await b.cancel();
      expect(clients.single.closed, isTrue);
      final c = transport.channel('order:c').listen((_) {});
      await settle();
      expect(clients, hasLength(2));
      await c.cancel();
    },
  );

  test(
    'a signed-out session stops the client; a new channel reconnects it',
    () async {
      final first = transport.channel('merchant:r1').listen((_) {});
      await settle();
      final client = clients.single;
      signedOut = true;
      await expectLater(
        client.config.getToken!(ConnectionTokenEvent()),
        throwsA(isA<UnauthorizedException>()),
      );
      client.state = State.disconnected;
      signedOut = false;
      final second = transport.channel('order:a').listen((_) {});
      await settle();
      expect(clients, hasLength(1));
      expect(client.connects, 2);
      await first.cancel();
      await second.cancel();
    },
  );
}
