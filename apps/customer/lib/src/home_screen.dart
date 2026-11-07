import 'package:core_auth/core_auth.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'api.dart';
import 'auth.dart';

/// Home until the restaurant list (slice 1.14d): the server status, and
/// sign-in or sign-out. Unstyled until the design (the design stop in the
/// root CLAUDE.md).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final status = ref.watch(statusProvider);
    final signedIn = ref.watch(customerAuth.session).value is SignedIn;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.customerAppName)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(switch (status) {
              AsyncData() => l10n.statusOk,
              AsyncError() => l10n.statusError,
              AsyncLoading() => l10n.statusLoading,
            }),
            if (signedIn) ...[
              Text(l10n.signedIn),
              TextButton(
                onPressed: () =>
                    ref.read(customerAuth.session.notifier).signOut(),
                child: Text(l10n.signOut),
              ),
            ] else
              FilledButton(
                onPressed: () => context.go('/sign-in'),
                child: Text(l10n.signInTitle),
              ),
          ],
        ),
      ),
    );
  }
}
