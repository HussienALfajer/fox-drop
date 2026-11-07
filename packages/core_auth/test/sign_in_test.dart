import 'package:core_auth/core_auth.dart';
import 'package:core_storage/core_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:core_auth/testing.dart';

final _now = DateTime.utc(2026, 11, 7, 12);
const _code = '/v1/captain/auth/code';
const _signIn = '/v1/captain/auth/sign-in';

class _Harness {
  _Harness({bool operations = true, AppCheckToken? appCheck}) {
    scope = AuthScope(
      party: (ref) => CaptainAuth(server.client()),
      offersOperationsCode: operations,
      clock: () => _now,
    );
    container = ProviderContainer(
      overrides: [
        scope.store.overrideWithValue(store),
        if (appCheck != null) scope.appCheck.overrideWithValue(appCheck),
      ],
      retry: (retryCount, error) => null,
    );
    // Keeps the auto-disposed controller alive between reads.
    container.listen(scope.signIn, (previous, next) {});
  }

  final server = FakeServer();
  final store = MemorySecureStore();
  late final AuthScope scope;
  late final ProviderContainer container;

  SignInController get controller => container.read(scope.signIn.notifier);

  SignInState get state => container.read(scope.signIn);
}

Map<String, Object?> _sent() => {
  'channel': 'whatsapp',
  'resendAfterSec': 60,
  'expiresAt': _now.add(const Duration(minutes: 5)).toIso8601String(),
};

void main() {
  test('refuses a number that is not a mobile, without a request', () async {
    final h = _Harness();
    addTearDown(h.container.dispose);
    await h.controller.requestCode('12345');
    expect(h.state.invalidPhone, isTrue);
    expect(h.server.requests, isEmpty);
  });

  test('sends the code, then signs in and starts the session', () async {
    final h = _Harness();
    addTearDown(h.container.dispose);
    h.server.on(_code, [FakeAnswer(200, _sent())]);
    h.server.on(_signIn, [
      FakeAnswer(200, {
        'accountId': '00000000-0000-4000-8000-000000000001',
        'captainId': '00000000-0000-4000-8000-000000000002',
        ...tokens('1', _now.add(const Duration(minutes: 15))),
      }),
    ]);
    await h.controller.requestCode('0944123456');
    expect(h.state.step, SignInStep.code);
    expect(h.state.phone, '+963944123456');
    expect(h.state.resendAt, _now.add(const Duration(seconds: 60)));
    final codeRequest = h.server.to(_code).single.data as Map;
    expect(codeRequest['phone'], '+963944123456');

    await h.controller.submitCode('123456');
    final signIn = h.server.to(_signIn).single.data as Map;
    expect(signIn['code'], '123456');
    expect(signIn['deviceId'], codeRequest['deviceId']);
    final session = await h.container.read(h.scope.session.future);
    expect(
      (session as SignedIn).accountId,
      '00000000-0000-4000-8000-000000000001',
    );
    expect(h.store.values['session'], contains('refresh-1'));
  });

  test('a wrong code shows the tries left and stays on the code', () async {
    final h = _Harness();
    addTearDown(h.container.dispose);
    h.server.on(_code, [FakeAnswer(200, _sent())]);
    h.server.on(_signIn, [
      const FakeAnswer(400, {'error': 'wrong_code', 'attemptsLeft': 3}),
    ]);
    await h.controller.requestCode('944123456');
    await h.controller.submitCode('000000');
    expect(h.state.step, SignInStep.code);
    expect(h.state.refusal?.error, 'wrong_code');
    expect(h.state.refusal?.attemptsLeft, 3);
  });

  test(
    'an open code, such as an emergency one, goes to the code step',
    () async {
      final h = _Harness();
      addTearDown(h.container.dispose);
      h.server.on(_code, [
        const FakeAnswer(
          429,
          {'error': 'resend_wait', 'retryAfterSec': 300},
          {'retry-after': '300'},
        ),
      ]);
      await h.controller.requestCode('0944123456');
      expect(h.state.step, SignInStep.code);
      expect(h.state.refusal, isNull);
      expect(h.state.resendAt, _now.add(const Duration(seconds: 300)));
    },
  );

  test(
    'no code can be sent: «لديّ رمز من العمليات» opens the code step',
    () async {
      final h = _Harness();
      addTearDown(h.container.dispose);
      h.server.on(_code, [
        const FakeAnswer(503, {'error': 'unavailable'}),
      ]);
      await h.controller.requestCode('0944123456');
      expect(h.state.step, SignInStep.phone);
      expect(h.state.unavailable, isTrue);
      h.controller.useOperationsCode();
      expect(h.state.step, SignInStep.code);
      expect(h.state.operationsCode, isTrue);
      expect(h.state.phone, '+963944123456');
    },
  );

  test('the customer app does not offer an operations code', () async {
    final h = _Harness(operations: false);
    addTearDown(h.container.dispose);
    h.server.on(_code, [
      const FakeAnswer(503, {'error': 'unavailable'}),
    ]);
    await h.controller.requestCode('0944123456');
    h.controller.useOperationsCode();
    expect(h.state.step, SignInStep.phone);
  });

  test(
    'a number without WhatsApp stays on the number with the refusal',
    () async {
      final h = _Harness();
      addTearDown(h.container.dispose);
      h.server.on(_code, [
        const FakeAnswer(400, {'error': 'not_on_whatsapp'}),
      ]);
      await h.controller.requestCode('0944123456');
      expect(h.state.step, SignInStep.phone);
      expect(h.state.refusal?.error, 'not_on_whatsapp');
    },
  );

  test('the code request carries the App Check token', () async {
    var asked = 0;
    final h = _Harness(
      appCheck: () async {
        asked++;
        return 'app-check-token';
      },
    );
    addTearDown(h.container.dispose);
    h.server.on(_code, [FakeAnswer(200, _sent())]);
    await h.controller.requestCode('0944123456');
    expect(asked, 1);
    expect(
      h.server.to(_code).single.headers['X-Firebase-AppCheck'],
      'app-check-token',
    );

    // Only the code request carries it.
    h.server.on(_signIn, [
      FakeAnswer(200, {
        'accountId': '00000000-0000-4000-8000-000000000001',
        'captainId': '00000000-0000-4000-8000-000000000002',
        ...tokens('1', _now.add(const Duration(minutes: 15))),
      }),
    ]);
    await h.controller.submitCode('123456');
    expect(
      h.server.to(_signIn).single.headers.containsKey('X-Firebase-AppCheck'),
      isFalse,
    );
    expect(asked, 1);
  });

  test('without a token the code request goes without the header', () async {
    final h = _Harness();
    addTearDown(h.container.dispose);
    h.server.on(_code, [FakeAnswer(200, _sent())]);
    await h.controller.requestCode('0944123456');
    expect(
      h.server.to(_code).single.headers.containsKey('X-Firebase-AppCheck'),
      isFalse,
    );
  });

  test('a refused App Check token shows the refusal at the number', () async {
    final h = _Harness(appCheck: () async => 'replayed');
    addTearDown(h.container.dispose);
    h.server.on(_code, [
      const FakeAnswer(403, {'error': 'app_check_failed'}),
    ]);
    await h.controller.requestCode('0944123456');
    expect(h.state.step, SignInStep.phone);
    expect(h.state.refusal?.error, 'app_check_failed');
  });
}
