import 'dart:async';

import 'package:core_realtime/core_realtime.dart';
import 'package:test/test.dart';

class FakeTransport implements RealtimeTransport {
  final channels = <String, StreamController<RealtimeSignal>>{};

  @override
  Stream<RealtimeSignal> channel(String name) =>
      (channels[name] = StreamController<RealtimeSignal>()).stream;

  void send(String name, RealtimeSignal signal) => channels[name]!.add(signal);
}

Map<String, Object?> event(String orderId, int version, [String? type]) => {
  'orderId': orderId,
  'version': version,
  'type': ?type,
};

Future<void> settle() => Future<void>.delayed(const Duration(milliseconds: 5));

void main() {
  late FakeTransport transport;
  late List<Map<String, int>> answers;
  late int fetches;
  late bool failing;
  late LiveFeed<Map<String, int>> feed;

  setUp(() {
    transport = FakeTransport();
    answers = [
      {'a': 1},
    ];
    fetches = 0;
    failing = false;
    feed = LiveFeed(
      transport: transport,
      channel: 'merchant:r1',
      fetch: () async {
        fetches++;
        if (failing) throw StateError('no answer');
        return answers.length > 1 ? answers.removeAt(0) : answers.first;
      },
      versions: (state) => state,
      pollEvery: const Duration(milliseconds: 40),
    );
  });

  tearDown(() => feed.close());

  test('fetches the full state at start and shows it', () async {
    feed.start();
    await settle();
    expect(fetches, 1);
    expect(feed.state.value, {'a': 1});
    expect(feed.state.live, isFalse);
  });

  test('fetches again after a subscription without recovery only', () async {
    feed.start();
    await settle();
    transport.send('merchant:r1', const RealtimeUp(recovered: true));
    await settle();
    expect(fetches, 1);
    expect(feed.state.live, isTrue);
    transport.send('merchant:r1', const RealtimeUp(recovered: false));
    await settle();
    expect(fetches, 2);
  });

  test('a newer event fetches; an older or repeated one is ignored', () async {
    answers = [
      {'a': 3},
      {'a': 4},
    ];
    feed.start();
    final events = <Map<String, Object?>>[];
    feed.events.listen(events.add);
    transport.send('merchant:r1', const RealtimeUp(recovered: true));
    await settle();
    transport.send('merchant:r1', RealtimePublication(event('a', 2)));
    transport.send('merchant:r1', RealtimePublication(event('a', 3)));
    await settle();
    expect(fetches, 1);
    transport.send(
      'merchant:r1',
      RealtimePublication(event('a', 4, 'order.ready')),
    );
    transport.send('merchant:r1', RealtimePublication(event('a', 4)));
    await settle();
    expect(fetches, 2);
    expect(events.map((e) => e['type']), ['order.ready']);
    expect(feed.state.value, {'a': 4});
  });

  test('an order not in the state yet is new', () async {
    feed.start();
    transport.send('merchant:r1', const RealtimeUp(recovered: true));
    await settle();
    transport.send(
      'merchant:r1',
      RealtimePublication(event('b', 1, 'order.placed')),
    );
    await settle();
    expect(fetches, 2);
  });

  test('a late repeat of an order that left the state is ignored', () async {
    answers = [
      {'a': 1},
      {},
    ];
    feed.start();
    transport.send('merchant:r1', const RealtimeUp(recovered: true));
    await settle();
    transport.send('merchant:r1', RealtimePublication(event('a', 2)));
    await settle();
    expect(feed.state.value, isEmpty);
    transport.send('merchant:r1', RealtimePublication(event('a', 2)));
    await settle();
    expect(fetches, 2);
  });

  test('polls while the channel is down, and stops once it is up', () async {
    feed.start();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(fetches, greaterThanOrEqualTo(3));
    transport.send('merchant:r1', const RealtimeUp(recovered: true));
    await settle();
    final atUp = fetches;
    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(fetches, atUp);
    transport.send('merchant:r1', const RealtimeDown());
    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(feed.state.live, isFalse);
    expect(fetches, greaterThan(atUp));
  });

  test('keeps the last state after a failed fetch, and tries again', () async {
    feed.start();
    transport.send('merchant:r1', const RealtimeUp(recovered: true));
    await settle();
    failing = true;
    await feed.refresh();
    expect(feed.state.failed, isTrue);
    expect(feed.state.value, {'a': 1});
    failing = false;
    await Future<void>.delayed(const Duration(milliseconds: 80));
    expect(feed.state.failed, isFalse);
  });

  test('refreshes during a fetch make one more fetch after it', () async {
    feed.start();
    unawaited(feed.refresh());
    unawaited(feed.refresh());
    await settle();
    expect(fetches, 2);
  });

  test('show() puts a command answer up and counts its version', () async {
    feed.start();
    transport.send('merchant:r1', const RealtimeUp(recovered: true));
    await settle();
    feed.show({'a': 5});
    expect(feed.state.value, {'a': 5});
    transport.send('merchant:r1', RealtimePublication(event('a', 5)));
    await settle();
    expect(fetches, 1);
  });
}
