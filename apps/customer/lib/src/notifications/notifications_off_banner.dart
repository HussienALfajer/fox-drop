import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'permission.dart';

/// The order screen's banner when the customer refused notifications (CU
/// §4.4): a link to the phone's settings, gone once they are allowed there.
/// Unstyled until the design.
class NotificationsOffBanner extends ConsumerStatefulWidget {
  const NotificationsOffBanner({super.key});

  @override
  ConsumerState<NotificationsOffBanner> createState() =>
      _NotificationsOffBannerState();
}

class _NotificationsOffBannerState
    extends ConsumerState<NotificationsOffBanner> {
  // Back from the settings, the permission is read again.
  late final _lifecycle = AppLifecycleListener(
    onResume: () => ref.invalidate(notificationsOffProvider),
  );

  @override
  void initState() {
    super.initState();
    _lifecycle;
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(notificationsOffProvider).value != true) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context);
    return MaterialBanner(
      key: const Key('notifications-off'),
      content: Text(l10n.customerNotificationsOff),
      actions: [
        TextButton(
          onPressed: () =>
              ref.read(notificationPermissionProvider).openSettings(),
          child: Text(l10n.customerNotificationsOpenSettings),
        ),
      ],
    );
  }
}
