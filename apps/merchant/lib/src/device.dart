import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'api.dart';
import 'auth.dart';

/// The signed-in user's restaurant, role and whether this device has its name
/// (RA §5.2 item 5); null while signed out. Read again at every sign-in.
final merchantSessionProvider = FutureProvider<MerchantSessionDtoOutput?>((
  ref,
) async {
  final session = await ref.watch(merchantAuth.session.future);
  if (session is! SignedIn) return null;
  final response = await ref
      .watch(coreApiProvider)
      .getMerchantApi()
      .merchantAuthCurrent();
  return response.data;
});

/// The app's version, for the device record (RA §5.3).
final appVersionProvider = FutureProvider<String>(
  (ref) async => (await PackageInfo.fromPlatform()).version,
);

/// Names this device on its first sign-in (RA §5.2 item 5): «كاشير 1» or
/// «تابلت المطبخ». Returns false for an empty name.
Future<bool> nameDevice(WidgetRef ref, String name) async {
  final trimmed = name.trim();
  if (trimmed.isEmpty) return false;
  final appVersion = await ref.read(appVersionProvider.future);
  await ref
      .read(coreApiProvider)
      .getMerchantApi()
      .merchantAuthDevice(
        merchantDeviceDto: MerchantDeviceDto(
          (b) => b
            ..name = trimmed
            ..platform = devicePlatform()
            ..appVersion = appVersion,
        ),
      );
  ref.invalidate(merchantSessionProvider);
  return true;
}
