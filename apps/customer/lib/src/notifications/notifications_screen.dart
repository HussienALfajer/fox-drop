import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'notifications.dart';
import 'push.dart';

/// «الإشعارات» (CU §13, §14): the account's pushes of the last 30 days,
/// newest first; a tap opens its target. Unstyled until the design.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final notifications = ref.watch(notificationsProvider);
    Future<void> reload() => ref.refresh(notificationsProvider.future);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.customerNotificationsTitle)),
      body: switch (notifications) {
        AsyncData(value: final list) => RefreshIndicator(
          onRefresh: reload,
          child: ListView(
            // Pulling works on an empty list too.
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              if (list.isEmpty)
                ListTile(title: Text(l10n.customerNotificationsEmpty)),
              for (final n in list)
                ListTile(
                  key: Key('notification-${n.id}'),
                  title: Text(n.body),
                  subtitle: Text(
                    '${l10n.formatDate(n.at)} ${l10n.formatTime(n.at)}',
                  ),
                  onTap: switch (pushTargetPath(n.data.toMap())) {
                    final path? => () => context.push(path),
                    null => null,
                  },
                ),
            ],
          ),
        ),
        AsyncError() => Center(
          child: TextButton(
            onPressed: () => ref.invalidate(notificationsProvider),
            child: Text(l10n.customerTryAgain),
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
