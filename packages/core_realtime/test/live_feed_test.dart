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

// Lets the pending stream events and fetches run: they are futures, all run
// before a timer, so the 5 ms is never what a test waits for.
Future<void> settle() => Future<void>.delayed(const Duration(milliseconds: 5));

// Waits until [done] holds, checked every 5 ms for up to 5 s: the polls run on
// real timers, which fire late on a loaded machine, so a fixed wait for a
// number of them fails there.
Future<void> until(bool Function() done) async {
  final waited = Stopwatch()..start();
  while (!done()) {
    if (waited.elapsed > const Duration(seconds: 5)) {
      fail('still waiting after 5 s');
    }
    await settle();
  }
}

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
    await until(() => fetches >= 3);
    transport.send('merchant:r1', const RealtimeUp(recovered: true));
    await settle();
    final atUp = fetches;
    // Two and a half polls' time, in which a poll that did not stop would
    // fetch (a timer fires late, never early).
    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(fetches, atUp);
    transport.send('merchant:r1', const RealtimeDown());
    await settle();
    expect(feed.state.live, isFalse);
    await until(() => fetches > atUp);
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
    await until(() => !feed.state.failed);
  });

  test('refreshes during a fetch make one more fetch after it', () async {
    feed.start();
    unawaited(feed.refresh());
    unawaited(feed.refresh());
    await settle();
    expect(fetches, 2);
  });

  test('watch() gives the current state, then each new one', () async {
    feed.start();
    await settle();
    final seen = <Map<String, int>?>[];
    final watching = feed.watch().listen((state) => seen.add(state.value));
    await settle();
    answers = [
      {'a': 2},
    ];
    await feed.refresh();
    await settle();
    expect(seen, [
      {'a': 1},
      {'a': 2},
    ]);
    await watching.cancel();
  });
}
