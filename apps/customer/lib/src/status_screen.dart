import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api.dart';

/// Unstyled until the design (the design stop in the root CLAUDE.md).
class StatusScreen extends ConsumerWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final status = ref.watch(statusProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.customerAppName)),
      body: Center(
        child: Text(switch (status) {
          AsyncData() => l10n.statusOk,
          AsyncError() => l10n.statusError,
          AsyncLoading() => l10n.statusLoading,
        }),
      ),
    );
  }
}
