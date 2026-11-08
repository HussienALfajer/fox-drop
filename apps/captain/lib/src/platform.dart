import 'dart:async';

import 'package:core_platform/core_platform.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api.dart';
import 'work/alerts.dart';
import 'work/commands.dart';
import 'work/work.dart';

/// The app's update and maintenance (CA §4.2, §4.8), kept current from the
/// app's start for its whole run (`packages/core_platform/CLAUDE.md`).
final platformCheckProvider = Provider<PlatformCheck>((ref) {
  final api = ref.watch(coreApiProvider).getCaptainApi();
  final check = PlatformCheck(() async {
    final version = plainVersion(await ref.read(appVersionProvider.future));
    final answer = await api.captainPlatformGet(version: version);
    return platformStatusOf(answer.data!);
  });
  ref.onDispose(check.dispose);
  check.start();
  return check;
});

/// Whether the captain's screens give way to the blocking screen. A current
/// order is always finished first (CA §4.2, §4.8). A required update leaves
/// an online captain their offers and applies the next time they go online
/// (CA §7.2); maintenance does the same, so an online captain keeps the
/// offers and the switch to go offline instead of staying online behind the
/// screen. [work] is null while signed out.
bool captainBlocked(PlatformStatus status, Work? work) =>
    status.blocks && work?.order == null && !(work?.online ?? false);

/// The city's emergency stop (CA §6.3 item 2): read at sign-in, on each
/// return to the foreground, and by [platformBroadcastsProvider]. Null while
/// signed out. Offers stop with it; a current order goes on.
final emergencyStopProvider = Provider.autoDispose<EmergencyStopCheck?>((ref) {
  final session = ref.watch(captainSessionProvider).value;
  if (session == null) return null;
  final api = ref.watch(coreApiProvider).getCaptainApi();
  final check = EmergencyStopCheck(() async {
    final answer = (await api.captainEmergencyStopRead()).data!;
    return EmergencyStop(active: answer.active, startedAt: answer.startedAt);
  });
  // CA §14 #31: a chime when it starts or ends.
  final ringer = ref.watch(ringerProvider);
  final switches = check.switched.listen((_) => ringer.chime());
  ref.onDispose(() {
    unawaited(switches.cancel());
    check.dispose();
  });
  check.start();
  return check;
});

/// The platform broadcasts on `captain:{captain_id}` (CA §15): the channel
/// connecting reads the platform and the stop again ("on every reconnect",
/// CA §4.2), `platform.emergency_stop` the stop and `platform.app_changed`
/// the platform. Watched by `CaptainApp`.
final platformBroadcastsProvider = Provider.autoDispose<void>((ref) {
  final session = ref.watch(captainSessionProvider).value;
  if (session == null) return;
  final following = followPlatformBroadcasts(
    ref
        .watch(realtimeTransportProvider)
        .channel('captain:${session.captainId}'),
    stop: ref.watch(emergencyStopProvider),
    platform: ref.watch(platformCheckProvider),
  );
  ref.onDispose(() => unawaited(following.cancel()));
});
