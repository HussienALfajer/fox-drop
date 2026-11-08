import 'package:core_platform/core_platform.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api.dart';
import 'device.dart';

/// The app's update and maintenance (CU §4.2, §4.7), kept current from the
/// app's start for its whole run (`packages/core_platform/CLAUDE.md`).
final platformCheckProvider = Provider<PlatformCheck>((ref) {
  final api = ref.watch(coreApiProvider).getCustomerApi();
  final check = PlatformCheck(() async {
    final answer = await api.customerPlatformGet(version: appVersion);
    return platformStatusOf(answer.data!);
  });
  ref.onDispose(check.dispose);
  check.start();
  return check;
});
