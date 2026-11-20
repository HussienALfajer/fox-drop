import 'dart:convert';

import 'package:core_api/core_api.dart';
import 'package:core_storage/core_storage.dart';
import 'package:core_time/core_time.dart';
import 'package:cryptography/cryptography.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../auth.dart';

/// The secure store's key of this PC's Ed25519 seed (32 bytes in base64):
/// its registration, kept until the app is removed.
const windowsKeyStoreKey = 'windows.signing_key';

/// What the PC signs for a code request; the server checks the same text
/// (`windows-devices.service.ts`, `codeRequestMessage`).
String codeRequestMessage(String deviceId, String signedAt) =>
    'fox-drop/merchant-code-request\n$deviceId\n$signedAt';

/// Why a pairing code was refused.
enum PairingRefusal { invalidCode, tooMany, terminated, failed }

/// RA §4.3, architecture §8.3.3 item 1 (slice 2.44): the restaurant app on
/// Windows has no App Check, so an owner's pairing code registers the PC's
/// own Ed25519 key once, and the key signs every code request.
class WindowsRegistration {
  WindowsRegistration({
    required this.store,
    required this.api,
    required this.deviceId,
    required this.clock,
  });

  final SecureStore store;

  /// The sign-in routes' client (no session).
  final CoreApi api;
  final Future<String> Function() deviceId;
  final ServerClock clock;
  final _ed25519 = Ed25519();

  Future<bool> registered() async =>
      await store.read(windowsKeyStoreKey) != null;

  /// Registers this PC with [code]; null once registered.
  Future<PairingRefusal?> register(String code) async {
    final keyPair = await _ed25519.newKeyPair();
    final seed = await keyPair.extractPrivateKeyBytes();
    final publicKey = await keyPair.extractPublicKey();
    final installation = await deviceId();
    try {
      await api.getMerchantApi().merchantAuthRegisterWindows(
        merchantWindowsRegistrationDto: MerchantWindowsRegistrationDto(
          (b) => b
            ..code = code
            ..deviceId = installation
            ..publicKey = base64.encode(publicKey.bytes),
        ),
      );
    } on DioException catch (error) {
      return switch (error.response?.statusCode) {
        400 => PairingRefusal.invalidCode,
        429 => PairingRefusal.tooMany,
        403 => PairingRefusal.terminated,
        _ => PairingRefusal.failed,
      };
    }
    await store.write(windowsKeyStoreKey, base64.encode(seed));
    return null;
  }

  /// The signature a code request carries, on the server's clock; null
  /// before the PC is registered.
  Future<MerchantCodeRequestDtoDeviceSignature?> sign(String deviceId) async {
    final seed = await store.read(windowsKeyStoreKey);
    if (seed == null) return null;
    final keyPair = await _ed25519.newKeyPairFromSeed(base64.decode(seed));
    final signedAt = DateTime.fromMillisecondsSinceEpoch(
      clock.now().millisecondsSinceEpoch,
      isUtc: true,
    );
    final signature = await _ed25519.sign(
      utf8.encode(codeRequestMessage(deviceId, signedAt.toIso8601String())),
      keyPair: keyPair,
    );
    return MerchantCodeRequestDtoDeviceSignature(
      (b) => b
        ..signedAt = signedAt
        ..signature = base64.encode(signature.bytes),
    );
  }
}

/// Whether this installation runs on Windows, where sign-in needs the PC's
/// registration first.
bool get onWindows => defaultTargetPlatform == TargetPlatform.windows;

final windowsRegistrationProvider = Provider<WindowsRegistration>(
  (ref) => WindowsRegistration(
    store: ref.watch(merchantAuth.store),
    api: ref.watch(authApiProvider),
    deviceId: () => ref.read(merchantAuth.session.notifier).deviceId(),
    clock: ref.watch(serverClockProvider),
  ),
);

/// True once this PC is registered, and always away from Windows.
final windowsRegisteredProvider = FutureProvider<bool>(
  (ref) async =>
      !onWindows || await ref.watch(windowsRegistrationProvider).registered(),
);
