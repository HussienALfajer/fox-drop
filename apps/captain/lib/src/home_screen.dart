import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api.dart';
import 'auth.dart';

/// The signed-in home until the captain's screens (slice 1.14g). Unstyled
/// until the design (the design stop in the root CLAUDE.md).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final status = ref.watch(statusProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.captainAppName)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.signedIn),
            Text(switch (status) {
              AsyncData() => l10n.statusOk,
              AsyncError() => l10n.statusError,
              AsyncLoading() => l10n.statusLoading,
            }),
            TextButton(
              onPressed: () => ref.read(captainAuth.session.notifier).signOut(),
              child: Text(l10n.signOut),
            ),
          ],
        ),
      ),
    );
  }
}
