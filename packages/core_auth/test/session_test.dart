import 'dart:async';
import 'dart:convert';

import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:core_storage/core_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:core_auth/testing.dart';

final _now = DateTime.utc(2026, 11, 7, 12);

/// The stored values of a signed-in captain whose access token expires at
/// [expiresAt].
Map<String, String> _signedIn(DateTime expiresAt) => {
  'session': jsonEncode({
    'accessToken': 'access-0',
    'accessTokenExpiresAt': expiresAt.toIso8601String(),
    'refreshToken': 'refresh-0',
    'accountId': 'account-1',
  }),
};

/// The stored refresh token, or null when signed out.
String? _storedRefresh(MemorySecureStore store) {
  final value = store.values['session'];
  if (value == null) return null;
  return (jsonDecode(value) as Map)['refreshToken'] as String;
}

class _Harness {
  _Harness(Map<String, String> stored) : store = MemorySecureStore(stored) {
    scope = AuthScope(
      party: (ref) => CaptainAuth(server.client()),
      clock: () => _now,
      refreshRetryWindow: const Duration(milliseconds: 60),
      refreshRetryPause: const Duration(milliseconds: 25),
    );
    container = ProviderContainer(
      overrides: [scope.store.overrideWithValue(store)],
      retry: (retryCount, error) => null,
    );
    app = server.client();
    app.dio.interceptors.add(
      AuthInterceptor(() => container.read(scope.session.notifier), app.dio),
    );
  }

  final server = FakeServer();
  final MemorySecureStore store;
  late final AuthScope scope;
  late final ProviderContainer container;
  late final CoreApi app;

  SessionController get session => container.read(scope.session.notifier);

  Future<SessionState> state() => container.read(scope.session.future);
}

const _refresh = '/v1/captain/auth/refresh';
const _current = '/v1/captain/auth/session';

Map<String, Object?> _session() => {
  'accountId': '00000000-0000-4000-8000-000000000001',
  'captainId': '00000000-0000-4000-8000-000000000002',
  'sessionId': '00000000-0000-4000-8000-000000000003',
};

void main() {
  test('starts signed out with nothing stored', () async {
    final h = _Harness({});
    addTearDown(h.container.dispose);
    final state = await h.state();
    expect(state, isA<SignedOut>());
    expect((state as SignedOut).reason, isNull);
    expect(await h.session.accessToken(), isNull);
  });

  test('keeps the session across starts and one device id', () async {
    final h = _Harness(_signedIn(_now.add(const Duration(minutes: 10))));
    addTearDown(h.container.dispose);
    expect(await h.state(), isA<SignedIn>());
    expect(await h.session.accessToken(), 'access-0');
    final id = await h.session.deviceId();
    expect(id, matches(RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-')));
    expect(await h.session.deviceId(), id);
    expect(h.server.requests, isEmpty);
  });

  test('renews a token about to expire once for concurrent calls', () async {
    final h = _Harness(_signedIn(_now.add(const Duration(seconds: 30))));
    addTearDown(h.container.dispose);
    await h.state();
    h.server.on(_refresh, [
      FakeAnswer(200, tokens('1', _now.add(const Duration(minutes: 15)))),
    ]);
    h.server.gate = Completer<void>();
    final calls = [
      h.session.accessToken(),
      h.session.accessToken(),
      h.session.accessToken(),
    ];
    await Future<void>.delayed(Duration.zero);
    h.server.gate!.complete();
    expect(await Future.wait(calls), ['access-1', 'access-1', 'access-1']);
    expect(h.server.to(_refresh), hasLength(1));
    expect(_storedRefresh(h.store), 'refresh-1');
  });

  test('retries a refresh that got no answer with the same token', () async {
    final h = _Harness(_signedIn(_now));
    addTearDown(h.container.dispose);
    await h.state();
    h.server.on(_refresh, [
      const FakeAnswer.none(),
      FakeAnswer(200, tokens('1', _now.add(const Duration(minutes: 15)))),
    ]);
    expect(await h.session.refresh(), isTrue);
    final sent = h.server
        .to(_refresh)
        .map((r) => (r.data as Map)['refreshToken']);
    expect(sent, ['refresh-0', 'refresh-0']);
  });

  test('keeps the session when no refresh answer comes at all', () async {
    final h = _Harness(_signedIn(_now));
    addTearDown(h.container.dispose);
    await h.state();
    h.server.on(_refresh, [const FakeAnswer.none()]);
    expect(await h.session.refresh(), isFalse);
    expect(h.server.to(_refresh).length, inInclusiveRange(2, 4));
    expect(await h.state(), isA<SignedIn>());
  });

  test('ends the session when the server refuses the refresh', () async {
    final h = _Harness(_signedIn(_now));
    addTearDown(h.container.dispose);
    await h.state();
    h.server.on(_refresh, [
      const FakeAnswer(401, {'statusCode': 401}),
    ]);
    expect(await h.session.refresh(), isFalse);
    expect(((await h.state()) as SignedOut).reason, SessionEndReason.ended);
    expect(_storedRefresh(h.store), isNull);
  });

  test('a captain signed in elsewhere ends with other_device', () async {
    final h = _Harness(_signedIn(_now));
    addTearDown(h.container.dispose);
    await h.state();
    h.server.on(_refresh, [
      const FakeAnswer(401, {'statusCode': 401, 'error': 'other_device'}),
    ]);
    await h.session.refresh();
    expect(
      ((await h.state()) as SignedOut).reason,
      SessionEndReason.otherDevice,
    );
  });

  test(
    'the client sends the token, renews it on a 401 and repeats the call',
    () async {
      final h = _Harness(_signedIn(_now.add(const Duration(minutes: 10))));
      addTearDown(h.container.dispose);
      await h.state();
      h.server.on(_current, [
        const FakeAnswer(401, {'statusCode': 401}),
        FakeAnswer(200, _session()),
      ]);
      h.server.on(_refresh, [
        FakeAnswer(200, tokens('1', _now.add(const Duration(minutes: 15)))),
      ]);
      final response = await h.app.getCaptainApi().captainAuthCurrent();
      expect(response.statusCode, 200);
      final sent = h.server.to(_current).map((r) => r.headers['Authorization']);
      expect(sent, ['Bearer access-0', 'Bearer access-1']);
    },
  );

  test(
    'a 401 other_device on a call ends the session without a refresh',
    () async {
      final h = _Harness(_signedIn(_now.add(const Duration(minutes: 10))));
      addTearDown(h.container.dispose);
      await h.state();
      h.server.on(_current, [
        const FakeAnswer(401, {'statusCode': 401, 'error': 'other_device'}),
      ]);
      await expectLater(
        h.app.getCaptainApi().captainAuthCurrent(),
        throwsA(anything),
      );
      expect(h.server.to(_refresh), isEmpty);
      expect(
        ((await h.state()) as SignedOut).reason,
        SessionEndReason.otherDevice,
      );
    },
  );

  test('signs out on the server, and here even without an answer', () async {
    final h = _Harness(_signedIn(_now.add(const Duration(minutes: 10))));
    addTearDown(h.container.dispose);
    await h.state();
    h.server.on('/v1/captain/auth/sign-out', [const FakeAnswer.none()]);
    await h.session.signOut();
    final sent = h.server.to('/v1/captain/auth/sign-out').single;
    expect(sent.headers['Authorization'], 'Bearer access-0');
    expect(((await h.state()) as SignedOut).reason, SessionEndReason.signedOut);
    expect(h.store.values.keys, isNot(contains('session')));
  });

  test('retries a refresh the proxy answered with 502', () async {
    final h = _Harness(_signedIn(_now));
    addTearDown(h.container.dispose);
    await h.state();
    h.server.on(_refresh, [
      const FakeAnswer(502),
      FakeAnswer(200, tokens('1', _now.add(const Duration(minutes: 15)))),
    ]);
    expect(await h.session.refresh(), isTrue);
    expect(h.server.to(_refresh), hasLength(2));
  });

  test('a refusal of the API itself is not retried', () async {
    final h = _Harness(_signedIn(_now));
    addTearDown(h.container.dispose);
    await h.state();
    h.server.on(_refresh, [
      const FakeAnswer(503, {'error': 'unavailable'}),
    ]);
    expect(await h.session.refresh(), isFalse);
    expect(h.server.to(_refresh), hasLength(1));
    expect(await h.state(), isA<SignedIn>());
  });

  test('an unreadable stored session starts signed out', () async {
    final h = _Harness({'session': 'not json'});
    addTearDown(h.container.dispose);
    expect(await h.state(), isA<SignedOut>());
    expect(h.store.values.keys, isNot(contains('session')));
  });

  test(
    'the expiry follows the server clock, not a wrong phone clock',
    () async {
      final h = _Harness({});
      addTearDown(h.container.dispose);
      // The server's clock is 20 minutes behind this one: its token expiring
      // 15 minutes after its now has already expired here unless moved.
      final serverNow = DateTime.now().subtract(const Duration(minutes: 20));
      h.server.on(_refresh, [
        FakeAnswer(
          200,
          tokens('1', serverNow.add(const Duration(minutes: 15))),
          {'server-time': '${serverNow.millisecondsSinceEpoch}'},
        ),
      ]);
      final tokens1 = await CaptainAuth(h.server.client()).refresh('refresh-0');
      final left = tokens1.accessTokenExpiresAt.difference(DateTime.now());
      expect(left.inMinutes, inInclusiveRange(14, 15));
    },
  );

  test('the clients wait longer than the server waits for the sender', () {
    // The identity module's SEND_ANSWER_TIMEOUT_MS is 10 seconds.
    expect(receiveTimeout, greaterThan(const Duration(seconds: 12)));
    final api = apiClient('https://api.example.test');
    expect(api.dio.options.receiveTimeout, receiveTimeout);
    expect(api.dio.interceptors.whereType<AuthInterceptor>(), isEmpty);
  });
}
