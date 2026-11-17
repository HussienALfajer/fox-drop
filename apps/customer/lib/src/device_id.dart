import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// The device block (docs/domain/08; slice 2.25d, owner decision
/// 2026-11-18): the sign-in's device id survives a reinstall, so a blocked
/// customer cannot order again from the same phone with another number. On
/// Android, MainActivity's channel turns Android ID into a UUID; on iOS the
/// installation's id lives in the Keychain, which a reinstall keeps, so it
/// answers null there. Play Integrity's device recall and DeviceCheck come
/// with the Google Cloud project and the Apple developer account.
Future<String?> customerDeviceId() async {
  if (defaultTargetPlatform != TargetPlatform.android) return null;
  return const MethodChannel(
    'com.foxdrop.customer/device',
  ).invokeMethod<String>('deviceId');
}
