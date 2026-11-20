import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:core_auth/testing.dart';
import 'package:flutter_test/flutter_test.dart';

// Slice 2.44: the restaurant app on Windows signs its code requests, and a
// refused signature sends the PC to pairing.
void main() {
  const path = '/v1/merchant/auth/code';
  const deviceId = '0190f3a0-0000-7000-8000-0000000000aa';
  const phone = '+963912345678';

  MerchantAuth auth(FakeServer server, {required void Function() refused}) =>
      MerchantAuth(
        server.client(),
        platform: MerchantCodeRequestDtoPlatformEnum.windows,
        deviceSignature: (device, number) async =>
            MerchantCodeRequestDtoDeviceSignature(
              (b) => b
                ..signedAt = DateTime.utc(2026, 11, 20, 9)
                ..signature = '$device|$number',
            ),
        onAttestationRefused: () async => refused(),
      );

  test('sends the signature of the device and the number', () async {
    final server = FakeServer()
      ..on(path, [
        const FakeAnswer(200, {
          'channel': 'whatsapp',
          'resendAfterSec': 60,
          'expiresAt': '2026-11-20T09:05:00.000Z',
        }),
      ]);
    var refusals = 0;
    await auth(
      server,
      refused: () => refusals++,
    ).requestCode(phone: phone, deviceId: deviceId);
    final body = server.to(path).single.data as Map<String, Object?>;
    expect(body['deviceSignature'], {
      'signedAt': '2026-11-20T09:00:00.000Z',
      'signature': '$deviceId|$phone',
    });
    expect(refusals, 0);
  });

  test('pairs again when the server refuses the signature', () async {
    final server = FakeServer()
      ..on(path, [
        const FakeAnswer(403, {'error': 'app_check_failed'}),
        const FakeAnswer(403, {'error': 'not_registered'}),
      ]);
    var refusals = 0;
    final merchant = auth(server, refused: () => refusals++);
    await expectLater(
      merchant.requestCode(phone: phone, deviceId: deviceId),
      throwsA(isA<AuthRefusal>()),
    );
    expect(refusals, 1);
    await expectLater(
      merchant.requestCode(phone: phone, deviceId: deviceId),
      throwsA(isA<AuthRefusal>()),
    );
    expect(refusals, 1);
  });
}
