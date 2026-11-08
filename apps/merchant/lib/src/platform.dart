import 'package:core_platform/core_platform.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api.dart';
import 'device.dart';

/// The app's update and maintenance (RA §4.2, §4.10), kept current from the
/// app's start for its whole run (`packages/core_platform/CLAUDE.md`). Both
/// block every device of the restaurant, owner and cashier alike.
final platformCheckProvider = Provider<PlatformCheck>((ref) {
  final api = ref.watch(coreApiProvider).getMerchantApi();
  final check = PlatformCheck(() async {
    final version = await ref.read(appVersionProvider.future);
    // The version without its build number, as the server takes it.
    final plain = RegExp(r'^\d+\.\d+\.\d+').stringMatch(version) ?? version;
    final answer = await api.merchantPlatformGet(version: plain);
    return platformStatusOf(answer.data!);
  });
  ref.onDispose(check.dispose);
  check.start();
  return check;
});
