import 'dart:async';

import 'package:core_platform/core_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api.dart';
import 'board/alerts.dart';
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

/// The city's emergency stop (RA §8.17), for the session's restaurant: read
/// at sign-in, on each return to the foreground, and by
/// [platformBroadcastsProvider]. Null while signed out.
final emergencyStopProvider = Provider.autoDispose<EmergencyStopCheck?>((ref) {
  // The id only: a session read again (naming the device) keeps the check.
  final restaurantId = ref.watch(
    merchantSessionProvider.select((s) => s.value?.restaurantId),
  );
  if (restaurantId == null) return null;
  final api = ref.watch(coreApiProvider).getMerchantApi();
  final check = EmergencyStopCheck(() async {
    final answer = (await api.merchantEmergencyStopRead()).data!;
    return EmergencyStop(active: answer.active, startedAt: answer.startedAt);
  });
  // RA §8.17, §16 #34: every device chimes once when it starts or ends.
  final ringer = ref.watch(ringerProvider);
  final switches = check.switched.listen((_) => ringer.chime());
  ref.onDispose(() {
    unawaited(switches.cancel());
    check.dispose();
  });
  check.start();
  return check;
});

/// The platform broadcasts on `merchant:{restaurant_id}` (RA §18): the
/// channel connecting reads the platform and the stop again ("on every
/// reconnect", RA §4.2), `platform.emergency_stop` the stop and
/// `platform.app_changed` the platform. Watched by `MerchantApp`.
final platformBroadcastsProvider = Provider.autoDispose<void>((ref) {
  final restaurantId = ref.watch(
    merchantSessionProvider.select((s) => s.value?.restaurantId),
  );
  if (restaurantId == null) return;
  final following = followPlatformBroadcasts(
    ref.watch(realtimeTransportProvider).channel('merchant:$restaurantId'),
    stop: ref.watch(emergencyStopProvider),
    platform: ref.watch(platformCheckProvider),
  );
  ref.onDispose(() => unawaited(following.cancel()));
});

/// RA §8.17 "every screen": the stop's banner above a signed-in screen that
/// has no offline bar (the terms, naming the device). The board and the
/// detail place it after their offline bar (`BoardAlertsLayer`, RA §6.3);
/// signed out there is no stop to show.
class WithStopBanner extends ConsumerWidget {
  const WithStopBanner({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stop = ref.watch(emergencyStopProvider);
    return Column(
      children: [
        if (stop != null)
          Material(
            child: SafeArea(
              bottom: false,
              child: EmergencyStopBanner(check: stop),
            ),
          ),
        Expanded(child: child),
      ],
    );
  }
}
