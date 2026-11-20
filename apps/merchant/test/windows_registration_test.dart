import 'dart:convert';

import 'package:core_auth/testing.dart';
import 'package:core_storage/core_storage.dart';
import 'package:core_time/core_time.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:merchant/src/windows/registration.dart';

// RA §4.3, architecture §8.3.3 item 1 (slice 2.44): the PC registers its key
// with the owner's code and signs its code requests with it.
void main() {
  const path = '/v1/merchant/auth/windows-registration';
  const deviceId = '0190f3a0-0000-7000-8000-0000000000aa';

  WindowsRegistration registration(FakeServer server, SecureStore store) =>
      WindowsRegistration(
        store: store,
        api: server.client(),
        deviceId: () async => deviceId,
        clock: ServerClock(deviceNow: () => DateTime.utc(2026, 11, 20, 9)),
      );

  test('keeps the key only once the server registered it', () async {
    final server = FakeServer()
      ..on(path, [
        const FakeAnswer(400, {'error': 'invalid_code'}),
        const FakeAnswer(429, {'error': 'too_many'}),
        const FakeAnswer(200, {'status': 'registered'}),
      ]);
    final store = MemorySecureStore();
    final pc = registration(server, store);
    expect(await pc.registered(), isFalse);
    expect(await pc.sign(deviceId), isNull);
    expect(await pc.register('12345678'), PairingRefusal.invalidCode);
    expect(await pc.register('12345678'), PairingRefusal.tooMany);
    expect(await pc.registered(), isFalse);
    expect(await pc.register('12345678'), isNull);
    expect(await pc.registered(), isTrue);
    final body = server.to(path).last.data as Map<String, Object?>;
    expect(body['code'], '12345678');
    expect(body['deviceId'], deviceId);
    expect(base64.decode(body['publicKey']! as String), hasLength(32));
  });

  test('signs the text the server checks with the registered key', () async {
    final server = FakeServer()
      ..on(path, [
        const FakeAnswer(200, {'status': 'registered'}),
      ]);
    final pc = registration(server, MemorySecureStore());
    await pc.register('12345678');
    final publicKey = base64.decode(
      (server.to(path).single.data as Map<String, Object?>)['publicKey']!
          as String,
    );

    final signature = (await pc.sign(deviceId))!;
    expect(signature.signedAt, DateTime.utc(2026, 11, 20, 9));
    final verified = await Ed25519().verify(
      utf8.encode(
        'fox-drop/merchant-code-request\n$deviceId\n2026-11-20T09:00:00.000Z',
      ),
      signature: Signature(
        base64.decode(signature.signature),
        publicKey: SimplePublicKey(publicKey, type: KeyPairType.ed25519),
      ),
    );
    expect(verified, isTrue);
  });
}
