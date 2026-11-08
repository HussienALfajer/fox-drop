import 'package:core_platform/core_platform.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api.dart';
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
