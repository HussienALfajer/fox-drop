import 'dart:async';

import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../board/board.dart';
import '../device.dart';
import '../push.dart';
import '../router.dart';
import 'receiving.dart';

/// RA §4.5: the device check runs at the first sign-in on each device: once
/// the device is named, the check opens over the board, once per
/// installation (`deviceCheckDoneKey`, written when it opens). Not where the
/// platform has nothing to check (Windows until its slice). Watched by
/// `MerchantApp`.
final deviceCheckPromptProvider = Provider<void>((ref) {
  final router = ref.watch(routerProvider);
  final named = ref.watch(
    merchantSessionProvider.select((s) => s.value?.deviceNamed == true),
  );
  final readings = ref.watch(deviceReadingsProvider).value;
  if (!named || readings == null) return;
  var asked = false;
  Future<void> prompt() async {
    if (asked) return;
    final top = router.routerDelegate.currentConfiguration;
    if (top.isEmpty || top.last.matchedLocation != '/') return;
    asked = true;
    final done = await ref.read(deviceStoreProvider).read(deviceCheckDoneKey);
    if (done == 'true') return;
    unawaited(router.push('/device/check'));
  }

  void listener() => unawaited(prompt());
  router.routerDelegate.addListener(listener);
  ref.onDispose(() => router.routerDelegate.removeListener(listener));
  scheduleMicrotask(listener);
});

/// RA §4.7: the red bar on every screen while the restaurant's connection is
/// down: «لا يوجد اتصال بالإنترنت — لن تصلك الطلبات الجديدة حتى يعود
/// الاتصال». Its colour comes with the design.
class OfflineFrame extends ConsumerWidget {
  const OfflineFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offline = ref.watch(
      boardProvider.select((board) {
        final state = board.value;
        return state != null && !state.live;
      }),
    );
    if (!offline) return child;
    return Column(
      children: [
        Material(
          child: SafeArea(
            bottom: false,
            child: ListTile(
              key: const Key('offline'),
              title: Text(AppLocalizations.of(context).merchantOffline),
            ),
          ),
        ),
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: child,
          ),
        ),
      ],
    );
  }
}
