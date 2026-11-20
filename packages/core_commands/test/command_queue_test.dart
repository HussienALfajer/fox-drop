import 'package:core_commands/core_commands.dart';
import 'package:core_storage/core_storage.dart';
import 'package:flutter_test/flutter_test.dart';

QueuedCommand command(String key, DateTime at, {String kind = 'accept'}) =>
    QueuedCommand(
      key: key,
      kind: kind,
      subject: 'order-1',
      accountId: 'account-1',
      args: {'prepMin': 20},
      queuedAt: at,
    );

void main() {
  final now = DateTime.utc(2026, 11, 20, 12);

  test('keeps the commands across a restart until each is answered', () async {
    final store = MemoryDeviceStore();
    await CommandQueue(store).put(command('k1', now));
    await CommandQueue(store).put(command('k2', now, kind: 'ready'));
    // A new queue on the same store is the app started again.
    final again = CommandQueue(store);
    final pending = await again.pending(now);
    expect(pending.map((each) => each.key), ['k1', 'k2']);
    expect(pending.first.args, {'prepMin': 20});
    expect(pending.first.identity, 'order-1 accept {"prepMin":20}');
    await again.remove('k1');
    expect((await again.pending(now)).map((each) => each.key), ['k2']);
    await again.remove('k2');
    expect(await store.read(CommandQueue.storeKey), isNull);
  });

  test('drops a command past the server’s 24 hours of keys', () async {
    final queue = CommandQueue(MemoryDeviceStore());
    await queue.put(command('old', now.subtract(const Duration(hours: 24))));
    await queue.put(command('new', now.subtract(const Duration(hours: 23))));
    expect((await queue.pending(now)).map((each) => each.key), ['new']);
  });

  test('writes in turn, so two quick commands are both kept', () async {
    final queue = CommandQueue(MemoryDeviceStore());
    await Future.wait([
      queue.put(command('a', now)),
      queue.put(command('b', now)),
    ]);
    expect((await queue.pending(now)).length, 2);
  });

  test('retries only what has no answer, after a growing wait', () {
    expect(unanswered(null), isTrue);
    expect(unanswered(503), isTrue);
    expect(unanswered(429), isTrue);
    expect(unanswered(409), isFalse);
    expect(unanswered(200), isFalse);
    expect(retryDelay(0).inMilliseconds, inInclusiveRange(500, 1000));
    expect(retryDelay(10).inMilliseconds, inInclusiveRange(7500, 15000));
  });
}
