import 'package:core_push/core_push.dart';
import 'package:core_push/testing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakePush push;
  late List<String> registered;
  late int failures;
  late PushTokens tokens;

  setUp(() {
    push = FakePush();
    registered = [];
    failures = 0;
    tokens = PushTokens(
      push,
      (token) async {
        if (failures > 0) {
          failures--;
          throw StateError('offline');
        }
        registered.add(token);
      },
      firstRetry: const Duration(milliseconds: 10),
      lastRetry: const Duration(milliseconds: 20),
    );
  });

  tearDown(() => tokens.dispose());

  // Lets the pending futures run; with `ms`, a window for a retry that must
  // not come (a timer fires late on a loaded machine, never early).
  Future<void> settle([int ms = 0]) =>
      Future<void>.delayed(Duration(milliseconds: ms));

  // Waits until [done] holds, checked every 5 ms for up to 5 s: the retries
  // run on real timers, so a fixed wait for them fails on a loaded machine.
  Future<void> until(bool Function() done) async {
    final waited = Stopwatch()..start();
    while (!done()) {
      if (waited.elapsed > const Duration(seconds: 5)) {
        fail('still waiting after 5 s');
      }
      await settle(5);
    }
  }

  test('registers the token at sign-in and each renewal', () async {
    tokens.signedIn();
    await settle();
    push.renew('push-token-1');
    await settle();
    expect(registered, ['push-token-0', 'push-token-1']);
  });

  test('signing in again while signed in registers nothing more', () async {
    tokens.signedIn();
    tokens.signedIn();
    await settle();
    expect(registered, ['push-token-0']);
  });

  test('registers nothing while signed out', () async {
    tokens.signedIn();
    await settle();
    tokens.signedOut();
    push.renew('push-token-1');
    await settle();
    expect(registered, ['push-token-0']);
  });

  test('no token, no registration', () async {
    push.currentToken = null;
    tokens.signedIn();
    await settle();
    expect(registered, isEmpty);
  });

  test('a failed registration is tried again while signed in', () async {
    failures = 2;
    tokens.signedIn();
    await until(() => registered.isNotEmpty);
    expect(registered, ['push-token-0']);
  });

  test('a sign-out stops the retries', () async {
    failures = 1;
    tokens.signedIn();
    await settle();
    tokens.signedOut();
    // Two retries' time, in which the stopped retry must not register.
    await settle(50);
    expect(registered, isEmpty);
  });

  test('Firebase failing to give a token is tried again', () async {
    push.failures = 2;
    tokens.signedIn();
    await until(() => registered.isNotEmpty);
    expect(registered, ['push-token-0']);
  });

  test('the same token from register and its stream is sent once', () async {
    push.echo = true;
    tokens.signedIn();
    await settle();
    expect(registered, ['push-token-0']);
  });

  test('signing in again registers the token again', () async {
    tokens.signedIn();
    await settle();
    tokens.signedOut();
    tokens.signedIn();
    await settle();
    expect(registered, ['push-token-0', 'push-token-0']);
  });

  test('a renewal replaces the retry of the older token', () async {
    failures = 1;
    tokens.signedIn();
    await settle();
    push.renew('push-token-1');
    await until(() => registered.isNotEmpty);
    // Two retries' time, in which the older token's cancelled retry must not
    // register it.
    await settle(50);
    expect(registered, ['push-token-1']);
  });
}
